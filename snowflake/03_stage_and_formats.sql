-- =====================================================================
-- External stage on S3 + CSV file format
-- =====================================================================
USE ROLE ACCOUNTADMIN;
USE DATABASE DINEFLOW;
USE SCHEMA RAW;


CREATE OR REPLACE FILE FORMAT DINEFLOW.RAW.CSV_FMT
  TYPE = 'CSV'
  COMPRESSION = 'AUTO'
  FIELD_DELIMITER = ','
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  SKIP_HEADER = 1
  EMPTY_FIELD_AS_NULL = TRUE
  NULL_IF = ('', '\\N', 'NULL')
  TRIM_SPACE = FALSE
  ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE;

-- Upload one CSV per folder:  raw/restaurants/  raw/users/  raw/food/  raw/menu/  raw/orders/  raw/order_items/  raw/reviews/
CREATE OR REPLACE STAGE DINEFLOW.RAW.DINEFLOW_RAW_STAGE
  STORAGE_INTEGRATION = DINEFLOW_S3_INT
  URL = 's3://dineflow-ai-pipeline-ingestion/raw/'
  FILE_FORMAT = DINEFLOW.RAW.CSV_FMT;

-- Confirm Snowflake can see your files (should list the seven table folders).
LIST @DINEFLOW.RAW.DINEFLOW_RAW_STAGE;