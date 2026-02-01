-- 06_data_quality_scorecard.sql
-- One row per DQ dimension & metric
WITH base_cnt AS (
    SELECT COUNT(*) AS total_cnt
    FROM fraud_trx_dq
),

null_issues AS (
    SELECT
        SUM(
            CASE
                WHEN transaction_id IS NULL
                  OR transaction_ts IS NULL
                  OR amount IS NULL
                  OR currency IS NULL
                  OR transaction_type IS NULL
                  OR originator_id IS NULL
                  OR destination_id IS NULL
                  OR old_balance_orig IS NULL
                  OR new_balance_orig IS NULL
                  OR old_balance_dest IS NULL
                  OR new_balance_dest IS NULL
                  OR is_fraud IS NULL
                  OR source_system IS NULL
                  OR ingestion_date IS NULL
                THEN 1 ELSE 0
            END
        ) AS issue_cnt
    FROM fraud_trx_dq
),

dup_trx AS (
    SELECT
        SUM(cnt - 1) AS issue_cnt
    FROM (
        SELECT transaction_id, COUNT(*) AS cnt
        FROM fraud_trx_dq
        GROUP BY transaction_id
        HAVING COUNT(*) > 1
    )
),

orig_balance_issue AS (
    SELECT
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
        ) AS issue_cnt
    FROM fraud_trx_dq
),

dest_balance_issue AS (
    SELECT
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
        ) AS issue_cnt
    FROM fraud_trx_dq
),

latency_issue AS (
    SELECT
        SUM(
            CASE
                WHEN (julianday(ingestion_date) - julianday(transaction_ts)) > 2
                  THEN 1 ELSE 0
            END
        ) AS issue_cnt
    FROM fraud_trx_dq
)

SELECT
    'Completeness' AS dq_dimension,
    'Any NULL in critical fields' AS dq_metric,
    n.issue_cnt AS issue_count,
    b.total_cnt AS total_count,
    ROUND(n.issue_cnt * 1.0 / b.total_cnt, 4) AS issue_rate
FROM null_issues n, base_cnt b

UNION ALL

SELECT
    'Uniqueness',
    'Duplicate transaction_id',
    d.issue_cnt,
    b.total_cnt,
    ROUND(d.issue_cnt * 1.0 / b.total_cnt, 4)
FROM dup_trx d, base_cnt b

UNION ALL

SELECT
    'Accuracy',
    'Originator balance mismatch',
    o.issue_cnt,
    b.total_cnt,
    ROUND(o.issue_cnt * 1.0 / b.total_cnt, 4)
FROM orig_balance_issue o, base_cnt b

UNION ALL

SELECT
    'Accuracy',
    'Destination balance mismatch',
    d.issue_cnt,
    b.total_cnt,
    ROUND(d.issue_cnt * 1.0 / b.total_cnt, 4)
FROM dest_balance_issue d, base_cnt b

UNION ALL

SELECT
    'Timeliness',
    'Ingestion delay > 2 days',
    l.issue_cnt,
    b.total_cnt,
    ROUND(l.issue_cnt * 1.0 / b.total_cnt, 4)
FROM latency_issue l, base_cnt b;




