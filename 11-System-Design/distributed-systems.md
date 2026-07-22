# Distributed Systems

Core concepts and challenges in building distributed systems.

## What is a Distributed System?

A distributed system is a collection of independent computers that appear to users as a single coherent system.

```
                    ┌─────────────────┐
                    │   Client/User   │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              v              v              v
         ┌─────────┐   ┌─────────┐   ┌─────────┐
         │ Server 1│◄─►│ Server 2│◄─►│ Server 3│
         │ (NYC)   │   │ (London)│   │ (Tokyo) │
         └─────────┘   └─────────┘   └─────────┘
              │              │              │
         ┌────┴────┐   ┌────┴────┐   ┌────┴────┐
         │   DB 1  │   │   DB 2  │   │   DB 3  │
         └─────────┘   └─────────┘   └─────────┘
```

## The Eight Fallacies of Distributed Computing

1. **The network is reliable** — It isn't. Packets get dropped.
2. **Latency is zero** — Network calls are orders of magnitude slower than memory.
3. **Bandwidth is infinite** — Networks have capacity limits.
4. **The network is secure** — Security must be explicitly designed.
5. **Topology doesn't change** — Servers fail, networks partition.
6. **There is one administrator** — Multiple teams, multiple policies.
7. **Transport cost is zero** — Serialization/deserialization has overhead.
8. **The network is homogeneous** — Different hardware, protocols, versions.

---

## CAP Theorem

In a distributed system, you can only guarantee **two** of three:

```
        Consistency (C)
           /    \
          /      \
         /        \
  Availability (A) ---- Partition Tolerance (P)

CAP Theorem: You must choose 2 out of 3
But in practice, P is non-negotiable (networks WILL partition)
So the real choice is: CP or AP
```

### CP Systems (Consistency + Partition Tolerance)

```
When partition occurs:
  - Reject writes to maintain consistency
  - Some data may be unavailable
  
Examples:
  - HBase, MongoDB (with majority write concern)
  - Google Spanner (uses TrueTime for consistency)
  - ZooKeeper, etcd

Trade-off: Available for reads but may reject writes during partition
```

### AP Systems (Availability + Partition Tolerance)

```
When partition occurs:
  - Accept writes on all sides
  - Data may become inconsistent temporarily
  
Examples:
  - Cassandra, DynamoDB
  - CouchDB, Riak
  - DNS

Trade-off: Always available, but eventual consistency
```

### PACELC Theorem (Extension of CAP)

```
If Partition:
  Choose Availability or Consistency
Else:
  Choose Latency or Consistency

System         | Partition | Else
---------------|-----------|------
Cassandra      | A         | L (latency)
MongoDB        | C         | C (consistency)
DynamoDB       | A         | L
Spanner        | C         | C
```

---

## Consistency Models

### Strong Consistency

```
After a write completes, all subsequent reads see the value.

Timeline:
  Write(x=5) completes -> Read(x) always returns 5
  No stale reads possible

Implementations:
  - Two-Phase Commit (2PC)
  - Paxos / Raft consensus
  - Spanner (TrueTime)
```

### Eventual Consistency

```
If no new writes, all replicas will EVENTUALLY converge.

Timeline:
  Write(x=5) on Node A
  Read(x) on Node B -> might return 4 (old value)
  Wait...
  Read(x) on Node B -> eventually returns 5

Implementations:
  - Dynamo-style systems
  - DNS
  - Cassandra (tunable)
```

### Consistency Levels (Cassandra Example)

| Level | Description | Latency | Consistency |
|-------|------------|---------|-------------|
| ONE | Read/write from one replica | Lowest | Weakest |
| QUORUM | Read/write from majority | Medium | Balanced |
| ALL | Read/write from all replicas | Highest | Strongest |
| LOCAL_QUORUM | Quorum in local DC | Medium | Good for multi-DC |

```
Formula: R + W > N guarantees strong consistency
  R = read replicas needed
  W = write replicas needed
  N = total replicas
  
Example: N=3, R=2, W=2 => 2+2 > 3 ✓ (strong consistency)
Example: N=3, R=1, W=1 => 1+1 < 3 ✗ (eventual consistency)
```

---

## Consensus Algorithms

### Raft Consensus

```
Leader Election:
  1. All nodes start as followers
  2. After timeout, node becomes candidate
  3. Candidate requests votes
  4. Majority votes -> becomes leader
  5. Leader handles all writes

Log Replication:
  Client -> Leader -> Append to log
  Leader -> Replicate to followers
  Followers -> Acknowledge
  Leader -> Commit (after majority)
  Leader -> Respond to client

Term System:
  Each term has at most one leader
  Stale leaders detected by higher term numbers
```

### Paxos (Simplified)

```
Phase 1 (Prepare):
  Proposer sends PREPARE(n) to acceptors
  Acceptors respond with highest accepted proposal

Phase 2 (Accept):
  Proposer sends ACCEPT(n, value)
  If majority accept -> value is chosen

Multi-Paxos: Optimization for repeated consensus
  elect stable leader
  skip phase 1 for subsequent values
```

### Raft vs Paxos

| Aspect | Raft | Paxos |
|--------|------|-------|
| Complexity | Easier to understand | Complex |
| Leader | Strong leader | Leaderless variants |
| Log | Strict ordering | May have gaps |
| Implementation | Many (etcd, TiKV) | Few (Google Chubby) |
| Performance | Comparable | Comparable |

---

## Distributed Transactions

### Two-Phase Commit (2PC)

```
Phase 1: Prepare
  Coordinator -> All participants: "Can you commit?"
  Participants -> Coordinator: "Yes" or "No"

Phase 2: Commit/Abort
  If all voted Yes:
    Coordinator -> All: "COMMIT"
  If any voted No:
    Coordinator -> All: "ABORT"

Problems:
  - Blocking: Participants hold locks during prepare
  - Coordinator failure: Participants stuck in uncertain state
  - Slow: Multiple round trips
```

### Saga Pattern

```
Instead of 2PC, use a series of local transactions:

T1: Create Order -> T2: Process Payment -> T3: Ship Item

If T3 fails:
  Compensating transactions:
  C2: Refund Payment -> C1: Cancel Order

Each step:
  1. Execute local transaction
  2. Publish event
  3. Next step picks up event

Orchestration:
  Central saga orchestrator manages the flow

Choreography:
  Services publish events, react to events
```

---

## Data Partitioning

### Hash Partitioning

```
Partition = hash(key) % num_partitions

  Key "user:123" -> hash(123) = 42 -> partition 42 % 8 = 2
  
Adding partitions: Most keys remap
Consistent hashing minimizes remapping
```

### Range Partitioning

```
  Partition 0: [A - F]
  Partition 1: [G - M]
  Partition 2: [N - Z]
  
Pros: Range queries efficient
Cons: Hotspots (popular ranges get more traffic)
```

### Consistent Hashing

```
Virtual nodes on a hash ring:
  
  Ring: 0 ------------------ 2^32
         |    V1   V2         |
         | S1        V3       |
         |           S2  V4   |
         |    V5              |
         | S3            V6   |

Key maps to nearest V-node clockwise.
Each physical server owns multiple V-nodes.
```

---

## Replication Strategies

### Synchronous Replication

```
Client -> Primary -> Writes locally
Primary -> Replica1 -> Writes locally
Primary -> Replica2 -> Writes locally
Primary -> Client: "Write successful"

Pros: Strong consistency
Cons: Higher latency, blocked if any replica fails
```

### Asynchronous Replication

```
Client -> Primary -> Writes locally
Primary -> Client: "Write successful"
Primary -> Replica1 -> (async) Writes later
Primary -> Replica2 -> (async) Writes later

Pros: Low latency, resilient to replica failures
Cons: Data loss possible if primary fails before replication
```

### Semi-Synchronous

```
Client -> Primary -> Writes locally
Primary -> Replica1 -> Acknowledges (sync)
Primary -> Client: "Write successful"
Primary -> Replica2 -> (async) Writes later

Pros: Balance of consistency and performance
Cons: Complex to configure
```

---

## Failure Detection

### Heartbeat

```
Node A sends heartbeat to Node B every 10 seconds
If Node B doesn't receive heartbeat for 30 seconds:
  Mark Node A as suspected failed
  
Gossip Protocol:
  Each node randomly shares its view of the cluster
  Eventually all nodes agree on who is alive
```

### Failure Modes

| Type | Description | Detection | Recovery |
|------|------------|-----------|----------|
| Crash failure | Node stops | Heartbeat timeout | Restart, failover |
| Omission failure | Messages lost | Retransmission | Retry |
| Timing failure | Slow response | Timeout | Increase timeout |
| Byzantine failure | Arbitrary behavior | Consensus | Manual intervention |

### Split Brain

```
Problem: Network partition makes two groups think each is the only one

  Group A: [Server1, Server2] thinks B is dead
  Group B: [Server3, Server4] thinks A is dead
  
  Both groups elect leaders and accept writes
  When partition heals: conflicting data!

Solutions:
  - Fencing tokens (monotonically increasing)
  - Quorum-based decisions
  - STONITH (Shoot The Other Node In The Head)
  - Witness/arbitrator node
```

---

## Distributed Caching

### Cache Topologies

```
Standalone:
  App -> Redis (single node)
  Simple, single point of failure

Replicated:
  App -> Redis Primary -> Redis Replica
  Read from replica, write to primary

Clustered:
  App -> Redis Cluster
  Hash slots distributed across nodes
  Auto-failover
```

### Cache Consistency Strategies

```
1. Write-Invalidate:
   On write: invalidate cache, next read repopulates
   
2. Write-Update:
   On write: update cache immediately
   
3. Time-based (TTL):
   Cache entries expire after fixed time
   
4. Event-based:
   Publish invalidation events on write
   Subscribers invalidate their caches
```

---

## Distributed File Systems

### GFS/HDFS Architecture

```
Client -> Master (metadata) -> Get chunk location
Client -> Chunk Server 1 (data)
Client -> Chunk Server 2 (data)

Key concepts:
  - Large files split into chunks (64MB-128MB)
  - Master stores metadata (file -> chunk mapping)
  - Chunks replicated across multiple servers (3x typical)
  - Client reads/writes directly to chunk servers
```

### Object Storage (S3-like)

```
API:
  PUT bucket/key -> Store object
  GET bucket/key -> Retrieve object
  DELETE bucket/key -> Remove object

Architecture:
  Client -> API Gateway -> Metadata Service
                        -> Data Nodes (objects)
  
Features:
  - Immutable objects
  - Versioning
  - Lifecycle policies
  - Eventually consistent reads (some systems)
```

---

## Distributed System Patterns

### Circuit Breaker

```
Closed (normal):
  Requests flow through
  Failures counted
  -> If failures > threshold: Open

Open (failing):
  Requests fail fast (no call to downstream)
  After timeout: Half-Open

Half-Open (testing):
  Allow limited requests through
  If succeed: -> Closed
  If fail: -> Open
```

### Bulkhead

```
Isolate failures by resource allocation:

  Service A  ─┬─ Thread Pool 1 (20 threads)
              └─ Thread Pool 2 (10 threads)
  
If Pool 1 is exhausted, Pool 2 still works.
Prevents cascading failures.
```

### Retry with Backoff

```python
import time
import random

def retry_with_backoff(func, max_retries=3, base_delay=1):
    for attempt in range(max_retries):
        try:
            return func()
        except Exception as e:
            if attempt == max_retries - 1:
                raise
            delay = base_delay * (2 ** attempt)  # Exponential backoff
            jitter = random.uniform(0, delay * 0.1)  # Add jitter
            time.sleep(delay + jitter)
```

### Leader Election

```
Use case: Single leader for writes, followers for reads

Algorithm:
  1. All nodes start as followers
  2. After election timeout, become candidate
  3. Request votes from majority
  4. Win majority -> become leader
  5. Send heartbeats to maintain leadership

Libraries: ZooKeeper, etcd, Consul
```

---

## Metrics for Distributed Systems

| Metric | Description | Target |
|--------|------------|--------|
| Latency (p50) | Median response time | < 50ms |
| Latency (p99) | 99th percentile | < 200ms |
| Throughput | Requests per second | Depends on system |
| Error rate | Failed requests percentage | < 0.1% |
| Availability | Uptime percentage | 99.99% |
| Replication lag | Time for data to reach replicas | < 1s |
| Partition recovery | Time to recover from partition | < 1 min |

## Resources

- "Designing Data-Intensive Applications" by Martin Kleppmann
- "Distributed Systems" by Maarten van Steen, Andrew Tanenbaum
- MIT 6.824 Distributed Systems (free lectures)
- "Distributed Algorithms" by Nancy Lynch
- Google Papers: GFS, BigTable, Spanner, MapReduce
