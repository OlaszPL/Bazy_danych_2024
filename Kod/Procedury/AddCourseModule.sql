CREATE PROCEDURE AddCourseModule
    @CourseID INT,
    @ModuleName NVARCHAR(50),
    @Date DATETIME,
    @TeacherID INT,
    @LanguageID INT,
    @ModuleType NVARCHAR(50), -- 'Hybrid', 'Stationary', 'OnlineSync', 'OnlineAsync'
    @LocationID INT = NULL, -- Required for 'Stationary'
    @Link NVARCHAR(100) = NULL, -- Required for 'OnlineSync' and 'OnlineAsync'
    @TranslatorID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdź, czy istnieje kurs o podanym CourseID
    IF NOT EXISTS (SELECT 1 FROM Courses WHERE CourseID = @CourseID)
    BEGIN
        RAISERROR('Kurs o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END

    -- Sprawdź, czy istnieje nauczyciel o podanym TeacherID
    IF NOT EXISTS (SELECT 1 FROM Teachers WHERE TeacherID = @TeacherID)
    BEGIN
        RAISERROR('Nauczyciel o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END

    -- Sprawdź, czy istnieje język o podanym LanguageID
    IF NOT EXISTS (SELECT 1 FROM Languages WHERE LanguageID = @LanguageID)
    BEGIN
        RAISERROR('Język o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END

    -- Sprawdź dostępność tłumacza, jeśli TranslatorID jest podane
    IF @TranslatorID IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM Translators WHERE TranslatorID = @TranslatorID)
        BEGIN
            RAISERROR('Tłumacz o podanym ID nie istnieje.', 16, 1);
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM dbo.CheckTranslatorAvailabilityForLanguage(@LanguageID) WHERE HasTranslator = 'Yes')
        BEGIN
            RAISERROR('Tłumacz dla podanego języka nie jest dostępny.', 16, 1);
            RETURN;
        END
    END

    -- Wstaw nowy moduł do tabeli CourseModules
    DECLARE @ModuleID INT;
    INSERT INTO CourseModules (CourseID, ModuleName, Date, TeacherID, LanguageID, TranslatorID)
    VALUES (@CourseID, @ModuleName, @Date, @TeacherID, @LanguageID, @TranslatorID);

    SET @ModuleID = SCOPE_IDENTITY();

    -- Dodaj moduł do odpowiedniej tabeli w zależności od typu
    IF @ModuleType = 'Hybrid'
    BEGIN
        INSERT INTO HybridModules (HybridModuleID, ComponentModuleID)
        VALUES (@ModuleID, @ModuleID);
    END
    ELSE IF @ModuleType = 'Stationary'
    BEGIN
        IF @LocationID IS NULL
        BEGIN
            RAISERROR('LocationID jest wymagane dla modułu stacjonarnego.', 16, 1);
            RETURN;
        END
        INSERT INTO StationaryModule (ModuleID, LocationID)
        VALUES (@ModuleID, @LocationID);
    END
    ELSE IF @ModuleType = 'OnlineSync'
    BEGIN
        IF @Link IS NULL
        BEGIN
            RAISERROR('Link jest wymagany dla modułu online synchronicznego.', 16, 1);
            RETURN;
        END
        INSERT INTO OnlineSyncModule (ModuleID, Link)
        VALUES (@ModuleID, @Link);
    END
    ELSE IF @ModuleType = 'OnlineAsync'
    BEGIN
        IF @Link IS NULL
        BEGIN
            RAISERROR('Link jest wymagany dla modułu online asynchronicznego.', 16, 1);
            RETURN;
        END
        INSERT INTO OnlineAsyncModule (ModuleID, VideoLink)
        VALUES (@ModuleID, @Link);
    END
    ELSE
    BEGIN
        RAISERROR('Nieprawidłowy typ modułu.', 16, 1);
        RETURN;
    END

    PRINT 'Moduł dodany pomyślnie.';
END;
go

grant execute on dbo.AddCourseModule to koordynator_kursu
go

grant execute on dbo.AddCourseModule to koordynator_przedmiotu
go

grant execute on dbo.AddCourseModule to koordynator_studiow
go

