--NOWA BAZA 
--services
--orders
--studies
--Single_studies
--Syllabus
--Subjects
--Translator
--Webinars
--Webinar_hist
-- Table: Courses
-- webinary 1, studia 2, kursy 3, single studies 4,
CREATE TABLE Courses (
    ServiceID int IDENTITY(3,4) PRIMARY KEY,
    CourseName varchar(50)  NOT NULL,
    Type varchar(20)  CHECK(Type in ('Online', 'Hybrid', 'Stationary')) NOT NULL,
    StartDate datetime CHECK(StartDate >= '2019-01-01') NOT NULL,
    EndDate datetime   NOT NULL,
    PriceInAdvance money   NOT NULL,
    PriceWhole money  NOT NULL,
    Limit int NULL,
	CONSTRAINT CoursesDateCheck CHECK (
	ISDATE(StartDate) = 1 AND
	ISDATE(EndDate) = 1 AND
	EndDate > StartDate
	),
	CONSTRAINT CoursesPriceCheck CHECK (
	PriceInAdvance >= 0 AND
	PriceWhole >= 0 AND 
	PriceInAdvance <= PriceWhole
	),
	CONSTRAINT CoursesLimitCheck CHECK (
	Limit > 0 OR Limit IS NULL
	)
);



-- Table: Courses_attendance
CREATE TABLE Courses_attendance (
    ClassID int  NOT NULL,
    CustomerID int  NOT NULL,
    ModuleID int  NOT NULL,
    Attendance varchar(10) CHECK(Attendance in ('Present', 'Absent'))  NOT NULL,
    CONSTRAINT Courses_attendance_pk PRIMARY KEY  (CustomerID,ClassID)
);

-- Table: Courses_hist
CREATE TABLE Courses_hist (
    ClassID int IDENTITY(1,1) PRIMARY KEY,
    ModuleID int  NOT NULL,
    LecturerID int  NOT NULL,
    TranslatorID int  NOT NULL,
	StartDate datetime CHECK(StartDate >= '2019-01-01') NULL,
    EndDate datetime  NOT NULL,
	Type varchar(20)  CHECK(Type in ('Online', 'Hybrid', 'Stationary')) NOT NULL,
	LinkNagranie varchar(50) NULL,
	CONSTRAINT Courses_histDateCheck CHECK (
	ISDATE(StartDate) = 1 AND
	ISDATE(EndDate) = 1 AND
	EndDate > StartDate
	)
);



-- Table: Customers
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) CHECK (LEFT(FirstName, 1) = UPPER(LEFT(FirstName, 1))) NOT NULL,
    LastName VARCHAR(50) CHECK (LEFT(LastName, 1) = UPPER(LEFT(LastName, 1))) NOT NULL,
    Balance MONEY NOT NULL,
    Email VARCHAR(50) NOT NULL UNIQUE,
    City VARCHAR(50) CHECK (LEFT(City, 1) = UPPER(LEFT(City, 1))) NOT NULL,
    Address VARCHAR(50) NOT NULL,
    PostalCode VARCHAR(50) NOT NULL
);


-- Table: Diplomas
CREATE TABLE Diplomas (
    DiplomaID int IDENTITY(1,1) PRIMARY KEY,
    ServiceID int  NOT NULL,
    CustomerID int  NOT NULL,
    Date datetime  CHECK(Date >= '2019-01-01') NOT NULL,
    Title varchar(30) CHECK (LEFT(Title, 1) = UPPER(LEFT(Title, 1))) NOT NULL,
	CONSTRAINT DiplomasDateCheck CHECK (
	ISDATE(Date) = 1
	)
);


-- Table: Exams
CREATE TABLE Exams (
    ServiceID int  NOT NULL,
    CustomerID int  NOT NULL,
    Grade float(1) CHECK (Grade in (2.0,3.0,3.5,4.0,4.5,5.0))  NOT NULL,
    CONSTRAINT Exams_pk PRIMARY KEY  (ServiceID,CustomerID)
);

-- Table: Internships
CREATE TABLE Internships (
    InternshipID int  IDENTITY(1,1) PRIMARY KEY,
    ServiceID int  NOT NULL,
    InternshipName varchar(200) CHECK (LEFT(InternshipName, 1) = UPPER(LEFT(InternshipName, 1))) NOT NULL,
    InternshipDescription varchar(200)   NOT NULL,
    StartDate datetime CHECK(StartDate >= '2019-01-01') NOT NULL,
    EndDate datetime  NOT NULL,
	CONSTRAINT InternshipsDateCheck CHECK (
	ISDATE(StartDate) = 1 AND
	ISDATE(EndDate) = 1 AND
	EndDate > StartDate
	)
);

-- Table: Internships_passed
CREATE TABLE Internships_passed (
    InternshipID int  NOT NULL,
    CustomerID int  NOT NULL,
    Passed varchar(3) CHECK(Passed in ('Yes', 'No')) NOT NULL,
    CONSTRAINT Internships_passed_pk PRIMARY KEY  (InternshipID,CustomerID)
);

-- Table: Lecturers
CREATE TABLE Lecturers (
    LecturerID int IDENTITY(1,1) PRIMARY KEY,
    FirstName varchar(50) CHECK (LEFT(FirstName, 1) = UPPER(LEFT(FirstName, 1))) NOT NULL,
    LastName varchar(50) CHECK (LEFT(LastName, 1) = UPPER(LEFT(LastName, 1))) NOT NULL,
);

-- Table: Lectures
CREATE TABLE Lectures (
    LectureID int IDENTITY(1,1) PRIMARY KEY,
    LecturerID int  NOT NULL,
    TranslatorID int  NOT NULL,
    ServiceID int  NOT NULL,
    Type varchar(20)  CHECK(Type in ('Online', 'Hybrid', 'Stationary')) NOT NULL,
    Language varchar(50) CHECK (LEFT(Language, 1) = UPPER(LEFT(Language, 1))) NOT NULL,
	LinkNagranie varchar(50) NULL,
	StartDate datetime NOT NULL,
    EndDate datetime  NOT NULL,
	Limit int NULL,
	CONSTRAINT LecturesDateCheck CHECK (
	ISDATE(StartDate) = 1 AND
	ISDATE(EndDate) = 1 AND
	EndDate > StartDate
	),
	CONSTRAINT LecturesLimitCheck CHECK (
	Limit > 0 OR Limit IS NULL
	)
);

-- Table: Lectures_attendance
CREATE TABLE Lectures_attendance (
    CustomerID int  NOT NULL,
    LectureID int  NOT NULL,
    Attendance varchar(10) CHECK(Attendance in ('Present', 'Absent'))  NOT NULL,
    CONSTRAINT Lectures_attendance_pk PRIMARY KEY  (CustomerID,LectureID)
);



-- Table: Modules
CREATE TABLE Modules (
    ModuleID int  IDENTITY(1,1) PRIMARY KEY,
    ServiceID int  NOT NULL,
    ModuleName varchar(50) NOT NULL
);

-- Table: Order_details
CREATE TABLE Order_details (
    ServiceID int  NOT NULL,
    OrderID int  NOT NULL,
    UnitPrice money  NOT NULL,
    CONSTRAINT Order_details_pk PRIMARY KEY  (ServiceID,OrderID),
	CONSTRAINT Order_detailsUnitPriceCheck CHECK (
	UnitPrice >= 0
	)
);



-- Table: Orders
CREATE TABLE Orders (
    OrderID int  IDENTITY(1,1) PRIMARY KEY,
    CustomerID int  NOT NULL,
    OrderDate datetime CHECK(OrderDate >= '2019-01-01') NOT NULL,
    PaymentAssesed money  NOT NULL,
    PaymentPaid money  NOT NULL,
    PaymentWaived money  NOT NULL,
    DueDate datetime   NOT NULL,
    OrderStatus varchar(10) CHECK(OrderStatus in ('Ordered', 'InCart'))  NOT NULL,
	CONSTRAINT OrdersDateCheck CHECK (
	ISDATE(DueDate) = 1 AND
	ISDATE(OrderDate) = 1 AND
	DueDate > OrderDate
	),
	CONSTRAINT OrdersPaymentCheck CHECK (
	PaymentAssesed >= 0 AND
	PaymentPaid >= 0 AND
	PaymentWaived >= 0 AND
	PaymentAssesed >= PaymentPaid
	)
);

-- Table: Services
CREATE TABLE Services (
    ServiceID int  PRIMARY KEY,
    PriceInAdvance money   NOT NULL,
    PriceWhole money  NOT NULL,
	CONSTRAINT ServicesPriceCheck CHECK (
	PriceInAdvance >= 0 AND
	PriceWhole >= 0 AND 
	PriceInAdvance <= PriceWhole
	)
);

-- Table: Single_Studies
CREATE TABLE Single_Studies (
    ServiceID int IDENTITY(4,4) PRIMARY KEY,
	LectureID int NOT NULL,
    Major varchar(50)  CHECK (LEFT(Major, 1) = UPPER(LEFT(Major, 1))) NOT NULL,
	Type varchar(20)  CHECK(Type in ('Online', 'Hybrid', 'Stationary')) NOT NULL, 
    PriceInAdvance money   NOT NULL,
    PriceWhole money  NOT NULL,
	Limit int NULL,
	CONSTRAINT Single_StudiesPriceCheck CHECK (
	PriceInAdvance >= 0 AND
	PriceWhole >= 0 AND 
	PriceInAdvance <= PriceWhole
	),
	CONSTRAINT Single_StudiesLimitCheck CHECK (
	Limit > 0 OR Limit IS NULL
	)
);



-- Table: Studies
CREATE TABLE Studies (
    ServiceID int IDENTITY(2,4) PRIMARY KEY,
    SyllabusID int  NOT NULL,
    Major varchar(50)  CHECK (LEFT(Major, 1) = UPPER(LEFT(Major, 1))) NOT NULL,
    StartDate datetime CHECK(StartDate >= '2019-01-01') NOT NULL,
    EndDate datetime   NOT NULL,
    PriceInAdvance money  NOT NULL,
    PriceWhole money  NOT NULL,
	Limit int NULL,
	CONSTRAINT StudiesDateCheck CHECK (
	ISDATE(StartDate) = 1 AND
	ISDATE(EndDate) = 1 AND
	EndDate > StartDate
	),
	CONSTRAINT StudiesPriceCheck CHECK (
	PriceInAdvance >= 0 AND
	PriceWhole >= 0 AND 
	PriceInAdvance <= PriceWhole
	),
	CONSTRAINT StudiesLimitCheck CHECK (
	Limit > 0 OR Limit IS NULL
	)
);



-- Table: Subjects
CREATE TABLE Subjects (
    SubjectID int  IDENTITY(1,1) PRIMARY KEY,
    LecturerID int  NOT NULL,
    SubjectName varchar(50) CHECK (LEFT(SubjectName, 1) = UPPER(LEFT(SubjectName, 1))) NOT NULL,
    SubjectDescription varchar(200) NOT NULL,
    Hours int  NOT NULL,
    Assessment varchar(30) CHECK(Assessment in ('Attendance', 'Exam', 'Internship'))NOT NULL,
	CONSTRAINT SubjectsHoursCheck CHECK (
	Hours > 0
	)
);



-- Table: Syllabus
CREATE TABLE Syllabus (
    SyllabusID int IDENTITY(1,1) PRIMARY KEY,
    SyllabusName varchar(50) CHECK (LEFT(SyllabusName, 1) = UPPER(LEFT(SyllabusName, 1))) NOT NULL,
);

-- Table: Syllabus_details
CREATE TABLE Syllabus_details (
    SyllabusID int  NOT NULL,
    SubjectID int  NOT NULL,
    CONSTRAINT Syllabus_details_pk PRIMARY KEY  (SubjectID,SyllabusID)
);

-- Table: Translator
CREATE TABLE Translator (
    TranslatorID int  IDENTITY(1,1) PRIMARY KEY,
    FirstName varchar(50) CHECK (LEFT(FirstName, 1) = UPPER(LEFT(FirstName, 1))) NOT NULL,
    LastName varchar(50) CHECK (LEFT(LastName, 1) = UPPER(LEFT(LastName, 1))) NOT NULL,
);

-- Table: Languages
CREATE TABLE Languages (
    LanguageID int  IDENTITY(1,1) PRIMARY KEY,
    LanguageName varchar(50)  NOT NULL,
);

-- Table: Translator_details
CREATE TABLE Translator_details (
    TranslatorID int  NOT NULL,
    LanguageID int  NOT NULL,
    CONSTRAINT Translator_details_pk PRIMARY KEY  (TranslatorID,LanguageID)
);



	-- Table: Webinars
CREATE TABLE Webinars (
    ServiceID int  IDENTITY(1,4) PRIMARY KEY,
    WebinarName varchar(50)  CHECK (LEFT(WebinarName, 1) = UPPER(LEFT(WebinarName, 1))) NOT NULL,
	StartDate datetime CHECK(StartDate >= '2019-01-01') NOT NULL,
    EndDate datetime  NOT NULL,
    PriceInAdvance money   NOT NULL,
    PriceWhole money  NOT NULL,
	CONSTRAINT WebinarsDateCheck CHECK (
	ISDATE(StartDate) = 1 AND
	ISDATE(EndDate) = 1 AND
	EndDate > StartDate
	),
	CONSTRAINT WebinarsPriceCheck CHECK (
	PriceInAdvance >= 0 AND
	PriceWhole >= 0 AND 
	PriceInAdvance <= PriceWhole
	)
);
--Table: Webinars_attendance
CREATE TABLE Webinars_attendance (
    WebinarID int  NOT NULL,
    CustomerID int  NOT NULL,
    Attendance varchar(10)  NOT NULL,
    CONSTRAINT Webinars_attendance_pk PRIMARY KEY  (CustomerID,WebinarID)
);

-- Table: Webinars_hist
CREATE TABLE Webinars_hist (
	WebinarID int IDENTITY(1,1) PRIMARY KEY,
    ServiceID int  NOT NULL,
    LecturerID int  NOT NULL,
    TranslatorID int  NOT NULL,
	StartDate datetime CHECK(StartDate >= '2019-01-01')  NOT NULL,
    EndDate datetime  NOT NULL,	
	LinkNagranie varchar(50)  NOT NULL,
	CONSTRAINT Webinars_histDateCheck CHECK (
	ISDATE(StartDate) = 1 AND
	ISDATE(EndDate) = 1 AND
	EndDate > StartDate
	)
);

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

	-- Reference: Services_Single_Studies (table: Single_Studies)
ALTER TABLE Single_Studies ADD CONSTRAINT Services_Single_Studies
    FOREIGN KEY (ServiceID)
    REFERENCES Services (ServiceID);

	-- Reference: Lectures_Single_Studies (table: Single_Studies)
ALTER TABLE Single_Studies ADD CONSTRAINT Lectures_Single_Studies
    FOREIGN KEY (LectureID)
    REFERENCES Lectures(LectureID);

	-- Reference: Studies_Services (table: Studies)
ALTER TABLE Studies ADD CONSTRAINT Studies_Cennik
    FOREIGN KEY (ServiceID)
    REFERENCES Services (ServiceID);

-- Reference: Studies_Syllabus (table: Studies)
ALTER TABLE Studies ADD CONSTRAINT Studies_Syllabus
    FOREIGN KEY (SyllabusID)
    REFERENCES Syllabus (SyllabusID);


-- Reference: Syllabus_details_Subjects (table: Syllabus_details)
ALTER TABLE Syllabus_details ADD CONSTRAINT Syllabus_details_Subjects
    FOREIGN KEY (SubjectID)
    REFERENCES Subjects (SubjectID);

-- Reference: Syllabus_details_Syllabus (table: Syllabus_details)
ALTER TABLE Syllabus_details ADD CONSTRAINT Syllabus_details_Syllabus
    FOREIGN KEY (SyllabusID)
    REFERENCES Syllabus (SyllabusID);

-- Reference: Subjects_Lecturers (table: Subjects)
ALTER TABLE Subjects ADD CONSTRAINT Subjects_Lecturers
    FOREIGN KEY (LecturerID)
    REFERENCES Lecturers (LecturerID);


-- Reference: Translator_details_Languages (table: Translator_details)
ALTER TABLE Translator_details ADD CONSTRAINT Translator_details_Languages
    FOREIGN KEY (LanguageID)
    REFERENCES Languages (LanguageID);

-- Reference: Translator_details_Translator (table: Translator_details)
ALTER TABLE Translator_details ADD CONSTRAINT Translator_details_Translator
    FOREIGN KEY (TranslatorID)
    REFERENCES Translator (TranslatorID);

	-- Reference: Webinars_Services(table: Webinars)
ALTER TABLE Webinars ADD CONSTRAINT Webinars_Services
    FOREIGN KEY (ServiceID)
    REFERENCES Services (ServiceID);
		
-- Reference: Webinars_attendance_Customers (table: Webinars_attendance)
ALTER TABLE Webinars_attendance ADD CONSTRAINT Webinars_attendance_Customers
    FOREIGN KEY (CustomerID)
    REFERENCES Customers (CustomerID);

-- Reference: Webinars_attendance_Webinars_hist (table: Webinars_attendance)
ALTER TABLE Webinars_attendance ADD CONSTRAINT Webinars_attendance_Webinars_hist
    FOREIGN KEY (WebinarID)
    REFERENCES Webinars_hist (WebinarID);


