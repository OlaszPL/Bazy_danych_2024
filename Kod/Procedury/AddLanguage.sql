CREATE   PROCEDURE AddLanguage
    @LanguageName NVARCHAR(30)
AS
BEGIN
    -- Sprawdź, czy język o podanej nazwie już istnieje
    IF EXISTS (SELECT 1 FROM Languages WHERE LanguageName = @LanguageName)
    BEGIN
        RAISERROR('Język o podanej nazwie już istnieje.', 16, 1);
        RETURN;
    END

    -- Wstaw nowy język do tabeli Languages
    INSERT INTO Languages (LanguageName)
    VALUES (@LanguageName);
END;
go

