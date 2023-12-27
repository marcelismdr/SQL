-- https://en.wikibooks.org/wiki/SQL_Exercises/Planet_Express 
-- 7.1 Who receieved a 1.5kg package?
    -- The result is "Al Gore's Head".
SELECT employee.name
FROM ex_06.employee AS employee
LEFT JOIN ex_06.shipment AS shipment ON employee.employeeID = shipment.manager
LEFT JOIN ex_06.package AS package ON shipment.shipmentID = package.shipment
WHERE package.weight = 1.5
;

-- 7.2 What is the total weight of all the packages that he sent?
SELECT SUM(package.weight) AS total_weight
FROM ex_06.employee AS employee
LEFT JOIN ex_06.shipment AS shipment ON employee.employeeID = shipment.manager
LEFT JOIN ex_06.package AS package ON shipment.shipmentID = package.shipment
WHERE employee.name = 
	(SELECT employee.name
	FROM ex_06.employee AS employee
	LEFT JOIN ex_06.shipment AS shipment ON employee.employeeID = shipment.manager
	LEFT JOIN ex_06.package AS package ON shipment.shipmentID = package.shipment
	WHERE package.weight = 1.5)
;