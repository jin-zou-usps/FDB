-- DROP and CREATE Operations
-- Collection of DROP statements and database object creation

-- 1. Drop table
DROP TABLE IF EXISTS temp_employees;

-- 2. Drop table with CASCADE (removes dependent objects)
DROP TABLE employees CASCADE;

-- 3. Drop multiple tables
DROP TABLE IF EXISTS table1, table2, table3;

-- 4. Create and drop database
CREATE DATABASE company_db;
DROP DATABASE IF EXISTS old_company_db;

-- 5. Create and drop schema
CREATE SCHEMA hr;
DROP SCHEMA IF EXISTS old_hr CASCADE;

-- 6. Create view
CREATE VIEW active_employees AS
SELECT id, first_name, last_name, department, salary
FROM employees
WHERE is_active = true;

-- 7. Create materialized view (PostgreSQL)
CREATE MATERIALIZED VIEW department_stats AS
SELECT 
    department,
    COUNT(*) as employee_count,
    AVG(salary) as avg_salary,
    MIN(hire_date) as earliest_hire
FROM employees
GROUP BY department;

-- 8. Drop view
DROP VIEW IF EXISTS active_employees;

-- 9. Create stored procedure (PostgreSQL)
CREATE OR REPLACE FUNCTION get_employee_count(dept_name VARCHAR)
RETURNS INTEGER AS $$
BEGIN
    RETURN (SELECT COUNT(*) FROM employees WHERE department = dept_name);
END;
$$ LANGUAGE plpgsql;

-- 10. Drop function
DROP FUNCTION IF EXISTS get_employee_count(VARCHAR);

-- 11. Create trigger
CREATE OR REPLACE FUNCTION update_last_modified()
RETURNS TRIGGER AS $$
BEGIN
    NEW.last_modified = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER employees_update_last_modified
    BEFORE UPDATE ON employees
    FOR EACH ROW
    EXECUTE FUNCTION update_last_modified();

-- 12. Drop trigger
DROP TRIGGER IF EXISTS employees_update_last_modified ON employees;

-- 13. Create sequence
CREATE SEQUENCE employee_id_seq
    START WITH 1000
    INCREMENT BY 1
    MINVALUE 1000
    MAXVALUE 999999
    CACHE 10;

-- 14. Drop sequence
DROP SEQUENCE IF EXISTS employee_id_seq;

-- 15. Create role/user
CREATE ROLE hr_manager WITH LOGIN PASSWORD 'secure_password';
CREATE USER app_user WITH PASSWORD 'app_password';

-- 16. Grant permissions
GRANT SELECT, INSERT, UPDATE ON employees TO hr_manager;
GRANT ALL PRIVILEGES ON DATABASE company_db TO app_user;

-- 17. Revoke permissions
REVOKE UPDATE ON employees FROM hr_manager;

-- 18. Drop role/user
DROP ROLE IF EXISTS hr_manager;
DROP USER IF EXISTS app_user;