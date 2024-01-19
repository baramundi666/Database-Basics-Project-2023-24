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
CREATE TABLE Customers (
    CustomerID int  NOT NULL,
    FirstName varchar(50)  NOT NULL,
    LastName varchar(50)  NOT NULL,
    Balance money  NOT NULL,
    Email varchar(50)  NOT NULL,
    City varchar(50)  NOT NULL,
    Street varchar(50)  NOT NULL,
    Address varchar(50)  NOT NULL,
    PostalCode varchar(50)  NOT NULL,
    CONSTRAINT Customer_ID PRIMARY KEY  (CustomerID)
);
```
#### 4.1.2    Orders
- PK: OrderID
- FK: CustomerID
- Opis: Tabela przechowuje spis wszystkich przeszłych zamówień, pole *OrderStatus* wskazuje na to, czy zamówienie jest na razie w koszyku, czy zostało już zrealizowane
```sql
CREATE TABLE Orders (
    OrderID int  NOT NULL,
    CustomerID int  NOT NULL,
    OrderDate date  NOT NULL,
    PaymentAssesed money  NOT NULL,
    PaymentPaid money  NOT NULL,
    PaymentWaived money  NOT NULL,
    DueDate date  NOT NULL,
    OrderStatus varchar(3)  NOT NULL,
    CONSTRAINT Orders_pk PRIMARY KEY  (OrderID)
);
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
    CONSTRAINT Order_details_pk PRIMARY KEY  (ServiceID,OrderID)
);
```
#### 4.1.4    Services
- PK: ServiceID
- Opis: Tabela przechowuje wszystkie usługi wraz z ceną
```sql
CREATE TABLE Services (
    ServiceID int  NOT NULL,
    PriceInAdvance money  NOT NULL,
    PriceWhole money  NOT NULL,
    CONSTRAINT Services_pk PRIMARY KEY  (ServiceID)
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
    ServiceID int  NOT NULL,
    SyllabusID int  NOT NULL,
    Major varchar(50)  NOT NULL,
    Type varchar(30)  NOT NULL,
    StartDate date  NOT NULL,
    EndDate date  NOT NULL,
    PriceInAdvance money  NOT NULL,
    PriceWhole money  NOT NULL,
    CONSTRAINT Studies_pk PRIMARY KEY  (ServiceID)
);
```
#### 4.2.2  SingleStudies
- PK: ServiceID
- FK: ServiceID
- Opis: Tabela przechowuje możliwe pojedyncze zajęcia studyjne
```sql
CREATE TABLE Single_Studies (
    ServiceID int  NOT NULL,
    Major varchar(50)  NOT NULL,
    Type varchar(20)  NOT NULL,
    Date datetime  NOT NULL,
    PriceInAdvance money  NOT NULL,
    PriceWhole money  NOT NULL,
    CONSTRAINT Single_Studies_pk PRIMARY KEY  (ServiceID)
);
```
#### 4.2.3  Lectures
- PK: LectureID
- FK: ServiceID, LecturerID, TranslatorID
- Opis: Tabela przechowuje wszystkie histoyczne wykłady zajęć studyjnych
```sql
CREATE TABLE Lectures (
    LectureID int  NOT NULL,
    LecturerID int  NOT NULL,
    TranslatorID int  NOT NULL,
    ServiceID int  NOT NULL,
    CategoryID int  NOT NULL,
    Language varchar(50)  NOT NULL,
    LinkNagranie varchar(50)  NOT NULL,
    Date date  NOT NULL,
    CONSTRAINT Lectures_pk PRIMARY KEY  (LectureID)
);
```
#### 4.2.4  Lectures_attendance
- PK: CustomerID, LectureID
- FK: CustomerID, LectureID
- Opis: Tabela przechowuje listę obecności każdego wykładu
```sql
CREATE TABLE Lectures_attendance (
    CustomerID int  NOT NULL,
    LectureID int  NOT NULL,
    Date datetime  NOT NULL,
    Attendance varchar(20)  NOT NULL,
    CONSTRAINT Lectures_attendance_pk PRIMARY KEY  (CustomerID,LectureID)
);
```
#### 4.2.5  Exams
- PK: CustomerID, ServiceID
- FK: CustomerID, ServiceID
- Opis: Tabela przechowuje listę egzaminów każdego ze studentów
```sql
CREATE TABLE Exams (
    ServiceID int  NOT NULL,
    CustomerID int  NOT NULL,
    Grade int  NOT NULL,
    CONSTRAINT Exams_pk PRIMARY KEY  (ServiceID,CustomerID)
);
```
#### 4.2.6  Diplomas
- PK: DiplomaID
- FK: CustomerID, ServiceID
- Opis: Tabela przechowuje dyplomy przyznane za ukończenie studiów
```sql
CREATE TABLE Diplomas (
    DiplomaID int  NOT NULL,
    ServiceID int  NOT NULL,
    CustomerID int  NOT NULL,
    Date date  NOT NULL,
    Title varchar(30)  NOT NULL,
    CONSTRAINT Diplomas_pk PRIMARY KEY  (DiplomaID)
);
```
#### 4.2.7  Internships
- PK: InternshipID
- FK: ServiceID
- Opis: Tabela przechowuje praktyki z każdych studiów
```sql
CREATE TABLE Internships (
    InternshipID int  NOT NULL,
    InternshipName varchar(200)  NOT NULL,
    InternshipDescription varchar(200)  NOT NULL,
    ServiceID int  NOT NULL,
    StartDate date  NOT NULL,
    EndDate date  NOT NULL,
    CONSTRAINT Internships_pk PRIMARY KEY  (InternshipID)
);
```
#### 4.2.8  Internships_passed
- PK: InternshipID, CustomerID
- FK: InternshipID, CustomerID
- Opis: Tabela przechowuje informację, czy praktyka została zaliczona przez danego studenta
```sql
CREATE TABLE Internships_passed (
    InternshipID int  NOT NULL,
    CustomerID int  NOT NULL,
    Passed varchar(10)  NOT NULL,
    CONSTRAINT Internships_passed_pk PRIMARY KEY  (InternshipID,CustomerID)
);
```
#### 4.2.9  Syllabus
- PK: SyllabusID
- FK: SubjectID
- Opis: Tabela przechowuje plan zajęć każdego z kierunków studiów
```sql
CREATE TABLE Syllabus (
    SyllabusID int  NOT NULL,
    SubjectID int  NOT NULL,
    SyllabusName varchar(50)  NOT NULL,
    CONSTRAINT Syllabus_pk PRIMARY KEY  (SyllabusID)
);
```
#### 4.2.10 Subjects
- PK: SubjectID
- FK: LecturerID
- Opis: Tabela przechowuje informacje na temat każdego z przedmiotów studyjnych
```sql
CREATE TABLE Subjects (
    SubjectID int  NOT NULL,
    LecturerID int  NOT NULL,
    SubjectName int  NOT NULL,
    SubjectDescription int  NOT NULL,
    Hours int  NOT NULL,
    Assessment int  NOT NULL,
    Syllabus_SyllabusID int  NOT NULL,
    CONSTRAINT Subjects_pk PRIMARY KEY  (SubjectID)
);
```
&nbsp;
### 4.3   *Webinars* <a name="web"></a>
#### 4.3.1   Webinars
- PK: ServiceID
- FK: ServiceID
- Opis: Tabela przechowuje wszystkie webinary
```sql
CREATE TABLE Webinars (
    ServiceID int  NOT NULL,
    WebinarName varchar(50)  NOT NULL,
    Date datetime  NOT NULL,
    PriceInAdvance money  NOT NULL,
    PriceWhole money  NOT NULL,
    CONSTRAINT Webinars_pk PRIMARY KEY  (ServiceID)
);
```
#### 4.3.2   Webinars_hist
- PK: ServiceID, LecturerID
- FK: ServiceID, LecturerID, TranslatorID
- Opis: Tabela przechowuje informacje na temat każdego z webinarów
```sql
CREATE TABLE Webinars_hist (
    ServiceID int  NOT NULL,
    TranslatorID int  NOT NULL,
    LecturerID int  NOT NULL,
    Date int  NOT NULL,
    CONSTRAINT Webinars_hist_pk PRIMARY KEY  (ServiceID,LecturerID)
);
```
&nbsp;
### 4.3    *Kursy* <a name="crs"></a>
#### 4.3.1  Courses
- PK: ServiceID
- FK: ServiceID
- Opis: Tabela przechowuje wszystkie realizowane kursy teraz i w przeszłości
```sql
CREATE TABLE Courses (
    ServiceID int  NOT NULL,
    CourseName int  NOT NULL,
    Type varchar(50)  NOT NULL,
    StartDate varchar(500)  NOT NULL,
    EndDate int  NOT NULL,
    PriceInAdvance varchar(30)  NOT NULL,
    PriceWhole int  NOT NULL,
    CONSTRAINT Courses_pk PRIMARY KEY  (ServiceID)
);
```
#### 4.3.2  Modules
- PK: ModuleID
- FK: ServiceID
- Opis: Tabela przechowuje listę modułów każdego z kursów
```sql
CREATE TABLE Modules (
    ModuleID int  NOT NULL,
    ServiceID int  NOT NULL,
    CONSTRAINT Modules_pk PRIMARY KEY  (ModuleID)
);
```
#### 4.3.3  Courses_hist
- PK: ClassID
- FK: ModuleID, LecturerID, TranslatorID
- Opis: Tabela przechowuje informacje o każdym module
```sql
CREATE TABLE Courses_hist (
    ClassID int  NOT NULL,
    ModuleID int  NOT NULL,
    LecturerID int  NOT NULL,
    TranslatorID int  NOT NULL,
    Date int  NOT NULL,
    CONSTRAINT Courses_hist_pk PRIMARY KEY  (ClassID)
);
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
    Attendance varchar(20)  NOT NULL,
    CONSTRAINT Courses_attendance_pk PRIMARY KEY  (CustomerID,ClassID)
);
```
&nbsp;
### 4.4 *Common tables* <a name="ctb"></a>
#### 4.4.1   Lecturers
- PK: LecturerID
- Opis: Tabela przechowuje informacje na temat każdego z wykładowców
```sql
CREATE TABLE Lecturers (
    LecturerID int  NOT NULL,
    FirstName varchar(50)  NOT NULL,
    LastName varchar(50)  NOT NULL,
    CONSTRAINT Lecturer_ID PRIMARY KEY  (LecturerID)
);
```
#### 4.4.2   Translator
- PK: TranslatorID
- Opis: Tabela przechowuje informacje na temat każdego z tłumaczy
```sql
CREATE TABLE Translator (
    TranslatorID int  NOT NULL,
    FirstName varchar(50)  NOT NULL,
    LastName varchar(50)  NOT NULL,
    Language varchar(50)  NOT NULL,
    CONSTRAINT Translator_pk PRIMARY KEY  (TranslatorID)
);
```
&nbsp;

## 5.	Widoki <a name="widoki"></a>

### 1. Raporty finansowe – zestawienie przychodów dla każdego webinaru/kursu/studium.

```sql
Create view dbo.FinancialRaport as(
select Major as Nazwa ,sum(Services.PriceWhole) as Przychody
from Services 
join Studies on Services.ServiceID = Studies.ServiceID 
group by ServiceID



union all

select Major as Nazwa ,sum(Services.PriceWhole) as Przychody
from Services 
join Single_Studies on Services.ServiceID = Single_Studies.ServiceID 
group by ServiceID

union all

select WebinarName as Nazwa ,sum(Services.PriceWhole) as Przychody
from Services 
join Webinars on Services.ServiceID = Webinars.ServiceID 
group by ServiceID

union all

select CourseName as Nazwa ,sum(Services.PriceWhole) as Przychody
from Services 
join Courses on Services.ServiceID = Courses.ServiceID 
group by ServiceID)
```
### 2. Lista „dłużników” – osoby, które skorzystały z usług, ale nie uiściły opłat.

```sql
Create view dbo.DebtorsList as (
select FirstName, LastName, Balance
from Customers
where Balance < 0 and CustomerID in(select Customers.CustomerID, Balance
from Customers
join Orders on Customers.CustomerID = Orders.CustomerID
join Order_Details on Orders.OrderID = Order_Details.OrderID
join Services on Order_Details.ServiceID = Services.ServiceID
join Studies on Services.ServiceID = Studies.ServiceID
where Studies.Date < GETDATE()
group by Customers.CustomerID

union

select Customers.CustomerID, Balance
from Customers
join Orders on Customers.CustomerID = Orders.CustomerID
join Order_Details on Orders.OrderID = Order_Details.OrderID
join Services on Order_Details.ServiceID = Services.ServiceID
join Single_studies on Services.ServiceID = Single_studies.ServiceID
where Single_studies.Date < GETDATE()
group by Customers.CustomerID

union

select Customers.CustomerID, Balance
from Customers
join Orders on Customers.CustomerID = Orders.CustomerID
join Order_Details on Orders.OrderID = Order_Details.OrderID
join Services on Order_Details.ServiceID = Services.ServiceID
join Webinars on Webinars.ServiceID = Services.ServiceID
where Customers.Date < GETDATE()
group by Customers.CustomerID

union

select Customers.CustomerID, Balance
from Customers
join Orders on Customers.CustomerID = Orders.CustomerID
join Order_Details on Orders.OrderID = Order_Details.OrderID
join Services on Order_Details.ServiceID = Services.ServiceID
join Courses on Services.ServiceID = Courses.ServiceID
where Courses.Date < GETDATE()
group by Customers.CustomerID)
order by FirstName, LastName, Balance)
```


### 3. Ogólny raport dotyczący liczby zapisanych osób na przyszłe wydarzenia (z informacją, czy wydarzenie jest stacjonarnie, czy zdalnie).

```sql
Create view dbo.FutureEventsAttendance as(select Lectures.ServiceID,Lectures.LecturerID,Studies.Type as Typ, Lectures.Date,  count(Customers.CustomerID) as Liczba_Zapisanych_Osób
from Customers
join Orders on Customers.CustomerID = Orders.CustomerID
join Order_Details on Orders.OrderID = Order_Details.OrderID
join Services on Order_Details.ServiceID = Services.ServiceID
join Studies on Studies.ServiceID = Services.ServiceID
join Lectures on Lectures.ServiceID = Studies.ServiceID
where Lectures.Date > GETDATE()
group by Lectures.ServiceID,Lectures.LecturerID, Lectures.Date
order by Lectures.Date

union

select Lectures.ServiceID,Lectures.LecturerID,Single_Studies.Type as Typ, Lectures.Date,  count(Customers.CustomerID) as Liczba_Zapisanych_Osób
from Customers
join Orders on Customers.CustomerID = Orders.CustomerID
join Order_Details on Orders.OrderID = Order_Details.OrderID
join Services on Order_Details.ServiceID = Services.ServiceID
join Single_studies on Single_studies.ServiceID = Services.ServiceID
join Lectures on Lectures.ServiceID = Single_studies.ServiceID
where Lectures.Date > GETDATE()
group by Lectures.ServiceID,Lectures.LecturerID, Lectures.Date
order by Lectures.Date

union

select Webinars_his.ServiceID,Webinars_hist.LecturerID, "Zdalnie" as Typ, Webinars_hist.Date,  count(Customers.CustomerID) as Liczba_Zapisanych_Osób
from Customers
join Orders on Customers.CustomerID = Orders.CustomerID
join Order_Details on Orders.OrderID = Order_Details.OrderID
join Services on Order_Details.ServiceID = Services.ServiceID
join Webinars on Webinars.ServiceID = Services.ServiceID
join Webinars_hist on Webinars_hist.ServiceID = Webinars.ServiceID
where Webinars_hist.Date > GETDATE()
group by Webinars_hist.ServiceID, Webinars_hist.LecturerID, Lectures.Date
order by Webinars_hist.Date


union

select Courses_hist.ServiceID,Courses_hist.LecturerID, Courses.Type as Typ, Courses_hist.Date,  count(Customers.CustomerID) as Liczba_Zapisanych_Osób
from Customers
join Orders on Customers.CustomerID = Orders.CustomerID
join Order_Details on Orders.OrderID = Order_Details.OrderID
join Services on Order_Details.ServiceID = Services.ServiceID
join Courses on Courses.ServiceID = Services.ServiceID
join Courses_hist on Courses_hist.ServiceID = Studies.ServiceID
where Courses_hist.Date > GETDATE()
group by Courses_hist.ServiceID,Courses_hist.LecturerID, Courses_hist.Date
order by Courses_hist.Date)
```



### 4. Ogólny raport dotyczący frekwencji na zakończonych już wydarzeniach.

```sql
-- empty
```

### 5. Lista obecności dla każdego szkolenia z datą, imieniem, nazwiskiem i informacją czy uczestnik był obecny, czy nie.

```sql
-- empty
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
    SELECT TOP 100 PERCENT * from Lectures 
	where Lectures.ServiceID = @ServiceID
	order by Lectures.Date DESC
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
