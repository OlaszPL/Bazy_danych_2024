CREATE PROCEDURE AddSubject
    @StudiesID INT,
    @SubjectName NVARCHAR(30),
    @Description NVARCHAR(MAX),
    @LanguageID INT,
    @TeacherID INT,
    @TranslatorID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdź, czy istnieją studia o podanym StudiesID
    IF NOT EXISTS (SELECT 1 FROM Studies WHERE StudiesID = @StudiesID)
    BEGIN
        RAISERROR('Studia o podanym ID nie istnieją.', 16, 1);
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

    -- Wstaw nowy przedmiot do tabeli Subjects
    INSERT INTO Subjects (StudiesID, SubjectName, Description)
    VALUES (@StudiesID, @SubjectName, @Description);

    PRINT 'Przedmiot dodany pomyślnie.';
END;
go

grant execute on dbo.AddSubject to koordynator_przedmiotu
go

grant execute on dbo.AddSubject to koordynator_studiow
go

