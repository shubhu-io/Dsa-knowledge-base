# DBMS Interview Questions

## Basic Questions

### Q1: What is a DBMS? What are its advantages?

A DBMS (Database Management System) is software that manages databases, providing systematic ways to create, retrieve, update, and manage data. Advantages include: data redundancy control, data consistency, data security, concurrent access with ACID properties, backup and recovery mechanisms, and data independence.

### Q2: What is the difference between DBMS and RDBMS?

| Aspect | DBMS | RDBMS |
|--------|------|-------|
| Data model | Hierarchical, network, or file-based | Relational (tables) |
| Relationships | No foreign keys | Uses foreign keys |
| Normalization | Not supported | Supported |
| ACID | Partial | Full |
| Data storage | Files or navigational | Tables with rows/columns |
| Examples | IMS, IDMS, XML DB | PostgreSQL, MySQL, Oracle |

### Q3: Explain the three-schema architecture.

1. **External Level** (View level) — How individual users see the data.
2. **Conceptual Level** (Logical level) — What data is stored and the relationships among them.
3. **Internal Level** (Physical level) — How data is actually stored (files, indexes, pages).

Data independence: **Logical data independence** (change conceptual schema without changing external views) and **Physical data independence** (change internal schema without changing conceptual schema).

### Q4: What is a primary key? Can a table have multiple primary keys?

A primary key uniquely identifies each row in a table. It must be unique and NOT NULL. A table can have only one primary key, but that key can consist of multiple columns (composite key).

### Q5: What is the difference between a primary key and a unique key?

| Property | Primary Key | Unique Key |
|----------|------------|------------|
| NULL values | Not allowed | Allowed (one NULL in most DBs) |
| Per table | Only one | Multiple allowed |
| Clustered index | Default (SQL Server) | Non-clustered by default |
| Foreign key reference | Yes | Yes |

### Q6: What is a foreign key? What is referential integrity?

A foreign key is a column (or set of columns) in one table that references the primary key of another table. **Referential integrity** ensures that foreign key values always match an existing primary key value (or are NULL). This prevents orphan records.

### Q7: Explain the different types of relationships in a database.

- **One-to-One (1:1)**: Each row in Table A matches exactly one row in Table B (e.g., Employee ↔ EmployeeDetails).
- **One-to-Many (1:N)**: One row in Table A matches many rows in Table B (e.g., Department → Employees).
- **Many-to-Many (M:N)**: Many rows in Table A match many rows in Table B via a junction table (e.g., Students ↔ Courses via Enrollments).

---

## Intermediate Questions

### Q8: What is normalization? Explain 1NF, 2NF, 3NF.

Normalization reduces redundancy and prevents anomalies.
- **1NF**: Atomic values, no repeating groups, unique rows.
- **2NF**: 1NF + every non-key column depends on the full primary key.
- **3NF**: 2NF + no transitive dependencies.

See [dbms-normalization.md](./dbms-normalization.md) for details.

### Q9: What is denormalization? When would you use it?

Denormalization is intentionally adding redundancy to optimize read performance. Use cases: data warehousing, reporting, high-read/low-write workloads, pre-computed aggregations.

### Q10: What are ACID properties?

- **Atomicity**: All operations in a transaction succeed or fail as a unit.
- **Consistency**: Transactions preserve database integrity.
- **Isolation**: Concurrent transactions don't interfere.
- **Durability**: Committed changes survive system failures.

### Q11: Explain the different isolation levels.

| Level | Dirty Read | Non-repeatable | Phantom |
|-------|-----------|---------------|---------|
| READ UNCOMMITTED | Yes | Yes | Yes |
| READ COMMITTED | No | Yes | Yes |
| REPEATABLE READ | No | No | Yes* |
| SERIALIZABLE | No | No | No |

\* PostgreSQL prevents phantoms at REPEATABLE READ via MVCC.

### Q12: What is a deadlock? How do you prevent it?

A deadlock occurs when two or more transactions wait indefinitely for each other's locks. Prevention methods:
1. Lock resources in a consistent order.
2. Use lock timeouts.
3. Use deadlock detection (wait-for graph) and victim selection.
4. Use wait-die or wound-wait schemes.

### Q13: Explain the difference between horizontal and vertical partitioning.

- **Horizontal partitioning (sharding)**: Splits rows across multiple tables/servers. Each partition has the same schema. Used for scaling.
- **Vertical partitioning**: Splits columns into different tables. Used to separate frequently accessed columns from large blobs or to improve cache locality.

### Q14: What is an index? What are the types?

An index is a data structure that speeds up data retrieval.

| Type | Description | Use Case |
|------|-------------|----------|
| B-Tree | Balanced tree | General purpose |
| Hash | Hash table | Equality lookups |
| Bitmap | Bit arrays | Low-cardinality columns |
| GiST | Generalized Search Tree | Full-text, geometric |
| GIN | Inverted index | JSONB, arrays, full-text |
| Spatial | R-Tree | Geographic data |

### Q15: What is a view? Can you update data through a view?

A view is a virtual table based on a SELECT query. Updatable views require that the view maps directly to a single base table without aggregations, DISTINCT, GROUP BY, or set operations. Use `WITH CHECK OPTION` to prevent updates that would make rows invisible through the view.

---

## Advanced Questions

### Q16: Explain MVCC (Multiversion Concurrency Control).

MVCC maintains multiple versions of each data row. Readers see a consistent snapshot from when their transaction began. Writers create new versions without blocking readers. Benefits: no reader-writer blocking, consistent reads without locks. Drawbacks: version storage overhead, need for garbage collection (VACUUM in PostgreSQL).

### Q17: What is the difference between a clustered and a non-clustered index?

| Aspect | Clustered | Non-Clustered |
|--------|-----------|---------------|
| Data storage | Data at leaf level | Pointer to data at leaf |
| Number per table | 1 (physical sort order) | Many |
| Size | No extra space for leaf | Extra space for index pages |
| Speed | Fast range scans | Fast point lookups |

### Q18: What is a coverting index (index-only scan)?

An index that contains all columns needed by a query, so the database never needs to access the table itself. PostgreSQL's `INCLUDE` clause adds non-key columns to the index leaf pages without affecting the sort order.

```sql
CREATE INDEX idx_covering ON employees (dept_id) INCLUDE (first_name, salary);
SELECT first_name, salary FROM employees WHERE dept_id = 1;  -- index only
```

### Q19: Explain the ARIES recovery algorithm.

ARIES (Algorithm for Recovery and Isolation Exploiting Semantics) has three phases:
1. **Analysis**: Scan log to determine dirty pages and active transactions at crash time.
2. **Redo**: Reapply all changes from the last checkpoint (repeat history to recover the state).
3. **Undo**: Roll back uncommitted transactions (using the log, oldest first).

Key principles: Write-Ahead Logging (WAL), repeating history, and logging undo actions.

### Q20: What is the difference between conflict serializability and view serializability?

- **Conflict serializability**: Two schedules are equivalent if they have the same order of conflicting operations (read-write, write-read, write-write). Tested via precedence graph (must be acyclic).
- **View serializability**: A schedule produces the same final result as some serial schedule. Broader than conflict serializability: some view-serializable schedules have cycles in their precedence graph.

### Q21: Explain the CAP theorem in the context of distributed databases.

| Property | Description |
|----------|-------------|
| **C**onsistency | Every read receives the most recent write |
| **A**vailability | Every request receives a non-error response |
| **P**artition Tolerance | System continues despite network failures |

CAP theorem states that a distributed database can satisfy at most two of three properties:
- **CA**: Traditional RDBMS (single-node) — sacrifices partition tolerance.
- **CP**: MongoDB, HBase — sacrifices availability during partitions.
- **AP**: Cassandra, CouchDB — sacrifices consistency (eventual consistency).

### Q22: What is the difference between SQL and NoSQL databases?

| Aspect | SQL (RDBMS) | NoSQL |
|--------|------------|-------|
| Data model | Tables (rows/columns) | Documents, key-value, graphs, columns |
| Schema | Fixed (schema-on-write) | Flexible (schema-on-read) |
| Scaling | Vertical (beefier servers) | Horizontal (more servers) |
| ACID | Full | Often BASE (Basically Available, Soft state, Eventual consistency) |
| Queries | SQL (standardized) | API-driven, vendor-specific |

### Q23: What is sharding? What strategies exist?

Sharding horizontally partitions data across multiple database instances.

Shard key strategies:
1. **Hash-based**: Consistent hashing on shard key (e.g., user_id % N).
2. **Range-based**: Data split by value ranges (e.g., A-M on shard 1, N-Z on shard 2).
3. **Directory-based**: Lookup table maps keys to shards.
4. **Geographic**: Data partitioned by region.

### Q24: Explain the write-ahead log (WAL) protocol.

Before modifying any database page, the change is recorded in the WAL (on stable storage). This ensures durability (committed changes survive crashes) and enables recovery. The actual data pages may be flushed lazily. In PostgreSQL, WAL files are typically 16 MB each.

### Q25: What is the difference between optimistic and pessimistic concurrency control?

| Aspect | Pessimistic | Optimistic |
|--------|------------|------------|
| Approach | Lock data upfront | Check for conflicts at commit |
| Best for | High contention | Low contention |
| Deadlocks | Possible | No (aborts instead) |
| Overhead | Lock management | Validation phase |
| Example | `SELECT ... FOR UPDATE` | Application-level version check |

### Q26: Explain the differences between TRUNCATE, DELETE, and DROP.

| Operation | DDL/DML | Rollback | Speed | Reset Identity | Table Structure |
|-----------|---------|----------|-------|---------------|-----------------|
| DELETE | DML | Yes | Slow | No | Preserved |
| TRUNCATE | DDL | In transaction | Fast | Yes | Preserved |
| DROP | DDL | No | Fast | N/A | Removed |

### Q27: What is a bitmap index? When would you use it?

A bitmap index uses bit arrays (bitmaps) to represent which rows contain a given value. Efficient for low-cardinality columns (e.g., gender, status, region). Common in data warehousing (Oracle, Vertica). Bitwise operations (AND, OR, NOT) enable fast set-based queries. Not suitable for high-cardinality columns or frequent updates.

### Q28: What is a stored procedure? Pros and cons?

A stored procedure is precompiled SQL code stored in the database.

| Pros | Cons |
|------|------|
| Reduces network traffic | Vendor lock-in |
| Reusable across applications | Harder to debug |
| Enhanced security (direct table access restricted) | Version control challenges |
| Better performance (compiled/cached) | Scales differently than app code |

### Q29: Explain the concept of "phantom read" and how SERIALIZABLE isolation prevents it.

A phantom read occurs when a transaction re-executes a range query and gets different rows because another transaction inserted/deleted rows in that range between the two queries. SERIALIZABLE isolation prevents this by either: (a) using predicate locks (lock the range), (b) using serializable snapshot isolation (SSI) in PostgreSQL (detect serialization anomalies), or (c) materializing the conflict (lock a dummy table row representing the range).

### Q30: What is the difference between a database trigger and a check constraint?

| Aspect | Trigger | Check Constraint |
|--------|---------|-----------------|
| Activation | BEFORE/AFTER INSERT/UPDATE/DELETE | On any INSERT/UPDATE |
| Condition | Arbitrary logic (functions, procedures) | Simple boolean expression |
| Cross-table | Yes (can reference other tables) | No (single row only) |
| Performance | Higher overhead | Minimal |

```sql
-- Check constraint
ALTER TABLE employees ADD CONSTRAINT chk_age CHECK (age >= 18);

-- Trigger
CREATE TRIGGER trg_prevent_high_raise
BEFORE UPDATE OF salary ON employees
FOR EACH ROW
EXECUTE FUNCTION check_raise_percentage();
```
