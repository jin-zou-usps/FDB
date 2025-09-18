-- Subquery Examples
-- Collection of subquery patterns and techniques

-- 1. Scalar subquery in SELECT
SELECT first_name, last_name, salary,
       (SELECT AVG(salary) FROM employees) as company_avg_salary,
       salary - (SELECT AVG(salary) FROM employees) as salary_diff
FROM employees;

-- 2. Subquery in WHERE clause
SELECT * FROM employees
WHERE salary > (
    SELECT AVG(salary) 
    FROM employees 
    WHERE department = 'Engineering'
);

-- 3. EXISTS subquery
SELECT * FROM customers c
WHERE EXISTS (
    SELECT 1 FROM orders o 
    WHERE o.customer_id = c.customer_id 
    AND o.order_date >= '2024-01-01'
);

-- 4. NOT EXISTS subquery
SELECT * FROM products p
WHERE NOT EXISTS (
    SELECT 1 FROM order_items oi 
    WHERE oi.product_id = p.product_id
);

-- 5. IN subquery
SELECT * FROM employees
WHERE department_id IN (
    SELECT id FROM departments 
    WHERE budget > 1000000
);

-- 6. NOT IN subquery (careful with NULLs)
SELECT * FROM employees
WHERE department_id NOT IN (
    SELECT id FROM departments 
    WHERE budget < 500000 
    AND id IS NOT NULL
);

-- 7. Correlated subquery
SELECT e1.first_name, e1.last_name, e1.salary, e1.department
FROM employees e1
WHERE e1.salary > (
    SELECT AVG(e2.salary) 
    FROM employees e2 
    WHERE e2.department = e1.department
);

-- 8. Subquery in FROM clause (derived table)
SELECT dept_stats.department, dept_stats.avg_salary
FROM (
    SELECT department, AVG(salary) as avg_salary
    FROM employees
    GROUP BY department
) dept_stats
WHERE dept_stats.avg_salary > 75000;

-- 9. Multiple column subquery
SELECT * FROM employees
WHERE (department, salary) IN (
    SELECT department, MAX(salary)
    FROM employees
    GROUP BY department
);

-- 10. Nested subqueries
SELECT * FROM employees
WHERE salary > (
    SELECT AVG(salary) FROM employees
    WHERE department IN (
        SELECT department_name FROM departments
        WHERE location = 'New York'
    )
);

-- 11. ANY/SOME subquery
SELECT * FROM employees
WHERE salary > ANY (
    SELECT salary FROM employees
    WHERE department = 'Sales'
);

-- 12. ALL subquery
SELECT * FROM employees
WHERE salary > ALL (
    SELECT salary FROM employees
    WHERE department = 'Intern'
);

-- 13. Subquery with aggregation
SELECT customer_name,
       (SELECT COUNT(*) FROM orders o WHERE o.customer_id = c.customer_id) as order_count,
       (SELECT SUM(total_amount) FROM orders o WHERE o.customer_id = c.customer_id) as total_spent
FROM customers c;