# System Design Flashcards

Q&A flashcards covering essential system design concepts for technical interviews.

---

## Fundamentals

### Card 1: Scalability

**Q:** What's the difference between horizontal and vertical scaling?

**A:**

**Vertical Scaling (Scale Up):**
- Add more resources to single machine
- CPU, RAM, Storage upgrades
- Simple but limited
- Single point of failure

**Horizontal Scaling (Scale Out):**
- Add more machines
- Load balancing required
- More complex but unlimited
- Better fault tolerance

**When to use:**
- Vertical: Small apps, databases
- Horizontal: Large-scale systems, high availability

---

### Card 2: CAP Theorem

**Q:** What does the CAP theorem state?

**A:** A distributed system can guarantee at most 2 of 3:

- **Consistency:** Every read receives most recent write
- **Availability:** Every request receives response
- **Partition Tolerance:** System works despite network failures

**In practice:** Partition tolerance is required, so choose:
- **CP:** Consistent but may be unavailable
- **AP:** Available but may be inconsistent

**Examples:**
- CP: HBase, MongoDB (with majority read)
- AP: Cassandra, DynamoDB

---

### Card 3: Consistency Models

**Q:** What are the main consistency models?

**A:**

| Model | Description | Use Case |
|-------|-------------|----------|
| Strong | Read returns most recent write | Banking |
| Eventual | Eventually consistent | Social media |
| Causal | Preserves causal ordering | Collaborative editing |
| Weak | No ordering guarantees | DNS |

---

## Databases

### Card 4: SQL vs NoSQL

**Q:** When should you use SQL vs NoSQL?

**A:**

| SQL | NoSQL |
|-----|-------|
| Structured data | Unstructured/semi-structured |
| ACID transactions | Eventual consistency |
| Complex queries | Simple queries |
| Vertical scaling | Horizontal scaling |
| Fixed schema | Flexible schema |

**SQL:** Banking, e-commerce, data integrity critical
**NoSQL:** Real-time apps, big data, rapid development

---

### Card 5: Database Indexing

**Q:** How do database indexes work and when to use them?

**A:**

**What is an index:** Data structure that speeds up data retrieval.

**Types:**
- **B-Tree:** Default, good for range queries
- **Hash:** Exact match, O(1) lookup
- **GIN:** Full-text search, array contains
- **GiST:** Spatial data, geometric queries

**When to index:**
- Columns in WHERE clauses
- Columns in JOIN conditions
- Columns in ORDER BY

**When NOT to index:**
- Small tables
- Columns with low cardinality
- Frequently updated columns

---

### Card 6: Replication

**Q:** What are the types of database replication?

**A:**

| Type | Description | Trade-off |
|------|-------------|-----------|
| Master-Slave | One write, multiple reads | Read scalability, single write bottleneck |
| Master-Master | Multiple writes, multiple reads | Complexity, conflict resolution |
| Peer-to-Peer | All nodes can read/write | Consistency challenges |

**Sync vs Async:**
- Sync: Strong consistency, higher latency
- Async: Eventual consistency, lower latency

---

### Card 7: Sharding

**Q:** What is sharding and what are its strategies?

**A:**

**Sharding:** Horizontal partitioning across multiple databases.

**Strategies:**
1. **Range-based:** Shard by value ranges
2. **Hash-based:** Shard by hash of key
3. **Geographic:** Shard by location

**Challenges:**
- Joins across shards
- Rebalancing
- Cross-shard transactions
- Hotspots

---

## Caching

### Card 8: Caching Strategies

**Q:** What are the main caching strategies?

**A:**

| Strategy | Description | Best For |
|----------|-------------|----------|
| Cache-Aside | App manages cache | General purpose |
| Read-Through | Cache loads from DB | Read-heavy |
| Write-Through | Write to cache and DB | Data consistency |
| Write-Behind | Write to cache, async to DB | Write-heavy |

---

### Card 9: Cache Invalidation

**Q:** How do you handle cache invalidation?

**A:**

**Strategies:**
1. **TTL (Time-To-Live):** Expire after set time
2. **Event-driven:** Invalidate on data change
3. **Version-based:** Cache key includes version
4. **Write-through:** Update cache with write

**Common problems:**
- Thundering herd: Many requests hit DB
- Cache stampede: Cache expires simultaneously
- Stale data: Cache not updated

---

### Card 10: Redis vs Memcached

**Q:** What are the differences between Redis and Memcached?

**A:**

| Feature | Redis | Memcached |
|---------|-------|-----------|
| Data structures | Strings, lists, sets, hashes | Strings only |
| Persistence | Yes | No |
| Clustering | Built-in | Client-side |
| Memory | More efficient | Less overhead |
| Pub/Sub | Yes | No |

**Use Redis when:** Need complex data structures, persistence
**Use Memcached when:** Simple key-value, high throughput

---

## Load Balancing

### Card 11: Load Balancing Algorithms

**Q:** What are common load balancing algorithms?

**A:**

| Algorithm | Description | Best For |
|-----------|-------------|----------|
| Round Robin | Distribute equally | Equal capacity servers |
| Least Connections | Send to least busy | Variable request times |
| IP Hash | Same IP to same server | Session persistence |
| Weighted | Based on server capacity | Heterogeneous servers |
| Least Response Time | Fastest server | Performance critical |

---

### Card 12: L4 vs L7 Load Balancing

**Q:** What's the difference between L4 and L7 load balancing?

**A:**

**L4 (Transport):**
- TCP/UDP level
- Faster, less overhead
- Can't inspect content
- Use for: Simple routing, high throughput

**L7 (Application):**
- HTTP/HTTPS level
- Can inspect headers, content
- More features, more overhead
- Use for: Content routing, SSL termination

---

## Message Queues

### Card 13: Message Queue Patterns

**Q:** What are the main message queue patterns?

**A:**

| Pattern | Description | Use Case |
|---------|-------------|----------|
| Point-to-Point | One producer, one consumer | Task queues |
| Publish-Subscribe | One producer, many consumers | Notifications |
| Request-Reply | Wait for response | Synchronous calls |
| Fan-out | Broadcast to all | Event distribution |

**Popular systems:** RabbitMQ, Kafka, SQS

---

### Card 14: Kafka vs RabbitMQ

**Q:** When would you choose Kafka over RabbitMQ?

**A:**

| Kafka | RabbitMQ |
|-------|----------|
| High throughput | Lower latency |
| Message replay | Message deletion |
| Distributed log | Traditional queue |
| Stream processing | Complex routing |

**Choose Kafka for:** Log aggregation, event streaming, analytics
**Choose RabbitMQ for:** Task queues, RPC, complex routing

---

## Microservices

### Card 15: Microservices Pros/Cons

**Q:** What are the advantages and disadvantages of microservices?

**A:**

**Advantages:**
- Independent deployment
- Technology diversity
- Fault isolation
- Scalability per service

**Disadvantages:**
- Distributed system complexity
- Network latency
- Data consistency challenges
- Operational overhead

**When to use:** Large teams, complex domains, need for independence

---

### Card 16: Service Discovery

**Q:** How do microservices find each other?

**A:**

**Approaches:**
1. **Client-side:** Service maintains registry
2. **Server-side:** Load balancer handles discovery
3. **DNS-based:** Use DNS for resolution

**Tools:**
- Consul
- Eureka
- etcd
- Kubernetes Service

---

## Security

### Card 17: Authentication vs Authorization

**Q:** What's the difference between authentication and authorization?

**A:**

**Authentication:** Who are you?
- Username/password
- OAuth tokens
- JWT
- MFA

**Authorization:** What can you do?
- RBAC (Role-Based)
- ABAC (Attribute-Based)
- ACL (Access Control Lists)

**Both are essential for security.**

---

### Card 18: JWT vs Sessions

**Q:** When should you use JWT vs sessions?

**A:**

| JWT | Sessions |
|-----|----------|
| Stateless | Stateful |
| Stored client-side | Stored server-side |
| Scalable | Harder to scale |
| No revocation | Easy to revoke |

**Use JWT for:** APIs, microservices, mobile apps
**Use Sessions for:** Traditional web apps, need for revocation

---

## Monitoring

### Card 19: Three Pillars of Observability

**Q:** What are the three pillars of observability?

**A:**

| Pillar | What It Captures | Tools |
|--------|------------------|-------|
| Logs | Discrete events | ELK, Fluentd |
| Metrics | Numerical measurements | Prometheus, Datadog |
| Traces | Request flow across services | Jaeger, Zipkin |

**Together they provide:** Complete visibility into system behavior

---

### Card 20: SLA vs SLO vs SLI

**Q:** What's the difference between SLA, SLO, and SLI?

**A:**

**SLI (Service Level Indicator):**
- Metric measuring service performance
- e.g., 99.9% of requests < 200ms

**SLO (Service Level Objective):**
- Target value for SLI
- e.g., 99.9% availability

**SLA (Service Level Agreement):**
- Contractual commitment
- Includes consequences for missing SLO

---

## Design Patterns

### Card 21: Circuit Breaker

**Q:** What is the circuit breaker pattern?

**A:** Prevents cascading failures in distributed systems.

**States:**
1. **Closed:** Requests flow normally
2. **Open:** Requests fail immediately
3. **Half-Open:** Test if service recovered

**Use when:** Calling external services, network dependencies

---

### Card 22: CQRS

**Q:** What is CQRS and when is it useful?

**A:**

**Command Query Responsibility Segregation:**
- Separate read and write models
- Different databases for each
- Optimized for each operation

**Use when:**
- Read and write loads differ significantly
- Complex domain with different read/write needs
- Event sourcing

---

## Capacity Planning

### Card 23: Estimation

**Q:** How do you estimate system capacity?

**A:**

**Process:**
1. Estimate daily active users
2. Estimate requests per user
3. Calculate total QPS
4. Add buffer (2-3x)
5. Calculate storage needs

**Example:**
- 10M DAU
- 10 requests/user/day
- 100M requests/day = ~1,160 QPS
- With 3x buffer: 3,500 QPS

---

### Card 24: Bandwidth Calculation

**Q:** How do you calculate bandwidth requirements?

**A:**

```
Bandwidth = (Requests × Average Size) / Time

Example:
- 10,000 requests/second
- 10KB average response
- = 100MB/s = 800Mbps
```

**Consider:**
- Peak vs average traffic
- Compression
- CDN for static assets

---

## Availability

### Card 25: Availability Calculations

**Q:** What does "five nines" availability mean?

**A:**

| Availability | Downtime/Year | Downtime/Month |
|--------------|---------------|----------------|
| 99% (2 nines) | 3.65 days | 7.31 hours |
| 99.9% (3 nines) | 8.76 hours | 43.8 minutes |
| 99.99% (4 nines) | 52.6 minutes | 4.38 minutes |
| 99.999% (5 nines) | 5.26 minutes | 26.3 seconds |

**How to achieve:**
- Redundancy
- Failover
- Monitoring
- Testing

---

## Quick Reference

### System Design Interview Checklist

```
UNDERSTAND REQUIREMENTS
□ Functional requirements
□ Non-functional requirements
□ Scale estimates
□ Data model

HIGH-LEVEL DESIGN
□ Core components
□ Data flow
□ API design

DETAILED DESIGN
□ Database schema
□ Caching strategy
□ Load balancing
□ Message queues

CROSS-CUTTING
□ Monitoring
□ Security
□ Deployment
□ Cost estimation
```

### Common Design Patterns

| Pattern | Use Case |
|---------|----------|
| Cache-Aside | General caching |
| Circuit Breaker | Fault tolerance |
| Event Sourcing | Audit trail |
| CQRS | Read/write optimization |
| Saga | Distributed transactions |
| Sidecar | Service mesh |
