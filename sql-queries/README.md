# SQL Query Collection Index

This directory contains a comprehensive collection of SQL queries organized by category and complexity level.

## Directory Structure

### 📁 basic/
Fundamental SQL operations for beginners and everyday use:
- **select_queries.sql** - Basic SELECT operations, WHERE clauses, ordering, and filtering
- **join_queries.sql** - Various types of JOINs (INNER, LEFT, RIGHT, FULL OUTER)
- **aggregation_queries.sql** - GROUP BY, HAVING, aggregate functions (COUNT, SUM, AVG, etc.)

### 📁 dml/ (Data Manipulation Language)
Data modification operations:
- **insert_queries.sql** - INSERT statements (single row, multiple rows, with SELECT)
- **update_queries.sql** - UPDATE operations with conditions, JOINs, and calculations
- **delete_queries.sql** - DELETE operations with various conditions and safety patterns

### 📁 ddl/ (Data Definition Language)
Database structure operations:
- **create_table_queries.sql** - Table creation with constraints, indexes, and various data types
- **alter_table_queries.sql** - Table modifications, column changes, constraint management
- **drop_create_queries.sql** - DROP operations, database objects creation/removal

### 📁 advanced/
Complex SQL patterns and advanced techniques:
- **subquery_examples.sql** - Scalar, correlated, and nested subqueries
- **window_functions.sql** - Analytical functions (ROW_NUMBER, RANK, LAG/LEAD, etc.)
- **cte_examples.sql** - Common Table Expressions including recursive CTEs

### 📁 utilities/
Administrative and analytical queries:
- **database_admin.sql** - DBA tasks, monitoring, maintenance operations
- **performance_queries.sql** - Performance analysis, optimization, and troubleshooting
- **data_analysis.sql** - Statistical analysis, reporting, and business intelligence queries

## Usage Guidelines

1. **File Organization**: Each file contains related queries with clear comments explaining their purpose
2. **Comments**: Every query includes descriptive comments explaining what it does
3. **Examples**: Queries use realistic table and column names for better understanding
4. **Database Compatibility**: Most queries are written for PostgreSQL but include notes for other databases where syntax differs
5. **Safety**: Potentially dangerous operations (like DROP, DELETE ALL) include warnings

## Quick Reference

### Common Patterns
- **Basic querying**: Start with `basic/select_queries.sql`
- **Data analysis**: Check `utilities/data_analysis.sql`
- **Performance issues**: Use queries in `utilities/performance_queries.sql`
- **Complex reporting**: Combine techniques from `advanced/` directory

### Database Systems
These queries are primarily written for PostgreSQL but most are compatible with:
- MySQL (with minor syntax adjustments)
- SQL Server (with minor syntax adjustments)
- Oracle (with minor syntax adjustments)
- SQLite (for basic operations)

## Contributing
When adding new queries:
1. Place them in the appropriate category directory
2. Include clear, descriptive comments
3. Use meaningful table/column names
4. Test the syntax before committing
5. Document any database-specific features

## Learning Path
1. Start with `basic/` queries to understand fundamentals
2. Practice with `dml/` and `ddl/` for data manipulation
3. Advance to `advanced/` for complex analytical queries
4. Use `utilities/` for real-world administration and analysis tasks