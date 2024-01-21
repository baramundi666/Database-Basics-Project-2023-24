--1. Raporty finansowe – zestawienie przychodów dla każdego webinaru/kursu/studium.

Create view dbo.FinancialRaport as(
select Major as Nazwa, sum(Services.PriceWhole) as Przychody, Studies.StartDate as Date
from Services 
join Studies on Services.ServiceID = Studies.ServiceID 
group by Major, Services.ServiceID, Studies.StartDate

union all

select Major as Nazwa ,sum(Services.PriceWhole) as Przychody, Lectures.StartDate as Date
from Services 
join Single_Studies on Services.ServiceID = Single_Studies.ServiceID 
join Lectures on Lectures.LectureID = Single_Studies.LectureID
group by Major, Services.ServiceID, Lectures.StartDate

union all

select WebinarName as Nazwa ,sum(Services.PriceWhole) as Przychody, Webinars.StartDate as Date
from Services 
join Webinars on Services.ServiceID = Webinars.ServiceID 
group by WebinarName, Services.ServiceID, Webinars.StartDate

union all

select CourseName as Nazwa, sum(Services.PriceWhole) as Przychody, Courses.StartDate as Date
from Services 
join Courses on Services.ServiceID = Courses.ServiceID 
group by CourseName, Services.ServiceID, Courses.StartDate)

go 

--2. Lista „dłużników” – osoby, które skorzystały z usług, ale nie uiściły opłat.

Create view dbo.DebtorsList as (
select FirstName, LastName, Balance
from Customers
where Balance < 0 and CustomerID in(
select Customers.CustomerID
from Customers
join Orders on Customers.CustomerID = Orders.CustomerID
join Order_Details on Orders.OrderID = Order_Details.OrderID
join Services on Order_Details.ServiceID = Services.ServiceID
join Studies on Services.ServiceID = Studies.ServiceID
where Studies.StartDate < GETDATE()
group by Customers.CustomerID

union

select Customers.CustomerID
from Customers
join Orders on Customers.CustomerID = Orders.CustomerID
join Order_Details on Orders.OrderID = Order_Details.OrderID
join Services on Order_Details.ServiceID = Services.ServiceID
join Single_studies on Services.ServiceID = Single_studies.ServiceID
join Lectures on Lectures.LectureID = Single_studies.LectureID
where Lectures.StartDate < GETDATE()
group by Customers.CustomerID

union

select Customers.CustomerID
from Customers
join Orders on Customers.CustomerID = Orders.CustomerID
join Order_Details on Orders.OrderID = Order_Details.OrderID
join Services on Order_Details.ServiceID = Services.ServiceID
join Webinars on Webinars.ServiceID = Services.ServiceID
where Webinars.StartDate < GETDATE()
group by Customers.CustomerID

union

select Customers.CustomerID
from Customers
join Orders on Customers.CustomerID = Orders.CustomerID
join Order_Details on Orders.OrderID = Order_Details.OrderID
join Services on Order_Details.ServiceID = Services.ServiceID
join Courses on Services.ServiceID = Courses.ServiceID
where Courses.StartDate < GETDATE()
group by Customers.CustomerID)
group by FirstName, LastName, Balance)


go
--3. Ogólny raport dotyczący liczby zapisanych osób na przyszłe wydarzenia (z informacją,
--czy wydarzenie jest stacjonarnie, czy zdalnie).

Create view dbo.FutureEventsAttendance as(
select Lectures.ServiceID,Lectures.LecturerID,Lectures.Type as Typ, Lectures.StartDate,  count(Customers.CustomerID) as Liczba_Zapisanych_Osób
from Customers
join Orders on Customers.CustomerID = Orders.CustomerID
join Order_Details on Orders.OrderID = Order_Details.OrderID
join Services on Order_Details.ServiceID = Services.ServiceID
join Studies on Studies.ServiceID = Services.ServiceID
join Lectures on Lectures.ServiceID = Studies.ServiceID
where Lectures.StartDate > GETDATE()
group by Lectures.ServiceID,Lectures.LecturerID,Lectures.Type, Lectures.StartDate

union

select Lectures.ServiceID,Lectures.LecturerID,Lectures.Type as Typ, Lectures.StartDate,  count(Customers.CustomerID) as Liczba_Zapisanych_Osób
from Customers
join Orders on Customers.CustomerID = Orders.CustomerID
join Order_Details on Orders.OrderID = Order_Details.OrderID
join Services on Order_Details.ServiceID = Services.ServiceID
join Single_studies on Single_studies.ServiceID = Services.ServiceID
join Lectures on Lectures.ServiceID = Single_studies.ServiceID
where Lectures.StartDate > GETDATE()
group by Lectures.ServiceID,Lectures.LecturerID,Lectures.Type, Lectures.StartDate

union

select Webinars_hist.ServiceID,Webinars_hist.LecturerID, 'Zdalnie' as Typ, Webinars_hist.StartDate,  count(Customers.CustomerID) as Liczba_Zapisanych_Osób
from Customers
join Orders on Customers.CustomerID = Orders.CustomerID
join Order_Details on Orders.OrderID = Order_Details.OrderID
join Services on Order_Details.ServiceID = Services.ServiceID
join Webinars on Webinars.ServiceID = Services.ServiceID
join Webinars_hist on Webinars_hist.ServiceID = Webinars.ServiceID
where Webinars_hist.StartDate > GETDATE()
group by Webinars_hist.ServiceID, Webinars_hist.LecturerID, Webinars_hist.StartDate


union

select Courses_hist.ClassID,Courses_hist.LecturerID, Courses.Type as Typ, Courses_hist.StartDate,  count(Customers.CustomerID) as Liczba_Zapisanych_Osób
from Customers
join Orders on Customers.CustomerID = Orders.CustomerID
join Order_Details on Orders.OrderID = Order_Details.OrderID
join Services on Order_Details.ServiceID = Services.ServiceID
join Courses on Courses.ServiceID = Services.ServiceID
join Modules on Modules.ServiceID = Courses.ServiceID
join Courses_hist on Courses_hist.ModuleID = Modules.ModuleID
where Courses_hist.StartDate > GETDATE()
group by Courses_hist.ClassID,Courses_hist.LecturerID, Courses.Type,  Courses_hist.StartDate)

go

--4. Ogólny raport dotyczący frekwencji na zakończonych już wydarzeniach.
select
    event_type,
    event_id,
    customer_id,
    attendance
from
    (
        select
            'lecture' as event_type,
            la.lecture_id as event_id,
            la.customer_id,
            la.attendance
        from
            lectures_attendance la
            join lectures l on la.lecture_id = l.lecture_id
        where
            l.end_date <= getdate()

        union all

        select
            'webinar' as event_type,
            wa.webinar_id as event_id,
            wa.customer_id,
            wa.attendance
        from
            webinars_attendance wa
            join webinars_hist wh on wa.webinar_id = wh.webinar_id
        where
            wh.end_date <= getdate()

        union all

        select
            'course' as event_type,
            ca.class_id as event_id,
            ca.customer_id,
            ca.attendance
        from
            courses_attendance ca
            join courses_hist ch on ca.class_id = ch.class_id
        where
            ch.end_date <= getdate()
    ) all_events;

go
--5. Lista obecności dla każdego szkolenia z datą, imieniem, nazwiskiem i informacją czy
--uczestnik był obecny, czy nie.

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
    join Lectures on Studies.ServiceID = Lectures.ServiceID
    join Lectures_attendance on Lectures.LectureID = Lectures_attendance.LectureID
    join Customers c on Lectures_attendance.CustomerID = c.CustomerID

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
    join Lectures on Single_Studies.LectureID = Lectures.LectureID
    join Lectures_attendance on Lectures.LectureID = Lectures_attendance.LectureID
    join Customers on Lectures_attendance.CustomerID = Customers.CustomerID

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
    join Webinars_hist Webinars_hist on w.ServiceID = Webinars_hist.ServiceID
    join Webinars_attendance Webinars_attendance on Webinars_hist.WebinarID = Webinars_attendance.WebinarID
    join Customers c on Webinars_attendance.CustomerID = c.CustomerID

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
	join Modules on Courses.ServiceID = Modules.ServiceID
    join Courses_hist on Courses.ServiceID = Modules.ServiceID
    join Courses_attendance on Courses_hist.ClassID = Courses_attendance.ClassID
    join Customers on Courses_attendance.CustomerID = Customers.CustomerID;

	go
--6. Raport bilokacji: lista osób, które są zapisane na co najmniej dwa przyszłe szkolenia,
--które ze sobą kolidują czasowo.

CREATE VIEW BilocationReport AS
SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName,
    t1.ServiceID AS Service1ID,
    t1.ServiceType AS Service1Type,
    t1.StartDate AS Service1StartDate,
    t1.EndDate AS Service1EndDate,
    t2.ServiceID AS Service2ID,
    t2.ServiceType AS Service2Type,
    t2.StartDate AS Service2StartDate,
    t2.EndDate AS Service2EndDate
FROM
    Customers c
    JOIN (
        SELECT
            Lectures_attendance.CustomerID,
            Lectures.ServiceID AS ServiceID,
            'Studies' AS ServiceType,
            Lectures.StartDate,
            Lectures.EndDate
        FROM Studies
		join Lectures on Lectures.ServiceID = Studies.ServiceID
		join Lectures_attendance on Lectures.LectureID = Lectures_attendance.LectureID
        WHERE Lectures.EndDate > GETDATE()

        UNION

        SELECT
            la.CustomerID,
            lh.ServiceID AS ServiceID,
            'Single_Studies' AS ServiceType,
            lh.StartDate,
            lh.EndDate
        FROM Lectures_attendance la
        INNER JOIN Lectures lh ON la.LectureID = lh.LectureID
        WHERE lh.EndDate > GETDATE()

        UNION 

        SELECT
            wa.CustomerID,
            wh.ServiceID AS ServiceID,
            'Webinars' AS ServiceType,
            wh.StartDate,
            wh.EndDate
        FROM Webinars_attendance wa
        JOIN Webinars_hist wh ON wa.WebinarID = wh.WebinarID
        WHERE wh.EndDate > GETDATE()

        UNION 

        SELECT
            Courses_attendance.CustomerID,
            Modules.ServiceID AS ServiceID,
            'Courses' AS ServiceType,
            Courses_hist.StartDate,
            Courses_hist.EndDate
        FROM Courses_attendance
        JOIN Courses_hist ON Courses_attendance.ClassID = Courses_hist.ClassID
		join Modules on Modules.ModuleID = Courses_hist.ModuleID
        WHERE Courses_hist.EndDate > GETDATE()
    ) t1 ON c.CustomerID = t1.CustomerID

    JOIN (
        SELECT
            Lectures_attendance.CustomerID,
            Lectures.ServiceID AS ServiceID,
            'Studies' AS ServiceType,
            Lectures.StartDate,
            Lectures.EndDate
        FROM Studies
		join Lectures on Lectures.ServiceID = Studies.ServiceID
		join Lectures_attendance on Lectures.LectureID = Lectures_attendance.LectureID
        WHERE Lectures.EndDate > GETDATE()

        UNION ALL

        SELECT
            la.CustomerID,
            lh.ServiceID AS ServiceID,
            'Single_Studies' AS ServiceType,
            lh.StartDate,
            lh.EndDate
        FROM Lectures_attendance la
        INNER JOIN Lectures lh ON la.LectureID = lh.LectureID
        WHERE lh.EndDate > GETDATE()

        UNION ALL

        SELECT
            wa.CustomerID,
            wh.ServiceID AS ServiceID,
            'Webinars' AS ServiceType,
            wh.StartDate,
            wh.EndDate
        FROM Webinars_attendance wa
        INNER JOIN Webinars_hist wh ON wa.WebinarID = wh.WebinarID
        WHERE wh.EndDate > GETDATE()

        UNION ALL

        SELECT
            ca.CustomerID,
            Modules.ServiceID AS ServiceID,
            'Courses' AS ServiceType,
            Courses_hist.StartDate,
            Courses_hist.EndDate
        FROM Courses_attendance ca
        INNER JOIN Courses_hist ON ca.ClassID = Courses_hist.ClassID
		join Modules on Modules.ModuleID = Courses_hist.ModuleID
        WHERE Courses_hist.EndDate > GETDATE()
    ) t2 ON c.CustomerID = t2.CustomerID
    AND t1.ServiceID < t2.ServiceID
    AND t1.EndDate > t2.StartDate
    AND t1.StartDate < t2.EndDate;
