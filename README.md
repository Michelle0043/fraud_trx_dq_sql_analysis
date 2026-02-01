# Data Quality Mini Project – Fraud Transaction Dataset

## Overview

This project is a **data quality assessment mini project** built on a fraud transaction dataset.  
It simulates **real-world enterprise data governance practices** by identifying, quantifying, and summarizing common data quality issues using SQL.

The final output is a **Data Quality Scorecard** that can be used for:
- Data Governance
- Data Management
- Internal Audit
- Fraud & Risk Analytics

---

## Dataset

**Table name:** `fraud_trx_dq`

## Project Objectives

The goal of this project is to assess **data quality** across five core dimensions commonly used in enterprise data governance:

1. Completeness  
2. Uniqueness  
3. Validity  
4. Accuracy  
5. Timeliness  

## Data Quality Checks

### Data Understanding

Basic profiling to understand dataset size and time range:
- Total row count
- Distinct transaction count
- Transaction timestamp range
- Ingestion date range

### Completeness (NULL Checks)

Checks for missing values in critical columns, including:
- Identifiers
- Timestamps
- Amounts
- Balances
- Fraud indicators
- Source system
- Ingestion date

**Output:**
- Number of records with NULL values
- NULL rate across the dataset

### Uniqueness (Duplicate Checks)

Detects:
- Duplicate `transaction_id`
- Potential business-key duplicates based on:
  - transaction_ts
  - amount
  - originator_id
  - destination_id


### Accuracy (Balance Reconciliation)

Validates balance calculations based on transaction type:
- Originator balance reconciliation
- Destination balance reconciliation

A tolerance is applied to handle floating-point precision.


### Timeliness (Ingestion Delay)

Measures ingestion delay between:
- `transaction_ts`
- `ingestion_date`

Key metrics:
- Delay in days per transaction
- Distribution of ingestion delays
- Percentage of transactions ingested more than 2 days late
  

## Data Quality Scorecard

The final output is a **Data Quality Scorecard** with one row per metric.

dq_dimension	dq_metric	issue_count	total_count	issue_rate
Completeness	Any NULL in critical fields	1004	3000	0.3347
Uniqueness	Duplicate transaction_id	1243	3000	0.4143
Accuracy	Originator balance mismatch	340	3000	0.1133
Accuracy	Destination balance mismatch	1181	3000	0.3937
Timeliness	Ingestion delay > 2 days	1800	3000	0.6


## Possible Extensions

- Data quality trend analysis over time
- SLA thresholds with pass/fail indicators
- Overall data quality scoring
- Integration with BI dashboards
- Column-level lineage and ownership tracking

---

## Author Notes

This is a time-boxed mini project designed to be completed within half a day, while still reflecting enterprise-level data governance concepts.
