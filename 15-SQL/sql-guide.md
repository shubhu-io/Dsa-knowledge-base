# SQL Guide — Fundamentals

## 1. What is SQL?

SQL (Structured Query Language) is a domain-specific language designed for managing data held in a relational database management system (RDBMS). It was first developed at IBM in the 1970s and standardized by ANSI and ISO.

## 2. Data Types

### Common SQL Data Types

| Type | Category | Example |
|------|----------|---------|
| `INTEGER` / `INT` | Numeric | `25` |
| `DECIMAL(p,s)` / `NUMERIC(p,s)` | Numeric (exact) | `1234.56` |
| `FLOAT(p)` / `REAL` | Numeric (approximate) | `3.14159` |
| `VARCHAR(n)` | String (variable) | `'John'` |
| `CHAR(n)` | String (fixed) | `'NY'` |
| `TEXT` | String (large) | long paragraph |
| `DATE` | Date | `'2025-01-15'` |
| `TIMESTAMP` | Date + Time | `'2025-01-15 10:30:00'` |
| `BOOLEAN` | Logical | `TRUE` / `FALSE` |
| `BLOB` | Binary | image, file |

### String vs. Char

- `CHAR(10)` — always stores 10 characters (padded with spaces)
- `VARCHAR(10)` — stores up to 10 characters (no padding)

## 3. DDL — Data Definition Language

### CREATE

```sql
CREATE DATABASE company;

CREATE TABLE employees (
    emp_id     SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    email      VARCHAR(100) UNIQUE NOT NULL,
    hire_date  DATE DEFAULT CURRENT_DATE,
    salary     DECIMAL(10,2) CHECK (salary > 0),
    dept_id    INTEGER REFERENCES departments(dept_id)
);
```

### ALTER

```sql
-- Add a column
ALTER TABLE employees ADD COLUMN phone VARCHAR(20);

-- Modify column type
ALTER TABLE employees ALTER COLUMN salary TYPE NUMERIC(12,2);

-- Add constraint
ALTER TABLE employees ADD CONSTRAINT chk_salary CHECK (salary >= 0);

-- Rename column
ALTER TABLE employees RENAME COLUMN phone TO mobile;
```

### DROP

```sql
DROP TABLE IF EXISTS employees;
DROP DATABASE company;
```

### TRUNCATE

```sql
TRUNCATE TABLE employees;  -- removes all rows, keeps structure
```

## 4. DML — Data Manipulation Language

### INSERT

```sql
INSERT INTO employees (first_name, last_name, email, salary, dept_id)
VALUES ('Alice', 'Johnson', 'alice@example.com', 75000, 1);

-- Multi-row insert
INSERT INTO employees (first_name, last_name, email, salary, dept_id)
VALUES
    ('Bob', 'Smith', 'bob@example.com', 62000, 2),
    ('Carol', 'Davis', 'carol@example.com', 88000, 1);

-- Insert from another table
INSERT INTO employees_archive (emp_id, first_name, last_name, email)
SELECT emp_id, first_name, last_name, email FROM employees WHERE salary > 100000;
```

### SELECT (Basic)

```sql
SELECT * FROM employees;

SELECT first_name, last_name, salary FROM employees;

SELECT DISTINCT dept_id FROM employees;
```

### UPDATE

```sql
UPDATE employees
SET salary = salary * 1.10
WHERE dept_id = 2;

UPDATE employees
SET salary = 85000, last_name = 'Smith-Jones'
WHERE emp_id = 1;
```

### DELETE

```sql
DELETE FROM employees WHERE emp_id = 10;

DELETE FROM employees;  -- removes all rows (use with caution)
```

## 5. SELECT with Clauses

### WHERE Clause

```sql
-- Comparison operators: =, !=, <>, >, <, >=, <=
SELECT * FROM employees WHERE salary >= 60000;

-- Logical operators: AND, OR, NOT
SELECT * FROM employees
WHERE salary > 50000 AND dept_id = 1;

-- Range: BETWEEN
SELECT * FROM employees
WHERE salary BETWEEN 40000 AND 80000;

-- Set membership: IN
SELECT * FROM employees
WHERE dept_id IN (1, 3, 5);

-- Pattern matching: LIKE
-- % matches any sequence, _ matches a single character
SELECT * FROM employees
WHERE first_name LIKE 'A%';     -- starts with A

SELECT * FROM employees
WHERE email LIKE '%@example.com';

-- NULL checks
SELECT * FROM employees WHERE salary IS NULL;
SELECT * FROM employees WHERE salary IS NOT NULL;
```

### ORDER BY

```sql
SELECT first_name, last_name, salary
FROM employees
ORDER BY salary DESC, last_name ASC;
```

### LIMIT / OFFSET

```sql
SELECT * FROM employees ORDER BY salary DESC LIMIT 5;

SELECT * FROM employees ORDER BY salary DESC LIMIT 5 OFFSET 5;  -- page 2
```

### Aggregate Functions

```sql
SELECT
    COUNT(*)                AS total_employees,
    AVG(salary)             AS avg_salary,
    SUM(salary)             AS total_salary,
    MIN(salary)             AS min_salary,
    MAX(salary)             AS max_salary
FROM employees;
```

### GROUP BY and HAVING

```sql
-- Group by department
SELECT dept_id, COUNT(*) AS emp_count, AVG(salary) AS avg_salary
FROM employees
GROUP BY dept_id;

-- HAVING filters groups (WHERE filters rows before grouping)
SELECT dept_id, COUNT(*) AS emp_count
FROM employees
GROUP BY dept_id
HAVING COUNT(*) > 5;
```

## 6. Joins

### INNER JOIN

```sql
SELECT e.first_name, e.last_name, d.dept_name
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id;
```

### LEFT JOIN (LEFT OUTER JOIN)

```sql
SELECT e.first_name, d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id;
```

### RIGHT JOIN (RIGHT OUTER JOIN)

```sql
SELECT e.first_name, d.dept_name
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id;
```

### FULL OUTER JOIN

```sql
SELECT e.first_name, d.dept_name
FROM employees e
FULL OUTER JOIN departments d ON e.dept_id = d.dept_id;
```

### CROSS JOIN

```sql
-- Cartesian product
SELECT e.first_name, p.project_name
FROM employees e
CROSS JOIN projects p;
```

### SELF JOIN

```sql
-- Find employees and their managers
SELECT e1.first_name AS employee, e2.first_name AS manager
FROM employees e1
LEFT JOIN employees e2 ON e1.manager_id = e2.emp_id;
```

## 7. Subqueries

```sql
-- Subquery in WHERE
SELECT first_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- Subquery in FROM (derived table)
SELECT dept_id, avg_salary
FROM (
    SELECT dept_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY dept_id
) AS dept_avg
WHERE avg_salary > 60000;

-- Correlated subquery
SELECT e1.first_name, e1.salary
FROM employees e1
WHERE e1.salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.dept_id = e1.dept_id
);

-- EXISTS
SELECT d.dept_name
FROM departments d
WHERE EXISTS (
    SELECT 1 FROM employees e WHERE e.dept_id = d.dept_id
);
```

## 8. Set Operations

```sql
-- UNION (removes duplicates)
SELECT city FROM customers
UNION
SELECT city FROM suppliers;

-- UNION ALL (includes duplicates)
SELECT city FROM customers
UNION ALL
SELECT city FROM suppliers;

-- INTERSECT
SELECT city FROM customers
INTERSECT
SELECT city FROM suppliers;

-- EXCEPT (rows in first query but not second)
SELECT city FROM customers
EXCEPT
SELECT city FROM suppliers;
```

## 9. Constraints

| Constraint | Purpose |
|------------|---------|
| `PRIMARY KEY` | Uniquely identifies each row (NOT NULL + UNIQUE) |
| `FOREIGN KEY` | Ensures referential integrity |
| `UNIQUE` | All values in column(s) must be distinct |
| `NOT NULL` | Column cannot contain NULL |
| `CHECK` | Values must satisfy a condition |
| `DEFAULT` | Provides a default value |

```sql
CREATE TABLE orders (
    order_id    SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date  DATE NOT NULL DEFAULT CURRENT_DATE,
    total       DECIMAL(12,2) CHECK (total >= 0),
    status      VARCHAR(20) CHECK (status IN ('pending','shipped','delivered')),
    UNIQUE (order_id, customer_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
```
