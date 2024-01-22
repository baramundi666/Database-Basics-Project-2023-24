-- Create the CheckClassDates scalar-valued function
CREATE FUNCTION CheckClassDates
(
    @ModuleID int,
    @StartDateOfClass datetime,
    @EndDateOfClass datetime
)
RETURNS bit
AS
BEGIN
    DECLARE @IsValid bit = 0;

    -- Get the StartDate and EndDate of the associated course using the ModuleID
    DECLARE @CourseStartDate datetime;
    DECLARE @CourseEndDate datetime;

    SELECT @CourseStartDate = c.StartDate, @CourseEndDate = c.EndDate
    FROM Modules m
    INNER JOIN Courses c ON m.ServiceID = c.ServiceID
    WHERE m.ModuleID = @ModuleID;

    -- Check if the class dates are within the valid range for the associated course
    IF @StartDateOfClass >= @CourseStartDate AND @EndDateOfClass <= @CourseEndDate
    BEGIN
        SET @IsValid = 1;
    END

    RETURN @IsValid;
END;

go
-- Create a function to check if lecture dates correspond to study dates
CREATE FUNCTION dbo.CheckLectureDates
(
    @ServiceID int,
    @StartDate datetime,
    @EndDate datetime
)
RETURNS BIT
AS
BEGIN
    DECLARE @IsValid BIT = 0;

    -- Check if the lecture dates correspond to study dates
    IF EXISTS (
        SELECT 1
        FROM Studies s
        WHERE s.ServiceID = @ServiceID
          AND @StartDate >= s.StartDate
          AND @EndDate <= s.EndDate
    )
    BEGIN
        SET @IsValid = 1;
    END

    RETURN @IsValid;
END;
GO

-- Create a function to check the limit for Single_Studies
CREATE FUNCTION dbo.CheckLimitForSingleStudies
(
    @LectureID int,
    @Limit int
)
RETURNS BIT
AS
BEGIN
    DECLARE @IsValid BIT = 1;

    -- If limit is provided, check if it is less than or equal to the difference between the lecture limit and studies limit
    IF @Limit IS NOT NULL
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM Lectures l
            LEFT JOIN Studies s ON l.ServiceID = s.ServiceID
            WHERE l.LectureID = @LectureID
              AND @Limit > (l.Limit - ISNULL(s.Limit, 0))
        )
        BEGIN
            SET @IsValid = 0;
        END
    END

    RETURN @IsValid;
END;
GO


-- Create a function to check if there is a cart for a customer
CREATE FUNCTION IsThereCart (@CustomerID INT)
RETURNS INT
AS
BEGIN
    DECLARE @CartOrderID INT;

    SELECT @CartOrderID = OrderID
    FROM Orders
    WHERE CustomerID = @CustomerID
      AND OrderStatus = 'InCart';

    RETURN @CartOrderID;
END;
go

CREATE FUNCTION checklimit(@ServiceID INT)
RETURNS BIT
AS
BEGIN
    DECLARE @ModResult INT;
    DECLARE @OrderCount INT;

    -- Calculate service ID mod 4
    SET @ModResult = @ServiceID % 4;
	DECLARE @Limit INT;

   
    -- Case 1: If mod result is 1, return true
    IF @ModResult = 1
    BEGIN
        RETURN 1; -- True
    END
    ELSE
	 -- Count the number of times the serviceID has been ordered
    SELECT @OrderCount = COUNT(*)
    FROM Order_details od
    WHERE od.ServiceID = @ServiceID and  od.UnitPrice >0 ;
	BEGIN
        -- Case 2: If mod result is 2, check limit in studies
        IF @ModResult = 2
        BEGIN

            SELECT @Limit = s.Limit
            FROM Studies s
            WHERE s.ServiceID = @ServiceID;

            -- Compare counts and limit, return true if greater
            RETURN CASE WHEN @OrderCount < @Limit THEN 1 ELSE 0 END;
        END
        -- Case 3: If mod result is 3, check limit in courses
        ELSE IF @ModResult = 3
        BEGIN

            SELECT @Limit = c.Limit
            FROM Courses c
            WHERE c.ServiceID = @ServiceID;

            -- Compare counts and limit, return true if greater
            RETURN CASE WHEN @OrderCount < @Limit THEN 1 ELSE 0 END;
        END
        -- Case 4: If mod result is 0, check limit in single_studies
        ELSE IF @ModResult = 0
        BEGIN
            SELECT @Limit = ss.Limit
            FROM Single_Studies ss
            WHERE ss.ServiceID = @ServiceID;

            -- Compare counts and limit, return true if greater
            RETURN CASE WHEN @OrderCount < @Limit THEN 1 ELSE 0 END;
        END
        RETURN 0; -- False
        
    END
END;


-- FUNCTIONS-WOJTEK

CREATE FUNCTION GetFutureEvents
    ()
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM Lectures
    WHERE EndDate > GETDATE()

    UNION

    SELECT *
    FROM Webinars_hist
    WHERE EndDate > GETDATE()

    UNION

    SELECT *
    FROM Courses_hist
    WHERE EndDate > GETDATE()
);

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

CREATE FUNCTION GetClassIDsForModule
	(@ModuleID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT ClassID
    FROM Courses_attendance
    WHERE ModuleID = @ModuleID

    UNION

    SELECT ClassID
    FROM Lectures_attendance
    WHERE ModuleID = @ModuleID

    UNION

    SELECT ClassID
    FROM Webinars_attendance
    WHERE ModuleID = @ModuleID
);

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

    RETURN CASE WHEN @PassedStatus = 'Yes' THEN 1 ELSE 0; 
END;

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


CREATE FUNCTION LecturesAttendanceCheckIntegrity
(
    @CustomerID INT,
    @LectureID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @Studies INT;
    DECLARE @SingleStudies INT;

    -- Get the Studies service ID connected to the Lecture
    SELECT @Studies = ServiceID
    FROM Lectures
    WHERE LectureID = @LectureID;

    -- Get the SingleStudies service ID if it exists
    SELECT @SingleStudies = ServiceID
    FROM Single_Studies
    WHERE LectureID = @LectureID;

    -- Check if there is an OrderDetails record for Studies or SingleStudies
    IF EXISTS (
        SELECT 1
        FROM Order_details od
		join orders o
		on od.OrderID = o.OrderID
        WHERE o.CustomerID = @CustomerID
          AND (od.ServiceID = @Studies OR od.ServiceID = @SingleStudies)
    )
    BEGIN
        -- Return 1 if there is a matching record
        RETURN 1;
    END
  
        RETURN 0;

END;

CREATE FUNCTION InternshipsIntegrity
(
    @InternshipID INT,
    @CustomerID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @Studies INT;

    SELECT @Studies = ServiceID
    FROM Internships
    WHERE InternshipID = @InternshipID;

    IF EXISTS (
        SELECT 1
        FROM Order_Details od
		join Orders o
		ON o.OrderID = od.OrderID
        WHERE od.ServiceID = @Studies
          AND o.CustomerID = @CustomerID
    )
    BEGIN
        RETURN 1;
    END
        RETURN 0;

END;


CREATE FUNCTION CoursesIntegrity
(
    @ClassID INT,
    @CustomerID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @Course INT;

    SELECT @Course = m.ServiceID
    FROM Courses_hist ch 
	join Modules m
	on ch.ModuleID = m.ModuleID
    WHERE ch.ClassID = @ClassID;
	IF @Course % 4 <> 3
	BEGIN
		RETURN 0;
	END;
    IF EXISTS (
        SELECT 1
        FROM Order_Details od
		join Orders o
		ON o.OrderID = od.OrderID
        WHERE od.ServiceID = @Course
          AND o.CustomerID = @CustomerID
    )
    BEGIN
        RETURN 1;
    END
        RETURN 0;

END;