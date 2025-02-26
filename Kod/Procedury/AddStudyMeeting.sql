CREATE PROCEDURE AddStudyMeeting
    @SubjectID INT,
    @TeacherID INT,
    @MeetingName NVARCHAR(50),
    @UnitPrice MONEY = NULL,
    @Date DATETIME,
    @TranslatorID INT = NULL,
    @LanguageID INT,
    @MeetingType NVARCHAR(50), -- 'Stationary', 'OnlineSync', 'OnlineAsync'
    @LocationID INT = NULL, -- Required for 'Stationary'
    @Link NVARCHAR(100) = NULL -- Required for 'OnlineSync' and 'OnlineAsync'
AS
BEGIN
    SET NOCOUNT ON;

    -- Ustaw domyślną wartość dla UnitPrice, jeśli nie jest podana
    IF @UnitPrice IS NULL
    BEGIN
        SET @UnitPrice = 100;
    END

    -- Sprawdź, czy istnieje przedmiot o podanym SubjectID
    IF NOT EXISTS (SELECT 1 FROM Subjects WHERE SubjectID = @SubjectID)
    BEGIN
        RAISERROR('Przedmiot o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END

    -- Sprawdź, czy istnieje nauczyciel o podanym TeacherID
    IF NOT EXISTS (SELECT 1 FROM Teachers WHERE TeacherID = @TeacherID)
    BEGIN
        RAISERROR('Nauczyciel o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END

    -- Sprawdź dostępność tłumacza, jeśli TranslatorID i LanguageID są podane
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

    -- Wstaw nowe spotkanie do tabeli AcademicMeeting
    DECLARE @MeetingID INT;
    INSERT INTO AcademicMeeting (MeetingName, SubjectID, Date, TeacherID, TranslatorID, LanguageID, UnitPrice)
    VALUES (@MeetingName, @SubjectID, @Date, @TeacherID, @TranslatorID, @LanguageID, @UnitPrice);

    SET @MeetingID = SCOPE_IDENTITY();

    -- Dodaj spotkanie do odpowiedniej tabeli w zależności od typu
    IF @MeetingType = 'Stationary'
    BEGIN
        IF @LocationID IS NULL
        BEGIN
            RAISERROR('LocationID jest wymagane dla spotkania stacjonarnego.', 16, 1);
            RETURN;
        END
        INSERT INTO StationaryMeeting (MeetingID, LocationID)
        VALUES (@MeetingID, @LocationID);
    END
    ELSE IF @MeetingType = 'OnlineSync'
    BEGIN
        IF @Link IS NULL
        BEGIN
            RAISERROR('Link jest wymagany dla spotkania online synchronicznego.', 16, 1);
            RETURN;
        END
        INSERT INTO OnlineSyncMeeting (MeetingID, Link)
        VALUES (@MeetingID, @Link);
    END
    ELSE IF @MeetingType = 'OnlineAsync'
    BEGIN
        IF @Link IS NULL
        BEGIN
            RAISERROR('Link jest wymagany dla spotkania online asynchronicznego.', 16, 1);
            RETURN;
        END
        INSERT INTO OnlineAsyncMeeting (MeetingID, VideoLink)
        VALUES (@MeetingID, @Link);
    END
    ELSE
    BEGIN
        RAISERROR('Nieprawidłowy typ spotkania.', 16, 1);
        RETURN;
    END

    PRINT 'Spotkanie dodane pomyślnie.';
END;
go

grant execute on dbo.AddStudyMeeting to koordynator_przedmiotu
go

grant execute on dbo.AddStudyMeeting to koordynator_studiow
go

