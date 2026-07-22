# Data Warehouse Architecture and Modeling

## Overview

A data warehouse is a centralized repository for structured, processed data optimized for analytical querying. This guide covers architecture, modeling techniques, and implementation.

## Data Warehouse Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    Data Warehouse Architecture                    │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  [Operational Sources]                                           │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐           │
│  │   ERP   │  │   CRM   │  │  Web    │  │ Mobile  │           │
│  └────┬────┘  └────┬────┘  └────┬────┘  └────┬────┘           │
│       │            │            │            │                   │
│       v            v            v            v                   │
│  ┌─────────────────────────────────────────────────┐            │
│  │              Staging Area                        │            │
│  │  Raw data, minimal transformation               │            │
│  └─────────────────────────────────────────────────┘            │
│                          │                                       │
│                          v                                       │
│  ┌─────────────────────────────────────────────────┐            │
│  │              Integration Layer                   │            │
│  │  Conformed dimensions, business rules           │            │
│  └─────────────────────────────────────────────────┘            │
│                          │                                       │
│                          v                                       │
│  ┌─────────────────────────────────────────────────┐            │
│  │              Data Warehouse                      │            │
│  │  ┌─────────────────────────────────────────┐   │            │
│  │  │  Core Facts & Dimensions                 │   │            │
│  │  │  - fact_sales                           │   │            │
│  │  │  - dim_customer                         │   │            │
│  │  │  - dim_product                          │   │            │
│  │  │  - dim_date                             │   │            │
│  │  └─────────────────────────────────────────┘   │            │
│  └─────────────────────────────────────────────────┘            │
│                          │                                       │
│                          v                                       │
│  ┌─────────────────────────────────────────────────┐            │
│  │              Data Marts                          │            │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐        │            │
│  │  │Finance  │  │Marketing│  │Operations│        │            │
│  │  └─────────┘  └─────────┘  └─────────┘        │            │
│  └─────────────────────────────────────────────────┘            │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

## Modeling Approaches

### Inmon (Corporate Information Factory)

```
┌─────────────────────────────────────────────────────────────────┐
│                    Inmon Architecture                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  [Sources] ──▶ [Staging] ──▶ [EDW] ──▶ [Data Marts]            │
│                               │            │                      │
│                               v            v                      │
│                          Normalized    Department                 │
│                          (3NF)         Specific                  │
│                                                                   │
│  Key Characteristics:                                            │
│  - Top-down approach                                              │
│  - Normalized enterprise data warehouse                          │
│  - Single source of truth                                        │
│  - Data marts built from EDW                                     │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

**Pros:**
- Single source of truth
- Reduced data redundancy
- Consistent data model
- Better data integrity

**Cons:**
- Complex implementation
- Longer development time
- Higher initial cost
- Requires strong governance

### Kimball (Dimensional Modeling)

```
┌─────────────────────────────────────────────────────────────────┐
│                    Kimball Architecture                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  [Sources] ──▶ [Staging] ──▶ [Dimensional Model] ──▶ [Marts]   │
│                               │                                   │
│                               v                                   │
│                          Star Schema                             │
│                          - Facts                                  │
│                          - Dimensions                             │
│                                                                   │
│  Key Characteristics:                                            │
│  - Bottom-up approach                                            │
│  - Dimensional modeling (star/snowflake)                         │
│  - Business process oriented                                     │
│  - Iterative development                                         │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

**Pros:**
- Fast query performance
- Easy to understand
- Business-friendly
- Quick time to value

**Cons:**
- Data redundancy
- Potential inconsistencies
- Harder to maintain
- Less flexible

### Data Vault

```
┌─────────────────────────────────────────────────────────────────┐
│                    Data Vault Components                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌─────────────┐                                                 │
│  │    HUB      │  Business keys (natural keys)                   │
│  ├─────────────┤                                                 │
│  │ hub_id (HK) │  Hash of business key                           │
│  │ business_key│  Natural identifier                             │
│  │ load_date   │  When record was loaded                         │
│  │ source      │  Origin system                                  │
│  └─────────────┘                                                 │
│                                                                   │
│  ┌─────────────┐                                                 │
│  │    LINK     │  Relationships between hubs                     │
│  ├─────────────┤                                                 │
│  │ link_id (HK)│  Hash of hub references                         │
│  │ hub1_id (FK)│  Reference to hub 1                             │
│  │ hub2_id (FK)│  Reference to hub 2                             │
│  │ load_date   │  When relationship was loaded                   │
│  │ source      │  Origin system                                  │
│  └─────────────┘                                                 │
│                                                                   │
│  ┌─────────────┐                                                 │
│  │  SATELLITE  │  Descriptive attributes                         │
│  ├─────────────┤                                                 │
│  │ hub_id (FK) │  Reference to parent hub/link                   │
│  │ load_date   │  When attributes were loaded                    │
│  │ load_end    │  End of validity period                         │
│  │ attributes  │  Descriptive columns                            │
│  │ source      │  Origin system                                  │
│  └─────────────┘                                                 │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

**Pros:**
- Full audit trail
- Historical tracking
- Flexible schema
- Source system agnostic

**Cons:**
- Complex queries
- Higher storage
- Steep learning curve
- More joins required

---

## Star Schema Design

### Sales Example

```sql
-- Dimension Tables
CREATE TABLE dim_date (
    date_key            INT PRIMARY KEY,
    full_date           DATE NOT NULL,
    day_of_week         VARCHAR(10),
    day_name            VARCHAR(10),
    month_name          VARCHAR(10),
    month_number        INT,
    quarter             INT,
    year                INT,
    is_weekend          BOOLEAN
);

CREATE TABLE dim_product (
    product_key         INT PRIMARY KEY,
    product_id          VARCHAR(50) NOT NULL,
    product_name        VARCHAR(200),
    category            VARCHAR(100),
    subcategory         VARCHAR(100),
    brand               VARCHAR(100),
    unit_price          DECIMAL(10,2),
    is_active           BOOLEAN
);

CREATE TABLE dim_customer (
    customer_key        INT PRIMARY KEY,
    customer_id         VARCHAR(50) NOT NULL,
    first_name          VARCHAR(100),
    last_name           VARCHAR(100),
    email               VARCHAR(255),
    segment             VARCHAR(50),
    region              VARCHAR(50),
    registration_date   DATE
);

CREATE TABLE dim_store (
    store_key           INT PRIMARY KEY,
    store_id            VARCHAR(50) NOT NULL,
    store_name          VARCHAR(200),
    city                VARCHAR(100),
    state               VARCHAR(50),
    country             VARCHAR(100),
    store_type          VARCHAR(50)
);

-- Fact Table
CREATE TABLE fact_sales (
    sale_id             BIGINT PRIMARY KEY,
    date_key            INT REFERENCES dim_date(date_key),
    product_key         INT REFERENCES dim_product(product_key),
    customer_key        INT REFERENCES dim_customer(customer_key),
    store_key           INT REFERENCES dim_store(store_key),
    quantity            INT,
    unit_price          DECIMAL(10,2),
    discount            DECIMAL(10,2),
    total_amount        DECIMAL(12,2),
    cost                DECIMAL(12,2),
    profit              DECIMAL(12,2)
);

-- Indexes
CREATE INDEX idx_fact_sales_date ON fact_sales(date_key);
CREATE INDEX idx_fact_sales_product ON fact_sales(product_key);
CREATE INDEX idx_fact_sales_customer ON fact_sales(customer_key);
```

### Query Patterns

```sql
-- Sales by category and month
SELECT
    d.year,
    d.month_name,
    p.category,
    SUM(f.total_amount) AS total_sales,
    SUM(f.profit) AS total_profit,
    COUNT(DISTINCT f.customer_key) AS unique_customers
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_key
JOIN dim_product p ON f.product_key = p.product_key
WHERE d.year = 2024
GROUP BY d.year, d.month_name, p.category
ORDER BY d.month_name, total_sales DESC;

-- Customer lifetime value
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    COUNT(DISTINCT f.sale_id) AS total_orders,
    SUM(f.total_amount) AS lifetime_value,
    AVG(f.total_amount) AS avg_order_value,
    MIN(d.full_date) AS first_purchase,
    MAX(d.full_date) AS last_purchase
FROM fact_sales f
JOIN dim_customer c ON f.customer_key = c.customer_key
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY lifetime_value DESC;
```

---

## Slowly Changing Dimensions (SCD)

### SCD Type 1 (Overwrite)

```sql
-- Overwrite existing record
UPDATE dim_customer
SET
    email = :new_email,
    segment = :new_segment,
    last_updated = CURRENT_TIMESTAMP
WHERE customer_id = :customer_id;

-- Insert if not exists
INSERT INTO dim_customer (customer_id, email, segment, last_updated)
SELECT :customer_id, :new_email, :new_segment, CURRENT_TIMESTAMP
WHERE NOT EXISTS (
    SELECT 1 FROM dim_customer WHERE customer_id = :customer_id
);
```

### SCD Type 2 (Historical)

```sql
-- Create new version
UPDATE dim_customer
SET
    effective_end_date = CURRENT_TIMESTAMP,
    is_current = FALSE
WHERE customer_id = :customer_id
AND is_current = TRUE;

INSERT INTO dim_customer (
    customer_id, email, segment, effective_start_date,
    effective_end_date, is_current, version
)
VALUES (
    :customer_id, :new_email, :new_segment, CURRENT_TIMESTAMP,
    NULL, TRUE,
    (SELECT COALESCE(MAX(version), 0) + 1
     FROM dim_customer WHERE customer_id = :customer_id)
);
```

### SCD Type 3 (Limited History)

```sql
-- Store previous value
UPDATE dim_customer
SET
    previous_email = current_email,
    current_email = :new_email,
    last_updated = CURRENT_TIMESTAMP
WHERE customer_id = :customer_id;
```

---

## Modern Data Warehouse

### Cloud Solutions Comparison

| Feature | Snowflake | BigQuery | Redshift | Databricks |
|---------|-----------|----------|----------|------------|
| Architecture | Separated | Serverless | Clustered | Lakehouse |
| Pricing | Per query/storage | Per query/storage | Per node/hour | Per DBU |
| Scaling | Instant | Automatic | Manual | Automatic |
| Concurrency | High | High | Limited | High |
| Semi-structured | Yes | Yes | Limited | Yes |
| ML Integration | Limited | Built-in | Limited | Native |
| Best For | Enterprise | Analytics | Cost-sensitive | ML workloads |

### Snowflake Example

```sql
-- Create warehouse
CREATE WAREHOUSE analytics_wh
    WAREHOUSE_SIZE = 'MEDIUM'
    AUTO_SUSPEND = 300
    AUTO_RESUME = TRUE;

-- Create database
CREATE DATABASE analytics
    DATA_RETENTION_TIME_IN_DAYS = 90;

-- Create schema
CREATE SCHEMA raw;
CREATE SCHEMA staging;
CREATE SCHEMA marts;

-- Create table with clustering
CREATE TABLE marts.sales (
    sale_id BIGINT,
    customer_id VARCHAR(50),
    product_id VARCHAR(50),
    sale_date DATE,
    amount DECIMAL(10,2)
)
CLUSTER BY (sale_date, customer_id);

-- Create materialized view
CREATE MATERIALIZED VIEW marts.daily_sales_summary AS
SELECT
    sale_date,
    COUNT(*) AS total_orders,
    SUM(amount) AS total_amount,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM marts.sales
GROUP BY sale_date;
```

---

## Data Warehouse Best Practices

### 1. Schema Design

```sql
-- Use appropriate data types
CREATE TABLE orders (
    order_id        BIGINT PRIMARY KEY,      -- Use BIGINT for IDs
    order_date      TIMESTAMP NOT NULL,       -- TIMESTAMP for precision
    customer_id     VARCHAR(50) NOT NULL,     -- VARCHAR for business keys
    order_status    VARCHAR(20),              -- VARCHAR for categories
    total_amount    DECIMAL(12,2),            -- DECIMAL for money
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
DISTSTYLE KEY
DISTKEY(customer_id)
SORTKEY(order_date);
```

### 2. Partitioning and Clustering

```sql
-- Partition by date (Redshift)
CREATE TABLE events (
    event_id BIGINT,
    event_date DATE,
    user_id INT
)
DISTSTYLE KEY
DISTKEY(user_id)
PARTITION BY event_date;

-- Cluster by multiple columns (Snowflake)
CREATE TABLE events (
    event_id BIGINT,
    event_date DATE,
    user_id INT,
    event_type VARCHAR(50)
)
CLUSTER BY (event_date, event_type);
```

### 3. Query Optimization

```sql
-- Use distribution keys wisely
-- Fact tables: Distribute by join key
-- Dimension tables: Distribute by all or replicate

-- Use sort keys for range queries
-- Sort by columns used in WHERE clauses

-- Use materialized views for common aggregations
CREATE MATERIALIZED VIEW mv_daily_sales AS
SELECT
    DATE_TRUNC('day', sale_date) AS sale_date,
    product_category,
    SUM(amount) AS total_sales
FROM fact_sales
JOIN dim_product ON fact_sales.product_key = dim_product.product_key
GROUP BY 1, 2;
```

### 4. Data Governance

```sql
-- Create roles
CREATE ROLE data_analyst;
CREATE ROLE data_engineer;
CREATE ROLE data_admin;

-- Grant permissions
GRANT USAGE ON DATABASE analytics TO ROLE data_analyst;
GRANT SELECT ON ALL TABLES IN SCHEMA marts TO ROLE data_analyst;
GRANT ALL ON SCHEMA staging TO ROLE data_engineer;
GRANT ALL ON DATABASE analytics TO ROLE data_admin;

-- Row-level security
CREATE ROW ACCESS POLICY customer_policy ON marts.customers
AS (segment VARCHAR) RETURNS BOOLEAN ->
    CASE
        WHEN CURRENT_ROLE() = 'data_admin' THEN TRUE
        WHEN segment = 'internal' THEN TRUE
        ELSE FALSE
    END;
```

---

## ETL vs ELT in Data Warehousing

| Aspect | ETL | ELT |
|--------|-----|-----|
| Transformation | Before loading | After loading |
| Target | Data warehouse | Data lake + warehouse |
| Raw data | Not stored | Stored |
| Processing | External tool | Database engine |
| Flexibility | Less | More |
| Cost | Higher infrastructure | Lower (cloud storage) |

---

## Summary

Key points:

1. **Choose the right modeling approach** - Kimball for analytics, Inmon for enterprise, Data Vault for audit
2. **Design efficient schemas** - Proper distribution, clustering, and partitioning
3. **Implement SCD correctly** - Type 1 for overwrite, Type 2 for history
4. **Optimize queries** - Materialized views, appropriate indexes
5. **Enforce governance** - Access control, row-level security, auditing
6. **Consider modern solutions** - Cloud data warehouses for flexibility and scalability
