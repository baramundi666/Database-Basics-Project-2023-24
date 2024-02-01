-- Create a procedure to add a service to the cart
CREATE PROCEDURE AddToCart
    @CustomerID INT,
    @ServiceID INT
AS
BEGIN
    -- Begin a new transaction
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if the given ServiceID exists in the database
        IF NOT EXISTS (SELECT 1 FROM Services WHERE ServiceID = @ServiceID)
        BEGIN
            THROW 50001, 'Service with the provided ID does not exist.', 1;
        END

        -- Check if there is an existing cart for the customer
        DECLARE @CartOrderID INT;
        SELECT @CartOrderID = dbo.IsThereCart(@CustomerID);

        IF @CartOrderID IS NULL
        BEGIN
            -- If no cart exists, create a new Order
            INSERT INTO Orders (CustomerID, OrderDate, PaymentAssesed, PaymentPaid, PaymentWaived, DueDate, OrderStatus)
            VALUES (@CustomerID, GETDATE(), 0, 0, 0, DATEADD(DAY, 30, GETDATE()), 'InCart');

            -- Get the newly created OrderID
            SET @CartOrderID = SCOPE_IDENTITY();
        END
		IF @CartOrderID is not NULL
		BEGIN
			SET @CartOrderID = @CartOrderID;
		END
        -- Add the service to the cart by inserting a record into Order_details
        INSERT INTO Order_details (ServiceID, OrderID, UnitPrice)
        VALUES (@ServiceID, @CartOrderID, 0);

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

GO



-- Create a procedure to delete a service from the cart
CREATE PROCEDURE DeleteFromCart
    @CustomerID INT,
    @ServiceID INT
AS
BEGIN
    -- Begin a new transaction
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if the given ServiceID exists in the database
        IF NOT EXISTS (SELECT 1 FROM Services WHERE ServiceID = @ServiceID)
        BEGIN
            THROW 50001, 'Service with the provided ID does not exist.', 1;
        END

        -- Check if there is an existing cart for the customer
        DECLARE @CartOrderID INT;
        SET @CartOrderID = dbo.IsThereCart(@CustomerID);

        -- If there is no cart, do nothing
        IF @CartOrderID IS NULL
        BEGIN
			ROLLBACK;
            RETURN;
        END

        -- Delete the record from Order_details with the given ServiceID
        DELETE FROM Order_details
        WHERE OrderID = @CartOrderID AND ServiceID = @ServiceID;

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


GO


-- Create a procedure to process the purchase of items in the cart
CREATE PROCEDURE BuyCart
    @CustomerID INT
AS
BEGIN
    -- Begin a new transaction
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if there is an existing cart for the customer
        DECLARE @CartOrderID INT;
        SET @CartOrderID = dbo.IsThereCart(@CustomerID);

        -- If there is no cart, do nothing
        IF @CartOrderID IS NULL
        BEGIN
            RETURN;
        END

        -- Update the OrderStatus to "Ordered"
        UPDATE Orders
        SET OrderStatus = 'Ordered',
            OrderDate = GETDATE()
        WHERE OrderID = @CartOrderID;

        DECLARE @NewBalance MONEY;
        SELECT @NewBalance = Balance FROM Customers WHERE CustomerID = @CustomerID;

        DECLARE @NewPaymentPaid MONEY = 0;
        DECLARE @NewPaymentAssesed MONEY = 0;
        -- Process payments for each service in the order
        UPDATE od
		SET od.UnitPrice = s.PriceWhole,
			@NewPaymentAssesed = @NewPaymentAssesed + s.PriceWhole,
			@NewPaymentPaid = @NewPaymentPaid + 
				CASE 
					WHEN s.PriceWhole > @NewBalance and @NewBalance>0 THEN @NewBalance
					WHEN s.PriceWhole > @NewBalance and @NewBalance<0 THEN 0
					ELSE s.PriceWhole
				END,
			@NewBalance = @NewBalance - s.PriceWhole
		FROM Order_details od
		INNER JOIN Services s ON od.ServiceID = s.ServiceID
		INNER JOIN Orders o ON od.OrderID = o.OrderID
		INNER JOIN Customers c ON o.CustomerID = c.CustomerID
		WHERE od.OrderID = @CartOrderID;


        -- Update Orders table with new payment information
        UPDATE Orders
        SET PaymentPaid = @NewPaymentPaid,
            PaymentAssesed = @NewPaymentAssesed
        WHERE OrderID = @CartOrderID;

        -- Update Customers table with new balance
        UPDATE Customers
        SET Balance = @NewBalance
        WHERE CustomerID = @CustomerID;

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
GO



CREATE PROCEDURE UpdateBalance
    @CustomerID INT,
    @Amount MONEY
AS
BEGIN
    -- Begin a new transaction
    BEGIN TRANSACTION;

    BEGIN TRY
	    UPDATE Customers
        SET Balance = Balance + @Amount
        WHERE CustomerID = @CustomerID;

        DECLARE @RemainingAmount MONEY = @Amount;

        WHILE @RemainingAmount > 0
        BEGIN
            -- Find the oldest order with PaymentAssesed - PaymentPaid > 0
            DECLARE @OldestOrderID INT;

            SELECT TOP 1 @OldestOrderID = o.OrderID
            FROM Orders o
            WHERE o.CustomerID = @CustomerID
              AND o.PaymentAssesed - o.PaymentPaid > 0
            ORDER BY o.OrderDate;

            -- Exit the loop if no such order is found
            IF @OldestOrderID IS NULL
                BREAK;
			
            -- Calculate the remaining amount to be paid for this order
            DECLARE @RemainingOrderAmount MONEY;
            SELECT @RemainingOrderAmount = o.PaymentAssesed - o.PaymentPaid from orders o where orderID = @OldestOrderID

            -- Calculate the amount to be paid for this iteration
            DECLARE @PaymentThisIteration MONEY;
            SET @PaymentThisIteration = CASE
                WHEN @RemainingOrderAmount >= @RemainingAmount THEN @RemainingAmount
                ELSE @RemainingOrderAmount
            END;

            -- Update OrderDetails and Order tables
            UPDATE o
            SET  o.PaymentPaid = o.PaymentPaid + @PaymentThisIteration
            FROM Orders o
            WHERE o.OrderID = @OldestOrderID;

            -- Update the remaining amount
            SET @RemainingAmount = @RemainingAmount - @PaymentThisIteration;
        END

        -- Update the balance for the specified customer


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

GO

CREATE PROCEDURE BuyNow
    @CustomerID INT,
    @ServiceID INT
AS
BEGIN
    -- Begin a new transaction
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if the product is available based on the limit
        IF dbo.checklimit(@ServiceID) = 0
        BEGIN
            -- Rollback the transaction if the product is not available
            ROLLBACK;
            RETURN;
        END

        -- Check if balance is sufficient
        DECLARE @Balance MONEY;
        SELECT @Balance = Balance FROM Customers WHERE CustomerID = @CustomerID;

        DECLARE @PriceInAdvance MONEY, @PriceWhole MONEY;
        SELECT @PriceInAdvance = PriceInAdvance, @PriceWhole = PriceWhole FROM Services WHERE ServiceID = @ServiceID;

        IF @Balance < @PriceInAdvance
        BEGIN
            -- Rollback the transaction if balance is insufficient
            ROLLBACK;
            RETURN;
        END

        -- Create a new order
	DECLARE @duedate DATETIME;
	SET @duedate = DATEADD(DAY, 5, GETDATE());

-- Now @duedate holds the date 5 days from the current date

        INSERT INTO Orders (CustomerID, OrderDate, PaymentAssesed, PaymentPaid, PaymentWaived, DueDate, OrderStatus)
        VALUES (@CustomerID, GETDATE(), @PriceWhole, 
                CASE WHEN @PriceWhole < @Balance THEN @PriceWhole ELSE @Balance END, 0,@duedate,
                'Ordered');

        -- Get the OrderID of the newly created order
        DECLARE @NewOrderID INT;
        SET @NewOrderID = SCOPE_IDENTITY();

        -- Update the balance
        UPDATE Customers
        SET Balance = Balance - CASE WHEN @PriceWhole < @Balance THEN @PriceWhole ELSE @Balance END
        WHERE CustomerID = @CustomerID;

        -- Add OrderDetails for the service
        INSERT INTO Order_details (OrderID, ServiceID, UnitPrice)
        VALUES (@NewOrderID, @ServiceID, @PriceWhole);

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