-- DELETE Queries
-- Collection of DELETE operations

-- 1. Simple DELETE - single record
DELETE FROM employees WHERE id = 100;

-- 2. DELETE with WHERE clause - multiple records
DELETE FROM employees 
WHERE department = 'Temp' 
  AND hire_date < '2023-01-01';

-- 3. DELETE with IN clause
DELETE FROM employees 
WHERE id IN (101, 102, 103, 104);

-- 4. DELETE with subquery
DELETE FROM employees 
WHERE id IN (
    SELECT employee_id 
    FROM terminations 
    WHERE termination_date <= CURRENT_DATE
);

-- 5. DELETE with EXISTS condition
DELETE FROM employees 
WHERE EXISTS (
    SELECT 1 FROM performance_reviews pr 
    WHERE pr.employee_id = employees.id 
    AND pr.rating < 2 
    AND pr.review_date >= CURRENT_DATE - INTERVAL '1 year'
);

-- 6. DELETE with JOIN (varies by database)
-- MySQL syntax:
DELETE e FROM employees e
INNER JOIN departments d ON e.department_id = d.id
WHERE d.status = 'Closed';

-- PostgreSQL syntax:
DELETE FROM employees 
USING departments d 
WHERE employees.department_id = d.id 
  AND d.status = 'Closed';

-- 7. DELETE with multiple conditions
DELETE FROM orders 
WHERE order_date < '2023-01-01' 
  AND status = 'Cancelled' 
  AND total_amount = 0;

-- 8. DELETE with LIMIT (MySQL)
DELETE FROM audit_logs 
WHERE created_date < DATE_SUB(CURRENT_DATE, INTERVAL 90 DAY)
ORDER BY created_date ASC 
LIMIT 1000;

-- 9. DELETE with RETURNING clause (PostgreSQL)
DELETE FROM employees 
WHERE status = 'Inactive' 
  AND last_login < CURRENT_DATE - INTERVAL '1 year'
RETURNING id, first_name, last_name, last_login;

-- 10. Soft DELETE (update instead of delete)
UPDATE employees 
SET is_deleted = true, 
    deleted_date = CURRENT_TIMESTAMP 
WHERE id = 100;

-- 11. DELETE all records (use with caution!)
-- DELETE FROM temp_table;

-- 12. DELETE with NOT EXISTS
DELETE FROM old_employees 
WHERE NOT EXISTS (
    SELECT 1 FROM current_employees ce 
    WHERE ce.employee_number = old_employees.employee_number
);