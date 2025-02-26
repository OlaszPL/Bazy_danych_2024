CREATE VIEW FinancialReports AS
SELECT
    'Webinar' AS EventType,
    W.WebinarName AS EventName,
    SUM(P.PaidAmount) AS TotalRevenue
FROM Webinars W
JOIN OrderWebinar OW ON W.WebinarID = OW.WebinarID
JOIN OrderContentDetails OCD ON OW.OrderContentID = OCD.OrderContentID
JOIN Payments P ON OCD.OrderID = P.OrderID
GROUP BY W.WebinarName
UNION ALL
SELECT
    'Course' AS EventType,
    C.CourseName AS EventName,
    SUM(P.PaidAmount) AS TotalRevenue
FROM Courses C
JOIN OrderCourse OC ON C.CourseID = OC.CourseID
JOIN OrderContentDetails OCD ON OC.OrderContentID = OCD.OrderContentID
JOIN Payments P ON OCD.OrderID = P.OrderID
GROUP BY C.CourseName
UNION ALL
SELECT
    'Studies' AS EventType,
    S.StudiesName AS EventName,
    SUM(P.PaidAmount) AS TotalRevenue
FROM Studies S
JOIN OrderStudies OS ON S.StudiesID = OS.StudiesID
JOIN OrderContentDetails OCD ON OS.OrderContentID = OCD.OrderContentID
JOIN Payments P ON OCD.OrderID = P.OrderID
GROUP BY S.StudiesName
UNION ALL
SELECT
    'Academic Meeting' AS EventType,
    AM.MeetingName AS EventName,
    SUM(P.PaidAmount) AS TotalRevenue
FROM AcademicMeeting AM
JOIN OrderAcademicMeeting OAM ON AM.MeetingID = OAM.MeetingID
JOIN OrderContentDetails OCD ON OAM.OrderContentID = OCD.OrderContentID
JOIN Payments P ON OCD.OrderID = P.OrderID
GROUP BY AM.MeetingName;


CREATE VIEW Debtors AS
SELECT DISTINCT
    S.StudentID,
    S.FirstName,
    S.LastName,
    O.OrderID,
    O.OrderDate
FROM Students S
JOIN Orders O ON S.StudentID = O.StudentID
WHERE O.FullyPaidDate IS NULL;


CREATE VIEW FutureEventsEnrollment AS
SELECT
    'Webinar' AS EventType,
    W.WebinarName AS EventName,
    W.WebinarDate AS EventDate,
    'Online' AS EventMode,
    COUNT(DISTINCT WD.StudentID) AS EnrolledCount
FROM Webinars W
JOIN WebinarDetails WD ON W.WebinarID = WD.WebinarID
WHERE W.WebinarDate > GETDATE()
GROUP BY W.WebinarName, W.WebinarDate
UNION ALL
SELECT
    'Course' AS EventType,
    C.CourseName AS EventName,
    M.Date AS EventDate,
    CASE WHEN SM.LocationID IS NOT NULL THEN 'Stationary' ELSE 'Online' END AS EventMode,
    COUNT(DISTINCT MAD.StudentID) AS EnrolledCount
FROM Courses C
JOIN CourseModules M ON C.CourseID = M.CourseID
LEFT JOIN StationaryModule SM ON M.ModuleID = SM.ModuleID
LEFT JOIN ModuleAttendance MAD ON M.ModuleID = MAD.ModuleID
WHERE M.Date > GETDATE()
GROUP BY C.CourseName, M.Date, SM.LocationID;


CREATE VIEW PastEventsAttendance AS
SELECT
    'Webinar' AS EventType,
    W.WebinarName AS EventName,
    W.WebinarDate AS EventDate,
    COUNT(DISTINCT WD.StudentID) AS TotalParticipants,
    SUM(CASE WHEN WD.TerminationDate IS NOT NULL THEN 1 ELSE 0 END) AS AttendedCount
FROM Webinars W
JOIN WebinarDetails WD ON W.WebinarID = WD.WebinarID
WHERE W.WebinarDate <= GETDATE()
GROUP BY W.WebinarName, W.WebinarDate
UNION ALL
SELECT
    'Course' AS EventType,
    C.CourseName AS EventName,
    M.Date AS EventDate,
    COUNT(DISTINCT MAD.StudentID) AS TotalParticipants,
    SUM(CASE WHEN MAD.ModuleCompletion = 1 THEN 1 ELSE 0 END) AS AttendedCount
FROM Courses C
JOIN CourseModules M ON C.CourseID = M.CourseID
LEFT JOIN ModuleAttendance MAD ON M.ModuleID = MAD.ModuleID
WHERE M.Date <= GETDATE()
GROUP BY C.CourseName, M.Date;


CREATE VIEW AttendanceList AS
SELECT
    M.ModuleID,
    M.Date AS EventDate,
    S.FirstName,
    S.LastName,
    CASE WHEN MA.ModuleCompletion = 1 THEN 'Present' ELSE 'Absent' END AS AttendanceStatus
FROM CourseModules M
JOIN ModuleAttendance MA ON M.ModuleID = MA.ModuleID
JOIN Students S ON MA.StudentID = S.StudentID;



CREATE VIEW OverlappingEnrollments AS
SELECT
    S.StudentID,
    S.FirstName,
    S.LastName,
    COUNT(DISTINCT M1.ModuleID) AS OverlappingCount
FROM Students S
JOIN ModuleAttendance MA1 ON S.StudentID = MA1.StudentID
JOIN CourseModules M1 ON MA1.ModuleID = M1.ModuleID
JOIN ModuleAttendance MA2 ON S.StudentID = MA2.StudentID
JOIN CourseModules M2 ON MA2.ModuleID = M2.ModuleID
WHERE M1.Date = M2.Date AND M1.ModuleID <> M2.ModuleID
GROUP BY S.StudentID, S.FirstName, S.LastName
HAVING COUNT(DISTINCT M1.ModuleID) > 1;

CREATE VIEW View_Course_Diplomas AS
SELECT 
    s.StudentID,
    s.FirstName,
    s.LastName,
    s.Address AS CorrespondenceAddress,
    c.CourseName AS DiplomaType
FROM 
    Students s
JOIN 
    CourseStudentDetails csd ON s.StudentID = csd.StudentID
JOIN 
    Courses c ON csd.CourseID = c.CourseID
JOIN 
    ModuleAttendance cm ON cm.StudentID = s.StudentID
WHERE 
    cm.ModuleCompletion = 1;


CREATE VIEW View_Study_Diplomas AS
SELECT 
    s.StudentID,
    s.FirstName,
    s.LastName,
    s.Address AS CorrespondenceAddress,
    st.StudiesName AS DiplomaType,
    ss.Grade AS FinalGrade
FROM 
    Students s
JOIN 
    StudentStudiesDetails ss ON s.StudentID = ss.StudentID
JOIN 
    Studies st ON ss.StudiesID = st.StudiesID
WHERE 
    ss.Grade IS NOT NULL;

CREATE VIEW ModuleAttendanceView AS
SELECT
    ma.ModuleID,
    m.ModuleName,
    ma.StudentID,
    s.FirstName AS StudentFirstName,
    s.LastName AS StudentLastName,
    ma.ModuleCompletion,
    CASE
        WHEN sm.LocationID IS NOT NULL THEN 'Stationary'
        WHEN osm.Link IS NOT NULL THEN 'OnlineSync'
        ELSE 'Unknown'
    END AS ModuleType
FROM ModuleAttendance ma
JOIN Students s ON ma.StudentID = s.StudentID
JOIN CourseModules m ON ma.ModuleID = m.ModuleID
LEFT JOIN StationaryModule sm ON ma.ModuleID = sm.ModuleID
LEFT JOIN OnlineSyncModule osm ON ma.ModuleID = osm.ModuleID
WHERE sm.LocationID IS NOT NULL OR osm.Link IS NOT NULL;

CREATE VIEW MeetingAttendanceView AS
SELECT 
    ma.MeetingID,
    am.MeetingName,
    ma.StudentID,
    s.FirstName AS StudentFirstName,
    s.LastName AS StudentLastName,
    ma.MeetingCompletion,
    CASE 
        WHEN sm.LocationID IS NOT NULL THEN 'Stationary'
        WHEN osm.Link IS NOT NULL THEN 'OnlineSync'
        ELSE 'Unknown'
    END AS MeetingType
FROM MeetingAttendance ma
JOIN Students s ON ma.StudentID = s.StudentID
JOIN AcademicMeeting am ON ma.MeetingID = am.MeetingID
LEFT JOIN StationaryMeeting sm ON ma.MeetingID = sm.MeetingID
LEFT JOIN OnlineSyncMeeting osm ON ma.MeetingID = osm.MeetingID
WHERE sm.LocationID IS NOT NULL OR osm.Link IS NOT NULL;

CREATE VIEW TranslatorSchedule AS
SELECT
    'Meeting' AS EventType,
    am.MeetingName AS EventName,
    am.Date AS EventDate,
    am.TeacherID,
    am.TranslatorID,
    am.LanguageID
FROM AcademicMeeting am
WHERE am.TranslatorID IS NOT NULL

UNION ALL

SELECT
    'Module' AS EventType,
    cm.ModuleName AS EventName,
    cm.Date AS EventDate,
    cm.TeacherID,
    cm.TranslatorID,
    cm.LanguageID
FROM CourseModules cm
WHERE cm.TranslatorID IS NOT NULL

UNION ALL

SELECT
    'Webinar' AS EventType,
    w.WebinarName AS EventName,
    w.WebinarDate AS EventDate,
    w.TeacherID,
    w.TranslatorID,
    w.LanguageID
FROM Webinars w
WHERE w.TranslatorID IS NOT NULL;

--------------------------------------------------

CREATE VIEW StudentSchedule AS
SELECT
    'Meeting' AS EventType,
    am.MeetingName AS EventName,
    am.Date AS EventDate,
    ma.StudentID,
    am.TeacherID,
    am.LanguageID
FROM AcademicMeeting am
JOIN MeetingAttendance ma ON am.MeetingID = ma.MeetingID

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

UNION ALL

SELECT
    'Webinar' AS EventType,
    w.WebinarName AS EventName,
    w.WebinarDate AS EventDate,
    wd.StudentID,
    w.TeacherID,
    w.LanguageID
FROM Webinars w
JOIN WebinarDetails wd ON w.WebinarID = wd.WebinarID;


--------------------------------------------------

CREATE VIEW TeacherSchedule AS
SELECT
    'Meeting' AS EventType,
    am.MeetingName AS EventName,
    am.Date AS EventDate,
    am.TeacherID,
    am.TranslatorID,
    am.LanguageID
FROM AcademicMeeting am
WHERE am.TeacherID IS NOT NULL

UNION ALL

SELECT
    'Module' AS EventType,
    cm.ModuleName AS EventName,
    cm.Date AS EventDate,
    cm.TeacherID,
    cm.TranslatorID,
    cm.LanguageID
FROM CourseModules cm
WHERE cm.TeacherID IS NOT NULL

UNION ALL

SELECT
    'Webinar' AS EventType,
    w.WebinarName AS EventName,
    w.WebinarDate AS EventDate,
    w.TeacherID,
    w.TranslatorID,
    w.LanguageID
FROM Webinars w
WHERE w.TeacherID IS NOT NULL;


