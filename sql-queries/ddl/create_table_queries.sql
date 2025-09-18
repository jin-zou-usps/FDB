-- CREATE TABLE Queries
-- Collection of table creation statements

-- 1. Basic table creation
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    hire_date DATE DEFAULT CURRENT_DATE,
    salary DECIMAL(10,2),
    department VARCHAR(50)
);

-- 2. Table with various data types
CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    weight DECIMAL(8,3),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    category_id INTEGER,
    sku VARCHAR(50) UNIQUE
);

-- 3. Table with foreign key constraints
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(12,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);

-- 4. Table with multiple constraints
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
    discount_percent DECIMAL(5,2) DEFAULT 0 CHECK (discount_percent BETWEEN 0 AND 100),
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    UNIQUE(order_id, product_id)
);

-- 5. Table with composite primary key
CREATE TABLE employee_projects (
    employee_id INTEGER,
    project_id INTEGER,
    role VARCHAR(50),
    start_date DATE NOT NULL,
    end_date DATE,
    allocation_percent DECIMAL(5,2) DEFAULT 100,
    PRIMARY KEY (employee_id, project_id),
    FOREIGN KEY (employee_id) REFERENCES employees(id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id),
    CHECK (end_date IS NULL OR end_date >= start_date)
);

-- 6. Temporary table
CREATE TEMPORARY TABLE temp_calculations (
    id SERIAL PRIMARY KEY,
    calculation_value DECIMAL(15,4),
    calculation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 7. Table with JSON/JSONB column (PostgreSQL)
CREATE TABLE user_preferences (
    user_id INTEGER PRIMARY KEY,
    preferences JSONB,
    settings JSONB DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 8. Partitioned table (PostgreSQL)
CREATE TABLE sales_data (
    sale_id SERIAL,
    sale_date DATE NOT NULL,
    amount DECIMAL(10,2),
    customer_id INTEGER,
    region VARCHAR(50)
) PARTITION BY RANGE (sale_date);

-- 9. Table with generated columns (MySQL 5.7+/PostgreSQL 12+)
CREATE TABLE order_summary (
    order_id INTEGER PRIMARY KEY,
    subtotal DECIMAL(10,2) NOT NULL,
    tax_rate DECIMAL(5,4) NOT NULL,
    tax_amount DECIMAL(10,2) GENERATED ALWAYS AS (subtotal * tax_rate) STORED,
    total_amount DECIMAL(10,2) GENERATED ALWAYS AS (subtotal + tax_amount) STORED
);

-- 10. Create table from query results
CREATE TABLE high_value_customers AS
SELECT customer_id, 
       SUM(total_amount) as lifetime_value,
       COUNT(*) as order_count
FROM orders 
GROUP BY customer_id 
HAVING SUM(total_amount) > 10000;