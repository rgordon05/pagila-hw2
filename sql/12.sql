/*
 * List the title of all movies that have both the 'Behind the Scenes' and the 'Trailers' special_feature
 *
 * HINT:
 * Create a select statement that lists the titles of all tables with the 'Behind the Scenes' special_feature.
 * Create a select statement that lists the titles of all tables with the 'Trailers' special_feature.
 * Inner join the queries above.
 */
SELECT behind.title
FROM (
    SELECT film_id, title
    FROM film
    WHERE 'Behind the Scenes' IN (
        SELECT unnest(special_features)
    )
) AS behind
INNER JOIN (
    SELECT film_id
    FROM film
    WHERE 'Trailers' IN (
        SELECT unnest(special_features)
    )
) AS trailers ON behind.film_id = trailers.film_id
ORDER BY behind.title;
