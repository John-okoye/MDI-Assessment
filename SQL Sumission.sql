DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
    ID INTEGER PRIMARY KEY,
    Name VARCHAR(30),
    Age INTEGER,
    Salary INTEGER,
    Bonus INTEGER,
    City VARCHAR(50),
    Dep_id INTEGER
);


INSERT INTO employees 
	(ID, Name, Age, Salary, Bonus, City, Dep_id) 
VALUES
	(1, 'Monika', 25, 1000, NULL, 'Palanga', 1),
	(2, 'Aidas', 51, 900, 300, 'Vilnius', 2),
	(3, 'Algimantas', 34, 1500, NULL, 'Vilnius', 2),
	(4, 'Julius', 42, 2300, 250, 'Vilnius', 3),
	(5, 'Vaidas', 33, 1700, NULL, 'Palanga', 3);
	


DROP TABLE IF EXISTS departments;
CREATE TABLE departments (
    ID INTEGER PRIMARY KEY,
    Name VARCHAR(30),
    Location VARCHAR(50),
    Budget_last_year INTEGER,
    Budget_this_year INTEGER,
    Mgr_id INTEGER
);

INSERT INTO departments 
	(ID, Name, Location, Budget_last_year, Budget_this_year, Mgr_id) 
VALUES
	(1, 'HR', 'Palanga', 10, 12, 1),
	(2, 'Sales', 'Vilnius', 20, 25, 2),
	(3, 'BI', 'Vilnius', NULL, 7, 5),
	(4, 'R+D', 'Vilnius', 5, 10, NULL);


--1. % of departments without managers
SELECT 
    ROUND((SUM(CASE WHEN Mgr_id IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*))) AS "%_departments_no_managers"
FROM departments;

--2. Department with the highest increase of budget from last year to this year, and budget amount increase
SELECT 
    Name AS "Department",
    (COALESCE(Budget_this_year, 0) - COALESCE(Budget_last_year, 0)) AS "Amount"
FROM departments
ORDER BY (Budget_this_year - Budget_last_year) DESC
LIMIT 1;

--3. For each employee, the name of department they manage
SELECT 
    e.Name AS "Employee Name",
    d.Name AS "Department"
FROM 
    employees e
LEFT JOIN departments d ON e.ID = d.Mgr_id;

--4. Name of each manager and average salary in they department
SELECT 
    e.Name AS Manager,
    ROUND(AVG(emp.Salary)) AS Amount
FROM 
    departments d
JOIN 
    employees e ON d.Mgr_id = e.ID
JOIN 
    employees emp ON d.ID = emp.Dep_id
GROUP BY 
    e.Name;

--5. For the department with highest budget this year, name of the manager, budget and department they manage.
SELECT 
	e.Name AS "Manager_Name", 
	d.Name AS "Department_Name", Budget_this_year AS "Budget"
FROM 
    departments d
JOIN 
    employees e ON d.Mgr_id = e.ID
ORDER BY 
    d.Budget_this_year DESC
LIMIT 1;


--6. Name of departments spending less than 2000 in salaries
SELECT 
	d.name "Department_Name"
FROM 
  departments d 
LEFT JOIN 
  employees e ON e.Dep_id = d.ID
GROUP BY d.name
HAVING SUM(COALESCE(e.Salary, 0)) < 2000


--7. For each manager, employee id and location of the department they manage
SELECT 
  e.ID AS "Employee_ID", 
  d.Location AS "Location"
FROM 
  departments d 
JOIN 
  employees e ON d.Mgr_id = e.ID 

--8. Number of departments managed by an employee belonging to another department 
SELECT 
    COUNT(*) AS "# departments"
FROM 
    departments d
JOIN 
    employees e ON d.Mgr_id = e.ID
WHERE 
    d.ID <> e.Dep_id;
