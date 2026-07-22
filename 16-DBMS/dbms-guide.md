# DBMS Guide — Fundamentals

## 1. What is a DBMS?

A DBMS is a collection of programs that enables users to create, maintain, and manipulate a database. It acts as an interface between the database and end-users or application programs, ensuring data is organized, secure, and accessible.

### Advantages of DBMS

| Advantage | Description |
|-----------|-------------|
| Data Redundancy Control | Centralized storage minimizes duplication |
| Data Consistency | Updates propagate automatically |
| Data Security | Access controls and authentication |
| Data Integrity | Constraints ensure validity |
| Concurrent Access | ACID properties for multi-user support |
| Backup & Recovery | Automated mechanisms against failures |
| Data Independence | Logical/physical separation from applications |

### Disadvantages

- High initial cost (hardware, software, licensing)
- Complex management (requires DBA expertise)
- Performance overhead compared to file systems
- Centralized failure risk (single point of failure)

## 2. DBMS vs File System

| Feature | File System | DBMS |
|---------|------------|------|
| Data Redundancy | High | Low (controlled) |
| Data Consistency | Low | High |
| Data Security | Limited | Robust |
| Concurrent Access | No/Limited | Yes (ACID) |
| Query Capability | Manual/Code | Query languages (SQL) |
| Backup/Recovery | Manual | Automated |
| Data Independence | No | Yes |
| Multi-user Support | Poor | Excellent |

## 3. Data Models

### Relational Model (Most Common)

Data organized into tables (relations) with rows (tuples) and columns (attributes).

```
Employees
┌────────┬──────────┬─────────┬────────┐
│ emp_id │ name     │ salary  │ dept   │
├────────┼──────────┼─────────┼────────┤
│ 1      │ Alice    │ 75000   │ Eng    │
│ 2      │ Bob      │ 62000   │ Mktg   │
│ 3      │ Carol    │ 88000   │ Eng    │
└────────┴──────────┴─────────┴────────┘
```

### Entity-Relationship (ER) Model

A conceptual model using entities (rectangles), attributes (ovals), and relationships (diamonds).

```
    ┌──────────┐        ┌───────────┐        ┌──────────┐
    │ Employee │◄───────│ Works_In  │───────►│Dept      │
    └──────────┘        └───────────┘        └──────────┘
         │                                       │
    ┌────┴─────┐                          ┌──────┴─────┐
    │ emp_id   │                          │ dept_id    │
    │ name     │                          │ dept_name  │
    │ salary   │                          │ location   │
    └──────────┘                          └────────────┘
```

### Hierarchical Model

Tree-like structure (parent-child). One-to-many relationships. Used in IMS.

### Network Model

Graph structure allowing many-to-many relationships (CODASYL). Uses records and sets.

### Object-Oriented Model

Extends OOP concepts to databases. Objects with attributes and methods.

## 4. Keys in DBMS

| Key Type | Description | Example |
|----------|-------------|---------|
| Super Key | Set of attributes that uniquely identifies a tuple | {emp_id}, {emp_id, name} |
| Candidate Key | Minimal super key (no proper subset is a super key) | {emp_id}, {email} |
| Primary Key | Chosen candidate key | emp_id |
| Alternate Key | Candidate key not chosen as primary | email |
| Foreign Key | References primary key of another table | dept_id |
| Composite Key | Primary key with multiple attributes | {order_id, product_id} |
| Surrogate Key | Artificial key (auto-increment) | SERIAL, UUID |

## 5. Integrity Constraints

### Domain Integrity
Column values must be of a specific type/range (`CHECK`, `NOT NULL`).

### Entity Integrity
Primary key must be unique and not null.

### Referential Integrity
Foreign key values must match a primary key value in the referenced table (or be NULL).

### User-Defined Integrity
Business rules enforced via `CHECK` constraints or triggers.

## 6. DBMS Architecture

### Centralized Architecture

Single server handling all processing. Clients connect and send requests.

### Client-Server Architecture

```
┌──────────┐   Query    ┌────────────┐   Files    ┌──────────┐
│  Clients  │──────────►│  DBMS/Server │─────────►│ Database │
│ (Tier 1)  │◄──────────│  (Tier 2/3) │◄──────────│ (Storage)│
└──────────┘   Results  └────────────┘   Pages    └──────────┘
```

### 3-Tier Architecture

```
┌──────────┐   HTTP    ┌──────────────┐   SQL    ┌──────────┐
│  Browser  │─────────►│  App Server   │─────────►│ Database │
│ (Tier 1)  │◄────────│  (Tier 2)     │◄─────────│ (Tier 3) │
└──────────┘   HTML   └──────────────┘  Results  └──────────┘
```

## 7. ER Diagram Components

| Notation | Symbol Shape | Represents |
|----------|-------------|-----------|
| Entity | Rectangle | Real-world object |
| Attribute | Oval | Property of entity |
| Relationship | Diamond | Association between entities |
| Weak Entity | Double Rectangle | Depends on another entity |
| Key Attribute | Underlined Oval | Unique identifier |
| Multivalued Attribute | Double Oval | Multiple values (e.g., phone numbers) |
| Derived Attribute | Dashed Oval | Calculated value (e.g., age) |

## 8. Relational Algebra Operations

Relational algebra is the procedural foundation of SQL.

| Operation | Symbol | Description |
|-----------|--------|-------------|
| Selection | σ | Filter rows by condition |
| Projection | π | Pick specific columns |
| Union | ∪ | Combine rows (deduplicated) |
| Intersection | ∩ | Common rows |
| Difference | − | Rows in first but not second |
| Cartesian Product | × | All combinations |
| Join | ⨝ | Combine related rows |
| Division | ÷ | "All of" queries |

### Examples

```
σ_salary > 50000 (Employees)          → Employees with salary > 50000
π_name, salary (Employees)            → Only name and salary columns
σ_dept='Eng' (Employees) ⨝ Departments → Engineering employees with department info
```

## 9. Popular DBMS Software

| DBMS | Type | License | Known For |
|------|------|---------|-----------|
| PostgreSQL | RDBMS | Open Source | ACID, extensibility, advanced features |
| MySQL | RDBMS | Open Source | Speed, ease of use, LAMP stack |
| Oracle DB | RDBMS | Commercial | Enterprise features, scalability |
| SQL Server | RDBMS | Commercial | Integration with Microsoft ecosystem |
| SQLite | RDBMS | Public Domain | Embedded, serverless, zero-config |
| MongoDB | NoSQL (Document) | Open Source | JSON-like documents, horizontal scaling |
| Redis | NoSQL (Key-Value) | Open Source | In-memory, blazing fast, caching |
| Cassandra | NoSQL (Column) | Open Source | High availability, no single point of failure |
| Neo4j | NoSQL (Graph) | Open Source | Graph traversals, relationships |
