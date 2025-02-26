CREATE   FUNCTION IsCourseModuleCompleted
(
    @StudentID INT,
    @ModuleID INT
)
RETURNS BIT
AS
BEGIN
    DECLARE @CourseModuleCompletion BIT;
    DECLARE @IsStudentAssigned BIT;

    -- Get module completion status and check if student is assigned
    SELECT
        @CourseModuleCompletion = ma.ModuleCompletion,
        @IsStudentAssigned = CASE
            WHEN EXISTS (
                SELECT 1
                FROM CourseStudentDetails csd
                JOIN CourseModules cm ON cm.CourseID = csd.CourseID
                WHERE csd.StudentID = @StudentID
                AND cm.ModuleID = @ModuleID
            ) THEN 1
            ELSE 0
        END
    FROM ModuleAttendance ma
    WHERE ma.StudentID = @StudentId
    AND ma.ModuleID = @ModuleID;

    -- Return 1 only if student is both assigned and has completed the module
    RETURN CASE
        WHEN @CourseModuleCompletion = 1 AND @IsStudentAssigned = 1 THEN 1
        ELSE 0
    END;
END
go

grant execute on dbo.IsCourseModuleCompleted to student
go

