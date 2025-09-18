-- Basic SELECT Queries
-- Collection of fundamental SELECT operations

-- 1. Simple SELECT - retrieve all columns
SELECT * FROM employees;

-- 2. SELECT specific columns
SELECT first_name, last_name, email FROM employees;

-- 3. SELECT with WHERE clause
SELECT * FROM employees 
WHERE department = 'Engineering';

-- 4. SELECT with multiple conditions
SELECT * FROM employees 
WHERE department = 'Engineering' 
  AND salary > 75000;

-- 5. SELECT with OR condition
SELECT * FROM employees 
WHERE department = 'Engineering' 
   OR department = 'Marketing';

-- 6. SELECT with IN clause
SELECT * FROM employees 
WHERE department IN ('Engineering', 'Marketing', 'Sales');

-- 7. SELECT with LIKE pattern matching
SELECT * FROM employees 
WHERE last_name LIKE 'Smith%';

-- 8. SELECT with ORDER BY
SELECT * FROM employees 
ORDER BY last_name ASC, first_name ASC;

-- 9. SELECT with LIMIT
SELECT * FROM employees 
ORDER BY salary DESC 
LIMIT 10;

-- 10. SELECT DISTINCT values
SELECT DISTINCT department FROM employees;

-- 11. SELECT with NULL checks
SELECT * FROM employees 
WHERE phone_number IS NOT NULL;

-- 12. SELECT with date range
SELECT * FROM orders 
WHERE order_date BETWEEN '2023-01-01' AND '2023-12-31';