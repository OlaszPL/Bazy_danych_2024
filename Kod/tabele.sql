-- tables
-- Table: AcademicMeeting
CREATE TABLE AcademicMeeting (
    MeetingID int  NOT NULL IDENTITY,
    MeetingName nvarchar(50)  NOT NULL,
    SubjectID int  NOT NULL,
    Date datetime  NOT NULL,
    TeacherID int  NOT NULL,
    TranslatorID int  NULL,
    LanguageID int  NOT NULL,
    UnitPrice money  NOT NULL CHECK (UnitPrice > 0),
    CONSTRAINT AcademicMeeting_pk PRIMARY KEY  (MeetingID)
);

-- Table: CourseModules
CREATE TABLE CourseModules (
    ModuleID int  NOT NULL IDENTITY ,
    ModuleName nvarchar(50)  NOT NULL,
    CourseID int  NOT NULL,
    LanguageID int  NOT NULL,
    TeacherID int  NOT NULL,
    TranslatorID int  NULL,
    Date datetime  NOT NULL,
    CONSTRAINT CourseModules_pk PRIMARY KEY  (ModuleID)
);

-- Table: CourseStudentDetails
CREATE TABLE CourseStudentDetails (
    StudentID int  NOT NULL,
    CourseID int  NOT NULL,
    Completed bit  NOT NULL DEFAULT 0,
    CONSTRAINT CourseStudentDetails_pk PRIMARY KEY  (StudentID,CourseID)
);

-- Table: Courses
CREATE TABLE Courses (
    CourseID    int          NOT NULL IDENTITY,
    CourseName  nvarchar(50) NOT NULL UNIQUE,
    Price       money        NOT NULL CHECK (Price > 0),
    Description varchar(max) NOT NULL,
    CONSTRAINT Courses_pk PRIMARY KEY  (CourseID)
);

-- Table: CurrenciesRate
CREATE TABLE CurrenciesRate (
    CurrencyID int  NOT NULL IDENTITY,
    CurrencyRate decimal(10,4)  NOT NULL CHECK (CurrencyRate > 0),
    CurrencyName nvarchar(15)  NOT NULL UNIQUE,
    CONSTRAINT CurrenciesRate_pk PRIMARY KEY  (CurrencyID)
);

-- Table: GradesList
CREATE TABLE GradesList (
    Grade DECIMAL(2,1)  NOT NULL UNIQUE CHECK (Grade >= 2 AND Grade <= 5),
    Description nvarchar(20)  NOT NULL,
    CONSTRAINT GradesList_pk PRIMARY KEY  (Grade)
);

-- Table: HybridMeetings
CREATE TABLE HybridMeetings (
    HybridMeetingID int  NOT NULL,
    ComponentMeetingID int  NOT NULL,
    CONSTRAINT HybridMeetings_pk PRIMARY KEY  (HybridMeetingID,ComponentMeetingID)
);

-- Table: HybridModules
CREATE TABLE HybridModules (
    HybridModuleID int  NOT NULL,
    ComponentModuleID int  NOT NULL,
    CONSTRAINT HybridModules_pk PRIMARY KEY  (HybridModuleID,ComponentModuleID)
);

-- Table: Internships
CREATE TABLE Internships (
    InternshipID int  NOT NULL IDENTITY,
    StudiesID int  NOT NULL,
    InternshipName nvarchar(30)  NOT NULL,
    StartingDate datetime  NOT NULL,
    Description nvarchar(max)  NOT NULL,
    CONSTRAINT Internships_pk PRIMARY KEY  (InternshipID)
);

-- Table: Languages
CREATE TABLE Languages (
    LanguageID int  NOT NULL IDENTITY,
    LanguageName nvarchar(30)  NOT NULL UNIQUE,
    CONSTRAINT Languages_pk PRIMARY KEY  (LanguageID)
);

-- Table: Locations
CREATE TABLE Locations (
    LocationID int  NOT NULL IDENTITY,
    Address varchar(150)  NOT NULL,
    Room varchar(10)  NOT NULL,
    MaxPeople int  NOT NULL CHECK (MaxPeople > 0),
    CONSTRAINT Locations_pk PRIMARY KEY  (LocationID)
);

-- Table: MeetingAttendance
CREATE TABLE MeetingAttendance (
    MeetingID int  NOT NULL,
    StudentID int  NOT NULL,
    MeetingCompletion bit  NOT NULL DEFAULT 0,
    CONSTRAINT MeetingAttendance_pk PRIMARY KEY  (MeetingID,StudentID)
);

-- Table: ModuleAttendance
CREATE TABLE ModuleAttendance (
    ModuleID int  NOT NULL,
    StudentID int  NOT NULL,
    ModuleCompletion bit  NOT NULL DEFAULT 0,
    CONSTRAINT ModuleAttendance_pk PRIMARY KEY  (ModuleID,StudentID)
);

-- Table: OnlineAsyncMeeting
CREATE TABLE OnlineAsyncMeeting (
    MeetingID int  NOT NULL,
    VideoLink varchar(100)  NOT NULL,
    CONSTRAINT OnlineAsyncMeeting_pk PRIMARY KEY  (MeetingID)
);

-- Table: OnlineAsyncModule
CREATE TABLE OnlineAsyncModule (
    ModuleID int  NOT NULL,
    VideoLink varchar(100)  NOT NULL,
    CONSTRAINT OnlineAsyncModule_pk PRIMARY KEY  (ModuleID)
);

-- Table: OnlineSyncMeeting
CREATE TABLE OnlineSyncMeeting (
    MeetingID int  NOT NULL,
    Link varchar(100)  NOT NULL,
    CONSTRAINT OnlineSyncMeeting_pk PRIMARY KEY  (MeetingID)
);

-- Table: OnlineSyncModule
CREATE TABLE OnlineSyncModule (
    ModuleID int  NOT NULL,
    Link varchar(100)  NOT NULL,
    CONSTRAINT OnlineSyncModule_pk PRIMARY KEY  (ModuleID)
);

-- Table: OrderAcademicMeeting
CREATE TABLE OrderAcademicMeeting (
    OrderContentID int  NOT NULL,
    MeetingID int  NOT NULL,
    CONSTRAINT OrderAcademicMeeting_pk PRIMARY KEY  (OrderContentID)
);

-- Table: OrderContentDetails
CREATE TABLE OrderContentDetails (
    OrderContentID int  NOT NULL IDENTITY,
    OrderID int  NOT NULL,
    CONSTRAINT OrderContentDetails_pk PRIMARY KEY  (OrderContentID)
);

-- Table: OrderCourse
CREATE TABLE OrderCourse (
    OrderContentID int  NOT NULL,
    CourseID int  NOT NULL,
    CONSTRAINT OrderCourse_pk PRIMARY KEY  (OrderContentID)
);

-- Table: OrderStudies
CREATE TABLE OrderStudies (
    OrderContentID int  NOT NULL,
    StudiesID int  NOT NULL,
    CONSTRAINT OrderStudies_pk PRIMARY KEY  (OrderContentID)
);

-- Table: OrderWebinar
CREATE TABLE OrderWebinar (
    OrderContentID int  NOT NULL,
    WebinarID int  NOT NULL,
    CONSTRAINT OrderWebinar_pk PRIMARY KEY  (OrderContentID)
);

-- Table: Orders
CREATE TABLE Orders (
    OrderID int  NOT NULL IDENTITY,
    StudentID int  NOT NULL,
    OrderDate datetime  NOT NULL,
    FullyPaidDate datetime  NULL,
    PaymentLink nvarchar(100)  NOT NULL,
    CurrencyID int  NOT NULL,
    vatID int  NOT NULL,
    CONSTRAINT Orders_pk PRIMARY KEY  (OrderID)
);

-- Table: Payments
CREATE TABLE Payments (
    PaymentID int  NOT NULL IDENTITY,
    PaidAmount money  NOT NULL CHECK (PaidAmount > 0),
    OrderID int  NOT NULL,
    PaymentDate datetime  NOT NULL,
    CONSTRAINT Payments_pk PRIMARY KEY  (PaymentID)
);

-- Table: StationaryMeeting
CREATE TABLE StationaryMeeting (
    MeetingID int  NOT NULL,
    LocationID int  NOT NULL,
    CONSTRAINT StationaryMeeting_pk PRIMARY KEY  (MeetingID)
);

-- Table: StationaryModule
CREATE TABLE StationaryModule (
    ModuleID int  NOT NULL,
    LocationID int  NOT NULL,
    CONSTRAINT StationaryModule_pk PRIMARY KEY  (ModuleID)
);

-- Table: StudentInternshipDetails
CREATE TABLE StudentInternshipDetails (
    InternshipID int  NOT NULL,
    StudentID int  NOT NULL,
    CompletedDays int  NOT NULL DEFAULT 0 CHECK (CompletedDays >= 0),
    CONSTRAINT StudentInternshipDetails_pk PRIMARY KEY  (InternshipID,StudentID)
);

-- Table: StudentStudiesDetails
CREATE TABLE StudentStudiesDetails (
    StudentID int  NOT NULL,
    StudiesID int  NULL,
    Grade DECIMAL(2,1)  NOT NULL,
    CONSTRAINT StudentStudiesDetails_pk PRIMARY KEY  (StudentID,StudiesID)
);

-- Table: StudentSubjectDetails
CREATE TABLE StudentSubjectDetails (
    StudentID int  NOT NULL,
    SubjectID int  NOT NULL,
    Grade DECIMAL(2,1)  NULL,
    CONSTRAINT StudentSubjectDetails_pk PRIMARY KEY  (StudentID,SubjectID)
);

-- Table: Students
CREATE TABLE Students (
    StudentID int  NOT NULL IDENTITY,
    FirstName nvarchar(50)  NOT NULL,
    LastName nvarchar(60)  NOT NULL,
    Address nvarchar(150)  NOT NULL,
    City nvarchar(30)  NOT NULL,
    PostalCode varchar(10)  NOT NULL,
    Country nvarchar(30)  NOT NULL,
    Email varchar(100)  NOT NULL UNIQUE CHECK (Email LIKE '%_@_%._%'),
    PhoneNumber varchar(15)  NOT NULL UNIQUE CHECK (PhoneNumber LIKE '+[1-9][0-9]%'),
    IsRegularCustomer bit  NOT NULL DEFAULT 0,
    GDPRAgreementDate datetime  NOT NULL DEFAULT GETDATE(),
    CONSTRAINT StudentID PRIMARY KEY  (StudentID)
);

-- Table: Studies
CREATE TABLE Studies (
    StudiesID int  NOT NULL IDENTITY,
    StudiesName nvarchar(30)  NOT NULL UNIQUE ,
    Syllabus nvarchar(max)  NOT NULL,
    Tuition money  NOT NULL CHECK (Tuition > 0),
    CONSTRAINT Studies_pk PRIMARY KEY  (StudiesID)
);

-- Table: Subjects
CREATE TABLE Subjects (
    SubjectID int  NOT NULL IDENTITY,
    SubjectName nvarchar(30)  NOT NULL,
    Description nvarchar(max)  NOT NULL,
    StudiesID int  NOT NULL,
    CONSTRAINT Subjects_pk PRIMARY KEY  (SubjectID)
);

-- Table: Teachers
CREATE TABLE Teachers (
    TeacherID int  NOT NULL IDENTITY,
    FirstName nvarchar(30)  NOT NULL,
    LastName nvarchar(60)  NOT NULL,
    Address nvarchar(150)  NOT NULL,
    City nvarchar(30)  NOT NULL,
    Country nvarchar(30)  NOT NULL,
    Email varchar(100)  NOT NULL UNIQUE CHECK (Email LIKE '%_@_%._%'),
    PhoneNumber varchar(15) NOT NULL UNIQUE CHECK (PhoneNumber LIKE '+[1-9][0-9]%'),
    CONSTRAINT TeacherID PRIMARY KEY  (TeacherID)
);

-- Table: TranslatorLanguageDetails
CREATE TABLE TranslatorLanguageDetails (
    TranslatorID int  NOT NULL,
    LanguageID int  NOT NULL,
    CONSTRAINT TranslatorLanguageDetails_pk PRIMARY KEY  (TranslatorID,LanguageID)
);

-- Table: `Translators`
CREATE TABLE Translators (
    TranslatorID int  NOT NULL IDENTITY,
    FirstName nvarchar(30)  NOT NULL,
    LastName nvarchar(60)  NOT NULL,
    Email varchar(100)  NOT NULL UNIQUE CHECK (Email LIKE '%_@_%._%'),
    PhoneNumber varchar(15)  NOT NULL UNIQUE CHECK (PhoneNumber LIKE '+[1-9][0-9]%'),
    CONSTRAINT Translators_pk PRIMARY KEY  (TranslatorID)
);

-- Table: VAT
CREATE TABLE VAT (
    vatID int  NOT NULL IDENTITY,
    Rate decimal(4,2)  NOT NULL CHECK (Rate >= 0 AND Rate <= 99.99),
    CONSTRAINT VAT_pk PRIMARY KEY  (vatID)
);

-- Table: WebinarDetails
CREATE TABLE WebinarDetails (
    StudentID int  NOT NULL,
    WebinarID int  NOT NULL,
    TerminationDate datetime  NOT NULL,
    CONSTRAINT WebinarDetails_pk PRIMARY KEY  (StudentID,WebinarID)
);

-- Table: Webinars
CREATE TABLE Webinars (
    WebinarID int  NOT NULL IDENTITY,
    WebinarName nvarchar(50)  NOT NULL,
    Price money  NOT NULL CHECK (Price >= 0),
    TeacherID int  NOT NULL,
    Link varchar(100)  NOT NULL,
    TranslatorID int  NULL,
    WebinarDate datetime  NOT NULL,
    LanguageID int  NOT NULL,
    Description nvarchar(max)  NOT NULL,
    CONSTRAINT Webinars_pk PRIMARY KEY  (WebinarID)
);

-- foreign keys
-- Reference: AcademicMeeting_Languages (table: AcademicMeeting)
ALTER TABLE AcademicMeeting ADD CONSTRAINT AcademicMeeting_Languages
    FOREIGN KEY (LanguageID)
    REFERENCES Languages (LanguageID);

-- Reference: AcademicMeeting_Subjects (table: AcademicMeeting)
ALTER TABLE AcademicMeeting ADD CONSTRAINT AcademicMeeting_Subjects
    FOREIGN KEY (SubjectID)
    REFERENCES Subjects (SubjectID);

-- Reference: AcademicMeeting_Teachers (table: AcademicMeeting)
ALTER TABLE AcademicMeeting ADD CONSTRAINT AcademicMeeting_Teachers
    FOREIGN KEY (TeacherID)
    REFERENCES Teachers (TeacherID);

-- Reference: AcademicMeeting_Translators (table: AcademicMeeting)
ALTER TABLE AcademicMeeting ADD CONSTRAINT AcademicMeeting_Translators
    FOREIGN KEY (TranslatorID)
    REFERENCES Translators (TranslatorID);

-- Reference: CourseModules_Courses (table: CourseModules)
ALTER TABLE CourseModules ADD CONSTRAINT CourseModules_Courses
    FOREIGN KEY (CourseID)
    REFERENCES Courses (CourseID);

-- Reference: CourseModules_Languages (table: CourseModules)
ALTER TABLE CourseModules ADD CONSTRAINT CourseModules_Languages
    FOREIGN KEY (LanguageID)
    REFERENCES Languages (LanguageID);

-- Reference: CourseModules_OnlineAsyncModule (table: CourseModules)
ALTER TABLE CourseModules ADD CONSTRAINT CourseModules_OnlineAsyncModule
    FOREIGN KEY (ModuleID)
    REFERENCES OnlineAsyncModule (ModuleID);

-- Reference: CourseModules_OnlineSyncModule (table: CourseModules)
ALTER TABLE CourseModules ADD CONSTRAINT CourseModules_OnlineSyncModule
    FOREIGN KEY (ModuleID)
    REFERENCES OnlineSyncModule (ModuleID);

-- Reference: CourseModules_StationaryModule (table: CourseModules)
ALTER TABLE CourseModules ADD CONSTRAINT CourseModules_StationaryModule
    FOREIGN KEY (ModuleID)
    REFERENCES StationaryModule (ModuleID);

-- Reference: CourseModules_Teachers (table: CourseModules)
ALTER TABLE CourseModules ADD CONSTRAINT CourseModules_Teachers
    FOREIGN KEY (TeacherID)
    REFERENCES Teachers (TeacherID);

-- Reference: CourseModules_Translators (table: CourseModules)
ALTER TABLE CourseModules ADD CONSTRAINT CourseModules_Translators
    FOREIGN KEY (TranslatorID)
    REFERENCES Translators (TranslatorID);

-- Reference: CourseStudentDetails_Courses (table: CourseStudentDetails)
ALTER TABLE CourseStudentDetails ADD CONSTRAINT CourseStudentDetails_Courses
    FOREIGN KEY (CourseID)
    REFERENCES Courses (CourseID);

-- Reference: CourseStudentDetails_Students (table: CourseStudentDetails)
ALTER TABLE CourseStudentDetails ADD CONSTRAINT CourseStudentDetails_Students
    FOREIGN KEY (StudentID)
    REFERENCES Students (StudentID);

-- Reference: HybridMeetings_AcademicMeeting (table: HybridMeetings)
ALTER TABLE HybridMeetings ADD CONSTRAINT HybridMeetings_AcademicMeeting
    FOREIGN KEY (HybridMeetingID)
    REFERENCES AcademicMeeting (MeetingID);

-- Reference: HybridModules_CourseModules (table: HybridModules)
ALTER TABLE HybridModules ADD CONSTRAINT HybridModules_CourseModules
    FOREIGN KEY (HybridModuleID)
    REFERENCES CourseModules (ModuleID);

-- Reference: HybridModules_OnlineAsyncModule (table: HybridModules)
ALTER TABLE HybridModules ADD CONSTRAINT HybridModules_OnlineAsyncModule
    FOREIGN KEY (ComponentModuleID)
    REFERENCES OnlineAsyncModule (ModuleID);

-- Reference: HybridModules_OnlineSyncModule (table: HybridModules)
ALTER TABLE HybridModules ADD CONSTRAINT HybridModules_OnlineSyncModule
    FOREIGN KEY (ComponentModuleID)
    REFERENCES OnlineSyncModule (ModuleID);

-- Reference: HybridModules_StationaryModule (table: HybridModules)
ALTER TABLE HybridModules ADD CONSTRAINT HybridModules_StationaryModule
    FOREIGN KEY (ComponentModuleID)
    REFERENCES StationaryModule (ModuleID);

-- Reference: Locations_StationaryMeeting (table: StationaryMeeting)
ALTER TABLE StationaryMeeting ADD CONSTRAINT Locations_StationaryMeeting
    FOREIGN KEY (LocationID)
    REFERENCES Locations (LocationID);

-- Reference: Locations_StationaryModule (table: StationaryModule)
ALTER TABLE StationaryModule ADD CONSTRAINT Locations_StationaryModule
    FOREIGN KEY (LocationID)
    REFERENCES Locations (LocationID);

-- Reference: MeetingAttendance_AcademicMeeting (table: MeetingAttendance)
ALTER TABLE MeetingAttendance ADD CONSTRAINT MeetingAttendance_AcademicMeeting
    FOREIGN KEY (MeetingID)
    REFERENCES AcademicMeeting (MeetingID);

-- Reference: MeetingAttendance_Students (table: MeetingAttendance)
ALTER TABLE MeetingAttendance ADD CONSTRAINT MeetingAttendance_Students
    FOREIGN KEY (StudentID)
    REFERENCES Students (StudentID);

-- Reference: ModuleAttendance_CourseModules (table: ModuleAttendance)
ALTER TABLE ModuleAttendance ADD CONSTRAINT ModuleAttendance_CourseModules
    FOREIGN KEY (ModuleID)
    REFERENCES CourseModules (ModuleID);

-- Reference: ModuleAttendance_Students (table: ModuleAttendance)
ALTER TABLE ModuleAttendance ADD CONSTRAINT ModuleAttendance_Students
    FOREIGN KEY (StudentID)
    REFERENCES Students (StudentID);

-- Reference: OnlineAsyncMeeting_AcademicMeeting (table: OnlineAsyncMeeting)
ALTER TABLE OnlineAsyncMeeting ADD CONSTRAINT OnlineAsyncMeeting_AcademicMeeting
    FOREIGN KEY (MeetingID)
    REFERENCES AcademicMeeting (MeetingID);

-- Reference: OnlineAsyncMeeting_HybridMeetings (table: HybridMeetings)
ALTER TABLE HybridMeetings ADD CONSTRAINT OnlineAsyncMeeting_HybridMeetings
    FOREIGN KEY (ComponentMeetingID)
    REFERENCES OnlineAsyncMeeting (MeetingID);

-- Reference: OnlineSyncMeeting_AcademicMeeting (table: OnlineSyncMeeting)
ALTER TABLE OnlineSyncMeeting ADD CONSTRAINT OnlineSyncMeeting_AcademicMeeting
    FOREIGN KEY (MeetingID)
    REFERENCES AcademicMeeting (MeetingID);

-- Reference: OnlineSyncMeeting_HybridMeetings (table: HybridMeetings)
ALTER TABLE HybridMeetings ADD CONSTRAINT OnlineSyncMeeting_HybridMeetings
    FOREIGN KEY (ComponentMeetingID)
    REFERENCES OnlineSyncMeeting (MeetingID);

-- Reference: OrderAcademicMeeting_AcademicMeeting (table: OrderAcademicMeeting)
ALTER TABLE OrderAcademicMeeting ADD CONSTRAINT OrderAcademicMeeting_AcademicMeeting
    FOREIGN KEY (MeetingID)
    REFERENCES AcademicMeeting (MeetingID);

-- Reference: OrderContentDetails_OrderAcademicMeeting (table: OrderContentDetails)
ALTER TABLE OrderContentDetails ADD CONSTRAINT OrderContentDetails_OrderAcademicMeeting
    FOREIGN KEY (OrderContentID)
    REFERENCES OrderAcademicMeeting (OrderContentID);

-- Reference: OrderContentDetails_OrderCourse (table: OrderContentDetails)
ALTER TABLE OrderContentDetails ADD CONSTRAINT OrderContentDetails_OrderCourse
    FOREIGN KEY (OrderContentID)
    REFERENCES OrderCourse (OrderContentID);

-- Reference: OrderContentDetails_OrderStudies (table: OrderContentDetails)
ALTER TABLE OrderContentDetails ADD CONSTRAINT OrderContentDetails_OrderStudies
    FOREIGN KEY (OrderContentID)
    REFERENCES OrderStudies (OrderContentID);

-- Reference: OrderContentDetails_OrderWebinar (table: OrderContentDetails)
ALTER TABLE OrderContentDetails ADD CONSTRAINT OrderContentDetails_OrderWebinar
    FOREIGN KEY (OrderContentID)
    REFERENCES OrderWebinar (OrderContentID);

-- Reference: OrderContentDetails_Orders (table: OrderContentDetails)
ALTER TABLE OrderContentDetails ADD CONSTRAINT OrderContentDetails_Orders
    FOREIGN KEY (OrderID)
    REFERENCES Orders (OrderID);

-- Reference: OrderCourse_Courses (table: OrderCourse)
ALTER TABLE OrderCourse ADD CONSTRAINT OrderCourse_Courses
    FOREIGN KEY (CourseID)
    REFERENCES Courses (CourseID);

-- Reference: OrderStudies_Studies (table: OrderStudies)
ALTER TABLE OrderStudies ADD CONSTRAINT OrderStudies_Studies
    FOREIGN KEY (StudiesID)
    REFERENCES Studies (StudiesID);

-- Reference: OrderWebinar_Webinars (table: OrderWebinar)
ALTER TABLE OrderWebinar ADD CONSTRAINT OrderWebinar_Webinars
    FOREIGN KEY (WebinarID)
    REFERENCES Webinars (WebinarID);

-- Reference: Orders_CurrenciesRate (table: Orders)
ALTER TABLE Orders ADD CONSTRAINT Orders_CurrenciesRate
    FOREIGN KEY (CurrencyID)
    REFERENCES CurrenciesRate (CurrencyID);

-- Reference: Orders_Students (table: Orders)
ALTER TABLE Orders ADD CONSTRAINT Orders_Students
    FOREIGN KEY (StudentID)
    REFERENCES Students (StudentID);

-- Reference: Orders_VAT (table: Orders)
ALTER TABLE Orders ADD CONSTRAINT Orders_VAT
    FOREIGN KEY (vatID)
    REFERENCES VAT (vatID);

-- Reference: Payments_Orders (table: Payments)
ALTER TABLE Payments ADD CONSTRAINT Payments_Orders
    FOREIGN KEY (OrderID)
    REFERENCES Orders (OrderID);

-- Reference: StationaryMeeting_AcademicMeeting (table: StationaryMeeting)
ALTER TABLE StationaryMeeting ADD CONSTRAINT StationaryMeeting_AcademicMeeting
    FOREIGN KEY (MeetingID)
    REFERENCES AcademicMeeting (MeetingID);

-- Reference: StationaryMeeting_HybridMeetings (table: HybridMeetings)
ALTER TABLE HybridMeetings ADD CONSTRAINT StationaryMeeting_HybridMeetings
    FOREIGN KEY (ComponentMeetingID)
    REFERENCES StationaryMeeting (MeetingID);

-- Reference: StudentInternshipDetails_Internships (table: StudentInternshipDetails)
ALTER TABLE StudentInternshipDetails ADD CONSTRAINT StudentInternshipDetails_Internships
    FOREIGN KEY (InternshipID)
    REFERENCES Internships (InternshipID);

-- Reference: StudentInternshipDetails_Students (table: StudentInternshipDetails)
ALTER TABLE StudentInternshipDetails ADD CONSTRAINT StudentInternshipDetails_Students
    FOREIGN KEY (StudentID)
    REFERENCES Students (StudentID);

-- Reference: StudentStudiesDetails_GradesList (table: StudentStudiesDetails)
ALTER TABLE StudentStudiesDetails ADD CONSTRAINT StudentStudiesDetails_GradesList
    FOREIGN KEY (Grade)
    REFERENCES GradesList (Grade);

-- Reference: StudentStudiesDetails_Students (table: StudentStudiesDetails)
ALTER TABLE StudentStudiesDetails ADD CONSTRAINT StudentStudiesDetails_Students
    FOREIGN KEY (StudentID)
    REFERENCES Students (StudentID);

-- Reference: StudentStudiesDetails_Studies (table: StudentStudiesDetails)
ALTER TABLE StudentStudiesDetails ADD CONSTRAINT StudentStudiesDetails_Studies
    FOREIGN KEY (StudiesID)
    REFERENCES Studies (StudiesID);

-- Reference: StudentSubjectDetails_GradesList (table: StudentSubjectDetails)
ALTER TABLE StudentSubjectDetails ADD CONSTRAINT StudentSubjectDetails_GradesList
    FOREIGN KEY (Grade)
    REFERENCES GradesList (Grade);

-- Reference: StudentSubjectDetails_Students (table: StudentSubjectDetails)
ALTER TABLE StudentSubjectDetails ADD CONSTRAINT StudentSubjectDetails_Students
    FOREIGN KEY (StudentID)
    REFERENCES Students (StudentID);

-- Reference: StudentSubjectDetails_Subjects (table: StudentSubjectDetails)
ALTER TABLE StudentSubjectDetails ADD CONSTRAINT StudentSubjectDetails_Subjects
    FOREIGN KEY (SubjectID)
    REFERENCES Subjects (SubjectID);

-- Reference: Studies_Internships (table: Internships)
ALTER TABLE Internships ADD CONSTRAINT Studies_Internships
    FOREIGN KEY (StudiesID)
    REFERENCES Studies (StudiesID);

-- Reference: Subjects_Studies (table: Subjects)
ALTER TABLE Subjects ADD CONSTRAINT Subjects_Studies
    FOREIGN KEY (StudiesID)
    REFERENCES Studies (StudiesID);

-- Reference: TranslatorLanguageDetails_Languages (table: TranslatorLanguageDetails)
ALTER TABLE TranslatorLanguageDetails ADD CONSTRAINT TranslatorLanguageDetails_Languages
    FOREIGN KEY (LanguageID)
    REFERENCES Languages (LanguageID);

-- Reference: TranslatorLanguageDetails_Translators (table: TranslatorLanguageDetails)
ALTER TABLE TranslatorLanguageDetails ADD CONSTRAINT TranslatorLanguageDetails_Translators
    FOREIGN KEY (TranslatorID)
    REFERENCES Translators (TranslatorID);

-- Reference: WebinarDetails_Students (table: WebinarDetails)
ALTER TABLE WebinarDetails ADD CONSTRAINT WebinarDetails_Students
    FOREIGN KEY (StudentID)
    REFERENCES Students (StudentID);

-- Reference: WebinarDetails_Webinars (table: WebinarDetails)
ALTER TABLE WebinarDetails ADD CONSTRAINT WebinarDetails_Webinars
    FOREIGN KEY (WebinarID)
    REFERENCES Webinars (WebinarID);

-- Reference: Webinars_Languages (table: Webinars)
ALTER TABLE Webinars ADD CONSTRAINT Webinars_Languages
    FOREIGN KEY (LanguageID)
    REFERENCES Languages (LanguageID);

-- Reference: Webinars_Teachers (table: Webinars)
ALTER TABLE Webinars ADD CONSTRAINT Webinars_Teachers
    FOREIGN KEY (TeacherID)
    REFERENCES Teachers (TeacherID);

-- Reference: Webinars_Translators (table: Webinars)
ALTER TABLE Webinars ADD CONSTRAINT Webinars_Translators
    FOREIGN KEY (TranslatorID)
    REFERENCES Translators (TranslatorID);

-- End of file.

-- Remove foreign key constraints from CourseModules
ALTER TABLE CourseModules DROP CONSTRAINT CourseModules_OnlineAsyncModule;
ALTER TABLE CourseModules DROP CONSTRAINT CourseModules_OnlineSyncModule;
ALTER TABLE CourseModules DROP CONSTRAINT CourseModules_StationaryModule;


-- Add foreign key constraints to the respective module tables
ALTER TABLE OnlineAsyncModule ADD CONSTRAINT OnlineAsyncModule_CourseModules
    FOREIGN KEY (ModuleID)
    REFERENCES CourseModules (ModuleID);

ALTER TABLE OnlineSyncModule ADD CONSTRAINT OnlineSyncModule_CourseModules
    FOREIGN KEY (ModuleID)
    REFERENCES CourseModules (ModuleID);

ALTER TABLE StationaryModule ADD CONSTRAINT StationaryModule_CourseModules
    FOREIGN KEY (ModuleID)
    REFERENCES CourseModules (ModuleID);

-- Korekta błędnych referencji dla modułów

-- Remove unnecessary foreign key constraints from HybridModules
ALTER TABLE HybridModules DROP CONSTRAINT HybridModules_OnlineAsyncModule;
ALTER TABLE HybridModules DROP CONSTRAINT HybridModules_OnlineSyncModule;
ALTER TABLE HybridModules DROP CONSTRAINT HybridModules_StationaryModule;

-- Add foreign key constraint to ensure ComponentModuleID exists in CourseModules
ALTER TABLE HybridModules ADD CONSTRAINT HybridModules_CourseModules_Components
    FOREIGN KEY (ComponentModuleID)
    REFERENCES CourseModules (ModuleID);

-- To samo ale dla HybridMeetings

-- Remove unnecessary foreign key constraints from HybridMeetings
ALTER TABLE HybridMeetings DROP CONSTRAINT OnlineAsyncMeeting_HybridMeetings;
ALTER TABLE HybridMeetings DROP CONSTRAINT OnlineSyncMeeting_HybridMeetings;
ALTER TABLE HybridMeetings DROP CONSTRAINT StationaryMeeting_HybridMeetings;

-- Add foreign key constraint to ensure ComponentMeetingID exists in AcademicMeeting
ALTER TABLE HybridMeetings ADD CONSTRAINT HybridMeetings_AcademicMeeting_Components
    FOREIGN KEY (ComponentMeetingID)
    REFERENCES AcademicMeeting (MeetingID);


------

-- Drop existing foreign key constraints
ALTER TABLE OrderContentDetails DROP CONSTRAINT OrderContentDetails_OrderWebinar;
ALTER TABLE OrderContentDetails DROP CONSTRAINT OrderContentDetails_OrderCourse;
ALTER TABLE OrderContentDetails DROP CONSTRAINT OrderContentDetails_OrderAcademicMeeting;
ALTER TABLE OrderContentDetails DROP CONSTRAINT OrderContentDetails_OrderStudies;

-- Add new foreign key constraints
ALTER TABLE OrderWebinar ADD CONSTRAINT OrderWebinar_OrderContentDetails
    FOREIGN KEY (OrderContentID)
    REFERENCES OrderContentDetails (OrderContentID);

ALTER TABLE OrderCourse ADD CONSTRAINT OrderCourse_OrderContentDetails
    FOREIGN KEY (OrderContentID)
    REFERENCES OrderContentDetails (OrderContentID);

ALTER TABLE OrderAcademicMeeting ADD CONSTRAINT OrderAcademicMeeting_OrderContentDetails
    FOREIGN KEY (OrderContentID)
    REFERENCES OrderContentDetails (OrderContentID);

ALTER TABLE OrderStudies ADD CONSTRAINT OrderStudies_OrderContentDetails
    FOREIGN KEY (OrderContentID)
    REFERENCES OrderContentDetails (OrderContentID);