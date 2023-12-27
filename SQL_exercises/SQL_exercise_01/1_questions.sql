-- LINK: https://en.wikibooks.org/wiki/SQL_Exercises/The_computer_store

-- 1.1 Select the names of all the products in the store.
SELECT * FROM ex_01.products;

-- 1.2 Select the names and the prices of all the products in the store.
SELECT name, price FROM ex_01.products;

-- 1.3 Select the name of the products with a price less than or equal to $200.
SELECT name, price FROM ex_01.products WHERE price <= 200;

-- 1.4 Select all the products with a price between $60 and $120.
SELECT name, price FROM ex_01.products WHERE price BETWEEN 60 and 120;

-- 1.5 Select the name and price in cents (i.e., the price must be multiplied by 100).
SELECT name, price * 100 as cents FROM ex_01.products;

-- 1.6 Compute the average price of all the products.
SELECT AVG(price) FROM ex_01.products;

-- 1.7 Compute the average price of all products with manufacturer code equal to 2.
SELECT AVG(price) FROM ex_01.products WHERE manufacturer = 2;

-- 1.8 Compute the number of products with a price larger than or equal to $180.
SELECT COUNT(name) FROM ex_01.products WHERE price >= 180;

-- 1.9 Select the name and price of all products with a price larger than or equal to $180, 
-- and sort first by price (in descending order), and then by name (in ascending order).
SELECT name, price FROM ex_01.products WHERE price >= 180 ORDER BY price DESC, name ASC;

-- 1.10 Select all the data from the products, including all the data for each product's manufacturer.
SELECT name, price FROM ex_01.products WHERE price >= 180 ORDER BY price DESC, name ASC;

-- 1.11 Select the product name, price, and manufacturer name of all the products.
SELECT a.name AS product_name, a.price AS product_price, b.name AS manufacturer_name
FROM ex_01.products AS a
LEFT JOIN ex_01.manufacturers as b ON a.manufacturer = b.code;

-- 1.12 Select the average price of each manufacturer's products, showing only the manufacturer's code.
SELECT manufacturer, AVG(price) FROM ex_01.products GROUP BY manufacturer;

-- 1.13 Select the average price of each manufacturer's products, showing the manufacturer's name.
SELECT b.name, AVG(a.price) 
FROM ex_01.products as a
LEFT JOIN ex_01.manufacturers as b ON a.manufacturer = b.code
GROUP BY b.name;

-- 1.14 Select the names of manufacturer whose products have an average price larger than or equal to $150.
SELECT *
FROM(
	SELECT b.name, AVG(a.price) as avg_price
	FROM ex_01.products as a
	LEFT JOIN ex_01.manufacturers as b ON a.manufacturer = b.code
	GROUP BY b.name
	) as sub_q
WHERE avg_price >= 150;

-- 1.15 Select the name and price of the cheapest product.
SELECT name, price FROM ex_01.products ORDER BY price ASC LIMIT 1;

-- 1.16 Select the name of each manufacturer along with the name and price of its most expensive product.
SELECT manufacturer, product, price
FROM(
	SELECT  b.name AS manufacturer, a.name AS product, a.price, RANK() OVER(PARTITION BY b.name ORDER BY a.price DESC) as ranking
	FROM ex_01.products as a
	LEFT JOIN ex_01.manufacturers as b ON a.manufacturer = b.code
	) AS sub_q
WHERE ranking = 1
;
	
-- 1.17 Add a new product: Loudspeakers, $70, manufacturer 2.
INSERT INTO ex_01.products(Code,Name,Price,Manufacturer) VALUES(11,'Loudspeakers',70,2);

-- 1.18 Update the name of product 8 to "Laser Printer".
UPDATE ex_01.products
SET name = 'Lacer Printer'
WHERE code = 8;

-- 1.19 Apply a 10% discount to all products.
SELECT code, name, price * 0.9 AS discounted_price, manufacturer FROM ex_01.products;

-- 1.20 Apply a 10% discount to all products with a price larger than or equal to $120.
SELECT code, name, price * 0.9 AS discounted_price, manufacturer FROM ex_01.products WHERE price >= 120;