# DBMS (Database Management System)

## Overview
A Database Management System (DBMS) is software that enables users to define, create, maintain, and control access to databases. It serves as an intermediary between the user and the database, ensuring data is stored efficiently, retrieved quickly, and remains consistent and secure.

## Topics Covered

| # | Topic | File |
|---|-------|------|
| 1 | DBMS Guide (Fundamentals) | [dbms-guide.md](./dbms-guide.md) |
| 2 | DBMS Normalization | [dbms-normalization.md](./dbms-normalization.md) |
| 3 | DBMS Transactions & Concurrency | [dbms-transactions.md](./dbms-transactions.md) |
| 4 | DBMS Interview Questions | [dbms-interview-questions.md](./dbms-interview-questions.md) |

## Types of DBMS

```
DBMS
├── Hierarchical DBMS (IMS)
├── Network DBMS (IDMS)
├── Relational DBMS (RDBMS) ← Most common
│   ├── PostgreSQL
│   ├── MySQL
│   ├── Oracle DB
│   ├── SQL Server
│   └── SQLite
├── Object-Oriented DBMS (OODBMS)
├── NoSQL DBMS
│   ├── Document (MongoDB)
│   ├── Key-Value (Redis)
│   ├── Column-Family (Cassandra)
│   └── Graph (Neo4j)
└── NewSQL (CockroachDB, Spanner)
```

## Three-Schema Architecture

```
┌─────────────────────────────────────┐
│      External Level (View 1..N)     │  ← What users see
├─────────────────────────────────────┤
│    Conceptual Level (Logical)       │  ← Structure & constraints
├─────────────────────────────────────┤
│     Internal Level (Physical)       │  ← Storage & indexing
└─────────────────────────────────────┘
```

## Key DBMS Languages

| Language | Purpose |
|----------|---------|
| DDL | Define database schema (CREATE, ALTER, DROP) |
| DML | Manipulate data (SELECT, INSERT, UPDATE, DELETE) |
| DCL | Control access (GRANT, REVOKE) |
| TCL | Manage transactions (COMMIT, ROLLBACK, SAVEPOINT) |

## Key People

- **Charles Bachman** — Network DBMS (IDS), Turing Award 1973
- **Edgar F. Codd** — Relational model, Turing Award 1981
- **Jim Gray** — Transaction processing, Turing Award 1998
- **Michael Stonebraker** — Ingres, Postgres, Turing Award 2014
