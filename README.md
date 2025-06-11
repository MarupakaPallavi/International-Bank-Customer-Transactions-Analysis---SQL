# International-Bank-Customer-Transactions-Analysis---SQL

As a  database developer of an international bank. we are responsible for managing the bank’s database. We  want to use the data to answer a few questions about your customers regarding withdrawal, deposit and so on, especially about the transaction amount on a particular date across various regions of the world.
The project is about performing  SQL queries to get the key insights of a customer


## Data Set 

The 3 key datasets for this case study are:

a. Continent: The Continent table has two attributes i.e., region_id and region_name, where region_name consists of different continents such as Asia, Europe, Africa etc., assigned with the unique region id.

b. Customers: The Customers table has four attributes named customer_id, region_id, start_date and end_date which consists of 3500 records.

c. Transaction: Finally, the Transaction table contains around 5850 records and has four attributes named customer_id, txn_date, txn_type and txn_amount.


## Analysis Questions 

1. Display the count of customers in each region who have done the
transaction in the year 2020.

2. Display the maximum and minimum transaction amount of each
transaction type.

3. Display the customer id, region name and transaction amount where transaction type is deposit and transaction amount > 2000.

4. Find duplicate records in the Customer table.

5. Display the customer id, region name, transaction type and transaction amount for the minimum transaction amount in deposit.

6. Create a stored procedure to display details of customers in the
Transaction table where the transaction date is greater than Jun 2020.

7. Create a stored procedure to insert a record in the Continent table.

8. Create a stored procedure to display the details of transactions that happened on a specific day.

9. Create a user defined function to add 10% of the transaction amount in a table.

10. Create a user defined function to find the total transaction amount for a given transaction type.

11. Create a table value function which comprises the columns customer_id, region_id ,txn_date , txn_type , txn_amount which will retrieve data from the above table.

12. Create a TRY...CATCH block to print a region id and region name in a single column.

13. Create a TRY...CATCH block to insert a value in the Continent table.

14. Create a trigger to prevent deleting a table in a database.

15. Create a trigger to audit the data in a table.

16. Create a trigger to prevent login of the same user id in multiple pages.

17. Display top n customers on the basis of transaction type.

18. Create a pivot table to display the total purchase, withdrawal and deposit for all the customers.
