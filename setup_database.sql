-- Database Setup Script for FDB
-- This script creates the necessary tables and loads sample data

-- Create the schemas
\echo 'Creating FDBDBA.FAC_LEASES_T table...'
\i sql/schemas/fac_leases_t.sql

\echo 'Creating FDBDBA.FMS_LINK_T table...'
\i sql/schemas/fms_link_t.sql

-- Load sample data
\echo 'Loading sample data for FAC_LEASES_T...'
\i sql/sample_data/fac_leases_sample.sql

\echo 'Loading sample data for FMS_LINK_T...'
\i sql/sample_data/fms_link_sample.sql

-- Test the main query
\echo 'Testing orphaned facility leases query...'
\echo 'Expected results: FMS002 (Warehouse Facility A) and FMS004 (Industrial Complex B)'
\i sql/queries/orphaned_facility_leases.sql

\echo 'Database setup complete!'