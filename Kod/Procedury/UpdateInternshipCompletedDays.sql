CREATE PROCEDURE UpdateInternshipCompletedDays
    @StudentID INT,
    @InternshipID INT,
    @AdditionalDays INT
AS
BEGIN
    BEGIN TRY
        -- Sprawdzenie, czy student istnieje
        IF NOT EXISTS (SELECT 1 FROM Students WHERE StudentID = @StudentID)
        BEGIN
            PRINT 'Błąd: Student nie istnieje.';
            RETURN;
        END

        -- Sprawdzenie, czy staż istnieje
        IF NOT EXISTS (SELECT 1 FROM Internships WHERE InternshipID = @InternshipID)
        BEGIN
            PRINT 'Błąd: Staż nie istnieje.';
            RETURN;
        END

        -- Sprawdzenie, czy student jest zapisany na studia związane ze stażem
        DECLARE @StudiesID INT;
        SELECT @StudiesID = StudiesID FROM Internships WHERE InternshipID = @InternshipID;

        IF NOT EXISTS (SELECT 1 FROM StudentStudiesDetails WHERE StudentID = @StudentID AND StudiesID = @StudiesID)
        BEGIN
            PRINT 'Błąd: Student nie jest zapisany na odpowiednie studia.';
            RETURN;
        END

        -- Sprawdzenie, czy student jest przypisany do stażu
        IF NOT EXISTS (SELECT 1 FROM StudentInternshipDetails WHERE StudentID = @StudentID AND InternshipID = @InternshipID)
        BEGIN
            -- Przypisanie studenta do stażu
            INSERT INTO StudentInternshipDetails (StudentID, InternshipID, CompletedDays)
            VALUES (@StudentID, @InternshipID, 0);
        END

        -- Aktualizacja liczby CompletedDays (tylko zwiększanie)
        UPDATE StudentInternshipDetails
        SET CompletedDays = CompletedDays + @AdditionalDays
        WHERE StudentID = @StudentID AND InternshipID = @InternshipID;

        PRINT 'Liczba CompletedDays została pomyślnie zaktualizowana.';
    END TRY
    BEGIN CATCH
        PRINT 'Wystąpił błąd: ' + ERROR_MESSAGE();
    END CATCH
END;
go

