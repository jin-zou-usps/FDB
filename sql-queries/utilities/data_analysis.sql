-- Data Analysis and Reporting Queries
-- Collection of analytical and reporting SQL queries

-- 1. Basic descriptive statistics
SELECT 
    COUNT(*) as total_count,
    AVG(salary) as mean_salary,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary) as median_salary,
    MIN(salary) as min_salary,
    MAX(salary) as max_salary,
    STDDEV(salary) as std_deviation,
    VARIANCE(salary) as variance
FROM employees;

-- 2. Quartile analysis
SELECT 
    department,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY salary) as q1_salary,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary) as median_salary,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY salary) as q3_salary,
    PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY salary) as p90_salary
FROM employees
GROUP BY department
ORDER BY median_salary DESC;

-- 3. Cohort analysis (customer retention)
WITH first_purchase AS (
    SELECT 
        customer_id,
        MIN(DATE_TRUNC('month', order_date)) as first_purchase_month
    FROM orders
    GROUP BY customer_id
),
monthly_activity AS (
    SELECT 
        fp.customer_id,
        fp.first_purchase_month,
        DATE_TRUNC('month', o.order_date) as activity_month,
        EXTRACT(EPOCH FROM (DATE_TRUNC('month', o.order_date) - fp.first_purchase_month)) / (30.44 * 24 * 3600) as month_diff
    FROM first_purchase fp
    JOIN orders o ON fp.customer_id = o.customer_id
)
SELECT 
    first_purchase_month,
    month_diff,
    COUNT(DISTINCT customer_id) as customers
FROM monthly_activity
WHERE month_diff BETWEEN 0 AND 12
GROUP BY first_purchase_month, month_diff
ORDER BY first_purchase_month, month_diff;

-- 4. Time series analysis
SELECT 
    DATE_TRUNC('week', order_date) as week,
    COUNT(*) as order_count,
    SUM(total_amount) as revenue,
    AVG(total_amount) as avg_order_value,
    COUNT(DISTINCT customer_id) as unique_customers
FROM orders
WHERE order_date >= CURRENT_DATE - INTERVAL '52 weeks'
GROUP BY DATE_TRUNC('week', order_date)
ORDER BY week;

-- 5. Customer segmentation (RFM Analysis)
WITH customer_metrics AS (
    SELECT 
        customer_id,
        MAX(order_date) as last_order_date,
        COUNT(*) as frequency,
        SUM(total_amount) as monetary_value,
        CURRENT_DATE - MAX(order_date) as recency_days
    FROM orders
    GROUP BY customer_id
),
rfm_scores AS (
    SELECT 
        customer_id,
        NTILE(5) OVER (ORDER BY recency_days ASC) as recency_score,
        NTILE(5) OVER (ORDER BY frequency) as frequency_score,
        NTILE(5) OVER (ORDER BY monetary_value) as monetary_score
    FROM customer_metrics
)
SELECT 
    CASE 
        WHEN recency_score >= 4 AND frequency_score >= 4 AND monetary_score >= 4 THEN 'Champions'
        WHEN recency_score >= 3 AND frequency_score >= 3 AND monetary_score >= 3 THEN 'Loyal Customers'
        WHEN recency_score >= 3 AND frequency_score <= 2 THEN 'Potential Loyalists'
        WHEN recency_score <= 2 AND frequency_score >= 3 THEN 'At Risk'
        WHEN recency_score <= 2 AND frequency_score <= 2 THEN 'Lost Customers'
        ELSE 'Others'
    END as customer_segment,
    COUNT(*) as customer_count,
    AVG(monetary_score) as avg_monetary_score
FROM rfm_scores
GROUP BY 1
ORDER BY customer_count DESC;

-- 6. Product affinity analysis (Market Basket Analysis)
WITH order_pairs AS (
    SELECT 
        oi1.order_id,
        oi1.product_id as product_a,
        oi2.product_id as product_b
    FROM order_items oi1
    JOIN order_items oi2 ON oi1.order_id = oi2.order_id
    WHERE oi1.product_id < oi2.product_id
),
product_combinations AS (
    SELECT 
        product_a,
        product_b,
        COUNT(*) as frequency
    FROM order_pairs
    GROUP BY product_a, product_b
),
product_totals AS (
    SELECT 
        product_id,
        COUNT(DISTINCT order_id) as total_orders
    FROM order_items
    GROUP BY product_id
)
SELECT 
    pc.product_a,
    pc.product_b,
    pc.frequency,
    pt1.total_orders as product_a_orders,
    pt2.total_orders as product_b_orders,
    pc.frequency::float / pt1.total_orders as confidence_a_to_b,
    pc.frequency::float / pt2.total_orders as confidence_b_to_a
FROM product_combinations pc
JOIN product_totals pt1 ON pc.product_a = pt1.product_id
JOIN product_totals pt2 ON pc.product_b = pt2.product_id
WHERE pc.frequency >= 5
ORDER BY pc.frequency DESC;

-- 7. Sales trend analysis with seasonality
SELECT 
    EXTRACT(year FROM order_date) as year,
    EXTRACT(month FROM order_date) as month,
    COUNT(*) as order_count,
    SUM(total_amount) as revenue,
    LAG(SUM(total_amount)) OVER (ORDER BY EXTRACT(year FROM order_date), EXTRACT(month FROM order_date)) as prev_month_revenue,
    (SUM(total_amount) - LAG(SUM(total_amount)) OVER (ORDER BY EXTRACT(year FROM order_date), EXTRACT(month FROM order_date))) / 
        LAG(SUM(total_amount)) OVER (ORDER BY EXTRACT(year FROM order_date), EXTRACT(month FROM order_date)) * 100 as growth_rate
FROM orders
GROUP BY EXTRACT(year FROM order_date), EXTRACT(month FROM order_date)
ORDER BY year, month;

-- 8. Employee performance analysis
SELECT 
    e.department,
    e.first_name,
    e.last_name,
    COUNT(p.project_id) as projects_count,
    AVG(p.completion_rate) as avg_completion_rate,
    SUM(p.budget) as total_project_budget,
    RANK() OVER (PARTITION BY e.department ORDER BY AVG(p.completion_rate) DESC) as dept_performance_rank
FROM employees e
LEFT JOIN employee_projects ep ON e.id = ep.employee_id
LEFT JOIN projects p ON ep.project_id = p.project_id
WHERE p.status = 'Completed'
GROUP BY e.department, e.id, e.first_name, e.last_name
HAVING COUNT(p.project_id) >= 3
ORDER BY e.department, avg_completion_rate DESC;