CREATE PROCEDURE SetCourseCompletion
    @StudentID INT,
    @CourseID INT,
    @Completed BIT
AS
BEGIN
    BEGIN TRY
        -- Sprawdzenie, czy student istnieje
        IF NOT EXISTS (SELECT 1 FROM Students WHERE StudentID = @StudentID)
        BEGIN
            PRINT 'Błąd: Student nie istnieje.';
            RETURN;
        END

        -- Sprawdzenie, czy kurs istnieje
        IF NOT EXISTS (SELECT 1 FROM Courses WHERE CourseID = @CourseID)
        BEGIN
            PRINT 'Błąd: Kurs nie istnieje.';
            RETURN;
        END

        -- Sprawdzenie, czy para (student, kurs) istnieje w CourseStudentDetails
        IF NOT EXISTS (SELECT 1 FROM CourseStudentDetails WHERE StudentID = @StudentID AND CourseID = @CourseID)
        BEGIN
            PRINT 'Błąd: Student nie jest zapisany na ten kurs.';
            RETURN;
        END

        -- Ustawienie obecności studenta na kursie
        UPDATE CourseStudentDetails
        SET Completed = @Completed
        WHERE StudentID = @StudentID AND CourseID = @CourseID;

        PRINT 'Obecność studenta na kursie została pomyślnie ustawiona.';
    END TRY
    BEGIN CATCH
        PRINT 'Wystąpił błąd: ' + ERROR_MESSAGE();
    END CATCH
END;
go

