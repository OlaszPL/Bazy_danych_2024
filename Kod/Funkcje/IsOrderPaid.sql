CREATE FUNCTION IsOrderPaid
(
    @OrderID INT
)
RETURNS BIT
AS
BEGIN
    DECLARE @TotalPrice DECIMAL(18, 2);
    DECLARE @TotalPaid DECIMAL(18, 2);

    -- Calculate the total price using the CalculateOrderPrice function
    SET @TotalPrice = dbo.CalculateOrderPrice(@OrderID);

    -- Retrieve payment details
    SELECT
        @TotalPaid = p.PaidAmount
    FROM Payments p
    WHERE p.OrderID = @OrderID;

    -- Return 1 if fully paid, otherwise 0
    RETURN CASE
                WHEN @TotalPaid >= @TotalPrice THEN 1
                ELSE 0
           END;
END
go

grant execute on dbo.IsOrderPaid to student
go

