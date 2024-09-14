#10 Sample queries for SAKILA Database
USE sakila;

# 1) All films with PG-13 films with rental rate of 2.99 or lower
SELECT * FROM film
WHERE rating = "PG-13" and rental_rate <=2.99; 

# 2) All films that have deleted scenes
SELECT film_id, title, release_year, special_features FROM film
WHERE special_features like "%Deleted% scenes";

# 3) All active customers
SELECT customer_id, first_name, last_name, active from customer
WHERE active = 1;

# 4) Names of customers who rented a movie on 26th July 2005
SELECT rental_id,rental_date, c.customer_id, concat(first_name,"  ", last_name) Name FROM customer c
INNER JOIN rental r on r.customer_id = c.customer_id
WHERE date(rental_date) = "2005-07-26";

# 5) Distinct names of customers who rented a movie on 26th July 2005
SELECT DISTINCT r.customer_id, first_name, last_name from customer c
INNER JOIN rental r on r.customer_id = c.customer_id
WHERE date(rental_date) = "2005-07-26";
 
# H1) How many distinct last names we have in the data?
SELECT COUNT( distinct last_name) from customer;

# 6) How many rentals we do on each day?
SELECT date(rental_date), COUNT(*) FROM rental
group by date(rental_date)
ORDER BY date(rental_date);

# 7) What is the busiest day so far?
SELECT date(rental_date), COUNT(*) FROM rental
group by date(rental_date)
ORDER BY COUNT(*) DESC
LIMIT 1;

# 8) All Sci-fi films in our catalogue
SELECT name, f.film_id, c.category_id,title, release_year from category c
INNER JOIN film_category fc on fc.category_id = c.category_id
INNER JOIN film f on f.film_id = fc.film_id
WHERE name = "Sci-Fi";

# 9) Customers and how many movies they rented from us so far?
SELECT c.customer_id, concat(first_name," ", last_name) Name, email ,count(rental_id) CNT from rental r 
INNER JOIN customer c on c.customer_id = r.customer_id
GROUP BY customer_id
ORDER BY count(rental_id) DESC;

# 9) Which movies should we discontinue from our catalogue (less than 5 lifetime rentals)
WITH low_rental_movie as (
   SELECT f.film_id, title, COUNT(rental_id)  FROM film f
   INNER JOIN inventory i on i.film_id = f.film_id
   INNER JOIN rental r on r.inventory_id = i.inventory_id
   GROUP BY 1,2,3
   HAVING COUNT(rental_id)<=1) SELECT * FROM low_rental_movie;

# 10) Which movies are not returned yet?
SELECT f.film_id, rental_date, customer_id, title FROM film f
INNER JOIN inventory i on i.film_id = f.film_id
INNER JOIN rental r on r.inventory_id = i.inventory_id
WHERE return_date is NULL;

# H2) How much money and rentals we make for Store 1 by day?
SELECT date(r.rental_date) ,SUM(amount), count(r.rental_id) FROM store s
INNER JOIN customer c on c.store_id = s.store_id
INNER JOIN rental r on r.customer_id = c.customer_id
INNER JOIN payment p on p.rental_id = r.rental_id
WHERE s.store_id = 1
GROUP BY date(r.rental_date);

# What are the three top earning days so far?
SELECT date(r.rental_date) ,SUM(amount) FROM payment p
INNER JOIN rental r on r.rental_id = p.rental_id
GROUP BY DATE(r.rental_date) 
ORDER BY sum(amount) DESC;
