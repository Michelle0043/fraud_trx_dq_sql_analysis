-- 00_data_overview.sql
-- Purpose: High-level data volume, uniqueness, and time coverage
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT transaction_id) AS distinct_transaction_id,
    MIN(transaction_ts) AS min_transaction_ts,
    MAX(transaction_ts) AS max_transaction_ts,
    MIN(ingestion_date) AS min_ingestion_date,
    MAX(ingestion_date) AS max_ingestion_date
FROM fraud_trx_dq;