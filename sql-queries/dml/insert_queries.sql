-- INSERT Queries
-- Collection of INSERT operations

-- 1. Simple INSERT - single row
INSERT INTO employees (first_name, last_name, email, department, salary, hire_date)
VALUES ('John', 'Doe', 'john.doe@company.com', 'Engineering', 85000, '2024-01-15');

-- 2. INSERT multiple rows
INSERT INTO employees (first_name, last_name, email, department, salary, hire_date)
VALUES 
    ('Jane', 'Smith', 'jane.smith@company.com', 'Marketing', 72000, '2024-02-01'),
    ('Bob', 'Johnson', 'bob.johnson@company.com', 'Sales', 68000, '2024-02-15'),
    ('Alice', 'Williams', 'alice.williams@company.com', 'Engineering', 92000, '2024-03-01');

-- 3. INSERT with SELECT (copy data from another table)
INSERT INTO employees_backup (first_name, last_name, email, department, salary, hire_date)
SELECT first_name, last_name, email, department, salary, hire_date
FROM employees
WHERE hire_date >= '2024-01-01';

-- 4. INSERT with DEFAULT values
INSERT INTO employees (first_name, last_name, email, hire_date)
VALUES ('Test', 'User', 'test.user@company.com', DEFAULT);

-- 5. INSERT with conditional data
INSERT INTO employees (first_name, last_name, email, department, salary, hire_date)
SELECT 'New', 'Employee', 'new.employee@company.com', 'Engineering', 75000, CURRENT_DATE
WHERE NOT EXISTS (
    SELECT 1 FROM employees WHERE email = 'new.employee@company.com'
);

-- 6. INSERT with calculated values
INSERT INTO order_summary (order_date, total_orders, total_amount)
SELECT 
    order_date,
    COUNT(*) as total_orders,
    SUM(amount) as total_amount
FROM orders
WHERE order_date = CURRENT_DATE
GROUP BY order_date;

-- 7. INSERT with RETURNING clause (PostgreSQL/Oracle)
INSERT INTO employees (first_name, last_name, email, department, salary, hire_date)
VALUES ('New', 'Hire', 'new.hire@company.com', 'HR', 65000, CURRENT_DATE)
RETURNING id, first_name, last_name;

-- 8. INSERT with ON CONFLICT (PostgreSQL) / MERGE equivalent
INSERT INTO employees (id, first_name, last_name, email, department, salary)
VALUES (1, 'Updated', 'Name', 'updated@company.com', 'Engineering', 95000)
ON CONFLICT (id) 
DO UPDATE SET 
    first_name = EXCLUDED.first_name,
    last_name = EXCLUDED.last_name,
    email = EXCLUDED.email,
    salary = EXCLUDED.salary;