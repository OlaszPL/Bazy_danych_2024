-- Funkcja sprawdzająca dostępność miejsc dla kursu
CREATE   FUNCTION CheckCourseCapacity (@CourseID int)
RETURNS TABLE
AS
RETURN
(
    WITH CourseStats AS (
        SELECT
            c.CourseID,
            c.CourseName,
            l.LocationID,
            COALESCE(l.MaxPeople, 999999) as RoomCapacity, -- Dla zajęć online dajemy bardzo dużą wartość
            COUNT(DISTINCT csd.StudentID) as CurrentEnrollment,
            CASE
                WHEN l.LocationID IS NULL THEN 'Online'
                ELSE 'Stacjonarny/Hybrydowy'
            END as CourseType
        FROM Courses c
        JOIN CourseModules cm ON c.CourseID = cm.CourseID
        LEFT JOIN StationaryModule sm ON cm.ModuleID = sm.ModuleID
        LEFT JOIN Locations l ON sm.LocationID = l.LocationID
        LEFT JOIN CourseStudentDetails csd ON c.CourseID = csd.CourseID
        WHERE c.CourseID = @CourseID
        GROUP BY c.CourseID, c.CourseName, l.LocationID, l.MaxPeople
    )
    SELECT
        CourseID,
        CourseName,
        CourseType,
        CurrentEnrollment,
        CASE
            WHEN CourseType = 'Online' THEN 'Bez limitu'
            ELSE CAST(RoomCapacity as varchar(10))
        END as RoomCapacity,
        CASE
            WHEN CourseType = 'Online' THEN 1
            WHEN CurrentEnrollment >= RoomCapacity THEN 0
            ELSE 1
        END as HasAvailableSpots,
        CASE
            WHEN CourseType = 'Online' THEN 999999
            ELSE RoomCapacity - CurrentEnrollment
        END as RemainingSpots
    FROM CourseStats
)
go

