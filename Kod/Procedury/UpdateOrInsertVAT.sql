CREATE PROCEDURE UpdateOrInsertVAT
    @vatID INT = NULL,
    @Rate DECIMAL(4,2)
AS
BEGIN
    IF @vatID IS NULL
    BEGIN
        -- Wstawienie nowej stawki VAT
        INSERT INTO VAT (Rate)
        VALUES (@Rate);
    END
    ELSE
    BEGIN
        -- Aktualizacja istniejącej stawki VAT
        UPDATE VAT
        SET Rate = @Rate
        WHERE vatID = @vatID;
    END
END;
go

