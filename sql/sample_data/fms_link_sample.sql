-- Sample data for FDBDBA.FMS_LINK_T table
-- This includes some records with null FACILITY_ID to test the orphaned leases query

INSERT INTO FDBDBA.FMS_LINK_T (LINK_ID, FMSWIN_ID, FACILITY_ID, LINK_TYPE, LINK_STATUS) VALUES
('LINK001', 'FMS001', 'FAC001', 'PRIMARY', 'ACTIVE'),
('LINK002', 'FMS002', NULL, 'PRIMARY', 'PENDING'),  -- Orphaned link - no FACILITY_ID
('LINK003', 'FMS003', 'FAC003', 'PRIMARY', 'ACTIVE'),
('LINK004', 'FMS004', NULL, 'PRIMARY', 'PENDING'),  -- Orphaned link - no FACILITY_ID
('LINK005', 'FMS005', 'FAC005', 'PRIMARY', 'INACTIVE'),
('LINK006', 'FMS006', NULL, 'SECONDARY', 'PENDING'), -- Orphaned link for non-existent lease
('LINK007', 'FMS002', 'FAC007', 'SECONDARY', 'ACTIVE'); -- Additional link for FMS002