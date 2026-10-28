/*
 * Compute the total revenue for each film.
 * The output should include another new column "revenue percent" that shows the percent of total revenue that comes from the current film and all previous films.
 * That is, the "revenue percent" column is 100*"total revenue"/sum(revenue)
 *
 * HINT:
 * The `to_char` function can be used to achieve the correct formatting of your percentage.
 * See: <https://www.postgresql.org/docs/current/functions-formatting.html#FUNCTIONS-FORMATTING-EXAMPLES-TABLE>
 */
SELECT rank,
       title,
       revenue,
       "total revenue",
       TO_CHAR(
           100 * "total revenue" / SUM(revenue) OVER (),
           'FM900.00'
       ) AS "percent revenue"
FROM (
    SELECT RANK() OVER (ORDER BY revenue DESC) AS rank,
           title,
           revenue,
           SUM(revenue) OVER (
               ORDER BY revenue DESC
               RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
           ) AS "total revenue"
    FROM (
        SELECT film.title,
               COALESCE(SUM(payment.amount), 0.00) AS revenue
        FROM film
        LEFT JOIN inventory ON film.film_id = inventory.film_id
        LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id
        LEFT JOIN payment ON rental.rental_id = payment.rental_id
        GROUP BY film.film_id, film.title
    ) AS film_revenue
) AS ranked_films
ORDER BY revenue DESC, title;
