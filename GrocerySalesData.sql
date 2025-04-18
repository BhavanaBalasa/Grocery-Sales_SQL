CREATE DATABASE GrocerySalesData;

USE GrocerySalesData;

CREATE TABLE categories(
CategoryID INT PRIMARY KEY,
CategoryName VARCHAR(45)
);

SELECT * FROM categories;

CREATE TABLE country(
CountryID INT PRIMARY KEY,
CountryName VARCHAR(45),
CountryCode VARCHAR(2)
);

SELECT * FROM country;

CREATE TABLE cities(
CityID	INT PRIMARY KEY,
CityName	VARCHAR(45),
Zipcode	DECIMAL(5,0),
CountryID	INT,
FOREIGN KEY(CountryID) REFERENCES country(CountryID)
);

SELECT * FROM cities;

CREATE TABLE customer(
CustomerID	INT PRIMARY KEY,
FirstName	VARCHAR(45),
MiddleInitial	VARCHAR(1),
LastName	VARCHAR(45),
cityID	INT,
Address	VARCHAR(90),
FOREIGN KEY(cityID) REFERENCES cities(cityID)
);

SELECT * FROM customer;


CREATE TABLE employees(
EmployeeID	INT PRIMARY KEY,
FirstName	VARCHAR(45),
MiddleInitial	VARCHAR(1),
LastName	VARCHAR(45),
BirthDate	DATE,
Gender	VARCHAR(10),
CityID	INT,
HireDate	DATE,
FOREIGN KEY(cityID) REFERENCES cities(cityID)
);

SELECT * FROM employees;

CREATE TABLE products(
ProductID	INT PRIMARY KEY,
ProductName	VARCHAR(45),
Price	DECIMAL(4,0),
CategoryID	INT,
Class	VARCHAR(15),
ModifyDate	DATE,
Resistant	VARCHAR(15),
IsAllergic	VARCHAR(15),
VitalityDays	DECIMAL(3,0),
FOREIGN KEY(CategoryID) REFERENCES categories(CategoryID)
);

SELECT * FROM products;

ALTER TABLE products
ADD CONSTRAINT FOREIGN KEY(CategoryID) REFERENCES categories(CategoryID);

DROP TABLE sales;

CREATE TABLE sales(
SalesID INT PRIMARY KEY,
SalesPersonID INT,
CustomerID INT,
ProductID INT,
Quantity INT,
Discount DECIMAL(10,2),
TotalPrice DECIMAL(10,2),
SalesDate DATETIME,
TransactionNumber VARCHAR(25),
FOREIGN KEY(SalesPersonID) REFERENCES employees(EmployeeID),
FOREIGN KEY(CustomerID) REFERENCES customer(CustomerID),
FOREIGN KEY(ProductID) REFERENCES products(ProductID)
);

SELECT * FROM sales;

SET GLOBAL max_allowed_packet=1073741824;

-- Bussiness Questions
-- 1. Calculate total sales for each month.

SELECT EXTRACT(MONTH FROM SalesDate) Month, CONCAT(ROUND(SUM((products.price*Quantity)-((products.price*Quantity)*Discount))/ 1000000,2),' M') TotalSales
FROM sales
INNER JOIN products on sales.ProductID=products.ProductID
GROUP BY Month
ORDER BY Month;

-- 2. Compare sales performance across different product categories each month.
SELECT EXTRACT(MONTH FROM SalesDate) Month , CategoryName, CONCAT(ROUND(SUM((products.price*Quantity)-((products.price*Quantity)*Discount))/ 1000000,2),' M') TotalSales
FROM sales
INNER JOIN products on sales.ProductID=products.ProductID
INNER JOIN categories ON products.CategoryID=categories.CategoryID
GROUP BY Month, CategoryName
ORDER BY Month;

-- 3. Rank products based on total sales revenue.
SELECT *,  RANK() OVER(ORDER BY TotalSales DESC) Rnakno
FROM(
SELECT products.ProductName, CONCAT(ROUND(SUM((products.price*Quantity)-((products.price*Quantity)*Discount))/ 100000,2),' K') TotalSales
FROM sales
INNER JOIN products on sales.ProductID=products.ProductID
GROUP BY products.ProductName) PRSALES;

-- 4. Analyze sales quantity and revenue to identify high-demand products.
WITH REVENUE AS(
SELECT products.ProductName PRODUCT ,CONCAT(ROUND(SUM((products.price*Quantity)-((products.price*Quantity)*Discount))/ 100000,2),' K') TotalSales
FROM sales
INNER JOIN products on sales.ProductID=products.ProductID
GROUP BY products.ProductName),
Quantityno AS(
SELECT products.ProductName PRODUCT, SUM(Quantity) TotalQuantity
FROM sales
INNER JOIN products on sales.ProductID=products.ProductID
GROUP BY products.ProductName)
SELECT REVENUE.Product,TotalSales,Quantityno.TotalQuantity
FROM REVENUE
INNER JOIN Quantityno ON REVENUE.Product=Quantityno.Product
ORDER BY Product;

-- 5. Examine the impact of product classifications on sales performance.

SELECT  CategoryName, CONCAT(ROUND(SUM((products.price*Quantity)-((products.price*Quantity)*Discount))/ 1000000,2),' M') TotalSales
FROM sales
INNER JOIN products on sales.ProductID=products.ProductID
INNER JOIN categories ON products.CategoryID=categories.CategoryID
GROUP BY  CategoryName;


-- 6. Segment customers based on their purchase frequency and total spend.
SELECT CONCAT(FirstName,' ',LastName) CustomerName, COUNT(sales.SalesID) PurchaseFrequency
FROM customer
INNER JOIN sales ON customer.CustomerID=sales.CustomerID
GROUP BY CustomerName
ORDER BY PurchaseFrequency DESC
LIMIT 5;

SELECT CONCAT(FirstName,' ',LastName) CustomerName, SUM((products.price*Quantity)-((products.price*Quantity)*Discount)) PurchaseFrequency
FROM customer
INNER JOIN sales ON customer.CustomerID=sales.CustomerID
INNER JOIN products on sales.ProductID=products.ProductID
GROUP BY CustomerName
ORDER BY PurchaseFrequency DESC
LIMIT 5;

-- 7. Identify repeat customers versus one-time buyers.

SELECT CustomerType, COUNT(CustomerID) Customercount
FROM(
SELECT customer.CustomerID, COUNT(SalesID),
CASE WHEN COUNT(SalesID)=1 THEN "one-time buyer"
ELSE "repeat customer"
END AS CustomerType
FROM customer
INNER JOIN sales ON customer.CustomerID=sales.CustomerID
GROUP BY customer.CustomerID) AS CustomerSegment
GROUP BY CustomerType;

-- 8. Analyze average order value and basket size.
/* AOV= Total Revenue/Total Orders
Basket Size= Total Items Sold/Total Orders */

SELECT SUM((products.price*Quantity)-((products.price*Quantity)*Discount))/COUNT(SalesID) AOV, SUM(Quantity)/COUNT(SalesID) BasketSize
FROM sales
INNER JOIN products ON sales.ProductID=products.ProductID;

-- 9. Calculate total sales attributed to each salesperson.
SELECT EmployeeID, CONCAT(FirstName,' ',LastName) EmployeeName, ROUND(SUM((sales.Quantity*products.Price)-(sales.Quantity*products.Price)*Sales.Discount)/1000000,2) `TotalSales(M)`
FROM employees
INNER JOIN sales ON sales.SalesPersonID=employees.EmployeeID
INNER JOIN products ON products.ProductID=sales.ProductID
GROUP BY EmployeeID;

-- 10. Identify top-performing and underperforming sales staff.

WITH SalesPS AS(
SELECT EmployeeID, CONCAT(FirstName,' ',LastName) EmployeeName, SUM((sales.Quantity*products.Price)-(sales.Quantity*products.Price)*Sales.Discount) TotalSales
FROM employees
INNER JOIN sales ON sales.SalesPersonID=employees.EmployeeID
INNER JOIN products ON products.ProductID=sales.ProductID
GROUP BY EmployeeID),
SalesPersonPercentage AS(
SELECT EmployeeID,EmployeeName,TotalSales, PERCENT_RANK() OVER(ORDER BY TotalSales) SalesPercentage
FROM SalesPS),
SalesPersonPerfomance AS(
SELECT EmployeeID,EmployeeName,TotalSales,
CASE WHEN SalesPercentage>=0.8 THEN "top-performing"
     WHEN SalesPercentage<=0.2 THEN "underperforming"
     ELSE "averageperformance"
END AS PerformanceCategory
FROM SalesPersonPercentage)
SELECT * FROM SalesPersonPerfomance
WHERE PerformanceCategory='top-performing' OR PerformanceCategory='underperforming';


-- 11. Analyze sales trends based on individual salesperson contributions over time.
SELECT EmployeeID, CONCAT(FirstName,' ',LastName) EmployeeName, MONTH(sales.SalesDate) Month, ROUND(SUM((sales.Quantity*products.Price)-(sales.Quantity*products.Price)*Sales.Discount)/1000000,2) `TotalSales(M)`
FROM employees
INNER JOIN sales ON sales.SalesPersonID=employees.EmployeeID
INNER JOIN products ON products.ProductID=sales.ProductID
GROUP BY EmployeeID,EmployeeName,Month
ORDER BY Month;

-- 12. Map sales data to specific cities and countries to identify high-performing regions.
SELECT CountryName, CityName , ROUND(SUM((sales.Quantity*products.Price)-(sales.Quantity*products.Price)*Sales.Discount)/1000000,2) `TotalSales(M)`
FROM cities
INNER JOIN country ON country.CountryID=cities.CountryID
INNER JOIN customer ON customer.cityID=cities.cityID
INNER JOIN sales ON customer.CustomerID=sales.CustomerID
INNER JOIN products ON products.ProductID=sales.ProductID
GROUP BY CountryName, CityName
ORDER BY `TotalSales(M)` DESC
LIMIT 5;

-- 13. Compare sales volumes between various geographical areas.
SELECT CountryName, CityName , SUM(sales.quantity) TotalVolume
FROM cities
INNER JOIN country ON country.CountryID=cities.CountryID
INNER JOIN customer ON customer.cityID=cities.cityID
INNER JOIN sales ON customer.CustomerID=sales.CustomerID
GROUP BY CountryName, CityName
ORDER BY TotalVolume DESC

