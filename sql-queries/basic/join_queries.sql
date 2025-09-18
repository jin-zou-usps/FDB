-- JOIN Queries
-- Collection of different types of JOIN operations

-- 1. INNER JOIN - employees with their departments
SELECT e.first_name, e.last_name, d.department_name 
FROM employees e
INNER JOIN departments d ON e.department_id = d.id;

-- 2. LEFT JOIN - all employees with department info (including those without department)
SELECT e.first_name, e.last_name, d.department_name 
FROM employees e
LEFT JOIN departments d ON e.department_id = d.id;

-- 3. RIGHT JOIN - all departments with employee info
SELECT e.first_name, e.last_name, d.department_name 
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.id;

-- 4. FULL OUTER JOIN - all employees and departments
SELECT e.first_name, e.last_name, d.department_name 
FROM employees e
FULL OUTER JOIN departments d ON e.department_id = d.id;

-- 5. Multiple JOINs - employees, departments, and locations
SELECT e.first_name, e.last_name, d.department_name, l.city, l.country
FROM employees e
INNER JOIN departments d ON e.department_id = d.id
INNER JOIN locations l ON d.location_id = l.id;

-- 6. Self JOIN - find employees and their managers
SELECT e1.first_name || ' ' || e1.last_name AS employee,
       e2.first_name || ' ' || e2.last_name AS manager
FROM employees e1
LEFT JOIN employees e2 ON e1.manager_id = e2.id;

-- 7. JOIN with WHERE clause
SELECT e.first_name, e.last_name, d.department_name 
FROM employees e
INNER JOIN departments d ON e.department_id = d.id
WHERE d.department_name = 'Engineering';

-- 8. JOIN with aggregation
SELECT d.department_name, COUNT(e.id) as employee_count
FROM departments d
LEFT JOIN employees e ON d.id = e.department_id
GROUP BY d.department_name;

-- 9. Complex JOIN with multiple conditions
SELECT e.first_name, e.last_name, p.project_name
FROM employees e
INNER JOIN employee_projects ep ON e.id = ep.employee_id
INNER JOIN projects p ON ep.project_id = p.id
WHERE p.status = 'Active' AND ep.role = 'Lead';