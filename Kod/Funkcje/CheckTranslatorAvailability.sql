CREATE   FUNCTION CheckTranslatorAvailability()
RETURNS TABLE
AS
RETURN
(
    WITH LanguagesInUse AS (
        -- Languages from Academic Meetings
        SELECT DISTINCT 
            l.LanguageID,
            l.LanguageName
        FROM AcademicMeeting am
        JOIN Languages l ON am.LanguageID = l.LanguageID

        UNION

        -- Languages from Course Modules
        SELECT DISTINCT 
            l.LanguageID,
            l.LanguageName
        FROM CourseModules cm
        JOIN Languages l ON cm.LanguageID = l.LanguageID

        UNION

        -- Languages from Webinars
        SELECT DISTINCT 
            l.LanguageID,
            l.LanguageName
        FROM Webinars w
        JOIN Languages l ON w.LanguageID = l.LanguageID
    )
    SELECT 
        liu.LanguageID,
        liu.LanguageName,
        CASE 
            WHEN EXISTS (
                SELECT 1 
                FROM TranslatorLanguageDetails tld 
                WHERE tld.LanguageID = liu.LanguageID
            ) THEN 'Yes'
            ELSE 'No'
        END as HasTranslator,
        (
            SELECT COUNT(DISTINCT tld.TranslatorID)
            FROM TranslatorLanguageDetails tld
            WHERE tld.LanguageID = liu.LanguageID
        ) as TranslatorsCount,
        STUFF((
            SELECT ', ' + t.FirstName + ' ' + t.LastName
            FROM TranslatorLanguageDetails tld
            JOIN Translators t ON tld.TranslatorID = t.TranslatorID
            WHERE tld.LanguageID = liu.LanguageID
            FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 1, 2, '') as TranslatorsList
    FROM LanguagesInUse liu
)
go

