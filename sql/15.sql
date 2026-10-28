/*
 * Compute the total revenue for each film.
 */
SELECT film.title,
       COALESCE(SUM(payment.amount), 0.00) AS revenue
FROM film
LEFT JOIN inventory ON film.film_id = inventory.film_id
LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id
LEFT JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY film.film_id, film.title
ORDER BY revenue DESC, film.title;
