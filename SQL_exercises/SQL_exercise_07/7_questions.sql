-- 9.1 give the total number of recordings in this table
SELECT COUNT(size)
FROM ex_09.log_r;

-- 9.2 the number of packages listed in this table?
SELECT COUNT(DISTINCT(package))
FROM ex_09.log_r;

-- 9.3 How many times the package "Rcpp" was downloaded?
SELECT COUNT(package)
FROM ex_09.log_r
WHERE package = 'Rcpp';

-- 9.4 How many recordings are from China ("CN")?
SELECT COUNT(size)
FROM ex_09.log_r
WHERE country = 'CN';

-- 9.5 Give the package name and how many times they're downloaded. Order by the 2nd column descently.
SELECT package, count(size) AS cuantity
FROM ex_09.log_r
GROUP BY package
ORDER BY cuantity DESC;

-- 9.6 Give the package ranking (based on how many times it was downloaded) during 9AM to 11AM
SELECT package, RANK() OVER(ORDER BY cuantity DESC)
FROM (
	SELECT package, COUNT(size) AS cuantity
	FROM ex_09.log_r
	WHERE DATE_PART('HOUR', time) >= 9 AND DATE_PART('HOUR', time) <= 11
	GROUP BY package
	) AS sub_q
ORDER BY rank ASC;

-- 9.7 How many recordings are from China ("CN") or Japan("JP") or Singapore ("SG")?
SELECT COUNT(size)
FROM ex_09.log_r
WHERE country = 'CN'
	OR country = 'JP'
	OR country = 'SG';

-- 9.8 Print the countries whose downloaded are more than the downloads from China ("CN")
SELECT country
FROM (SELECT country, count(size) AS downloads FROM ex_09.log_r WHERE country != 'CN' GROUP BY country) AS sub_q
WHERE downloads > (
	SELECT COUNT(size)
	FROM ex_09.log_r
	WHERE country = 'CN'
	);

-- 9.9 Print the average length of the package name of all the UNIQUE packages
SELECT AVG(LENGTH(package))
FROM (
	SELECT DISTINCT(package)
	FROM ex_09.log_r) AS sub_q;

-- 9.10 Get the package whose downloading count ranks 2nd (print package name and it's download count).
SELECT package, cuantity
FROM (
	SELECT package, cuantity, RANK() OVER(ORDER BY cuantity DESC)
	FROM (
		SELECT package, COUNT(size) AS cuantity
		FROM ex_09.log_r
		WHERE DATE_PART('HOUR', time) >= 9 AND DATE_PART('HOUR', time) <= 11
		GROUP BY package
		) AS sub_q
	) AS sub_sub_q
WHERE rank = 2;

-- 9.11 Print the name of the package whose download count is bigger than 1000.
SELECT package, downloads
FROM (SELECT package, count(size) AS downloads FROM ex_09.log_r GROUP BY package) AS sub_q
WHERE downloads > 1000;

-- 9.12 The field "r_os" is the operating system of the users.
    -- 	Here we would like to know what main system we have (ignore version number), the relevant counts, and the proportion (in percentage).
SELECT *, (cuantity * 100 / (SELECT COUNT(r_os) FROM ex_09.log_R)) AS proportion
FROM (
	SELECT r_os, COUNT(r_os) as cuantity
	FROM ex_09.log_r 
	GROUP BY r_os
	) AS sub_q
ORDER BY proportion DESC
