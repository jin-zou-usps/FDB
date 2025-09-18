-- FDB SQL Queries: Find data that exists in table A but not in table B
-- This file contains SQL queries for finding differences between two tables

-- Query 1: Find records in table_a that don't exist in table_b
-- This uses a LEFT JOIN to find records in A that have no match in B
SELECT a.*
FROM table_a a
LEFT JOIN table_b b ON a.name = b.name AND a.value = b.value
WHERE b.name IS NULL
ORDER BY a.id;

-- Query 2: Find records in table_b that don't exist in table_a
-- This uses a LEFT JOIN to find records in B that have no match in A
SELECT b.*
FROM table_b b
LEFT JOIN table_a a ON b.name = a.name AND b.value = a.value
WHERE a.name IS NULL
ORDER BY b.id;

-- Alternative Query using NOT EXISTS (may be more efficient for large datasets)
-- Find records in table_a that don't exist in table_b using NOT EXISTS
SELECT a.*
FROM table_a a
WHERE NOT EXISTS (
    SELECT 1 
    FROM table_b b 
    WHERE a.name = b.name AND a.value = b.value
)
ORDER BY a.id;

-- Alternative Query using EXCEPT (PostgreSQL, SQL Server)
-- Note: This is not supported in SQLite but works in other databases
-- SELECT id, name, value FROM table_a
-- EXCEPT
-- SELECT id, name, value FROM table_b;

-- Query to compare tables and show counts
SELECT 
    'table_a' as table_name,
    COUNT(*) as total_records,
    COUNT(DISTINCT name) as unique_names
FROM table_a
UNION ALL
SELECT 
    'table_b' as table_name,
    COUNT(*) as total_records,
    COUNT(DISTINCT name) as unique_names
FROM table_b;