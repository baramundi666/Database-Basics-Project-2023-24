CREATE PROCEDURE UpdateLectureAttendance
    @CustomerID INT,
    @LectureID INT,
    @AttendanceStatus VARCHAR(10)
AS
BEGIN
    -- Begin a new transaction
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check the integrity of the attendance data
        IF dbo.LecturesAttendanceCheckIntegrity(@CustomerID, @LectureID) = 0
        BEGIN
            -- If integrity check fails, throw an error and rollback the transaction
            THROW 50001, 'Invalid attendance data.', 1;
        END

        -- Add a new record to the lecturesattendance table with AttendanceStatus
        INSERT INTO Lectures_attendance(CustomerID, LectureID, Attendance)
        VALUES (@CustomerID, @LectureID, @AttendanceStatus);

        -- Commit the transaction
        COMMIT;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK;

        -- Re-throw the error
        THROW;
    END CATCH;
END;


select * from Order_details
select * from services 
select * from studies 
select * from customers 
select * from Internships
CREATE PROCEDURE UpdateInternshipPassed
    @InternshipID INT,
    @CustomerID INT,
    @Passed NVARCHAR(3)  -- Assuming 'Yes' or 'No' values
AS
BEGIN
    -- Check integrity using the InternshipsIntegrity function
    IF dbo.InternshipsIntegrity(@InternshipID, @CustomerID) = 0
    BEGIN
        -- Integrity check failed, throw an error
        THROW 50001, 'Integrity check failed. Record not found in Order_Details.', 1;
    END

    -- Insert record into Internship_Passed table
    INSERT INTO Internships_passed (InternshipID, CustomerID, Passed)
    VALUES (@InternshipID, @CustomerID, @Passed);
END;

CREATE PROCEDURE UpdateExams
    @ServiceID INT,
    @CustomerID INT,
    @Grade float(1)
AS
BEGIN
	IF @ServiceID % 4 <> 2
    BEGIN
        THROW 50002, 'Invalid ServiceID for updating diploma.', 1;
    END
    -- Check if there exists a record in order_details for the specified service and customer
    IF NOT EXISTS (
        SELECT 1
        FROM Order_details od
		join orders o 
		on od.OrderID = o.OrderID
        WHERE od.ServiceID = @ServiceID
          AND o.CustomerID = @CustomerID
    )
    BEGIN
        -- If no such record exists, throw an error
        THROW 50001, 'No order record found for the specified service and customer.', 1;
    END

    -- If the record exists, proceed to insert into the exams table
    INSERT INTO Exams (ServiceID, CustomerID, Grade)
    VALUES (@ServiceID, @CustomerID, @Grade);
END;
     



CREATE PROCEDURE UpdateDiploma
    @ServiceID INT,
    @CustomerID INT,
    @Date DATETIME,
    @Title VARCHAR(255)
AS
BEGIN
    -- Check if ServiceID mod 4 is not equal to 2
    IF @ServiceID % 4 <> 2
    BEGIN
        THROW 50002, 'Invalid ServiceID for updating diploma.', 1;
    END

    -- Check if there exists a record in order_details for the given parameters
    IF NOT EXISTS (
        SELECT 1
        FROM Order_details od
		join orders o 
		on o.orderid = od.orderid 
        WHERE od.ServiceID = @ServiceID
          AND o.CustomerID = @CustomerID
    )
    BEGIN
        THROW 50001, 'No matching record in order_details found.', 1;
    END

    -- Insert a record into the exams table
    INSERT INTO Diplomas(ServiceID, CustomerID, Date, Title)
    VALUES (@ServiceID, @CustomerID, @Date, @Title);
END;



CREATE PROCEDURE UpdateCoursesAttendance
	@ClassID INT,
	@CustomerID INT,
	@Attendance varchar(10)
AS
BEGIN
	Declare @ModuleID INT;
	SELECT @ModuleID = m.ModuleID from Courses_hist m 
	where m.ClassID =  @ClassID

	IF dbo.CoursesIntegrity(@ClassID, @CustomerID)= 0 
	BEGIN
        THROW 50001, 'Integrity check failed. Record not found in Order_Details.', 1;
    END
	INSERT INTO Courses_attendance(ClassID, CustomerID, ModuleID, Attendance)
    VALUES (@ClassID, @CustomerID,@ModuleID, @Attendance);
END;


CREATE PROCEDURE UpdateWebinarsAtttendance
	@WebinarID  INT,
	@CustomerID INT,
	@Attendance varchar(10)
AS
BEGIN
	Declare @ServiceID INT;
	SELECT @ServiceID = w.serviceID from Webinars_hist w 
	where w.WebinarID = @WebinarID
	IF NOT EXISTS (
        SELECT 1
        FROM Order_details od
		join orders o 
		on o.orderid = od.orderid 
        WHERE od.ServiceID = @ServiceID
          AND o.CustomerID = @CustomerID
    )
    BEGIN
        THROW 50001, 'No matching record in order_details found.', 1;
    END

	INSERT INTO Webinars_attendance(WebinarID, CustomerID, Attendance)
	VALUES(@WebinarID,@CustomerID,@Attendance)
END