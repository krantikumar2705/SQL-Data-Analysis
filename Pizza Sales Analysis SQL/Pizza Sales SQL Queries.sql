CREATE DATABASE PIZZA_HUT;
USE PIZZA_HUT;

-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
-- 	Retrieve the total number of orders placed.
SELECT 
    COUNT(order_id) AS Total_orders
FROM
    orders;

-- Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(quantity * price), 2) Revenue
FROM
    pizzas AS p
        INNER JOIN
    order_details AS od ON od.pizza_id = p.pizza_id;

-- Identify the highest-priced pizza.
SELECT pt.name AS Name,price FROM pizzas AS p
INNER JOIN pizza_types AS pt on pt.pizza_type_id = p.pizza_type_id
ORDER BY PRICE DESC
LIMIT 1;

-- Identify the most common pizza size ordered.
SELECT COUNT(order_details_id) as Orders, size FROM pizzas AS P
INNER JOIN order_details as od on od.pizza_id = p.pizza_id 
GROUP BY size
ORDER BY SUM(quantity) DESC;

-- List the top 5 most ordered pizza types along with their quantities.
SELECT name,pt.pizza_type_id Pizza_id, sum(quantity) Quantity FROM order_details as od
INNER JOIN pizzas AS p on p.pizza_id = od.pizza_id
INNER JOIN pizza_types AS pt on pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.pizza_type_id,name
ORDER BY SUM(quantity) DESC
LIMIT 5;

-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

-- Intermediate:
-- Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT category, SUM(quantity) AS Quantity FROM pizza_types AS pt
INNER JOIN pizzas AS P ON p.pizza_type_id = pt.pizza_type_id
INNER JOIN order_details AS od on od.pizza_id = p.pizza_id
GROUP BY category 
ORDER BY SUM(quantity) DESC;

-- Determine the distribution of orders by hour of the day.
SELECT HOUR(order_time) HOUR_TIME, COUNT(order_id) ORDER_CNT FROM orders
GROUP BY HOUR(order_time);

-- Join relevant tables to find the category-wise distribution of pizzas.
SELECT category, COUNT(name) cnt_ordered FROM pizza_types
GROUP BY category;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT ROUND(AVG(quantity),2) AS AVG_Sale FROM
(SELECT o.order_date, SUM(od.quantity) AS quantity FROM orders AS o
JOIN order_details AS od ON od.order_id  = o.order_id
GROUP BY order_date) AS order_quantity;

-- Determine the top 3 most ordered pizza types based on revenue.
SELECT name, SUM(quantity * price) Rev FROM pizza_types AS pt
INNER JOIN pizzas AS p ON p.pizza_type_id = pt.pizza_type_id
INNER JOIN order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY name
ORDER BY Rev DESC
LIMIT 3;

-- Advanced:
-- Calculate the percentage contribution of each pizza type to total revenue.
SELECT pt.category, CONCAT(ROUND(SUM(quantity*price) / (SELECT 
    ROUND(SUM(quantity * price), 2)
FROM
    pizzas AS p
        INNER JOIN
    order_details AS od ON od.pizza_id = p.pizza_id) * 100,2),"%")AS Rev
FROM pizza_types AS pt
INNER JOIN pizzas AS p ON p.pizza_type_id = pt.pizza_type_id
INNER JOIN order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY pt.category 
ORDER BY Rev DESC;


-- Analyze the cumulative revenue generated over time.
SELECT order_date, SUM(Rev) OVER(ORDER BY order_date) AS CUM_Rev
FROM
	(SELECT order_date, SUM(quantity * price) Rev FROM pizzas AS P
INNER JOIN order_details AS od ON od.pizza_id = p.pizza_id
INNER JOIN orders AS o ON o.order_id = od.order_id
GROUP BY order_date) AS sales;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

SELECT name, revenue, Rank_ FROM
( SELECT category, name, revenue,
RANK() OVER( PARTITION BY category ORDER BY revenue DESC) AS Rank_
FROM 
(SELECT pt.category, pt.name, SUM(od.quantity * p.price) AS revenue
FROM pizza_types  AS  pt
JOIN pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY pt.category, pt.name) AS a) AS b
WHERE Rank_ <=3;