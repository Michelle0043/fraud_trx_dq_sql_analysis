-- 04_balance_consistency_check.sql
-- Purpose: Validate financial integrity rules: New balance = Old balance +/- Amount

-- Originator balance consistency
SELECT
  COUNT(*) AS total_tx,
  SUM(
    CASE
      WHEN transaction_type IN ('TRANSFER', 'PAYMENT', 'CASH_OUT', 'DEBIT')
           AND ABS(new_balance_orig - (old_balance_orig - amount)) > 0.0001
        THEN 1
      WHEN transaction_type = 'CASH_IN'
           AND ABS(new_balance_orig - (old_balance_orig + amount)) > 0.0001
        THEN 1
      ELSE 0
    END
  ) AS orig_balance_mismatch_tx
FROM fraud_trx_dq;

-- Destination balance consistency
SELECT
  COUNT(*) AS total_tx,
  SUM(
    CASE
      WHEN transaction_type IN ('TRANSFER', 'PAYMENT', 'CASH_IN')
           AND ABS(new_balance_dest - (old_balance_dest + amount)) > 0.0001
        THEN 1
      WHEN transaction_type IN ('CASH_OUT', 'DEBIT')
           AND ABS(new_balance_dest - old_balance_dest) > 0.0001
        THEN 1
      ELSE 0
    END
  ) AS dest_balance_mismatch_tx
FROM fraud_trx_dq;