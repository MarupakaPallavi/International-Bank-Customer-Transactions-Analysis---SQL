use assignments

select * from continent

select * from customers

select * from  Transactions

---1. Display the count of customers in each region who have done the
---transaction in the year 2020

SELECT c.region_id, COUNT(DISTINCT c.customer_id) AS customer_count
FROM Customers c
JOIN Transactions t ON c.customer_id = t.customer_id
WHERE YEAR(t.txn_date) = 2020
GROUP BY c.region_id;


--2. Display the maximum and minimum transaction amount of each
--transaction type.

SELECT txn_type, MAX(txn_amount) AS max_amount, MIN(txn_amount) AS min_amount
FROM Transactions
GROUP BY txn_type;

--3. Display the customer id, region name and transaction amount where
--transaction type is deposit and transaction amount > 2000.


SELECT c.customer_id, cn.region_name, t.txn_amount
FROM Customers c
JOIN Continent cn ON c.region_id = cn.region_id
JOIN Transactions t ON c.customer_id = t.customer_id
WHERE t.txn_type = 'deposit' AND t.txn_amount > 2000;

--4. Find duplicate records in the Customer table
SELECT customer_id, COUNT(*)
FROM Customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

--5. Display the customer id, region name, transaction type and transaction
--amount for the minimum transaction amount in deposit.

SELECT c.customer_id, cn.region_name, t.txn_type, t.txn_amount
FROM Customers c
JOIN Continent cn ON c.region_id = cn.region_id
JOIN Transactions t ON c.customer_id = t.customer_id
WHERE t.txn_type = 'deposit' AND t.txn_amount = (SELECT MIN(txn_amount) 
FROM Transactions 
WHERE txn_type = 'deposit');


--6. Create a stored procedure to display details of customers in the
--Transaction table where the transaction date is greater than Jun 2020.


CREATE PROCEDURE GetTransactionsAfterJune2020s
AS
BEGIN
    SELECT *
    FROM Transactions
    WHERE txn_date > '2020-06-01'
END;

exec GetTransactionsAfterJune2020s

--7. Create a stored procedure to insert a record in the Continent table.

CREATE PROCEDURE InsertContinentRecordss
    @region_id INT,
    @region_name VARCHAR(255)
AS
BEGIN
    INSERT INTO Continent (region_id, region_name)
    VALUES (@region_id, @region_name);
END;

exec InsertContinentRecordss @region_id = 14, @region_name = "warangal"
select * from continent where region_id = 14

--8. Create a stored procedure to display the details of transactions that
--happened on a specific day

CREATE PROCEDURE GetTransactionsByDate
    @specific_date DATE
AS
BEGIN
    SELECT *
    FROM Transactions
    WHERE txn_date = @specific_date;
END;

exec GetTransactionsByDate @specific_date = '2020-01-21'

--9. Create a user defined function to add 10% of the transaction amount in a
--table.

CREATE FUNCTION AddTenPercent()
RETURNS table
AS
RETURN 
(select*, (txn_amount +(txn_amount * 10)/100)as newtransactionamount from Transactions);

select * from dbo.AddTenPercent()


--10. Create a user defined function to find the total transaction amount for a
--given transaction type.

CREATE FUNCTION total_transaction_amount(@value varchar(20))
RETURNS table
AS
RETURN 
(select txn_type , sum(txn_amount) as total_transaction_amt from Transactions  where txn_type = @value group by txn_type);

select  * from total_transaction_amount('deposit')

select * from Transactions order by customer_id

--or

CREATE FUNCTION dbo.GetTotalTransactionAmounts
(
    @txn_type VARCHAR(50)
)
RETURNS DECIMAL(18, 2)
AS
BEGIN
    DECLARE @totalAmount DECIMAL(18, 2);
    
    SELECT @totalAmount = SUM(txn_amount)
    FROM Transactions
    WHERE txn_type = @txn_type
	group by txn_type;

    RETURN ISNULL(@totalAmount, 0);
END;

select dbo.GetTotalTransactionAmounts('deposit') from Transactions

--11. Create a table value function which comprises the columns customer_id,
--region_id ,txn_date , txn_type , txn_amount which will retrieve data from
--the above table.

CREATE FUNCTION dbo.GetTransactionDetails()
RETURNS TABLE
AS
RETURN
(
    SELECT c.customer_id, c.region_id, t.txn_date, t.txn_type, t.txn_amount
    FROM Customers c
    JOIN Transactions t ON c.customer_id = t.customer_id
);


select * from  dbo.GetTransactionDetails() 

--12. Create a TRY...CATCH block to print a region id and region name in a
--single column.BEGIN TRY
   
    SELECT (region_id+''+region_name) as id_name
    FROM Continent;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

-- 13. Create a TRY...CATCH block to insert a value in the Continent table

BEGIN TRY
    
    INSERT INTO Continent (region_id, region_name)
    VALUES (1, 'Test Region');
    PRINT 'Value inserted successfully.';
END TRY
BEGIN CATCH
    PRINT 'Error occurred. Value not inserted.';
END CATCH;

-- 14. Create a trigger to prevent deleting a table in a database

CREATE TRIGGER PreventDeleteTable
ON ASSIGNMENTS 
FOR delete
AS
BEGIN
    RAISEERROR('Deleting tables is not allowed.', 16, 1);
    ROLLBACK;
END;

---15. Create a trigger to audit the data in a table.
CREATE TRIGGER AuditTransaction
ON Transactions
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    
    PRINT 'Audit record added for Transaction table.';
END;

--16. Create a trigger to prevent login of the same user id in multiple pages.
CREATE TRIGGER PreventMultipleLogins
ON LoginsTable
AFTER INSERT
AS
BEGIN
    IF (SELECT COUNT(*) FROM INSERTED) > 1
    BEGIN
        RAISEERROR('Multiple logins for the same user id not allowed.', 16, 1)
        ROLLBACK
    END
END;

--17.Display top n customers on the basis of transaction type
DECLARE @n INT = 5; 

SELECT TOP (@n) c.customer_id, c.region_id, t.txn_type, SUM(t.txn_amount) AS total_amount
FROM customers c
JOIN Transactions t ON c.customer_id = t.customer_id

GROUP BY c.customer_id, c.region_id, t.txn_type
ORDER BY total_amount DESC;

--18.Create a pivot table to display the total purchase, withdrawal, and deposit for all the customers
SELECT *
FROM (
    SELECT customer_id, txn_type, txn_amount
    FROM Transactions 
) AS SourceTable
PIVOT (
    SUM(txn_amount)
    FOR txn_type IN ([purchase], [withdrawal], [deposit])
) AS PivotTable;
