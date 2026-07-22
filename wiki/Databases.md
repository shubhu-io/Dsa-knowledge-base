# Databases

## Overview

Databases are organized collections of structured data stored electronically.
Understanding databases is essential for backend development, system design,
and technical interviews. This covers SQL, NoSQL, normalization, indexing,
and common query patterns.

---

## Key Concepts

### SQL vs NoSQL

| Feature         | SQL                          | NoSQL                         |
|----------------|------------------------------|-------------------------------|
| Schema          | Fixed (rigid)                | Dynamic (flexible)            |
| Scaling         | Vertical                     | Horizontal                    |
| ACID            | Yes                          | Eventual consistency          |
| Query Language   | SQL                          | Varies (API-based)            |
| Examples        | PostgreSQL, MySQL, SQLite    | MongoDB, Redis, DynamoDB      |
| Best For        | Complex joins, transactions  | Large-scale, flexible data    |
| Data Model      | Tables with rows/columns     | Documents, key-value, graph   |

---

## Normalization

Normalization reduces data redundancy by organizing data into related tables.

### First Normal Form (1NF)

- Each column contains atomic ( indivisible) values
- Each row is unique

```
# Violates 1NF: Multiple values in one column
| StudentID | Courses              |
|-----------|----------------------|
| 1         | Math, Physics, Chem  |

# Satisfies 1NF: Atomic values
| StudentID | Course   |
|-----------|----------|
| 1         | Math     |
| 1         | Physics  |
| 1         | Chem     |
```

### Second Normal Form (2NF)

- Must be in 1NF
- No partial dependency (all non-key attributes depend on the full primary key)

### Third Normal Form (3NF)

- Must be in 2NF
- No transitive dependency (non-key attributes do not depend on other non-keys)

```
# Violates 3NF: City -> State is transitive
| StudentID | City   | State  |
|-----------|--------|--------|
| 1         | Dallas | Texas  |

# Fix: Separate tables
Students:  | StudentID | CityID |
Cities:    | CityID    | City   | State |
```

---

## ACID Properties

| Property      | Description                                          |
|--------------|------------------------------------------------------|
| Atomicity    | All operations in a transaction succeed or all fail   |
| Consistency  | Database moves from one valid state to another       |
| Isolation    | Concurrent transactions do not interfere             |
| Durability   | Committed data survives system failures              |

---

## Common SQL Queries

### JOIN Types

```sql
-- INNER JOIN: Only matching rows
SELECT e.name, d.department_name
FROM employees e
INNER JOIN departments d ON e.dept_id = d.id;

-- LEFT JOIN: All rows from left table
SELECT e.name, d.department_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.id;

-- RIGHT JOIN: All rows from right table
SELECT e.name, d.department_name
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.id;

-- FULL OUTER JOIN: All rows from both tables
SELECT e.name, d.department_name
FROM employees e
FULL OUTER JOIN departments d ON e.dept_id = d.id;
```

### GROUP BY and Aggregation

```sql
SELECT department, COUNT(*) as emp_count, AVG(salary) as avg_salary
FROM employees
GROUP BY department
HAVING COUNT(*) > 5
ORDER BY avg_salary DESC;
```

### Window Functions

```sql
-- Rank employees by salary within each department
SELECT name, department, salary,
       RANK() OVER (PARTITION BY department ORDER BY salary DESC) as rank
FROM employees;

-- Running total of sales
SELECT date, amount,
       SUM(amount) OVER (ORDER BY date) as running_total
FROM sales;
```

### Subqueries

```sql
-- Employees earning above average
SELECT name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- EXISTS check
SELECT d.department_name
FROM departments d
WHERE EXISTS (
    SELECT 1 FROM employees e WHERE e.dept_id = d.id
);
```

---

## Indexing Basics

Indexes improve query speed by allowing faster data retrieval.

### Types of Indexes

- **B-Tree Index**: Default, good for range queries
- **Hash Index**: Exact match lookups only
- **Composite Index**: Multiple columns
- **Covering Index**: Contains all columns needed by query

### When to Use Indexes

- Columns used in WHERE clauses frequently
- Columns used in JOIN conditions
- Columns used in ORDER BY

### When NOT to Use Indexes

- Small tables
- Columns with low cardinality (e.g., boolean)
- Tables with heavy write operations

```sql
-- Create index
CREATE INDEX idx_employee_name ON employees(name);

-- Composite index
CREATE INDEX idx_emp_dept_salary ON employees(dept_id, salary);
```

---

## Common Interview Questions

1. Explain the difference between INNER JOIN and LEFT JOIN
2. What are database indexes and when should you use them?
3. What is the difference between DELETE, TRUNCATE, and DROP?
4. Explain ACID properties with real-world examples
5. What is N+1 query problem and how do you solve it?

---

## See Also

- [[System-Design]]
- [[Low-Level-Design]]
- [[Networking]]
- [[Operating-System]]

---

> Full content: [15-SQL](../15-SQL/) and [16-DBMS](../16-DBMS/)
