-- Walmart Sales Data Anaysis --
CREATE DATABASE walmart;

USE walmart;

-- Create table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);
--  checking the table
select * from sales;

-- ---------------------------------------------------------------------------------
-- --------------------------Feature Engineering ---------------------------------------

SELECT * FROM sales;

-- 1.Add a new column named time_of_day to give insight of sales in the Morning, 
-- Afternoon and Evening. This will help answer the question on which part 
-- of the day most sales are made.
-- SET SQL_SAFE_UPDATES = 0;

SELECT time,
	(CASE
		WHEN `time` >= '00:00:00' AND `time` < '12:00:00' THEN 'Morning'
        WHEN `time` >= '12:00:00' AND `time` < '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
        END) AS time_of_date
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales 
SET time_of_day = 
		(CASE
			WHEN `time` >= '00:00:00' AND `time` < '12:00:00' THEN 'Morning'
			WHEN `time` >= '12:00:00' AND `time` < '16:00:00' THEN 'Afternoon'
			ELSE 'Evening'
			END);

-- 2.Add a new column named day_name that contains the extracted days of the week on which the given transaction took place 
-- (Mon, Tue, Wed, Thur, Fri). This will help answer the question on which week of the day each branch is busiest.

select date, DAYNAME(date) 
from sales;

-- Adding columns
ALTER TABLE sales ADD COLUMN day_name VARCHAR(50);

--  insert the values
UPDATE sales
SET day_name = DAYNAME(date);

-- 3. Add a new column named month_name that contains the extracted months of the year 
-- on which the given transaction took place (Jan, Feb, Mar). 
-- Help determine which month of the year has the most sales and profit.
SELECT date,
	MONTHNAME(date) FROM sales;
    
-- create columns
ALTER TABLE sales ADD COLUMN month_name varchar(20);

-- puting the values
UPDATE sales
SET month_name = MONTHNAME(date);

-- ------------------------------------------------------------------------------------------------------------------------
-- ------------------------------GENERIC QUESTIONS -------------------------------------------------------------------
-- 1. How many unique cities does the data have?
	SELECT DISTINCT city FROM sales;
    
-- 2.In which city is each branch?
SELECT DISTINCT branch, city FROM sales;

-- ---------------------------------------------------------------------------------------------------------------------
-- - ----------------------------------------------PRODUCT QUESTIONS--------------------------------------------------------------
-- 1.How many unique product lines does the data have?
SELECT COUNT(DISTINCT product_line) AS count_of_product_line FROM sales;

-- 2.What is the most common payment method?
SELECT payment,count(payment)  AS cnt_of_payment FROM sales
GROUP BY payment
ORDER BY count(payment) desc;

-- What is the most selling product line?
SELECT product_line,count(product_line) AS cnt 
FROM sales
GROUP BY product_line
ORDER BY count(product_line) DESC;

-- What is the total revenue by month?
SELECT month_name, SUM(total) AS total_revenue FROM sales
GROUP BY month_name
ORDER BY SUM(total) DESC;

-- What month had the largest COGS? -- Cost of goods sold 
SELECT month_name, SUM(cogs) AS cogs FROM sales
GROUP BY month_name
ORDER BY cogs DESC;


-- What product line had the largest revenue?
SELECT product_line, SUM(total) AS largest_revenue FROM sales
GROUP BY product_line
ORDER BY largest_revenue DESC;

-- What is the city with the largest revenue?
SELECT city, SUM(total) AS largest_revenue FROM sales
GROUP BY city
ORDER BY largest_revenue DESC;

-- What product line had the largest VAT? -- Value Added Tax 
SELECT product_line, AVG(vat) AS Avg_tax FROM sales
GROUP BY product_line
ORDER BY Avg_tax DESC;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". 
-- Good if its greater than average sales3
SELECT product_line,AVG(quantity),
		(CASE
			WHEN AVG(quantity) > 6 THEN "GOOD"
            ELSE "BAD"
		END)
FROM sales;


-- Which branch sold more products than average product sold?
SELECT branch, SUM(quantity) AS qty FROM sales
GROUP BY branch
HAVING qty > (SELECT AVG(quantity) FROM sales);


-- What is the most common product line by gender?
SELECT gender, count(gender) AS total_cnt, product_line FROM sales
GROUP BY gender,product_line
ORDER BY COUNT(gender) DESC;

-- What is the average rating of each product line?
SELECT product_line, ROUND(AVG(rating),2) FROM sales
GROUP BY product_line
ORDER BY AVG(rating) DESC;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------SALES ANALYSIS ----------------------------------------------------------------
-- Number of sales made in each time of the day per weekday
SELECT time_of_day, COUNT(*)  AS sales FROM sales
WHERE day_name = "sunday"
GROUP BY time_of_day
ORDER BY sales DESC;

-- Which of the customer types brings the most revenue?
SELECT distinct customer_type, SUM(total) AS total_rev FROM sales
GROUP BY customer_type
ORDER BY total_rev DESC;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT city, AVG(vat) AS vat FROM sales
GROUP BY city 
ORDER BY vat DESC;

-- Which customer type pays the most in VAT?
SELECT customer_type, AVG(vat) AS VAT FROM sales
GROUP BY customer_type
ORDER BY VAT DESC;

-- ----------------------------------------------------------------------------------------------------
-- ------------------------------------------- Customer Analysis ----------------------------------------
-- How many unique customer types does the data have?
SELECT DISTINCT customer_type FROM sales;

-- How many unique payment methods does the data have?
SELECT DISTINCT payment FROM sales;

-- What is the most common customer type?
SELECT DISTINCT customer_type, COUNT(*) FROM sales
GROUP BY customer_type
ORDER BY COUNT(*) DESC;

-- Which customer type buys the most?
SELECT DISTINCT customer_type, COUNT(*) FROM sales
GROUP BY customer_type
ORDER BY COUNT(*) DESC;

-- What is the gender of most of the customers?
SELECT gender, count(gender) AS cnt FROM sales
GROUP BY gender 
ORDER BY cnt DESC;

-- What is the gender distribution per branch? -- A, B, C branch
SELECT branch,gender, COUNT(gender) AS cnt FROM sales
WHERE branch = 'c'
GROUP BY branch, gender
ORDER BY cnt DESC;

-- Which time of the day do customers give most ratings?
SELECT time_of_day, AVG(rating) AS avg_rate FROM sales
GROUP BY time_of_day
ORDER BY avg_rate DESC;

-- Which time of the day do customers give most ratings per branch?
SELECT branch,time_of_day, AVG(rating) AS avg_rate FROM sales
WHERE branch = "A"
GROUP BY time_of_day
ORDER BY avg_rate DESC;

-- Which day of the week has the best avg ratings?
SELECT day_name, AVG(rating) AS rate FROM sales
GROUP BY day_name
ORDER BY rate DESC;

-- Which day of the week has the best average ratings per branch?
SELECT branch, day_name,AVG(rating) AS rat FROM sales
WHERE branch = "A"
GROUP BY branch, day_name
ORDER BY rat DESC;






