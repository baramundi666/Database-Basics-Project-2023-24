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



## 1.	Opis systemu <a name="opis"></a>
Firma oferuje różnorakie usługi uczelniane w postaci kursów, webinarów oraz umożliwia zapis na studia. Zajęcia przeprowadzane są w formie stacjonarnej, online bądź hybrydowej, zależnie od typu usługi.

Klient może zakupić równolegle dostęp do wielu usług lub uzyskać dostęp do darmowych spotkań i nagrań.

System zawiera informacje o założonych kontach, wykupionych usługach, statusach zajęć oraz płatności oraz możliwość modyfikacji poszczególnych danych, przez uprawnione do tego jednostki.

## 2.	Funkcje realizowane przez system <a name="funkcje"></a>
### 2.1.	Klient firmy <a name="klient"></a>
- Założenie konta i logowanie się do niego każdorazowo
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
- Założenie konta i logowanie się do niego każdorazowo
- Dostęp do:
    - Podstawowych informacji na temat stanu systemu
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


