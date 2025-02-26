-- Funkcja sprawdzająca dostępność miejsc dla studiów
CREATE    FUNCTION CheckStudiesCapacity (@StudiesID int)
RETURNS TABLE
AS
RETURN
(
    WITH StudiesStats AS (
        SELECT
            s.StudiesID,
            s.StudiesName,
            l.LocationID,
            COALESCE(l.MaxPeople, 999999) as RoomCapacity,
            COUNT(DISTINCT ssd.StudentID) as CurrentEnrollment,
            CASE
                WHEN l.LocationID IS NULL THEN 'Online'
                ELSE 'Stacjonarny/Hybrydowy'
            END as StudiesType
        FROM Studies s
        JOIN Subjects sub ON s.StudiesID = sub.StudiesID
        JOIN AcademicMeeting am ON sub.SubjectID = am.SubjectID
        LEFT JOIN StationaryMeeting sm ON am.MeetingID = sm.MeetingID
        LEFT JOIN Locations l ON sm.LocationID = l.LocationID
        LEFT JOIN StudentStudiesDetails ssd ON s.StudiesID = ssd.StudiesID
        WHERE s.StudiesID = @StudiesID
        GROUP BY s.StudiesID, s.StudiesName, l.LocationID, l.MaxPeople
    )
    SELECT
        StudiesID,
        StudiesName,
        StudiesType,
        CurrentEnrollment,
        CASE
            WHEN StudiesType = 'Online' THEN 'Bez limitu'
            ELSE CAST(RoomCapacity as varchar(10))
        END as RoomCapacity,
        CAST(
            CASE
                WHEN StudiesType = 'Online' THEN 1
                WHEN CurrentEnrollment >= RoomCapacity THEN 0
                ELSE 1
            END AS bit
        ) as HasAvailableSpots,
        CASE
            WHEN StudiesType = 'Online' THEN 999999
            ELSE RoomCapacity - CurrentEnrollment
        END as RemainingSpots
    FROM StudiesStats
)
go

