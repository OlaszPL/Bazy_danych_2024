CREATE    FUNCTION CalculateOrderPrice(@OrderID INT)
RETURNS MONEY
AS
BEGIN
    DECLARE @TotalPrice MONEY = 0;
    DECLARE @CurrencyRate DECIMAL(18, 6)
    DECLARE @VATRate DECIMAL(4, 2);

    -- Get the currency rate for the order
    SELECT @CurrencyRate = CR.CurrencyRate
    FROM Orders O
    JOIN CurrenciesRate CR ON O.CurrencyID = CR.CurrencyID
    WHERE O.OrderID = @OrderID;

    -- Get the VAT rate for the order
    SELECT @VATRate = V.Rate
    FROM Orders O
    JOIN VAT V ON O.vatID = V.vatID
    WHERE O.OrderID = @OrderID;

    -- Calculate total prices for courses
    SELECT @TotalPrice = @TotalPrice + ISNULL(SUM(C.Price), 0)
    FROM OrderCourse OC
    JOIN Courses C ON OC.CourseID = C.CourseID
    WHERE OC.OrderContentID IN (
        SELECT OrderContentID FROM OrderContentDetails WHERE OrderID = @OrderID
    );

    -- Calculate total prices for webinars
    SELECT @TotalPrice = @TotalPrice + ISNULL(SUM(W.Price), 0)
    FROM OrderWebinar OW
    JOIN Webinars W ON OW.WebinarID = W.WebinarID
    WHERE OW.OrderContentID IN (
        SELECT OrderContentID FROM OrderContentDetails WHERE OrderID = @OrderID
    );

    -- Calculate total prices for academic meetings
    SELECT @TotalPrice = @TotalPrice + ISNULL(SUM(AM.UnitPrice), 0)
    FROM OrderAcademicMeeting OAM
    JOIN AcademicMeeting AM ON OAM.MeetingID = AM.MeetingID
    WHERE OAM.OrderContentID IN (
        SELECT OrderContentID FROM OrderContentDetails WHERE OrderID = @OrderID
    );

    -- Calculate total prices for studies
    SELECT @TotalPrice = @TotalPrice + ISNULL(SUM(S.Tuition), 0)
    FROM OrderStudies OS
    JOIN Studies S ON OS.StudiesID = S.StudiesID
    WHERE OS.OrderContentID IN (
        SELECT OrderContentID FROM OrderContentDetails WHERE OrderID = @OrderID
    );

    -- Add VAT and apply currency conversion
    SET @TotalPrice = @TotalPrice * (1 + @VATRate / 100) * @CurrencyRate;

    SET @TotalPrice = ROUND(@TotalPrice, 2);

    RETURN @TotalPrice;
END
go

