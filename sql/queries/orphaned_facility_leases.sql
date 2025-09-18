-- Query to find facility leases with orphaned FMS links
-- This query selects all records from FAC_LEASES_T where there exists
-- a corresponding record in FMS_LINK_T with the same FMSWIN_ID but
-- where FACILITY_ID is null (indicating an incomplete/orphaned link)

SELECT *
FROM FDBDBA.FAC_LEASES_T F
WHERE EXISTS (
    SELECT 1 
    FROM FDBDBA.FMS_LINK_T 
    WHERE FMSWIN_ID = F.FMSWIN_ID
      AND FACILITY_ID IS NULL
);

-- Alternative query with more explicit formatting and comments
-- for better readability and maintenance

SELECT 
    F.FMSWIN_ID,
    F.LEASE_ID,
    F.FACILITY_NAME,
    F.LEASE_START_DATE,
    F.LEASE_END_DATE,
    F.LEASE_AMOUNT,
    F.LEASE_STATUS,
    F.CREATED_DATE,
    F.MODIFIED_DATE
FROM FDBDBA.FAC_LEASES_T F
WHERE EXISTS (
    SELECT 1 
    FROM FDBDBA.FMS_LINK_T L
    WHERE L.FMSWIN_ID = F.FMSWIN_ID
      AND L.FACILITY_ID IS NULL
)
ORDER BY F.FMSWIN_ID;