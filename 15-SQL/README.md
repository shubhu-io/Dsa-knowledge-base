# SQL (Structured Query Language)

## Overview
SQL is the standard language for managing and manipulating relational databases. It is used to query, insert, update, and delete data, as well as to define and manage database schemas.

## Topics Covered

| # | Topic | File |
|---|-------|------|
| 1 | SQL Guide (Fundamentals) | [sql-guide.md](./sql-guide.md) |
| 2 | SQL Queries & Examples | [sql-queries.md](./sql-queries.md) |
| 3 | SQL Advanced Concepts | [sql-advanced.md](./sql-advanced.md) |
| 4 | SQL Interview Questions | [sql-interview-questions.md](./sql-interview-questions.md) |

## SQL Command Categories

```
SQL
├── DDL (Data Definition Language)
│   ├── CREATE
│   ├── ALTER
│   ├── DROP
│   ├── TRUNCATE
│   └── RENAME
├── DML (Data Manipulation Language)
│   ├── SELECT
│   ├── INSERT
│   ├── UPDATE
│   └── DELETE
├── DCL (Data Control Language)
│   ├── GRANT
│   └── REVOKE
└── TCL (Transaction Control Language)
    ├── COMMIT
    ├── ROLLBACK
    └── SAVEPOINT
```

## Why SQL?

- **Declarative** — you say *what* to retrieve, not *how*
- **Widely adopted** — PostgreSQL, MySQL, SQL Server, Oracle, SQLite
- **ACID compliant** — guarantees reliable transactions
- **Set-based** — operates on entire sets of rows, not individual records

## Prerequisites

- Basic understanding of data and tables
- Familiarity with any programming language (for embedded SQL)

## How to Use These Docs

Start with `sql-guide.md` for fundamentals. Move to `sql-queries.md` for hands-on examples. Then explore `sql-advanced.md` for indexing, optimization, and window functions. Finally, test yourself with `sql-interview-questions.md`.

## Quick Example

```sql
-- Create a table
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    salary DECIMAL(10,2),
    dept_id INTEGER REFERENCES departments(id)
);

-- Query data
SELECT name, salary
FROM employees
WHERE salary > 50000
ORDER BY salary DESC;
```
