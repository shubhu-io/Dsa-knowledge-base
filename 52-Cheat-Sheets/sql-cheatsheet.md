# SQL Cheat Sheet for DSA

Quick reference for SQL queries, joins, indexes, and optimization techniques.

---

## Basic Queries

```sql
-- SELECT
SELECT column1, column2 FROM table_name;
SELECT * FROM table_name;
SELECT DISTINCT column1 FROM table_name;

-- WHERE
SELECT * FROM employees WHERE salary > 50000;
SELECT * FROM employees WHERE department = 'Engineering' AND salary > 80000;
SELECT * FROM employees WHERE name LIKE '%Smith%';
SELECT * FROM employees WHERE name IN ('Alice', 'Bob');
SELECT * FROM employees WHERE salary BETWEEN 50000 AND 100000;
SELECT * FROM employees WHERE manager_id IS NULL;

-- ORDER BY
SELECT * FROM employees ORDER BY salary DESC;
SELECT * FROM employees ORDER BY department ASC, salary DESC;

-- LIMIT
SELECT * FROM employees LIMIT 10;
SELECT * FROM employees LIMIT 10 OFFSET 20;  -- Pagination
```

---

## Aggregate Functions

```sql
-- COUNT
SELECT COUNT(*) FROM employees;
SELECT COUNT(DISTINCT department) FROM employees;

-- SUM, AVG, MIN, MAX
SELECT SUM(salary) FROM employees;
SELECT AVG(salary) FROM employees;
SELECT MIN(salary), MAX(salary) FROM employees;

-- GROUP BY
SELECT department, COUNT(*) as count, AVG(salary) as avg_salary
FROM employees
GROUP BY department;

-- HAVING (filter after GROUP BY)
SELECT department, AVG(salary) as avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 70000;
```

---

## Joins

```sql
-- INNER JOIN (only matching rows)
SELECT e.name, d.department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.id;

-- LEFT JOIN (all from left, matching from right)
SELECT e.name, d.department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.id;

-- RIGHT JOIN (all from right, matching from left)
SELECT e.name, d.department_name
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.id;

-- FULL OUTER JOIN (all from both)
SELECT e.name, d.department_name
FROM employees e
FULL OUTER JOIN departments d ON e.department_id = d.id;

-- CROSS JOIN (all combinations)
SELECT e.name, d.department_name
FROM employees e
CROSS JOIN departments d;

-- Self Join
SELECT e.name as employee, m.name as manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.id;
```

---

## Subqueries

```sql
-- WHERE subquery
SELECT * FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- FROM subquery
SELECT department, avg_salary
FROM (SELECT department, AVG(salary) as avg_salary
      FROM employees
      GROUP BY department) dept_avg
WHERE avg_salary > 70000;

-- EXISTS
SELECT * FROM departments d
WHERE EXISTS (
    SELECT 1 FROM employees e
    WHERE e.department_id = d.id
);

-- IN subquery
SELECT * FROM employees
WHERE department_id IN (
    SELECT id FROM departments
    WHERE location = 'New York'
);
```

---

## Window Functions

```sql
-- ROW_NUMBER
SELECT *,
    ROW_NUMBER() OVER (ORDER BY salary DESC) as rank
FROM employees;

-- RANK and DENSE_RANK
SELECT *,
    RANK() OVER (ORDER BY salary DESC) as rank,
    DENSE_RANK() OVER (ORDER BY salary DESC) as dense_rank
FROM employees;

-- PARTITION BY
SELECT *,
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) as dept_rank
FROM employees;

-- LAG and LEAD
SELECT *,
    LAG(salary, 1) OVER (ORDER BY hire_date) as prev_salary,
    LEAD(salary, 1) OVER (ORDER BY hire_date) as next_salary
FROM employees;

-- Running total
SELECT *,
    SUM(salary) OVER (ORDER BY hire_date) as running_total
FROM employees;

-- NTILE (quartiles)
SELECT *,
    NTILE(4) OVER (ORDER BY salary) as quartile
FROM employees;
```

---

## Common Table Expressions (CTEs)

```sql
-- Basic CTE
WITH DepartmentStats AS (
    SELECT department,
           COUNT(*) as emp_count,
           AVG(salary) as avg_salary
    FROM employees
    GROUP BY department
)
SELECT * FROM DepartmentStats
WHERE avg_salary > 70000;

-- Recursive CTE (hierarchy)
WITH RECURSIVE EmployeeHierarchy AS (
    SELECT id, name, manager_id, 1 as level
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    SELECT e.id, e.name, e.manager_id, eh.level + 1
    FROM employees e
    JOIN EmployeeHierarchy eh ON e.manager_id = eh.id
)
SELECT * FROM EmployeeHierarchy;
```

---

## Indexes

```sql
-- Create index
CREATE INDEX idx_employees_salary ON employees(salary);

-- Composite index
CREATE INDEX idx_employees_dept_salary ON employees(department_id, salary);

-- Unique index
CREATE UNIQUE INDEX idx_employees_email ON employees(email);

-- Partial index (PostgreSQL)
CREATE INDEX idx_high_salary ON employees(salary)
WHERE salary > 100000;

-- Drop index
DROP INDEX idx_employees_salary;

-- Show indexes
SHOW INDEX FROM employees;
```

---

## Performance Tips

### Use EXPLAIN

```sql
EXPLAIN SELECT * FROM employees WHERE salary > 50000;

-- PostgreSQL
EXPLAIN ANALYZE SELECT * FROM employees WHERE salary > 50000;
```

### Common Optimizations

```sql
-- 1. Avoid SELECT *
SELECT id, name, salary FROM employees;

-- 2. Use appropriate indexes
CREATE INDEX idx_salary ON employees(salary);

-- 3. Avoid functions on indexed columns
-- Bad
SELECT * FROM employees WHERE YEAR(hire_date) = 2024;
-- Good
SELECT * FROM employees WHERE hire_date >= '2024-01-01' 
                          AND hire_date < '2025-01-01';

-- 4. Use LIMIT for large result sets
SELECT * FROM employees LIMIT 100;

-- 5. Avoid LIKE with leading wildcard
-- Bad
SELECT * FROM employees WHERE name LIKE '%smith%';
-- Good (with full-text index)
SELECT * FROM employees WHERE name @@ 'smith';
```

---

## Data Definition

```sql
-- Create table
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    salary DECIMAL(10, 2),
    department_id INT,
    hire_date DATE DEFAULT CURRENT_DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Alter table
ALTER TABLE employees ADD COLUMN phone VARCHAR(20);
ALTER TABLE employees DROP COLUMN phone;
ALTER TABLE employees MODIFY COLUMN name VARCHAR(150);
ALTER TABLE employees RENAME COLUMN name TO full_name;

-- Drop table
DROP TABLE IF EXISTS employees;

-- Truncate (delete all rows, keep structure)
TRUNCATE TABLE employees;
```

---

## Common Patterns

### Pagination

```sql
-- Offset-based
SELECT * FROM employees
ORDER BY id
LIMIT 10 OFFSET 20;

-- Cursor-based (more efficient)
SELECT * FROM employees
WHERE id > 1000
ORDER BY id
LIMIT 10;
```

### Deduplication

```sql
-- Keep first occurrence
DELETE FROM employees
WHERE id NOT IN (
    SELECT MIN(id)
    FROM employees
    GROUP BY email
);

-- Using window function
WITH RankedEmployees AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY email ORDER BY id) as rn
    FROM employees
)
DELETE FROM RankedEmployees WHERE rn > 1;
```

### Hierarchical Data

```sql
-- Find all subordinates
WITH RECURSIVE subordinates AS (
    SELECT id, name, manager_id
    FROM employees
    WHERE id = 1  -- Starting manager
    
    UNION ALL
    
    SELECT e.id, e.name, e.manager_id
    FROM employees e
    JOIN subordinates s ON e.manager_id = s.id
)
SELECT * FROM subordinates;
```

---

## Useful Functions

```sql
-- String functions
UPPER('hello')          -- 'HELLO'
LOWER('HELLO')          -- 'hello'
LENGTH('hello')         -- 5
CONCAT('Hello', ' ', 'World')  -- 'Hello World'
SUBSTRING('hello' FROM 2 FOR 3)  -- 'ell'
TRIM('  hello  ')       -- 'hello'
REPLACE('hello', 'l', 'r')  -- 'herro'

-- Date functions
NOW()                   -- Current timestamp
CURRENT_DATE            -- Current date
EXTRACT(YEAR FROM date) -- Extract year
DATE_ADD(date, INTERVAL 1 DAY)
DATE_DIFF(date1, date2)

-- Math functions
ABS(-5)                 -- 5
CEIL(4.2)              -- 5
FLOOR(4.8)             -- 4
ROUND(4.567, 2)        -- 4.57
POWER(2, 3)            -- 8
SQRT(16)               -- 4

-- Conversion
CAST('123' AS INTEGER)
TO_DATE('2024-01-01', 'YYYY-MM-DD')
COALESCE(NULL, 'default')  -- 'default'
NULLIF(0, 0)           -- NULL
```

---

## Common Interview Queries

### Second Highest Salary

```sql
SELECT MAX(salary) as second_highest
FROM employees
WHERE salary < (SELECT MAX(salary) FROM employees);

-- Alternative with LIMIT
SELECT DISTINCT salary
FROM employees
ORDER BY salary DESC
LIMIT 1 OFFSET 1;
```

### Departments with No Employees

```sql
SELECT d.name
FROM departments d
LEFT JOIN employees e ON d.id = e.department_id
WHERE e.id IS NULL;
```

### Top N Per Group

```sql
WITH RankedEmployees AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) as rn
    FROM employees
)
SELECT * FROM RankedEmployees WHERE rn <= 3;
```

### Year-over-Year Growth

```sql
WITH YearlySales AS (
    SELECT 
        EXTRACT(YEAR FROM order_date) as year,
        SUM(amount) as total_sales
    FROM orders
    GROUP BY 1
)
SELECT 
    year,
    total_sales,
    LAG(total_sales) OVER (ORDER BY year) as prev_year,
    ROUND((total_sales - LAG(total_sales) OVER (ORDER BY year)) / 
          LAG(total_sales) OVER (ORDER BY year) * 100, 2) as growth_pct
FROM YearlySales;
```
