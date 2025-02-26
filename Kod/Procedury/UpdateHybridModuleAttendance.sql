CREATE PROCEDURE UpdateHybridModuleAttendance
    @StudentID INT,
    @HybridModuleID INT
AS
BEGIN
    BEGIN TRY
        -- Sprawdzenie, czy student istnieje
        IF NOT EXISTS (SELECT 1 FROM Students WHERE StudentID = @StudentID)
        BEGIN
            PRINT 'Błąd: Student nie istnieje.';
            RETURN;
        END

        -- Sprawdzenie, czy moduł hybrydowy istnieje
        IF NOT EXISTS (SELECT 1 FROM HybridModules WHERE HybridModuleID = @HybridModuleID)
        BEGIN
            PRINT 'Błąd: Moduł hybrydowy nie istnieje.';
            RETURN;
        END

        -- Sprawdzenie, czy student jest zapisany na kurs, którego dotyczy HybridModuleID
        DECLARE @CourseID INT;
        SELECT @CourseID = CourseID FROM CourseModules WHERE ModuleID = @HybridModuleID;

        IF NOT EXISTS (SELECT 1 FROM CourseStudentDetails WHERE StudentID = @StudentID AND CourseID = @CourseID)
        BEGIN
            PRINT 'Błąd: Student nie jest zapisany na kurs związany z modułem hybrydowym.';
            RETURN;
        END

        -- Sprawdzenie obecności na wszystkich wymaganych modułach komponentowych
        IF NOT EXISTS (
            SELECT 1
            FROM HybridModules hm
            JOIN CourseModules cm ON hm.ComponentModuleID = cm.ModuleID
            LEFT JOIN StationaryModule sm ON cm.ModuleID = sm.ModuleID
            LEFT JOIN OnlineSyncModule osm ON cm.ModuleID = osm.ModuleID
            LEFT JOIN ModuleAttendance ma ON cm.ModuleID = ma.ModuleID AND ma.StudentID = @StudentID
            WHERE hm.HybridModuleID = @HybridModuleID
            AND (sm.ModuleID IS NOT NULL OR osm.ModuleID IS NOT NULL)
            AND (ma.ModuleCompletion IS NULL OR ma.ModuleCompletion = 0)
        )
        BEGIN
            -- Ustawienie obecności na module hybrydowym
            IF EXISTS (SELECT 1 FROM ModuleAttendance WHERE StudentID = @StudentID AND ModuleID = @HybridModuleID)
            BEGIN
                UPDATE ModuleAttendance
                SET ModuleCompletion = 1
                WHERE StudentID = @StudentID AND ModuleID = @HybridModuleID;
            END
            ELSE
            BEGIN
                INSERT INTO ModuleAttendance (StudentID, ModuleID, ModuleCompletion)
                VALUES (@StudentID, @HybridModuleID, 1);
            END

            PRINT 'Obecność na module hybrydowym została pomyślnie ustawiona.';
        END
        ELSE
        BEGIN
            PRINT 'Student nie był obecny na wszystkich wymaganych modułach komponentowych.';
        END
    END TRY
    BEGIN CATCH
        PRINT 'Wystąpił błąd: ' + ERROR_MESSAGE();
    END CATCH
END;
go

