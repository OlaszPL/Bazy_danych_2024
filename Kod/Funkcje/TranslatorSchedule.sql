CREATE FUNCTION TranslatorSchedule (@TranslatorID INT)
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
    WHERE am.TranslatorID = @TranslatorID

    UNION ALL

    SELECT
        'Module' AS EventType,
        cm.ModuleName AS EventName,
        cm.Date AS EventDate,
        cm.TeacherID,
        cm.TranslatorID,
        cm.LanguageID
    FROM CourseModules cm
    WHERE cm.TranslatorID = @TranslatorID

    UNION ALL

    SELECT
        'Webinar' AS EventType,
        w.WebinarName AS EventName,
        w.WebinarDate AS EventDate,
        w.TeacherID,
        w.TranslatorID,
        w.LanguageID
    FROM Webinars w
    WHERE w.TranslatorID = @TranslatorID

)
go

