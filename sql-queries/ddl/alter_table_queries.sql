-- ALTER TABLE Queries
-- Collection of table modification statements

-- 1. Add new column
ALTER TABLE employees 
ADD COLUMN phone_number VARCHAR(20);

-- 2. Add multiple columns
ALTER TABLE employees 
ADD COLUMN birth_date DATE,
ADD COLUMN manager_id INTEGER;

-- 3. Modify column data type
ALTER TABLE employees 
ALTER COLUMN salary TYPE DECIMAL(12,2);

-- 4. Add NOT NULL constraint
ALTER TABLE employees 
ALTER COLUMN phone_number SET NOT NULL;

-- 5. Drop NOT NULL constraint
ALTER TABLE employees 
ALTER COLUMN phone_number DROP NOT NULL;

-- 6. Add primary key constraint
ALTER TABLE departments 
ADD CONSTRAINT pk_departments PRIMARY KEY (department_id);

-- 7. Add foreign key constraint
ALTER TABLE employees 
ADD CONSTRAINT fk_employees_manager 
FOREIGN KEY (manager_id) REFERENCES employees(id);

-- 8. Add unique constraint
ALTER TABLE employees 
ADD CONSTRAINT uk_employees_email UNIQUE (email);

-- 9. Add check constraint
ALTER TABLE employees 
ADD CONSTRAINT chk_employees_salary 
CHECK (salary > 0);

-- 10. Drop column
ALTER TABLE employees 
DROP COLUMN temp_column;

-- 11. Drop constraint
ALTER TABLE employees 
DROP CONSTRAINT chk_employees_salary;

-- 12. Rename column
ALTER TABLE employees 
RENAME COLUMN phone_number TO contact_number;

-- 13. Rename table
ALTER TABLE employees 
RENAME TO staff_members;

-- 14. Add default value
ALTER TABLE employees 
ALTER COLUMN hire_date SET DEFAULT CURRENT_DATE;

-- 15. Drop default value
ALTER TABLE employees 
ALTER COLUMN hire_date DROP DEFAULT;

-- 16. Add index
CREATE INDEX idx_employees_department 
ON employees(department);

-- 17. Add composite index
CREATE INDEX idx_employees_name 
ON employees(last_name, first_name);

-- 18. Add unique index
CREATE UNIQUE INDEX idx_employees_email_unique 
ON employees(email);

-- 19. Add partial index (PostgreSQL)
CREATE INDEX idx_active_employees 
ON employees(department) 
WHERE is_active = true;

-- 20. Drop index
DROP INDEX idx_employees_department;