CREATE PROCEDURE SetStudentAttendance
    @StudentID INT,
    @ModuleID INT,
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

        -- Sprawdzenie, czy moduł istnieje
        IF NOT EXISTS (SELECT 1 FROM CourseModules WHERE ModuleID = @ModuleID)
        BEGIN
            PRINT 'Błąd: Moduł nie istnieje.';
            RETURN;
        END

        -- Sprawdzenie, czy student jest zapisany na kurs, którego dotyczy ModuleID
        DECLARE @CourseID INT;
        SELECT @CourseID = CourseID FROM CourseModules WHERE ModuleID = @ModuleID;

        IF NOT EXISTS (SELECT 1 FROM CourseStudentDetails WHERE StudentID = @StudentID AND CourseID = @CourseID)
        BEGIN
            PRINT 'Błąd: Student nie jest zapisany na kurs związany z modułem.';
            RETURN;
        END

        -- Sprawdzenie, czy moduł jest typu StationaryModule, OnlineSyncModule lub HybridModule
        IF NOT EXISTS (
            SELECT 1 FROM StationaryModule WHERE ModuleID = @ModuleID
            UNION
            SELECT 1 FROM OnlineSyncModule WHERE ModuleID = @ModuleID
            UNION
            SELECT 1 FROM HybridModules WHERE HybridModuleID = @ModuleID
        )
        BEGIN
            PRINT 'Błąd: Obecność może być dodana tylko dla modułów typu StationaryModule, OnlineSyncModule lub HybridModule.';
            RETURN;
        END

        -- Dodanie lub aktualizacja obecności studenta
        IF EXISTS (SELECT 1 FROM ModuleAttendance WHERE StudentID = @StudentID AND ModuleID = @ModuleID)
        BEGIN
            UPDATE ModuleAttendance
            SET ModuleCompletion = @Attendance
            WHERE StudentID = @StudentID AND ModuleID = @ModuleID;
        END
        ELSE
        BEGIN
            INSERT INTO ModuleAttendance (StudentID, ModuleID, ModuleCompletion)
            VALUES (@StudentID, @ModuleID, @Attendance);
        END

        PRINT 'Obecność studenta została pomyślnie ustawiona.';
    END TRY
    BEGIN CATCH
        PRINT 'Wystąpił błąd: ' + ERROR_MESSAGE();
    END CATCH
END;
go

