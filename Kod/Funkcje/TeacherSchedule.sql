CREATE FUNCTION TeacherSchedule (@TeacherID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT
        'Meeting' AS EventType,
        am.MeetingName AS EventName,
        am.Date AS EventDate,
        am.TeacherID,
        am.TranslatorID,
        am.LanguageID
    FROM AcademicMeeting am
    WHERE am.TeacherID = @TeacherID

    UNION ALL

    SELECT
        'Module' AS EventType,
        cm.ModuleName AS EventName,
        cm.Date AS EventDate,
        cm.TeacherID,
        cm.TranslatorID,
        cm.LanguageID
    FROM CourseModules cm
    WHERE cm.TeacherID = @TeacherID

    UNION ALL

    SELECT
        'Webinar' AS EventType,
        w.WebinarName AS EventName,
        w.WebinarDate AS EventDate,
        w.TeacherID,
        w.TranslatorID,
        w.LanguageID
    FROM Webinars w
    WHERE w.TeacherID = @TeacherID

)
go

