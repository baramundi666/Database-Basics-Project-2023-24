select * from BilocationRaport

select * from webinars
where serviceID = 2021

select * from customers
where customerID = 1

-- customerid = 1 balance = -1000

exec buynow 2, 2021
exec buynow 2, 2025

select * from order_details
where serviceID = 2021

select dbo.checklimit(2021)

CREATE PROCEDURE BuyNow
    @CustomerID INT,
    @ServiceID INT
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        IF dbo.checklimit(@ServiceID) = 0
        BEGIN
            ROLLBACK;
            RETURN;
        END

        DECLARE @Balance MONEY;
        SELECT @Balance = Balance FROM Customers WHERE CustomerID = @CustomerID;

        DECLARE @PriceInAdvance MONEY, @PriceWhole MONEY;
        SELECT @PriceInAdvance = PriceInAdvance, @PriceWhole = PriceWhole FROM Services WHERE ServiceID = @ServiceID;

        IF @Balance < @PriceInAdvance
        BEGIN
            ROLLBACK;
            RETURN;
        END

	DECLARE @duedate DATETIME;
	SET @duedate = DATEADD(DAY, 5, GETDATE());

        INSERT INTO Orders (CustomerID, OrderDate, PaymentAssesed, PaymentPaid, PaymentWaived, DueDate, OrderStatus)
        VALUES (@CustomerID, GETDATE(), @PriceWhole, 
                CASE WHEN @PriceWhole < @Balance THEN @PriceWhole ELSE @Balance END, 0,@duedate,
                'Ordered');


        DECLARE @NewOrderID INT;
        SET @NewOrderID = SCOPE_IDENTITY();

        UPDATE Customers
        SET Balance = Balance - CASE WHEN @PriceWhole < @Balance THEN @PriceWhole ELSE @Balance END
        WHERE CustomerID = @CustomerID;

        INSERT INTO Order_details (OrderID, ServiceID, UnitPrice)
        VALUES (@NewOrderID, @ServiceID, @PriceWhole);

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;

        THROW;
    END CATCH;
END;