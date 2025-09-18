# FDB - Find Database Differences

A Python-based solution for querying data that exists in table A but not in table B.

## Overview

FDB provides functionality to find differences between two database tables, specifically identifying records that exist in one table but not in another. This is useful for data comparison, synchronization tasks, and identifying missing records.

## Features

- Query data that exists in table A but not in table B
- Query data that exists in table B but not in table A
- Support for custom key columns for comparison
- In-memory and file-based SQLite database support
- Comprehensive test suite
- Sample data for demonstration

## Quick Start

### Basic Usage

```python
from fdb_query import FDBQuery

# Initialize with in-memory database
fdb = FDBQuery()

# Create sample tables and data
fdb.create_sample_tables()
fdb.insert_sample_data()

# Find records in table A but not in table B
differences = fdb.find_data_not_in_table_b()
for record in differences:
    print(record)

# Clean up
fdb.close()
```

### Command Line Demo

```bash
python3 fdb_query.py
```

This will run a demonstration showing:
- Sample data in both tables
- Records that exist in table A but not in table B
- Records that exist in table B but not in table A

## SQL Queries

The core functionality is based on SQL LEFT JOIN queries. See `queries.sql` for the raw SQL implementations:

```sql
-- Find records in table_a that don't exist in table_b
SELECT a.*
FROM table_a a
LEFT JOIN table_b b ON a.name = b.name AND a.value = b.value
WHERE b.name IS NULL
ORDER BY a.id;
```

## API Reference

### FDBQuery Class

#### Constructor
```python
FDBQuery(db_path=":memory:")
```
- `db_path`: Path to SQLite database file. Defaults to in-memory database.

#### Methods

##### `find_data_not_in_table_b(key_columns=None)`
Find data that exists in table_a but not in table_b.
- `key_columns`: List of column names for comparison. Defaults to `['name', 'value']`.
- Returns: List of tuples representing rows that exist in A but not in B.

##### `find_data_not_in_table_a(key_columns=None)`
Find data that exists in table_b but not in table_a.
- `key_columns`: List of column names for comparison. Defaults to `['name', 'value']`.
- Returns: List of tuples representing rows that exist in B but not in A.

##### `create_sample_tables()`
Create sample tables A and B for demonstration purposes.

##### `insert_sample_data()`
Insert sample data into the tables for testing.

##### `get_table_contents(table_name)`
Get all contents of a specified table.
- `table_name`: Name of the table to query.
- Returns: List of tuples representing all rows in the table.

## Testing

Run the test suite to validate functionality:

```bash
python3 test_fdb_query.py
```

The test suite includes:
- Database connection tests
- Table creation validation
- Data insertion verification
- Query functionality tests
- Custom key column tests
- Empty table handling
- File-based database tests

## Requirements

- Python 3.6+
- SQLite (included with Python standard library)

No external dependencies required.

## Use Cases

1. **Data Synchronization**: Identify records that need to be synchronized between databases
2. **Data Migration**: Find missing records during migration processes
3. **Quality Assurance**: Compare datasets to ensure completeness
4. **Backup Verification**: Verify that backup data contains all records from source
5. **ETL Processes**: Identify new or missing records in data pipelines

## Example Output

```
=== FDB Query Demo ===
Finding data that exists in table A but not in table B

Table A contents:
  (1, 'apple', 'red')
  (2, 'banana', 'yellow')
  (3, 'cherry', 'red')
  (4, 'date', 'brown')
  (5, 'elderberry', 'purple')

Table B contents:
  (1, 'apple', 'red')
  (3, 'cherry', 'red')
  (6, 'fig', 'purple')
  (7, 'grape', 'green')

Data in Table A but NOT in Table B:
  (2, 'banana', 'yellow')
  (4, 'date', 'brown')
  (5, 'elderberry', 'purple')

Data in Table B but NOT in Table A:
  (6, 'fig', 'purple')
  (7, 'grape', 'green')
```

## Files

- `fdb_query.py`: Main module with FDBQuery class and functionality
- `test_fdb_query.py`: Comprehensive test suite
- `queries.sql`: Raw SQL queries for reference
- `requirements.txt`: Project dependencies (none beyond Python standard library)
- `README.md`: This documentation file
