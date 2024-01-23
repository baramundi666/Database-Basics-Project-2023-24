
CREATE VIEW BilocationRaport 
AS
With CoursesClasses AS(
	Select c.CourseName ServiceName, m.ServiceID ServiceID, ch.StartDate StartDate, ch.EndDate EndDate
	from Courses_hist ch
	join modules m on m.moduleid = ch.moduleid
	join courses c on m.serviceid = c.serviceid
	WHERE GETDATE() < ch.StartDate
),
LectureClasses AS(
	Select s.Major as ServiceName, s.ServiceID ServiceID, l.StartDate StartDate, l.EndDate EndDate
	from Lectures l 
	join Studies s on s.ServiceID = l.ServiceID
	WHERE GETDATE() < l.StartDate

),
singleClasses AS(
	Select ss.Major ServiceName, ss.ServiceID ServiceID, l.StartDate StartDate, l.EndDate EndDate
	from Single_Studies ss
	join Lectures l on l.LectureID = ss.LectureID
	WHERE GETDATE() < l.StartDate

),
UNIONSERVICES AS(
	Select WebinarName ServiceName, ServiceID ServiceID, StartDate StartDate, EndDate EndDate
	from Webinars w
	WHERE GETDATE() < w.StartDate

	UNION ALL
	Select ServiceName ServiceName, ServiceID ServiceID, StartDate StartDate, EndDate EndDate
	from CoursesClasses
	UNION ALL
	Select ServiceName, ServiceID ServiceID, StartDate StartDate, EndDate EndDate
	from LectureClasses 
	UNION ALL
	Select ServiceName, ServiceID ServiceID, StartDate StartDate, EndDate EndDate
	from SingleClasses 

),
CUSTOMERS_SERVICES AS (
	Select c.FirstName FirstName, c.LastName LastName, o.CustomerID CustomerID,u.ServiceName ServiceName, od.ServiceID ServiceID, u.StartDate StartDate, u.EndDate EndDate
	from Order_details od
	join orders o on o.OrderID = od.OrderID 
	join customers c on o.CustomerID = c.CustomerID
	join UNIONSERVICES u on od.ServiceID = u.ServiceID 

)
SELECT
	cs1.FirstName,
	cs1.LastName,
    cs1.CustomerID,
	cs1.ServiceName AS ServiceName1,
    cs1.ServiceID AS ServiceID1,
	cs1.StartDate AS StartDate1,
	cs2.ServiceName AS ServiceName2,
    cs2.ServiceID AS ServiceID2,
	cs2.StartDate AS StartDate2

FROM
    CUSTOMERS_SERVICES cs1
JOIN
    CUSTOMERS_SERVICES cs2 ON cs1.CustomerID= cs2.CustomerID
WHERE
    cs1.ServiceID < cs2.ServiceID
    AND (
        (cs1.StartDate BETWEEN cs2.StartDate AND cs2.EndDate)
        OR (cs1.EndDate BETWEEN cs2.StartDate AND cs2.EndDate)
	)
GO

select * from BilocationRaport

select * from webinars where serviceid = 1 or serviceid = 2017