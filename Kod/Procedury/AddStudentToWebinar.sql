CREATE PROCEDURE AddStudentToWebinar
    @StudentID INT,
    @WebinarID INT
AS
BEGIN
    BEGIN TRY
        -- Sprawdzenie, czy student istnieje
        IF NOT EXISTS (SELECT 1 FROM Students WHERE StudentID = @StudentID)
        BEGIN
            PRINT 'Błąd: Student nie istnieje.';
            RETURN;
        END

        -- Sprawdzenie, czy webinar istnieje
        IF NOT EXISTS (SELECT 1 FROM Webinars WHERE WebinarID = @WebinarID)
        BEGIN
            PRINT 'Błąd: Webinar nie istnieje.';
            RETURN;
        END

        -- Sprawdzenie, czy student może zapisać się na webinar
        IF dbo.CanEnrollWebinar(@StudentID, @WebinarID) = 0
        BEGIN
            PRINT 'Błąd: Student nie może zapisać się na webinar.';
            RETURN;
        END

        -- Dodanie studenta do webinaru
        INSERT INTO WebinarDetails (StudentID, WebinarID, TerminationDate)
        VALUES (@StudentID, @WebinarID, DATEADD(DAY, 30, GETDATE()));

        PRINT 'Student został pomyślnie dodany do webinaru.';
    END TRY
    BEGIN CATCH
        PRINT 'Wystąpił błąd: ' + ERROR_MESSAGE();
    END CATCH
END;
go

