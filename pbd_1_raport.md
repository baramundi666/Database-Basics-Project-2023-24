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
    3. [Webinars](#c&p)
    4. [Kursy](#c&p)
    5. [Common tables](#ctb)
5. [Widoki](#widoki)
6. [Funkcje](#funkcje)
7. [Procedury](#procedury)
8. [Wygenerowane dane](#wygdane)



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
 
![diagramphoto](https://github.com/baramundi666/PBD_projekt/blob/00c7474af3a3d429ade52e72a6febf8702e47176/PBD_Projekt_diagram_15.12.png)

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


## 8.	Wygenerowane dane <a name="wygdane"></a>

### 1. Customers

```sql
INSERT INTO Customers (CustomerID,FirstName,LastName,Balance,Email,City,Address,PostalCode)
VALUES
  (1, 'Neil', 'Bartlett', 64401.94, 'donec@hotmail.ca', 'East London', 'Ap #693-3880 Ut Rd.', '48837'),
(2, 'Allen', 'Aguirre', 25466.02, 'at.velit.cras@icloud.ca', 'Sint-Pieters-Woluwe', '139-3010 Phasellus Rd.', '879381'),
(3, 'Hayes', 'Berry', 31508.39, 'ut.tincidunt@hotmail.ca', 'Almere', 'Ap #859-568 Augue. Ave', '272240'),
(4, 'Vance', 'Hicks', 33227.05, 'sem.nulla@google.couk', 'Caledon', '6011 Diam Avenue', '143678'),
(5, 'Ali', 'Wooten', 59561.76, 'fringilla.porttitor.vulputate@aol.ca', 'Norman Wells', '782-6086 Morbi St.', '5591'),
(6, 'Maggie', 'Pickett', 64905.37, 'euismod@protonmail.edu', 'Morrinsville', 'P.O. Box 780, 8491 Quisque Avenue', 'IB58 6NN'),
(7, 'Eaton', 'Lara', 2396.76, 'massa.quisque.porttitor@protonmail.edu', 'Porsgrunn', '121-7322 Phasellus Road', '50419'),
(8, 'Russell', 'Preston', 83610.7, 'ante.lectus@yahoo.com', 'Camborne', '649-6539 Morbi Rd.', '76631'),
(9, 'Maris', 'Davidson', 97334.21, 'nunc@outlook.ca', 'Gore', '7452 Penatibus St.', '582354'),
(10, 'Hop', 'Molina', 64417.74, 'neque.sed.dictum@yahoo.net', 'Saltillo', 'Ap #379-8830 Urna Avenue', '7793'),
(11, 'Kasimir', 'Townsend', 79206.31, 'ipsum.phasellus.vitae@hotmail.net', 'San Andrés', '306-6870 Lobortis St.', '761519'),
(12, 'Wyatt', 'Britt', 25042.4, 'non@hotmail.net', 'Antofagasta', 'Ap #876-2070 Tellus. St.', '444651'),
(13, 'Emi', 'Guerra', 27571.79, 'lobortis.class.aptent@hotmail.com', 'Alajuela', 'Ap #258-2488 Vulputate Rd.', '861860'),
(14, 'Kylie', 'Duncan', 48615.25, 'donec.feugiat@hotmail.couk', 'Quesada', 'Ap #852-2161 Sit Ave', '1707'),
(15, 'Chandler', 'Vang', 32445.16, 'ipsum.ac@icloud.com', 'Tours', '793 Mauris Rd.', '7028 SM'),
(16, 'Olivia', 'Spears', 31813.77, 'eleifend@yahoo.couk', 'Schagen', 'Ap #985-2865 Eget St.', '8573 FX'),
(17, 'Nayda', 'Stone', 68410.62, 'cursus.integer@icloud.couk', 'Incheon', 'Ap #879-1246 Aliquam St.', '410362'),
(18, 'Camilla', 'Fletcher', 79091.22, 'congue.a@yahoo.net', 'Sars-la-Buissire', '6452 Eget Rd.', '8201'),
(19, 'Carson', 'Frost', 98374.68, 'hymenaeos@google.ca', 'Gaziantep', 'P.O. Box 215, 3928 Quisque St.', '3595-7288'),
(20, 'Eaton', 'Maldonado', 10314.08, 'phasellus.dapibus.quam@aol.net', 'Nam Sách', '375-2525 Sed Rd.', '263268'),
(21, 'Ferdinand', 'Meyers', 99212.8, 'nostra@protonmail.edu', 'Sokoto', 'Ap #583-7140 Blandit. Ave', '4867'),
(22, 'Linda', 'Gallagher', 3124.88, 'neque.vitae@yahoo.net', 'Kohima', 'Ap #379-8599 Dolor, St.', '00340'),
(23, 'Dorothy', 'Burnett', 99926.29, 'orci@google.com', 'La Hulpe', 'Ap #430-581 Cursus Av.', '12805'),
(24, 'Fay', 'Merritt', 93555.02, 'auctor@yahoo.couk', 'The Hague', '3992 Condimentum Ave', '40966'),
(25, 'Xena', 'Miranda', 5441.53, 'vitae.erat.vivamus@aol.org', 'Lugo', '404-7414 Vestibulum Rd.', '298422'),
(26, 'Michael', 'Nash', 11239.02, 'faucibus.ut@aol.edu', 'Ilesa', 'Ap #432-5278 A, Rd.', '543784'),
(27, 'Pearl', 'Ryan', 83199.39, 'porttitor@yahoo.org', 'Cabuyao', '157-5646 Eros Street', '7498'),
(28, 'Gail', 'Oneil', 75712.74, 'erat.vivamus@icloud.couk', 'Bandar Lampung', '314-5870 Eu St.', '652645'),
(29, 'Stephen', 'Martin', 53931.71, 'convallis@hotmail.com', 'Toruń', 'Ap #145-3010 Conubia Rd.', '462810'),
(30, 'Jillian', 'Sullivan', 20706.04, 'molestie@outlook.net', 'Açailândia', '911-8496 Maecenas Avenue', 'PJ12 4UM'),
(31, 'Victor', 'Benjamin', 23641.59, 'dictum@icloud.net', 'San Nicolás', 'P.O. Box 684, 824 Eget Avenue', '5477'),
(32, 'Ariana', 'Eaton', 24735.99, 'nulla.eu@icloud.com', 'Kurgan', '259-7294 Arcu Rd.', '21517'),
(33, 'Rae', 'Perry', 6840.08, 'lorem.ipsum@protonmail.couk', 'Saarlouis', 'Ap #880-9240 Pede Avenue', '8058'),
(34, 'Kasimir', 'Eaton', 55967.07, 'aliquam.rutrum@yahoo.org', 'Tczew', '1433 Nec Road', 'B6M 0P5'),
(35, 'Ori', 'Morrison', 7617.26, 'mauris.suspendisse@outlook.com', 'Alanya', '230-9337 Magna. Street', '68544'),
(36, 'Kyla', 'Hull', 35532.69, 'molestie.dapibus.ligula@icloud.net', 'Chortkiv', 'Ap #429-5642 Ut, Avenue', '652912'),
(37, 'Joseph', 'Casey', 28161.63, 'sagittis.lobortis@yahoo.edu', 'Saintes', '3463 Felis Street', '226087'),
(38, 'Cheyenne', 'Haynes', 86775.17, 'imperdiet.ornare.in@google.edu', 'Izmail', 'P.O. Box 609, 2606 Auctor Rd.', '392663'),
(39, 'Griffin', 'Hatfield', 62512.77, 'suspendisse.dui@aol.couk', 'Ospedaletto dAlpinolo', '287-1240 Amet Av.', '05910'),
(40, 'Isadora', 'Powers', 36363.31, 'sodales.mauris.blandit@icloud.ca', 'Jayapura', 'Ap #861-6368 Quisque Avenue', 'J9A 8T2'),
(41, 'Logan', 'Graham', 18764.66, 'sit.amet@yahoo.couk', 'Guápiles', 'P.O. Box 892, 6337 Faucibus. Avenue', '734325'),
(42, 'Oprah', 'Reilly', 40911.7, 'sed.nec@outlook.edu', 'Barranca', 'P.O. Box 545, 4070 Vestibulum Av.', '42018'),
(43, 'Savannah', 'Joyce', 51307.94, 'dui.nec@protonmail.edu', 'Radom', 'Ap #592-4759 Pede. Av.', '2998'),
(44, 'Yoko', 'Weiss', 35959.99, 'orci.lacus@hotmail.com', 'Arnhem', 'Ap #739-6661 Dignissim. St.', '23720-16931'),
(45, 'Montana', 'Mcpherson', 96170.49, 'duis@hotmail.com', 'Port Harcourt', '648-3490 In Avenue', '58417'),
(46, 'Timothy', 'Sellers', 76445.19, 'nisi@yahoo.net', 'Chiquinquirá', '282-3401 Nisi. Street', '005557'),
(47, 'Ishmael', 'Moody', 18150.33, 'donec.nibh.enim@protonmail.net', 'Altach', 'Ap #511-7652 Aliquam St.', '0118'),
(48, 'Scarlet', 'English', 97431.18, 'eget.magna.suspendisse@aol.org', 'Mandi Bahauddin', '730-8655 Vestibulum, Ave', '8040'),
(49, 'Hermione', 'Colon', 56121.88, 'justo.sit.amet@aol.net', 'Port Blair', '9634 Pede Street', '4133'),
(50, 'Dara', 'Lee', 99104.4, 'libero@outlook.net', 'Feldkirchen in Kärnten', '616-7458 Non St.', 'T9K 2W2'),
(51, 'Yoshio', 'Campos', 68395.78, 'consequat@yahoo.org', 'Máfil', '2027 Sed, Road', '8317'),
(52, 'Brynn', 'Woodard', 22692.37, 'nisl.nulla@icloud.ca', 'San Fernando', 'Ap #685-4953 Nostra, Rd.', 'CQ4 8VK'),
(53, 'Lani', 'Norris', 38930.17, 'tincidunt@protonmail.ca', 'San Francisco', '376-8488 Commodo Rd.', '02701'),
(54, 'Samuel', 'Floyd', 4298.01, 'adipiscing@outlook.couk', 'Puno', '420-5965 Tincidunt Av.', '26365'),
(55, 'Adena', 'Mcgowan', 28063.0, 'mauris.ut.mi@google.couk', 'Magangué', '9006 Cum St.', '151576'),
(56, 'Nichole', 'Pope', 95324.16, 'ante.ipsum.primis@aol.com', 'Elbląg', 'Ap #189-1898 Blandit St.', '37586'),
(57, 'Callie', 'Kent', 87603.15, 'egestas.blandit@aol.net', 'Águas Lindas de Goiás', 'Ap #106-1113 Posuere Rd.', '01137'),
(58, 'Ruby', 'Evans', 24671.43, 'auctor.quis@outlook.com', 'Boon Lay', '9142 Vitae Avenue', '8176-8915'),
(59, 'Noelle', 'Sears', 30879.21, 'eget.odio.aliquam@yahoo.couk', 'Saint-Herblain', '698-2805 Leo, Avenue', 'w0C 8V9'),
(60, 'Anne', 'Alston', 23886.25, 'risus.varius@protonmail.com', 'Montluçon', '946-9404 Integer St.', '91235'),
(61, 'Curran', 'Jenkins', 58561.16, 'ipsum.suspendisse@yahoo.edu', 'Stirling', 'Ap #162-6257 Tortor, St.', '9091'),
(62, 'Venus', 'Buck', 56230.89, 'lorem@protonmail.ca', 'Darica', '304-4970 Erat Rd.', '6715'),
(63, 'Jaime', 'Rich', 5976.07, 'vitae.erat.vivamus@yahoo.couk', 'Oslo', '5351 Tellus Street', '46707'),
(64, 'Hop', 'Velasquez', 89433.23, 'odio@outlook.couk', 'Bắc Giang', 'Ap #323-9298 Dui Road', '764114'),
(65, 'Wesley', 'Miles', 41877.28, 'ut.nisi@aol.org', 'Châtellerault', 'Ap #879-9121 Aliquam Rd.', '626177'),
(66, 'Ray', 'Rich', 93544.22, 'neque@icloud.org', 'Chandigarh', 'Ap #838-6748 Eu, Road', '65602'),
(67, 'Anika', 'Hogan', 75237.88, 'phasellus.libero@aol.com', 'Rapagnano', 'P.O. Box 730, 8520 Sed Ave', '67218'),
(68, 'Azalia', 'Cummings', 87900.17, 'sem@outlook.org', 'Emalahleni', '186-7062 Interdum. Rd.', '656937'),
(69, 'Violet', 'Stone', 84414.88, 'iaculis.lacus.pede@hotmail.edu', 'Melilla', '8900 Ipsum Ave', 'GW8I 3DX'),
(70, 'Fay', 'Barrett', 76080.42, 'sed.dui.fusce@hotmail.ca', 'Temuka', 'Ap #987-5366 Id, Rd.', '5902'),
(71, 'Felix', 'Bailey', 70155.45, 'natoque.penatibus@hotmail.edu', 'Whangarei', 'Ap #860-685 Dui. St.', '20007'),
(72, 'Rooney', 'Day', 16755.76, 'nunc.sed.pede@google.org', 'Bellevue', 'Ap #560-4286 Aliquam Avenue', '3533'),
(73, 'Rudyard', 'Matthews', 60819.62, 'at@aol.ca', 'Shanxi', 'P.O. Box 782, 6142 Tellus Road', '4898'),
(74, 'Autumn', 'Mosley', 32067.45, 'semper.rutrum@yahoo.net', 'Newark', '521-9235 Luctus. Road', '77703'),
(75, 'Brent', 'Whitehead', 76697.41, 'fringilla.donec@aol.org', 'Dublin', '764-8281 Mi, Rd.', '57923'),
(76, 'Talon', 'Horn', 33219.84, 'et.eros@outlook.org', 'Kaliningrad', '726-7854 Ipsum Rd.', '58427'),
(77, 'Leilani', 'Hurley', 23130.27, 'lacinia.at.iaculis@icloud.com', 'Querétaro', '497-8045 Vel Av.', '36665'),
(78, 'Rudyard', 'Gilbert', 6881.09, 'hymenaeos.mauris@google.com', 'Surigao City', '4846 Et, Ave', '31004'),
(79, 'Shoshana', 'Cummings', 95147.95, 'ornare.placerat@protonmail.couk', 'Cartagena', '507-1234 Gravida Ave', '111919'),
(80, 'Pearl', 'Young', 86949.42, 'fusce.dolor@aol.net', 'Mödling', '705-8057 Dictum. Rd.', '474284'),
(81, 'Cynthia', 'Curtis', 35869.25, 'rhoncus.nullam@aol.com', 'Sungei Kadut', '493-9102 Hendrerit Street', '41515'),
(82, 'Noelle', 'Malone', 10284.03, 'luctus.vulputate.nisi@hotmail.net', 'Okene', 'Ap #968-6315 Aliquam Ave', '176524'),
(83, 'Timothy', 'Morrow', 94304.15, 'dapibus.id.blandit@aol.net', 'Chongqing', 'Ap #372-4727 Ultrices, Ave', '264246'),
(84, 'Mechelle', 'Holman', 92886.9, 'urna.convallis.erat@yahoo.edu', 'Central Water Catchment', 'Ap #131-7207 Quisque St.', '644689'),
(85, 'Lee', 'Patterson', 38812.26, 'vitae.odio.sagittis@google.com', 'Waterbury', '436-2483 Tincidunt, St.', 'JM5 6RP'),
(86, 'Caleb', 'Stephens', 95264.88, 'lacinia.sed@google.com', 'Bismil', '9223 Et Rd.', '02612-40633'),
(87, 'Fay', 'Stone', 84167.6, 'hendrerit.donec.porttitor@google.com', 'Dillenburg', 'Ap #449-4365 Maecenas Ave', '414704'),
(88, 'Deacon', 'Booth', 15673.13, 'velit.justo.nec@protonmail.edu', 'Alcalá de Henares', 'Ap #902-6666 Sed Street', '14486'),
(89, 'Thomas', 'Pope', 35033.36, 'mauris@yahoo.net', 'Norrköping', '836-6280 Dolor Avenue', '9734'),
(90, 'Martin', 'Wynn', 50504.49, 'proin.dolor.nulla@aol.com', 'Pietermaritzburg', 'Ap #543-6757 Auctor St.', '53252-96423'),
(91, 'Emerson', 'Guerrero', 67160.65, 'ridiculus.mus.aenean@aol.couk', 'Rio Verde', 'P.O. Box 841, 6279 Volutpat St.', '4126'),
(92, 'Desiree', 'Conrad', 65344.65, 'per.inceptos@protonmail.edu', 'Ełk', '879-439 Vitae St.', '17646'),
(93, 'Bethany', 'Jacobson', 75583.68, 'urna@aol.com', 'Ternopil', 'Ap #363-6758 Neque Av.', '50112'),
(94, 'Tatiana', 'Huffman', 24954.63, 'est@protonmail.couk', 'Kufstein', 'Ap #964-8931 Fringilla St.', '17951'),
(95, 'Dane', 'Castaneda', 33112.7, 'enim@google.com', 'Macchia Valfortore', '7140 Nulla Rd.', '47367-90275'),
(96, 'Kamal', 'Reid', 83570.01, 'mauris.quis@protonmail.ca', 'Melitopol', '5379 Dis Avenue', 'VB4R 4MP'),
(97, 'Driscoll', 'Hanson', 610.14, 'et.libero.proin@protonmail.edu', 'Irapuato', '352-209 Sit St.', '58272'),
(98, 'Mason', 'Andrews', 38716.94, 'mauris.integer.sem@hotmail.couk', 'Sokoto', 'Ap #191-6149 Nunc St.', '50118'),
(99, 'Salvador', 'Williams', 8695.26, 'ac.sem@outlook.couk', 'Timaru', '1000 Gravida Ave', '12086'),
(100, 'Galena', 'Moore', 48980.03, 'semper.nam@google.edu', 'Torres del Paine', 'Ap #654-3812 Placerat Street', '84-81');
```

### 2. Webinars

```sql
INSERT INTO Webinars (ServiceID,WebinarName,Date,PriceInAdvance,PriceWhole)
VALUES
  (3, 'Samochody', '2023-05-23 18:59:28', 607.48, 412.76),
(6, 'Samochody', '2023-08-05 18:44:23', 952.66, 814.21), 
(9, 'Samochody', '2024-08-02 11:55:30', 686.34, 310.83), 
(12, 'Samochody', '2023-08-30 02:39:15', 554.98, 514.21),
(15, 'Samochody', '2024-09-01 12:01:31', 445.76, 210.92),
(18, 'Auta', '2023-07-12 10:33:32', 327.88, 555.90),     
(21, 'Auta', '2024-04-27 18:55:41', 405.58, 689.08),     
(24, 'Auta', '2024-04-23 21:54:45', 204.24, 156.90),     
(27, 'Auta', '2025-01-06 05:27:22', 929.05, 104.72),     
(30, 'Auta', '2023-05-11 06:02:31', 104.12, 996.15),     
(33, 'Dinozaury', '2024-03-02 12:58:12', 909.68, 396.95),
(36, 'Dinozaury', '2023-07-21 12:24:47', 919.49, 250.27),
(39, 'Dinozaury', '2024-10-24 02:49:47', 179.6, 322.23), 
(42, 'Dinozaury', '2024-10-08 05:10:17', 882.31, 546.86),
(45, 'Dinozaury', '2023-12-31 02:36:29', 703.85, 786.19),
(48, 'Leki', '2023-12-13 19:37:10', 693.44, 452.39),     
(51, 'Leki', '2024-01-08 21:56:35', 552.86, 9.90),       
(54, 'Leki', '2024-06-12 03:13:13', 631.7, 958.31),
(57, 'Leki', '2025-01-09 17:27:59', 939.81, 617.69),
(60, 'Leki', '2023-12-06 03:05:06', 680.67, 27.95),
(63, 'Pokemony', '2023-03-05 06:28:15', 876.94, 684.28),
(66, 'Pokemony', '2024-03-30 07:51:46', 767.76, 147.01),
(69, 'Pokemony', '2023-12-24 05:11:38', 447.09, 890.80),
(72, 'Pokemony', '2024-09-12 21:54:12', 615.32, 922.04),
(75, 'Pokemony', '2023-09-04 07:24:03', 443.57, 294.35),
(78, 'Samochody', '2023-10-21 07:52:57', 255.02, 465.00),
(81, 'Samochody', '2024-04-13 13:08:26', 996.96, 468.14),
(84, 'Samochody', '2023-04-14 09:10:11', 819.42, 754.24),
(87, 'Samochody', '2023-11-29 02:30:16', 414.24, 876.63),
(90, 'Samochody', '2023-07-24 03:56:32', 683.33, 304.46),
(93, 'Auta', '2024-10-05 01:30:41', 194.55, 681.24),
(96, 'Auta', '2024-10-11 05:31:16', 947.56, 970.09),
(99, 'Auta', '2024-04-12 19:33:59', 519.47, 806.13),
(102, 'Auta', '2023-11-28 05:50:08', 726.03, 50.72),
(105, 'Auta', '2024-03-22 14:31:38', 187.73, 183.43),
(108, 'Dinozaury', '2024-09-19 11:11:30', 692.51, 93.22),
(111, 'Dinozaury', '2025-01-07 20:56:29', 603.73, 677.93),
(114, 'Dinozaury', '2024-10-21 10:10:45', 18.86, 101.67),
(117, 'Dinozaury', '2023-09-25 22:32:06', 711.59, 19.18),
(120, 'Dinozaury', '2024-06-22 06:41:31', 522.67, 668.90),
(123, 'Leki', '2023-10-08 03:20:51', 612.13, 81.96),
(126, 'Leki', '2023-07-08 02:50:17', 168.77, 496.91),
(129, 'Leki', '2024-06-06 18:23:30', 842.34, 741.94),
(132, 'Leki', '2024-09-27 19:14:37', 651.47, 667.42),
(135, 'Leki', '2024-01-30 10:18:38', 878.42, 589.85),
(138, 'Pokemony', '2023-07-10 05:44:08', 666.53, 222.38),
(141, 'Pokemony', '2023-08-16 10:05:40', 378.52, 231.85),
(144, 'Pokemony', '2024-12-31 23:08:48', 35.7, 784.39),
(147, 'Pokemony', '2023-10-30 13:39:48', 160.48, 310.77),
(150, 'Pokemony', '2024-03-29 18:02:27', 632.78, 674.29),
(153, 'Samochody', '2023-09-20 18:00:33', 384.46, 372.56),
(156, 'Samochody', '2024-07-09 18:41:29', 527.2, 13.89),
(159, 'Samochody', '2023-05-04 06:58:22', 108.13, 98.95),
(162, 'Samochody', '2023-08-20 20:44:14', 296.56, 117.39),
(165, 'Samochody', '2023-03-21 00:34:42', 334.03, 152.92),
(168, 'Auta', '2023-09-28 12:15:07', 717.99, 656.21),
(171, 'Auta', '2023-06-27 07:30:09', 625.66, 278.13),
(174, 'Auta', '2024-10-01 00:40:36', 64.63, 232.90),
(177, 'Auta', '2025-01-14 03:43:13', 428.39, 160.14),
(180, 'Auta', '2023-09-24 02:25:16', 956.2, 986.69),
(183, 'Dinozaury', '2024-12-02 03:19:50', 727.35, 142.96),
(186, 'Dinozaury', '2023-05-14 15:51:44', 179.3, 371.56),
(189, 'Dinozaury', '2023-12-06 10:45:26', 442.62, 895.19),
(192, 'Dinozaury', '2024-03-17 11:54:02', 671.59, 54.05),
(195, 'Dinozaury', '2023-01-22 12:41:48', 858.57, 773.52),
(198, 'Leki', '2024-05-29 07:46:55', 363.01, 579.28),
(201, 'Leki', '2024-08-07 20:48:50', 356.51, 615.39),
(204, 'Leki', '2024-04-20 13:07:06', 904.46, 242.22),
(207, 'Leki', '2024-06-17 12:36:27', 252.86, 899.42),
(210, 'Leki', '2024-03-30 03:43:30', 117.35, 820.71),
(213, 'Pokemony', '2024-07-03 14:42:06', 609.99, 243.37),
(216, 'Pokemony', '2024-03-12 17:24:30', 191.56, 0.10),
(219, 'Pokemony', '2024-07-25 02:54:21', 865.39, 569.52),
(222, 'Pokemony', '2024-05-30 12:48:19', 780.42, 131.57),
(225, 'Pokemony', '2024-09-09 10:11:52', 18.93, 114.56),
(228, 'Samochody', '2024-12-05 16:48:32', 452.4, 922.67),
(231, 'Samochody', '2024-07-08 00:47:56', 941.22, 108.36),
(234, 'Samochody', '2024-03-02 08:26:51', 102.3, 848.93),
(237, 'Samochody', '2023-03-28 03:38:49', 974.94, 110.08),
(240, 'Samochody', '2024-01-25 14:42:30', 17.26, 933.17),
(243, 'Auta', '2024-12-03 03:33:43', 141.07, 47.82),
(246, 'Auta', '2024-01-28 03:14:08', 497.76, 25.26),
(249, 'Auta', '2024-09-03 07:31:31', 566.18, 254.75),
(252, 'Auta', '2024-05-31 05:05:35', 140.27, 33.32),
(255, 'Auta', '2023-02-27 08:09:16', 527.1, 182.77),
(258, 'Dinozaury', '2024-03-07 11:33:24', 716.65, 500.75),
(261, 'Dinozaury', '2023-09-15 14:28:12', 700.72, 989.72),
(264, 'Dinozaury', '2023-05-02 07:19:05', 692.66, 22.68),
(267, 'Dinozaury', '2023-02-11 01:44:05', 424.71, 45.51),
(270, 'Dinozaury', '2023-11-14 00:13:46', 944.25, 888.42),
(273, 'Leki', '2024-09-19 10:07:04', 988.47, 454.83),
(276, 'Leki', '2023-11-08 21:09:42', 625.68, 444.56),
(279, 'Leki', '2023-06-10 00:24:53', 369.19, 601.60),
(282, 'Leki', '2024-11-11 07:05:31', 492.3, 75.26),
(285, 'Leki', '2023-02-27 01:34:25', 662.85, 423.78),
(288, 'Pokemony', '2023-06-15 18:38:57', 362.45, 359.65),
(291, 'Pokemony', '2024-11-01 14:22:22', 444.5, 457.02),
(294, 'Pokemony', '2023-08-12 03:07:39', 145.29, 42.72),
(297, 'Pokemony', '2023-10-13 05:43:44', 26.92, 867.55),
(300, 'Pokemony', '2023-08-26 18:30:01', 291.28, 472.25),
(303, 'Samochody', '2023-12-12 15:58:20', 448.24, 762.66),
(306, 'Samochody', '2024-08-31 22:47:32', 606.69, 53.20),
(309, 'Samochody', '2023-11-23 02:17:43', 543.18, 744.56),
(312, 'Samochody', '2023-06-29 00:06:50', 841.66, 587.10),
(315, 'Samochody', '2023-12-09 22:38:25', 877.43, 611.09),
(318, 'Auta', '2023-07-27 13:14:13', 919.68, 393.45),
(321, 'Auta', '2024-04-08 17:53:06', 415.74, 92.55),
(324, 'Auta', '2024-06-29 05:21:33', 388.66, 638.44),
(327, 'Auta', '2024-03-23 17:07:05', 768.32, 769.30),
(330, 'Auta', '2023-07-22 02:03:45', 185.57, 779.32),
(333, 'Dinozaury', '2023-06-03 21:23:07', 369.8, 366.53),
(336, 'Dinozaury', '2023-12-08 04:15:58', 819.91, 214.48),
(339, 'Dinozaury', '2023-05-22 21:58:14', 241.29, 933.99),
(342, 'Dinozaury', '2023-09-04 16:39:12', 428.65, 384.68),
(345, 'Dinozaury', '2023-09-16 23:55:07', 674.9, 288.71),
(348, 'Leki', '2024-12-10 03:44:14', 340.32, 712.71),
(351, 'Leki', '2024-01-26 08:16:57', 916.8, 666.30),
(354, 'Leki', '2024-03-18 05:17:34', 725.72, 538.85),
(357, 'Leki', '2024-05-21 01:00:23', 966.03, 258.20),
(360, 'Leki', '2024-09-04 15:16:01', 418.7, 662.90),
(363, 'Pokemony', '2024-04-17 09:02:52', 726.22, 915.73),
(366, 'Pokemony', '2024-12-23 11:40:40', 29.87, 334.89),
(369, 'Pokemony', '2024-04-21 11:53:24', 79.49, 769.91),
(372, 'Pokemony', '2024-02-08 22:00:00', 299.01, 40.48),
(375, 'Pokemony', '2024-03-24 07:53:16', 237.9, 214.16),
(378, 'Samochody', '2023-04-27 02:33:51', 122.12, 353.19),
(381, 'Samochody', '2024-08-05 18:03:34', 328.9, 461.44),
(384, 'Samochody', '2024-06-22 13:49:50', 322.77, 445.33),
(387, 'Samochody', '2024-07-29 17:38:56', 69.43, 477.48),
(390, 'Samochody', '2024-06-25 19:45:51', 958.83, 596.43),
(393, 'Auta', '2023-04-22 01:05:36', 4.9, 130.47),
(396, 'Auta', '2023-11-28 05:35:25', 861.22, 356.20),
(399, 'Auta', '2023-08-29 22:25:03', 352.28, 743.31),
(402, 'Auta', '2023-07-01 11:04:03', 55.07, 517.40),
(405, 'Auta', '2025-01-03 14:12:17', 420.59, 737.65),
(408, 'Dinozaury', '2023-09-04 05:02:35', 47.43, 775.50),
(411, 'Dinozaury', '2024-06-11 06:01:36', 307.51, 541.74),
(414, 'Dinozaury', '2024-09-14 06:23:06', 497.67, 970.55),
(417, 'Dinozaury', '2023-11-11 01:33:59', 45.19, 671.39),
(420, 'Dinozaury', '2024-09-18 22:46:24', 874.26, 453.22),
(423, 'Leki', '2024-02-28 20:14:57', 826.21, 78.53),
(426, 'Leki', '2023-08-24 13:09:07', 177.71, 107.52),
(429, 'Leki', '2023-07-19 20:28:06', 228.79, 294.09),
(432, 'Leki', '2023-12-14 20:56:45', 532.0, 299.27),
(435, 'Leki', '2023-01-27 08:26:35', 904.74, 502.11),
(438, 'Pokemony', '2023-12-05 04:25:57', 927.42, 438.51),
(441, 'Pokemony', '2024-06-10 07:44:46', 869.2, 419.92),
(444, 'Pokemony', '2024-04-11 09:58:55', 182.05, 231.57),
(447, 'Pokemony', '2023-04-16 13:30:14', 785.62, 590.48),
(450, 'Pokemony', '2023-06-27 10:31:16', 474.93, 875.13),
(453, 'Samochody', '2024-03-24 00:57:17', 677.35, 640.53),
(456, 'Samochody', '2023-09-04 03:54:37', 495.63, 54.96),
(459, 'Samochody', '2023-10-07 06:44:11', 28.87, 42.16),
(462, 'Samochody', '2024-04-09 01:16:03', 794.28, 318.07),
(465, 'Samochody', '2023-12-04 03:47:20', 831.96, 443.10),
(468, 'Auta', '2023-11-27 12:18:37', 138.97, 159.98),
(471, 'Auta', '2023-10-26 15:44:16', 713.37, 413.03),
(474, 'Auta', '2023-05-10 10:18:10', 776.49, 311.94),
(477, 'Auta', '2023-10-12 04:28:39', 107.68, 983.26),
(480, 'Auta', '2024-08-06 20:49:18', 73.8, 495.53),
(483, 'Dinozaury', '2024-12-05 08:33:22', 49.65, 191.79),
(486, 'Dinozaury', '2024-02-16 18:51:14', 741.48, 505.18),
(489, 'Dinozaury', '2023-03-19 21:17:53', 649.65, 436.03),
(492, 'Dinozaury', '2024-06-21 07:14:59', 877.21, 390.54),
(495, 'Dinozaury', '2024-12-18 13:17:43', 642.49, 395.11),
(498, 'Leki', '2024-10-21 08:20:41', 419.02, 391.69),
(501, 'Leki', '2024-07-17 14:08:20', 319.41, 388.33),
(504, 'Leki', '2023-10-03 12:56:53', 895.68, 836.03),
(507, 'Leki', '2024-08-13 08:32:50', 150.11, 681.57),
(510, 'Leki', '2024-08-06 10:49:34', 867.95, 26.82),
(513, 'Pokemony', '2024-10-23 07:57:00', 2.34, 438.54),
(516, 'Pokemony', '2023-07-02 17:51:19', 926.4, 686.04),
(519, 'Pokemony', '2023-02-21 06:59:04', 502.53, 151.91),
(522, 'Pokemony', '2023-11-27 11:09:57', 57.66, 656.50),
(525, 'Pokemony', '2023-12-05 15:24:15', 189.99, 358.82),
(528, 'Samochody', '2024-02-01 02:42:42', 832.65, 858.51),
(531, 'Samochody', '2023-09-03 07:58:20', 16.09, 344.65),
(534, 'Samochody', '2023-02-25 22:45:20', 180.87, 103.64),
(537, 'Samochody', '2023-11-13 22:23:57', 787.3, 132.55),
(540, 'Samochody', '2024-08-12 09:35:41', 155.82, 785.05),
(543, 'Auta', '2023-05-05 10:44:16', 471.17, 811.48),
(546, 'Auta', '2024-01-20 07:58:41', 187.76, 181.10),
(549, 'Auta', '2023-08-06 07:09:15', 434.99, 622.10),
(552, 'Auta', '2024-07-26 02:59:34', 439.9, 169.12),
(555, 'Auta', '2024-08-31 22:11:56', 812.58, 775.36),
(558, 'Dinozaury', '2024-12-17 04:51:02', 993.56, 821.50),
(561, 'Dinozaury', '2024-11-01 02:37:24', 400.64, 459.01),
(564, 'Dinozaury', '2024-05-22 03:39:11', 338.25, 595.36),
(567, 'Dinozaury', '2024-06-04 09:16:10', 772.04, 973.17),
(570, 'Dinozaury', '2023-02-04 18:09:56', 48.73, 461.61),
(573, 'Leki', '2023-08-08 08:25:26', 267.63, 131.45),
(576, 'Leki', '2023-05-06 06:09:30', 421.32, 225.17),
(579, 'Leki', '2023-11-07 00:38:46', 925.21, 158.81),
(582, 'Leki', '2023-04-24 23:44:00', 41.56, 32.69),
(585, 'Leki', '2023-12-28 14:07:58', 257.19, 437.71),
(588, 'Pokemony', '2024-12-31 05:16:10', 384.83, 369.49),
(591, 'Pokemony', '2024-01-15 17:04:04', 525.7, 266.65),
(594, 'Pokemony', '2024-06-30 20:26:43', 970.48, 223.67),
(597, 'Pokemony', '2023-01-16 10:09:47', 933.07, 471.07),
(600, 'Pokemony', '2024-01-16 08:51:04', 11.37, 495.10),
(603, 'Samochody', '2024-05-08 01:26:51', 954.94, 414.56),
(606, 'Samochody', '2023-10-30 04:39:27', 482.79, 668.45),
(609, 'Samochody', '2023-04-13 23:02:05', 817.5, 511.76),
(612, 'Samochody', '2024-05-23 04:17:54', 198.2, 834.52),
(615, 'Samochody', '2024-12-26 18:59:53', 68.71, 205.29),
(618, 'Auta', '2024-06-22 18:23:58', 545.63, 477.25),
(621, 'Auta', '2024-06-04 16:40:38', 525.94, 152.48),
(624, 'Auta', '2024-06-25 05:22:14', 845.47, 160.74),
(627, 'Auta', '2023-06-23 21:08:03', 254.41, 364.68),
(630, 'Auta', '2023-12-23 21:48:02', 274.85, 857.72),
(633, 'Dinozaury', '2023-12-17 04:23:11', 463.58, 490.90),
(636, 'Dinozaury', '2023-07-12 03:28:05', 297.97, 6.54),
(639, 'Dinozaury', '2023-03-23 12:35:20', 97.68, 627.85),
(642, 'Dinozaury', '2023-02-21 18:53:59', 118.29, 978.87),
(645, 'Dinozaury', '2023-03-17 11:51:24', 932.02, 273.88),
(648, 'Leki', '2023-04-16 02:02:33', 191.13, 937.57),
(651, 'Leki', '2023-10-05 15:20:39', 907.55, 124.68),
(654, 'Leki', '2024-01-03 02:40:18', 297.37, 784.79),
(657, 'Leki', '2024-12-21 06:44:27', 62.65, 928.97),
(660, 'Leki', '2023-07-16 17:17:20', 506.0, 77.06),
(663, 'Pokemony', '2024-11-12 13:48:03', 523.35, 994.61),
(666, 'Pokemony', '2024-05-14 19:23:35', 589.14, 723.19),
(669, 'Pokemony', '2023-10-07 16:08:03', 775.4, 949.79),
(672, 'Pokemony', '2023-03-05 14:19:07', 246.3, 532.73),
(675, 'Pokemony', '2023-07-05 18:18:53', 469.33, 619.01),
(678, 'Samochody', '2024-07-05 04:28:28', 281.32, 735.76),
(681, 'Samochody', '2024-01-23 06:56:57', 734.65, 807.54),
(684, 'Samochody', '2024-10-15 11:05:52', 171.63, 416.86),
(687, 'Samochody', '2023-10-25 09:35:38', 703.08, 886.74),
(690, 'Samochody', '2024-11-02 23:09:24', 844.27, 606.70),
(693, 'Auta', '2024-10-28 03:38:35', 645.0, 56.57),
(696, 'Auta', '2024-10-23 22:45:02', 595.06, 851.14),
(699, 'Auta', '2024-09-09 21:50:27', 450.65, 258.85),
(702, 'Auta', '2024-12-10 05:23:28', 176.96, 244.98),
(705, 'Auta', '2024-05-15 09:23:34', 28.87, 646.17),
(708, 'Dinozaury', '2024-12-19 01:31:36', 773.66, 917.86),
(711, 'Dinozaury', '2024-11-15 10:31:32', 527.64, 380.31),
(714, 'Dinozaury', '2024-03-31 06:18:48', 488.44, 644.04),
(717, 'Dinozaury', '2025-01-07 17:12:58', 372.48, 253.14),
(720, 'Dinozaury', '2024-10-13 04:36:06', 568.52, 178.34),
(723, 'Leki', '2023-04-08 09:17:17', 535.16, 794.08),
(726, 'Leki', '2023-04-08 22:12:21', 827.17, 804.36),
(729, 'Leki', '2024-06-23 16:05:43', 54.75, 963.32),
(732, 'Leki', '2024-09-30 08:05:13', 853.47, 590.09),
(735, 'Leki', '2023-11-27 21:37:05', 805.0, 432.19),
(738, 'Pokemony', '2024-01-18 01:01:48', 633.17, 131.56),
(741, 'Pokemony', '2023-11-11 02:41:56', 864.72, 93.08),
(744, 'Pokemony', '2023-05-19 20:50:28', 619.27, 555.91),
(747, 'Pokemony', '2023-02-12 22:17:23', 574.54, 721.98),
(750, 'Pokemony', '2023-12-08 06:35:48', 381.2, 527.92),
(753, 'Samochody', '2024-05-26 21:15:01', 30.08, 735.49),
(756, 'Samochody', '2023-09-24 10:30:47', 50.58, 379.76),
(759, 'Samochody', '2024-04-12 19:09:06', 282.71, 53.51),
(762, 'Samochody', '2024-08-31 03:57:11', 790.68, 484.19),
(765, 'Samochody', '2023-06-22 19:55:51', 5.01, 756.44),
(768, 'Auta', '2024-01-31 21:14:18', 506.17, 787.08),
(771, 'Auta', '2024-05-05 04:14:33', 22.49, 168.19),
(774, 'Auta', '2023-09-25 11:32:07', 641.96, 260.14),
(777, 'Auta', '2025-01-12 16:27:24', 940.79, 684.32),
(780, 'Auta', '2024-05-20 04:31:26', 334.85, 872.94),
(783, 'Dinozaury', '2023-10-04 16:44:01', 818.84, 695.83),
(786, 'Dinozaury', '2023-11-02 02:49:11', 625.54, 30.99),
(789, 'Dinozaury', '2023-05-05 15:22:47', 701.41, 566.02),
(792, 'Dinozaury', '2024-02-23 02:57:51', 803.61, 234.00),
(795, 'Dinozaury', '2023-04-08 20:59:18', 213.03, 130.06),
(798, 'Leki', '2024-09-17 09:19:28', 968.56, 367.35),
(801, 'Leki', '2023-10-08 19:53:55', 294.33, 508.86),
(804, 'Leki', '2023-03-28 12:28:39', 687.79, 139.36),
(807, 'Leki', '2024-08-11 16:05:37', 992.44, 379.64),
(810, 'Leki', '2023-12-16 12:36:50', 231.78, 664.10),
(813, 'Pokemony', '2024-05-20 19:20:37', 628.17, 414.83),
(816, 'Pokemony', '2023-10-17 16:25:25', 777.95, 280.75),
(819, 'Pokemony', '2024-06-02 21:11:07', 667.12, 3.63),
(822, 'Pokemony', '2024-10-27 16:16:41', 68.32, 656.75),
(825, 'Pokemony', '2023-08-02 19:48:21', 277.98, 695.90),
(828, 'Samochody', '2024-07-02 09:49:06', 583.3, 251.55),
(831, 'Samochody', '2023-08-28 18:58:47', 716.39, 928.66),
(834, 'Samochody', '2024-08-05 00:14:25', 245.67, 725.53),
(837, 'Samochody', '2023-08-17 07:50:56', 215.44, 570.48),
(840, 'Samochody', '2024-05-18 07:06:41', 905.6, 775.05),
(843, 'Auta', '2024-05-12 11:19:04', 514.71, 91.16),
(846, 'Auta', '2024-03-08 15:49:23', 778.16, 17.51),
(849, 'Auta', '2024-12-06 07:21:41', 80.96, 570.49),
(852, 'Auta', '2023-07-22 06:57:29', 872.9, 63.02),
(855, 'Auta', '2024-03-08 02:55:13', 115.47, 652.15),
(858, 'Dinozaury', '2023-10-04 23:56:14', 151.25, 956.76),
(861, 'Dinozaury', '2023-05-21 05:08:35', 762.41, 484.94),
(864, 'Dinozaury', '2023-05-10 22:45:42', 495.86, 413.54),
(867, 'Dinozaury', '2023-09-25 11:53:08', 441.85, 683.79),
(870, 'Dinozaury', '2023-05-20 14:34:54', 845.29, 908.62),
(873, 'Leki', '2025-01-05 16:10:44', 936.0, 976.80),
(876, 'Leki', '2024-02-18 09:58:07', 735.63, 880.28),
(879, 'Leki', '2023-06-05 22:21:53', 645.58, 163.34),
(882, 'Leki', '2024-08-28 21:32:00', 315.39, 525.33),
(885, 'Leki', '2024-02-27 07:04:22', 842.03, 938.99),
(888, 'Pokemony', '2024-02-16 08:32:06', 531.43, 551.73),
(891, 'Pokemony', '2023-08-12 13:47:12', 300.55, 273.64),
(894, 'Pokemony', '2023-02-06 09:49:57', 21.89, 813.63),
(897, 'Pokemony', '2024-02-24 06:18:03', 200.13, 642.54),
(900, 'Pokemony', '2023-08-19 19:21:21', 95.17, 68.25),
(903, 'Samochody', '2024-01-10 23:49:18', 764.06, 104.40),
(906, 'Samochody', '2024-07-14 18:08:55', 183.02, 905.03),
(909, 'Samochody', '2024-08-25 20:43:50', 406.62, 560.11),
(912, 'Samochody', '2023-01-31 22:28:37', 989.83, 548.98),
(915, 'Samochody', '2024-05-04 23:44:59', 253.18, 698.29),
(918, 'Auta', '2024-01-19 18:59:08', 851.57, 594.97),
(921, 'Auta', '2024-10-12 02:26:04', 303.68, 704.07),
(924, 'Auta', '2024-07-22 00:00:58', 982.17, 516.39),
(927, 'Auta', '2024-05-26 16:09:49', 78.65, 251.62),
(930, 'Auta', '2023-07-01 11:02:34', 636.38, 510.22),
(933, 'Dinozaury', '2024-03-09 09:30:39', 291.37, 699.26),
(936, 'Dinozaury', '2023-02-12 04:01:04', 613.58, 19.68),
(939, 'Dinozaury', '2023-06-29 11:37:53', 121.83, 608.63),
(942, 'Dinozaury', '2023-06-24 22:52:22', 291.8, 323.45),
(945, 'Dinozaury', '2024-08-20 09:25:01', 349.49, 835.38),
(948, 'Leki', '2024-12-20 05:44:33', 786.35, 815.96),
(951, 'Leki', '2023-04-15 13:22:15', 91.04, 979.67),
(954, 'Leki', '2024-04-22 14:33:37', 81.28, 136.03),
(957, 'Leki', '2023-11-13 22:20:16', 79.44, 701.43),
(960, 'Leki', '2024-10-24 17:24:16', 372.06, 351.32),
(963, 'Pokemony', '2023-04-19 15:18:31', 857.5, 42.40),
(966, 'Pokemony', '2023-12-05 22:25:45', 479.68, 303.15),
(969, 'Pokemony', '2023-07-30 06:22:49', 337.18, 978.51),
(972, 'Pokemony', '2023-06-05 01:51:37', 510.29, 56.65),
(975, 'Pokemony', '2024-04-15 01:47:19', 71.17, 533.20),
(978, 'Samochody', '2023-08-30 20:08:34', 38.75, 669.52),
(981, 'Samochody', '2023-06-07 04:34:43', 467.38, 555.33),
(984, 'Samochody', '2024-02-04 19:15:00', 318.51, 1.13),
(987, 'Samochody', '2023-06-23 16:05:47', 561.27, 114.54),
(990, 'Samochody', '2024-01-21 09:14:00', 379.26, 931.38),
(993, 'Auta', '2023-03-20 14:39:56', 462.6, 184.18),
(996, 'Auta', '2023-09-30 04:07:12', 977.34, 701.65),
(999, 'Auta', '2023-03-20 03:20:09', 712.47, 819.00),
(1002, 'Auta', '2024-02-25 11:19:16', 429.77, 568.55),
(1005, 'Auta', '2024-05-04 06:09:30', 450.43, 580.39),
(1008, 'Dinozaury', '2024-05-06 11:44:20', 341.0, 576.37),
(1011, 'Dinozaury', '2023-06-02 18:56:47', 327.44, 215.56),
(1014, 'Dinozaury', '2023-10-28 12:59:34', 323.93, 872.99),
(1017, 'Dinozaury', '2024-08-25 00:56:27', 605.36, 955.55),
(1020, 'Dinozaury', '2023-07-04 22:41:59', 593.5, 437.79),
(1023, 'Leki', '2024-01-04 04:12:38', 714.69, 134.65),
(1026, 'Leki', '2023-11-17 15:51:18', 657.22, 968.67),
(1029, 'Leki', '2024-12-25 04:20:53', 65.87, 46.38),
(1032, 'Leki', '2023-10-31 15:33:41', 599.86, 724.33),
(1035, 'Leki', '2023-05-14 15:45:59', 717.93, 258.94),
(1038, 'Pokemony', '2025-01-11 15:44:31', 281.34, 29.38),
(1041, 'Pokemony', '2023-12-22 14:58:44', 393.39, 405.78),
(1044, 'Pokemony', '2023-02-07 18:59:06', 928.17, 151.80),
(1047, 'Pokemony', '2024-12-21 07:58:27', 507.53, 664.45),
(1050, 'Pokemony', '2023-02-19 10:29:24', 371.3, 674.99),
(1053, 'Samochody', '2024-07-24 16:12:02', 997.88, 569.69),
(1056, 'Samochody', '2024-05-01 22:58:45', 17.43, 174.15),
(1059, 'Samochody', '2023-08-09 19:55:49', 725.98, 134.26),
(1062, 'Samochody', '2023-11-20 23:36:11', 68.75, 999.91),
(1065, 'Samochody', '2024-09-12 09:47:29', 879.26, 524.21),
(1068, 'Auta', '2024-08-31 06:43:30', 100.96, 521.86),
(1071, 'Auta', '2023-08-08 03:24:57', 655.13, 716.88),
(1074, 'Auta', '2023-12-15 10:16:24', 950.76, 56.12),
(1077, 'Auta', '2024-09-09 21:36:55', 290.32, 251.52),
(1080, 'Auta', '2023-08-06 10:14:06', 305.63, 284.14),
(1083, 'Dinozaury', '2023-07-25 11:07:35', 462.82, 443.05),
(1086, 'Dinozaury', '2023-09-14 10:29:47', 26.9, 690.07),
(1089, 'Dinozaury', '2023-01-22 10:30:00', 678.17, 351.72),
(1092, 'Dinozaury', '2024-10-08 15:50:53', 470.87, 762.76),
(1095, 'Dinozaury', '2023-04-18 16:09:11', 87.95, 704.51),
(1098, 'Leki', '2024-02-12 03:17:06', 474.69, 639.68),
(1101, 'Leki', '2023-04-29 20:14:36', 775.0, 431.12),
(1104, 'Leki', '2023-12-18 11:45:54', 898.32, 599.67),
(1107, 'Leki', '2023-07-11 12:52:06', 615.81, 331.78),
(1110, 'Leki', '2024-08-11 12:43:27', 353.6, 598.79),
(1113, 'Pokemony', '2024-05-26 20:45:50', 292.33, 518.54),
(1116, 'Pokemony', '2024-11-20 18:30:02', 527.27, 85.51),
(1119, 'Pokemony', '2023-02-20 05:41:38', 46.11, 409.20),
(1122, 'Pokemony', '2024-09-10 08:47:17', 789.65, 244.73),
(1125, 'Pokemony', '2025-01-13 10:00:06', 90.12, 762.45),
(1128, 'Samochody', '2024-06-09 03:20:55', 735.39, 378.05),
(1131, 'Samochody', '2023-02-15 02:09:54', 396.41, 419.47),
(1134, 'Samochody', '2024-05-05 10:13:22', 186.5, 34.20),
(1137, 'Samochody', '2023-12-09 12:15:29', 609.73, 981.61),
(1140, 'Samochody', '2023-06-04 03:04:04', 520.67, 736.82),
(1143, 'Auta', '2023-05-13 01:16:02', 499.92, 306.74),
(1146, 'Auta', '2024-03-24 02:02:16', 881.38, 787.34),
(1149, 'Auta', '2023-05-05 23:08:39', 347.6, 307.55),
(1152, 'Auta', '2023-06-05 11:29:09', 959.89, 362.12),
(1155, 'Auta', '2024-11-07 19:12:50', 429.31, 613.79),
(1158, 'Dinozaury', '2024-09-09 23:30:56', 380.82, 137.02),
(1161, 'Dinozaury', '2023-05-01 22:22:25', 713.73, 380.86),
(1164, 'Dinozaury', '2024-07-01 10:42:31', 933.36, 274.58),
(1167, 'Dinozaury', '2024-07-22 02:38:47', 602.64, 940.02),
(1170, 'Dinozaury', '2024-03-25 18:16:37', 841.14, 9.57),
(1173, 'Leki', '2023-04-16 05:31:53', 180.55, 744.57),
(1176, 'Leki', '2024-01-15 08:20:40', 767.89, 918.34),
(1179, 'Leki', '2023-03-16 18:18:31', 76.25, 627.70),
(1182, 'Leki', '2023-01-25 10:04:45', 240.89, 717.12),
(1185, 'Leki', '2024-08-02 04:26:55', 445.16, 842.72),
(1188, 'Pokemony', '2023-09-19 07:25:09', 241.72, 889.06),
(1191, 'Pokemony', '2023-02-14 23:32:57', 141.28, 407.74),
(1194, 'Pokemony', '2024-05-10 15:16:57', 123.93, 781.41),
(1197, 'Pokemony', '2023-07-04 14:25:42', 672.79, 184.99),
(1200, 'Pokemony', '2024-03-21 05:18:01', 117.92, 860.47),
(1203, 'Samochody', '2023-05-29 11:12:48', 885.07, 341.83),
(1206, 'Samochody', '2023-07-25 12:59:47', 917.93, 782.85),
(1209, 'Samochody', '2024-06-08 12:48:58', 789.82, 234.16),
(1212, 'Samochody', '2024-07-31 02:10:04', 498.22, 259.01),
(1215, 'Samochody', '2023-08-26 00:22:40', 476.55, 359.03),
(1218, 'Auta', '2024-03-21 07:50:15', 330.39, 374.30),
(1221, 'Auta', '2023-09-25 04:03:13', 673.03, 517.33),
(1224, 'Auta', '2023-07-19 09:55:17', 856.66, 341.05),
(1227, 'Auta', '2024-11-24 06:25:09', 537.03, 42.28),
(1230, 'Auta', '2023-08-02 17:17:45', 674.31, 922.44),
(1233, 'Dinozaury', '2024-06-09 15:18:23', 691.22, 862.71),
(1236, 'Dinozaury', '2023-10-26 06:40:41', 294.99, 951.17),
(1239, 'Dinozaury', '2023-08-30 04:00:18', 710.34, 562.94),
(1242, 'Dinozaury', '2024-06-01 10:48:40', 500.93, 251.82),
(1245, 'Dinozaury', '2024-09-13 01:36:33', 784.26, 83.15),
(1248, 'Leki', '2024-12-19 05:51:50', 395.9, 686.48),
(1251, 'Leki', '2024-12-25 04:16:44', 671.77, 314.84),
(1254, 'Leki', '2024-10-22 16:28:40', 596.17, 829.56),
(1257, 'Leki', '2023-11-06 21:38:39', 881.29, 933.03),
(1260, 'Leki', '2024-11-16 07:33:45', 724.27, 694.37),
(1263, 'Pokemony', '2024-01-30 07:34:08', 99.05, 464.42),
(1266, 'Pokemony', '2023-12-19 01:34:08', 826.99, 805.78),
(1269, 'Pokemony', '2023-09-07 20:43:01', 178.29, 402.40),
(1272, 'Pokemony', '2023-08-21 12:01:06', 546.1, 633.44),
(1275, 'Pokemony', '2023-02-11 20:59:07', 671.48, 941.62),
(1278, 'Samochody', '2023-12-09 06:54:10', 57.09, 41.60),
(1281, 'Samochody', '2023-02-20 09:53:31', 694.65, 631.89),
(1284, 'Samochody', '2024-08-31 20:25:50', 537.12, 573.07),
(1287, 'Samochody', '2023-03-06 00:17:17', 256.72, 433.22),
(1290, 'Samochody', '2023-03-04 00:12:16', 818.32, 600.67),
(1293, 'Auta', '2024-04-21 14:26:57', 548.0, 291.25),
(1296, 'Auta', '2024-04-19 03:33:37', 326.92, 475.91),
(1299, 'Auta', '2023-03-18 16:23:31', 197.97, 325.24),
(1302, 'Auta', '2024-10-25 15:12:43', 556.17, 868.07),
(1305, 'Auta', '2024-10-23 16:23:36', 895.6, 663.95),
(1308, 'Dinozaury', '2024-01-04 12:14:36', 919.95, 860.69),
(1311, 'Dinozaury', '2023-10-27 04:47:29', 625.11, 138.24),
(1314, 'Dinozaury', '2024-03-02 00:52:41', 89.89, 862.10),
(1317, 'Dinozaury', '2024-11-18 13:01:13', 916.48, 734.23),
(1320, 'Dinozaury', '2024-07-21 05:08:50', 223.2, 199.70),
(1323, 'Leki', '2023-06-21 03:23:18', 899.49, 254.32),
(1326, 'Leki', '2023-05-07 10:24:20', 963.26, 538.46),
(1329, 'Leki', '2024-09-01 07:19:37', 930.25, 704.20),
(1332, 'Leki', '2025-01-12 16:30:40', 342.32, 311.80),
(1335, 'Leki', '2024-11-06 06:03:59', 571.93, 600.72),
(1338, 'Pokemony', '2024-01-10 04:24:46', 600.06, 492.76),
(1341, 'Pokemony', '2023-06-24 13:54:59', 133.46, 857.41),
(1344, 'Pokemony', '2024-05-30 21:29:19', 751.77, 958.46),
(1347, 'Pokemony', '2025-01-05 14:53:58', 380.72, 398.95),
(1350, 'Pokemony', '2024-01-09 14:47:04', 889.48, 384.21),
(1353, 'Samochody', '2023-06-24 01:41:17', 480.26, 84.66),
(1356, 'Samochody', '2023-05-07 19:55:07', 371.88, 570.16),
(1359, 'Samochody', '2023-12-05 19:13:25', 512.93, 329.76),
(1362, 'Samochody', '2023-04-27 13:37:12', 328.41, 179.50),
(1365, 'Samochody', '2023-04-26 01:12:23', 951.92, 667.20),
(1368, 'Auta', '2023-10-15 23:27:53', 922.54, 123.93),
(1371, 'Auta', '2023-12-30 04:38:59', 241.71, 708.71),
(1374, 'Auta', '2023-03-06 05:58:02', 976.67, 630.70),
(1377, 'Auta', '2023-04-18 15:51:54', 775.48, 556.33),
(1380, 'Auta', '2023-06-04 09:04:13', 991.84, 977.87),
(1383, 'Dinozaury', '2023-04-13 08:32:08', 563.39, 48.13),
(1386, 'Dinozaury', '2023-08-28 00:57:42', 848.79, 34.52),
(1389, 'Dinozaury', '2024-08-06 04:41:26', 245.41, 791.31),
(1392, 'Dinozaury', '2023-07-27 01:09:53', 828.26, 182.34),
(1395, 'Dinozaury', '2024-07-05 08:32:38', 329.16, 831.99),
(1398, 'Leki', '2023-05-14 12:58:06', 668.7, 207.70),
(1401, 'Leki', '2024-12-18 10:35:21', 719.32, 826.00),
(1404, 'Leki', '2024-12-02 21:45:05', 231.94, 691.07),
(1407, 'Leki', '2024-02-21 15:07:08', 723.03, 119.81),
(1410, 'Leki', '2023-06-27 18:05:05', 640.72, 118.56),
(1413, 'Pokemony', '2023-07-12 14:16:00', 195.3, 880.94),
(1416, 'Pokemony', '2024-11-19 16:51:54', 30.12, 117.79),
(1419, 'Pokemony', '2024-07-09 08:22:58', 615.91, 789.02),
(1422, 'Pokemony', '2023-04-03 09:57:31', 735.27, 990.31),
(1425, 'Pokemony', '2023-08-24 02:25:52', 722.3, 705.41),
(1428, 'Samochody', '2024-10-04 19:55:43', 544.11, 559.64),
(1431, 'Samochody', '2024-02-26 06:32:46', 221.0, 27.77),
(1434, 'Samochody', '2023-10-05 18:58:28', 8.19, 596.65),
(1437, 'Samochody', '2023-06-13 11:20:31', 866.98, 622.53),
(1440, 'Samochody', '2023-07-31 04:41:22', 250.84, 451.74),
(1443, 'Auta', '2023-01-17 19:43:23', 99.53, 399.90),
(1446, 'Auta', '2024-05-30 05:01:08', 630.84, 795.52),
(1449, 'Auta', '2023-10-24 14:43:50', 454.89, 627.54),
(1452, 'Auta', '2024-06-16 19:26:48', 671.52, 163.26),
(1455, 'Auta', '2024-11-17 18:09:22', 303.36, 748.12),
(1458, 'Dinozaury', '2024-11-21 22:06:20', 206.33, 12.51),
(1461, 'Dinozaury', '2023-02-02 17:28:08', 184.06, 38.94),
(1464, 'Dinozaury', '2023-04-08 06:27:43', 970.28, 175.31),
(1467, 'Dinozaury', '2024-02-14 00:34:36', 564.1, 811.12),
(1470, 'Dinozaury', '2024-09-12 16:16:09', 774.73, 130.36),
(1473, 'Leki', '2024-03-10 14:00:14', 852.95, 937.82),
(1476, 'Leki', '2023-01-22 13:48:32', 714.81, 80.37),
(1479, 'Leki', '2023-08-09 04:21:09', 952.65, 672.79),
(1482, 'Leki', '2023-04-16 03:13:29', 8.52, 899.65),
(1485, 'Leki', '2024-10-01 03:00:29', 331.49, 752.93),
(1488, 'Pokemony', '2023-09-11 22:23:39', 754.36, 946.56),
(1491, 'Pokemony', '2025-01-07 23:20:00', 167.19, 338.94),
(1494, 'Pokemony', '2023-06-25 14:38:57', 170.08, 381.19),
(1497, 'Pokemony', '2024-02-01 17:07:30', 899.03, 745.11),
(1500, 'Pokemony', '2023-12-25 19:46:02', 40.64, 7.97);
```

### 3. Orders

```sql
INSERT  INTO Orders (OrderID,CustomerID,OrderDate,PaymentAssesed,Paymentpaid,PaymentWaived,DueDate,OrderStatus)
VALUES
  (1, 4, '2024-06-21 09:30:42', 509.51, 446.08, 932.86, '2023-07-17 20:28:08',  'InCart'),
(2, 100, '2023-08-22 01:04:38', 934.28, 884.93, 708.3, '2023-05-18 21:32:19',  'InCart'),
(3, 92, '2023-07-25 21:13:17', 641.72, 466.54, 313.8, '2024-10-05 17:29:07',  'Ordered'),
(4, 68, '2024-06-12 12:10:32', 738.24, 375.79, 294.12, '2024-12-12 13:57:29',  'Ordered'),
(5, 3, '2024-09-19 14:10:04', 284.07, 720.53, 324.97, '2025-01-26 15:18:46',  'InCart'),
(6, 12, '2024-12-29 17:47:45', 630.59, 163.2, 553.67, '2024-12-18 10:06:37',  'InCart'),
(7, 90, '2023-07-13 18:27:34', 366.15, 353.04, 755.7, '2024-01-27 02:01:34',  'Ordered'),
(8, 96, '2023-09-08 14:15:43', 306.8, 240.96, 950.65, '2024-12-14 23:56:34',  'Ordered'),
(9, 44, '2023-04-12 00:28:18', 311.18, 246.27, 239.15, '2024-12-27 20:14:15',  'InCart'),
(10, 52, '2025-01-27 08:43:52', 811.86, 182.53, 925.15, '2023-11-10 14:20:15',  'InCart'),
(11, 65, '2023-04-26 04:33:30', 86.52, 956.86, 329.0, '2023-01-23 19:37:42',  'Ordered'),
(12, 8, '2023-01-28 08:46:40', 473.11, 289.69, 110.38, '2023-06-06 16:44:42',  'Ordered'),
(13, 69, '2024-04-10 02:52:02', 329.35, 18.96, 21.2, '2023-09-19 05:38:48',  'InCart'),
(14, 44, '2023-06-18 14:11:59', 690.22, 580.87, 235.86, '2023-01-26 15:16:48',  'InCart'),
(15, 100, '2024-01-03 02:09:01', 920.83, 789.23, 261.29, '2024-04-12 17:01:51',  'Ordered'),
(16, 16, '2023-09-01 11:28:04', 305.07, 163.82, 973.24, '2024-10-25 18:32:42',  'Ordered'),
(17, 7, '2024-07-27 05:31:33', 358.75, 933.0, 211.06, '2024-06-21 06:10:31',  'InCart'),
(18, 32, '2023-11-16 23:49:22', 432.9, 895.14, 754.12, '2023-07-29 06:51:07',  'InCart'),
(19, 7, '2023-06-15 19:29:16', 832.61, 131.98, 620.93, '2024-02-28 11:27:42',  'Ordered'),
(20, 30, '2024-12-15 21:00:52', 717.94, 731.34, 263.98, '2023-11-06 08:21:46',  'Ordered'),
(21, 77, '2024-11-21 17:53:18', 688.26, 302.62, 90.26, '2024-06-19 03:17:14',  'InCart'),
(22, 4, '2023-12-14 13:05:30', 781.06, 56.54, 633.69, '2024-06-10 19:48:07',  'InCart'),
(23, 17, '2024-04-27 01:20:00', 497.77, 461.05, 640.76, '2024-09-21 06:45:56',  'Ordered'),
(24, 84, '2024-04-06 10:01:05', 862.5, 112.59, 630.6, '2024-10-21 05:33:58',  'Ordered'),
(25, 5, '2024-03-31 11:54:28', 267.28, 144.27, 297.82, '2023-10-21 16:06:08',  'InCart'),
(26, 66, '2023-12-02 06:46:02', 880.57, 612.1, 690.07, '2024-03-18 20:05:25',  'InCart'),
(27, 79, '2025-01-22 04:52:52', 93.71, 228.18, 999.95, '2024-03-01 11:29:52',  'Ordered'),
(28, 91, '2024-11-04 10:23:30', 908.26, 151.55, 295.73, '2024-04-01 15:19:12',  'Ordered'),
(29, 22, '2023-12-14 14:14:34', 393.41, 89.03, 554.38, '2023-02-27 09:52:19',  'InCart'),
(30, 42, '2023-11-08 17:22:17', 376.49, 808.3, 393.52, '2024-08-13 04:04:27',  'InCart'),
(31, 56, '2024-02-01 02:08:12', 392.89, 534.61, 253.84, '2023-10-11 15:09:26',  'Ordered'),
(32, 31, '2024-01-28 14:43:19', 815.43, 553.38, 762.88, '2024-12-21 15:16:00',  'Ordered'),
(33, 32, '2024-11-07 18:49:29', 96.94, 263.71, 912.26, '2023-02-15 13:36:37',  'InCart'),
(34, 9, '2024-09-26 18:19:17', 746.58, 38.75, 987.92, '2023-05-28 08:28:30',  'InCart'),
(35, 40, '2024-12-06 22:26:50', 640.49, 245.88, 693.79, '2024-04-25 00:30:05',  'Ordered'),
(36, 88, '2024-08-19 16:42:26', 438.47, 539.92, 775.88, '2023-11-01 22:42:52',  'Ordered'),
(37, 45, '2024-03-01 17:35:56', 366.13, 549.02, 476.94, '2025-02-08 17:50:14',  'InCart'),
(38, 28, '2024-10-19 12:43:42', 52.25, 943.03, 419.15, '2023-02-10 05:16:40',  'InCart'),
(39, 94, '2023-08-31 06:50:44', 825.92, 756.9, 957.1, '2024-12-16 15:41:09',  'Ordered'),
(40, 2, '2023-03-04 20:41:46', 275.08, 459.65, 336.82, '2024-06-12 17:37:35',  'Ordered'),
(41, 55, '2024-02-29 07:59:36', 858.34, 223.62, 508.09, '2023-03-22 17:37:43',  'InCart'),
(42, 64, '2024-06-05 19:45:14', 921.03, 125.08, 341.78, '2023-01-30 03:34:44',  'InCart'),
(43, 47, '2023-07-16 18:24:52', 147.03, 184.03, 869.11, '2024-02-25 15:36:35',  'Ordered'),
(44, 50, '2023-10-30 00:13:22', 236.18, 976.31, 845.15, '2024-07-24 17:38:21',  'Ordered'),
(45, 18, '2025-01-17 09:09:50', 174.37, 579.9, 902.25, '2024-02-16 19:17:42',  'InCart'),
(46, 13, '2024-10-04 02:15:24', 381.15, 301.83, 220.19, '2023-07-27 09:37:18',  'InCart'),
(47, 87, '2023-06-21 05:04:21', 131.18, 592.68, 37.59, '2023-02-25 08:43:08',  'Ordered'),
(48, 20, '2024-11-04 09:22:54', 879.93, 590.67, 75.38, '2024-01-11 06:21:27',  'Ordered'),
(49, 89, '2024-07-30 08:10:00', 118.92, 950.19, 374.2, '2023-09-10 23:27:24',  'InCart'),
(50, 70, '2023-11-06 01:27:39', 48.01, 601.38, 601.35, '2024-01-18 15:19:46',  'InCart'),
(51, 87, '2024-07-18 05:36:00', 591.79, 686.53, 420.25, '2024-10-17 07:42:14',  'Ordered'),
(52, 5, '2024-01-10 16:44:47', 306.63, 344.49, 772.03, '2024-01-23 11:05:40',  'Ordered'),
(53, 22, '2023-04-09 21:11:19', 673.19, 813.05, 201.34, '2025-02-01 10:44:09',  'InCart'),
(54, 56, '2024-03-09 11:38:14', 475.9, 52.32, 829.78, '2023-08-10 13:26:47',  'InCart'),
(55, 32, '2024-04-12 13:07:22', 219.76, 801.6, 865.8, '2023-06-21 05:15:05',  'Ordered'),
(56, 26, '2023-07-04 15:39:59', 670.27, 644.8, 501.12, '2023-01-17 20:36:29',  'Ordered'),
(57, 8, '2024-06-14 21:46:49', 992.78, 272.58, 310.89, '2023-07-02 04:58:51',  'InCart'),
(58, 46, '2023-07-03 20:13:44', 836.08, 124.58, 150.94, '2024-07-18 16:05:22',  'InCart'),
(59, 72, '2023-09-09 12:51:44', 14.52, 720.24, 322.5, '2023-03-04 21:01:10',  'Ordered'),
(60, 22, '2024-02-10 05:01:06', 404.46, 169.87, 664.53, '2024-09-21 22:31:52',  'Ordered'),
(61, 71, '2023-07-01 09:36:35', 639.91, 641.09, 800.23, '2023-06-24 01:36:02',  'InCart'),
(62, 61, '2025-01-10 07:10:09', 247.69, 146.82, 58.75, '2024-05-15 17:47:17',  'InCart'),
(63, 60, '2024-12-24 17:29:13', 595.7, 635.44, 195.7, '2023-10-18 11:59:48',  'Ordered'),
(64, 46, '2024-09-14 14:22:08', 451.42, 785.54, 536.88, '2024-08-15 00:31:58',  'Ordered'),
(65, 81, '2024-01-25 00:38:35', 312.82, 100.88, 374.4, '2024-04-27 14:45:14',  'InCart'),
(66, 90, '2024-09-05 04:30:47', 907.13, 852.66, 33.57, '2024-06-16 05:15:24',  'InCart'),
(67, 82, '2023-09-16 01:48:16', 565.47, 408.26, 805.36, '2024-10-18 07:46:43',  'Ordered'),
(68, 64, '2023-09-17 17:51:23', 133.97, 995.72, 820.37, '2023-03-19 21:27:23',  'Ordered'),
(69, 70, '2024-09-09 09:02:18', 455.33, 865.98, 13.31, '2024-09-21 04:43:21',  'InCart'),
(70, 87, '2023-07-03 23:14:01', 482.95, 746.75, 613.69, '2023-02-07 13:59:08',  'InCart'),
(71, 63, '2023-10-18 09:28:11', 478.19, 128.15, 769.53, '2023-08-20 04:58:19',  'Ordered'),
(72, 41, '2024-10-01 06:05:32', 63.37, 576.59, 715.07, '2023-05-21 12:33:10',  'Ordered'),
(73, 39, '2025-01-06 17:02:05', 297.48, 4.03, 655.96, '2024-03-06 06:10:31',  'InCart'),
(74, 42, '2023-10-18 05:31:13', 0.05, 733.53, 574.03, '2023-09-12 03:56:57',  'InCart'),
(75, 27, '2024-11-11 19:32:27', 350.29, 344.36, 911.25, '2024-06-13 16:33:49',  'Ordered'),
(76, 15, '2023-11-23 09:33:17', 361.07, 360.69, 708.5, '2024-12-26 03:15:10',  'Ordered'),
(77, 62, '2023-11-25 09:03:23', 722.03, 28.46, 395.33, '2023-05-18 19:17:51',  'InCart'),
(78, 50, '2023-08-20 11:24:06', 412.52, 419.7, 529.24, '2023-07-30 20:37:35',  'InCart'),
(79, 85, '2023-08-03 06:56:05', 106.37, 176.64, 890.88, '2025-01-10 21:44:14',  'Ordered'),
(80, 45, '2023-03-02 23:33:20', 749.89, 662.3, 247.48, '2024-01-07 14:45:31',  'Ordered'),
(81, 48, '2023-07-05 05:28:33', 497.68, 888.32, 377.53, '2023-02-06 08:11:51',  'InCart'),
(82, 4, '2023-04-26 22:24:42', 971.64, 508.95, 781.5, '2024-03-27 10:17:58',  'InCart'),
(83, 63, '2023-10-06 19:09:39', 179.86, 978.75, 25.12, '2024-12-29 21:40:04',  'Ordered'),
(84, 32, '2023-07-24 23:33:14', 332.05, 512.91, 79.33, '2023-07-01 18:00:08',  'Ordered'),
(85, 37, '2024-07-11 19:27:40', 495.44, 91.81, 51.07, '2024-04-16 15:46:16',  'InCart'),
(86, 75, '2024-06-04 00:58:01', 292.13, 126.56, 811.59, '2024-07-13 01:53:43',  'InCart'),
(87, 24, '2024-09-30 01:41:52', 867.1, 701.14, 319.14, '2024-11-21 22:53:53',  'Ordered'),
(88, 5, '2025-01-14 11:48:27', 614.11, 988.03, 185.33, '2023-01-18 05:47:26',  'Ordered'),
(89, 67, '2024-02-21 04:40:03', 678.82, 319.79, 492.83, '2024-08-09 01:06:31',  'InCart'),
(90, 56, '2024-08-01 14:15:51', 544.58, 101.81, 889.15, '2024-07-31 21:12:10',  'InCart'),
(91, 79, '2023-06-16 20:55:58', 218.08, 360.96, 541.49, '2023-01-27 23:43:27',  'Ordered'),
(92, 68, '2024-11-27 20:36:42', 431.66, 766.95, 379.89, '2024-06-10 02:44:28',  'Ordered'),
(93, 10, '2023-10-23 17:08:17', 303.5, 300.08, 116.78, '2023-11-03 06:47:23',  'InCart'),
(94, 11, '2024-05-29 22:39:03', 614.41, 60.27, 7.31, '2025-01-21 06:26:19',  'InCart'),
(95, 52, '2023-11-07 15:31:48', 397.31, 627.73, 291.02, '2023-08-03 06:23:51',  'Ordered'),
(96, 84, '2024-12-23 08:37:09', 655.57, 1.21, 447.23, '2024-04-05 20:06:41',  'Ordered'),
(97, 67, '2024-03-11 03:08:45', 934.04, 88.48, 531.04, '2025-02-03 20:08:53',  'InCart'),
(98, 62, '2024-07-10 20:53:08', 230.07, 326.55, 784.76, '2024-05-19 18:24:50',  'InCart'),
(99, 77, '2024-01-26 05:25:20', 298.53, 191.92, 52.08, '2024-01-08 19:00:04',  'Ordered'),
(100, 51, '2023-03-16 17:58:13', 414.42, 952.69, 39.08, '2023-05-28 10:18:40',  'Ordered'),
(101, 42, '2024-07-18 14:48:52', 20.62, 200.51, 522.87, '2024-12-29 08:13:26',  'InCart'),
(102, 85, '2024-11-06 15:46:32', 96.43, 298.28, 44.36, '2023-08-02 01:58:38',  'InCart'),
(103, 63, '2023-07-14 22:20:03', 425.56, 548.13, 293.65, '2023-11-11 05:46:32',  'Ordered'),
(104, 86, '2024-12-22 22:03:52', 527.9, 594.04, 633.65, '2023-10-29 19:51:48',  'Ordered'),
(105, 61, '2024-06-24 09:54:17', 462.92, 939.96, 950.59, '2024-03-28 14:37:59',  'InCart'),
(106, 13, '2023-06-17 23:25:37', 332.7, 411.88, 964.58, '2024-06-03 10:52:35',  'InCart'),
(107, 4, '2025-01-10 14:27:25', 336.38, 552.29, 279.81, '2023-05-02 20:32:06',  'Ordered'),
(108, 39, '2024-07-29 03:10:48', 581.28, 772.05, 161.49, '2023-08-23 07:33:54',  'Ordered'),
(109, 7, '2024-04-30 10:50:46', 95.75, 661.08, 618.02, '2024-05-26 19:56:24',  'InCart'),
(110, 16, '2024-08-15 15:06:32', 171.98, 793.36, 172.76, '2024-03-30 16:05:18',  'InCart'),
(111, 96, '2024-05-09 00:13:33', 378.93, 22.76, 598.95, '2024-07-09 21:10:05',  'Ordered'),
(112, 0, '2024-05-02 23:53:57', 385.97, 963.02, 442.61, '2024-02-26 09:09:08',  'Ordered'),
(113, 41, '2024-05-07 13:43:10', 384.67, 950.2, 466.94, '2024-11-13 14:00:21',  'InCart'),
(114, 9, '2024-05-20 10:20:22', 32.93, 495.52, 206.03, '2023-01-21 22:48:44',  'InCart'),
(115, 27, '2023-09-13 18:49:19', 382.05, 21.96, 906.68, '2024-01-20 04:18:00',  'Ordered'),
(116, 76, '2024-01-25 11:55:40', 42.22, 217.81, 452.5, '2025-02-13 03:12:42',  'Ordered'),
(117, 75, '2024-10-06 16:27:45', 578.27, 208.46, 863.44, '2024-03-10 05:24:10',  'InCart'),
(118, 95, '2024-01-22 09:14:07', 900.73, 470.77, 748.47, '2023-04-26 10:40:47',  'InCart'),
(119, 71, '2023-08-26 03:45:44', 461.17, 297.59, 173.04, '2023-02-24 00:45:04',  'Ordered'),
(120, 47, '2023-07-31 19:41:59', 59.27, 725.3, 550.39, '2023-08-20 14:13:25',  'Ordered'),
(121, 40, '2024-09-13 11:11:16', 54.77, 125.63, 986.4, '2024-12-29 22:44:55',  'InCart'),
(122, 70, '2023-05-14 16:35:21', 588.23, 365.85, 794.46, '2023-03-09 16:18:00',  'InCart'),
(123, 98, '2024-07-21 03:15:02', 94.5, 875.49, 165.44, '2024-01-12 09:36:27',  'Ordered'),
(124, 60, '2023-11-19 06:28:27', 45.72, 986.52, 619.19, '2023-01-19 02:33:29',  'Ordered'),
(125, 29, '2023-10-17 21:33:08', 159.96, 932.96, 252.56, '2023-09-21 14:41:39',  'InCart'),
(126, 53, '2023-05-20 12:33:08', 755.05, 325.3, 117.47, '2023-08-04 21:04:19',  'InCart'),
(127, 5, '2024-10-09 02:24:01', 646.09, 433.07, 875.2, '2024-04-30 06:45:13',  'Ordered'),
(128, 26, '2024-12-03 01:55:14', 122.39, 238.94, 164.95, '2023-12-23 19:57:04',  'Ordered'),
(129, 4, '2024-01-04 04:48:27', 577.64, 632.64, 304.95, '2024-05-16 18:31:55',  'InCart'),
(130, 50, '2024-11-23 12:24:31', 996.6, 134.57, 510.13, '2024-04-04 11:58:25',  'InCart'),
(131, 70, '2023-07-27 00:51:48', 208.19, 319.6, 130.79, '2023-08-27 05:19:18',  'Ordered'),
(132, 52, '2024-11-11 10:29:44', 132.92, 963.8, 170.55, '2024-04-26 06:39:11',  'Ordered'),
(133, 17, '2023-01-15 11:04:46', 475.79, 588.5, 628.02, '2023-02-19 21:25:34',  'InCart'),
(134, 45, '2024-09-02 14:59:48', 47.36, 966.33, 881.85, '2023-08-11 05:20:31',  'InCart'),
(135, 19, '2024-11-08 10:05:15', 707.27, 893.31, 772.67, '2023-12-03 23:07:46',  'Ordered'),
(136, 94, '2023-01-17 16:30:47', 521.89, 133.92, 915.49, '2024-04-12 13:31:41',  'Ordered'),
(137, 75, '2024-09-11 06:09:55', 719.56, 289.17, 159.0, '2023-05-06 00:15:59',  'InCart'),
(138, 87, '2024-04-21 11:50:54', 8.07, 449.82, 760.77, '2024-07-11 08:46:36',  'InCart'),
(139, 46, '2024-10-02 10:55:44', 913.76, 828.16, 289.25, '2023-05-14 00:47:07',  'Ordered'),
(140, 4, '2024-01-10 03:57:01', 542.5, 296.33, 919.89, '2024-07-29 00:31:00',  'Ordered'),
(141, 26, '2023-08-28 18:12:44', 330.51, 987.75, 525.51, '2023-08-24 13:52:17',  'InCart'),
(142, 10, '2023-06-27 05:18:56', 423.96, 433.06, 587.7, '2023-11-08 06:15:42',  'InCart'),
(143, 12, '2023-09-15 11:34:47', 890.56, 272.71, 288.28, '2024-08-01 10:34:05',  'Ordered'),
(144, 54, '2024-04-05 21:04:35', 637.13, 921.68, 70.14, '2024-04-28 23:04:36',  'Ordered'),
(145, 93, '2023-06-15 02:28:37', 399.05, 530.73, 128.13, '2023-05-07 06:21:43',  'InCart'),
(146, 28, '2023-01-24 18:41:58', 774.46, 945.13, 122.63, '2023-12-07 07:41:37',  'InCart'),
(147, 29, '2023-02-15 05:14:07', 713.69, 81.62, 800.54, '2023-04-07 15:44:19',  'Ordered'),
(148, 66, '2024-10-25 12:17:29', 767.93, 463.83, 89.76, '2024-06-09 05:56:22',  'Ordered'),
(149, 61, '2023-05-06 05:04:44', 363.66, 498.41, 648.99, '2024-03-03 00:09:21',  'InCart'),
(150, 18, '2024-04-02 13:43:45', 503.76, 578.67, 810.73, '2023-10-27 23:09:00',  'InCart'),
(151, 93, '2024-03-11 06:24:19', 502.75, 709.11, 164.81, '2023-10-12 15:01:27',  'Ordered'),
(152, 6, '2023-02-22 09:05:05', 948.27, 901.41, 653.22, '2023-03-06 07:41:58',  'Ordered'),
(153, 76, '2024-05-31 05:50:33', 813.36, 964.11, 598.77, '2024-01-08 22:56:15',  'InCart'),
(154, 3, '2024-03-25 11:27:08', 612.81, 561.16, 68.22, '2024-03-09 08:53:36',  'InCart'),
(155, 26, '2023-04-11 01:43:03', 550.73, 658.55, 111.79, '2024-09-20 18:51:36',  'Ordered'),
(156, 26, '2024-02-23 17:31:50', 918.67, 279.22, 413.54, '2023-06-18 12:26:51',  'Ordered'),
(157, 87, '2024-02-20 05:54:01', 553.92, 73.81, 743.68, '2023-01-21 14:36:41',  'InCart'),
(158, 81, '2024-03-07 00:40:55', 778.79, 69.92, 783.86, '2023-08-03 12:57:12',  'InCart'),
(159, 85, '2023-05-10 08:36:54', 981.31, 985.32, 867.2, '2023-06-13 02:36:00',  'Ordered'),
(160, 27, '2023-01-20 12:29:27', 566.86, 518.93, 967.34, '2025-01-09 21:44:56',  'Ordered'),
(161, 51, '2024-09-14 04:52:44', 397.92, 250.15, 604.16, '2023-04-13 18:37:05',  'InCart'),
(162, 5, '2024-06-14 10:25:30', 905.8, 906.61, 344.58, '2025-01-09 17:30:06',  'InCart'),
(163, 14, '2024-03-23 12:41:11', 528.8, 106.41, 805.72, '2024-02-16 08:32:19',  'Ordered'),
(164, 9, '2023-07-30 16:07:33', 76.54, 17.35, 469.48, '2024-05-09 01:58:24',  'Ordered'),
(165, 70, '2025-01-12 08:48:13', 981.9, 710.61, 888.36, '2024-10-16 17:29:20',  'InCart'),
(166, 69, '2023-08-12 02:30:48', 176.31, 34.83, 835.9, '2023-03-23 16:17:03',  'InCart'),
(167, 45, '2024-06-09 04:57:46', 134.54, 353.94, 248.18, '2024-09-05 19:08:24',  'Ordered'),
(168, 68, '2023-05-29 06:18:25', 660.36, 861.75, 982.23, '2025-01-17 01:03:05',  'Ordered'),
(169, 93, '2024-09-27 09:44:02', 63.22, 615.3, 832.63, '2024-06-18 05:06:34',  'InCart'),
(170, 25, '2024-11-29 11:28:01', 53.43, 851.43, 261.27, '2023-10-30 03:46:34',  'InCart'),
(171, 39, '2024-11-22 23:36:03', 177.01, 57.39, 866.72, '2023-10-23 03:48:41',  'Ordered'),
(172, 44, '2024-07-10 02:16:21', 912.48, 302.54, 773.27, '2024-10-04 19:36:51',  'Ordered'),
(173, 44, '2023-07-16 03:54:32', 66.72, 791.1, 882.18, '2023-10-04 06:47:19',  'InCart'),
(174, 78, '2023-01-22 22:27:56', 153.85, 941.34, 190.23, '2023-08-22 21:38:16',  'InCart'),
(175, 30, '2023-12-17 11:20:04', 700.48, 852.41, 924.48, '2024-10-24 22:12:27',  'Ordered'),
(176, 31, '2024-01-01 11:21:55', 93.73, 656.21, 596.78, '2023-06-10 21:12:31',  'Ordered'),
(177, 80, '2024-01-31 12:34:15', 574.22, 286.63, 358.05, '2023-08-26 23:59:43',  'InCart'),
(178, 61, '2025-01-10 18:02:36', 702.45, 843.47, 112.53, '2023-09-02 21:22:03',  'InCart'),
(179, 20, '2024-02-23 14:59:35', 389.65, 785.79, 218.06, '2023-08-10 00:13:14',  'Ordered'),
(180, 10, '2023-01-27 15:44:32', 991.38, 688.21, 715.69, '2023-05-10 03:05:06',  'Ordered'),
(181, 92, '2023-09-15 20:22:52', 806.57, 468.62, 472.28, '2024-08-04 20:56:11',  'InCart'),
(182, 50, '2024-06-24 18:41:02', 952.69, 591.27, 808.3, '2024-01-12 10:44:06',  'InCart'),
(183, 10, '2024-03-20 07:40:58', 505.22, 654.52, 682.72, '2024-09-10 19:50:21',  'Ordered'),
(184, 79, '2024-09-08 13:45:32', 227.02, 399.17, 206.02, '2024-08-01 10:31:54',  'Ordered'),
(185, 85, '2024-12-18 09:18:52', 176.66, 504.79, 777.28, '2023-12-22 23:49:40',  'InCart'),
(186, 83, '2024-02-21 03:44:26', 510.82, 451.5, 156.41, '2024-06-15 08:00:26',  'InCart'),
(187, 32, '2024-01-27 10:42:05', 579.96, 244.8, 172.56, '2024-04-12 16:35:13',  'Ordered'),
(188, 6, '2024-07-25 16:50:30', 202.54, 709.2, 497.02, '2023-08-08 17:59:23',  'Ordered'),
(189, 68, '2024-02-25 18:52:35', 828.03, 592.16, 756.05, '2023-06-09 13:24:10',  'InCart'),
(190, 94, '2023-10-04 22:11:46', 162.28, 716.3, 732.07, '2023-10-14 12:16:59',  'InCart'),
(191, 86, '2023-02-09 04:07:55', 624.11, 242.67, 191.01, '2023-10-25 09:13:00',  'Ordered'),
(192, 67, '2024-04-24 12:38:33', 707.47, 202.37, 689.3, '2024-04-09 17:28:24',  'Ordered'),
(193, 28, '2024-03-04 15:21:19', 457.89, 781.71, 234.4, '2023-02-18 20:54:38',  'InCart'),
(194, 64, '2023-01-21 08:25:33', 924.79, 205.72, 800.41, '2024-01-28 21:09:14',  'InCart'),
(195, 100, '2023-06-17 02:19:27', 6.58, 484.39, 645.82, '2024-12-21 10:29:26',  'Ordered'),
(196, 85, '2023-05-13 17:45:42', 581.38, 331.16, 981.71, '2024-03-19 05:48:56',  'Ordered'),
(197, 84, '2023-08-24 11:57:24', 481.56, 9.3, 872.43, '2023-06-14 19:08:18',  'InCart'),
(198, 56, '2024-05-12 19:55:38', 326.32, 56.25, 343.56, '2024-08-15 17:00:53',  'InCart'),
(199, 34, '2024-05-22 22:45:29', 874.35, 366.9, 331.24, '2024-05-22 02:59:59',  'Ordered'),
(200, 77, '2023-02-21 19:29:56', 858.85, 362.31, 723.64, '2023-11-19 20:46:14',  'Ordered'),
(201, 93, '2023-07-08 02:31:25', 308.26, 461.27, 190.12, '2024-03-22 16:14:03',  'InCart'),
(202, 1, '2023-01-30 11:09:48', 898.76, 932.59, 330.53, '2024-04-12 14:08:29',  'InCart'),
(203, 90, '2024-01-14 17:14:25', 198.5, 974.47, 204.63, '2024-01-24 19:23:47',  'Ordered'),
(204, 43, '2024-10-11 09:04:21', 807.44, 554.39, 782.7, '2024-02-19 22:16:21',  'Ordered'),
(205, 0, '2024-02-22 01:03:52', 738.43, 854.34, 735.57, '2025-01-31 14:28:56',  'InCart'),
(206, 63, '2024-04-08 20:42:06', 941.34, 721.29, 919.08, '2025-02-04 15:36:39',  'InCart'),
(207, 17, '2024-01-07 15:56:41', 417.85, 468.16, 19.53, '2023-05-23 04:56:30',  'Ordered'),
(208, 84, '2023-09-12 18:21:11', 793.01, 300.16, 969.33, '2023-11-03 09:51:00',  'Ordered'),
(209, 12, '2024-07-26 18:21:39', 12.87, 831.82, 934.33, '2024-03-13 04:11:27',  'InCart'),
(210, 17, '2023-12-22 17:14:56', 786.0, 183.13, 762.46, '2023-11-01 05:17:16',  'InCart'),
(211, 78, '2024-01-07 17:22:59', 122.7, 371.36, 332.3, '2024-02-15 14:47:03',  'Ordered'),
(212, 1, '2023-04-05 06:36:30', 400.41, 565.7, 806.66, '2023-09-17 23:12:34',  'Ordered'),
(213, 13, '2023-04-16 21:28:21', 826.56, 192.82, 483.24, '2023-03-14 13:53:22',  'InCart'),
(214, 81, '2024-06-20 17:41:04', 467.17, 653.52, 691.44, '2024-02-13 13:43:37',  'InCart'),
(215, 53, '2023-07-09 19:51:27', 619.4, 817.91, 451.5, '2024-02-13 21:00:41',  'Ordered'),
(216, 88, '2023-03-28 20:15:43', 568.83, 510.47, 32.85, '2023-03-23 01:42:57',  'Ordered'),
(217, 72, '2023-08-24 03:47:24', 20.1, 591.82, 479.71, '2023-08-25 04:18:13',  'InCart'),
(218, 29, '2023-10-01 23:14:50', 538.87, 947.63, 875.76, '2024-02-17 04:43:53',  'InCart'),
(219, 36, '2025-01-23 05:42:21', 193.03, 218.33, 857.01, '2023-07-18 11:40:12',  'Ordered'),
(220, 26, '2023-06-21 07:05:48', 501.24, 982.87, 919.97, '2023-03-19 05:33:22',  'Ordered'),
(221, 85, '2025-01-21 13:38:29', 713.42, 255.55, 251.34, '2023-10-17 23:19:25',  'InCart'),
(222, 3, '2024-03-06 13:28:12', 793.86, 971.57, 663.17, '2023-06-30 11:42:51',  'InCart'),
(223, 75, '2023-12-15 13:52:27', 278.85, 187.71, 132.36, '2025-01-27 15:40:36',  'Ordered'),
(224, 25, '2024-11-11 09:15:30', 787.78, 406.04, 550.64, '2023-08-07 13:52:07',  'Ordered'),
(225, 74, '2024-05-17 00:10:51', 234.85, 224.55, 814.05, '2024-04-10 04:38:31',  'InCart'),
(226, 66, '2023-11-16 19:24:13', 317.15, 64.82, 611.17, '2023-06-10 16:22:09',  'InCart'),
(227, 34, '2023-12-14 13:01:44', 856.23, 829.56, 936.82, '2024-04-20 16:28:02',  'Ordered'),
(228, 87, '2023-05-23 13:22:45', 551.28, 9.3, 432.8, '2023-11-26 23:17:15',  'Ordered'),
(229, 71, '2024-08-06 20:12:56', 804.08, 119.89, 952.22, '2023-02-05 14:26:09',  'InCart'),
(230, 63, '2023-07-27 13:04:01', 564.45, 997.09, 943.66, '2024-07-19 20:15:48',  'InCart'),
(231, 87, '2023-12-10 00:06:32', 314.21, 254.48, 731.44, '2024-07-30 07:31:20',  'Ordered'),
(232, 42, '2023-01-17 15:57:22', 115.08, 832.62, 607.81, '2023-08-18 23:13:57',  'Ordered'),
(233, 2, '2024-06-20 12:53:11', 336.76, 642.96, 467.4, '2023-07-27 08:48:12',  'InCart'),
(234, 72, '2023-05-29 01:44:27', 689.06, 837.71, 627.67, '2024-06-26 09:59:19',  'InCart'),
(235, 67, '2024-07-12 10:29:11', 955.07, 350.82, 487.09, '2024-03-02 14:10:43',  'Ordered'),
(236, 48, '2023-03-23 01:03:24', 0.14, 110.09, 288.35, '2024-10-09 10:23:32',  'Ordered'),
(237, 70, '2024-04-28 10:10:16', 542.64, 513.23, 634.77, '2023-03-14 23:32:22',  'InCart'),
(238, 26, '2024-10-14 17:01:16', 642.52, 227.31, 525.77, '2023-07-16 16:02:18',  'InCart'),
(239, 84, '2024-05-02 04:14:06', 478.49, 146.49, 821.57, '2025-01-28 20:03:21',  'Ordered'),
(240, 59, '2024-10-05 11:59:16', 24.81, 978.26, 875.57, '2023-02-24 10:04:35',  'Ordered'),
(241, 68, '2023-04-13 13:45:22', 237.75, 392.48, 763.7, '2025-02-11 14:53:18',  'InCart'),
(242, 4, '2023-03-13 10:41:10', 709.15, 444.39, 240.12, '2023-12-27 22:19:56',  'InCart'),
(243, 49, '2023-04-22 19:34:16', 662.22, 487.28, 437.67, '2024-11-16 13:25:07',  'Ordered'),
(244, 67, '2023-01-31 04:15:41', 259.07, 458.24, 176.76, '2024-11-17 07:02:11',  'Ordered'),
(245, 71, '2023-02-21 08:08:43', 850.25, 413.44, 187.97, '2023-02-18 10:32:36',  'InCart'),
(246, 61, '2024-09-11 20:33:43', 751.87, 314.27, 622.23, '2024-09-11 11:53:09',  'InCart'),
(247, 9, '2023-12-19 06:25:03', 245.34, 76.05, 474.95, '2023-07-13 08:32:24',  'Ordered'),
(248, 30, '2023-04-08 07:33:38', 472.22, 686.28, 129.21, '2025-01-12 01:40:32',  'Ordered'),
(249, 22, '2024-06-01 11:14:08', 479.7, 350.82, 579.91, '2023-05-08 15:38:34',  'InCart'),
(250, 54, '2024-03-11 04:40:27', 603.52, 906.27, 721.9, '2024-07-22 17:18:24',  'InCart'),
(251, 82, '2023-01-11 12:57:48', 834.28, 903.77, 31.16, '2023-01-20 09:46:37',  'Ordered'),
(252, 39, '2023-05-31 21:48:18', 636.56, 67.86, 827.99, '2023-11-26 17:44:06',  'Ordered'),
(253, 98, '2024-12-02 18:28:32', 500.72, 55.14, 6.49, '2024-10-12 02:24:29',  'InCart'),
(254, 53, '2023-06-29 08:30:06', 979.1, 721.85, 849.33, '2024-06-06 10:32:23',  'InCart'),
(255, 25, '2024-03-30 18:13:14', 625.18, 709.03, 28.21, '2024-07-26 15:46:32',  'Ordered'),
(256, 7, '2023-03-04 01:24:57', 475.16, 938.88, 199.22, '2023-11-19 22:06:44',  'Ordered'),
(257, 90, '2024-11-01 06:39:34', 537.78, 59.95, 86.07, '2023-03-07 14:36:39',  'InCart'),
(258, 40, '2023-07-23 05:21:52', 332.3, 889.11, 990.52, '2024-12-21 22:06:46',  'InCart'),
(259, 24, '2023-08-26 02:17:38', 153.45, 418.56, 385.76, '2023-11-22 00:30:51',  'Ordered'),
(260, 25, '2024-03-29 02:42:01', 598.89, 831.26, 485.57, '2023-03-21 15:57:19',  'Ordered'),
(261, 55, '2023-04-25 19:10:12', 83.37, 972.43, 348.94, '2024-02-14 16:43:47',  'InCart'),
(262, 18, '2025-01-30 03:11:32', 776.29, 202.27, 957.71, '2024-08-10 08:16:53',  'InCart'),
(263, 100, '2023-10-16 10:06:46', 999.71, 591.58, 918.83, '2024-09-28 22:29:59',  'Ordered'),
(264, 1, '2023-03-31 02:40:32', 859.51, 271.51, 597.91, '2024-05-19 18:39:54',  'Ordered'),
(265, 69, '2023-09-06 16:43:24', 574.48, 581.17, 672.36, '2025-02-11 02:39:52',  'InCart'),
(266, 86, '2023-03-03 06:47:41', 755.84, 966.09, 748.94, '2023-09-26 10:57:02',  'InCart'),
(267, 74, '2024-03-27 02:50:26', 580.21, 947.6, 566.93, '2024-08-05 00:07:39',  'Ordered'),
(268, 19, '2024-08-18 21:46:46', 617.68, 695.43, 62.05, '2023-05-02 14:39:50',  'Ordered'),
(269, 16, '2024-10-06 18:51:21', 360.43, 552.16, 13.66, '2024-08-13 07:56:52',  'InCart'),
(270, 15, '2023-01-21 20:54:36', 499.13, 38.09, 241.54, '2023-01-29 01:45:06',  'InCart'),
(271, 85, '2023-03-27 08:14:53', 631.84, 442.59, 895.99, '2025-01-25 22:48:19',  'Ordered'),
(272, 40, '2023-02-21 05:44:41', 589.49, 92.84, 586.81, '2023-07-23 12:09:43',  'Ordered'),
(273, 4, '2024-02-11 03:56:35', 942.49, 345.95, 162.82, '2024-11-07 14:06:41',  'InCart'),
(274, 84, '2024-08-17 11:31:06', 85.58, 351.77, 760.84, '2023-07-17 07:25:05',  'InCart'),
(275, 39, '2024-02-06 02:05:48', 838.57, 636.74, 97.58, '2023-01-24 10:52:57',  'Ordered'),
(276, 53, '2023-04-28 04:36:48', 18.9, 679.05, 670.58, '2024-09-08 15:36:44',  'Ordered'),
(277, 6, '2023-12-25 01:50:03', 699.95, 588.58, 975.79, '2023-07-04 04:34:01',  'InCart'),
(278, 59, '2023-10-05 22:00:45', 790.35, 120.83, 610.78, '2023-10-22 03:11:14',  'InCart'),
(279, 10, '2023-06-05 02:02:48', 700.55, 674.16, 559.19, '2024-11-09 07:29:33',  'Ordered'),
(280, 4, '2023-01-18 04:46:16', 380.43, 857.59, 720.65, '2023-04-26 09:42:35',  'Ordered'),
(281, 49, '2023-10-29 00:09:39', 754.14, 682.12, 305.69, '2024-08-07 10:40:18',  'InCart'),
(282, 7, '2025-01-11 10:44:23', 685.3, 201.78, 703.8, '2024-01-18 00:59:45',  'InCart'),
(283, 24, '2023-04-12 03:28:31', 43.96, 750.5, 597.56, '2024-11-29 21:46:11',  'Ordered'),
(284, 86, '2023-04-13 14:38:50', 365.06, 682.67, 646.11, '2024-09-23 03:38:20',  'Ordered'),
(285, 51, '2024-03-09 05:34:42', 344.6, 886.25, 582.67, '2023-10-23 22:52:51',  'InCart'),
(286, 72, '2023-07-21 06:19:57', 376.69, 519.25, 854.22, '2023-02-28 20:31:23',  'InCart'),
(287, 30, '2023-11-12 08:44:48', 542.31, 804.29, 701.11, '2024-08-10 04:31:34',  'Ordered'),
(288, 20, '2023-12-20 08:43:43', 523.54, 728.02, 333.16, '2024-11-16 16:45:12',  'Ordered'),
(289, 46, '2024-10-22 23:53:41', 604.65, 297.39, 468.57, '2024-12-26 01:08:46',  'InCart'),
(290, 2, '2024-11-01 02:04:18', 60.92, 571.08, 244.41, '2024-04-19 06:57:50',  'InCart'),
(291, 86, '2024-04-08 15:46:20', 878.67, 832.64, 307.72, '2025-01-02 01:26:46',  'Ordered'),
(292, 35, '2024-10-16 07:14:08', 345.41, 884.93, 427.69, '2024-03-08 14:43:46',  'Ordered'),
(293, 78, '2024-04-08 13:19:17', 670.09, 661.68, 715.07, '2023-10-27 08:38:17',  'InCart'),
(294, 77, '2023-10-23 17:48:26', 672.64, 230.11, 622.14, '2023-09-27 12:41:32',  'InCart'),
(295, 48, '2024-01-09 10:52:56', 510.32, 896.33, 433.29, '2023-05-26 01:03:01',  'Ordered'),
(296, 43, '2024-05-30 13:58:30', 298.82, 381.69, 277.17, '2024-07-15 13:22:44',  'Ordered'),
(297, 96, '2024-07-19 21:02:22', 713.96, 815.0, 209.82, '2024-11-13 14:25:41',  'InCart'),
(298, 97, '2023-03-09 04:40:33', 458.87, 474.12, 716.11, '2024-07-31 02:25:57',  'InCart'),
(299, 26, '2024-03-02 20:33:26', 282.94, 103.38, 597.75, '2024-02-19 10:26:43',  'Ordered'),
(300, 16, '2023-12-11 15:17:15', 656.09, 808.86, 716.16, '2024-04-12 04:36:20',  'Ordered'),
(301, 80, '2023-12-28 20:44:16', 211.67, 647.54, 999.58, '2024-09-05 14:21:13',  'InCart'),
(302, 1, '2024-04-20 22:02:00', 969.65, 513.36, 827.52, '2023-12-24 15:02:57',  'InCart'),
(303, 32, '2024-11-02 14:51:01', 585.54, 321.59, 794.63, '2024-01-08 10:12:09',  'Ordered'),
(304, 33, '2024-12-24 19:12:07', 592.84, 897.69, 85.16, '2024-08-07 09:35:21',  'Ordered'),
(305, 34, '2024-06-01 05:13:47', 558.43, 971.89, 278.25, '2023-08-07 07:12:22',  'InCart'),
(306, 36, '2023-07-09 15:14:01', 277.28, 215.24, 239.47, '2023-07-23 09:27:06',  'InCart'),
(307, 82, '2023-12-13 05:00:10', 998.07, 457.42, 285.9, '2023-06-18 21:05:27',  'Ordered'),
(308, 6, '2024-06-03 20:45:15', 999.91, 256.26, 992.06, '2023-12-20 13:09:29',  'Ordered'),
(309, 75, '2024-10-10 04:30:11', 982.59, 186.5, 481.5, '2023-11-15 14:12:42',  'InCart'),
(310, 90, '2023-09-06 16:04:37', 584.15, 949.45, 735.47, '2024-04-04 08:03:33',  'InCart'),
(311, 7, '2024-11-04 08:55:21', 306.87, 803.13, 248.19, '2023-10-09 19:08:14',  'Ordered'),
(312, 67, '2023-10-16 11:02:08', 345.07, 406.35, 899.97, '2023-04-08 13:03:59',  'Ordered'),
(313, 34, '2024-01-04 18:27:23', 40.53, 217.39, 952.77, '2023-05-25 03:03:49',  'InCart'),
(314, 97, '2024-07-04 16:20:21', 706.92, 527.26, 509.26, '2023-06-30 09:36:39',  'InCart'),
(315, 86, '2023-06-01 02:50:38', 988.79, 554.21, 353.05, '2024-04-01 11:05:08',  'Ordered'),
(316, 64, '2023-12-21 19:02:04', 365.55, 434.99, 152.13, '2024-07-13 12:17:41',  'Ordered'),
(317, 52, '2024-11-29 08:38:41', 686.01, 553.98, 722.42, '2023-04-20 06:04:04',  'InCart'),
(318, 70, '2024-03-14 01:39:51', 700.58, 574.55, 214.87, '2023-05-13 23:48:59',  'InCart'),
(319, 66, '2024-04-29 00:32:16', 970.17, 415.64, 97.29, '2024-05-14 12:13:52',  'Ordered'),
(320, 11, '2024-11-12 04:28:02', 569.94, 6.72, 434.37, '2023-11-20 11:26:54',  'Ordered'),
(321, 24, '2023-08-17 11:44:13', 754.54, 912.26, 235.82, '2024-10-27 22:55:17',  'InCart'),
(322, 25, '2024-06-20 04:41:21', 988.52, 643.91, 981.36, '2023-12-20 21:43:01',  'InCart'),
(323, 29, '2024-12-25 19:06:16', 391.81, 416.94, 348.63, '2025-01-15 00:33:41',  'Ordered'),
(324, 51, '2023-10-08 00:27:14', 109.8, 261.7, 547.76, '2024-06-25 14:51:41',  'Ordered'),
(325, 30, '2023-10-01 23:20:29', 703.94, 958.3, 185.26, '2025-02-11 21:09:11',  'InCart'),
(326, 41, '2025-01-21 15:10:10', 515.8, 146.49, 946.82, '2024-05-28 03:08:12',  'InCart'),
(327, 75, '2024-10-29 00:00:41', 180.76, 301.37, 451.88, '2024-11-01 04:47:01',  'Ordered'),
(328, 46, '2024-03-11 01:54:13', 164.85, 63.64, 275.52, '2024-02-15 18:10:43',  'Ordered'),
(329, 25, '2023-01-31 00:51:02', 77.2, 429.01, 626.66, '2024-02-22 08:22:49',  'InCart'),
(330, 63, '2023-10-30 04:20:06', 325.6, 751.1, 918.22, '2025-01-20 05:44:46',  'InCart'),
(331, 23, '2023-03-11 03:35:51', 573.4, 236.49, 945.85, '2024-12-08 01:15:28',  'Ordered'),
(332, 61, '2024-07-07 02:10:18', 107.13, 767.96, 739.05, '2023-02-25 12:58:03',  'Ordered'),
(333, 99, '2024-10-30 16:12:56', 821.37, 986.12, 599.82, '2023-12-23 21:31:36',  'InCart'),
(334, 55, '2023-11-20 06:45:50', 900.71, 653.24, 552.64, '2023-02-26 03:24:17',  'InCart'),
(335, 11, '2024-06-12 08:27:52', 636.2, 466.21, 266.01, '2024-04-06 19:09:20',  'Ordered'),
(336, 62, '2023-08-18 01:14:52', 57.25, 158.86, 301.03, '2025-02-08 06:23:52',  'Ordered'),
(337, 19, '2024-07-31 17:29:26', 908.97, 440.15, 293.31, '2024-12-01 22:12:39',  'InCart'),
(338, 25, '2024-11-21 20:20:46', 256.37, 303.71, 875.79, '2024-05-09 08:30:36',  'InCart'),
(339, 41, '2024-02-01 07:41:07', 359.83, 903.9, 503.09, '2025-02-07 19:37:47',  'Ordered'),
(340, 20, '2024-11-06 11:42:48', 699.34, 734.24, 53.4, '2023-07-21 00:14:36',  'Ordered'),
(341, 32, '2023-02-26 14:46:23', 334.37, 979.76, 294.82, '2024-06-14 22:42:52',  'InCart'),
(342, 4, '2024-08-03 23:46:45', 522.68, 418.38, 57.38, '2024-03-10 11:40:51',  'InCart'),
(343, 25, '2025-01-21 15:50:48', 609.86, 867.71, 155.08, '2024-11-29 14:20:15',  'Ordered'),
(344, 61, '2024-04-23 08:08:22', 633.23, 842.25, 681.88, '2024-11-06 21:43:48',  'Ordered'),
(345, 100, '2024-04-02 05:20:48', 195.92, 914.88, 94.26, '2025-01-16 00:05:43',  'InCart'),
(346, 11, '2024-10-31 19:03:12', 570.08, 318.78, 34.69, '2023-10-24 12:08:04',  'InCart'),
(347, 60, '2024-05-25 16:35:49', 762.89, 553.4, 468.32, '2024-08-19 22:30:51',  'Ordered'),
(348, 5, '2024-12-06 18:45:57', 55.57, 386.16, 899.87, '2023-03-13 10:18:10',  'Ordered'),
(349, 98, '2023-07-07 15:27:21', 37.43, 605.07, 684.94, '2023-02-13 22:28:07',  'InCart'),
(350, 28, '2023-08-09 02:10:02', 542.21, 755.45, 871.12, '2024-11-02 16:42:31',  'InCart'),
(351, 76, '2023-11-23 06:04:48', 326.42, 849.24, 680.79, '2023-09-08 20:21:56',  'Ordered'),
(352, 11, '2024-07-09 00:32:49', 352.41, 611.12, 31.84, '2023-11-28 17:40:51',  'Ordered'),
(353, 32, '2023-02-03 19:34:24', 570.93, 512.44, 340.93, '2025-01-24 16:49:13',  'InCart'),
(354, 75, '2024-02-17 05:13:46', 747.61, 81.45, 708.61, '2023-06-25 21:40:19',  'InCart'),
(355, 64, '2023-02-13 05:04:20', 70.73, 205.66, 253.93, '2024-01-15 17:57:21',  'Ordered'),
(356, 70, '2023-07-27 11:25:52', 412.87, 619.82, 955.17, '2023-10-12 22:09:13',  'Ordered'),
(357, 49, '2023-07-14 17:48:02', 416.74, 378.19, 266.12, '2023-08-08 14:01:49',  'InCart'),
(358, 68, '2023-08-13 14:36:46', 924.4, 85.77, 485.4, '2025-01-21 10:43:57',  'InCart'),
(359, 36, '2024-08-22 01:23:35', 977.18, 97.82, 404.27, '2023-07-06 17:14:54',  'Ordered'),
(360, 24, '2024-07-10 03:01:39', 71.44, 500.11, 94.55, '2024-08-02 07:45:25',  'Ordered'),
(361, 1, '2024-08-05 19:26:52', 652.35, 274.58, 34.66, '2024-02-02 11:47:30',  'InCart'),
(362, 84, '2024-01-05 10:14:49', 64.77, 552.77, 268.03, '2023-02-21 13:43:05',  'InCart'),
(363, 79, '2024-06-27 14:04:24', 417.82, 671.04, 326.22, '2024-04-01 21:17:45',  'Ordered'),
(364, 1, '2023-10-02 08:16:09', 115.66, 151.14, 726.9, '2024-02-13 23:59:25',  'Ordered'),
(365, 87, '2023-03-16 04:31:51', 368.21, 838.64, 301.72, '2023-07-11 08:24:53',  'InCart'),
(366, 33, '2023-03-07 00:36:07', 153.06, 524.82, 734.22, '2024-11-06 01:42:09',  'InCart'),
(367, 34, '2024-11-05 18:20:21', 825.93, 37.41, 170.73, '2024-05-17 12:54:07',  'Ordered'),
(368, 59, '2023-12-29 00:20:44', 167.44, 315.71, 355.58, '2024-07-23 21:12:32',  'Ordered'),
(369, 13, '2023-09-03 14:30:17', 269.83, 236.36, 579.39, '2024-05-28 12:45:27',  'InCart'),
(370, 41, '2024-12-12 21:09:28', 406.05, 393.81, 15.18, '2024-09-14 03:33:33',  'InCart'),
(371, 27, '2024-04-08 19:35:43', 737.79, 721.52, 53.24, '2023-02-04 05:55:02',  'Ordered'),
(372, 21, '2023-05-03 21:03:01', 565.61, 794.09, 299.36, '2024-02-21 13:12:29',  'Ordered'),
(373, 32, '2024-07-15 08:34:45', 76.13, 792.54, 476.09, '2023-08-18 09:17:53',  'InCart'),
(374, 66, '2023-05-25 12:34:25', 41.3, 134.3, 246.25, '2023-12-13 00:23:06',  'InCart'),
(375, 43, '2023-12-25 06:33:08', 419.2, 11.04, 266.94, '2024-08-09 17:52:51',  'Ordered'),
(376, 20, '2023-09-16 21:00:49', 713.25, 400.93, 671.44, '2023-12-30 01:07:19',  'Ordered'),
(377, 86, '2024-01-18 18:26:26', 886.34, 638.17, 855.86, '2023-07-04 04:58:30',  'InCart'),
(378, 26, '2024-03-19 10:40:03', 870.71, 824.31, 673.69, '2023-09-11 23:20:32',  'InCart'),
(379, 12, '2024-02-04 20:32:22', 845.83, 769.55, 71.0, '2023-03-09 23:55:40',  'Ordered'),
(380, 52, '2023-01-25 17:21:47', 409.0, 857.6, 747.73, '2024-06-29 07:32:25',  'Ordered'),
(381, 26, '2024-12-15 11:26:16', 905.7, 851.18, 989.11, '2024-12-30 01:26:21',  'InCart'),
(382, 66, '2024-11-19 12:02:38', 300.01, 392.29, 643.83, '2023-09-27 06:44:42',  'InCart'),
(383, 92, '2024-01-05 19:11:14', 505.43, 825.97, 921.4, '2024-02-02 20:44:11',  'Ordered'),
(384, 96, '2024-03-02 13:05:52', 620.85, 171.77, 954.11, '2024-04-11 03:06:17',  'Ordered'),
(385, 49, '2024-05-06 02:06:35', 992.12, 244.53, 581.51, '2024-03-01 11:52:18',  'InCart'),
(386, 9, '2024-03-30 05:26:39', 710.93, 752.64, 228.02, '2025-01-24 13:16:12',  'InCart'),
(387, 2, '2023-06-10 02:12:52', 783.71, 181.73, 934.16, '2024-07-31 15:58:29',  'Ordered'),
(388, 83, '2024-11-09 23:57:08', 28.15, 639.13, 614.58, '2025-02-04 06:00:16',  'Ordered'),
(389, 82, '2024-05-29 22:37:06', 524.75, 706.2, 276.67, '2023-02-11 13:01:43',  'InCart'),
(390, 39, '2024-09-01 03:32:42', 117.71, 885.51, 976.44, '2024-07-16 16:55:05',  'InCart'),
(391, 24, '2023-03-30 15:09:50', 286.51, 908.37, 633.83, '2023-05-04 17:57:28',  'Ordered'),
(392, 71, '2023-06-21 13:43:19', 789.28, 784.38, 41.39, '2025-02-09 09:20:55',  'Ordered'),
(393, 7, '2023-03-23 08:39:49', 644.43, 813.93, 706.2, '2023-07-19 04:45:11',  'InCart'),
(394, 47, '2024-11-01 21:20:08', 954.17, 587.58, 379.52, '2024-02-03 03:13:50',  'InCart'),
(395, 63, '2024-10-06 00:38:09', 994.92, 28.69, 47.32, '2023-07-09 17:58:55',  'Ordered'),
(396, 55, '2023-09-29 13:57:24', 129.36, 350.01, 198.43, '2024-03-07 06:20:41',  'Ordered'),
(397, 13, '2024-09-23 15:33:47', 236.0, 550.09, 725.12, '2023-07-02 14:06:15',  'InCart'),
(398, 36, '2024-12-09 16:34:02', 933.01, 592.71, 741.3, '2023-11-01 04:19:29',  'InCart'),
(399, 4, '2024-02-22 06:37:08', 827.21, 69.52, 553.4, '2023-03-12 04:54:33',  'Ordered'),
(400, 80, '2023-03-23 06:21:36', 950.71, 462.43, 107.07, '2023-03-15 15:26:47',  'Ordered'),
(401, 20, '2023-10-09 22:42:17', 511.61, 507.01, 337.26, '2024-07-19 02:53:32',  'InCart'),
(402, 76, '2023-08-12 08:14:06', 862.61, 113.18, 167.36, '2024-11-12 15:46:25',  'InCart'),
(403, 99, '2023-12-20 06:43:13', 619.71, 702.02, 293.17, '2023-03-08 14:03:49',  'Ordered'),
(404, 45, '2024-07-24 12:06:11', 697.59, 15.89, 291.89, '2023-07-21 04:58:41',  'Ordered'),
(405, 80, '2024-10-19 19:33:32', 542.17, 778.9, 235.99, '2023-11-28 11:43:06',  'InCart'),
(406, 70, '2025-01-19 01:37:30', 862.36, 387.27, 674.95, '2023-07-21 10:07:14',  'InCart'),
(407, 81, '2024-11-10 18:29:06', 380.64, 598.14, 771.44, '2024-08-12 22:27:55',  'Ordered'),
(408, 63, '2024-01-25 00:45:41', 576.45, 60.81, 773.83, '2023-12-20 18:17:48',  'Ordered'),
(409, 51, '2024-08-24 08:26:38', 969.22, 344.73, 396.15, '2023-12-02 02:41:31',  'InCart'),
(410, 65, '2024-12-19 10:23:40', 801.25, 620.37, 696.17, '2023-10-22 00:19:06',  'InCart'),
(411, 44, '2024-04-17 18:54:40', 474.9, 880.07, 345.08, '2023-06-19 20:20:40',  'Ordered'),
(412, 52, '2024-02-23 03:09:07', 893.82, 300.11, 703.09, '2023-12-25 11:22:20',  'Ordered'),
(413, 79, '2023-01-19 18:55:59', 939.53, 685.9, 619.04, '2024-08-14 01:06:25',  'InCart'),
(414, 61, '2023-04-07 09:57:04', 843.17, 195.06, 26.09, '2023-02-08 04:36:14',  'InCart'),
(415, 3, '2024-03-31 01:58:36', 874.61, 816.41, 339.85, '2024-02-25 07:59:13',  'Ordered'),
(416, 73, '2024-11-27 02:34:23', 611.7, 988.1, 687.81, '2023-08-23 23:49:57',  'Ordered'),
(417, 23, '2024-12-02 09:55:09', 774.35, 950.31, 247.04, '2024-04-01 10:53:49',  'InCart'),
(418, 26, '2023-12-03 19:20:48', 804.88, 216.72, 856.39, '2024-02-04 01:19:36',  'InCart'),
(419, 96, '2023-11-27 18:10:49', 925.0, 474.48, 426.53, '2024-12-31 02:28:01',  'Ordered'),
(420, 98, '2023-06-28 16:06:05', 233.23, 501.48, 675.74, '2023-05-04 06:53:59',  'Ordered'),
(421, 45, '2024-11-19 10:26:21', 143.58, 931.94, 942.18, '2024-04-07 19:51:09',  'InCart'),
(422, 47, '2023-09-09 05:13:45', 82.1, 945.56, 360.78, '2024-07-18 10:19:13',  'InCart'),
(423, 90, '2024-04-19 05:59:31', 480.49, 112.38, 220.42, '2023-11-29 17:22:27',  'Ordered'),
(424, 97, '2023-03-27 17:29:02', 31.24, 968.02, 729.11, '2024-12-16 03:10:27',  'Ordered'),
(425, 73, '2023-08-19 14:48:35', 884.21, 955.75, 431.87, '2023-12-19 18:48:38',  'InCart'),
(426, 36, '2023-02-15 15:57:55', 397.82, 436.47, 832.71, '2023-07-15 05:49:30',  'InCart'),
(427, 44, '2023-03-01 10:09:45', 521.48, 538.76, 307.19, '2024-07-30 13:16:57',  'Ordered'),
(428, 26, '2023-12-09 07:43:39', 15.44, 752.17, 107.74, '2024-01-16 18:24:44',  'Ordered'),
(429, 51, '2024-05-26 00:51:07', 450.21, 621.29, 828.56, '2023-08-02 09:12:51',  'InCart'),
(430, 14, '2024-12-16 21:32:14', 149.64, 489.49, 769.02, '2024-01-11 22:16:20',  'InCart'),
(431, 76, '2023-02-21 14:45:56', 650.7, 275.94, 392.37, '2023-02-24 22:01:54',  'Ordered'),
(432, 6, '2024-01-07 13:25:15', 123.34, 717.13, 775.26, '2025-01-01 01:12:43',  'Ordered'),
(433, 72, '2023-03-09 08:00:20', 192.87, 887.28, 367.01, '2023-09-30 13:13:17',  'InCart'),
(434, 31, '2023-10-26 00:56:54', 153.81, 719.66, 867.6, '2023-08-09 22:19:12',  'InCart'),
(435, 60, '2024-04-02 15:20:53', 838.06, 137.23, 244.07, '2024-05-30 13:23:55',  'Ordered'),
(436, 90, '2024-09-30 01:37:35', 751.36, 125.49, 362.13, '2025-01-21 13:37:24',  'Ordered'),
(437, 45, '2024-09-29 19:40:17', 725.19, 972.04, 583.52, '2023-05-07 15:17:59',  'InCart'),
(438, 32, '2024-08-26 11:32:14', 307.01, 113.47, 371.92, '2023-08-19 23:17:29',  'InCart'),
(439, 57, '2024-12-19 01:06:23', 917.52, 503.97, 347.16, '2023-07-22 14:00:48',  'Ordered'),
(440, 68, '2024-10-26 13:26:46', 148.67, 520.06, 649.7, '2023-10-20 14:03:16',  'Ordered'),
(441, 26, '2023-10-05 05:59:32', 245.74, 469.25, 784.75, '2023-01-25 19:48:03',  'InCart'),
(442, 59, '2023-11-28 13:04:22', 428.05, 160.41, 723.82, '2023-08-08 10:35:47',  'InCart'),
(443, 93, '2024-08-25 03:58:26', 621.71, 341.65, 71.47, '2023-03-28 12:40:27',  'Ordered'),
(444, 53, '2024-06-19 18:53:22', 620.46, 87.51, 499.17, '2024-06-08 06:51:50',  'Ordered'),
(445, 16, '2023-11-09 08:16:54', 845.26, 356.6, 348.81, '2024-12-25 21:35:57',  'InCart'),
(446, 22, '2024-05-06 18:15:18', 746.35, 284.06, 553.84, '2024-02-23 03:41:41',  'InCart'),
(447, 30, '2024-07-16 03:53:40', 876.35, 422.97, 250.0, '2023-03-30 22:16:21',  'Ordered'),
(448, 87, '2023-05-01 17:14:50', 217.78, 655.31, 209.33, '2024-08-24 10:11:20',  'Ordered'),
(449, 59, '2023-08-04 02:49:41', 51.48, 835.06, 865.27, '2024-07-07 15:37:19',  'InCart'),
(450, 24, '2024-07-26 22:57:24', 729.67, 615.83, 862.7, '2023-10-29 03:46:00',  'InCart'),
(451, 31, '2024-07-02 06:52:52', 918.33, 683.08, 831.5, '2023-07-22 15:05:57',  'Ordered'),
(452, 41, '2024-10-31 01:47:10', 697.7, 549.04, 375.44, '2024-11-27 06:17:00',  'Ordered'),
(453, 68, '2024-08-22 09:50:58', 117.71, 310.23, 31.14, '2023-08-06 14:07:05',  'InCart'),
(454, 0, '2023-10-20 18:47:42', 848.34, 465.41, 909.82, '2023-01-25 10:09:05',  'InCart'),
(455, 20, '2023-03-28 11:55:15', 47.13, 936.62, 283.16, '2024-11-13 10:27:59',  'Ordered'),
(456, 24, '2024-01-21 21:44:35', 697.57, 226.49, 970.02, '2023-02-12 21:05:16',  'Ordered'),
(457, 26, '2023-11-09 00:25:56', 24.66, 160.85, 888.3, '2023-04-28 21:53:41',  'InCart'),
(458, 81, '2024-08-04 17:45:34', 702.89, 467.96, 442.49, '2024-06-12 23:35:42',  'InCart'),
(459, 34, '2024-04-24 11:03:17', 60.15, 191.91, 372.16, '2025-02-05 00:37:28',  'Ordered'),
(460, 22, '2024-04-10 00:43:29', 7.46, 522.42, 96.53, '2023-12-03 01:16:47',  'Ordered'),
(461, 64, '2024-10-27 20:43:21', 346.16, 130.02, 776.58, '2023-07-22 15:56:07',  'InCart'),
(462, 48, '2023-07-10 00:02:10', 267.84, 293.79, 868.92, '2024-05-05 09:28:36',  'InCart'),
(463, 67, '2023-03-07 13:28:56', 522.53, 466.23, 107.12, '2025-01-11 05:31:12',  'Ordered'),
(464, 38, '2023-01-05 10:45:31', 885.65, 290.85, 816.66, '2023-02-03 13:39:31',  'Ordered'),
(465, 15, '2024-05-15 22:56:26', 952.2, 486.06, 548.13, '2023-09-14 18:24:47',  'InCart'),
(466, 29, '2023-06-08 03:56:03', 705.0, 996.76, 233.23, '2023-09-20 07:05:54',  'InCart'),
(467, 29, '2023-04-04 22:06:46', 542.23, 548.75, 44.04, '2023-11-13 21:58:40',  'Ordered'),
(468, 46, '2024-05-21 15:41:00', 769.16, 869.94, 156.57, '2024-02-19 06:16:10',  'Ordered'),
(469, 20, '2024-03-02 19:42:45', 301.48, 805.6, 650.88, '2024-01-15 03:35:56',  'InCart'),
(470, 8, '2024-02-23 14:53:22', 254.52, 495.9, 621.77, '2023-04-25 01:23:06',  'InCart'),
(471, 32, '2024-01-26 18:00:53', 31.43, 440.19, 136.24, '2023-12-29 19:07:37',  'Ordered'),
(472, 39, '2023-07-12 03:46:49', 125.19, 922.54, 74.69, '2023-04-25 03:12:15',  'Ordered'),
(473, 65, '2023-03-23 04:58:31', 572.63, 726.05, 85.68, '2024-09-02 09:03:07',  'InCart'),
(474, 68, '2023-04-27 04:36:26', 667.9, 754.93, 762.92, '2023-06-14 16:18:02',  'InCart'),
(475, 87, '2023-10-29 18:15:54', 325.3, 429.88, 399.05, '2023-02-18 19:23:07',  'Ordered'),
(476, 40, '2023-10-20 19:32:29', 142.12, 472.63, 704.2, '2024-01-16 16:54:14',  'Ordered'),
(477, 33, '2024-01-26 02:51:01', 888.07, 883.03, 178.38, '2023-05-08 07:57:42',  'InCart'),
(478, 26, '2024-05-03 14:41:48', 228.69, 664.7, 699.94, '2024-08-21 08:39:54',  'InCart'),
(479, 2, '2024-02-23 07:03:34', 106.25, 725.96, 825.93, '2024-10-04 12:31:51',  'Ordered'),
(480, 26, '2023-12-22 11:14:45', 797.19, 683.24, 787.5, '2024-07-24 07:36:46',  'Ordered'),
(481, 16, '2023-03-09 02:11:41', 69.76, 740.76, 370.07, '2023-12-09 11:41:31',  'InCart'),
(482, 42, '2024-03-10 13:55:37', 470.37, 307.97, 447.08, '2023-11-11 17:59:06',  'InCart'),
(483, 91, '2024-03-11 08:41:59', 651.74, 263.5, 16.69, '2024-10-14 17:42:45',  'Ordered'),
(484, 16, '2024-10-05 06:58:10', 134.54, 989.79, 243.2, '2025-01-07 10:50:28',  'Ordered'),
(485, 65, '2023-01-25 23:41:48', 975.26, 636.0, 924.69, '2025-01-06 18:30:04',  'InCart'),
(486, 46, '2024-08-19 04:54:23', 519.06, 783.04, 362.54, '2023-06-21 19:57:41',  'InCart'),
(487, 13, '2024-07-15 21:13:54', 34.81, 990.39, 566.43, '2023-01-24 01:10:01',  'Ordered'),
(488, 88, '2023-07-27 04:55:13', 838.46, 408.94, 741.23, '2023-01-18 23:58:00',  'Ordered'),
(489, 37, '2023-04-30 00:19:35', 393.46, 12.89, 603.77, '2024-12-28 23:11:33',  'InCart'),
(490, 91, '2024-06-08 21:52:37', 697.78, 377.67, 716.13, '2024-12-23 16:39:16',  'InCart'),
(491, 30, '2024-12-06 16:40:32', 823.27, 769.81, 809.81, '2023-05-10 21:57:53',  'Ordered'),
(492, 59, '2023-08-14 00:47:03', 3.1, 466.82, 184.29, '2025-02-11 16:22:53',  'Ordered'),
(493, 22, '2023-05-26 14:39:35', 776.76, 985.64, 838.92, '2024-11-12 08:46:20',  'InCart'),
(494, 47, '2025-01-02 01:56:29', 192.97, 944.95, 707.61, '2024-12-28 19:03:41',  'InCart'),
(495, 50, '2024-08-03 21:37:27', 140.73, 152.19, 994.5, '2023-09-07 02:00:50',  'Ordered'),
(496, 35, '2023-03-07 17:46:35', 796.68, 745.63, 626.12, '2024-07-26 12:08:27',  'Ordered'),
(497, 95, '2024-02-02 06:18:58', 154.73, 364.09, 320.19, '2024-04-13 00:26:50',  'InCart'),
(498, 71, '2024-09-25 08:48:38', 255.03, 619.45, 537.17, '2024-06-10 13:12:05',  'InCart'),
(499, 71, '2023-12-21 12:19:22', 30.17, 843.94, 640.96, '2024-01-11 14:56:40',  'Ordered'),
(500, 78, '2024-01-26 04:18:27', 92.45, 627.09, 611.03, '2024-10-17 11:48:41',  'Ordered');
```



