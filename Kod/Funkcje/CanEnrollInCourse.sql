CREATE     FUNCTION CanEnrollInCourse
(
    @StudentID INT,
    @CourseID INT
)
RETURNS TABLE
AS
RETURN
(
    WITH CourseEnrollmentStatus AS (
        SELECT
            -- Check if student already enrolled
            CASE WHEN EXISTS (
                SELECT 1
                FROM CourseStudentDetails csd
                WHERE csd.StudentID = @StudentID
                AND csd.CourseID = @CourseID
            ) THEN 1 ELSE 0 END AS IsAlreadyEnrolled,

            -- Check if student has paid for the course
            CASE WHEN EXISTS (
                SELECT 1
                FROM Orders o
                JOIN OrderContentDetails ocd ON o.OrderID = ocd.OrderID
                JOIN OrderCourse oc ON ocd.OrderContentID = oc.OrderContentID
                WHERE o.StudentID = @StudentID
                AND oc.CourseID = @CourseID
                AND o.FullyPaidDate IS NOT NULL
            ) THEN 1 ELSE 0 END AS HasPaidForCourse,

            -- Check if there's space in stationary modules
            CASE WHEN NOT EXISTS (
                SELECT 1
                FROM CourseModules cm
                JOIN StationaryModule sm ON cm.ModuleID = sm.ModuleID
                JOIN Locations l ON sm.LocationID = l.LocationID
                WHERE cm.CourseID = @CourseID
                AND (
                    SELECT COUNT(*)
                    FROM ModuleAttendance ma
                    WHERE ma.ModuleID = cm.ModuleID
                ) >= l.MaxPeople
            ) THEN 1 ELSE 0 END AS HasAvailableSpace
    )
    SELECT
        @StudentID AS StudentID,
        @CourseID AS CourseID,
        c.CourseName,
        CASE
            WHEN IsAlreadyEnrolled = 1 THEN 'Already enrolled in this course'
            WHEN HasPaidForCourse = 0 THEN 'Course not purchased'
            WHEN HasAvailableSpace = 0 THEN 'No available space in stationary modules'
            ELSE 'Can enroll'
        END AS EnrollmentStatus,
        CASE
            WHEN IsAlreadyEnrolled = 0
            AND HasPaidForCourse = 1
            AND HasAvailableSpace = 1
            THEN 1
            ELSE 0
        END AS CanEnroll
    FROM CourseEnrollmentStatus ces
    CROSS JOIN Courses c
    WHERE c.CourseID = @CourseID
)
go

