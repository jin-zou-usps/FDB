-- Test validation for the orphaned facility leases query
-- This script shows what the query should return with sample data

-- Expected scenario:
-- 1. FMS002 has lease "Warehouse Facility A" and has LINK002 with null FACILITY_ID -> SHOULD RETURN
-- 2. FMS004 has lease "Industrial Complex B" and has LINK004 with null FACILITY_ID -> SHOULD RETURN  
-- 3. FMS001 has lease "Downtown Office Building" and has LINK001 with FACILITY_ID='FAC001' -> SHOULD NOT RETURN
-- 4. FMS003 has lease "Retail Space Main St" and has LINK003 with FACILITY_ID='FAC003' -> SHOULD NOT RETURN
-- 5. FMS005 has lease "Office Tower Central" and has LINK005 with FACILITY_ID='FAC005' -> SHOULD NOT RETURN

-- Expected query results:
-- FMSWIN_ID | LEASE_ID | FACILITY_NAME
-- FMS002    | LEASE002 | Warehouse Facility A
-- FMS004    | LEASE004 | Industrial Complex B

-- This validates that the EXISTS clause correctly identifies:
-- - Records in FAC_LEASES_T that have matching FMSWIN_ID in FMS_LINK_T
-- - Where the FMS_LINK_T record has FACILITY_ID IS NULL
-- - Excludes records where FACILITY_ID is not null
-- - Excludes FMS_LINK_T records that don't have corresponding FAC_LEASES_T records

-- Query explanation:
-- The EXISTS subquery returns true when there's at least one record in FMS_LINK_T
-- with the same FMSWIN_ID and FACILITY_ID IS NULL, causing the outer query
-- to include that FAC_LEASES_T record in the result set.