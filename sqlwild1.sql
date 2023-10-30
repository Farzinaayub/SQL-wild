SELECT * FROM CUSTOMERS ORDER BY CUSTOMERID DESC;
SELECT CUSTOMERID,FIRSTNAME,LASTNAME,EMAIL,CITY,COUNTRY
FROM CUSTOMERS
ORDER BY CUSTOMERID;
SELECT * FROM CUSTOMERS
WHERE PHONE LIKE '7%'
ORDER BY PHONE;
SELECT COUNT(*) AS GERMANCOUNT FROM CUSTOMERS
WHERE COUNTRY ='GERMANY';
SELECT COUNT(*) AS LASTNAMEJAMES FROM CUSTOMERS
WHERE LASTNAME = 'James';
SELECT * FROM CUSTOMERS
WHERE CUSTOMERID BETWEEN 57282 AND 57304;
-- The stakeholders wants to know on which number of transaction every customer did the maximum payment.
-- Print the Customer Id,First Name,Last Name,Order Id,Total Order Amount,Number of Transaction for each Customer.
-- For Customers with no Last Name give 'Doe' as Last Name.
-- if two or more transactions were done in a single day the lowest transaction will be considered as the first transaction of that day and highest will be considered as the last transaction of that day.
-- Sort the output in ascending order of customerid.
-- Note: if the maximum transaction done for a customer was on the 7th order then the number of transaction will be 7, but if two orders were placed on the same day of maximum transaction then the number of transaction will be 8.
WITH CTE AS(
SELECT CUSTOMERID,FIRSTNAME,COALESCE(LASTNAME,'Doe') AS LASTNAME, ORDERID,TOTAL_ORDER_AMOUNT,ROW_NUMBER()OVER(PARTITION BY CUSTOMERID ORDER BY ORDERDATE,TOTAL_ORDER_AMOUNT) AS TRANSACTION_NUMBER, DENSE_RANK() OVER (PARTITION BY CUSTOMERID ORDER BY TOTAL_ORDER_AMOUNT DESC) AS RNK
FROM CUSTOMERS
NATURAL JOIN ORDERS
ORDER BY CUSTOMERID,ORDERDATE)
SELECT CUSTOMERID,FIRSTNAME,LASTNAME, ORDERID,TOTAL_ORDER_AMOUNT,TRANSACTION_NUMBER
FROM CTE
WHERE RNK=1
ORDER BY CUSTOMERID;
-- Retrieve the Customer id, complete name (First Name followed by Last Name and single space between their First Name and Last Name, for Customers with no Last Name just keep their First Name) and Current Age of each customer.
-- Arrange the results in a descending order based on their age, for Customers with the same age sort in ascending order of Customer id.
-- Use timestampdiff and year for age calculation.
SELECT CUSTOMERID,CONCAT(FIRSTNAME," ",LASTNAME) AS NAME,TIMESTAMPDIFF(YEAR,DATE_OF_BIRTH,CURRENT_DATE) AS AGE
FROM CUSTOMERS
ORDER BY AGE DESC,CUSTOMERID;
-- Get the number of orders placed for each year in every week.
-- Print Week number ,Orders placed in 2020 and Orders placed in 2021
-- Sort the result in ascending order of week number.
SELECT WEEK(ORDERDATE) AS WEEK,SUM(CASE WHEN YEAR(ORDERDATE)=2020 THEN 1 ELSE 0 END)AS ORDERS2020,
SUM(CASE WHEN YEAR(ORDERDATE)=2021 THEN 1 ELSE 0 END) AS ORDERS2021
FROM ORDERS
GROUP BY WEEK
ORDER BY WEEK;
-- Print the details of different payment methods along with the total amount of money transacted through them in the years 2020 and 2021.
-- Print Payment Type, Allowed, Transaction value in 2020, Transaction value in 2021.
-- Order your output in alphabetical order of Payment Type. Include all payment types that exist in the database.
SELECT PAYMENTTYPE,ALLOWED,SUM(CASE WHEN YEAR(ORDERDATE)=2020 THEN TOTAL_ORDER_AMOUNT ELSE NULL END) AS 2020TRANSACTION,SUM(CASE WHEN YEAR(ORDERDATE)=2021 THEN TOTAL_ORDER_AMOUNT ELSE NULL END) AS 2021TRANSACTION 
FROM PAYMENTS P
LEFT JOIN ORDERS O ON O.PAYMENTID=P.PAYMENTID
 GROUP BY 1,2
 ORDER BY PAYMENTTYPE;

