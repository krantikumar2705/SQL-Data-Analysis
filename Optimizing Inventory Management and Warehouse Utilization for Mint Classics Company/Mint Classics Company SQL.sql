USE mintclassics;
SHOW TABLES;
DESCRIBE warehouses;
DESCRIBE products;



-- Investigate the Business Problem
-- SQL query to check inventory levels:
SELECT productCode, productName, quantityInStock, warehouseCode
FROM products;
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------Inventory Analysis -----------------------------------------------------------------
-- Total quantity stock in each warehouse
SELECT w.warehouseName, SUM(p.quantityInStock) quantityINstock FROM products AS p
INNER JOIN warehouses AS w ON w.warehouseCode = p.warehouseCode
GROUP BY w.warehouseName
ORDER BY quantityINstock DESC;

-- Are all the warehouses currently in use still necessary?
-- How can we review warehouses that have low or inactive inventory?
SELECT w.warehouseName, productName, SUM(quantityInStock)  stock FROM  products AS p
INNER JOIN warehouses AS w on w.warehouseCode = p.warehouseCode
GROUP BY  w.warehouseName, productName
ORDER BY stock desc;


SELECT productCode, productName, quantityInStock
FROM products
ORDER BY quantityInStock DESC
LIMIT 10; -- Highest inventory

SELECT productCode, productName, quantityInStock
FROM products
ORDER BY quantityInStock ASC
LIMIT 10; -- Lowest inventory


-- Total stock in each productline
SELECT  w.warehouseName, p.productline, SUM(p.quantityInStock) stock FROM products AS p
INNER JOIN warehouses AS w ON w.warehouseCode = p.warehouseCode
GROUP BY w.warehouseName, p.productline
ORDER BY stock DESC;

-- Total stock for each product
SELECT productName, quantityInStock FROM products
ORDER BY quantityInStock DESC;

-- ----------------------- ---------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------Product sale Analysis -----------------------------------------------------------------
--  Comparative data between Total Stock and Total Ordered
SELECT p.productName, p.quantityInStock, SUM(quantityOrdered) ordered, (p.quantityInstock - SUM(quantityOrdered)) CurrentInventory FROM products p
LEFT JOIN orderdetails od ON od.productCode = p.productCode
GROUP BY p.productName, p.quantityInStock
ORDER BY CurrentInventory DESC;

-- Sales trends
-- get total ordered by time
SELECT o.orderDate, 
		Total_ordered
					FROM orders o LEFT JOIN
		(SELECT od.orderNumber, SUM(quantityOrdered) Total_ordered FROM orderdetails od
		GROUP BY od.orderNumber) AS od
on od.orderNumber = o.orderNumber
ORDER BY orderDate;



-- Identify the most frequently sold items
SELECT od.productCode, productName, SUM(quantityOrdered) AS totalSold
FROM orderdetails od
INNER JOIN products p on p.productCode = od.productCode
GROUP BY productCode, productName
ORDER BY totalSold DESC
LIMIT 10; -- Top 10 selling products


-- how does the product price affect sales volume
SELECT p.productCode, p.productName, p.buyPrice, SUM(od.quantityOrdered) AS totalSold
FROM products p
JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productCode, p.productName, p.buyPrice
ORDER BY p.buyPrice;

-- are there any special pattern in thhis sales
SELECT MONTH(o.orderDate) AS orderMonth, SUM(od.quantityOrdered) AS totalSold
FROM orders o
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY orderMonth
ORDER BY orderMonth;

-- -------------------------------------------------------------------Company Revenue

-- Get The Total revenue by each warehouse
SELECT warehouseName AS warehouse, 
		SUM(quantityOrdered) Total_ordered, 
		SUM(od.quantityOrdered * od.priceEach) AS total_revenue
FROM warehouses w
iNNER JOIN products as p on p.warehouseCode = w.warehouseCode
INNER JOIN orderdetails as od on od.productCode = p.productCode
GROUP BY warehouse
ORDER BY total_revenue DESC;


-- revenue from each product line
SELECT productLine, 
		SUM(quantityOrdered) Total_ordered, 
		SUM(od.quantityOrdered * od.priceEach) AS total_revenue
FROM products p
INNER JOIN orderdetails od ON od.productCode = p.productCode
GROUP BY productLine
ORDER BY total_revenue DESC;

-- revenue from each product --  Using each price 
SELECT distinct productName,quantityInStock, buyPrice, priceEach, 
		SUM(quantityOrdered) Total_ordered, 
		SUM(od.quantityOrdered * od.priceEach) AS total_revenue
FROM products p
INNER JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY productName,quantityInStock, buyPrice, priceEach
ORDER BY total_revenue desc;

--  without each price only products and total revenue by products
SELECT distinct productName, 
		SUM(quantityOrdered) Total_ordered, 
		SUM(od.quantityOrdered * od.priceEach) AS total_revenue
FROM products p
INNER JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY productName
ORDER BY total_revenue desc;

-- ------------------------------------------------- Custotmer analysis -----------------------------------------------------------------------------------------------
 -- --------------------------------------------------------------------------------------------------------------------------------------------------
-- GET Customer Profile DAta  including orders and  payments
SELECT c.customerNumber, c.customerName, c.country, c.creditLimit, Total_order,total_payment, (total_payment- creditLimit) as creditLimitdiff
		FROM (SELECT  customerNumber, customerName, country, creditLimit FROM customers) c
LEFT JOIN 
		(SELECT customerNumber, SUM(amount) as total_payment 
		FROM payments
		GROUP BY customerNumber) p
on c.customerNumber = p.customerNumber
LEFT JOIN
		(SELECT customerNumber,Count(orderNumber) Total_order FROM orders
		GROUP BY customerNumber) o
on c.customerNumber = o.customerNumber
GROUP BY customerName, c.customerNumber, c.customerName, c.country, c.creditLimit, Total_order,total_payment
ORDER BY total_payment DESC;

-- -------------------------------------------------------------------Employee Performance-----------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Get data on the number of employees in each office
SELECT COUNT(employeeNumber) cnt_of_employee, o.officeCode, o.city, o.country 
FROM offices o
LEFT JOIN employees e on e.officeCode = o.officeCode
GROUP BY officeCode
ORDER BY cnt_of_employee DESC;
 
-- Get employee performance Data
SELECT employeeNumber, firstName, lastName, jobTitle, 
		COUNT(orderNumber) count_of_orders 
FROM employees e
LEFT JOIN customers c on c.salesRepEmployeeNumber = e.employeeNumber
LEFT JOIN orders o on o.customerNumber = c.customerNumber
GROUP BY employeeNumber, firstName, lastName, jobTitle
ORDER BY count_of_orders DESC;


-- ----------------------------------------------- Conduct What-if Analysis -------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------------
-- What-if analysis for reducing inventory by 5%
SELECT productCode, productName, quantityInStock, quantityInStock * 0.95 AS reducedStock
FROM products; -- To understand the impact of reducing inventory by 5%, we need to calculate the new inventory levels.

-- -------------------------------------------------- Formulate Suggestions and Recommendations--------------------------
-- -----------------------------------------------------------------------------------------------------------------------
-- A. Scenario 1: Close the Least Utilized Warehouse
-- Identify the least utilized warehouse
SELECT p.warehouseCode, warehouseName, SUM(quantityInStock) AS totalInventory
FROM products p
join warehouses w ON w.warehouseCode = p.warehouseCode
GROUP BY warehouseCode
ORDER BY totalInventory ASC; -- South

-- B. Scenario 2: Optimize Inventory Levels
-- Identify slow-moving products
SELECT p.productCode, productName, quantityInStock, SUM(od.quantityOrdered) AS totalSold
		FROM products p
		JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productCode, p.productName, p.quantityInStock
HAVING totalSold <
					(SELECT AVG(quantityOrdered) FROM orderdetails)
ORDER BY totalSold ASC;

-- Identify the least utilized warehouse
SELECT p.warehouseCode, warehouseName, SUM(quantityInStock) AS totalInventory
FROM products p
join warehouses w ON w.warehouseCode = p.warehouseCode
GROUP BY warehouseCode
ORDER BY totalInventory ASC
LIMIT 1; -- South

-- What-if analysis for reducing inventory of slow-moving products by 5%
SELECT productCode, productName, quantityInStock, quantityInStock * 0.95 AS reducedStock
FROM products
WHERE productCode IN (
  SELECT productCode
  FROM (SELECT productCode, SUM(quantityOrdered) AS totalSold
        FROM orderdetails
        GROUP BY productCode
        HAVING totalSold < (SELECT AVG(quantityOrdered) FROM orderdetails)) AS slow_moving
);
















