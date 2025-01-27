/* EVALUACION FINAL MODULO 2 */
/* Para este ejercicio utilizaremos la BBDD Sakila. Es una base de datos que simula una tienda de alquiler 
de películas. Contiene tablas como film (películas), actor (actores), customer (clientes), rental (alquileres), 
category (categorías), entre otras. */

USE sakila;

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT DISTINCT title AS nombre_pelicula
FROM film;

-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

SELECT title  AS nombre_pelicula
FROM film
WHERE rating = 'PG-13';

-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.

SELECT title AS nombre_pelicula, 
description AS descripcion_pelicula
FROM film
WHERE description LIKE '%Amazing%';

-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

SELECT title AS nombre_pelicula
FROM film
WHERE length > 120;

-- 5. Encuentra los nombres de todos los actores, muestralos en una sola columna que se llame
-- nombre_actor y contenga nombre y apellido.

SELECT DISTINCT CONCAT(first_name, ' ', last_name) AS nombre_actor
FROM actor;

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

SELECT first_name AS nombre_actor, 
last_name AS apellido_actor
FROM actor 
WHERE last_name = 'Gibson'; /*uso = en lugar de LIKE ya que busco una coincidencia exacta en el apellido*/

-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.

SELECT CONCAT (first_name, ' ', last_name) AS nombre_actor
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

-- 8. Encuentra el título de las películas en la tabla film que no tengan clasificacion "R" ni "PG-13".

SELECT title AS nombre_pelicula
FROM film
WHERE rating NOT IN ('R', 'PG-13');

-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la
-- clasificación junto con el recuento.

SELECT rating AS clasificacion, 
COUNT(film_id) AS recuento_peliculas
FROM film
GROUP BY rating
ORDER BY recuento_peliculas DESC;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su
-- nombre y apellido junto con la cantidad de películas alquiladas.

SELECT 
	c.customer_id AS id_cliente,
	c.first_name AS nombre_cliente,
	c.last_name AS apellido_cliente,
	COUNT(r.rental_id) AS cantidad_peliculas_alquiladas
FROM customer c
INNER JOIN rental r
ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY cantidad_peliculas_alquiladas DESC;

-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la
-- categoría junto con el recuento de alquileres.

/* 
SELECT * FROM rental;
SELECT * FROM inventory; 
SELECT * FROM film_category; 
SELECT * FROM category; 
*/

SELECT 
	c.name AS nombre_categoria,
	COUNT(r.rental_id) AS cantidad_peliculas_alquiladas
FROM rental r
INNER JOIN inventory i
ON r.inventory_id = i.inventory_id 
INNER JOIN film_category fc
ON i.film_id = fc.film_id
INNER JOIN category c
ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY cantidad_peliculas_alquiladas DESC;

-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y
-- muestra la clasificación junto con el promedio de duración.

SELECT 
	rating AS clasificacion, 
	AVG(length) AS promedio_duracion
FROM film
GROUP BY rating
ORDER BY promedio_duracion DESC;

-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

SELECT 
	a.first_name AS nombre_actor, 
	a.last_name AS apellido_actor
FROM actor a
INNER JOIN film_actor fa
ON a.actor_id = fa.actor_id
INNER JOIN film f
ON fa.film_id = f.film_id
WHERE f.title = 'Indian Love';

-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.

SELECT title AS nombre_pelicula 
FROM film
WHERE description LIKE '%dog%' OR description LIKE '%cat%';

-- 15. Hay algún actor o actriz que no aparezca en ninguna película en la tabla film_actor.

SELECT CONCAT (first_name, ' ', last_name) AS nombre_actor
FROM actor
WHERE actor_id NOT IN (
	SELECT DISTINCT actor_id
	FROM film_actor);

-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.

SELECT title AS nombre_pelicula
FROM film
WHERE release_year BETWEEN 2005 AND 2010;

-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".

-- Dos opciones: 
-- Opcion 1 (con joins):
SELECT f.title AS nombre_pelicula
FROM film f
INNER JOIN film_category fc
ON f.film_id = fc.film_id
INNER JOIN category c
ON fc.category_id = c.category_id
WHERE c.name = 'Family'; 

-- Opcion 2 (con subconsultas):
SELECT f.title AS nombre_pelicula
FROM film f
WHERE f.film_id IN(
	SELECT fc.film_id
	FROM film_category fc
	WHERE fc.category_id IN (
		SELECT c.category_id
		FROM category c
		WHERE c.name = 'Family'));

-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.

SELECT 
	a.first_name AS nombre_actor,
	a.last_name AS apellido_actor
FROM actor a
INNER JOIN film_actor fa
ON a.actor_id = fa.actor_id
GROUP BY a.first_name, a.last_name
HAVING COUNT(fa.film_id) > 10;

-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la
-- tabla film.

SELECT title AS nombre_pelicula
FROM film
WHERE rating = 'R' AND length > 120
ORDER BY length ASC;

-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120
-- minutos y muestra el nombre de la categoría junto con el promedio de duración.
/*
SELECT * FROM category;
SELECT * FROM film_category;
SELECT * FROM film;
*/

SELECT 
	c.name AS nombre_categoria,
	AVG(f.length) AS promedio_duracion
FROM category c
INNER JOIN film_category fc
ON c.category_id = fc.category_id
INNER JOIN film f
ON fc.film_id = f.film_id
GROUP BY c.name
HAVING promedio_duracion > 120;

-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor
-- junto con la cantidad de películas en las que han actuado.

SELECT 
	CONCAT(a.first_name, ' ', a.last_name) AS nombre_actor,
	COUNT(DISTINCT fa.film_id) AS conteo_peliculas
FROM actor a
INNER JOIN film_actor fa
ON a.actor_id = fa.actor_id
GROUP BY fa.actor_id
HAVING conteo_peliculas >= 5
ORDER BY conteo_peliculas DESC;

-- 22. Encuentra el título de todas las películas que fueron alquiladas durante más de 5 días. Utiliza una
-- subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona
-- las películas correspondientes. Pista: Usamos DATEDIFF para calcular la diferencia entre una
-- fecha y otra, ej: DATEDIFF(fecha_inicial, fecha_final)

/*
SELECT * FROM rental;
SELECT * FROM inventory;
SELECT * FROM film;
*/

SELECT DISTINCT(f.title) AS nombre_pelicula
FROM film f
INNER JOIN inventory i
ON f.film_id = i.film_id
WHERE i.inventory_id IN(
	SELECT r.inventory_id
	FROM rental r
	WHERE DATEDIFF(r.return_date, r.rental_date) > 5);

-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la
-- categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en
-- películas de la categoría "Horror" y luego exclúyelos de la lista de actores.
/*
SELECT * FROM actor;
SELECT * FROM film_actor;
SELECT * FROM film_category;
SELECT* FROM category;
*/

-- Dos opciones: 
-- Opcion 1 (solo con subconsultas)
SELECT 
	a.first_name AS nombre_actor, 
    a.last_name AS apellido_actor
FROM actor a
WHERE a.actor_id NOT IN (
	SELECT fa.actor_id
	FROM film_actor fa
	WHERE fa.film_id IN (
		SELECT fc.film_id
		FROM film_category fc
		WHERE fc.category_id IN(
			SELECT c.category_id
			FROM category c
			WHERE c.name = 'Horror')));

-- Opcion 2 (mezclando joins con una subconsulta)
SELECT 
	a.first_name AS nombre_actor,
	a.last_name AS apellido_actor
FROM actor a
WHERE a.actor_id NOT IN (
	SELECT fa.actor_id
	FROM film_actor fa
	INNER JOIN film_category fc
	ON fa.film_id = fc.film_id
	INNER JOIN category c
	ON fc.category_id = c.category_id
	WHERE c.name = 'Horror');

-- BONUS
-- 24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180
-- minutos en la tabla film con subconsultas.
/*
SELECT * FROM film;
SELECT * FROM film_category;
SELECT * FROM category;
*/

SELECT f.title AS nombre_pelicula 
FROM film f
WHERE f.length > 180 AND f.film_id IN(
	SELECT fc.film_id
	FROM film_category fc
	WHERE fc.category_id IN(
		SELECT c.category_id
		FROM category c
		WHERE c.name = 'Comedy'));

-- 25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. La
-- consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que
-- han actuado juntos. Pista: Podemos hacer un JOIN de una tabla consigo misma, poniendole un
-- alias diferente.
/*
SELECT * FROM film_actor;
*/

SELECT
	CONCAT (a1.first_name, ' ', a1.last_name) AS nombre_actor1,
    CONCAT (a2.first_name, ' ', a2.last_name) AS nombre_actor2,
    COUNT(fa1.film_id) AS conteo_peliculas
FROM film_actor fa1
INNER JOIN film_actor fa2
ON fa1.film_id = fa2.film_id -- este primer join me da para cada actor, el resto de actores con los que ha trabajado
INNER JOIN actor a1
ON a1.actor_id = fa1.actor_id
INNER JOIN actor a2
ON a2.actor_id = fa2.actor_id -- uno las tablas actor para poder decirle que me saque los nombres de actor (no los ids)
WHERE fa1.actor_id < fa2.actor_id -- pongo esta condicion para evitar comparar un actor consigo mismo
GROUP BY nombre_actor1, nombre_actor2;  -- agrupo para contar el numero de peliculas en el que han trabajado juntos.
