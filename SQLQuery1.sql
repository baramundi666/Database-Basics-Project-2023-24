
CREATE VIEW BilocationRaport 
AS
With CoursesClasses AS(
	Select m.ServiceID ServiceID, ch.StartDate StartDate, ch.EndDate EndDate
	from Courses_hist ch
	join modules m on m.moduleid = ch.moduleid
	WHERE GETDATE() < ch.StartDate
),
LectureClasses AS(
	Select s.ServiceID, l.StartDate StartDate, l.EndDate EndDate
	from Lectures l 
	join Studies s on s.ServiceID = l.ServiceID
	WHERE GETDATE() < l.StartDate

),
singleClasses AS(
	Select ss.ServiceID, l.StartDate StartDate, l.EndDate EndDate
	from Single_Studies ss
	join Lectures l on l.LectureID = ss.LectureID
	WHERE GETDATE() < l.StartDate

),
UNIONSERVICES AS(
	Select ServiceID ServiceID, StartDate StartDate, EndDate EndDate
	from Webinars w
	WHERE GETDATE() < w.StartDate

	UNION ALL
	Select ServiceID ServiceID, StartDate StartDate, EndDate EndDate
	from CoursesClasses
	UNION ALL
	Select ServiceID ServiceID, StartDate StartDate, EndDate EndDate
	from LectureClasses 
	UNION ALL
	Select ServiceID ServiceID, StartDate StartDate, EndDate EndDate
	from SingleClasses 

),
CUSTOMERS_SERVICES AS (
	Select o.CustomerID CustomerID, od.ServiceID ServiceID, u.StartDate StartDate, u.EndDate EndDate
	from Order_details od
	join orders o on o.OrderID = od.OrderID 
	join UNIONSERVICES u on od.ServiceID = u.ServiceID 

)
SELECT
    cs1.CustomerID,
    cs1.ServiceID AS ServiceID1,
    cs2.ServiceID AS ServiceID2,
    cs1.StartDate AS Date
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