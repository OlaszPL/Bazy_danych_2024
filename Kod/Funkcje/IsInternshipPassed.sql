CREATE   FUNCTION IsInternshipPassed
(
    @StudentID INT
)
RETURNS BIT
AS
BEGIN
    RETURN (
        CASE
            WHEN EXISTS (
                SELECT 1
                FROM StudentInternshipDetails
                WHERE StudentID = @StudentID AND CompletedDays < 14
            )
            THEN 0
            ELSE 1
        END
    );
END
go

