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
#### 4.1.2    Orders
- PK: OrderID
- FK: CustomerID
#### 4.1.3    Order_details
- PK: OrderID, ServiceID
- FK: OrderID, ServiceID
#### 4.1.4    Services
- PK: ServiceID
&nbsp;
### 4.2    *Studies* <a name="std"></a>
#### 4.2.1  Studies
- PK: ServiceID
- FK: ServiceID, SyllabusID
#### 4.2.2  SingleStudies
- PK: ServiceID
- FK: ServiceID
#### 4.2.3  Lectures
- PK: LectureID
- FK: ServiceID, LecturerID, TranslatorID
#### 4.2.4  Lectures_attendance
- PK: CustomerID, LectureID
- FK: CustomerID, LectureID
#### 4.2.5  Exams
- PK: CustomerID, ServiceID
- FK: CustomerID, ServiceID
#### 4.2.6  Diplomas
- PK: DiplomaID
- FK: CustomerID, ServiceID
#### 4.2.7  Internships
- PK: InternshipID
- FK: ServiceID
#### 4.2.8  Internships_passed
- PK: InternshipID, CustomerID
- FK: InternshipID, CustomerID
#### 4.2.9  Syllabus
- PK: SyllabusID
- FK: SubjectID
#### 4.2.10 Subjects
- PK: SubjectID
- FK: LecturerID
&nbsp;
### 4.3   *Webinars* <a name="web"></a>
#### 4.3.1   Webinars
- PK: ServiceID
- FK: ServiceID
#### 4.3.2   Webinars_hist
- PK: ServiceID, LecturerID
- FK: ServiceID, LecturerID, TranslatorID
&nbsp;
### 4.3    *Kursy* <a name="crs"></a>
#### 4.3.1  Courses
- PK: ServiceID
- FK: ServiceID
#### 4.3.2  Modules
- PK: ModuleID
- FK: ServiceID
#### 4.3.3  Courses_hist
- PK: ClassID
- FK: ModuleID, LecturerID, TranslatorID
#### 4.3.4  Courses_attendace
- PK: ClassID, CustomerID
- FK: ClassID, CustomerID
&nbsp;
### 4.4 *Common tables* <a name="ctb"></a>
#### 4.4.1   Lecturers
- PK: LecturerID
#### 4.4.2   Translator
- PK: TranslatorID


