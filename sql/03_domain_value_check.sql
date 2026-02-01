-- 03_domain_value_check.sql
-- Purpose: Validate categorical field distributions

-- Currency values
SELECT
  currency,
  COUNT(*) AS cnt
FROM fraud_trx_dq
GROUP BY currency
ORDER BY cnt DESC;

-- Transaction type values
SELECT
  transaction_type,
  COUNT(*) AS cnt
FROM fraud_trx_dq
GROUP BY transaction_type
ORDER BY cnt DESC;

-- Source system values
SELECT
  source_system,
  COUNT(*) AS cnt
FROM fraud_trx_dq
GROUP BY source_system
ORDER BY cnt DESC;