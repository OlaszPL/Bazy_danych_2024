CREATE   FUNCTION IsCourseCompleted
(
    @StudentID INT,
    @CourseID INT
)
RETURNS TABLE
AS
RETURN
(
    WITH ModuleCompletionStatus AS (
        -- Get all modules for the course and their completion status
        -- Exclude OnlineAsync modules
        SELECT
            cm.CourseID,
            cm.ModuleID,
            ISNULL(ma.ModuleCompletion, 0) AS ModuleCompleted
        FROM CourseModules cm
        LEFT JOIN ModuleAttendance ma ON cm.ModuleID = ma.ModuleID
            AND ma.StudentID = @StudentID
        WHERE cm.CourseID = @CourseID
        AND NOT EXISTS (
            SELECT 1
            FROM OnlineAsyncModule oam
            WHERE oam.ModuleID = cm.ModuleID
        )
    ),
    CourseStats AS (
        -- Calculate completion statistics
        SELECT
            @StudentID AS StudentID,
            @CourseID AS CourseID,
            COUNT(*) AS TotalModules,
            SUM(CASE WHEN ModuleCompleted = 1 THEN 1 ELSE 0 END) AS CompletedModules,
            CASE
                WHEN COUNT(*) = SUM(CASE WHEN ModuleCompleted = 1 THEN 1 ELSE 0 END)
                THEN 1
                ELSE 0
            END AS IsCompleted
        FROM ModuleCompletionStatus
    )
    SELECT
        cs.StudentID,
        cs.CourseID,
        c.CourseName,
        s.FirstName + ' ' + s.LastName AS StudentName,
        cs.TotalModules,
        cs.CompletedModules,
        CAST(ROUND(CAST(cs.CompletedModules AS FLOAT) / NULLIF(cs.TotalModules, 0) * 100, 2) AS DECIMAL(5,2)) AS CompletionPercentage,
        CASE
        WHEN CAST(ROUND(CAST(cs.CompletedModules AS FLOAT) / NULLIF(cs.TotalModules, 0) * 100, 2) AS DECIMAL(5,2)) >= 80 THEN 'Officially Completed'
        ELSE 'In Progress'
        END AS CourseStatus
    FROM CourseStats cs
    JOIN Courses c ON c.CourseID = cs.CourseID
    JOIN Students s ON s.StudentID = cs.StudentID
    LEFT JOIN CourseStudentDetails csd ON csd.CourseID = cs.CourseID
        AND csd.StudentID = cs.StudentID
)
go

