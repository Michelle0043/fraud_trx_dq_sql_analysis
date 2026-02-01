-- 01_null_completeness_check.sql
-- Purpose: Assess completeness by counting NULLs per column

SELECT
  COUNT(*) AS total_rows,
  SUM(CASE WHEN transaction_id IS NULL THEN 1 ELSE 0 END) AS transaction_id_nulls,
  SUM(CASE WHEN transaction_ts IS NULL THEN 1 ELSE 0 END) AS transaction_ts_nulls,
  SUM(CASE WHEN amount IS NULL THEN 1 ELSE 0 END) AS amount_nulls,
  SUM(CASE WHEN currency IS NULL THEN 1 ELSE 0 END) AS currency_nulls,
  SUM(CASE WHEN transaction_type IS NULL THEN 1 ELSE 0 END) AS transaction_type_nulls,
  SUM(CASE WHEN originator_id IS NULL THEN 1 ELSE 0 END) AS originator_id_nulls,
  SUM(CASE WHEN destination_id IS NULL THEN 1 ELSE 0 END) AS destination_id_nulls,
  SUM(CASE WHEN old_balance_orig IS NULL THEN 1 ELSE 0 END) AS old_balance_orig_nulls,
  SUM(CASE WHEN new_balance_orig IS NULL THEN 1 ELSE 0 END) AS new_balance_orig_nulls,
  SUM(CASE WHEN old_balance_dest IS NULL THEN 1 ELSE 0 END) AS old_balance_dest_nulls,
  SUM(CASE WHEN new_balance_dest IS NULL THEN 1 ELSE 0 END) AS new_balance_dest_nulls,
  SUM(CASE WHEN is_fraud IS NULL THEN 1 ELSE 0 END) AS is_fraud_nulls,
  SUM(CASE WHEN source_system IS NULL THEN 1 ELSE 0 END) AS source_system_nulls,
  SUM(CASE WHEN ingestion_date IS NULL THEN 1 ELSE 0 END) AS ingestion_date_nulls
FROM fraud_trx_dq;