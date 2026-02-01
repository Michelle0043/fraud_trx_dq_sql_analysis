-- 02_duplicate_check.sql
-- Purpose: Identify potential duplicate records

-- Duplicate transaction_id
SELECT
  transaction_id,
  COUNT(*) AS cnt
FROM fraud_trx_dq
GROUP BY transaction_id
HAVING COUNT(*) > 1;

-- Potential logical duplicates (same key attributes)
SELECT
  transaction_ts,
  amount,
  originator_id,
  destination_id,
  COUNT(*) AS cnt
FROM fraud_trx_dq
GROUP BY transaction_ts, amount, originator_id, destination_id
HAVING COUNT(*) > 