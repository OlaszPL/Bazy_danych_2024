CREATE PROCEDURE AddWebinar
    @WebinarName NVARCHAR(50),
    @Price MONEY,
    @TeacherID INT,
    @Link VARCHAR(100),
    @TranslatorID INT = NULL,
    @WebinarDate DATETIME,
    @LanguageID INT,
    @Description NVARCHAR(MAX)
AS
BEGIN
    BEGIN TRY
        -- Sprawdzenie, czy nauczyciel istnieje
        IF NOT EXISTS (SELECT 1 FROM Teachers WHERE TeacherID = @TeacherID)
        BEGIN
            PRINT 'Błąd: Nauczyciel nie istnieje.';
            RETURN;
        END

        -- Sprawdzenie, czy tłumacz jest dostępny (jeżeli podany)
        IF @TranslatorID IS NOT NULL
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM TranslatorLanguageDetails WHERE TranslatorID = @TranslatorID AND LanguageID = @LanguageID)
            BEGIN
                PRINT 'Błąd: Tłumacz nie jest dostępny dla podanego języka.';
                RETURN;
            END

            -- Sprawdzenie, czy tłumacz istnieje
            IF NOT EXISTS (SELECT 1 FROM Translators WHERE TranslatorID = @TranslatorID)
            BEGIN
                PRINT 'Błąd: Tłumacz nie istnieje.';
                RETURN;
            END
        END

        -- Sprawdzenie, czy link jest dodany
        IF @Link IS NULL OR @Link = ''
        BEGIN
            PRINT 'Błąd: Link jest wymagany.';
            RETURN;
        END

        -- Sprawdzenie, czy język istnieje
        IF NOT EXISTS (SELECT 1 FROM Languages WHERE LanguageID = @LanguageID)
        BEGIN
            PRINT 'Błąd: Język nie istnieje.';
            RETURN;
        END

        -- Wstawienie nowego webinaru
        INSERT INTO Webinars (WebinarName, Price, TeacherID, Link, TranslatorID, WebinarDate, LanguageID, Description)
        VALUES (@WebinarName, @Price, @TeacherID, @Link, @TranslatorID, @WebinarDate, @LanguageID, @Description);

        PRINT 'Webinar został pomyślnie dodany.';
    END TRY
    BEGIN CATCH
        PRINT 'Wystąpił błąd: ' + ERROR_MESSAGE();
    END CATCH
END;
go

grant execute on dbo.AddWebinar to koordynator_kursu
go

grant execute on dbo.AddWebinar to koordynator_przedmiotu
go

grant execute on dbo.AddWebinar to koordynator_studiow
go

grant execute on dbo.AddWebinar to nauczyciel
go

