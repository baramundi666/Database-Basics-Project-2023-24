-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-01-19 13:20:13.634

-- tables
-- Table: Courses
CREATE TABLE Courses (
    ServiceID int  NOT NULL,
    CourseName varchar(50)  NOT NULL,
    Type varchar(20)  NOT NULL,
    StartDate datetime  NOT NULL,
    EndDate datetime  NOT NULL,
    PriceInAdvance money  NOT NULL,
    PriceWhole money  NOT NULL,
    Limit int  NULL,
    CONSTRAINT Courses_pk PRIMARY KEY  (ServiceID)
);

-- Table: Courses_attendance
CREATE TABLE Courses_attendance (
    ClassID int  NOT NULL,
    CustomerID int  NOT NULL,
    ModuleID int  NOT NULL,
    Attendance varchar(10)  NOT NULL,
    CONSTRAINT Courses_attendance_pk PRIMARY KEY  (CustomerID,ClassID)
);

-- Table: Courses_hist
CREATE TABLE Courses_hist (
    ClassID int  NOT NULL,
    ModuleID int  NOT NULL,
    LecturerID int  NOT NULL,
    TranslatorID int  NOT NULL,
    Date datetime  NOT NULL,
    Type varchar(20)  NOT NULL,
    LinkNagranie varchar(50)  NULL,
    CONSTRAINT Courses_hist_pk PRIMARY KEY  (ClassID)
);

-- Table: Customers
CREATE TABLE Customers (
    CustomerID int  NOT NULL,
    FirstName varchar(50)  NOT NULL,
    LastName varchar(50)  NOT NULL,
    Balance money  NOT NULL,
    Email varchar(50)  NOT NULL,
    City varchar(50)  NOT NULL,
    Address varchar(50)  NOT NULL,
    PostalCode varchar(50)  NOT NULL,
    CONSTRAINT Customer_ID PRIMARY KEY  (CustomerID)
);

-- Table: Diplomas
CREATE TABLE Diplomas (
    DiplomaID int  NOT NULL,
    ServiceID int  NOT NULL,
    CustomerID int  NOT NULL,
    Date datetime  NOT NULL,
    Title varchar(30)  NOT NULL,
    CONSTRAINT Diplomas_pk PRIMARY KEY  (DiplomaID)
);

-- Table: Exams
CREATE TABLE Exams (
    ServiceID int  NOT NULL,
    CustomerID int  NOT NULL,
    Grade float(1)  NOT NULL,
    CONSTRAINT Exams_pk PRIMARY KEY  (ServiceID,CustomerID)
);

-- Table: Internships
CREATE TABLE Internships (
    InternshipID int  NOT NULL,
    ServiceID int  NOT NULL,
    InternshipName varchar(200)  NOT NULL,
    InternshipDescription varchar(200)  NOT NULL,
    StartDate datetime  NOT NULL,
    EndDate datetime  NOT NULL,
    CONSTRAINT Internships_pk PRIMARY KEY  (InternshipID)
);

-- Table: Internships_passed
CREATE TABLE Internships_passed (
    InternshipID int  NOT NULL,
    CustomerID int  NOT NULL,
    Passed varchar(3)  NOT NULL,
    CONSTRAINT Internships_passed_pk PRIMARY KEY  (InternshipID,CustomerID)
);

-- Table: Languages
CREATE TABLE Languages (
    LanguageID int  NOT NULL,
    LanguageName varchar(50)  NOT NULL,
    CONSTRAINT Languages_pk PRIMARY KEY  (LanguageID)
);

-- Table: Lecturers
CREATE TABLE Lecturers (
    LecturerID int  NOT NULL,
    FirstName varchar(50)  NOT NULL,
    LastName varchar(50)  NOT NULL,
    CONSTRAINT Lecturer_ID PRIMARY KEY  (LecturerID)
);

-- Table: Lectures
CREATE TABLE Lectures (
    LectureID int  NOT NULL,
    LecturerID int  NOT NULL,
    TranslatorID int  NOT NULL,
    ServiceID int  NOT NULL,
    Type varchar(20)  NOT NULL,
    Language varchar(50)  NOT NULL,
    LinkNagranie varchar(50)  NOT NULL,
    Date datetime  NOT NULL,
    Limit int  NULL,
    CONSTRAINT Lectures_pk PRIMARY KEY  (LectureID)
);

-- Table: Lectures_attendance
CREATE TABLE Lectures_attendance (
    CustomerID int  NOT NULL,
    LectureID int  NOT NULL,
    Date datetime  NOT NULL,
    Attendance varchar(10)  NOT NULL,
    CONSTRAINT Lectures_attendance_pk PRIMARY KEY  (CustomerID,LectureID)
);

-- Table: Modules
CREATE TABLE Modules (
    ModuleID int  NOT NULL,
    ServiceID int  NOT NULL,
    ModuleName varchar(50)  NOT NULL,
    CONSTRAINT Modules_pk PRIMARY KEY  (ModuleID)
);

-- Table: Order_details
CREATE TABLE Order_details (
    ServiceID int  NOT NULL,
    OrderID int  NOT NULL,
    UnitPrice money  NOT NULL,
    CONSTRAINT Order_ID PRIMARY KEY  (ServiceID,OrderID)
);

-- Table: Orders
CREATE TABLE Orders (
    OrderID int  NOT NULL,
    CustomerID int  NOT NULL,
    OrderDate datetime  NOT NULL,
    PaymentAssesed money  NOT NULL,
    PaymentPaid money  NOT NULL,
    PaymentWaived money  NOT NULL,
    DueDate datetime  NOT NULL,
    OrderStatus varchar(10)  NOT NULL,
    CONSTRAINT Order_ID PRIMARY KEY  (OrderID)
);

-- Table: Services
CREATE TABLE Services (
    ServiceID int  NOT NULL,
    PriceInAdvance money  NOT NULL,
    PriceWhole money  NOT NULL,
    CONSTRAINT Services_pk PRIMARY KEY  (ServiceID)
);

-- Table: Single_Studies
CREATE TABLE Single_Studies (
    ServiceID int  NOT NULL,
    LectureID int  NOT NULL,
    Major varchar(50)  NOT NULL,
    Type varchar(50)  NOT NULL,
    Date datetime  NOT NULL,
    PriceInAdvance money  NOT NULL,
    PriceWhole money  NOT NULL,
    Limit int  NULL,
    CONSTRAINT Single_Studies_pk PRIMARY KEY  (ServiceID)
);

-- Table: Studies
CREATE TABLE Studies (
    ServiceID int  NOT NULL,
    SyllabusID int  NOT NULL,
    Major varchar(50)  NOT NULL,
    Type varchar(30)  NOT NULL,
    StartDate datetime  NOT NULL,
    EndDate datetime  NOT NULL,
    PriceInAdvance money  NOT NULL,
    PriceWhole money  NOT NULL,
    Limit int  NULL,
    CONSTRAINT Studies_pk PRIMARY KEY  (ServiceID)
);

-- Table: Subjects
CREATE TABLE Subjects (
    SubjectID int  NOT NULL,
    LecturerID int  NOT NULL,
    SubjectName varchar(50)  NOT NULL,
    SubjectDescription varchar(200)  NOT NULL,
    Hours int  NOT NULL,
    Assessment varchar(30)  NOT NULL,
    CONSTRAINT Subjects_pk PRIMARY KEY  (SubjectID)
);

-- Table: Syllabus
CREATE TABLE Syllabus (
    SyllabusID int  NOT NULL,
    SubjectID int  NOT NULL,
    SyllabusName varchar(50)  NOT NULL,
    CONSTRAINT Syllabus_pk PRIMARY KEY  (SyllabusID)
);

-- Table: Translator
CREATE TABLE Translator (
    TranslatorID int  NOT NULL,
    FirstName varchar(50)  NOT NULL,
    LastName varchar(50)  NOT NULL,
    CONSTRAINT Translator_pk PRIMARY KEY  (TranslatorID)
);

-- Table: Translator_details
CREATE TABLE Translator_details (
    TranslatorID int  NOT NULL,
    LanguageID int  NOT NULL,
    CONSTRAINT Translator_details_pk PRIMARY KEY  (TranslatorID,LanguageID)
);

-- Table: Webinars
CREATE TABLE Webinars (
    ServiceID int  NOT NULL,
    WebinarName varchar(50)  NOT NULL,
    Date datetime  NOT NULL,
    PriceInAdvance money  NOT NULL,
    PriceWhole money  NOT NULL,
    CONSTRAINT Webinars_pk PRIMARY KEY  (ServiceID)
);

-- Table: Webinars_hist
CREATE TABLE Webinars_hist (
    ServiceID int  NOT NULL,
    LecturerID int  NOT NULL,
    TranslatorID int  NOT NULL,
    Date datetime  NOT NULL,
    LinkNagranie varchar(50)  NOT NULL,
    CONSTRAINT Webinars_hist_pk PRIMARY KEY  (ServiceID,LecturerID)
);

-- foreign keys
-- Reference: Cennik_Single_Studies (table: Single_Studies)
ALTER TABLE Single_Studies ADD CONSTRAINT Cennik_Single_Studies
    FOREIGN KEY (ServiceID)
    REFERENCES Services (ServiceID);

-- Reference: Courses_Cennik (table: Courses)
ALTER TABLE Courses ADD CONSTRAINT Courses_Cennik
    FOREIGN KEY (ServiceID)
    REFERENCES Services (ServiceID);

-- Reference: Courses_attendance_Courses_hist (table: Courses_attendance)
ALTER TABLE Courses_attendance ADD CONSTRAINT Courses_attendance_Courses_hist
    FOREIGN KEY (ClassID)
    REFERENCES Courses_hist (ClassID);

-- Reference: Courses_attendance_Customers (table: Courses_attendance)
ALTER TABLE Courses_attendance ADD CONSTRAINT Courses_attendance_Customers
    FOREIGN KEY (CustomerID)
    REFERENCES Customers (CustomerID);

-- Reference: Courses_hist_Lecturers (table: Courses_hist)
ALTER TABLE Courses_hist ADD CONSTRAINT Courses_hist_Lecturers
    FOREIGN KEY (LecturerID)
    REFERENCES Lecturers (LecturerID);

-- Reference: Courses_hist_Modules (table: Courses_hist)
ALTER TABLE Courses_hist ADD CONSTRAINT Courses_hist_Modules
    FOREIGN KEY (ModuleID)
    REFERENCES Modules (ModuleID);

-- Reference: Courses_hist_Translator (table: Courses_hist)
ALTER TABLE Courses_hist ADD CONSTRAINT Courses_hist_Translator
    FOREIGN KEY (TranslatorID)
    REFERENCES Translator (TranslatorID);

-- Reference: Diplomas_Exams (table: Diplomas)
ALTER TABLE Diplomas ADD CONSTRAINT Diplomas_Exams
    FOREIGN KEY (ServiceID,CustomerID)
    REFERENCES Exams (ServiceID,CustomerID);

-- Reference: Exams_Customers (table: Exams)
ALTER TABLE Exams ADD CONSTRAINT Exams_Customers
    FOREIGN KEY (CustomerID)
    REFERENCES Customers (CustomerID);

-- Reference: Exams_Studies (table: Exams)
ALTER TABLE Exams ADD CONSTRAINT Exams_Studies
    FOREIGN KEY (ServiceID)
    REFERENCES Studies (ServiceID);

-- Reference: Internships_Studies (table: Internships)
ALTER TABLE Internships ADD CONSTRAINT Internships_Studies
    FOREIGN KEY (ServiceID)
    REFERENCES Studies (ServiceID);

-- Reference: Internships_passed_Customers (table: Internships_passed)
ALTER TABLE Internships_passed ADD CONSTRAINT Internships_passed_Customers
    FOREIGN KEY (CustomerID)
    REFERENCES Customers (CustomerID);

-- Reference: Internships_passed_Internships (table: Internships_passed)
ALTER TABLE Internships_passed ADD CONSTRAINT Internships_passed_Internships
    FOREIGN KEY (InternshipID)
    REFERENCES Internships (InternshipID);

-- Reference: Lectures_Lecturers (table: Lectures)
ALTER TABLE Lectures ADD CONSTRAINT Lectures_Lecturers
    FOREIGN KEY (LecturerID)
    REFERENCES Lecturers (LecturerID);

-- Reference: Lectures_Single_Studies (table: Single_Studies)
ALTER TABLE Single_Studies ADD CONSTRAINT Lectures_Single_Studies
    FOREIGN KEY (LectureID)
    REFERENCES Lectures (LectureID);

-- Reference: Lectures_Studies (table: Lectures)
ALTER TABLE Lectures ADD CONSTRAINT Lectures_Studies
    FOREIGN KEY (ServiceID)
    REFERENCES Studies (ServiceID);

-- Reference: Lectures_Translator (table: Lectures)
ALTER TABLE Lectures ADD CONSTRAINT Lectures_Translator
    FOREIGN KEY (TranslatorID)
    REFERENCES Translator (TranslatorID);

-- Reference: Lectures_attendance_Lectures (table: Lectures_attendance)
ALTER TABLE Lectures_attendance ADD CONSTRAINT Lectures_attendance_Lectures
    FOREIGN KEY (LectureID)
    REFERENCES Lectures (LectureID);

-- Reference: Lectures_details_Customers (table: Lectures_attendance)
ALTER TABLE Lectures_attendance ADD CONSTRAINT Lectures_details_Customers
    FOREIGN KEY (CustomerID)
    REFERENCES Customers (CustomerID);

-- Reference: Modules_Courses (table: Modules)
ALTER TABLE Modules ADD CONSTRAINT Modules_Courses
    FOREIGN KEY (ServiceID)
    REFERENCES Courses (ServiceID);

-- Reference: Order_details_Cennik (table: Order_details)
ALTER TABLE Order_details ADD CONSTRAINT Order_details_Cennik
    FOREIGN KEY (ServiceID)
    REFERENCES Services (ServiceID);

-- Reference: Order_details_Orders (table: Order_details)
ALTER TABLE Order_details ADD CONSTRAINT Order_details_Orders
    FOREIGN KEY (OrderID)
    REFERENCES Orders (OrderID);

-- Reference: Orders_Customers (table: Orders)
ALTER TABLE Orders ADD CONSTRAINT Orders_Customers
    FOREIGN KEY (CustomerID)
    REFERENCES Customers (CustomerID);

-- Reference: Studies_Cennik (table: Studies)
ALTER TABLE Studies ADD CONSTRAINT Studies_Cennik
    FOREIGN KEY (ServiceID)
    REFERENCES Services (ServiceID);

-- Reference: Studies_Syllabus (table: Studies)
ALTER TABLE Studies ADD CONSTRAINT Studies_Syllabus
    FOREIGN KEY (SyllabusID)
    REFERENCES Syllabus (SyllabusID);

-- Reference: Subjects_Lecturers (table: Subjects)
ALTER TABLE Subjects ADD CONSTRAINT Subjects_Lecturers
    FOREIGN KEY (LecturerID)
    REFERENCES Lecturers (LecturerID);

-- Reference: Subjects_Syllabus (table: Syllabus)
ALTER TABLE Syllabus ADD CONSTRAINT Subjects_Syllabus
    FOREIGN KEY (SubjectID)
    REFERENCES Subjects (SubjectID);

-- Reference: Translator_details_Languages (table: Translator_details)
ALTER TABLE Translator_details ADD CONSTRAINT Translator_details_Languages
    FOREIGN KEY (LanguageID)
    REFERENCES Languages (LanguageID);

-- Reference: Translator_details_Translator (table: Translator_details)
ALTER TABLE Translator_details ADD CONSTRAINT Translator_details_Translator
    FOREIGN KEY (TranslatorID)
    REFERENCES Translator (TranslatorID);

-- Reference: Webinars_Cennik (table: Webinars)
ALTER TABLE Webinars ADD CONSTRAINT Webinars_Cennik
    FOREIGN KEY (ServiceID)
    REFERENCES Services (ServiceID);

-- Reference: Webinars_hist_Lecturers (table: Webinars_hist)
ALTER TABLE Webinars_hist ADD CONSTRAINT Webinars_hist_Lecturers
    FOREIGN KEY (LecturerID)
    REFERENCES Lecturers (LecturerID);

-- Reference: Webinars_hist_Translator (table: Webinars_hist)
ALTER TABLE Webinars_hist ADD CONSTRAINT Webinars_hist_Translator
    FOREIGN KEY (TranslatorID)
    REFERENCES Translator (TranslatorID);

-- Reference: Webinars_hist_Webinars (table: Webinars_hist)
ALTER TABLE Webinars_hist ADD CONSTRAINT Webinars_hist_Webinars
    FOREIGN KEY (ServiceID)
    REFERENCES Webinars (ServiceID);

-- End of file.

