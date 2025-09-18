-- UPDATE Queries
-- Collection of UPDATE operations

-- 1. Simple UPDATE - single column
UPDATE employees 
SET salary = 90000 
WHERE id = 1;

-- 2. UPDATE multiple columns
UPDATE employees 
SET salary = 95000, 
    department = 'Senior Engineering',
    last_modified = CURRENT_TIMESTAMP
WHERE id = 1;

-- 3. UPDATE with WHERE clause - multiple records
UPDATE employees 
SET salary = salary * 1.05 
WHERE department = 'Engineering';

-- 4. UPDATE with calculated values
UPDATE employees 
SET salary = salary + (salary * 0.1),
    bonus = salary * 0.15
WHERE performance_rating >= 4;

-- 5. UPDATE with subquery
UPDATE employees 
SET salary = (
    SELECT AVG(salary) * 1.1 
    FROM employees e2 
    WHERE e2.department = employees.department
)
WHERE department = 'Marketing';

-- 6. UPDATE with JOIN (varies by database)
-- PostgreSQL/MySQL syntax:
UPDATE employees e
SET salary = e.salary + 5000
FROM departments d
WHERE e.department_id = d.id 
  AND d.budget_increase > 0.1;

-- 7. Conditional UPDATE with CASE
UPDATE employees 
SET bonus = CASE 
    WHEN performance_rating >= 5 THEN salary * 0.2
    WHEN performance_rating >= 4 THEN salary * 0.15
    WHEN performance_rating >= 3 THEN salary * 0.1
    ELSE 0
END
WHERE hire_date < '2024-01-01';

-- 8. UPDATE with multiple conditions
UPDATE employees 
SET status = 'Senior',
    salary = salary + 10000
WHERE years_of_experience >= 5 
  AND department IN ('Engineering', 'Data Science')
  AND performance_rating >= 4;

-- 9. UPDATE with RETURNING clause (PostgreSQL)
UPDATE employees 
SET salary = salary * 1.1 
WHERE department = 'Sales'
RETURNING id, first_name, last_name, salary;

-- 10. UPDATE with EXISTS condition
UPDATE employees 
SET eligible_for_promotion = true
WHERE EXISTS (
    SELECT 1 FROM certifications c 
    WHERE c.employee_id = employees.id 
    AND c.certification_level = 'Advanced'
);