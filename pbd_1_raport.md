Król Mateusz 
Zieliński Filip 
Wietrzny Wojciech
# RAPORT PROJEKTU Z PODSTAW BAZ DANYCH 23/24
## System bazy danych firmy oferującej usługi naukowe
## Spis treści
1. [Opis systemu](#opis)
2. [Funkcje realizowane przez system](#funkcje)
    1. [Klient firmy](#klient)
    2. [Pracownicy](#pracownicy)
        1. [Wykładowcy](#wykladowcy)
        2. [Pracownicy organizacyjni](#pracownicyorgy)
        3. [Dyrektor Szkoły](#dyro)
3. [Diagram Bazy Danych](#diagram)
4. [Realizowane tabele](#tabels)
    1. [Customers and Purchase](#c&p)
    2. [Studies](#std)
    3. [Webinars](#web)
    4. [Kursy](#crs)
    5. [Common tables](#ctb)
5. [Widoki](#widoki)
6. [Funkcje](#funkcje)
7. [Procedury](#procedury)

![diagram](diagram_photo.png)

## 1.	Opis systemu <a name="opis"></a>
Firma oferuje różnorakie usługi uczelniane w postaci kursów, webinarów oraz umożliwia zapis na studia. Zajęcia przeprowadzane są w formie stacjonarnej, online bądź hybrydowej, zależnie od typu usługi.

Klient może zakupić równolegle dostęp do wielu usług lub uzyskać dostęp do darmowych spotkań i nagrań.

System zawiera informacje o założonych kontach, wykupionych usługach, statusach zajęć oraz płatności oraz możliwość modyfikacji poszczególnych danych, przez uprawnione do tego jednostki.

## 2.	Funkcje realizowane przez system <a name="funkcje"></a>
### 2.1.	Klient firmy <a name="klient"></a>
- Wyświetlanie oferty usług świadczonych przez firmę
- Zapisanie się na webinary, kursy, studia lub pojedyncze zajęcia ze studiów
- Dostęp do:
    - Własnego harmonogramu zajęć
    - Historii odbytych zajęć wraz ze statusem obecności
    - Zakupionych usług
    - Bilansu konta
    - Darmowych bądź zakupionych nagrań świadczonych usług
- Dodanie wybranych usług do koszyka
- Dokonanie płatności za usługi 
- Zakup nagrań świadczonych usług
- Odebranie dyplomu po zakończonym cyklu zajęć
- Wyświetlanie zajęć kolidujących ze sobą
### 2.2. Pracownicy <a name="pracownicy"></a>
#### 2.2.1.	Wykładowcy <a name="wykladowcy"></a>
- Dostęp do informacji dotyczących prowadzonych przez niego zajęć
- Wprowadzanie obecności na zajęciach
- Ustalanie zaliczeń po zakończonym cyklu zajęć
#### 2.2.2.	Pracownicy organizacyjni <a name="pracownicyorg"></a>
- Ustalanie i modyfikacje harmonogramu poszczególnych zajęć
- Obsługiwanie raportów o:
    - Zestawieniu przychodów dla każdego webinaru/kursu/studium.
    - Liście „dłużników” – osób, które skorzystały z usług, ale nie uiściły opłat.
    - Liczbie osób zapisanych na przyszłe wydarzenia.
    - Frekwencji na zakończonych już wydarzeniach.
    - Liście obecności dla każdego szkolenia z datą, imieniem, nazwiskiem i informacją czy uczestnik był obecny, czy nie
    - Bilokacji: lista osób, które są zapisane na co najmniej dwa przyszłe szkolenia, które ze sobą kolidują czasowo
- Dodawanie tłumacza na wydarzenia
#### 2.2.3.	Dyrektor Szkoły <a name="dyro"></a>
- Zatwierdzanie wyjątków dotyczących odroczenia płatności  
## 3.    Diagram Bazy Danych <a name="diagram"></a>
 


## 4.    Realizowane tabele <a name="tables"></a>
### 4.1    *Customers and Purchase* <a name="c&p"></a>
#### 4.1.1    Customers
- PK: CustomerID
- Opis: Tabela przechowuje informacje na temat klientów firmy/studentów

```sql
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

ALTER TABLE Courses ADD CONSTRAINT Courses_Cennik
    FOREIGN KEY (ServiceID)
    REFERENCES Services (ServiceID);
```

#### 4.1.2    Orders
- PK: OrderID
- FK: CustomerID
- Opis: Tabela przechowuje spis wszystkich przeszłych zamówień, pole *OrderStatus* wskazuje na to, czy zamówienie jest na razie w koszyku, czy zostało już zrealizowane

```sql
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
	PaymentAssesed > 0 AND
	PaymentPaid > 0 AND
	PaymentWaived >= 0 AND
	PaymentAssesed >= PaymentPaid
	)
);

ALTER TABLE Orders ADD CONSTRAINT Orders_Customers
    FOREIGN KEY (CustomerID)
    REFERENCES Customers (CustomerID);
```
#### 4.1.3    Order_details
- PK: OrderID, ServiceID
- FK: OrderID, ServiceID
- Opis: Tabela przechowuje informacje na temat każdego z zamówień z tabeli *Orders*

```sql
CREATE TABLE Order_details (
    ServiceID int  NOT NULL,
    OrderID int  NOT NULL,
    UnitPrice money  NOT NULL,
    CONSTRAINT Order_details_pk PRIMARY KEY  (ServiceID,OrderID),
	CONSTRAINT Order_detailsUnitPriceCheck CHECK (
	UnitPrice >= 0
	)
);

ALTER TABLE Order_details ADD CONSTRAINT Order_details_Orders
    FOREIGN KEY (OrderID)
    REFERENCES Orders (OrderID);
```
#### 4.1.4    Services
- PK: ServiceID
- Opis: Tabela przechowuje wszystkie usługi wraz z ceną

```sql
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
```
&nbsp;
### 4.2    *Studies* <a name="std"></a>
#### 4.2.1  Studies
- PK: ServiceID
- FK: ServiceID, SyllabusID
- Opis: Tabela przechowuje wszystkie realizowane studia teraz i w przeszłości

```sql
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

ALTER TABLE Studies ADD CONSTRAINT Studies_Cennik
    FOREIGN KEY (ServiceID)
    REFERENCES Services (ServiceID);

ALTER TABLE Studies ADD CONSTRAINT Studies_Syllabus
    FOREIGN KEY (SyllabusID)
    REFERENCES Syllabus (SyllabusID);
```
#### 4.2.2  SingleStudies
- PK: ServiceID
- FK: ServiceID
- Opis: Tabela przechowuje możliwe pojedyncze zajęcia studyjne

```sql
CREATE TABLE Single_Studies (
    ServiceID int IDENTITY(4,4) PRIMARY KEY,
	LectureID int NOT NULL,
    Major varchar(50)  CHECK (LEFT(Major, 1) = UPPER(LEFT(Major, 1))) NOT NULL,
	Type varchar(20)  CHECK(Type in ('Online', 'Hybrid', 'Stationary')) NOT NULL, 
	Limit int NULL,
    PriceInAdvance money   NOT NULL,
    PriceWhole money  NOT NULL,
	CONSTRAINT Single_StudiesPriceCheck CHECK (
	PriceInAdvance >= 0 AND
	PriceWhole >= 0 AND 
	PriceInAdvance <= PriceWhole
	),
	CONSTRAINT Single_StudiesLimitCheck CHECK (
	Limit > 0 OR Limit IS NULL
	)
);

ALTER TABLE Single_Studies ADD CONSTRAINT Services_Single_Studies
    FOREIGN KEY (ServiceID)
    REFERENCES Services (ServiceID);

ALTER TABLE Single_Studies ADD CONSTRAINT Lectures_Single_Studies
    FOREIGN KEY (LectureID)
    REFERENCES Lectures(LectureID);
```
#### 4.2.3  Lectures
- PK: LectureID
- FK: ServiceID, LecturerID, TranslatorID
- Opis: Tabela przechowuje wszystkie histoyczne wykłady zajęć studyjnych

```sql
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

ALTER TABLE Lectures ADD CONSTRAINT Lectures_Lecturers
    FOREIGN KEY (LecturerID)
    REFERENCES Lecturers (LecturerID);

ALTER TABLE Lectures ADD CONSTRAINT Lectures_Studies
    FOREIGN KEY (ServiceID)
    REFERENCES Studies (ServiceID);

ALTER TABLE Lectures ADD CONSTRAINT Lectures_Translator
    FOREIGN KEY (TranslatorID)
    REFERENCES Translator (TranslatorID);
```
#### 4.2.4  Lectures_attendance
- PK: CustomerID, LectureID
- FK: CustomerID, LectureID
- Opis: Tabela przechowuje listę obecności każdego wykładu
```sql
CREATE TABLE Lectures_attendance (
    CustomerID int  NOT NULL,
    LectureID int  NOT NULL,
    Attendance varchar(10) CHECK(Attendance in ('Present', 'Absent'))  NOT NULL,
    CONSTRAINT Lectures_attendance_pk PRIMARY KEY  (CustomerID,LectureID)
);

ALTER TABLE Lectures_attendance ADD CONSTRAINT Lectures_attendance_Lectures
    FOREIGN KEY (LectureID)
    REFERENCES Lectures (LectureID);

ALTER TABLE Lectures_attendance ADD CONSTRAINT Lectures_details_Customers
    FOREIGN KEY (CustomerID)
    REFERENCES Customers (CustomerID);
```
#### 4.2.5  Exams
- PK: CustomerID, ServiceID
- FK: CustomerID, ServiceID
- Opis: Tabela przechowuje listę egzaminów każdego ze studentów

```sql
CREATE TABLE Exams (
    ServiceID int  NOT NULL,
    CustomerID int  NOT NULL,
    Grade float(1) CHECK (Grade in (2.0,3.0,3.5,4.0,4.5,5.0))  NOT NULL,
    CONSTRAINT Exams_pk PRIMARY KEY  (ServiceID,CustomerID)
);

ALTER TABLE Exams ADD CONSTRAINT Exams_Customers
    FOREIGN KEY (CustomerID)
    REFERENCES Customers (CustomerID);

ALTER TABLE Exams ADD CONSTRAINT Exams_Studies
    FOREIGN KEY (ServiceID)
    REFERENCES Studies (ServiceID);
```
#### 4.2.6  Diplomas
- PK: DiplomaID
- FK: CustomerID, ServiceID
- Opis: Tabela przechowuje dyplomy przyznane za ukończenie studiów

```sql
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

ALTER TABLE Diplomas ADD CONSTRAINT Diplomas_Exams
    FOREIGN KEY (ServiceID,CustomerID)
    REFERENCES Exams (ServiceID,CustomerID);
```
#### 4.2.7  Internships
- PK: InternshipID
- FK: ServiceID
- Opis: Tabela przechowuje praktyki z każdych studiów

```sql
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

ALTER TABLE Internships ADD CONSTRAINT Internships_Studies
    FOREIGN KEY (ServiceID)
    REFERENCES Studies (ServiceID);
```
#### 4.2.8  Internships_passed
- PK: InternshipID, CustomerID
- FK: InternshipID, CustomerID
- Opis: Tabela przechowuje informację, czy praktyka została zaliczona przez danego studenta

```sql
CREATE TABLE Internships_passed (
    InternshipID int  NOT NULL,
    CustomerID int  NOT NULL,
    Passed varchar(3) CHECK(Passed in ('Yes', 'No')) NOT NULL,
    CONSTRAINT Internships_passed_pk PRIMARY KEY  (InternshipID,CustomerID)
);

ALTER TABLE Internships_passed ADD CONSTRAINT Internships_passed_Customers
    FOREIGN KEY (CustomerID)
    REFERENCES Customers (CustomerID);

ALTER TABLE Internships_passed ADD CONSTRAINT Internships_passed_Internships
    FOREIGN KEY (InternshipID)
    REFERENCES Internships (InternshipID);
```
#### 4.2.9  Syllabus
- PK: SyllabusID
- Opis: Tabela przechowuje plan zajęć każdego z kierunków studiów

```sql
CREATE TABLE Syllabus (
    SyllabusID int IDENTITY(1,1) PRIMARY KEY,
    SyllabusName varchar(50) CHECK (LEFT(SyllabusName, 1) = UPPER(LEFT(SyllabusName, 1))) NOT NULL,
);
```
#### 4.2.10  Syllabus_details
- PK: SyllabusID, SubjectID
- FK: SyllabusID, SubjectID
- Opis: Tabela przechowuje przedmioty każdego z Syllabusów

```sql
CREATE TABLE Syllabus_details (
    SyllabusID int  NOT NULL,
    SubjectID int  NOT NULL,
    CONSTRAINT Syllabus_details_pk PRIMARY KEY  (SubjectID,SyllabusID)
);

ALTER TABLE Syllabus_details ADD CONSTRAINT Syllabus_details_Subjects
    FOREIGN KEY (SubjectID)
    REFERENCES Subjects (SubjectID);

ALTER TABLE Syllabus_details ADD CONSTRAINT Syllabus_details_Syllabus
    FOREIGN KEY (SyllabusID)
    REFERENCES Syllabus (SyllabusID);
```
#### 4.2.11 Subjects
- PK: SubjectID
- FK: LecturerID
- Opis: Tabela przechowuje informacje na temat każdego z przedmiotów studyjnych

```sql
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

ALTER TABLE Subjects ADD CONSTRAINT Subjects_Lecturers
    FOREIGN KEY (LecturerID)
    REFERENCES Lecturers (LecturerID);
```
&nbsp;
### 4.3   *Webinars* <a name="web"></a>
#### 4.3.1   Webinars
- PK: ServiceID
- FK: ServiceID
- Opis: Tabela przechowuje wszystkie webinary

```sql
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

ALTER TABLE Webinars ADD CONSTRAINT Webinars_Services
    FOREIGN KEY (ServiceID)
    REFERENCES Services (ServiceID);
```
#### 4.3.2   Webinars_hist
- PK: ServiceID, LecturerID
- FK: ServiceID, LecturerID, TranslatorID
- Opis: Tabela przechowuje informacje na temat każdego z webinarów

```sql
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

ALTER TABLE Webinars_hist ADD CONSTRAINT Webinars_hist_Lecturers
    FOREIGN KEY (LecturerID)
    REFERENCES Lecturers (LecturerID);

ALTER TABLE Webinars_hist ADD CONSTRAINT Webinars_hist_Translator
    FOREIGN KEY (TranslatorID)
    REFERENCES Translator (TranslatorID);

ALTER TABLE Webinars_hist ADD CONSTRAINT Webinars_hist_Webinars
    FOREIGN KEY (ServiceID)
    REFERENCES Webinars (ServiceID);
```
&nbsp;
### 4.3    *Kursy* <a name="crs"></a>
#### 4.3.1  Courses
- PK: ServiceID
- FK: ServiceID
- Opis: Tabela przechowuje wszystkie realizowane kursy teraz i w przeszłości

```sql
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

ALTER TABLE Courses ADD CONSTRAINT Courses_Cennik
    FOREIGN KEY (ServiceID)
    REFERENCES Services (ServiceID);
```
#### 4.3.2  Modules
- PK: ModuleID
- FK: ServiceID
- Opis: Tabela przechowuje listę modułów każdego z kursów

```sql
CREATE TABLE Modules (
    ModuleID int  IDENTITY(1,1) PRIMARY KEY,
    ServiceID int  NOT NULL,
    ModuleName varchar(50) NOT NULL
);

ALTER TABLE Modules ADD CONSTRAINT Modules_Courses
    FOREIGN KEY (ServiceID)
    REFERENCES Courses (ServiceID);
```
#### 4.3.3  Courses_hist
- PK: ClassID
- FK: ModuleID, LecturerID, TranslatorID
- Opis: Tabela przechowuje informacje o każdym module

```sql
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

ALTER TABLE Courses_hist ADD CONSTRAINT Courses_hist_Lecturers
    FOREIGN KEY (LecturerID)
    REFERENCES Lecturers (LecturerID);

ALTER TABLE Courses_hist ADD CONSTRAINT Courses_hist_Modules
    FOREIGN KEY (ModuleID)
    REFERENCES Modules (ModuleID);

ALTER TABLE Courses_hist ADD CONSTRAINT Courses_hist_Translator
    FOREIGN KEY (TranslatorID)
    REFERENCES Translator (TranslatorID);
```
#### 4.3.4  Courses_attendace
- PK: ClassID, CustomerID
- FK: ClassID, CustomerID
- Opis: Tabela przechowuje listę obecności każdego z modułów

```sql
CREATE TABLE Courses_attendance (
    ClassID int  NOT NULL,
    CustomerID int  NOT NULL,
    ModuleID int  NOT NULL,
    Attendance varchar(10) CHECK(Attendance in ('Present', 'Absent'))  NOT NULL,
    CONSTRAINT Courses_attendance_pk PRIMARY KEY  (CustomerID,ClassID)
);

ALTER TABLE Courses_attendance ADD CONSTRAINT Courses_attendance_Courses_hist
    FOREIGN KEY (ClassID)
    REFERENCES Courses_hist (ClassID);

ALTER TABLE Courses_attendance ADD CONSTRAINT Courses_attendance_Customers
    FOREIGN KEY (CustomerID)
    REFERENCES Customers (CustomerID);
```
&nbsp;
### 4.4 *Common tables* <a name="ctb"></a>
#### 4.4.1   Lecturers
- PK: LecturerID
- Opis: Tabela przechowuje informacje na temat każdego z wykładowców

```sql
CREATE TABLE Lecturers (
    LecturerID int IDENTITY(1,1) PRIMARY KEY,
    FirstName varchar(50) CHECK (LEFT(FirstName, 1) = UPPER(LEFT(FirstName, 1))) NOT NULL,
    LastName varchar(50) CHECK (LEFT(LastName, 1) = UPPER(LEFT(LastName, 1))) NOT NULL,
);

ALTER TABLE Lectures ADD CONSTRAINT Lectures_Lecturers
    FOREIGN KEY (LecturerID)
    REFERENCES Lecturers (LecturerID);

ALTER TABLE Lectures ADD CONSTRAINT Lectures_Studies
    FOREIGN KEY (ServiceID)
    REFERENCES Studies (ServiceID);

ALTER TABLE Lectures ADD CONSTRAINT Lectures_Translator
    FOREIGN KEY (TranslatorID)
    REFERENCES Translator (TranslatorID);
```
#### 4.4.2   Translator
- PK: TranslatorID
- Opis: Tabela przechowuje informacje na temat każdego z tłumaczy

```sql
CREATE TABLE Translator (
    TranslatorID int  IDENTITY(1,1) PRIMARY KEY,
    FirstName varchar(50) CHECK (LEFT(FirstName, 1) = UPPER(LEFT(FirstName, 1))) NOT NULL,
    LastName varchar(50) CHECK (LEFT(LastName, 1) = UPPER(LEFT(LastName, 1))) NOT NULL,
);
```
#### 4.4.3   Translator_details
- PK: TranslatorID, LanguageID
- FK: TranslatorID, LanguageID
- Opis: Tabela przechowuje informacje na temat języków, które zna każdy z tłumaczy

```sql
CREATE TABLE Translator_details (
    TranslatorID int  NOT NULL,
    LanguageID int  NOT NULL,
    CONSTRAINT Translator_details_pk PRIMARY KEY  (TranslatorID,LanguageID)
);

ALTER TABLE Translator_details ADD CONSTRAINT Translator_details_Languages
    FOREIGN KEY (LanguageID)
    REFERENCES Languages (LanguageID);

ALTER TABLE Translator_details ADD CONSTRAINT Translator_details_Translator
    FOREIGN KEY (TranslatorID)
    REFERENCES Translator (TranslatorID);
```
#### 4.4.4   Languages
- PK: LanguageID
- Opis: Tabela przechowuje informacje dostępnych języków

```sql
CREATE TABLE Languages (
    LanguageID int  IDENTITY(1,1) PRIMARY KEY,
    LanguageName varchar(50)  NOT NULL,
);
```
&nbsp;

## 5.	Widoki <a name="widoki"></a>

### 1. Raporty finansowe – zestawienie przychodów dla każdego webinaru/kursu/studium.

```sql
Create view dbo.FinancialRaport as(
select Major as Nazwa, sum(Services.PriceWhole) as Przychody, Studies.StartDate as Date
from Services 
join Studies 
on Services.ServiceID = Studies.ServiceID 
group by Major, Services.ServiceID, Studies.StartDate

union all

select Major as Nazwa ,sum(Services.PriceWhole) as Przychody, Lectures.StartDate as Date
from Services 
join Single_Studies 
on Services.ServiceID = Single_Studies.ServiceID 
join Lectures 
on Lectures.LectureID = Single_Studies.LectureID
group by Major, Services.ServiceID, Lectures.StartDate

union all

select WebinarName as Nazwa ,sum(Services.PriceWhole) as Przychody, Webinars.StartDate as Date
from Services 
join Webinars 
on Services.ServiceID = Webinars.ServiceID 
group by WebinarName, Services.ServiceID, Webinars.StartDate

union all

select CourseName as Nazwa, sum(Services.PriceWhole) as Przychody, Courses.StartDate as Date
from Services 
join Courses 
on Services.ServiceID = Courses.ServiceID 
group by CourseName, Services.ServiceID, Courses.StartDate)
```

### 2. Lista „dłużników” – osoby, które skorzystały z usług, ale nie uiściły opłat.

```sql
Create view dbo.DebtorsList as (
select FirstName, LastName, Balance
from Customers
where Balance < 0 and CustomerID in(
select Customers.CustomerID
from Customers
join Orders 
on Customers.CustomerID = Orders.CustomerID
join Order_Details 
on Orders.OrderID = Order_Details.OrderID
join Services 
on Order_Details.ServiceID = Services.ServiceID
join Studies 
on Services.ServiceID = Studies.ServiceID
where Studies.StartDate < GETDATE()
group by Customers.CustomerID

union

select Customers.CustomerID
from Customers
join Orders 
on Customers.CustomerID = Orders.CustomerID
join Order_Details 
on Orders.OrderID = Order_Details.OrderID
join Services 
on Order_Details.ServiceID = Services.ServiceID
join Single_studies 
on Services.ServiceID = Single_studies.ServiceID
join Lectures 
on Lectures.LectureID = Single_studies.LectureID
where Lectures.StartDate < GETDATE()
group by Customers.CustomerID

union

select Customers.CustomerID
from Customers
join Orders 
on Customers.CustomerID = Orders.CustomerID
join Order_Details 
on Orders.OrderID = Order_Details.OrderID
join Services 
on Order_Details.ServiceID = Services.ServiceID
join Webinars 
on Webinars.ServiceID = Services.ServiceID
where Webinars.StartDate < GETDATE()
group by Customers.CustomerID

union

select Customers.CustomerID
from Customers
join Orders 
on Customers.CustomerID = Orders.CustomerID
join Order_Details 
on Orders.OrderID = Order_Details.OrderID
join Services 
on Order_Details.ServiceID = Services.ServiceID
join Courses 
on Services.ServiceID = Courses.ServiceID
where Courses.StartDate < GETDATE()
group by Customers.CustomerID)
group by FirstName, LastName, Balance)
```


### 3. Ogólny raport dotyczący liczby zapisanych osób na przyszłe wydarzenia (z informacją, czy wydarzenie jest stacjonarnie, czy zdalnie).

```sql
Create view dbo.FutureEventsAttendance as(
select Lectures.ServiceID,Lectures.LecturerID,Lectures.Type as Typ, Lectures.StartDate,  count(Customers.CustomerID) as Liczba_Zapisanych_Osób
from Customers
join Orders 
on Customers.CustomerID = Orders.CustomerID
join Order_Details 
on Orders.OrderID = Order_Details.OrderID
join Services 
on Order_Details.ServiceID = Services.ServiceID
join Studies 
on Studies.ServiceID = Services.ServiceID
join Lectures 
on Lectures.ServiceID = Studies.ServiceID
where Lectures.StartDate > GETDATE()
group by Lectures.ServiceID,Lectures.LecturerID,Lectures.Type, Lectures.StartDate

union

select Lectures.ServiceID,Lectures.LecturerID,Single_Studies.Type as Typ, Lectures.StartDate,  count(Customers.CustomerID) as Liczba_Zapisanych_Osób
from Customers
join Orders 
on Customers.CustomerID = Orders.CustomerID
join Order_Details 
on Orders.OrderID = Order_Details.OrderID
join Services 
on Order_Details.ServiceID = Services.ServiceID
join Single_studies 
on Single_studies.ServiceID = Services.ServiceID
join Lectures 
on Lectures.ServiceID = Single_studies.ServiceID
where Lectures.StartDate > GETDATE()
group by Lectures.ServiceID,Lectures.LecturerID,Single_Studies.Type, Lectures.StartDate

union

select Webinars_hist.ServiceID,Webinars_hist.LecturerID, 'Zdalnie' as Typ, Webinars_hist.StartDate,  count(Customers.CustomerID) as Liczba_Zapisanych_Osób
from Customers
join Orders 
on Customers.CustomerID = Orders.CustomerID
join Order_Details 
on Orders.OrderID = Order_Details.OrderID
join Services 
on Order_Details.ServiceID = Services.ServiceID
join Webinars 
on Webinars.ServiceID = Services.ServiceID
join Webinars_hist 
on Webinars_hist.ServiceID = Webinars.ServiceID
where Webinars_hist.StartDate > GETDATE()
group by Webinars_hist.ServiceID, Webinars_hist.LecturerID, Webinars_hist.StartDate


union

select Courses_hist.ClassID,Courses_hist.LecturerID, Courses.Type as Typ, Courses_hist.StartDate,  count(Customers.CustomerID) as Liczba_Zapisanych_Osób
from Customers
join Orders 
on Customers.CustomerID = Orders.CustomerID
join Order_Details 
on Orders.OrderID = Order_Details.OrderID
join Services 
on Order_Details.ServiceID = Services.ServiceID
join Courses 
on Courses.ServiceID = Services.ServiceID
join Modules 
on Modules.ServiceID = Courses.ServiceID
join Courses_hist 
on Courses_hist.ModuleID = Modules.ModuleID
where Courses_hist.StartDate > GETDATE()
group by Courses_hist.ClassID,Courses_hist.LecturerID, Courses.Type,  Courses_hist.StartDate)
```

### 4. Ogólny raport dotyczący frekwencji na zakończonych już wydarzeniach.

```sql
-- empty
```

### 5. Lista obecności dla każdego szkolenia z datą, imieniem, nazwiskiem i informacją czy uczestnik był obecny, czy nie.

```sql
create view AttendanceList as
select
    'Studies' as ServiceType,
    Studies.ServiceID as ServiceID,
    Lectures.StartDate as Date,
    c.FirstName,
    c.LastName,
    Lectures_attendance.Attendance as AttendanceStatus
from
    Studies
    join Lectures 
    on Studies.ServiceID = Lectures.ServiceID
    join Lectures_attendance 
    on Lectures.LectureID = Lectures_attendance.LectureID
    join Customers c 
    on Lectures_attendance.CustomerID = c.CustomerID

union 

select
    'Single_Studies' as ServiceType,
    Single_Studies.ServiceID as ServiceID,
    Lectures.StartDate as Date,
    Customers.FirstName,
    Customers.LastName,
    Lectures_attendance.Attendance as AttendanceStatus
from
    Single_Studies 
    join Lectures 
    on Single_Studies.LectureID = Lectures.LectureID
    join Lectures_attendance 
    on Lectures.LectureID = Lectures_attendance.LectureID
    join Customers 
    on Lectures_attendance.CustomerID = Customers.CustomerID

union 

select
    'Webinars' as ServiceType,
    w.ServiceID as ServiceID,
    Webinars_hist.StartDate as Date,
    c.FirstName,
    c.LastName,
    Webinars_attendance.Attendance as AttendanceStatus
from
    Webinars w
    join Webinars_hist Webinars_hist 
    on w.ServiceID = Webinars_hist.ServiceID
    join Webinars_attendance Webinars_attendance 
    on Webinars_hist.WebinarID = Webinars_attendance.WebinarID
    join Customers c 
    on Webinars_attendance.CustomerID = c.CustomerID

union

select
    'Courses' as ServiceType,
    Courses.ServiceID as ServiceID,
    Courses_hist.StartDate as Date,
    Customers.FirstName,
    Customers.LastName,
    Courses_attendance.Attendance as AttendanceStatus
from
    Courses
	join Modules 
    on Courses.ServiceID = Modules.ServiceID
    join Courses_hist 
    on Courses.ServiceID = Modules.ServiceID
    join Courses_attendance 
    on Courses_hist.ClassID = Courses_attendance.ClassID
    join Customers 
    on Courses_attendance.CustomerID = Customers.CustomerID;
```

### 6. Raport bilokacji: lista osób, które są zapisane na co najmniej dwa przyszłe szkolenia, które ze sobą kolidują czasowo.

```sql
-- empty
```

## 6. Funkcje <a name="funkcje"></a>

### 1. Koszyk studenta
 - Parametr: CustomerID

```sql
CREATE FUNCTION GetCustomerCart (@CustomerID INT)
RETURNS TABLE
AS
RETURN (
    select * from Orders
	where CustomerID = @CustomerID AND OrderStatus = 'InCart'
)
```
### 2. Harmonogram studiów
 - Parametr: ServiceID

```sql
CREATE FUNCTION GetStudiesSchedule (@ServiceID INT)
RETURNS TABLE
AS
RETURN (
    SELECT * from Lectures 
	where Lectures.ServiceID = @ServiceID
)
```
### 3. Harmonogram przyszłych zajęć dla użytkownika
 - Parametr: CustomerID
```sql
CREATE FUNCTION GetCustomerSchedule (@CustomerID INT)
RETURNS TABLE
AS
RETURN (
	WITH t1 AS (
		SELECT s.ServiceID 
		FROM Orders o
		JOIN Order_details od ON o.OrderID = od.OrderID
		JOIN Services s ON od.ServiceID = s.ServiceID
		WHERE o.CustomerID = @CustomerID
	)

	SELECT t1.ServiceID, l.LectureID, l.Date
	FROM t1
	JOIN Studies s ON t1.ServiceID = s.ServiceID
	JOIN Lectures l ON s.ServiceID = l.ServiceID
	WHERE l.Date > GETDATE()

	UNION

	SELECT t1.ServiceID, w.ServiceID, w.Date
	FROM t1
	JOIN Webinars w ON t1.ServiceID = w.ServiceID
	WHERE w.Date > GETDATE()

	UNION

	SELECT t1.ServiceID, m.ModuleID, ch.Date
	FROM t1
	JOIN Courses c ON t1.ServiceID = c.ServiceID
	JOIN Modules m ON c.ServiceID = m.ServiceID
	JOIN Courses_hist ch ON m.ModuleID = ch.ModuleID
	WHERE ch.Date > GETDATE()
);
```

## 7.	Procedury <a name="procedury"></a>

### 1. Dodanie klienta

```sql
CREATE PROCEDURE AddCustomer
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Balance MONEY,
    @Email VARCHAR(50),
    @City VARCHAR(50),
    @Street VARCHAR(50),
    @Address VARCHAR(10),
    @PostalCode VARCHAR(10)
AS
BEGIN
    DECLARE @NextCustomerID INT;

    SELECT @NextCustomerID = ISNULL(MAX(CustomerID), 0) + 1 FROM Customers;

    INSERT INTO Customers (CustomerID, FirstName, LastName, Balance, Email, City, Street, Address, PostalCode)
    VALUES (@NextCustomerID, @FirstName, @LastName, @Balance, @Email, @City, @Street, @Address, @PostalCode);

    PRINT 'Klient dodany pomyślnie.'
END;
```

### 2. Dodanie wykładowcy

```sql
CREATE PROCEDURE AddLecturer
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50)
AS
BEGIN
    DECLARE @NextLecturerID INT;

    SELECT @NextLecturerID = ISNULL(MAX(LecturerID), 0) + 1 FROM Lecturers;

    INSERT INTO Lecturers (LecturerID, FirstName, LastName)
    VALUES (@NextLecturerID, @FirstName, @LastName);

    PRINT 'Wykładowca dodany pomyślnie.';
END;
```

### 3. Dodanie tłumacza

```sql
CREATE PROCEDURE AddTranslator
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Language VARCHAR(50)
AS
BEGIN
    DECLARE @NextTranslatorID INT;

    SELECT @NextTranslatorID = ISNULL(MAX(TranslatorID), 0) + 1 FROM Translator;

    INSERT INTO Translator (TranslatorID, FirstName, LastName, Language)
    VALUES (@NextTranslatorID, @FirstName, @LastName, @Language);

    PRINT 'Translator dodany pomyślnie.';
END;
```

### 4. Dodanie Webinara

```sql
CREATE PROCEDURE AddWebinar
    @WebinarName VARCHAR(50),
    @Date DATETIME,
    @PriceInAdvance MONEY,
    @PriceWhole MONEY,
    @TranslatorID INT,
    @LecturerID INT
AS
BEGIN
    DECLARE @NextServiceID INT;

    IF @LecturerID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Lecturers WHERE LecturerID = @LecturerID)
    BEGIN
        PRINT 'Błąd: Nieprawidłowy LecturerID.';
        RETURN;
    END

    IF @TranslatorID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Translator WHERE TranslatorID = @TranslatorID)
    BEGIN
        PRINT 'Błąd: Nieprawidłowy TranslatorID.';
        RETURN;
    END

    SELECT @NextServiceID = ISNULL(MAX(ServiceID), -3) + 4 FROM Webinars;

    INSERT INTO Services (ServiceID, PriceInAdvance, PriceWhole)
    VALUES (@NextServiceID, @PriceInAdvance, @PriceWhole);

    INSERT INTO Webinars (ServiceID, WebinarName, Date, PriceInAdvance, PriceWhole)
    VALUES (@NextServiceID, @WebinarName, @Date, @PriceInAdvance, @PriceWhole);

    INSERT INTO Webinars_hist (ServiceID, TranslatorID, LecturerID, Date, LinkNagranie)
    VALUES (@NextServiceID, @TranslatorID, @LecturerID, @Date, '');

    PRINT 'Webinar dodany pomyślnie.';
END;
```

### 5. Dodanie przedmiotu

```sql
CREATE PROCEDURE AddSubject
    @SubjectName VARCHAR(50),
    @SubjectDescription INT,
    @Hours INT,
    @Assessment INT,
    @LecturerID INT
AS
BEGIN
    DECLARE @NextSubjectID INT;

    IF @LecturerID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Lecturers WHERE LecturerID = @LecturerID)
    BEGIN
        PRINT 'Błąd: Nieprawidłowy LecturerID.';
        RETURN;
    END

    SELECT @NextSubjectID = ISNULL(MAX(SubjectID), 0) + 1 FROM Subjects;

    INSERT INTO Subjects (SubjectID, LecturerID, SubjectName, SubjectDescription, Hours, Assessment)
    VALUES (@NextSubjectID, @LecturerID, @SubjectName, @SubjectDescription, @Hours, @Assessment);

    PRINT 'Przedmiot dodany pomyślnie. Przydzielony SubjectID: ' + CAST(@NextSubjectID AS VARCHAR);
END;
```

### 6. Dodanie Syllabusa

```sql
CREATE PROCEDURE AddSyllabus
    @SubjectID INT,
    @SyllabusName VARCHAR(50)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Subjects WHERE SubjectID = @SubjectID)
    BEGIN
        PRINT 'Błąd: Podane SubjectID nie istnieje.';
        RETURN;
    END

    DECLARE @NextSyllabusID INT;

    SELECT @NextSyllabusID = ISNULL(MAX(SyllabusID), 0) + 1 FROM Syllabus;

    INSERT INTO Syllabus (SyllabusID, SubjectID, SyllabusName)
    VALUES (@NextSyllabusID, @SubjectID, @SyllabusName);

    PRINT 'Plan studiów dodany pomyślnie.';
END;
```

### 7. Dodanie studiów

```sql
CREATE PROCEDURE AddStudies
    @SyllabusID INT,
    @Major VARCHAR(50),
    @StartDate DATE,
    @EndDate DATE,
    @PriceInAdvance MONEY,
    @PriceWhole MONEY
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Syllabus WHERE SyllabusID = @SyllabusID)
    BEGIN
        PRINT 'Błąd: Podane SyllabusID nie istnieje.';
        RETURN;
    END

    DECLARE @NextServiceID INT;

    SELECT @NextServiceID = ISNULL(MAX(ServiceID), -2) + 4 FROM Studies;

    INSERT INTO Services (ServiceID, PriceInAdvance, PriceWhole)
    VALUES (@NextServiceID, @PriceInAdvance, @PriceWhole);

    INSERT INTO Studies (ServiceID, SyllabusID, Major, StartDate, EndDate, PriceInAdvance, PriceWhole)
    VALUES (@NextServiceID, @SyllabusID, @Major, @StartDate, @EndDate, @PriceInAdvance, @PriceWhole);

    PRINT 'Studia dodane pomyślnie.';
END;
```

### 8. Dodanie stażu

```sql
CREATE PROCEDURE AddInternship
    @InternshipName VARCHAR(200),
    @InternshipDescription VARCHAR(200),
    @ServiceID INT,
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Services WHERE ServiceID = @ServiceID)
    BEGIN
        PRINT 'Błąd: Podane ServiceID nie istnieje.';
        RETURN;
    END

    DECLARE @NextInternshipID INT;

    SELECT @NextInternshipID = ISNULL(MAX(InternshipID), 0) + 1 FROM Internships;

    INSERT INTO Internships (InternshipID, InternshipName, InternshipDescription, ServiceID, StartDate, EndDate)
    VALUES (@NextInternshipID, @InternshipName, @InternshipDescription, @ServiceID, @StartDate, @EndDate);

    PRINT 'Internship dodane pomyślnie.';
END;
```

### 9. Dodanie zaliczonych stażów

```sql
CREATE PROCEDURE AddInternshipPassed
    @InternshipID INT,
    @CustomerID INT,
    @Passed VARCHAR(3)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Internships WHERE InternshipID = @InternshipID)
    BEGIN
        PRINT 'Błąd: Podane InternshipID nie istnieje.';
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Customers WHERE CustomerID = @CustomerID)
    BEGIN
        PRINT 'Błąd: Podane CustomerID nie istnieje.';
        RETURN;
    END

    DECLARE @NextInternshipPassedID INT;

    SELECT @NextInternshipPassedID = ISNULL(MAX(InternshipPassedID), 0) + 1 FROM Internships_passed;

    INSERT INTO Internships_passed (InternshipPassedID, InternshipID, CustomerID, Passed)
    VALUES (@NextInternshipPassedID, @InternshipID, @CustomerID, @Passed);

    PRINT 'Zaliczenie stażu dodane pomyślnie.';
END;
```
