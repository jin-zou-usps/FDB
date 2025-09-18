-- Aggregation Queries
-- Collection of GROUP BY, HAVING, and aggregate function queries

-- 1. COUNT - count employees by department
SELECT department, COUNT(*) as employee_count
FROM employees
GROUP BY department;

-- 2. SUM - total salary by department
SELECT department, SUM(salary) as total_salary
FROM employees
GROUP BY department;

-- 3. AVG - average salary by department
SELECT department, AVG(salary) as average_salary
FROM employees
GROUP BY department;

-- 4. MIN/MAX - salary range by department
SELECT department, 
       MIN(salary) as min_salary,
       MAX(salary) as max_salary
FROM employees
GROUP BY department;

-- 5. HAVING clause - departments with more than 5 employees
SELECT department, COUNT(*) as employee_count
FROM employees
GROUP BY department
HAVING COUNT(*) > 5;

-- 6. Multiple aggregations
SELECT department,
       COUNT(*) as total_employees,
       AVG(salary) as avg_salary,
       MIN(hire_date) as earliest_hire,
       MAX(hire_date) as latest_hire
FROM employees
GROUP BY department;

-- 7. GROUP BY with ORDER BY
SELECT department, COUNT(*) as employee_count
FROM employees
GROUP BY department
ORDER BY employee_count DESC;

-- 8. Nested aggregation with subquery
SELECT department, avg_salary
FROM (
    SELECT department, AVG(salary) as avg_salary
    FROM employees
    GROUP BY department
) dept_avg
WHERE avg_salary > 70000;

-- 9. ROLLUP - hierarchical totals
SELECT department, job_title, COUNT(*) as count
FROM employees
GROUP BY ROLLUP(department, job_title)
ORDER BY department, job_title;

-- 10. Count with conditions
SELECT 
    COUNT(CASE WHEN salary > 75000 THEN 1 END) as high_earners,
    COUNT(CASE WHEN salary <= 75000 THEN 1 END) as regular_earners
FROM employees;