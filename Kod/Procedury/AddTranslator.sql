CREATE PROCEDURE AddTranslator
    @FirstName NVARCHAR(30),
    @LastName NVARCHAR(60),
    @Email VARCHAR(100),
    @PhoneNumber VARCHAR(15)
AS
BEGIN
    BEGIN TRY
        -- Wstawienie nowego tłumacza
        INSERT INTO Translators (FirstName, LastName, Email, PhoneNumber)
        VALUES (@FirstName, @LastName, @Email, @PhoneNumber);

        PRINT 'Translator successfully added.';
    END TRY
    BEGIN CATCH
        PRINT 'Error occurred: ' + ERROR_MESSAGE();
    END CATCH
END;
go

grant execute on dbo.AddTranslator to kadrowy
go

