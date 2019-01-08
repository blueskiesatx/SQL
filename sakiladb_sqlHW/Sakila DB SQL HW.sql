-- 1a Display the first and last names of all actors from the table actor
USE sakila;
SELECT first_name, last_name FROM actor;

-- 1b Display the first and last name of each actor in a single column 
-- in upper case letters. Name the column Actor Name
SELECT upper(concat(first_name,' ', last_name)) AS Actor_Name
FROM actor;

-- 2a Find the ID number, first name, and last name of an actor, of whom you 
-- know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'Joe';

-- 2b Find all actors whose last name contain the letters GEN:
SELECT * FROM actor
WHERE last_name LIKE '%GEN%';

-- 2c Find all actors whose last names contain the letters LI. This time, 
-- order the rows by last name and first name, in that order:
SELECT last_name, first_name
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

-- 2d Using IN, display the country_id and country columns of the 
-- following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a You want to keep a description of each actor. You don't think 
-- you will be performing queries on a description, so create a column in the 
-- table actor named description and use the data type BLOB (Make sure to research 
-- the type BLOB, as the difference between it and VARCHAR are significant).

-- A blob is a collection of binary data
ALTER TABLE actor
ADD COLUMN description BLOB;

-- 3b Delete the description column.
ALTER TABLE actor
DROP COLUMN description;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name AS 'Last_Name', COUNT(last_name) AS 'LAST NAME COUNT'
FROM actor
GROUP BY last_name;

-- 4b. List the last names of actors, but only for names that are shared by at least two actors.
SELECT last_name, COUNT(last_name) as 'Last Name Duplicates'
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) >=2;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO 
-- WILLIAMS. Write a query to fix the record.
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO 
-- was the correct name after all! In a single query, if the first name of the actor is 
-- currently HARPO, change it to GROUCHO.
SELECT * from actor 
WHERE first_name = 'HARPO';
UPDATE actor
SET first_name = 'GROUCHO' 
WHERE first_name = 'HARPO' AND actor_id = 172;
SELECT * from actor 
WHERE actor_id = 172;

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
DESCRIBE sakila.address;
-- This was exported as Schema_of_table.csv and is in same folder as this script.

-- 6a.  Use JOIN to display the first and last names, as well as the address, of each staff member. 
-- Use the tables staff and address:
SELECT s.first_name, s.last_name, a.address
FROM staff s
INNER JOIN address a
ON s.address_id = a.address_id;

-- SELECT first_name, last_name, address
-- FROM staff s
-- INNER JOIN address a
-- ON s.address_id = a.address_id;


-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables 
-- 'staff' and 'payment'.
SELECT s.first_name, s.last_name, SUM(p.amount) AS 'Total Amount Rung 2005'
FROM staff s
INNER JOIN payment p
ON s.staff_id = p.staff_id
WHERE payment_date between '2005-08-01' AND '2005-08-31'
ORDER BY last_name ASC;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. 
-- Use inner join.
SELECT f.title AS 'FILM', COUNT(fa.actor_id) AS 'Total Actors in Film'
FROM film f
INNER JOIN film_actor fa
ON f.film_id = fa.film_id
GROUP BY f.title;

-- 6d How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT f.title AS 'film', COUNT(i.inventory_id) AS 'Available'
FROM film f
INNER JOIN inventory i 
ON f.film_id = i.film_id
WHERE f.title = 'Hunchback Impossible'
GROUP BY f.title;

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the 
-- customers alphabetically by last name:
SELECT c.first_name, c.last_name, COUNT(p.amount) AS 'Total Paid'
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY c.first_name,
c.last_name
ORDER BY last_name;

-- SELECT last_name, first_name, SUM(amount)
-- FROM payment p
-- INNER JOIN customer c
-- ON p.customer_id = c.customer_id
-- GROUP BY p.customer_id
-- ORDER BY last_name ASC;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
-- films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles 
-- of movies starting with the letters K and Q whose language is English. 
USE sakila;
SELECT title FROM film
WHERE language_id in
	(SELECT language_id 
	FROM language
	WHERE name = "English" )
AND (title LIKE "K%") OR (title LIKE "Q%");

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
USE sakila;
SELECT last_name, first_name
FROM actor
WHERE actor_id in
	(SELECT actor_id FROM film_actor
	WHERE film_id in 
		(SELECT film_id FROM film
		WHERE title = "Alone Trip"));

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses 
-- of all Canadian customers. Use joins to retrieve this information.
USE sakila;
SELECT country, last_name, first_name, email
FROM country c
LEFT JOIN customer cu
ON c.country_id = cu.customer_id
WHERE country = 'Canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.
USE sakila;
SELECT title, category
FROM film_list
WHERE category = 'Family';

-- 7e. Display the most frequently rented movies in descending order.
SELECT i.film_id, f.title, COUNT(r.inventory_id)
FROM inventory i
INNER JOIN rental r
ON i.inventory_id = r.inventory_id
INNER JOIN film_text f 
ON i.film_id = f.film_id
GROUP BY r.inventory_id
ORDER BY COUNT(r.inventory_id) DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT store.store_id, SUM(amount)
FROM store
INNER JOIN staff
ON store.store_id = staff.store_id
INNER JOIN payment p 
ON p.staff_id = staff.staff_id
GROUP BY store.store_id
ORDER BY SUM(amount);

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, city, country
FROM store s
INNER JOIN customer cu
ON s.store_id = cu.store_id
INNER JOIN staff st
ON s.store_id = st.store_id
INNER JOIN address a
ON cu.address_id = a.address_id
INNER JOIN city ci
ON a.city_id = ci.city_id
INNER JOIN country coun
ON ci.country_id = coun.country_id;

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following 
-- tables: category, film_category, inventory, payment, and rental.)
SELECT c.name as "Genre", SUM(p.amount)
FROM category c 
INNER JOIN film_category fc ON c.category_id = fc.category_id
INNER JOIN film f ON fc.film_id = f.film_id
INNER JOIN inventory i ON f.film_id = i.film_id
INNER JOIN rental r ON i.inventory_id = r.inventory_id
INNER JOIN payment p ON r.rental_id = p.rental_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of 
-- viewing the top five genres by gross revenue. Use the solution from the 
-- problem above to create a view. If you haven't solved 7h, you can substitute 
-- another query to create a view.
CREATE VIEW top_five_genres_1 AS
SELECT name, SUM(p.amount)
FROM category c
INNER JOIN film_category fc
ON fc.category_id = c.category_id
INNER JOIN inventory i
ON i.film_id = fc.film_id
INNER JOIN rental r
ON r.inventory_id = i.inventory_id
INNER JOIN payment p
ON p.rental_id = r.rental_id
GROUP BY c.name
ORDER BY SUM(p.amount)desc
LIMIT 5;

-- 8b. How would you display the view that you created in 8a?
SELECT * FROM top_five_genres_1;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top_five_genres_1
