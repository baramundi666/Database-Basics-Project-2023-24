--1. Raporty finansowe – zestawienie przychodów dla każdego webinaru/kursu/studium.
use u_makrol
go
Create view dbo.FinancialRaport as
select 
	Major as Nazwa, 
	sum(Services.PriceWhole) as Przychody,
	Studies.StartDate as Date
from 
	Services 
	join Studies on Services.ServiceID = Studies.ServiceID 
group by Major, Services.ServiceID, Studies.StartDate

union

select 
	Major as Nazwa,
	sum(Services.PriceWhole) as Przychody,
	Lectures.StartDate as Date
from 
	Services 
	join Single_Studies on Services.ServiceID = Single_Studies.ServiceID 
	join Lectures on Lectures.LectureID = Single_Studies.LectureID
group by Major, Services.ServiceID, Lectures.StartDate

union

select 
	WebinarName as Nazwa,
	sum(Services.PriceWhole) as Przychody,
	Webinars.StartDate as Date
from 
	Services 
	join Webinars on Services.ServiceID = Webinars.ServiceID 
group by 
	WebinarName,
	Services.ServiceID,
	Webinars.StartDate

union

select 
	CourseName as Nazwa,
	sum(Services.PriceWhole) as Przychody,
	Courses.StartDate as Date
from 
	Services 
	join Courses on Services.ServiceID = Courses.ServiceID 
group by 
	CourseName,
	Services.ServiceID,
	Courses.StartDate;

go 

--2. Lista „dłużników” – osoby, które skorzystały z usług, ale nie uiściły opłat.

Create view dbo.DebtorsList as 
select 
	FirstName,
	LastName,
	Balance
from 
	Customers
where 
	Balance < 0 and CustomerID 
	in(
		select 
			Customers.CustomerID
		from 
			Customers
			join Orders on Customers.CustomerID = Orders.CustomerID
			join Order_Details on Orders.OrderID = Order_Details.OrderID
			join Services on Order_Details.ServiceID = Services.ServiceID
			join Studies on Services.ServiceID = Studies.ServiceID
		where 
			Studies.StartDate < GETDATE()
		group by 
			Customers.CustomerID

		union

		select 
			Customers.CustomerID
		from 
			Customers
			join Orders on Customers.CustomerID = Orders.CustomerID
			join Order_Details on Orders.OrderID = Order_Details.OrderID
			join Services on Order_Details.ServiceID = Services.ServiceID
			join Single_studies on Services.ServiceID = Single_studies.ServiceID
			join Lectures on Lectures.LectureID = Single_studies.LectureID
		where 
			Lectures.StartDate < GETDATE()
		group by 
			Customers.CustomerID

		union

		select 
			Customers.CustomerID
		from 
			Customers
			join Orders on Customers.CustomerID = Orders.CustomerID
			join Order_Details on Orders.OrderID = Order_Details.OrderID
			join Services on Order_Details.ServiceID = Services.ServiceID
			join Webinars on Webinars.ServiceID = Services.ServiceID
		where 
			Webinars.StartDate < GETDATE()
		group by 
			Customers.CustomerID

		union

		select 
			Customers.CustomerID
		from 
			Customers
			join Orders on Customers.CustomerID = Orders.CustomerID
			join Order_Details on Orders.OrderID = Order_Details.OrderID
			join Services on Order_Details.ServiceID = Services.ServiceID
			join Courses on Services.ServiceID = Courses.ServiceID
		where 
			Courses.StartDate < GETDATE()
		group by 
			Customers.CustomerID)
		group by 
			FirstName, LastName, Balance;


go
--3. Ogólny raport dotyczący liczby zapisanych osób na przyszłe wydarzenia (z informacją,
--czy wydarzenie jest stacjonarnie, czy zdalnie).

Create view dbo.FutureEventsAttendance as
select 
	Lectures.ServiceID,
	Lectures.LecturerID,
	Lectures.Type as Typ,
	Lectures.StartDate,
	count(Customers.CustomerID) as Liczba_Zapisanych_Osób
from 
	Customers
	join Orders on Customers.CustomerID = Orders.CustomerID
	join Order_Details on Orders.OrderID = Order_Details.OrderID
	join Services on Order_Details.ServiceID = Services.ServiceID
	join Studies on Studies.ServiceID = Services.ServiceID
	join Lectures on Lectures.ServiceID = Studies.ServiceID
where 
	Lectures.StartDate > GETDATE()
group by 
	Lectures.ServiceID,
	Lectures.LecturerID,
	Lectures.Type,
	Lectures.StartDate

union

select 
	Lectures.ServiceID,
	Lectures.LecturerID,
	Lectures.Type as Typ,
	Lectures.StartDate,
	count(Customers.CustomerID) as Liczba_Zapisanych_Osób
from 
	Customers
	join Orders on Customers.CustomerID = Orders.CustomerID
	join Order_Details on Orders.OrderID = Order_Details.OrderID
	join Services on Order_Details.ServiceID = Services.ServiceID
	join Single_studies on Single_studies.ServiceID = Services.ServiceID
	join Lectures on Lectures.ServiceID = Single_studies.ServiceID
where 
	Lectures.StartDate > GETDATE()
group by 
	Lectures.ServiceID,
	Lectures.LecturerID,
	Lectures.Type,
	Lectures.StartDate

union

select 
	Webinars_hist.ServiceID,
	Webinars_hist.LecturerID,
	'Zdalnie' as Typ,
	Webinars_hist.StartDate,
	count(Customers.CustomerID) as Liczba_Zapisanych_Osób
from 
	Customers
	join Orders on Customers.CustomerID = Orders.CustomerID
	join Order_Details on Orders.OrderID = Order_Details.OrderID
	join Services on Order_Details.ServiceID = Services.ServiceID
	join Webinars on Webinars.ServiceID = Services.ServiceID
	join Webinars_hist on Webinars_hist.ServiceID = Webinars.ServiceID
where 
	Webinars_hist.StartDate > GETDATE()
group by 
	Webinars_hist.ServiceID,
	Webinars_hist.LecturerID,
	Webinars_hist.StartDate


union

select 
	Courses_hist.ClassID,
	Courses_hist.LecturerID, 
	Courses.Type as Typ, 
	Courses_hist.StartDate,
	count(Customers.CustomerID) as Liczba_Zapisanych_Osób
from 
	Customers
	join Orders on Customers.CustomerID = Orders.CustomerID
	join Order_Details on Orders.OrderID = Order_Details.OrderID
	join Services on Order_Details.ServiceID = Services.ServiceID
	join Courses on Courses.ServiceID = Services.ServiceID
	join Modules on Modules.ServiceID = Courses.ServiceID
	join Courses_hist on Courses_hist.ModuleID = Modules.ModuleID
where 
	Courses_hist.StartDate > GETDATE()
group by 
	Courses_hist.ClassID,
	Courses_hist.LecturerID,
	Courses.Type,
	Courses_hist.StartDate;

go

--4. Ogólny raport dotyczący frekwencji na zakończonych już wydarzeniach.
create view dbo.AttendanceRaport as
select
    ServiceType,
    EventID,
    CustomerID,
    Attendance
from
    (
        select
            'Lecture' as ServiceType,
            Lectures_attendance.LectureID as EventID,
            Lectures_attendance.CustomerID,
            Lectures_attendance.Attendance
        from
            Lectures_attendance
            join Lectures on Lectures_attendance.LectureID = Lectures.LectureID
        where
            Lectures.EndDate <= getdate()

        union 

        select
            'Webinar' as ServiceType,
            Webinars_attendance.WebinarID as EventID,
            Webinars_attendance.CustomerID,
            Webinars_attendance.attendance
        from
            Webinars_attendance
            join Webinars_hist on Webinars_attendance.WebinarID = Webinars_hist.WebinarID
        where
            Webinars_hist.EndDate <= getdate()

        union

        select
            'Course' as ServiceType,
            Courses_attendance.ClassID as EventID,
            Courses_attendance.CustomerID,
            Courses_attendance.Attendance
        from
            Courses_attendance
            join Courses_hist on Courses_attendance.ClassID = Courses_hist.ClassID
        where
            Courses_hist.EndDate <= getdate()
    ) AttendanceRaport;

go


--5. Lista obecności dla każdego szkolenia z datą, imieniem, nazwiskiem i informacją czy
--uczestnik był obecny, czy nie.

create view dbo.AttendanceList as
select
    'Studies' as ServiceType,
    Studies.ServiceID as ServiceID,
    Lectures.StartDate as Date,
    Customers.FirstName,
    Customers.LastName,
    Lectures_attendance.Attendance as AttendanceStatus
from
    Studies
    join Lectures on Studies.ServiceID = Lectures.ServiceID
    join Lectures_attendance on Lectures.LectureID = Lectures_attendance.LectureID
    join Customers on Lectures_attendance.CustomerID = Customers.CustomerID

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
    Customers.FirstName,
    Customers.LastName,
    Webinars_attendance.Attendance as AttendanceStatus
from
    Webinars
    join Webinars_hist Webinars_hist on Webinars.ServiceID = Webinars_hist.ServiceID
    join Webinars_attendance Webinars_attendance on Webinars_hist.WebinarID = Webinars_attendance.WebinarID
    join Customers on Webinars_attendance.CustomerID = Customers.CustomerID

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

create view dbo.BilocationReport as
select
    Customers.CustomerID,
    Customers.FirstName,
    Customers.LastName,
    t1.ServiceID as Service1ID,
    t1.ServiceType as Service1Type,
    t1.StartDate as Service1StartDate,
    t1.EndDate as Service1EndDate,
    t2.ServiceID as Service2ID,
    t2.ServiceType as Service2Type,
    t2.StartDate as Service2StartDate,
    t2.EndDate as Service2EndDate
from
    Customers
    join (
        select
            Lectures_attendance.CustomerID,
            Lectures.ServiceID as ServiceID,
            'Studies' as ServiceType,
            Lectures.StartDate,
            Lectures.EndDate
        from 
			Studies
			join Lectures on Lectures.ServiceID = Studies.ServiceID
			join Lectures_attendance on Lectures.LectureID = Lectures_attendance.LectureID
        where
			Lectures.EndDate > GETDATE()

        union

        select
            la.CustomerID,
            lh.ServiceID as ServiceID,
            'Single_Studies' as ServiceType,
            lh.StartDate,
            lh.EndDate
        from
			Lectures_attendance la
			join Lectures lh on la.LectureID = lh.LectureID
        where
			lh.EndDate > GETDATE()

        union 

        select
            Webinars_attendance.CustomerID,
            Webinars_hist.ServiceID as ServiceID,
            'Webinars' as ServiceType,
            Webinars_hist.StartDate,
            Webinars_hist.EndDate
        from
			Webinars_attendance
			join Webinars_hist on Webinars_attendance.WebinarID = Webinars_hist.WebinarID
        where 
			wh.EndDate > GETDATE()

        union 

        select
            Courses_attendance.CustomerID,
            Modules.ServiceID as ServiceID,
            'Courses' as ServiceType,
            Courses_hist.StartDate,
            Courses_hist.EndDate
        from 
			Courses_attendance
			join Courses_hist on Courses_attendance.ClassID = Courses_hist.ClassID
			join Modules on Modules.ModuleID = Courses_hist.ModuleID
        where
			Courses_hist.EndDate > GETDATE()
    ) t1 on c.CustomerID = t1.CustomerID

    join (
        select
            Lectures_attendance.CustomerID,
            Lectures.ServiceID as ServiceID,
            'Studies' as ServiceType,
            Lectures.StartDate,
            Lectures.EndDate
        from
			Studies
			join Lectures on Lectures.ServiceID = Studies.ServiceID
			join Lectures_attendance on Lectures.LectureID = Lectures_attendance.LectureID
        where
			Lectures.EndDate > GETDATE()

        union

        select
            la.CustomerID,
            lh.ServiceID as ServiceID,
            'Single_Studies' as ServiceType,
            lh.StartDate,
            lh.EndDate
        from
			Lectures_attendance la
			join Lectures lh on la.LectureID = lh.LectureID
        where
			lh.EndDate > GETDATE()

        union

        select
            wa.CustomerID,
            wh.ServiceID as ServiceID,
            'Webinars' as ServiceType,
            wh.StartDate,
            wh.EndDate
        from
			Webinars_attendance wa
			join Webinars_hist wh on wa.WebinarID = wh.WebinarID
        where
			wh.EndDate > GETDATE()

        union

        select
            ca.CustomerID,
            Modules.ServiceID as ServiceID,
            'Courses' as ServiceType,
            Courses_hist.StartDate,
            Courses_hist.EndDate
        from 
			Courses_attendance ca
			join Courses_hist on ca.ClassID = Courses_hist.ClassID
			join Modules on Modules.ModuleID = Courses_hist.ModuleID
        where
			Courses_hist.EndDate > GETDATE()
    ) t2 on c.CustomerID = t2.CustomerID
    and t1.ServiceID < t2.ServiceID
    and t1.EndDate > t2.StartDate
    and t1.StartDate < t2.EndDate;
