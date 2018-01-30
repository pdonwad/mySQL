
use sakila;

-- 1a. Display the first and last names of all actors from the table actor.
SELECT first_name "First Name",  last_name "Last Name" 
FROM actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT CONCAT_WS(" ", `first_name`, `last_name`) AS `Actor Name` FROM `actor`;

-- 2a. You need to find the ID number, first name, and last name of an actor, 
-- of whom you know only the first name, "Joe." What is one query would you use to obtain this information?

select actor_id "ID Number",first_name "First Name", last_name "Last Name" 
FROM actor
where first_name = "JOE";

-- 2b. Find all actors whose last name contain the letters GEN:
SELECT * FROM actor
WHERE last_name LIKE '%GEN%';
    
-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT * FROM actor
WHERE last_name LIKE '%LI%'
order by last_name and first_name asc;
    
-- 2d. Using IN, display the country_id and 
-- country columns of the following countries: Afghanistan, Bangladesh, and China:

 select 
	country_id "Country_ID", country "Country" 
 from  
	country    
 Where country 
	IN ('Afghanistan' , 'Bangladesh','China');
 
-- 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. 
-- Hint: you will need to specify the data type.
ALTER TABLE actor
 ADD COLUMN middle_name VARCHAR(15)  AFTER first_name;

-- 3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to something that can hold more than varchar.

ALTER TABLE actor 
CHANGE COLUMN middle_name middle_name BLOB NOT NULL ;

-- 3c. Now write a query that would remove the middle_name column.

ALTER TABLE 
	actor
DROP COLUMN 
	middle_name;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT 
	last_name,
	COUNT(last_name) AS actors_with_this_lastname
FROM 
	actor
GROUP BY 
	last_name
ORDER BY 
	COUNT(last_name) DESC;
    
    
-- 4b. List last names of actors and the number of actors who have that last name,but only for names that are shared by at least two actors
SELECT 
	last_name,
	COUNT(last_name) AS actors_with_lastname
FROM 
	actor
GROUP BY 
	last_name
HAVING 
	COUNT(last_name) >= 2 
ORDER BY 
	COUNT(last_name) DESC;

-- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
UPDATE actor 
SET 
    first_name = 'HARPO'
WHERE
    first_name = 'GROUCHO'
        AND last_name = 'WILLIAMS';
        
-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.)
UPDATE 
	actor
SET first_name  = 
( 
	CASE WHEN first_name = 'HARPO' THEN 'GROUCHO'
	ELSE 'MUCHO GROUCHO'
    END
)    
    
WHERE 
	actor_id = 172;   
    
    
-- 5a 
SELECT  *
FROM    INFORMATION_SCHEMA.TABLES
where   TABLES.TABLE_NAME="address";

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:

SELECT 
    s.first_name, s.last_name, a.address
FROM
    address a
        INNER JOIN
    staff s ON a.address_id = s.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment

SELECT 
    s.first_name, s.last_name, SUM(p.amount) AS Total_Amount
FROM
    payment p
        INNER JOIN
    staff s ON s.staff_id = p.staff_id
GROUP BY s.staff_id;

-- 6c List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

SELECT A.ACTOR_ID,A.FIRST_NAME, A.LAST_NAME ,COUNT(F.FILM_ID) AS TOTAL_FILMS
FROM FILM_ACTOR F 
INNER JOIN ACTOR A
ON A.ACTOR_ID=F.ACTOR_ID
GROUP BY A.ACTOR_ID;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT 
    COUNT(inventory_ID) AS COPIES
FROM
    INVENTORY
WHERE
    FILM_ID IN (SELECT 
            FILM_ID
        FROM
            FILM
        WHERE
            TITLE = 'Hunchback Impossible')
GROUP BY FILM_ID;

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:


SELECT * FROM CUSTOMER;
SELECT 
    P.PAYMENT_ID,
    P.CUSTOMER_ID,
    SUM(P.AMOUNT) Payment_total,
    C.first_name,
    C.last_name
FROM
    PAYMENT P
        INNER JOIN
    customer C ON P.customer_id = C.CUSTOMER_ID
GROUP BY P.CUSTOMER_ID
ORDER BY C.last_name;


-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT 
    *
FROM
    FILM
WHERE
    (title LIKE 'K%' OR title LIKE 'Q%')
        AND language_id IN (SELECT 
            language_id
        FROM
            language
        WHERE
            name = 'English');

-- 7b Use subqueries to display all actors who appear in the film Alone Trip.
select  * from film_actor;

SELECT 
    first_name, last_name
FROM
    actor
WHERE
    actor_id IN (SELECT 
            actor_id
        FROM
            film_actor
        WHERE
            film_id IN (SELECT 
                    film_id
                FROM
                    film
                WHERE
                    TITLE = 'Alone Trip'));



-- 7c You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

SELECT 
    first_name, last_name, email
FROM
    customer
WHERE
    customer_id IN (SELECT 
            customer_list.id
        FROM
            customer_list
                JOIN
            country ON customer_list.country = country.country
        WHERE
            country.country = 'Canada');
            

SELECT 
    c.first_name, c.last_name, c.email, a.address, co.country
FROM
    customer c
        LEFT JOIN
    address a ON c.address_id = a.address_id
        LEFT JOIN
    city ci ON a.city_id = ci.city_id
        LEFT JOIN
    country co ON ci.country_id = co.country_id
WHERE
    co.country = 'Canada';


-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.

SELECT 
    f.title
FROM
    film f
        LEFT JOIN
    film_category fc ON f.film_id = fc.film_id
        LEFT JOIN
    category c ON c.category_id = fc.category_id
WHERE
    c.name LIKE '%Family%';
    
-- 7e. Display the most frequently rented movies in descending order.
    
SELECT 
    f.title, f.film_id, COUNT(rental_id) AS Rented_recent
FROM
    film f
        LEFT JOIN
    inventory i ON f.film_id = i.film_id
        LEFT JOIN
    rental r ON r.inventory_id = i.inventory_id
GROUP BY f.film_id , f.title
ORDER BY COUNT(rental_id) DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.

SELECT 
    s.store_id AS Store_Number, SUM(p.amount) AS Total_Business
FROM
    store s
        INNER JOIN
    customer c ON c.store_id = s.store_id
        INNER JOIN
    payment p ON p.customer_id = c.customer_id
GROUP BY s.store_id
ORDER BY s.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.

SELECT 
    s.store_id AS StoreNumber, c.city, co.country
FROM
    store s
        LEFT JOIN
    address a ON s.address_id = a.address_id
        LEFT JOIN
    city c ON c.city_id = a.city_id
        LEFT JOIN
    country co ON c.country_id = co.country_id;

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

SELECT 
    g.name AS Genre, SUM(amount) AS GrossRevenue
FROM
    (SELECT 
        c.name, f.title, p.amount
    FROM
        film f
    LEFT JOIN film_category fc ON fc.film_id = f.film_id
    LEFT JOIN category c ON fc.category_id = c.category_id
    LEFT JOIN inventory i ON i.film_id = f.film_id
    LEFT JOIN rental r ON r.inventory_id = i.inventory_id
    LEFT JOIN payment p ON p.rental_id = r.rental_id
    WHERE
        p.amount IS NOT NULL) g
GROUP BY name
ORDER BY SUM(amount) DESC
LIMIT 5;


-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
DROP VIEW IF EXISTS top_five_genres;


CREATE VIEW top_five_genres
AS

SELECT
	v.name as Genre,
    SUM(amount) as GrossRevenue
FROM
(	
    SELECT
		c.name, f.title, p.amount 
	FROM film f
	LEFT JOIN film_category fc
	ON fc.film_id = f.film_id
	LEFT JOIN category c
	ON fc.category_id = c.category_id
	LEFT JOIN inventory i
	ON i.film_id = f.film_id
	LEFT JOIN rental r
	ON r.inventory_id = i.inventory_id
	LEFT JOIN payment p
	ON p.rental_id = r.rental_id
	WHERE p.amount IS NOT NULL
) v

GROUP BY name
ORDER BY sum(amount) desc
LIMIT 5;


-- 8b. How would you display the view that you created in 8a?
select * from top_five_genres;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

DROP VIEW top_five_genres;