-- 7.Get all pairs of actors that worked together.
-- 8.Get all pairs of customers that have rented the same film more than 3 times.
-- 9.For each film, list actor that has acted in more films.


-- LAB 3.01

Use sakila;

-- 1.Drop column picture from staff.
ALTER TABLE sakila.staff
DROP COLUMN picture;

-- 2.A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. Update the database accordingly.
SELECT 
    *
FROM
    sakila.customer
WHERE
    first_name = 'TAMMY';
SELECT 
    *
FROM
    sakila.staff;
INSERT INTO sakila.staff (staff_id, first_name, last_name, address_id, email, store_id, active, username, password)
VALUES (3, 'Tammy', 'Sanders', 79, 'tammy.sanders@sakilacustomer.com', 2, 1,'Tammy', 'tammygjovi');


-- 3.Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1. You can use current date for the rental_date column in the rental table. Hint: Check the columns in the table rental and see what information you would need to add there. You can query those pieces of information. For eg., you would notice that you need customer_id information as well. To get that you can use the following query:
SELECT 
    *
FROM
    sakila.rental;
SELECT 
    customer_id
FROM
    sakila.customer
WHERE
    first_name = 'CHARLOTTE'
        AND last_name = 'HUNTER';
INSERT INTO sakila.rental (inventory_id, customer_id, staff_id)
VALUES (1, 130, 3);	
SELECT 
    *
FROM
    sakila.rental;

-- LAB 3.03

-- 1.How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT 
    COUNT(film_id)
FROM
    sakila.inventory
WHERE
    (SELECT 
            film_id
        FROM
            film
        WHERE
            title = '%Hunchback Impossible%');
SELECT 
    COUNT(film_id)
FROM
    sakila.inventory
WHERE
    film_id = 439;
SELECT 
    film_id
FROM
    film
WHERE
    title = '%Hunchback Impossible%';
    
-- 2.List all films whose length is longer than the average of all the films.
SELECT 
    *
FROM
    sakila.film
WHERE
    length > (SELECT 
            AVG(length)
        FROM
            sakila.film);
            
-- 3.Use subqueries to display all actors who appear in the film Alone Trip.
SELECT 
    concat(first_name, " ", last_name) as actor_name
FROM
    actor
WHERE
    actor_id IN (SELECT 
            film_id
        FROM
            film_actor
        WHERE
            film_id IN (SELECT 
                    film_id
                FROM
                    sakila.film
                WHERE
                    title = 'Alone Trip'));
                    
-- 4.Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT 
    *
FROM
    sakila.category;
SELECT 
    title AS 'family movies'
FROM
    sakila.film
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            sakila.film_category
        WHERE
            category_id IN (SELECT 
                    category_id
                FROM
                    sakila.category
                WHERE
                    name = 'family'));
                    
-- 5.Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
SELECT 
    CONCAT(first_name, ' ', last_name) AS name, email
FROM
    sakila.customer
WHERE
    address_id IN (SELECT 
            address_id
        FROM
            sakila.address
        WHERE
            city_id IN (SELECT 
                    city_id
                FROM
                    sakila.city
                WHERE
                    country_id IN (SELECT 
                            country_id
                        FROM
                            sakila.country
                        WHERE
                            country = 'canada')));

-- or
SELECT 
    first_name, last_name, email
FROM
    customer
WHERE
    address_id IN (SELECT 
            address_id
        FROM
            address
        WHERE
            city_id IN (SELECT 
                    city_id
                FROM
                    city
                        JOIN
                    country USING (country_id)
                WHERE
                    country = 'Canada'));
                    
-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT 
    actor_id, COUNT(film_id) AS film
FROM
    film_actor
GROUP BY actor_id
ORDER BY film DESC;
SELECT 
    title AS 'Most prolific film'
FROM
    sakila.film
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            sakila.film_actor
        WHERE
            actor_id = 107);
    
-- 7.Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
SELECT 
    customer_id, SUM(amount) AS t_payment
FROM
    payment
GROUP BY customer_id
ORDER BY t_payment DESC;
SELECT 
    title
FROM
    sakila.film
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            sakila.inventory
        WHERE
            inventory_id IN (SELECT 
                    inventory_id
                FROM
                    sakila.rental
                WHERE
                    customer_id = 526));
    
-- 8.Customers who spent more than the average payments.
SELECT 
    *
FROM
    sakila.customer
WHERE
    customer_id IN (SELECT 
            customer_id
        FROM
            sakila.payment
        WHERE
            amount > (SELECT 
                    AVG(amount)
                FROM
                    sakila.payment));
