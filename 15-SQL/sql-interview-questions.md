# SQL Interview Questions

## Basic Questions

### Q1: What is the difference between WHERE and HAVING?

| Clause | Applies To | Used With |
|--------|-----------|-----------|
| `WHERE` | Individual rows (before grouping) | SELECT, UPDATE, DELETE |
| `HAVING` | Groups (after GROUP BY) | SELECT with GROUP BY |

```sql
SELECT dept_id, AVG(salary) AS avg_salary
FROM employees
WHERE hire_date > '2020-01-01'    -- filter rows first
GROUP BY dept_id
HAVING AVG(salary) > 70000;       -- filter groups after
```

### Q2: What is the difference between DELETE, TRUNCATE, and DROP?

| Operation | Type | Speed | Can Rollback? | Resets Identity? | Preserves Structure? |
|-----------|------|-------|--------------|-----------------|---------------------|
| `DELETE` | DML | Slow (row-by-row) | Yes | No | Yes |
| `TRUNCATE` | DDL | Fast | No* | Yes | Yes |
| `DROP` | DDL | Fast | No | N/A | No |

\*TRUNCATE can be rolled back in a transaction block.

### Q3: What are primary keys and foreign keys?

- **Primary Key**: Uniquely identifies each row. Must be unique and NOT NULL.
- **Foreign Key**: References a primary key in another table. Enforces referential integrity.

```sql
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id) -- FK
);
```

### Q4: Explain SQL normalization.

Normalization reduces data redundancy by organizing data into related tables. Common forms:

- **1NF**: Each column contains atomic (indivisible) values; each row is unique.
- **2NF**: In 1NF + all non-key columns depend on the full primary key.
- **3NF**: In 2NF + no transitive dependencies (non-key columns depend only on the key).
- **BCNF**: Every determinant must be a candidate key.

### Q5: What is the difference between CHAR and VARCHAR?

`CHAR(n)` is fixed-length (padded with spaces). `VARCHAR(n)` is variable-length (1-2 bytes overhead). Use CHAR for fixed-length codes (ISO country codes, postal codes). Use VARCHAR for variable text (names, emails).

### Q6: What is a JOIN? Explain different types.

A JOIN combines rows from two or more tables based on a related column.

```sql
INNER JOIN     -- Only matching rows in both tables
LEFT JOIN      -- All rows from left, matching from right (NULLs for non-matches)
RIGHT JOIN     -- All rows from right, matching from left
FULL JOIN      -- All rows from both tables
CROSS JOIN     -- Cartesian product (every row × every row)
SELF JOIN      -- Table joined with itself
```

---

## Intermediate Questions

### Q7: What is the difference between UNION and UNION ALL?

`UNION` removes duplicate rows (slower, sorts internally). `UNION ALL` includes duplicates (faster).

```sql
SELECT city FROM customers
UNION        -- 50 rows (deduplicated)
SELECT city FROM suppliers;

SELECT city FROM customers
UNION ALL    -- 72 rows (may include duplicates)
SELECT city FROM suppliers;
```

### Q8: Explain correlated vs. non-correlated subqueries.

A **non-correlated** subquery runs once, independent of the outer query. A **correlated** subquery references the outer query and runs for each row.

```sql
-- Non-correlated (runs once)
SELECT * FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- Correlated (runs per row)
SELECT e.* FROM employees e
WHERE salary > (
    SELECT AVG(salary) FROM employees WHERE dept_id = e.dept_id
);
```

### Q9: What are window functions? Give examples.

Window functions perform calculations across a set of rows related to the current row without collapsing them.

```sql
ROW_NUMBER()       -- Unique sequential number
RANK()             -- Rank with gaps
DENSE_RANK()       -- Rank without gaps
NTILE(n)           -- Divide into n buckets
LAG() / LEAD()     -- Access previous/next row
FIRST_VALUE()      -- First value in window
SUM() OVER(...)    -- Running total
```

### Q10: What is a CTE and when would you use it?

A Common Table Expression (WITH clause) creates a temporary named result set for a single query. Use cases: recursive queries, readability, replacing subqueries.

```sql
WITH high_earners AS (
    SELECT * FROM employees WHERE salary > 90000
)
SELECT dept_id, COUNT(*) FROM high_earners GROUP BY dept_id;
```

### Q11: What is the difference between clustered and non-clustered indexes?

| Type | Clustered | Non-Clustered |
|------|-----------|---------------|
| Data storage | Data stored at leaf level | Leaf stores pointer to data |
| Per table | 1 (like a dictionary) | Many (like an index in a book) |
| Order | Physical sort order | Logical order only |
| Speed | Fast for range queries | Fast for exact lookups |

### Q12: Explain ACID properties.

- **Atomicity**: Transaction is all-or-nothing.
- **Consistency**: Database moves from one valid state to another.
- **Isolation**: Concurrent transactions don't interfere.
- **Durability**: Committed changes survive failures.

---

## Advanced Questions

### Q13: How would you find duplicate rows in a table?

```sql
SELECT email, COUNT(*)
FROM employees
GROUP BY email
HAVING COUNT(*) > 1;

-- Delete duplicates (keep the one with smallest ID)
DELETE FROM employees
WHERE emp_id NOT IN (
    SELECT MIN(emp_id) FROM employees GROUP BY email
);
```

### Q14: Explain the N+1 query problem and how to solve it.

The N+1 problem occurs when you query a parent table (1 query) and then loop through results to query a child table (N queries). Solution: use JOIN or batch fetching.

```sql
-- N+1 (bad pattern)
-- For each department: SELECT * FROM employees WHERE dept_id = ?

-- Solution with JOIN
SELECT d.dept_name, e.first_name, e.last_name
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id;
```

### Q15: What is a deadlock? How would you prevent it?

A deadlock occurs when two transactions each hold a lock the other needs. Prevention:
- Access tables in the same order across transactions.
- Keep transactions short.
- Use a timeout (`LOCK_TIMEOUT`).
- Use lower isolation levels when safe.

### Q16: How do you optimize a slow query?

1. Run `EXPLAIN ANALYZE` to see the execution plan.
2. Check for sequential scans on large tables (missing indexes).
3. Verify join columns are indexed.
4. Avoid functions in WHERE clauses on indexed columns.
5. Consider rewriting with CTEs or temp tables.
6. Check if you need all columns (avoid SELECT *).
7. Look at PostgreSQL's `pg_stat_statements` for frequent queries.

### Q17: Explain database sharding vs. partitioning.

| Aspect | Sharding (Horizontal) | Partitioning |
|--------|----------------------|--------------|
| Scope | Across multiple servers/databases | Within a single database |
| Transparency | Application-aware | Transparent to application |
| Complexity | High (routing, resharding) | Low |
| Use case | Massive scale-out | Manage large tables |

### Q18: What is the difference between OLTP and OLAP?

| Aspect | OLTP | OLAP |
|--------|------|------|
| Purpose | Transaction processing | Analytical queries |
| Workload | Many small inserts/updates | Large scans, aggregations |
| Design | Normalized | Denormalized (star/snowflake) |
| Indexes | Many (for fast lookups) | Few (for scan efficiency) |
| Examples | E-commerce orders | Sales reporting |

### Q19: How do you implement pagination efficiently?

```sql
-- OFFSET-based (slow for large offsets — scans all skipped rows)
SELECT * FROM employees ORDER BY emp_id LIMIT 10 OFFSET 1000;

-- Keyset/cursor-based (efficient, uses index)
SELECT * FROM employees
WHERE emp_id > 1000
ORDER BY emp_id
LIMIT 10;
```

### Q20: What is the difference between "DELETE FROM" and "TRUNCATE TABLE" in terms of transaction logging?

`DELETE` logs each row deletion individually (can be rolled back). `TRUNCATE` deallocates entire data pages (minimal logging). In most databases, TRUNCATE cannot be rolled back unless used inside a transaction (supported in PostgreSQL, MySQL).

### Q21: Explain locking granularity in databases.

| Level | Description |
|-------|-------------|
| Row-level | Locks a single row (highest concurrency) |
| Page-level | Locks a data page (8KB typically) |
| Table-level | Locks the entire table |
| Database-level | Locks the entire database |

### Q22: What is a materialized view? How is it different from a regular view?

- **Regular View**: Virtual — stores only the query definition (always shows current data).
- **Materialized View**: Physical — stores the result set (faster reads, needs refresh).

### Q23: How would you design a table for a comment system with nested replies?

```sql
-- Adjacency list (simpler)
CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    parent_id INTEGER REFERENCES comments(id),  -- NULL = top-level
    content TEXT NOT NULL,
    author_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- OR use a closure table for deeper hierarchies
CREATE TABLE comment_paths (
    ancestor_id INTEGER REFERENCES comments(id),
    descendant_id INTEGER REFERENCES comments(id),
    depth INTEGER NOT NULL,
    PRIMARY KEY (ancestor_id, descendant_id)
);
```

### Q24: Explain the concept of "Covering Index".

A covering index contains all columns needed by a query, allowing the database to satisfy the query entirely from the index without accessing the table. In PostgreSQL, use `INCLUDE`:

```sql
CREATE INDEX idx_covering ON employees (dept_id) INCLUDE (first_name, salary);

-- This query can be served entirely from the index:
SELECT first_name, salary FROM employees WHERE dept_id = 1;
```

### Q25: What is the difference between `RANK()`, `DENSE_RANK()`, and `ROW_NUMBER()`?

| Function | Ties | Next Rank |
|----------|------|-----------|
| `ROW_NUMBER()` | No ties (arbitrary) | N/A |
| `RANK()` | Same rank | Skips (1,1,3,4) |
| `DENSE_RANK()` | Same rank | No skip (1,1,2,3) |

```sql
SELECT
    first_name, salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC) AS rn,
    RANK()       OVER (ORDER BY salary DESC) AS rk,
    DENSE_RANK() OVER (ORDER BY salary DESC) AS dr
FROM employees;
```
