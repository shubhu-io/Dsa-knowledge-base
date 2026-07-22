# Data Engineering Comprehensive Guide

## Table of Contents

1. [Introduction](#introduction)
2. [Data Modeling](#data-modeling)
3. [ETL vs ELT](#etl-vs-elt)
4. [Data Quality](#data-quality)
5. [Data Storage](#data-storage)
6. [Data Processing](#data-processing)
7. [Best Practices](#best-practices)

---

## Introduction

Data Engineering is the discipline of designing, building, and maintaining data systems. It enables organizations to collect, store, and analyze data efficiently.

### Data Engineering Lifecycle

```
┌──────────────────────────────────────────────────────────────┐
│                 Data Engineering Lifecycle                     │
├──────────────────────────────────────────────────────────────┤
│                                                                │
│  [Source] ──▶ [Ingest] ──▶ [Store] ──▶ [Transform] ──▶ [Serve]│
│     │            │            │            │            │      │
│     v            v            v            v            v      │
│  Databases    Kafka/        S3/GCS/      Spark/dbt    API/   │
│  APIs         Airflow       Snowflake    Airflow      BI     │
│  Files        Flink         Delta Lake               Dashboard│
│                                                                │
└──────────────────────────────────────────────────────────────┘
```

### Key Principles

1. **Reliability** - Systems should be fault-tolerant
2. **Scalability** - Handle growing data volumes
3. **Freshness** - Data should be up-to-date
4. **Quality** - Ensure accuracy and completeness
5. **Efficiency** - Optimize costs and performance

---

## Data Modeling

### Dimensional Modeling (Kimball)

```
┌─────────────────────────────────────────────────────────────┐
│                    Star Schema Example                        │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│     ┌─────────────┐                                          │
│     │ dim_date    │                                          │
│     ├─────────────┤                                          │
│     │ date_key    │                                          │
│     │ date        │                                          │
│     │ month       │                                          │
│     │ quarter     │                                          │
│     │ year        │                                          │
│     └──────┬──────┘                                          │
│            │                                                  │
│     ┌──────┴──────┐                                          │
│     │ fact_sales  │                                          │
│     ├─────────────┤                                          │
│     │ date_key    │──┐                                       │
│     │ product_key │──┼──▶ ┌──────────────┐                   │
│     │ store_key   │──┘   │ dim_product  │                   │
│     │ quantity    │      ├──────────────┤                   │
│     │ amount      │      │ product_key  │                   │
│     └──────┬──────┘      │ name         │                   │
│            │              │ category     │                   │
│            │              │ price        │                   │
│            │              └──────────────┘                   │
│            │                                                  │
│            └──────────────────▶ ┌──────────────┐             │
│                                 │ dim_store    │             │
│                                 ├──────────────┤             │
│                                 │ store_key    │             │
│                                 │ name         │             │
│                                 │ location     │             │
│                                 │ manager      │             │
│                                 └──────────────┘             │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

### Data Vault Modeling

```sql
-- Hub: Business keys
CREATE TABLE hub_customer (
    hub_customer_hk    VARCHAR(64) PRIMARY KEY,  -- Hash key
    customer_id        VARCHAR(50) NOT NULL,
    load_date          TIMESTAMP NOT NULL,
    record_source      VARCHAR(100) NOT NULL
);

-- Links: Relationships
CREATE TABLE link_order_customer (
    link_order_customer_hk  VARCHAR(64) PRIMARY KEY,
    order_hk               VARCHAR(64) NOT NULL,
    customer_hk            VARCHAR(64) NOT NULL,
    load_date              TIMESTAMP NOT NULL,
    record_source          VARCHAR(100) NOT NULL
);

-- Satellites: Descriptive attributes
CREATE TABLE sat_customer_details (
    customer_hk        VARCHAR(64) NOT NULL,
    load_date          TIMESTAMP NOT NULL,
    load_end_date      TIMESTAMP,
    first_name         VARCHAR(100),
    last_name          VARCHAR(100),
    email              VARCHAR(255),
    phone              VARCHAR(50),
    record_source      VARCHAR(100) NOT NULL,
    PRIMARY KEY (customer_hk, load_date)
);
```

### Normalization vs Denormalization

| Aspect | Normalized (3NF) | Denormalized |
|--------|------------------|--------------|
| Purpose | OLTP (transactions) | OLAP (analytics) |
| Redundancy | Minimal | High |
| Query Performance | Complex joins | Simple queries |
| Write Performance | Good | Poor |
| Storage | Efficient | Higher |
| Use Case | ERP, CRM | Data warehouse |

---

## ETL vs ELT

### ETL (Extract, Transform, Load)

```
Source ──▶ Extract ──▶ Transform ──▶ Load ──▶ Target
              │             │            │
              v             v            v
           Staging      Processing    Data Warehouse
           Area          Engine
```

**Pros:**
- Transformed data ready for analysis
- Reduced load on target system
- Data validation before loading

**Cons:**
- Slower for large datasets
- Requires separate staging area
- More complex infrastructure

### ELT (Extract, Load, Transform)

```
Source ──▶ Extract ──▶ Load ──▶ Transform ──▶ Target
              │          │           │
              v          v           v
           Raw Data   Data Lake   Data Warehouse
```

**Pros:**
- Faster loading
- Leverages target system power
- Raw data preserved

**Cons:**
- Higher storage costs
- More processing at target
- Potential data quality issues

### When to Use Each

| Scenario | Recommended Approach |
|----------|---------------------|
| Small data (< 1TB) | ETL |
| Large data (> 1TB) | ELT |
| Real-time requirements | ETL (streaming) |
| Cost-sensitive | ELT (cloud storage) |
| Complex transformations | ETL |
| Data lake architecture | ELT |

---

## Data Quality

### Data Quality Dimensions

```
┌─────────────────────────────────────────────────────────────┐
│                   Data Quality Dimensions                     │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │  Accuracy   │  │  Completeness│  │ Consistency │         │
│  │             │  │             │  │             │         │
│  │ Data matches│  │ No missing  │  │ Same data   │         │
│  │ reality     │  │ values      │  │ across      │         │
│  │             │  │             │  │ systems     │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
│                                                               │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │  Timeliness │  │  Validity   │  │ Uniqueness  │         │
│  │             │  │             │  │             │         │
│  │ Data is     │  │ Meets rules │  │ No duplicate│         │
│  │ up-to-date  │  │ and format  │  │ records     │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

### Great Expectations

```python
import great_expectations as ge

# Create expectations
df = ge.read_csv("customers.csv")

# Define expectations
df.expect_column_values_to_not_be_null("customer_id")
df.expect_column_values_to_be_unique("customer_id")
df.expect_column_values_to_match_regex("email", r"^[\w\.-]+@[\w\.-]+\.\w+$")
df.expect_column_values_to_be_between("age", 0, 150)
df.expect_column_values_to_be_in_set("status", ["active", "inactive", "pending"])

# Validate
results = df.validate()
print(results)
```

### dbt Tests

```yaml
# models/staging/stg_customers.yml
version: 2

models:
  - name: stg_customers
    columns:
      - name: customer_id
        tests:
          - unique
          - not_null
      - name: email
        tests:
          - not_null
          - regex_match:
              regex: "^[\w\.-]+@[\w\.-]+\.\w+$"
      - name: status
        tests:
          - accepted_values:
              values: ["active", "inactive", "pending"]
```

---

## Data Storage

### Storage Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                   Data Storage Layers                         │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌─────────────────────────────────────────────────┐        │
│  │  Hot Storage (SSD/NVMe)                         │        │
│  │  - Frequently accessed data                     │        │
│  │  - Real-time analytics                          │        │
│  │  - Last 30-90 days                              │        │
│  └─────────────────────────────────────────────────┘        │
│                          │                                    │
│                          v                                    │
│  ┌─────────────────────────────────────────────────┐        │
│  │  Warm Storage (Standard HDD)                    │        │
│  │  - Infrequently accessed data                   │        │
│  │  - Weekly/Monthly reports                       │        │
│  │  - 90 days - 1 year                             │        │
│  └─────────────────────────────────────────────────┘        │
│                          │                                    │
│                          v                                    │
│  ┌─────────────────────────────────────────────────┐        │
│  │  Cold Storage (Archive/Glacier)                 │        │
│  │  - Rarely accessed data                         │        │
│  │  - Compliance/audit                             │        │
│  │  - 1+ years                                     │        │
│  └─────────────────────────────────────────────────┘        │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

### Comparison

| Feature | Data Lake | Data Warehouse | Data Mart |
|---------|-----------|----------------|-----------|
| Data Type | Raw, all types | Structured | Structured |
| Schema | Schema-on-read | Schema-on-write | Schema-on-write |
| Users | Data Engineers | Analysts, BI | Business Users |
| Cost | Low | High | Medium |
| Flexibility | High | Low | Medium |
| Performance | Variable | Optimized | Optimized |

---

## Data Processing

### Apache Spark

```python
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, sum, avg, count

# Initialize Spark
spark = SparkSession.builder \
    .appName("Data Processing") \
    .config("spark.sql.warehouse.dir", "/warehouse") \
    .getOrCreate()

# Read data
df = spark.read.parquet("s3://data-lake/raw/customers")

# Transform data
processed_df = df \
    .filter(col("status") == "active") \
    .groupBy("region") \
    .agg(
        count("customer_id").alias("customer_count"),
        avg("lifetime_value").alias("avg_ltv"),
        sum("total_orders").alias("total_orders")
    ) \
    .orderBy(col("total_orders").desc())

# Write to data warehouse
processed_df.write \
    .mode("overwrite") \
    .partitionBy("region") \
    .parquet("s3://data-lake/processed/customer_summary")
```

### Apache Airflow

```python
from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime

default_args = {
    'owner': 'data_engineering',
    'depends_on_past': False,
    'start_date': datetime(2024, 1, 1),
    'retries': 3,
    'retry_delay': timedelta(minutes=5),
}

dag = DAG(
    'daily_etl',
    default_args=default_args,
    schedule_interval='0 2 * * *',  # Daily at 2 AM
    catchup=False
)

def extract(**context):
    """Extract data from source."""
    pass

def transform(**context):
    """Transform extracted data."""
    pass

def load(**context):
    """Load data to target."""
    pass

extract_task = PythonOperator(
    task_id='extract',
    python_callable=extract,
    dag=dag
)

transform_task = PythonOperator(
    task_id='transform',
    python_callable=transform,
    dag=dag
)

load_task = PythonOperator(
    task_id='load',
    python_callable=load,
    dag=dag
)

extract_task >> transform_task >> load_task
```

### dbt (Data Build Tool)

```sql
-- models/marts/customer_lifetime_value.sql
WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS order_count,
        SUM(amount) AS total_amount,
        MIN(order_date) AS first_order,
        MAX(order_date) AS last_order
    FROM {{ ref('stg_orders') }}
    GROUP BY customer_id
),

customer_segments AS (
    SELECT
        customer_id,
        order_count,
        total_amount,
        first_order,
        last_order,
        CASE
            WHEN order_count = 1 THEN 'One-time'
            WHEN order_count BETWEEN 2 AND 5 THEN 'Occasional'
            WHEN order_count BETWEEN 6 AND 10 THEN 'Regular'
            ELSE 'Loyal'
        END AS segment,
        DATEDIFF(day, first_order, last_order) AS customer_tenure_days
    FROM customer_orders
)

SELECT
    c.*,
    c.total_amount / NULLIF(c.customer_tenure_days, 0) AS daily_value,
    c.order_count / NULLIF(c.customer_tenure_days, 0) * 365 AS annual_order_frequency
FROM customer_segments c
```

---

## Best Practices

### 1. Schema Design

```sql
-- Use appropriate data types
CREATE TABLE events (
    event_id        BIGINT PRIMARY KEY,  -- Not VARCHAR
    user_id         INT NOT NULL,
    event_type      VARCHAR(50),
    event_timestamp TIMESTAMP,
    event_date      DATE,  -- Partition key
    payload         JSONB,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Partition large tables
CREATE TABLE events (
    event_id        BIGINT,
    event_date      DATE,
    user_id         INT,
    event_type      VARCHAR(50)
) PARTITION BY RANGE (event_date);

CREATE TABLE events_2024_01 PARTITION OF events
    FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');
```

### 2. Incremental Processing

```python
# Incremental load pattern
def incremental_load(source_table, target_table, watermark_column):
    """Load only new or updated records."""
    # Get last processed timestamp
    last_processed = get_watermark(target_table)

    # Query new records
    query = f"""
    SELECT *
    FROM {source_table}
    WHERE {watermark_column} > '{last_processed}'
    """

    new_records = read_from_source(query)

    if len(new_records) > 0:
        # Load to target
        write_to_target(new_records, target_table, mode='append')

        # Update watermark
        max_timestamp = new_records[watermark_column].max()
        update_watermark(target_table, max_timestamp)

    return len(new_records)
```

### 3. Error Handling

```python
import logging
from typing import Optional

logger = logging.getLogger(__name__)

class PipelineError(Exception):
    """Custom pipeline exception."""
    pass

def run_pipeline_with_retry(func, max_retries=3, **kwargs):
    """Execute pipeline with retry logic."""
    for attempt in range(max_retries):
        try:
            result = func(**kwargs)
            return result
        except Exception as e:
            logger.error(f"Attempt {attempt + 1} failed: {e}")
            if attempt == max_retries - 1:
                raise PipelineError(f"Pipeline failed after {max_retries} attempts: {e}")
            time.sleep(2 ** attempt)  # Exponential backoff
```

### 4. Monitoring

```python
import time
from functools import wraps

def monitor_pipeline(func):
    """Monitor pipeline execution."""
    @wraps(func)
    def wrapper(*args, **kwargs):
        start_time = time.time()
        try:
            result = func(*args, **kwargs)
            duration = time.time() - start_time
            logger.info(f"Pipeline {func.__name__} completed in {duration:.2f}s")
            # Send metrics
            send_metric("pipeline_duration", duration, tags={"pipeline": func.__name__})
            return result
        except Exception as e:
            duration = time.time() - start_time
            logger.error(f"Pipeline {func.__name__} failed after {duration:.2f}s: {e}")
            send_metric("pipeline_failure", 1, tags={"pipeline": func.__name__})
            raise
    return wrapper
```

---

## Summary

Key takeaways:

1. **Choose the right modeling approach** - Star schema for analytics, normalized for transactions
2. **Use ELT for modern stacks** - Leverage cloud data warehouses
3. **Ensure data quality** - Validate at ingestion and transformation
4. **Design for scalability** - Partition, distribute, and parallelize
5. **Monitor everything** - Track pipeline health and data freshness
