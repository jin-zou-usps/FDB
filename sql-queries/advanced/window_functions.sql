-- Window Functions
-- Collection of analytical window function examples

-- 1. ROW_NUMBER() - assign unique sequential numbers
SELECT 
    first_name, last_name, department, salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC) as salary_rank
FROM employees;

-- 2. RANK() and DENSE_RANK() - ranking with ties
SELECT 
    first_name, last_name, department, salary,
    RANK() OVER (ORDER BY salary DESC) as rank,
    DENSE_RANK() OVER (ORDER BY salary DESC) as dense_rank
FROM employees;

-- 3. PARTITION BY - separate ranking by department
SELECT 
    first_name, last_name, department, salary,
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) as dept_rank
FROM employees;

-- 4. NTILE() - divide into equal groups
SELECT 
    first_name, last_name, salary,
    NTILE(4) OVER (ORDER BY salary DESC) as salary_quartile
FROM employees;

-- 5. LAG() and LEAD() - access previous/next rows
SELECT 
    first_name, last_name, salary,
    LAG(salary, 1) OVER (ORDER BY hire_date) as previous_hire_salary,
    LEAD(salary, 1) OVER (ORDER BY hire_date) as next_hire_salary
FROM employees;

-- 6. FIRST_VALUE() and LAST_VALUE()
SELECT 
    first_name, last_name, department, salary,
    FIRST_VALUE(salary) OVER (PARTITION BY department ORDER BY hire_date) as first_dept_salary,
    LAST_VALUE(salary) OVER (
        PARTITION BY department 
        ORDER BY hire_date 
        RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) as last_dept_salary
FROM employees;

-- 7. Running totals with SUM() window function
SELECT 
    order_date, order_id, total_amount,
    SUM(total_amount) OVER (ORDER BY order_date) as running_total
FROM orders
ORDER BY order_date;

-- 8. Moving average
SELECT 
    order_date, total_amount,
    AVG(total_amount) OVER (
        ORDER BY order_date 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) as seven_day_avg
FROM daily_sales
ORDER BY order_date;

-- 9. Percent of total
SELECT 
    department, 
    SUM(salary) as dept_total,
    SUM(salary) * 100.0 / SUM(SUM(salary)) OVER () as percent_of_total
FROM employees
GROUP BY department;

-- 10. CUME_DIST() and PERCENT_RANK()
SELECT 
    first_name, last_name, salary,
    CUME_DIST() OVER (ORDER BY salary) as cumulative_dist,
    PERCENT_RANK() OVER (ORDER BY salary) as percent_rank
FROM employees;

-- 11. Complex window function with multiple partitions
SELECT 
    department, hire_date, first_name, last_name, salary,
    AVG(salary) OVER (PARTITION BY department) as dept_avg_salary,
    salary - AVG(salary) OVER (PARTITION BY department) as salary_vs_dept_avg,
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY hire_date) as hire_order_in_dept
FROM employees;

-- 12. Window function with custom frame
SELECT 
    order_date, daily_revenue,
    SUM(daily_revenue) OVER (
        ORDER BY order_date 
        ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING
    ) as five_day_total
FROM daily_revenue
ORDER BY order_date;