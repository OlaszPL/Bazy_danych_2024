CREATE ROLE admin;
GRANT ALL PRIVILEGES ON dbo.u_jozwik TO admin;

CREATE ROLE dyrektor;
GRANT SELECT ON Debtors TO dyrektor;
GRANT SELECT ON FinancialReports TO dyrektor;
GRANT SELECT ON FutureEventsEnrollment TO dyrektor;
GRANT SELECT ON MeetingAttendanceView TO dyrektor;
GRANT SELECT ON ModuleAttendanceView TO dyrektor;
GRANT SELECT ON OverlappingEnrollments TO dyrektor;
GRANT SELECT ON PastEventsAttendance TO dyrektor;
GRANT SELECT ON View_Course_Diplomas TO dyrektor;
GRANT SELECT ON View_Study_Diplomas TO dyrektor;
GRANT SELECT ON StudentsSchedule TO dyrektor;
GRANT SELECT ON TranslatorsSchedule TO dyrektor;
GRANT SELECT ON TeachersSchedule TO dyrektor;

CREATE ROLE ksiegowy;
GRANT SELECT ON Debtors TO ksiegowy;
GRANT SELECT ON FinancialReports TO ksiegowy;
GRANT SELECT ON FutureEventsEnrollment TO ksiegowy;
GRANT SELECT ON MeetingAttendanceView TO ksiegowy;
GRANT SELECT ON ModuleAttendanceView TO ksiegowy;
GRANT SELECT ON OverlappingEnrollments TO ksiegowy;
GRANT SELECT ON PastEventsAttendance TO ksiegowy;
GRANT SELECT, INSERT, UPDATE, DELETE ON Orders TO ksiegowy;
GRANT SELECT, INSERT, UPDATE, DELETE ON Payments TO ksiegowy;
GRANT SELECT, INSERT, UPDATE, DELETE ON OrderContentDetails TO ksiegowy;
GRANT SELECT, INSERT, UPDATE, DELETE ON OrderCourse TO ksiegowy;
GRANT SELECT, INSERT, UPDATE, DELETE ON OrderStudies TO ksiegowy;
GRANT SELECT, INSERT, UPDATE, DELETE ON OrderWebinar TO ksiegowy;
GRANT SELECT, INSERT, UPDATE, DELETE ON OrderAcademicMeeting TO ksiegowy;

CREATE ROLE nauczyciel;
GRANT SELECT ON MeetingAttendance TO nauczyciel;
GRANT SELECT ON ModuleAttendance TO nauczyciel;
GRANT UPDATE (MeetingCompletion) ON MeetingAttendance TO nauczyciel;
GRANT UPDATE (ModuleCompletion) ON ModuleAttendance TO nauczyciel;
GRANT EXECUTE ON AddWebinar TO nauczyciel;
GRANT SELECT, UPDATE ON Webinars TO nauczyciel;
GRANT SELECT ON TeachersSchedule TO nauczyciel;
GRANT EXECUTE ON TeacherSchedule TO nauczyciel;

CREATE ROLE koordynator_kursu;
GRANT SELECT ON ModuleAttendanceView TO koordynator_kursu;
GRANT EXECUTE ON AddCourse TO koordynator_kursu;
GRANT EXECUTE ON AddCourseModule TO koordynator_kursu;
GRANT EXECUTE ON CheckCourseCapacity TO koordynator_kursu;
GRANT SELECT ON MeetingAttendance TO koordynator_kursu;
GRANT SELECT ON ModuleAttendance TO koordynator_kursu;
GRANT UPDATE (MeetingCompletion) ON MeetingAttendance TO koordynator_kursu;
GRANT UPDATE (ModuleCompletion) ON ModuleAttendance TO koordynator_kursu;
GRANT EXECUTE ON AddWebinar TO koordynator_kursu;
GRANT SELECT, UPDATE ON Webinars TO koordynator_kursu;
GRANT SELECT ON TeachersSchedule TO koordynator_kursu;
GRANT EXECUTE ON TeacherSchedule TO koordynator_kursu;

CREATE ROLE koordynator_przedmiotu;
GRANT SELECT ON MeetingAttendanceView TO koordynator_przedmiotu;
GRANT EXECUTE ON AddSubject TO koordynator_przedmiotu;
GRANT EXECUTE ON AddStudyMeeting TO koordynator_przedmiotu;
GRANT SELECT, INSERT, UPDATE, DELETE ON Subjects TO koordynator_przedmiotu;
GRANT SELECT, INSERT, UPDATE, DELETE ON AcademicMeeting TO koordynator_przedmiotu;
GRANT INSERT ON StationaryMeeting TO koordynator_przedmiotu;
GRANT INSERT ON OnlineAsyncMeeting TO koordynator_przedmiotu;
GRANT INSERT ON OnlineSyncMeeting TO koordynator_przedmiotu;
GRANT SELECT ON ModuleAttendanceView TO koordynator_przedmiotu;
GRANT EXECUTE ON AddCourse TO koordynator_przedmiotu;
GRANT EXECUTE ON AddCourseModule TO koordynator_przedmiotu;
GRANT EXECUTE ON CheckCourseCapacity TO koordynator_przedmiotu;
GRANT SELECT ON MeetingAttendance TO koordynator_przedmiotu;
GRANT SELECT ON ModuleAttendance TO koordynator_przedmiotu;
GRANT UPDATE (MeetingCompletion) ON MeetingAttendance TO koordynator_przedmiotu;
GRANT UPDATE (ModuleCompletion) ON ModuleAttendance TO koordynator_przedmiotu;
GRANT EXECUTE ON AddWebinar TO koordynator_przedmiotu;
GRANT SELECT, UPDATE ON Webinars TO koordynator_przedmiotu;
GRANT SELECT ON TeachersSchedule TO koordynator_przedmiotu;
GRANT EXECUTE ON TeacherSchedule TO koordynator_przedmiotu;

CREATE ROLE koordynator_studiow;
GRANT SELECT ON MeetingAttendanceView TO koordynator_studiow;
GRANT EXECUTE ON AddSubject TO koordynator_studiow;
GRANT EXECUTE ON AddStudyMeeting TO koordynator_studiow;
GRANT SELECT, INSERT, UPDATE, DELETE ON Subjects TO koordynator_studiow;
GRANT SELECT, INSERT, UPDATE, DELETE ON AcademicMeeting TO koordynator_studiow;
GRANT INSERT ON StationaryMeeting TO koordynator_studiow;
GRANT INSERT ON OnlineAsyncMeeting TO koordynator_studiow;
GRANT INSERT ON OnlineSyncMeeting TO koordynator_studiow;
GRANT EXECUTE ON AddStudy TO koordynator_studiow;
GRANT SELECT, INSERT, UPDATE, DELETE ON Studies TO koordynator_studiow;
GRANT SELECT, INSERT, UPDATE, DELETE ON Internships TO koordynator_studiow;
GRANT SELECT ON ModuleAttendanceView TO koordynator_studiow;
GRANT EXECUTE ON AddCourse TO koordynator_studiow;
GRANT EXECUTE ON AddCourseModule TO koordynator_studiow;
GRANT EXECUTE ON CheckCourseCapacity TO koordynator_studiow;
GRANT SELECT ON MeetingAttendance TO koordynator_studiow;
GRANT SELECT ON ModuleAttendance TO koordynator_studiow;
GRANT UPDATE (MeetingCompletion) ON MeetingAttendance TO koordynator_studiow;
GRANT UPDATE (ModuleCompletion) ON ModuleAttendance TO koordynator_studiow;
GRANT EXECUTE ON AddWebinar TO koordynator_studiow;
GRANT SELECT, UPDATE ON Webinars TO koordynator_studiow;
GRANT SELECT ON TeachersSchedule TO koordynator_studiow;
GRANT EXECUTE ON TeacherSchedule TO koordynator_studiow;

CREATE ROLE opiekun_praktyk;
GRANT EXECUTE ON AddInternship TO opiekun_praktyk;
GRANT SELECT, INSERT, UPDATE ON Internships TO opiekun_praktyk;
GRANT SELECT, INSERT, UPDATE ON StudentInternshipDetails TO opiekun_praktyk;

CREATE ROLE tlumacz;
GRANT SELECT ON Webinars TO tlumacz;
GRANT SELECT ON CourseModules TO tlumacz;
GRANT SELECT ON AcademicMeeting TO tlumacz;
GRANT SELECT ON TranslatorsSchedule TO tlumacz;
GRANT EXECUTE ON TranslatorSchedule TO tlumacz;

CREATE ROLE kadrowy;
GRANT EXECUTE ON AddStudent TO kadrowy;
GRANT EXECUTE ON AddTranslator TO kadrowy;
GRANT EXECUTE ON AddTeacher TO kadrowy;

CREATE ROLE system;
GRANT EXECUTE ON AddOrder TO system;
GRANT EXECUTE ON AddOrderContent TO system;

CREATE ROLE student;
GRANT SELECT ON FutureEventsEnrollment TO student;
GRANT EXECUTE ON CanEnrollInCourse TO student;
GRANT EXECUTE ON CanEnrollInStudies TO student;
GRANT EXECUTE ON CanEnrollWebinar TO student;
GRANT EXECUTE ON IsCourseCompleted TO student;
GRANT EXECUTE ON IsCourseModuleCompleted TO student;
GRANT EXECUTE ON IsMeetingCompleted TO student;
GRANT EXECUTE ON IsOrderPaid TO student;
GRANT SELECT ON StudentsSchedule TO student;
GRANT EXECUTE ON StudentSchedule TO student;