CREATE PROCEDURE AddStudy
    @StudiesName NVARCHAR(30),
    @Syllabus NVARCHAR(MAX),
    @Tuition MONEY,
    @LanguageID INT,
    @TranslatorID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

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

    -- Wstaw nowe studia do tabeli Studies
    INSERT INTO Studies (StudiesName, Syllabus, Tuition)
    VALUES (@StudiesName, @Syllabus, @Tuition);

    PRINT 'Studia dodane pomyślnie.';
END;
go

grant execute on dbo.AddStudy to koordynator_studiow
go

