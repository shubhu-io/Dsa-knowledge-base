# Database Indexing Guide

This document covers database indexing strategies and optimization techniques.

## What is an Index?

An index is a data structure that improves the speed of data retrieval operations on a table at the cost of additional storage space and slower writes. Indexes are used to quickly locate data without having to search every row in a database table every time the table is accessed.

## Types of Indexes

### B-Tree Index (Default)
Most common index type, used for range queries and equality searches.

```sql
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_name ON users(last_name, first_name);
```

### Hash Index
Used only for equality comparisons. Faster than B-tree for exact matches but doesn't support range queries.

```sql
CREATE INDEX idx_users_email_hash ON users USING HASH(email);
```

### Partial Index
Index only a subset of rows based on a condition.

```sql
CREATE INDEX idx_orders_pending ON orders(order_date)
WHERE status = 'pending';
```

### Covering Index
Contains all columns needed for a query, avoiding table lookups.

```sql
CREATE INDEX idx_users_email_name ON users(email, name);
-- Query uses only indexed columns
SELECT name FROM users WHERE email = 'user@example.com';
```

### Multi-Column Index
Index on multiple columns. Column order matters based on query patterns.

```sql
CREATE INDEX idx_orders_user_date ON orders(user_id, order_date);
```

## Index Design Principles

### When to Create Indexes
- Columns frequently used in WHERE clauses
- Columns used in JOIN conditions
- Columns used in ORDER BY and GROUP BY
- Columns with high cardinality (many unique values)

### When NOT to Index
- Small tables (full scan is faster)
- Columns rarely used in queries
- Columns with low cardinality (few unique values)
- Frequently updated columns (write overhead)

### Index Column Order
1. Equality conditions first
2. Range conditions next
3. Sort conditions last

## Index Performance Analysis

### EXPLAIN Command
```sql
EXPLAIN SELECT * FROM users WHERE email = 'test@example.com';
```

### Key Metrics to Look For
- **Seq Scan**: Sequential scan (missing index)
- **Index Scan**: Using an index (good)
- **Index Only Scan**: Using covering index (best)
- **Rows**: Number of rows examined vs returned

## Index Maintenance

### Rebuild Fragmented Indexes
```sql
-- SQL Server
ALTER INDEX idx_name ON table_name REBUILD;

-- PostgreSQL
REINDEX INDEX idx_name;

-- MySQL
ALTER TABLE table_name ENGINE=InnoDB;
```

### Monitor Index Usage
```sql
-- PostgreSQL
SELECT * FROM pg_stat_user_indexes;

-- SQL Server
SELECT * FROM sys.dm_db_index_usage_stats;
```

### Remove Unused Indexes
```sql
-- PostgreSQL
SELECT * FROM pg_stat_user_indexes
WHERE idx_scan = 0;
```

## Common Index Mistakes

### Over-Indexing
Too many indexes slow down write operations and consume storage.

### Under-Indexing
Missing indexes cause slow queries and poor performance.

### Wrong Column Order
Multi-column indexes with wrong order don't benefit certain queries.

### Not Considering Query Patterns
Indexes should match actual query patterns, not theoretical ones.

## Composite Index Strategies

### Leftmost Prefix Rule
A composite index (A, B, C) can be used for:
- Queries on A
- Queries on A, B
- Queries on A, B, C
- Cannot be used for queries on B, C only

### Index Selectivity
High selectivity (many unique values) makes indexes more effective.

## Index Statistics

### Cardinality
Number of distinct values in a column affects index effectiveness.

### Selectivity
Ratio of distinct values to total rows. Higher selectivity = better index performance.

### Correlation
How well the physical order matches the logical order of the index.

## See Also

- [[dbms-guide]]
- [[dbms-normalization]]
- [[dbms-transactions]]
- [[dbms-interview-questions]]
