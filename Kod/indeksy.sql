-- Indeksy dla tabeli AcademicMeeting
CREATE INDEX idx_AcademicMeeting_SubjectID ON AcademicMeeting (SubjectID);
CREATE INDEX idx_AcademicMeeting_TeacherID ON AcademicMeeting (TeacherID);
CREATE INDEX idx_AcademicMeeting_TranslatorID ON AcademicMeeting (TranslatorID);
CREATE INDEX idx_AcademicMeeting_LanguageID ON AcademicMeeting (LanguageID);

-- Indeksy dla tabeli CourseModules
CREATE INDEX idx_CourseModules_CourseID ON CourseModules (CourseID);
CREATE INDEX idx_CourseModules_LanguageID ON CourseModules (LanguageID);
CREATE INDEX idx_CourseModules_TeacherID ON CourseModules (TeacherID);
CREATE INDEX idx_CourseModules_TranslatorID ON CourseModules (TranslatorID);

-- Indeksy dla tabeli CourseStudentDetails
CREATE INDEX idx_CourseStudentDetails_CourseID ON CourseStudentDetails (CourseID);
CREATE INDEX idx_CourseStudentDetails_StudentID ON CourseStudentDetails (StudentID);

-- Indeksy dla tabeli Orders
CREATE INDEX idx_Orders_StudentID ON Orders (StudentID);
CREATE INDEX idx_Orders_CurrencyID ON Orders (CurrencyID);
CREATE INDEX idx_Orders_vatID ON Orders (vatID);

-- Indeksy dla tabeli Payments
CREATE INDEX idx_Payments_OrderID ON Payments (OrderID);

-- Indeksy dla tabeli MeetingAttendance
CREATE INDEX idx_MeetingAttendance_MeetingID ON MeetingAttendance (MeetingID);
CREATE INDEX idx_MeetingAttendance_StudentID ON MeetingAttendance (StudentID);

-- Indeksy dla tabeli ModuleAttendance
CREATE INDEX idx_ModuleAttendance_ModuleID ON ModuleAttendance (ModuleID);
CREATE INDEX idx_ModuleAttendance_StudentID ON ModuleAttendance (StudentID);

-- Indeksy dla tabeli StudentInternshipDetails
CREATE INDEX idx_StudentInternshipDetails_InternshipID ON StudentInternshipDetails (InternshipID);
CREATE INDEX idx_StudentInternshipDetails_StudentID ON StudentInternshipDetails (StudentID);

-- Indeksy dla tabeli StudentStudiesDetails
CREATE INDEX idx_StudentStudiesDetails_StudentID ON StudentStudiesDetails (StudentID);
CREATE INDEX idx_StudentStudiesDetails_StudiesID ON StudentStudiesDetails (StudiesID);

-- Indeksy dla tabeli StudentSubjectDetails
CREATE INDEX idx_StudentSubjectDetails_StudentID ON StudentSubjectDetails (StudentID);
CREATE INDEX idx_StudentSubjectDetails_SubjectID ON StudentSubjectDetails (SubjectID);

-- Indeksy dla tabeli WebinarDetails
CREATE INDEX idx_WebinarDetails_StudentID ON WebinarDetails (StudentID);
CREATE INDEX idx_WebinarDetails_WebinarID ON WebinarDetails (WebinarID);

-- Indeksy dla tabeli Students
CREATE INDEX idx_Students_Email ON Students (Email);
CREATE INDEX idx_Students_PhoneNumber ON Students (PhoneNumber);

-- Indeksy dla tabeli Teachers
CREATE INDEX idx_Teachers_Email ON Teachers (Email);
CREATE INDEX idx_Teachers_PhoneNumber ON Teachers (PhoneNumber);

-- Indeksy dla tabeli Translators
CREATE INDEX idx_Translators_Email ON Translators (Email);
CREATE INDEX idx_Translators_PhoneNumber ON Translators (PhoneNumber);

-- Indeksy dla tabeli Subjects
CREATE INDEX idx_Subjects_StudiesID ON Subjects (StudiesID);

-- Indeksy dla tabeli Internships
CREATE INDEX idx_Internships_StudiesID ON Internships (StudiesID);

-- Indeksy dla tabeli OrderContentDetails
CREATE INDEX idx_OrderContentDetails_OrderID ON OrderContentDetails (OrderID);

-- Indeksy dla tabeli OrderWebinar
CREATE INDEX idx_OrderWebinar_WebinarID ON OrderWebinar (WebinarID);

-- Indeksy dla tabeli OrderCourse
CREATE INDEX idx_OrderCourse_CourseID ON OrderCourse (CourseID);

-- Indeksy dla tabeli OrderAcademicMeeting
CREATE INDEX idx_OrderAcademicMeeting_MeetingID ON OrderAcademicMeeting (MeetingID);

-- Indeksy dla tabeli OrderStudies
CREATE INDEX idx_OrderStudies_StudiesID ON OrderStudies (StudiesID);

-- Indeksy dla tabeli Webinars
CREATE INDEX idx_Webinars_TeacherID ON Webinars (TeacherID);
CREATE INDEX idx_Webinars_TranslatorID ON Webinars (TranslatorID);
CREATE INDEX idx_Webinars_LanguageID ON Webinars (LanguageID);

-- Indeksy dla tabeli Locations
CREATE INDEX idx_Locations_Address ON Locations (Address);

-- Indeksy dla tabeli CurrenciesRate
CREATE INDEX idx_CurrenciesRate_CurrencyName ON CurrenciesRate (CurrencyName);

-- Indeksy dla tabeli VAT
CREATE INDEX idx_VAT_Rate ON VAT (Rate);

-- Indeksy dla tabeli GradesList
CREATE INDEX idx_GradesList_Grade ON GradesList (Grade);

-- Indeksy dla tabeli Courses
CREATE INDEX idx_Courses_CourseName ON Courses (CourseName);

-- Indeksy dla tabeli Internships
CREATE INDEX idx_Internships_StartingDate ON Internships (StartingDate);

-- Indeksy dla tabeli Orders
CREATE INDEX idx_Orders_OrderDate ON Orders (OrderDate);
CREATE INDEX idx_Orders_FullyPaidDate ON Orders (FullyPaidDate);

-- Indeksy dla tabeli Payments
CREATE INDEX idx_Payments_PaymentDate ON Payments (PaymentDate);

-- Indeksy dla tabeli Students
CREATE INDEX idx_Students_LastName ON Students (LastName);

-- Indeksy dla tabeli Webinars
CREATE INDEX idx_Webinars_WebinarDate ON Webinars (WebinarDate);