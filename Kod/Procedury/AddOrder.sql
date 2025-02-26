CREATE PROCEDURE AddOrder
    @StudentID INT,
    @CurrencyID INT,
    @vatID INT,
    @PaymentLink NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdź, czy istnieje student o podanym StudentID
    IF NOT EXISTS (SELECT 1 FROM Students WHERE StudentID = @StudentID)
    BEGIN
        RAISERROR('Student o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END

    -- Wstaw nowe zamówienie do tabeli Orders
    DECLARE @OrderID INT;
    INSERT INTO Orders (StudentID, OrderDate, PaymentLink, CurrencyID, vatID)
    VALUES (@StudentID, GETDATE(), @PaymentLink, @CurrencyID, @vatID);

    SET @OrderID = SCOPE_IDENTITY();

    PRINT 'Zamówienie dodane pomyślnie.';
END;
go

grant execute on dbo.AddOrder to system
go

