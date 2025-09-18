# FDB - Facility Database Management

FDB Works - A SQL-based system for managing facility leases and FMS links.

## Quick Start

This repository implements SQL queries for identifying orphaned facility leases - leases that have corresponding FMS links but with incomplete facility references.

### Main Query
```sql
SELECT *
FROM FDBDBA.FAC_LEASES_T F
WHERE EXISTS (
    SELECT 1 
    FROM FDBDBA.FMS_LINK_T 
    WHERE FMSWIN_ID = F.FMSWIN_ID
      AND FACILITY_ID IS NULL
);
```

See [SQL_README.md](SQL_README.md) for detailed documentation and usage instructions.
