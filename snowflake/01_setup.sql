-- =====================================================================
-- Setup — Warehouse, database, schemas, role
-- =====================================================================
USE ROLE ACCOUNTADMIN;

-- Compute: extra-small, auto-suspend fast so the trial credits last.
CREATE WAREHOUSE IF NOT EXISTS DINEFLOW_WH
  WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND   = 60
  AUTO_RESUME    = TRUE
  INITIALLY_SUSPENDED = TRUE;

-- Database + medallion schemas.
CREATE DATABASE IF NOT EXISTS DINEFLOW;
CREATE SCHEMA  IF NOT EXISTS DINEFLOW.BRONZE;    -- Iceberg tables Spark wrote (dbt sources)
CREATE SCHEMA  IF NOT EXISTS DINEFLOW.RAW;       -- only used by the COPY fallback path
CREATE SCHEMA  IF NOT EXISTS DINEFLOW.STAGING;   -- cleaned / conformed (dbt)
CREATE SCHEMA  IF NOT EXISTS DINEFLOW.MARTS;     -- Gold, Iceberg (dbt)
CREATE SCHEMA  IF NOT EXISTS DINEFLOW.SNAPSHOTS; -- SCD2 history (dbt)
CREATE SCHEMA  IF NOT EXISTS DINEFLOW.AI;        -- LLM-enriched tables (OpenAI jobs)

-- A role dbt/Airflow will use.
CREATE ROLE IF NOT EXISTS DBT_ROLE;
GRANT USAGE   ON WAREHOUSE DINEFLOW_WH TO ROLE DBT_ROLE;
GRANT OPERATE ON WAREHOUSE DINEFLOW_WH TO ROLE DBT_ROLE;
GRANT ALL     ON DATABASE  DINEFLOW    TO ROLE DBT_ROLE;
GRANT ALL     ON ALL SCHEMAS IN DATABASE DINEFLOW TO ROLE DBT_ROLE;
GRANT ALL     ON FUTURE SCHEMAS IN DATABASE DINEFLOW TO ROLE DBT_ROLE;
GRANT ALL     ON FUTURE TABLES IN DATABASE DINEFLOW TO ROLE DBT_ROLE;
GRANT ALL     ON FUTURE VIEWS  IN DATABASE DINEFLOW TO ROLE DBT_ROLE;

-- Let your login use the role
SET my_user = CURRENT_USER();
GRANT ROLE DBT_ROLE TO USER IDENTIFIER($my_user);

SELECT 'setup complete' AS status;