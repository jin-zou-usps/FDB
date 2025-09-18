# FDB - Facility Database Management

## Overview

This repository contains SQL scripts and queries for managing facility leases and their associated FMS (Facility Management System) links.

## Database Tables

### FDBDBA.FAC_LEASES_T
- **Purpose**: Stores facility lease information
- **Key Fields**:
  - `FMSWIN_ID`: Foreign key linking to FMS system
  - `LEASE_ID`: Primary key for lease records
  - `FACILITY_NAME`: Name of the leased facility
  - `LEASE_START_DATE`, `LEASE_END_DATE`: Lease term dates
  - `LEASE_AMOUNT`: Lease amount in dollars
  - `LEASE_STATUS`: Current status of the lease

### FDBDBA.FMS_LINK_T  
- **Purpose**: Stores linkage between FMS system and facilities
- **Key Fields**:
  - `LINK_ID`: Primary key for link records
  - `FMSWIN_ID`: Links to FAC_LEASES_T records
  - `FACILITY_ID`: Reference to facility (can be null for incomplete links)
  - `LINK_TYPE`: Type of link (PRIMARY, SECONDARY, etc.)
  - `LINK_STATUS`: Current status of the link

## Key Query: Orphaned Facility Leases

The main query in this repository identifies facility leases that have orphaned FMS links:

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

### Purpose
This query finds leases where:
1. There is a corresponding FMS link record
2. The FMS link has a null `FACILITY_ID` (incomplete/orphaned)

This helps identify data integrity issues where leases exist but their facility linkage is incomplete.

## File Structure

```
sql/
├── schemas/
│   ├── fac_leases_t.sql    # Schema for facility leases table
│   └── fms_link_t.sql      # Schema for FMS link table
├── queries/
│   └── orphaned_facility_leases.sql  # Main query implementation
└── sample_data/
    ├── fac_leases_sample.sql  # Sample lease data
    └── fms_link_sample.sql    # Sample link data (includes orphaned records)
```

## Usage

1. Create the database schemas:
   ```sql
   -- Run these files in order:
   @sql/schemas/fac_leases_t.sql
   @sql/schemas/fms_link_t.sql
   ```

2. Load sample data (optional):
   ```sql
   @sql/sample_data/fac_leases_sample.sql
   @sql/sample_data/fms_link_sample.sql
   ```

3. Execute the orphaned leases query:
   ```sql
   @sql/queries/orphaned_facility_leases.sql
   ```

## Expected Results

With the sample data, the query should return:
- `FMS002` - Warehouse Facility A (has orphaned link LINK002)
- `FMS004` - Industrial Complex B (has orphaned link LINK004)

These represent leases that have incomplete facility linkage and may require data cleanup or investigation.