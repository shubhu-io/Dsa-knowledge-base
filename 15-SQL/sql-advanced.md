# SQL Advanced Concepts

## 1. Indexing

### Why Indexes?

Indexes speed up data retrieval at the cost of slower writes and additional storage.

| Index Type | Description | Use Case |
|------------|-------------|----------|
| B-Tree | Balanced tree (default) | General purpose, equality + range |
| Hash | Hash table | Equality lookups only |
| GiST | Generalized Search Tree | Full-text, geometric data |
| GIN | Generalized Inverted Index | Array, JSONB, full-text search |
| BRIN | Block Range Index | Large tables with natural ordering |

```sql
-- Single-column index
CREATE INDEX idx_employees_dept_id ON employees(dept_id);

-- Composite index (order matters!)
CREATE INDEX idx_employees_dept_salary ON employees(dept_id, salary DESC);

-- Unique index
CREATE UNIQUE INDEX idx_employees_email ON employees(email);

-- Partial index
CREATE INDEX idx_employees_high_salary ON employees(salary)
WHERE salary > 100000;

-- Covering index (INCLUDE non-key columns)
CREATE INDEX idx_employees_dept_covering
ON employees(dept_id) INCLUDE (first_name, last_name, salary);
```

### Index Scan Types

```
Full Table Scan: Seq Scan on employees
Bitmap Scan:     Bitmap Heap Scan on employees
                 -> Bitmap Index Scan on idx_employees_dept_id
Index Scan:      Index Scan using idx_employees_dept_id on employees
Index Only Scan: Index Only Scan using idx_employees_dept_covering
```

### When Indexes Hurt

- Small tables (full scan is faster)
- Columns with low cardinality (e.g., boolean)
- Heavy write workloads (index maintenance cost)
- Columns rarely used in WHERE/JOIN/ORDER BY

## 2. Query Optimization

### EXPLAIN and EXPLAIN ANALYZE

```sql
EXPLAIN SELECT * FROM employees WHERE dept_id = 1;

EXPLAIN ANALYZE SELECT * FROM employees WHERE dept_id = 1;
```

### Optimizer Hints (PostgreSQL)

```sql
-- Force index scan
SET enable_seqscan = OFF;

-- Or use pg_hint_plan extension for fine-grained control
SELECT /*+ IndexScan(e idx_employees_dept_id) */
    e.first_name, e.last_name
FROM employees e
WHERE e.dept_id = 1;
```

### Common Optimization Patterns

```sql
-- 1. Use EXISTS instead of IN for subqueries (short-circuits)
SELECT * FROM departments d
WHERE EXISTS (SELECT 1 FROM employees e WHERE e.dept_id = d.dept_id);

-- 2. Avoid functions on indexed columns in WHERE
-- BAD: WHERE EXTRACT(YEAR FROM hire_date) = 2020
-- GOOD: WHERE hire_date >= '2020-01-01' AND hire_date < '2021-01-01'

-- 3. Use UNION ALL instead of UNION when duplicates don't matter
SELECT city FROM customers
UNION ALL
SELECT city FROM suppliers;

-- 4. Limit wildcard prefix LIKE patterns
-- BAD: WHERE name LIKE '%smith%'  (cannot use index)
-- GOOD: WHERE name LIKE 'smith%'  (can use index)
```

## 3. Transactions and Isolation

### Transaction Control

```sql
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;
COMMIT;

-- Or rollback on error
BEGIN;
UPDATE inventory SET quantity = quantity - 1 WHERE product_id = 10;
-- Something goes wrong...
ROLLBACK;
```

### Isolation Levels (ANSI SQL)

| Level | Dirty Read | Non-repeatable Read | Phantom Read |
|-------|-----------|---------------------|--------------|
| READ UNCOMMITTED | Possible | Possible | Possible |
| READ COMMITTED | Prevented | Possible | Possible |
| REPEATABLE READ | Prevented | Prevented | Possible |
| SERIALIZABLE | Prevented | Prevented | Prevented |

```sql
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN;
SELECT * FROM employees WHERE dept_id = 1;
-- Another transaction commits a new row with dept_id=1 here
SELECT * FROM employees WHERE dept_id = 1;  -- may see different results
COMMIT;
```

## 4. Views and Materialized Views

### Views (Virtual Tables)

```sql
CREATE VIEW employee_details AS
SELECT e.emp_id, e.first_name, e.last_name, d.dept_name, e.salary
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id;

-- Use like a table
SELECT * FROM employee_details WHERE salary > 80000;

-- Updatable views (simple views only)
CREATE VIEW engineering_employees AS
SELECT emp_id, first_name, last_name, salary
FROM employees
WHERE dept_id = (SELECT dept_id FROM departments WHERE dept_name = 'Engineering')
WITH CHECK OPTION;  -- prevents inserting rows outside the view
```

### Materialized Views (Physically Stored)

```sql
CREATE MATERIALIZED VIEW dept_salary_summary AS
SELECT d.dept_name, COUNT(*) AS emp_count, AVG(e.salary) AS avg_salary
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_name;

-- Refresh (re-runs the query)
REFRESH MATERIALIZED VIEW dept_salary_summary;

-- Concurrent refresh (allows reads during refresh)
REFRESH MATERIALIZED VIEW CONCURRENTLY dept_salary_summary;
```

## 5. Stored Procedures and Functions

### Functions (Return a Value)

```sql
CREATE FUNCTION get_employee_count(dept_id_param INTEGER)
RETURNS INTEGER
LANGUAGE SQL
AS $$
    SELECT COUNT(*) FROM employees WHERE dept_id = dept_id_param;
$$;

-- Call it
SELECT get_employee_count(1);
```

### Stored Procedures (Procedural)

```sql
CREATE PROCEDURE give_raise(
    emp_id_param INTEGER,
    percent DECIMAL(5,2)
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE employees
    SET salary = salary * (1 + percent / 100)
    WHERE emp_id = emp_id_param;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Employee % not found', emp_id_param;
    END IF;
END;
$$;

CALL give_raise(1, 10.0);
```

## 6. Triggers

```sql
-- Trigger function (runs before/after an event)
CREATE FUNCTION log_salary_changes()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO salary_audit (emp_id, old_salary, new_salary, changed_by, changed_at)
    VALUES (OLD.emp_id, OLD.salary, NEW.salary, CURRENT_USER, NOW());
    RETURN NEW;
END;
$$;

-- Create trigger
CREATE TRIGGER trg_salary_update
AFTER UPDATE OF salary ON employees
FOR EACH ROW
EXECUTE FUNCTION log_salary_changes();
```

## 7. Advanced Data Types

### JSON / JSONB (PostgreSQL)

```sql
CREATE TABLE events (
    id SERIAL PRIMARY KEY,
    event_data JSONB NOT NULL
);

INSERT INTO events (event_data) VALUES
('{"type": "click", "user": "alice", "page": "/home", "timestamp": "2025-01-15T10:00:00Z"}'),
('{"type": "purchase", "user": "bob", "amount": 49.99, "items": [{"sku": "A1", "qty": 1}]}');

-- JSON queries
SELECT event_data->>'user' AS username
FROM events
WHERE event_data @> '{"type": "click"}';

-- Index JSONB
CREATE INDEX idx_events_type ON events USING GIN (event_data jsonb_path_ops);
```

### Arrays

```sql
CREATE TABLE articles (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200),
    tags TEXT[]  -- PostgreSQL array
);

INSERT INTO articles (title, tags) VALUES
('SQL Tips', ARRAY['database', 'sql', 'tutorial']),
('Advanced Joins', ARRAY['sql', 'intermediate']);

-- Array queries
SELECT * FROM articles WHERE 'sql' = ANY(tags);
SELECT * FROM articles WHERE tags @> ARRAY['sql', 'database'];
```

## 8. Full-Text Search

```sql
-- Create tsvector column
ALTER TABLE articles ADD COLUMN search_vector TSVECTOR;

-- Populate
UPDATE articles SET search_vector =
    to_tsvector('english', title || ' ' || COALESCE(body, ''));

-- GIN index for full-text
CREATE INDEX idx_articles_search ON articles USING GIN(search_vector);

-- Search
SELECT title FROM articles
WHERE search_vector @@ to_tsquery('english', 'sql & tips');
```

## 9. Partitioning

```sql
-- Range partitioning
CREATE TABLE sales (
    sale_id SERIAL,
    sale_date DATE NOT NULL,
    amount DECIMAL(10,2),
    region VARCHAR(50)
) PARTITION BY RANGE (sale_date);

CREATE TABLE sales_2024 PARTITION OF sales
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE sales_2025 PARTITION OF sales
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

-- List partitioning
CREATE TABLE customers_by_region PARTITION OF customers
    FOR VALUES IN ('Northeast', 'Southeast');

-- Hash partitioning
CREATE TABLE logs_partitioned PARTITION OF logs
    FOR VALUES WITH (MODULUS 4, REMAINDER 0);
```

## 10. Performance Tuning Checklist

| Step | Action |
|------|--------|
| 1 | Run EXPLAIN ANALYZE on slow queries |
| 2 | Check for missing indexes (seq scans on large tables) |
| 3 | Avoid SELECT * — fetch only needed columns |
| 4 | Use connection pooling (PgBouncer, etc.) |
| 5 | Tune PostgreSQL config (shared_buffers, work_mem, effective_cache_size) |
| 6 | Partition large tables |
| 7 | Use VACUUM and ANALYZE regularly |
| 8 | Archive or purge old data |
| 9 | Consider read replicas for heavy read workloads |
| 10 | Monitor slow query log |
