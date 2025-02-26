CREATE PROCEDURE UpdateHybridMeetingAttendance
    @StudentID INT,
    @HybridMeetingID INT
AS
BEGIN
    BEGIN TRY
        -- Sprawdzenie, czy student istnieje
        IF NOT EXISTS (SELECT 1 FROM Students WHERE StudentID = @StudentID)
        BEGIN
            PRINT 'Błąd: Student nie istnieje.';
            RETURN;
        END

        -- Sprawdzenie, czy spotkanie hybrydowe istnieje
        IF NOT EXISTS (SELECT 1 FROM HybridMeetings WHERE HybridMeetingID = @HybridMeetingID)
        BEGIN
            PRINT 'Błąd: Spotkanie hybrydowe nie istnieje.';
            RETURN;
        END

        -- Sprawdzenie, czy student jest zapisany na studia, którego dotyczy HybridMeetingID
        DECLARE @StudiesID INT;
        SELECT @StudiesID = StudiesID FROM Subjects WHERE SubjectID = (SELECT SubjectID FROM AcademicMeeting WHERE MeetingID = @HybridMeetingID);

        IF NOT EXISTS (SELECT 1 FROM StudentStudiesDetails WHERE StudentID = @StudentID AND StudiesID = @StudiesID)
        BEGIN
            PRINT 'Błąd: Student nie jest zapisany na studia związane ze spotkaniem hybrydowym.';
            RETURN;
        END

        -- Sprawdzenie obecności na wszystkich wymaganych spotkaniach komponentowych
        IF NOT EXISTS (
            SELECT 1
            FROM HybridMeetings hm
            JOIN AcademicMeeting am ON hm.ComponentMeetingID = am.MeetingID
            LEFT JOIN StationaryMeeting sm ON am.MeetingID = sm.MeetingID
            LEFT JOIN OnlineSyncMeeting osm ON am.MeetingID = osm.MeetingID
            LEFT JOIN MeetingAttendance ma ON am.MeetingID = ma.MeetingID AND ma.StudentID = @StudentID
            WHERE hm.HybridMeetingID = @HybridMeetingID
            AND (sm.MeetingID IS NOT NULL OR osm.MeetingID IS NOT NULL)
            AND (ma.MeetingCompletion IS NULL OR ma.MeetingCompletion = 0)
        )
        BEGIN
            -- Ustawienie obecności na spotkaniu hybrydowym
            IF EXISTS (SELECT 1 FROM MeetingAttendance WHERE StudentID = @StudentID AND MeetingID = @HybridMeetingID)
            BEGIN
                UPDATE MeetingAttendance
                SET MeetingCompletion = 1
                WHERE StudentID = @StudentID AND MeetingID = @HybridMeetingID;
            END
            ELSE
            BEGIN
                INSERT INTO MeetingAttendance (StudentID, MeetingID, MeetingCompletion)
                VALUES (@StudentID, @HybridMeetingID, 1);
            END

            PRINT 'Obecność na spotkaniu hybrydowym została pomyślnie ustawiona.';
        END
        ELSE
        BEGIN
            PRINT 'Student nie był obecny na wszystkich wymaganych spotkaniach komponentowych.';
        END
    END TRY
    BEGIN CATCH
        PRINT 'Wystąpił błąd: ' + ERROR_MESSAGE();
    END CATCH
END;
go

