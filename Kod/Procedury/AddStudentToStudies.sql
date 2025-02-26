CREATE PROCEDURE AddStudentToStudies
    @StudentID INT,
    @StudiesID INT
AS
BEGIN
    BEGIN TRY
        -- Sprawdzenie, czy student istnieje
        IF NOT EXISTS (SELECT 1 FROM Students WHERE StudentID = @StudentID)
        BEGIN
            PRINT 'Błąd: Student nie istnieje.';
            RETURN;
        END

        -- Sprawdzenie, czy studia istnieją
        IF NOT EXISTS (SELECT 1 FROM Studies WHERE StudiesID = @StudiesID)
        BEGIN
            PRINT 'Błąd: Studia nie istnieją.';
            RETURN;
        END

        -- Sprawdzenie, czy student może zapisać się na studia
        IF NOT EXISTS (SELECT 1 FROM dbo.CanEnrollInStudies(@StudentID, @StudiesID) WHERE CanEnroll = 1)
        BEGIN
            PRINT 'Błąd: Student nie może zapisać się na studia.';
            RETURN;
        END

        -- Dodanie studenta do studiów
        INSERT INTO StudentStudiesDetails (StudentID, StudiesID, Grade)
        VALUES (@StudentID, @StudiesID, NULL);

        -- Dodanie studenta do wszystkich przedmiotów powiązanych z danym kierunkiem studiów
        INSERT INTO StudentSubjectDetails (StudentID, SubjectID)
        SELECT @StudentID, SubjectID
        FROM Subjects
        WHERE StudiesID = @StudiesID;

        PRINT 'Student został pomyślnie zapisany na studia i do powiązanych przedmiotów.';
    END TRY
    BEGIN CATCH
        PRINT 'Wystąpił błąd: ' + ERROR_MESSAGE();
    END CATCH
END;
go

