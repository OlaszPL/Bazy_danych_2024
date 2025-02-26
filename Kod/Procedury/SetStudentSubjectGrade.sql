CREATE PROCEDURE SetStudentSubjectGrade
    @StudentID INT,
    @SubjectID INT,
    @Grade DECIMAL(2,1)
AS
BEGIN
    BEGIN TRY
        -- Sprawdzenie, czy student istnieje
        IF NOT EXISTS (SELECT 1 FROM Students WHERE StudentID = @StudentID)
        BEGIN
            PRINT 'Błąd: Student nie istnieje.';
            RETURN;
        END

        -- Sprawdzenie, czy przedmiot istnieje
        IF NOT EXISTS (SELECT 1 FROM Subjects WHERE SubjectID = @SubjectID)
        BEGIN
            PRINT 'Błąd: Przedmiot nie istnieje.';
            RETURN;
        END

        -- Sprawdzenie, czy para (student, przedmiot) istnieje w StudentSubjectDetails
        IF NOT EXISTS (SELECT 1 FROM StudentSubjectDetails WHERE StudentID = @StudentID AND SubjectID = @SubjectID)
        BEGIN
            PRINT 'Błąd: Student nie jest zapisany na ten przedmiot.';
            RETURN;
        END

        -- Sprawdzenie sumarycznej obecności studenta na wszystkich spotkaniach ze wszystkich przedmiotów ze studiów
        DECLARE @StudiesID INT;
        SELECT @StudiesID = StudiesID FROM Subjects WHERE SubjectID = @SubjectID;

        DECLARE @TotalMeetings INT;
        DECLARE @AttendedMeetings INT;

        SELECT @TotalMeetings = COUNT(*)
        FROM AcademicMeeting am
        JOIN Subjects s ON am.SubjectID = s.SubjectID
        WHERE s.StudiesID = @StudiesID
        AND EXISTS (
            SELECT 1 FROM StationaryMeeting sm WHERE sm.MeetingID = am.MeetingID
            UNION
            SELECT 1 FROM OnlineSyncMeeting osm WHERE osm.MeetingID = am.MeetingID
            UNION
            SELECT 1 FROM HybridMeetings hm WHERE hm.HybridMeetingID = am.MeetingID
        );

        SELECT @AttendedMeetings = COUNT(*)
        FROM MeetingAttendance ma
        JOIN AcademicMeeting am ON ma.MeetingID = am.MeetingID
        JOIN Subjects s ON am.SubjectID = s.SubjectID
        WHERE ma.StudentID = @StudentID
        AND s.StudiesID = @StudiesID
        AND ma.MeetingCompletion = 1
        AND EXISTS (
            SELECT 1 FROM StationaryMeeting sm WHERE sm.MeetingID = am.MeetingID
            UNION
            SELECT 1 FROM OnlineSyncMeeting osm WHERE osm.MeetingID = am.MeetingID
            UNION
            SELECT 1 FROM HybridMeetings hm WHERE hm.HybridMeetingID = am.MeetingID
        );

        DECLARE @AttendancePercentage DECIMAL(5,2);
        SET @AttendancePercentage = (CAST(@AttendedMeetings AS DECIMAL(5,2)) / @TotalMeetings) * 100;

        -- Jeśli obecność jest mniejsza niż 80%, nadpisz ocenę na 2.0
        IF @AttendancePercentage < 80
        BEGIN
            SET @Grade = 2.0;
        END

        -- Ustawienie oceny studenta za przedmiot
        UPDATE StudentSubjectDetails
        SET Grade = @Grade
        WHERE StudentID = @StudentID AND SubjectID = @SubjectID;

        PRINT 'Ocena studenta za przedmiot została pomyślnie ustawiona.';
    END TRY
    BEGIN CATCH
        PRINT 'Wystąpił błąd: ' + ERROR_MESSAGE();
    END CATCH
END;
go

