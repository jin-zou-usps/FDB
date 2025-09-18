-- Common Table Expressions (CTEs)
-- Collection of CTE examples and patterns

-- 1. Simple CTE
WITH high_earners AS (
    SELECT * FROM employees 
    WHERE salary > 80000
)
SELECT department, COUNT(*) as high_earner_count
FROM high_earners
GROUP BY department;

-- 2. Multiple CTEs
WITH 
engineering_employees AS (
    SELECT * FROM employees WHERE department = 'Engineering'
),
high_salaries AS (
    SELECT * FROM engineering_employees WHERE salary > 90000
)
SELECT first_name, last_name, salary
FROM high_salaries
ORDER BY salary DESC;

-- 3. Recursive CTE - Employee hierarchy
WITH RECURSIVE employee_hierarchy AS (
    -- Base case: top-level employees (no manager)
    SELECT id, first_name, last_name, manager_id, 1 as level
    FROM employees 
    WHERE manager_id IS NULL
    
    UNION ALL
    
    -- Recursive case: employees with managers
    SELECT e.id, e.first_name, e.last_name, e.manager_id, eh.level + 1
    FROM employees e
    INNER JOIN employee_hierarchy eh ON e.manager_id = eh.id
)
SELECT * FROM employee_hierarchy
ORDER BY level, last_name;

-- 4. CTE with aggregation
WITH department_stats AS (
    SELECT 
        department,
        COUNT(*) as employee_count,
        AVG(salary) as avg_salary,
        MAX(salary) as max_salary
    FROM employees
    GROUP BY department
)
SELECT 
    department,
    employee_count,
    ROUND(avg_salary, 2) as avg_salary,
    max_salary,
    CASE 
        WHEN avg_salary > 75000 THEN 'High Paying'
        WHEN avg_salary > 50000 THEN 'Medium Paying'
        ELSE 'Lower Paying'
    END as pay_category
FROM department_stats
ORDER BY avg_salary DESC;

-- 5. Recursive CTE - Generate series
WITH RECURSIVE date_series AS (
    SELECT DATE '2024-01-01' as date_value
    
    UNION ALL
    
    SELECT date_value + INTERVAL '1 day'
    FROM date_series
    WHERE date_value < DATE '2024-12-31'
)
SELECT date_value
FROM date_series
WHERE EXTRACT(DOW FROM date_value) = 1; -- Mondays only

-- 6. CTE for complex calculations
WITH monthly_sales AS (
    SELECT 
        DATE_TRUNC('month', order_date) as month,
        SUM(total_amount) as monthly_total
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)
),
sales_with_growth AS (
    SELECT 
        month,
        monthly_total,
        LAG(monthly_total) OVER (ORDER BY month) as previous_month,
        monthly_total - LAG(monthly_total) OVER (ORDER BY month) as growth_amount
    FROM monthly_sales
)
SELECT 
    month,
    monthly_total,
    previous_month,
    growth_amount,
    CASE 
        WHEN previous_month IS NULL THEN NULL
        ELSE ROUND((growth_amount / previous_month) * 100, 2)
    END as growth_percentage
FROM sales_with_growth
ORDER BY month;

-- 7. CTE with window functions
WITH ranked_employees AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) as dept_rank,
        DENSE_RANK() OVER (ORDER BY salary DESC) as company_rank
    FROM employees
)
SELECT 
    first_name, last_name, department, salary,
    dept_rank, company_rank
FROM ranked_employees
WHERE dept_rank <= 3; -- Top 3 in each department

-- 8. Recursive CTE - Bill of Materials
WITH RECURSIVE bom_explosion AS (
    -- Base case: top-level product
    SELECT 
        product_id, 
        component_id, 
        quantity,
        1 as level,
        CAST(product_id AS VARCHAR(1000)) as path
    FROM bill_of_materials
    WHERE product_id = 'LAPTOP-001'
    
    UNION ALL
    
    -- Recursive case: sub-components
    SELECT 
        bom.product_id,
        bom.component_id,
        bom.quantity * be.quantity as total_quantity,
        be.level + 1,
        be.path || '->' || bom.component_id
    FROM bill_of_materials bom
    INNER JOIN bom_explosion be ON bom.product_id = be.component_id
    WHERE be.level < 10 -- Prevent infinite recursion
)
SELECT level, component_id, total_quantity, path
FROM bom_explosion
ORDER BY level, component_id;