-- DAY 3 
-- 1)	Show customer number, customer name, state and credit limit from customers table for below conditions. Sort the results by highest to lowest values of creditLimit.
-- ●	State should not contain null values-- ●	credit limit should be between 50000 and 100000

SELECT customerNumber, customerName, state, creditLimit
FROM customers

WHERE state IS NOT NULL
  AND creditLimit BETWEEN 50000 AND 100000
ORDER BY creditLimit DESC;
  
-- 2)	Show the unique productline values containing the word cars at the end from products table.-- 

SELECT DISTINCT productLine
FROM products
WHERE productLine LIKE '%cars';

-- DAY 4 
-- 1)	Show the orderNumber, status and comments from orders table for shipped status only. If some comments are having null values then show them as “-“.

SELECT orderNumber, status, IFNULL(comments, '-') AS comments
FROM orders
WHERE status = 'Shipped';

-- 2)	Select employee number, first name, job title and job title abbreviation from employees table based on following conditions.
-- If job title is one among the below conditions, then job title abbreviation column should show below forms.
-- ●	President then “P”-- ●	Sales Manager / Sale Manager then “SM”-- ●	Sales Rep then “SR”-- ●	Containing VP word then “VP”

SELECT employeeNumber, firstName, jobTitle,
  CASE
    WHEN jobTitle = 'President' THEN 'P'
    WHEN jobTitle = 'Sales Manager (APAC)' OR jobTitle = 'Sale Manager (EMEA)' OR jobTitle ='Sales Manager (NA)' THEN 'SM'
    WHEN jobTitle = 'Sales Rep' THEN 'SR'
    WHEN jobTitle LIKE '%VP%' THEN 'VP'
  END AS jobTitleAbbreviation
FROM employees;

-- DAY 5
-- 1)	For every year, find the minimum amount value from payments table.

SELECT YEAR(paymentDate) AS paymentYear, MIN(amount) AS minAmount
FROM payments
GROUP BY YEAR(paymentDate)
ORDER BY paymentYear;


-- 2)	For every year and every quarter, find the unique customers and total orders from orders table. Make sure to show the quarter as Q1,Q2 etc.

SELECT YEAR(orderDate) AS orderYear,
       CONCAT('Q', QUARTER(orderDate)) AS orderQuarter,
       COUNT(DISTINCT customerNumber) AS uniqueCustomers,
       COUNT(*) AS totalOrders
FROM orders
GROUP BY YEAR(orderDate), QUARTER(orderDate)
ORDER BY orderYear, orderQuarter;

-- 3)	Show the formatted amount in thousands unit (e.g. 500K, 465K etc.) for every month (e.g. Jan, Feb etc.) 
-- with filter on total amount as 500000 to 1000000. Sort the output by total amount in descending mode. [ Refer. Payments Table]

SELECT DATE_FORMAT(paymentDate, '%b') AS paymentMonth,
       CONCAT(FORMAT(SUM(amount) / 1000, 0), 'K') AS formattedAmount
FROM payments
GROUP BY DATE_FORMAT(paymentDate, '%b')
HAVING SUM(amount) BETWEEN 500000 AND 1000000
ORDER BY SUM(amount) DESC;

-- Day 6:
-- 1)	Create a journey table with following fields and constraints.

CREATE TABLE journey (
  Bus_ID INT NOT NULL,
  Bus_Name VARCHAR(100) NOT NULL,
  Source_Station VARCHAR(100) NOT NULL,
  Destination VARCHAR(100) NOT NULL,
  Email VARCHAR(100) NOT NULL,
  CONSTRAINT PK_journey PRIMARY KEY (Bus_ID),
  CONSTRAINT CHK_Email UNIQUE (Email)
);

-- DROP TABLE IF EXISTS journey  ;

-- 2)	Create vendor table with following fields and constraints.

CREATE TABLE vendor (
  Vendor_ID INT NOT NULL,
  Name VARCHAR(100) NOT NULL,
  Email VARCHAR(100) NOT NULL,
  Country VARCHAR(100) DEFAULT 'N/A',
  CONSTRAINT PK_vendor PRIMARY KEY (Vendor_ID),
  CONSTRAINT CHK_Email UNIQUE (Email)
);

-- DROP TABLE IF EXISTS vendor  ;

-- 3)Create movies table with following fields and constraints.

CREATE TABLE movies (
  Movie_ID INT NOT NULL,
  Name VARCHAR(100) NOT NULL,
  Release_Year VARCHAR(10) DEFAULT '-',
  Cast VARCHAR(100) NOT NULL,
  Gender ENUM('Male', 'Female') NOT NULL,
  No_of_shows INT UNSIGNED NOT NULL CHECK (No_of_shows > 0),
  CONSTRAINT PK_movies PRIMARY KEY (Movie_ID)
);

-- DROP TABLE IF EXISTS movies  ;

-- 4)	Create the following tables. Use auto increment wherever applicable
-- a) Product

CREATE TABLE Product (
  product_id INT PRIMARY KEY AUTO_INCREMENT,
  product_name VARCHAR(100) NOT NULL UNIQUE,
  description VARCHAR(255),
  supplier_id INT,
  FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);
-- DROP TABLE IF EXISTS product  ;

-- b) Suppliers
CREATE TABLE Suppliers (
  supplier_id INT PRIMARY KEY AUTO_INCREMENT,
  supplier_name VARCHAR(100),
  location VARCHAR(100)
);
-- DROP TABLE IF EXISTS suppliers  ;

-- c) Stock
CREATE TABLE Stock (
  id INT PRIMARY KEY AUTO_INCREMENT,
  product_id INT,
  balance_stock INT,
  FOREIGN KEY (product_id) REFERENCES Product(product_id)
);
-- DROP TABLE IF EXISTS stock  ;

-- Day 7
-- 1)	Show employee number, Sales Person (combination of first and last names of employees), unique customers -- for each employee number and sort the data by highest to lowest unique customers.
-- Tables: Employees, Customers

SELECT
    e.employeeNumber,
    CONCAT(e.firstName, ' ', e.lastName) AS SalesPerson,
    COUNT(DISTINCT c.customerNumber) AS UniqueCustomers
FROM
    Employees e
JOIN
    Customers c ON e.employeeNumber = c.salesRepEmployeeNumber
GROUP BY
    e.employeeNumber, SalesPerson
ORDER BY
    UniqueCustomers DESC;

-- 2)	Show total quantities, total quantities in stock, left over quantities for each product and each customer. Sort the data by customer number.
-- Tables: Customers, Orders, Orderdetails, Products

SELECT
    c.customerNumber,
    c.customerName,
    p.productCode,
    SUM(od.quantityOrdered) AS TotalQuantities,
    SUM(p.quantityInStock) AS TotalQuantitiesInStock,
    SUM(p.quantityInStock) - SUM(od.quantityOrdered) AS LeftoverQuantities
FROM
    Customers c
JOIN
    Orders o ON c.customerNumber = o.customerNumber
JOIN
    Orderdetails od ON o.orderNumber = od.orderNumber
JOIN
    Products p ON od.productCode = p.productCode
GROUP BY
    c.customerNumber, c.customerName, p.productCode
ORDER BY
    c.customerNumber;


-- 3)	Create below tables and fields. (You can add the data as per your wish)
-- ●	Laptop: (Laptop_Name)-- ●	Colours: (Colour_Name)
-- Perform cross join between the two tables and find number of rows.

CREATE TABLE Laptop (
  Laptop_Name VARCHAR(100)
);

CREATE TABLE Colours (
  Colour_Name VARCHAR(100)
);

INSERT INTO Laptop (Laptop_Name)
VALUES ('DELL'), ('HP'), ('MI ');

INSERT INTO Colours (Colour_Name)
VALUES ('Red'), ('Blue'), ('Black');

-- DROP TABLE IF EXISTS Laptop  ;
-- DROP TABLE IF EXISTS colours  ;

SELECT l.Laptop_Name, c.Colour_Name
FROM Laptop l
CROSS JOIN Colours c;

-- 4)	Create table project with below fields.
-- ●	EmployeeID-- ●	FullName		-- ●	Gender-- ●	ManagerID

CREATE TABLE Project (
  EmployeeID INT,
  FullName VARCHAR(100),
  Gender VARCHAR(10),
  ManagerID INT
);

-- DROP TABLE IF EXISTS Project  ;

INSERT INTO Project (EmployeeID, FullName, Gender, ManagerID) VALUES
(1, 'Pranaya', 'Male', 3),
(2, 'Priyanka', 'Female', 1),
(3, 'Preety', 'Female', NULL),
(4, 'Anurag', 'Male', 1),
(5, 'Sambit', 'Male', 1),
(6, 'Rajesh', 'Male', 3),
(7, 'Hina', 'Female', 3);

SELECT 
    mgr.FullName AS Manager,
	emp.FullName AS Employee
        
FROM 
    Project AS emp
LEFT JOIN 
    Project AS mgr ON emp.ManagerID = mgr.EmployeeID;
    
-- DAY 8
-- Create table facility. Add the below fields into it.
-- ●	Facility_ID,Name,State,Country

CREATE TABLE facility (
  Facility_ID INT,
  Name VARCHAR(100),
  State VARCHAR(100),
  Country VARCHAR(100)
);

-- DROP TABLE IF EXISTS facility  ;

-- 1)Alter the table by adding the primary key and auto increment to Facility_ID column.

ALTER TABLE facility
MODIFY COLUMN Facility_ID INT AUTO_INCREMENT;

-- ii) Add a new column city after name with data type as varchar which should not accept any null values.

ALTER TABLE facility
ADD COLUMN City VARCHAR(100) NOT NULL AFTER Name;

DESCRIBE facility;

-- DAY 9
-- Create table university with below fields.
-- ●	ID,●	Name

CREATE TABLE university (
  ID INT,
  Name VARCHAR(100)
);

-- DROP TABLE IF EXISTS university  ;

INSERT INTO university (ID, Name)
VALUES
(1, 'Pune University'),
(2, 'Mumbai University'),
(3, 'Delhi University'),
(4, 'Madras University'),
(5, 'Nagpur University');

UPDATE university
SET Name = TRIM(Name);

SELECT * FROM University;


-- Day 10
-- Create the view products status. Show year wise total products sold. Also find the percentage of total value for each year. The output should look as shown in below figure.

CREATE VIEW products_status AS

SELECT
    Year,
    Value,
    CONCAT(ROUND((Value * 100.0) / TotalValue), '%') AS PercentageOfTotalValue
FROM
    (SELECT
        YEAR(o.orderDate) AS Year,
        COUNT(*) AS Value,
        SUM(COUNT(*)) OVER () AS TotalValue
    FROM
        orders o
    JOIN
        orderdetails od ON o.orderNumber = od.orderNumber
    GROUP BY
        YEAR(o.orderDate)) t
ORDER BY
    Value DESC;


-- Day 11
-- 1)Create a stored procedure GetCustomerLevel which takes input as customer number and gives the output as either Platinum, Gold or Silver as per below criteria.
-- Table: Customers-- ●	Platinum: creditLimit > 100000-- ●	Gold: creditLimit is between 25000 to 100000-- ●Silver: creditLimit < 25000

DELIMITER //

CREATE PROCEDURE GetCustomerLevel(IN p_customerNumber INT, OUT p_customerLevel VARCHAR(10))
BEGIN
    DECLARE v_creditLimit DECIMAL(10, 2);
    
    SELECT creditLimit INTO v_creditLimit
    FROM Customers
    WHERE customerNumber = p_customerNumber;
    
    IF v_creditLimit > 100000 THEN
        SET p_customerLevel = 'Platinum';
    ELSEIF v_creditLimit >= 25000 AND v_creditLimit <= 100000 THEN
        SET p_customerLevel = 'Gold';
    ELSE
        SET p_customerLevel = 'Silver';
    END IF;
END //

DELIMITER ;

CALL GetCustomerLevel(475, @level);
SELECT @level;


-- 2)	Create a stored procedure Get_country_payments which takes in year and country as inputs and gives year wise,
--  country wise total amount as an output. Format the total amount to nearest thousand unit (K)
-- Tables: Customers, Payments

DELIMITER //

CREATE PROCEDURE Get_country_payments(IN p_year INT, IN p_country VARCHAR(50), OUT p_totalAmount VARCHAR(20))
BEGIN
    SELECT 
        p_year AS Year,
        p_country AS Country,
        CONCAT(FORMAT(SUM(p.amount) / 1000, 0), 'K') INTO p_totalAmount
    FROM
        Payments p
    JOIN
        Customers c ON p.customerNumber = c.customerNumber
    WHERE
        YEAR(p.paymentDate) = p_year
        AND c.country = p_country;
END //

DELIMITER ;

CALL Get_country_payments(2003, 'France', @totalAmount);
SELECT 2003 AS Year, 'France' AS Country, @totalAmount AS TotalAmount;

-- Day 12
-- 1)	Calculate year wise, month name wise count of orders and year over year (YoY) percentage change. Format the YoY values in no decimals and show in % sign.
-- Table: Orders


SELECT
  curr.year AS Year,
  MONTHNAME(DATE_ADD(DATE_FORMAT('2003-01-01', '%Y-%m-%d'), INTERVAL curr.month - 1 MONTH)) AS Month,
  IFNULL(curr.order_count, 0) AS `Total Orders`,
  IFNULL(
    CONCAT(
      IF(ROUND(((curr.order_count - IFNULL(prev.order_count, 0)) / NULLIF(IFNULL(prev.order_count, 0), 0)) * 100, 0) >= 0, '+', '-'),
      ABS(ROUND(((curr.order_count - IFNULL(prev.order_count, 0)) / NULLIF(IFNULL(prev.order_count, 0), 0)) * 100, 0)),
      '%'
    ),
    'N/A'
  ) AS `% YoY Change`
FROM
  (SELECT
    YEAR(orderDate) AS year,
    MONTH(orderDate) AS month,
    COUNT(*) AS order_count
  FROM orders
  WHERE YEAR(orderDate) >= 2003 AND YEAR(orderDate) <= 2005
  GROUP BY YEAR(orderDate), MONTH(orderDate)) AS curr
LEFT JOIN
  (SELECT
    YEAR(orderDate) AS year,
    MONTH(orderDate) AS month,
    COUNT(*) AS order_count
  FROM orders
  WHERE YEAR(orderDate) >= 2002 AND YEAR(orderDate) <= 2004
  GROUP BY MONTH(orderDate)) AS prev
ON curr.month = prev.month AND curr.year = prev.year + 1
ORDER BY curr.year, curr.month;


-- 2)	Create the table emp_udf with below fields.
-- ●	Emp_ID-- ●	Name-- ●	DOB

  CREATE TABLE emp_udf (
  Emp_ID INT,
  Name VARCHAR(100),
  DOB DATE
);

INSERT INTO emp_udf (Name, DOB)
VALUES ('Piyush', '1990-03-30'), ('Aman', '1992-08-15'), ('Meena', '1998-07-28'), ('Ketan', '2000-11-21'), ('Sanjay', '1995-05-21');

DELIMITER //
CREATE FUNCTION calculate_age(DOB DATE)
RETURNS VARCHAR(100)
DETERMINISTIC
NO SQL
BEGIN
    DECLARE age_years INT;
    DECLARE age_months INT;
    DECLARE age VARCHAR(100);
    
    SET age_years = TIMESTAMPDIFF(YEAR, DOB, CURDATE());
    SET age_months = TIMESTAMPDIFF(MONTH, DOB, CURDATE()) % 12;
    
    SET age = CONCAT(age_years, ' years ', age_months, ' months');
    
    RETURN age;
END //
DELIMITER ;

UPDATE Emp_UDF
SET Age = calculate_age(DOB);

SELECT Emp_ID, Name, DOB, Age
FROM Emp_UDF;

-- DAY 13
-- 1)	Display the customer numbers and customer names from customers table who have not placed any orders using subquery
-- Table: Customers, Orders

SELECT customerNumber, customerName
FROM Customers
WHERE customerNumber NOT IN (
    SELECT customerNumber
    FROM Orders
)

-- 2)	Write a full outer join between customers and orders using union and get the customer number, customer name, count of orders for every customer.
-- Table: Customers, Orders

SELECT c.customerNumber, c.customerName, COUNT(o.orderNumber) AS orderCount
FROM Customers c
LEFT JOIN Orders o ON c.customerNumber = o.customerNumber
GROUP BY c.customerNumber, c.customerName
UNION
SELECT c.customerNumber, c.customerName, COUNT(o.orderNumber) AS orderCount
FROM Customers c
RIGHT JOIN Orders o ON c.customerNumber = o.customerNumber
GROUP BY c.customerNumber, c.customerName

-- 3)	Show the second highest quantity ordered value for each order number.
-- Table: Orderdetails

SELECT orderNumber, MAX(quantityOrdered) AS HighestQuantity
FROM Orderdetails
WHERE quantityOrdered < (
    SELECT MAX(quantityOrdered)
    FROM Orderdetails
)
GROUP BY orderNumber

-- 4)	For each order number count the number of products and then find the min and max of the values among count of orders.
-- Table: Orderdetails

SELECT MAX(Total) AS MaxTotal, MIN(Total) AS MinTotal
FROM (
    SELECT orderNumber, COUNT(*) AS Total
    FROM Orderdetails
    GROUP BY orderNumber
) AS Counts


-- 5)	Find out how many product lines are there for which the buy price value is greater than the average of buy price value. Show the output as product line and its count.

SELECT productLine, COUNT(*) AS Count
FROM products
WHERE buyPrice > (SELECT AVG(buyPrice) FROM products)
GROUP BY productLine


-- Day 14
-- Create the table Emp_EH. Below are its fields.-- ●	EmpID (Primary Key)-- ●	EmpName-- ●	EmailAddress
-- Create a procedure to accept the values for the columns in Emp_EH. Handle the error using exception handling concept. 
-- Show the message as “Error occurred” in case of anything wrong.

CREATE TABLE Emp_EH (
  EmpID INT PRIMARY KEY,
  EmpName VARCHAR(100),
  EmailAddress VARCHAR(100)
);

DELIMITER //
CREATE PROCEDURE Insert_Emp_EH(
  IN p_EmpID INT,
  IN p_EmpName VARCHAR(100),
  IN p_EmailAddress VARCHAR(100)
)
BEGIN
  DECLARE error_occurred BOOLEAN DEFAULT FALSE;

  -- Exception handling block
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
  BEGIN
    SET error_occurred = TRUE;
    SHOW ERRORS;
  END;

  -- Insert values into Emp_EH table
  INSERT INTO Emp_EH (EmpID, EmpName, EmailAddress)
  VALUES (p_EmpID, p_EmpName, p_EmailAddress);

  IF error_occurred THEN
    SELECT 'Error occurred' AS Message;
  ELSE
    SELECT 'Values inserted successfully' AS Message;
  END IF;
END//
DELIMITER ;

CALL Insert_Emp_EH(1, 'ranjithkumar l', 'ranjithkumar@example.com');

-- Day 15
-- Create the table Emp_BIT. Add below fields in it.
-- ●Name-- ●Occupation-- ●Working_date-- ●Working_hours 
-- Create before insert trigger to make sure any new value of Working_hours, if it is negative, then it should be inserted as positive.

CREATE TABLE Emp_BIT (
  Name VARCHAR(100),
  Occupation VARCHAR(100),
  Working_date DATE,
  Working_hours INT
);

INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11); 

DELIMITER //

CREATE TRIGGER Before_Insert_Emp_BIT
BEFORE INSERT ON Emp_BIT
FOR EACH ROW
BEGIN
  IF NEW.Working_hours < 0 THEN
    SET NEW.Working_hours = -NEW.Working_hours;
  END IF;
END //

DELIMITER ;

SELECT * FROM Emp_BIT;
