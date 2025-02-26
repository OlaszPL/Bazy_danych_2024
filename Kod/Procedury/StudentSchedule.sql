CREATE FUNCTION StudentSchedule (@StudentID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT
        'Meeting' AS EventType,
        am.MeetingName AS EventName,
        am.Date AS EventDate,
        ma.StudentID,
        am.TeacherID,
        am.LanguageID
    FROM AcademicMeeting am
    JOIN MeetingAttendance ma ON am.MeetingID = ma.MeetingID
    WHERE ma.StudentID = @StudentID

    UNION ALL

    SELECT
        'Module' AS EventType,
        cm.ModuleName AS EventName,
        cm.Date AS EventDate,
        ma.StudentID,
        cm.TeacherID,
        cm.LanguageID
    FROM CourseModules cm
    JOIN ModuleAttendance ma ON cm.ModuleID = ma.ModuleID
    WHERE ma.StudentID = @StudentID

    UNION ALL

    SELECT
        'Webinar' AS EventType,
        w.WebinarName AS EventName,
        w.WebinarDate AS EventDate,
        wd.StudentID,
        w.TeacherID,
        w.LanguageID
    FROM Webinars w
    JOIN WebinarDetails wd ON w.WebinarID = wd.WebinarID
    WHERE wd.StudentID = @StudentID

)
go

