# DBMS Transactions & Concurrency Control

## 1. What is a Transaction?

A **transaction** is a logical unit of work that contains one or more database operations (reads and writes). It must be treated as an atomic whole — either all operations complete successfully, or none of them take effect.

### Example: Bank Transfer

```sql
BEGIN TRANSACTION;
    UPDATE accounts SET balance = balance - 500 WHERE account_id = 1;
    UPDATE accounts SET balance = balance + 500 WHERE account_id = 2;
COMMIT;
```

If the system crashes after the first UPDATE but before the second, the ROLLBACK ensures the $500 is neither lost nor gained.

## 2. ACID Properties

| Property | Full Name | Description |
|----------|-----------|-------------|
| **A** | Atomicity | All-or-nothing execution |
| **C** | Consistency | Database remains valid (constraints preserved) |
| **I** | Isolation | Concurrent transactions don't interfere |
| **D** | Durability | Committed changes survive failures |

### Atomicity

Implemented via an **undo log**. Before modifying a page, the DBMS writes the old value to the log. If the transaction aborts, the system restores old values from the log.

### Consistency

The database is in a consistent state before and after the transaction. Integrity constraints (FOREIGN KEY, CHECK, UNIQUE) must be satisfied. The application is responsible for ensuring logical consistency.

### Isolation

Transactions execute as if they were run serially, even though they may be interleaved. Implemented via **locking** or **multiversion concurrency control (MVCC)**.

### Durability

Once a transaction commits, its changes persist even after a system crash. Implemented via a **write-ahead log (WAL)** — log records are flushed to disk before data pages.

## 3. Transaction States

```
                ┌───────────────┐
                │    Begin      │
                └───────┬───────┘
                        │
                        ▼
               ┌────────────────┐
        ┌─────│    Active       │◄──────────┐
        │     └───────┬────────┘            │
        │             │                    │
        │      ┌──────┴──────┐            │
        │      │             │              │
        ▼      ▼             ▼              │
   ┌────────┐  ┌────────┐  ┌─────────┐     │
   │Partially│  │Failed  │  │ Committed│    │
   │Committed│  └────┬───┘  └────┬────┘    │
   └────┬───┘       │          │          │
        │          │          │            │
        ▼          ▼          │            │
   ┌────────┐  ┌────────┐    │            │
   │Committed│  │ Aborted │    │            │
   └────────┘  └─────────┘    │            │
                              └────────────┘
                              (Restart if restartable)
```

## 4. Concurrency Problems

Without proper isolation, concurrent transactions can cause:

### Dirty Read (WR Conflict)

```
Transaction T1:         Transaction T2:
UPDATE SET balance=200  │
WHERE id=1              │
                        │ SELECT balance → reads 200 (uncommitted!)
ROLLBACK                │
```

T2 reads a value that was never committed. **Prevented by READ COMMITTED.**

### Non-repeatable Read (RW Conflict)

```
Transaction T1:         Transaction T2:
SELECT balance → 500   │
                        │ UPDATE SET balance=300 WHERE id=1
                        │ COMMIT
SELECT balance → 300   │ ← Different value!
```

T1 reads the same row twice and gets different values. **Prevented by REPEATABLE READ.**

### Phantom Read

```
Transaction T1:         Transaction T2:
SELECT * FROM accounts  │
WHERE balance > 400     │
→ returns 2 rows       │
                        │ INSERT INTO accounts (id, balance) VALUES (3, 450)
                        │ COMMIT
SELECT * FROM accounts  │
WHERE balance > 400     │
→ returns 3 rows       │ ← Phantom row!
```

T1 runs the same query twice and sees different sets of rows. **Prevented by SERIALIZABLE.**

### Lost Update

```
Transaction T1:         Transaction T2:
READ balance → 500     │
                        │ READ balance → 500
balance = 500 + 100    │
                        │ balance = 500 - 50
UPDATE balance = 600   │
                        │ UPDATE balance = 450  ← Overwrites T1's update!
```

Both transactions read the same initial value; the second write overwrites the first. **Prevented by row-level locks or optimistic concurrency.**

## 5. Isolation Levels (ANSI/ISO SQL)

| Level | Dirty Read | Non-repeatable Read | Phantom Read |
|-------|-----------|---------------------|--------------|
| READ UNCOMMITTED | Possible | Possible | Possible |
| READ COMMITTED | Prevented | Possible | Possible |
| REPEATABLE READ | Prevented | Prevented | Possible* |
| SERIALIZABLE | Prevented | Prevented | Prevented |

\* PostgreSQL's REPEATABLE READ also prevents phantom reads using MVCC.

```sql
-- Set isolation level
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN;
-- operations
COMMIT;
```

### Comparison: Which Level to Use?

| Use Case | Recommended Level |
|----------|-------------------|
| Reporting / Dashboards | READ COMMITTED (default in most DBs) |
| Financial transactions | SERIALIZABLE |
| Deduplication / Inventory | REPEATABLE READ or SERIALIZABLE |
| Read-only analytics | READ COMMITTED or snapshot isolation |
| High-throughput logging | READ UNCOMMITTED (rarely used) |

## 6. Lock-Based Concurrency Control

### Lock Types

| Lock | Symbol | Description |
|------|--------|-------------|
| Shared (Read) | S | Multiple transactions can read concurrently |
| Exclusive (Write) | X | Only one transaction can write; no concurrent reads |
| Update | U | Initial read that may become a write (prevents deadlocks) |
| Intention Shared | IS | Intention to set S locks on finer granularity |
| Intention Exclusive | IX | Intention to set X locks on finer granularity |

### Lock Compatibility Matrix

```
      S     X     IS    IX
S     ✓     ✗     ✓     ✓
X     ✗     ✗     ✗     ✗
IS    ✓     ✗     ✓     ✓
IX    ✓     ✗     ✓     ✓
```

### Two-Phase Locking (2PL)

```
Transaction Timeline:
┌───────────────────────┬───────────────────────┐
│   Growing Phase       │    Shrinking Phase    │
│   (Acquire locks)     │    (Release locks)    │
└───────────────────────┴───────────────────────┘
                         ↑
                    Lock Point
```

**Strict 2PL**: All exclusive locks are held until commit/abort. Prevents cascading aborts. Most practical variant.

### Deadlocks

A deadlock occurs when two or more transactions are waiting for each other to release locks.

```
T1: LOCK A → waiting for B
T2: LOCK B → waiting for A
```

**Detection**: Wait-for graph cycle detection.
**Prevention**: 
- Order all resources (always lock A then B).
- Use timeouts (`innodb_lock_wait_timeout` in MySQL).
- **Wait-Die** and **Wound-Wait** schemes.

## 7. Multiversion Concurrency Control (MVCC)

Instead of locking, MVCC maintains multiple versions of each data item. Reads see a snapshot of the database at a point in time.

### How MVCC Works

1. Each write creates a new version of the row with a timestamp/transaction ID.
2. Reads see the latest version that was committed before the read transaction began.
3. Old versions are garbage collected when no active transaction needs them.

### MVCC Advantages

- Readers never block writers, writers never block readers.
- Snapshot isolation (consistent read view).
- Lower contention under read-heavy workloads.

### MVCC in PostgreSQL

```
Row Header:
┌────────────┬───────────┬────────────┬─────────┐
│ xmin (TXID)│ xmax (TXID)│ t_ctid     │ Data    │
├────────────┼───────────┼────────────┼─────────┤
│ 100        │ 105       │ (1,1)      │ value   │
└────────────┴───────────┴────────────┴─────────┘
```

- `xmin` — transaction that created this version.
- `xmax` — transaction that deleted/replaced this version (NULL if active).

## 8. Recovery Techniques

### Write-Ahead Logging (WAL)

Before any data page is written to disk, the corresponding log record must be written to stable storage.

**Log Record Structure:** `<TXID, PageID, Offset, OldValue, NewValue, Type>`

### ARIES Recovery Algorithm

| Phase | Action |
|-------|--------|
| **Analysis** | Scan log forward to determine dirty pages and in-flight transactions |
| **Redo** | Reapply all changes from the last checkpoint (repeat history) |
| **Undo** | Roll back uncommitted transactions (undo log, oldest first) |

### Checkpointing

Periodically writes dirty page information to the log to reduce recovery time.

- **Fuzzy checkpoint**: Allows other transactions to continue during checkpoint.
- **Sharp checkpoint**: Pauses all transactions (rarely used in modern DBMS).

### Types of Failure

| Failure Type | Example | Recovery Method |
|--------------|---------|-----------------|
| Transaction failure | Logic error, constraint violation | Undo (rollback) |
| System crash | Power outage, OS crash | ARIES (redo + undo) |
| Media failure | Disk failure | Replay from backup + logs |
| Disaster | Site destruction | Remote replication |

## 9. Serializability

### Conflict Serializability

Two schedules are **conflict equivalent** if they have the same order of conflicting operations (same transaction reads/writes the same data item). A schedule is **conflict serializable** if it can be transformed into a serial schedule through swapping non-conflicting operations.

**Conflict operations:** Two operations conflict if they belong to different transactions, access the same data item, and at least one is a write.

### View Serializability

A schedule is **view serializable** if it produces the same final result as some serial schedule. View serializability is broader than conflict serializability (all conflict-serializable schedules are view-serializable, but not vice versa).

### Precedence Graph

Nodes = transactions. Edge T_i → T_j if T_i performs an operation on data item X before T_j's conflicting operation on X.

A schedule is conflict serializable **if and only if** its precedence graph has no cycles.

## 10. Timestamp-Based Concurrency Control

Each transaction is assigned a unique timestamp when it starts. Operations follow these rules:

| Operation | Rule |
|-----------|------|
| **Read** | Read if write timestamp < read timestamp; otherwise abort and restart |
| **Write** | Write if both read and write timestamps < write timestamp; otherwise abort and restart |

**Thomas Write Rule**: If a write is obsolete (a later write already occurred), simply skip it instead of aborting.

### Timestamp vs. Locking

| Aspect | Timestamp-Based | Lock-Based |
|--------|----------------|------------|
| Deadlocks | Impossible | Possible |
| Starvation | Possible (frequent restarts) | Possible (priority inversion) |
| Overhead | High (timestamp maintenance) | High (lock management) |
| Conflict rate | Better for low contention | Better for high contention |
