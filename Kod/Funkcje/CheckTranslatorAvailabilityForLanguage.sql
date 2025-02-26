-- Function to check if specific language has translators
CREATE   FUNCTION CheckTranslatorAvailabilityForLanguage
(
    @LanguageID int
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        l.LanguageID,
        l.LanguageName,
        CASE 
            WHEN EXISTS (
                SELECT 1 
                FROM TranslatorLanguageDetails tld 
                WHERE tld.LanguageID = l.LanguageID
            ) THEN 'Yes'
            ELSE 'No'
        END as HasTranslator,
        (
            SELECT COUNT(DISTINCT tld.TranslatorID)
            FROM TranslatorLanguageDetails tld
            WHERE tld.LanguageID = l.LanguageID
        ) as TranslatorsCount,
        STUFF((
            SELECT ', ' + t.FirstName + ' ' + t.LastName
            FROM TranslatorLanguageDetails tld
            JOIN Translators t ON tld.TranslatorID = t.TranslatorID
            WHERE tld.LanguageID = l.LanguageID
            FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 1, 2, '') as TranslatorsList,
        (
            SELECT COUNT(*) 
            FROM (
                SELECT MeetingID 
                FROM AcademicMeeting 
                WHERE LanguageID = l.LanguageID
                UNION
                SELECT ModuleID 
                FROM CourseModules 
                WHERE LanguageID = l.LanguageID
                UNION
                SELECT WebinarID 
                FROM Webinars 
                WHERE LanguageID = l.LanguageID
            ) as Activities
        ) as ActivitiesCount
    FROM Languages l
    WHERE l.LanguageID = @LanguageID
)
go

