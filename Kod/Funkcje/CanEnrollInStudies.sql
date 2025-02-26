CREATE     FUNCTION CanEnrollInStudies
(
    @StudentID INT,
    @StudiesID INT
)
RETURNS TABLE
AS
RETURN
(
    WITH CurrentStudies AS (
        -- Check if already enrolled in these studies
        SELECT
            ssd.StudentID,
            ssd.StudiesID,
            s.StudiesName
        FROM StudentStudiesDetails ssd
        JOIN Studies s ON s.StudiesID = ssd.StudiesID
        WHERE ssd.StudentID = @StudentID
        AND ssd.StudiesID = @StudiesID
    ),
    EnrollmentFeeStatus AS (
        -- Check if student has paid the enrollment fee
        SELECT DISTINCT o.StudentID, o.FullyPaidDate
        FROM Orders o
        JOIN OrderContentDetails ocd ON o.OrderID = ocd.OrderID
        JOIN OrderStudies os ON os.OrderContentID = ocd.OrderContentID
        WHERE o.StudentID = @StudentID
        AND os.StudiesID = @StudiesID
    ),
    RequestedStudies AS (
        -- Get information about requested studies
        SELECT
            StudiesID,
            StudiesName,
            Tuition
        FROM Studies
        WHERE StudiesID = @StudiesID
    )
    SELECT
        @StudentID AS StudentID,
        @StudiesID AS StudiesID,
        rs.StudiesName AS RequestedStudiesName,
        CASE
            WHEN cs.StudentID IS NOT NULL
                THEN 'Cannot enroll - Already enrolled in these studies'
            WHEN efs.FullyPaidDate IS NULL
                THEN 'Cannot enroll - Enrollment fee not paid'
            ELSE 'Can enroll'
        END AS EnrollmentStatus,
        CAST(CASE
            WHEN cs.StudentID IS NULL
            AND efs.FullyPaidDate IS NOT NULL
            THEN 1
            ELSE 0
        END AS BIT) AS CanEnroll
    FROM RequestedStudies rs
    LEFT JOIN CurrentStudies cs ON 1=1
    LEFT JOIN EnrollmentFeeStatus efs ON 1=1
)
go

