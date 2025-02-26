CREATE PROCEDURE AddStudentToCourse
    @StudentID INT,
    @CourseID INT
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

        -- Sprawdzenie, czy student może zapisać się na kurs
        IF NOT EXISTS (SELECT 1 FROM dbo.CanEnrollInCourse(@StudentID, @CourseID) WHERE CanEnroll = 1)
        BEGIN
            PRINT 'Błąd: Student nie może zapisać się na kurs.';
            RETURN;
        END

        -- Dodanie studenta do kursu
        INSERT INTO CourseStudentDetails (StudentID, CourseID)
        VALUES (@StudentID, @CourseID);

        PRINT 'Student został pomyślnie dodany do kursu.';
    END TRY
    BEGIN CATCH
        PRINT 'Wystąpił błąd: ' + ERROR_MESSAGE();
    END CATCH
END;
go

