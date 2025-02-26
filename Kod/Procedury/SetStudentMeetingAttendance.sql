CREATE PROCEDURE SetStudentMeetingAttendance
    @StudentID INT,
    @MeetingID INT,
    @Attendance BIT
AS
BEGIN
    BEGIN TRY
        -- Sprawdzenie, czy student istnieje
        IF NOT EXISTS (SELECT 1 FROM Students WHERE StudentID = @StudentID)
        BEGIN
            PRINT 'Błąd: Student nie istnieje.';
            RETURN;
        END

        -- Sprawdzenie, czy spotkanie istnieje
        IF NOT EXISTS (SELECT 1 FROM AcademicMeeting WHERE MeetingID = @MeetingID)
        BEGIN
            PRINT 'Błąd: Spotkanie nie istnieje.';
            RETURN;
        END

        -- Sprawdzenie, czy student jest zapisany na studia, którego dotyczy MeetingID
        DECLARE @StudiesID INT;
        SELECT @StudiesID = StudiesID FROM Subjects WHERE SubjectID = (SELECT SubjectID FROM AcademicMeeting WHERE MeetingID = @MeetingID);

        IF NOT EXISTS (SELECT 1 FROM StudentStudiesDetails WHERE StudentID = @StudentID AND StudiesID = @StudiesID)
        BEGIN
            PRINT 'Błąd: Student nie jest zapisany na studia związane ze spotkaniem.';
            RETURN;
        END

        -- Sprawdzenie, czy spotkanie jest typu StationaryMeeting, OnlineSyncMeeting lub HybridMeeting
        IF NOT EXISTS (
            SELECT 1 FROM StationaryMeeting WHERE MeetingID = @MeetingID
            UNION
            SELECT 1 FROM OnlineSyncMeeting WHERE MeetingID = @MeetingID
            UNION
            SELECT 1 FROM HybridMeetings WHERE HybridMeetingID = @MeetingID
        )
        BEGIN
            PRINT 'Błąd: Obecność może być dodana tylko dla spotkań typu StationaryMeeting, OnlineSyncMeeting lub HybridMeeting.';
            RETURN;
        END

        -- Dodanie lub aktualizacja obecności studenta
        IF EXISTS (SELECT 1 FROM MeetingAttendance WHERE StudentID = @StudentID AND MeetingID = @MeetingID)
        BEGIN
            UPDATE MeetingAttendance
            SET MeetingCompletion = @Attendance
            WHERE StudentID = @StudentID AND MeetingID = @MeetingID;
        END
        ELSE
        BEGIN
            INSERT INTO MeetingAttendance (StudentID, MeetingID, MeetingCompletion)
            VALUES (@StudentID, @MeetingID, @Attendance);
        END

        PRINT 'Obecność studenta na spotkaniu została pomyślnie ustawiona.';
    END TRY
    BEGIN CATCH
        PRINT 'Wystąpił błąd: ' + ERROR_MESSAGE();
    END CATCH
END;
go

