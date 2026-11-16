-- =====================================================================
--Secure S3 <-> Snowflake link (Storage Integration)
-- This is the real-world way to connect (no keys stored in Snowflake).
--
-- ORDER OF OPERATIONS (see RUNBOOK.md for the AWS clicks):
--   A. In AWS IAM, create role `snowflake-dineflow-role` with a PLACEHOLDER
--      trust policy.
--   B. Run CREATE STORAGE INTEGRATION below with that role's ARN.
--   C. DESC INTEGRATION -> copy STORAGE_AWS_IAM_USER_ARN + EXTERNAL_ID.
--   D. Edit the IAM role's trust policy with those two values.
-- =====================================================================
USE ROLE ACCOUNTADMIN;


CREATE OR REPLACE STORAGE INTEGRATION DINEFLOW_S3_INT
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = '<ROLE_ARN>'
  STORAGE_ALLOWED_LOCATIONS = ('s3://dineflow-ai-pipeline-ingestion/');

GRANT USAGE ON INTEGRATION DINEFLOW_S3_INT TO ROLE DBT_ROLE;

DESC INTEGRATION DINEFLOW_S3_INT;