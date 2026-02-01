-- 05_ingestion_latency_check.sql
-- Purpose: Assess data timeliness: Ingestion date vs transaction timestamp
   
-- Transaction-level ingestion delay (days)
SELECT
  transaction_id,
  transaction_ts,
  ingestion_date,
  CAST(
    julianday(ingestion_date) - julianday(transaction_ts)
    AS INTEGER
  ) AS ingestion_delay_days
FROM fraud_trx_dq
ORDER BY ingestion_delay_days DESC;

-- Distribution of ingestion delays
SELECT
  CAST(
    julianday(ingestion_date) - julianday(transaction_ts)
    AS INTEGER
  ) AS delay_days,
  COUNT(*) AS tx_cnt
FROM fraud_trx_dq
GROUP BY delay_days
ORDER BY delay_days;

-- SLA breach analysis (example SLA = 2 days)
SELECT
  COUNT(*) AS total_tx,
  SUM(
    CASE
      WHEN (julianday(ingestion_date) - julianday(transaction_ts)) > 2
        THEN 1 ELSE 0
    END
  ) AS delayed_tx,
  ROUND(
    SUM(
      CASE
        WHEN (julianday(ingestion_date) - julianday(transaction_ts)) > 2
          THEN 1 ELSE 0
      END
    ) * 1.0 / COUNT(*),
    4
  ) AS delayed_rate
FROM fraud_trx_dq;