-- FUNCTIONS-WOJTEK

--Funkcja zwracająca wszytskich klientów z balansem mniejszym niż podana granica
CREATE FUNCTION GetCustomersWithBalanceBeneath
    (@ThresholdMoney MONEY)
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM Customers
    WHERE Balance < @ThresholdMoney
);

--Funkcja zwracająca saldo danego klienta
CREATE FUNCTION GetCustomerBalance
	(@CustomerID INT)
RETURNS MONEY
AS
BEGIN
    DECLARE @CustomerBalance MONEY;

    SELECT @CustomerBalance = Balance
    FROM Customers
    WHERE CustomerID = @CustomerID;

    RETURN @CustomerBalance;
END;


--Funkcja zwracająca ID odbytych już lekcji składających się na moduł, którego ID podano
CREATE FUNCTION GetClassIDsForModule
	(@ModuleID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT ClassID
    FROM Courses_attendance
    WHERE ModuleID = @ModuleID
);

--Funkcja zwracająca wykłady dla danego kierunku studiów
CREATE FUNCTION GetLecturesForStudies
	(@ServiceID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT L.*
    FROM Lectures AS L
    INNER JOIN Studies AS S ON L.ServiceID = S.ServiceID
    WHERE S.ServiceID = @ServiceID
);


--Funkcja zwracająca przedmioty dla danego syllabusu kierunku studiów
CREATE FUNCTION GetSubjectsForSyllabus
	(@SyllabusID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT S.*
    FROM Subjects AS S
    INNER JOIN Syllabus_details AS SD ON S.SubjectID = SD.SubjectID
    WHERE SD.SyllabusID = @SyllabusID
);


--Funkcja sprawdzająca czy podany uzytkownik ukończył swój staż
CREATE FUNCTION CheckInternshipPassed
(@CustomerID INT)
RETURNS BIT
AS
BEGIN
    DECLARE @PassedStatus VARCHAR(3);

    SELECT @PassedStatus = Passed
    FROM Internships_passed
    WHERE CustomerID = @CustomerID;

    RETURN CASE WHEN @PassedStatus = 'Yes' THEN 1 ELSE 0 
END;


--Funkcja zwracająca wszystkie dyplomy dla danego użytkownika
CREATE FUNCTION GetDiplomasForCustomer
	(@CustomerID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT D.*
    FROM Diplomas AS D
    WHERE D.CustomerID = @CustomerID
);

--Funkcja sprawdzająca czy podany kursant pojawił się na podanym wykładzie
CREATE FUNCTION CheckCustomerAttendance
(
    @CustomerID INT,
    @LectureID INT
)
RETURNS BIT
AS
BEGIN
    DECLARE @Attendance BIT;

    SELECT @Attendance = CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END
    FROM Lectures_attendance
    WHERE CustomerID = @CustomerID AND LectureID = @LectureID;

    RETURN @Attendance;
END;

CREATE FUNCTION CheckInternshipPassed
(
    @CustomerID INT
)
RETURNS BIT
AS
BEGIN
    DECLARE @PassedStatus VARCHAR(3);

    SELECT @PassedStatus = Passed
    FROM Internships_passed
    WHERE CustomerID = @CustomerID;

    RETURN CASE WHEN @PassedStatus = 'Yes' THEN 1 ELSE 0 END;
END;