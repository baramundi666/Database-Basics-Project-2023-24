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
 
![diagramphoto](https://github.com/baramundi666/PBD_projekt/assets/128089906/741aeddb-0e93-47d3-be98-f4f0da8c26bd)

## 4.    Realizowane tabele
### 4.1    Customers
### 4.2    Orders
### 4.2.1    OrderDetails
### 4.3    Services
#### 4.3.1 Courses
##### 4.3.1.1    Modules
##### 4.3.1.2    Courses_hist
##### 4.3.1.3    Courses_attendace

#### 4.3.2    Webinars
##### 4.3.2.1    Webinars_hist
#### 4.3.3    Studies 
##### 4.3.3.1   SingleStudies
##### 4.3.3.2   Lectures
###### 4.3.3.2.1   Lecturers
###### 4.3.3.2.2   Translator
###### 4.3.3.2.3   Lectures_attendance
##### 4.3.3.3   Exams
###### 4.3.3.3.1   Diplomas
##### 4.3.3.3   Internships
###### 4.3.3.3.1  Internships_passed
##### 4.3.3.4   Sylalabus
###### 4.3.3.4.1    Subjects




