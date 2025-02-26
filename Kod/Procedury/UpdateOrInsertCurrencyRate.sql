CREATE PROCEDURE UpdateOrInsertCurrencyRate
    @CurrencyName NVARCHAR(15),
    @CurrencyRate DECIMAL(10,4)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM CurrenciesRate WHERE UPPER(CurrencyName) = UPPER(@CurrencyName))
    BEGIN
        -- Aktualizacja kursu dla istniejącej waluty
        UPDATE CurrenciesRate
        SET CurrencyRate = @CurrencyRate
        WHERE UPPER(CurrencyName) = UPPER(@CurrencyName);
    END
    ELSE
    BEGIN
        -- Dodanie nowej waluty z podanym kursem
        INSERT INTO CurrenciesRate (CurrencyName, CurrencyRate)
        VALUES (@CurrencyName, @CurrencyRate);
    END
END;
go

