CREATE PROCEDURE AddTranslatorLanguage
    @TranslatorID INT,
    @LanguageName NVARCHAR(30)
AS
BEGIN
    DECLARE @LanguageID INT;

    -- Pobranie ID języka na podstawie nazwy
    SELECT @LanguageID = LanguageID FROM Languages WHERE LanguageName = @LanguageName;

    -- Sprawdzenie, czy język istnieje
    IF @LanguageID IS NOT NULL
    BEGIN
        -- Sprawdzenie, czy tłumacz już zna ten język
        IF EXISTS (SELECT 1
                   FROM TranslatorLanguageDetails
                   WHERE TranslatorID = @TranslatorID AND LanguageID = @LanguageID)
        BEGIN
            PRINT 'The translator is already associated with this language.';
        END
        ELSE
        BEGIN
            -- Dodanie nowego powiązania
            INSERT INTO TranslatorLanguageDetails (TranslatorID, LanguageID)
            VALUES (@TranslatorID, @LanguageID);
            PRINT 'The translator has been successfully associated with the language.';
        END
    END
    ELSE
    BEGIN
        PRINT 'The specified language does not exist.';
    END;
END;
go

