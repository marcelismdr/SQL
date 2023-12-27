-- The Warehouse
-- lINK: https://en.wikibooks.org/wiki/SQL_Exercises/The_warehouse

--3.1 Select all warehouses.
SELECT * FROM ex_03.warehouses;

--3.2 Select all boxes with a value larger than $150.
SELECT * FROM ex_03.boxes WHERE value > 150;

--3.3 Select all distinct contents in all the boxes.
SELECT DISTINCT(contents) FROM ex_03.boxes;

--3.4 Select the average value of all the boxes.
SELECT AVG(value) FROM ex_03.boxes;

--3.5 Select the warehouse code and the average value of the boxes in each warehouse.
SELECT a.code, AVG(b.value) AS boxes_avg_value
FROM ex_03.warehouses AS a
LEFT JOIN ex_03.boxes AS b ON a.code = b.warehouse
GROUP BY a.code;

--3.6 Same as previous exercise, but select only those warehouses where the average value of the boxes is greater than 150.
SELECT *
FROM(
	SELECT a.code, AVG(b.value) AS boxes_avg_value
	FROM ex_03.warehouses AS a
	LEFT JOIN ex_03.boxes AS b ON a.code = b.warehouse
	GROUP BY a.code) AS sub_q
WHERE boxes_avg_value > 150
;

--3.7 Select the code of each box, along with the name of the city the box is located in.
SELECT b.code, a.location
FROM ex_03.warehouses AS a
LEFT JOIN ex_03.boxes AS b ON a.code = b.warehouse
;

--3.8 Select the warehouse codes, along with the number of boxes in each warehouse. 
SELECT a.code, COUNT(a.code) AS num_of_boxes
FROM ex_03.warehouses AS a
LEFT JOIN ex_03.boxes AS b ON a.code = b.warehouse
GROUP BY a.code
;

--3.9 Select the codes of all warehouses that are saturated (a warehouse is saturated if the number of boxes in it is larger than the warehouse's capacity).
SELECT *
FROM(
	SELECT a.code, a.capacity, COUNT(b.code) AS num_of_boxes
	FROM ex_03.warehouses AS a
	LEFT JOIN ex_03.boxes AS b ON a.code = b.warehouse
	GROUP BY a.code, a.capacity) AS sub_q
WHERE num_of_boxes > capacity
;

--3.10 Select the codes of all the boxes located in Chicago.
SELECT code
FROM(
	SELECT b.code, a.location
	FROM ex_03.warehouses AS a
	LEFT JOIN ex_03.boxes AS b ON a.code = b.warehouse
	) AS sub_q
WHERE location = 'Chicago'
;

--3.11 Create a new warehouse in New York with a capacity for 3 boxes.
INSERT INTO ex_03.Warehouses(Code,Location,Capacity) VALUES(6,'New York',3);

--3.12 Create a new box, with code "H5RT", containing "Papers" with a value of $200, and located in warehouse 2.
INSERT INTO ex_03.boxes(code, contents, value, warehouse) VALUES('H5RT', 'Papers', 200, 2);

--3.13 Reduce the value of all boxes by 15%.
SELECT code, contents, value * 0.85 AS reduced_value, warehouse
FROM ex_03.boxes;

--3.14 Remove all boxes with a value lower than $100.
DELETE FROM ex_03.boxes
WHERE value < 100;

-- 3.15 Remove all boxes from saturated warehouses.
DELETE FROM ex_03.boxes
WHERE warehouse = (SELECT code
	FROM(
		SELECT a.code, a.capacity, COUNT(b.code) AS num_of_boxes
		FROM ex_03.warehouses AS a
		LEFT JOIN ex_03.boxes AS b ON a.code = b.warehouse
		GROUP BY a.code, a.capacity) AS sub_q
	WHERE num_of_boxes > capacity);
	
-- 3.16 Add Index for column "Warehouse" in table "boxes"
-- !!!NOTE!!!: index should NOT be used on small tables in practice
CREATE INDEX warehouse_index ON ex_03.boxes (warehouse);

-- 3.17 Print all the existing indexes
    -- !!!NOTE!!!: index should NOT be used on small tables in practice
SELECT * FROM pg_indexes WHERE schemaname = 'ex_03';

-- 3.18 Remove (drop) the index you added just
    -- !!!NOTE!!!: index should NOT be used on small tables in practice
DROP INDEX ex_03.warehouse_index;
