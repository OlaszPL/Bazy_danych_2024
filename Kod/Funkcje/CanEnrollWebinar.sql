CREATE FUNCTION CanEnrollWebinar(
    @StudentID INT,
    @WebinarID INT
)
RETURNS BIT
AS
BEGIN
    DECLARE @CanEnroll BIT = 0;

    -- Check if the webinar exists and get its price
    DECLARE @WebinarPrice MONEY;
    SELECT @WebinarPrice = Price
    FROM Webinars
    WHERE WebinarID = @WebinarID;

    -- If the webinar does not exist, return 0
    IF @WebinarPrice IS NULL
        RETURN 0;

    -- Check if the student is already enrolled in the webinar
    IF EXISTS (
        SELECT 1
        FROM WebinarDetails
        WHERE StudentID = @StudentID
        AND WebinarID = @WebinarID
    )
        RETURN 0;

    -- If the webinar is free, the student can enroll
    IF @WebinarPrice = 0
        RETURN 1;

    -- Check if the student has fully paid for an order that includes this webinar
    IF EXISTS (
        SELECT 1
        FROM Orders o
        INNER JOIN OrderWebinar ow ON o.OrderID = ow.OrderContentID
        WHERE ow.WebinarID = @WebinarID
        AND o.StudentID = @StudentID
        AND o.FullyPaidDate IS NOT NULL
    )
        SET @CanEnroll = 1;

    RETURN @CanEnroll;
END
go

grant execute on dbo.CanEnrollWebinar to student
go

