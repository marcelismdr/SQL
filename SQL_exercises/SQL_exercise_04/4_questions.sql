-- https://en.wikibooks.org/wiki/SQL_Exercises/Movie_theatres.

-- 4.1 Select the title of all movies.
SELECT title FROM ex_04.movies;

-- 4.2 Show all the distinct ratings in the database.
SELECT DISTINCT rating FROM ex_04.movies WHERE rating IS NOT NULL;

-- 4.3  Show all unrated movies.
SELECT * FROM ex_04.movies WHERE rating IS NULL;

-- 4.4 Select all movie theaters that are not currently showing a movie.
SELECT * FROM ex_04.movietheaters WHERE movie IS NULL;

-- 4.5 Select all data from all movie theaters 
-- and, additionally, the data from the movie that is being shown in the theater (if one is being shown).
SELECT a.name, b.title
FROM ex_04.movietheaters AS a
LEFT JOIN ex_04.movies AS b ON a.movie = b.code
WHERE b.title IS NOT NULL;

-- 4.6 Select all data from all movies and, if that movie is being shown in a theater, show the data from the theater.
SELECT *
FROM ex_04.movietheaters AS a
RIGHT JOIN ex_04.movies AS b ON a.movie = b.code;

-- 4.7 Show the titles of movies not currently being shown in any theaters.
SELECT b.title
FROM ex_04.movietheaters AS a
RIGHT JOIN ex_04.movies AS b ON a.movie = b.code
WHERE a.name IS NULL;

-- 4.8 Add the unrated movie "One, Two, Three".
INSERT INTO ex_04.movies(code, title) VALUES (9, 'one, two, three');

-- 4.9 Set the rating of all unrated movies to "G".
UPDATE ex_04.movies
SET rating = 'G'
WHERE rating IS NULL;

-- 4.10 Remove movie theaters projecting movies rated "NC-17".
DELETE FROM ex_04.movietheaters
WHERE code = (
	SELECT a.code
	FROM ex_04.movietheaters AS a
	INNER JOIN ex_04.movies AS b ON a.movie = b.code
	WHERE b.rating = 'NC-17')
	;
