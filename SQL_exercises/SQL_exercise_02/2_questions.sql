-- LINK : https://en.wikibooks.org/wiki/SQL_Exercises/Employee_management

-- 2.1 Select the last name of all employees.
SELECT lastname FROM ex_02.employees;

-- 2.2 Select the last name of all employees, without duplicates.
SELECT DISTINCT(lastname) FROM ex_02.employees;

-- 2.3 Select all the data of employees whose last name is "Smith".
SELECT * FROM ex_02.employees WHERE lastname = 'Smith';

-- 2.4 Select all the data of employees whose last name is "Smith" or "Doe".
SELECT * FROM ex_02.employees WHERE lastname = 'Smith' OR lastname = 'Doe';

-- 2.5 Select all the data of employees that work in department 14.
SELECT * FROM ex_02.employees WHERE department = 14;

-- 2.6 Select all the data of employees that work in department 37 or department 77.
SELECT * FROM ex_02.employees WHERE department = 37 OR department = 77;

-- 2.7 Select all the data of employees whose last name begins with an "S".
SELECT * FROM ex_02.employees WHERE LEFT(lastname, 1) = 'S';

-- 2.8 Select the sum of all the departments' budgets.
SELECT SUM(budget) FROM ex_02.departments;

-- 2.9 Select the number of employees in each department (you only need to show the department code and the number of employees).
SELECT department, COUNT(name) AS number_of_employees
FROM ex_02.employees
GROUP BY department;

-- 2.10 Select all the data of employees, including each employee's department's data.
SELECT *
FROM ex_02.employees AS a
FULL OUTER JOIN ex_02.departments AS b ON a.department = b.code;

-- 2.11 Select the name and last name of each employee, along with the name and budget of the employee's department.
SELECT a.name, a.lastname, b.name AS department, b.budget
FROM ex_02.employees AS a
LEFT JOIN ex_02.departments AS b ON a.department = b.code;

-- 2.12 Select the name and last name of employees working for departments with a budget greater than $60,000.
SELECT a.name, a.lastname, b.name AS department, b.budget
FROM ex_02.employees AS a
LEFT JOIN ex_02.departments AS b ON a.department = b.code
WHERE b.budget >= 60000;

-- 2.13 Select the departments with a budget larger than the average budget of all the departments.
SELECT *
FROM ex_02.departments
WHERE budget > (
	SELECT AVG(budget)
	FROM ex_02.departments
	);

-- 2.14 Select the names of departments with more than two employees.
SELECT *
FROM(
	SELECT department, COUNT(name) AS number_of_employees
	FROM ex_02.employees
	GROUP BY department	
	) AS sub_q
WHERE number_of_employees > 2
;

-- 2.15 Very Important - Select the name and last name of employees working for departments with second lowest budget.
SELECT name, lastname
FROM ex_02.employees
WHERE department = (
	SELECT code
	FROM ex_02.departments
	ORDER BY budget DESC
	LIMIT 1 OFFSET 1
	)
; 

-- 2.16  Add a new department called "Quality Assurance", with a budget of $40,000 and departmental code 11. 
INSERT INTO ex_02.Departments(Code,Name,Budget) VALUES(11,'Quality Assurance',40000);

-- And Add an employee called "Mary Moore" in that department, with SSN 847-21-9811.
INSERT INTO ex_02.Employees(SSN,Name,LastName,Department) VALUES('847219811','Mary','Moore',11);

-- 2.17 Reduce the budget of all departments by 10%.
SELECT code, name, budget * 0.9 AS reduced_budget
FROM ex_02.Departments;

-- 2.18 Reassign all employees from the Research department (code 77) to the IT department (code 14).
UPDATE ex_02.employees
SET department = 14
WHERE department = 77;

-- 2.19 Delete from the table all employees in the IT department (code 14).
DELETE FROM ex_02.employees
WHERE department = 14;

-- 2.20 Delete from the table all employees who work in departments with a budget greater than or equal to $60,000.
DELETE FROM ex_02.employees
WHERE ssn IN (
	SELECT ssn
	FROM ex_02.employees AS a
	LEFT JOIN ex_02.departments AS b ON a.department = b.code
	WHERE budget >= 60000);

-- 2.21 Delete from the table all employees.
DELETE FROM ex_02.employees
