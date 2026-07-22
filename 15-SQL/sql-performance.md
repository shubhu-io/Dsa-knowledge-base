# SQL Performance Optimization

This document covers techniques for optimizing SQL queries and database performance.

## Query Optimization

### Use Indexes Effectively
Indexes speed up data retrieval but slow down writes. Create indexes on:
- Columns used in WHERE clauses
- Columns used in JOIN conditions
- Columns used in ORDER BY and GROUP BY clauses

```sql
-- Good: Index on filtered column
CREATE INDEX idx_users_email ON users(email);
SELECT * FROM users WHERE email = 'user@example.com';

-- Avoid: Functions on indexed columns prevent index usage
SELECT * FROM users WHERE UPPER(email) = 'USER@EXAMPLE.COM';
```

### Avoid SELECT *
Specify only the columns you need to reduce data transfer and memory usage.

```sql
-- Bad
SELECT * FROM users;

-- Good
SELECT id, name, email FROM users;
```

### Use LIMIT for Large Result Sets
```sql
-- Good for pagination
SELECT * FROM users ORDER BY created_at DESC LIMIT 10 OFFSET 0;
```

## JOIN Optimization

### Use INNER JOIN Instead of WHERE for Joins
```sql
-- Better
SELECT u.name, o.total
FROM users u
INNER JOIN orders o ON u.id = o.user_id;

-- Less efficient
SELECT u.name, o.total
FROM users u, orders o
WHERE u.id = o.user_id;
```

### Avoid Cartesian Products
Always ensure JOIN conditions are specified to prevent unintended cross joins.

### Choose the Right JOIN Type
- Use INNER JOIN when you only need matching records
- Use LEFT JOIN when you need all records from the left table
- Use EXISTS instead of IN for subqueries with large datasets

```sql
-- Better for large datasets
SELECT * FROM users u
WHERE EXISTS (
    SELECT 1 FROM orders o WHERE o.user_id = u.id
);

-- Less efficient for large datasets
SELECT * FROM users
WHERE id IN (SELECT user_id FROM orders);
```

## Subquery Optimization

### Correlated vs Non-Correlated Subqueries
Non-correlated subqueries are evaluated once, while correlated subqueries are evaluated for each row.

```sql
-- Non-correlated (better)
SELECT * FROM users
WHERE id IN (SELECT user_id FROM orders WHERE total > 100);

-- Correlated (slower)
SELECT * FROM users u
WHERE EXISTS (
    SELECT 1 FROM orders o
    WHERE o.user_id = u.id AND o.total > 100
);
```

## Index Strategies

### Types of Indexes
1. **B-Tree Index**: Default for most databases, good for range queries
2. **Hash Index**: Fast for exact matches, not supported in all databases
3. **Composite Index**: Index on multiple columns (order matters)
4. **Covering Index**: Includes all columns needed for a query

### Composite Index Order
Place the most selective columns first in composite indexes.

```sql
-- If filtering by both columns, order matters
CREATE INDEX idx_orders_user_date ON orders(user_id, order_date);
```

### Index Maintenance
- Regularly rebuild fragmented indexes
- Remove unused indexes
- Monitor index usage statistics

## Database Design Considerations

### Normalization vs Denormalization
- Normalize to reduce data redundancy (1NF, 2NF, 3NF)
- Denormalize for read-heavy workloads (data warehouses)

### Partitioning
Split large tables into smaller, more manageable pieces:
- **Horizontal partitioning**: Split by rows (by date, by ID range)
- **Vertical partitioning**: Split by columns

```sql
-- Example: Partition by date
CREATE TABLE orders_2023 PARTITION OF orders
FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');
```

## Query Execution Plans

### Using EXPLAIN
Analyze query execution plans to identify bottlenecks.

```sql
EXPLAIN SELECT u.name, COUNT(o.id) as order_count
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name;
```

### Common Execution Plan Issues
- **Sequential scans**: Consider adding indexes
- **Nested loops**: May indicate missing indexes
- **Temporary tables**: May indicate query restructuring needed

## Memory and Storage Optimization

### Buffer Pool Size
Configure database buffer pool to hold frequently accessed data in memory.

### Storage Engine Selection
- **InnoDB**: Default in MySQL, supports transactions and row-level locking
- **MyISAM**: Faster for read-heavy workloads, no transaction support

### Column Types
Use the smallest data type that fits your data:
- Use `INT` instead of `BIGINT` when possible
- Use `VARCHAR(n)` instead of `TEXT` for short strings
- Use `DATE` instead of `DATETIME` when time is not needed

## Monitoring and Profiling

### Slow Query Log
Enable slow query logging to identify problematic queries.

```sql
-- MySQL configuration
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 1;
```

### Key Metrics to Monitor
- Query execution time
- Number of rows examined vs returned
- Index usage
- Lock wait times
- Buffer pool hit ratio

## Caching Strategies

### Query Result Caching
Cache frequently executed query results to avoid repeated computation.

### Application-Level Caching
Use Redis or Memcached for caching query results at the application level.

## Best Practices Summary

1. **Write efficient queries** - Avoid unnecessary columns and rows
2. **Use indexes wisely** - Create on frequently queried columns
3. **Monitor performance** - Use EXPLAIN and profiling tools
4. **Optimize schema design** - Normalize appropriately
5. **Consider caching** - Cache expensive query results
6. **Regular maintenance** - Update statistics, rebuild indexes
7. **Test with realistic data** - Use production-like data volumes

## See Also

- [[sql-guide]]
- [[sql-advanced]]
- [[sql-interview-questions]]
- [[sql-queries]]
