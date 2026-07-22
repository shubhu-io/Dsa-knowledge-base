# System Design Guide

A comprehensive guide to designing scalable, reliable, and efficient systems.

## The System Design Process

```
Step 1: REQUIREMENTS           Step 2: HIGH-LEVEL DESIGN
  - Functional                   - Major components
  - Non-functional               - Data flow
  - Constraints                  - API design
         |                              |
         v                              v
Step 5: TRADE-OFFS              Step 3: DETAILED DESIGN
  - Consistency vs               - Database schema
    Availability                - Algorithms
  - Cost vs Performance         - Caching strategy
         |                              |
         v                              v
            Step 4: SCALE & OPTIMIZE
              - Bottlenecks
              - Horizontal scaling
              - Load balancing
```

## Step 1: Requirements Gathering

### Functional Requirements
```
Ask: "What should the system DO?"

Examples:
  - User can create/read/update/delete posts
  - User can follow other users
  - User can see a feed of posts from people they follow
  - System can handle image uploads
```

### Non-Functional Requirements
```
Ask: "What QUALITY attributes matter?"

  - Availability: 99.99% uptime?
  - Latency: < 200ms response time?
  - Throughput: 10,000 requests/second?
  - Durability: No data loss?
  - Scalability: 100M users?
```

### Capacity Estimation
```
Given:
  - 100M daily active users
  - 10 requests/user/day
  - 1KB per request

Calculate:
  - QPS = 100M * 10 / 86400 ≈ 11,600 QPS
  - Peak QPS = 2 * avg = 23,200 QPS
  - Storage/day = 100M * 10 * 1KB = 1TB/day
  - Storage/year = 365TB
  - Bandwidth = 11,600 * 1KB = 11.6 MB/s
```

---

## Step 2: High-Level Architecture

### Building Blocks

```
                         CLIENT
                           |
                      LOAD BALANCER
                     /      |       \
                 APP-1   APP-2    APP-3
                   |       |        |
                +--+-------+--------+--+
                |   CACHE LAYER (Redis) |
                +-----------+-----------+
                            |
                      MESSAGE QUEUE
                            |
                     +------+------+
                     |             |
                  DATABASE    SEARCH
                  (Primary)   (Elasticsearch)
                     |
                  REPLICA(s)
```

### Common Components

| Component | Purpose | Examples |
|-----------|---------|---------|
| Load Balancer | Distribute traffic | NGINX, HAProxy, AWS ALB |
| Application Server | Business logic | Node.js, Spring Boot, Django |
| Cache | Fast reads | Redis, Memcached |
| Database | Persistent storage | PostgreSQL, MongoDB, Cassandra |
| Message Queue | Async processing | Kafka, RabbitMQ, SQS |
| CDN | Static asset delivery | CloudFront, Akamai |
| Search Engine | Full-text search | Elasticsearch, Solr |
| Object Storage | File/blob storage | S3, GCS, Azure Blob |

---

## Step 3: API Design

### RESTful API Design

```
Resources:
  /users          - User operations
  /posts          - Post operations
  /feed           - User feed
  /follow         - Follow relationships

Methods:
  GET    /users/:id          - Get user profile
  POST   /users              - Create user
  PUT    /users/:id          - Update user
  DELETE /users/:id          - Delete user
  
  GET    /posts/:id          - Get post
  POST   /posts              - Create post
  GET    /users/:id/feed     - Get user's feed
  
  POST   /follow             - Follow a user
  DELETE /follow/:id         - Unfollow a user
```

### API Response Format

```json
{
  "status": "success",
  "data": {
    "id": 123,
    "username": "john_doe",
    "posts": [...]
  },
  "meta": {
    "page": 1,
    "total": 50
  }
}
```

### Rate Limiting

```
Headers:
  X-RateLimit-Limit: 100       (requests per window)
  X-RateLimit-Remaining: 75    (requests left)
  X-RateLimit-Reset: 1640000000 (window reset time)

Algorithms:
  - Token Bucket: Allows bursts, smooth rate
  - Sliding Window: Precise counting
  - Fixed Window: Simple but bursty
  - Leaky Bucket: Smooths out bursts
```

---

## Step 4: Database Design

### SQL vs NoSQL Decision

| Factor | SQL | NoSQL |
|--------|-----|-------|
| Schema | Fixed, structured | Flexible, dynamic |
| Relationships | Strong (JOINs) | Weak (denormalized) |
| ACID | Guaranteed | Eventual consistency |
| Scaling | Vertical | Horizontal |
| Query Language | SQL | Varies |
| Best For | Complex queries, transactions | High throughput, flexibility |

### Database Schema Example (URL Shortener)

```sql
-- Users table
CREATE TABLE users (
    id          BIGINT PRIMARY KEY AUTO_INCREMENT,
    email       VARCHAR(255) UNIQUE NOT NULL,
    username    VARCHAR(100) UNIQUE NOT NULL,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- URLs table
CREATE TABLE urls (
    id          BIGINT PRIMARY KEY AUTO_INCREMENT,
    short_code  VARCHAR(10) UNIQUE NOT NULL,
    original_url TEXT NOT NULL,
    user_id     BIGINT REFERENCES users(id),
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at  TIMESTAMP,
    click_count BIGINT DEFAULT 0
);

-- Analytics table
CREATE TABLE clicks (
    id          BIGINT PRIMARY KEY AUTO_INCREMENT,
    url_id      BIGINT REFERENCES urls(id),
    ip_address  VARCHAR(45),
    user_agent  TEXT,
    referrer    TEXT,
    clicked_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX idx_urls_short_code ON urls(short_code);
CREATE INDEX idx_clicks_url_id ON clicks(url_id);
CREATE INDEX idx_clicks_time ON clicks(clicked_at);
```

### Database Sharding Strategies

```
Strategy 1: Hash-based Sharding
  shard = hash(user_id) % num_shards
  Even distribution, but resharding is expensive

Strategy 2: Range-based Sharding
  Shard 0: user_id 1-1M
  Shard 1: user_id 1M-2M
  Easy to scale, but can create hotspots

Strategy 3: Directory-based
  Lookup table maps keys to shards
  Flexible, but adds a lookup hop
```

---

## Step 5: Caching Strategies

### Cache Patterns

```
Pattern 1: Cache-Aside (Lazy Loading)
  Application -> Check Cache -> [Miss] -> Read DB -> Write to Cache
  Application -> Check Cache -> [Hit]  -> Return cached data

Pattern 2: Write-Through
  Application -> Write to Cache AND DB simultaneously
  Always consistent, but write latency

Pattern 3: Write-Behind (Write-Back)
  Application -> Write to Cache -> Async write to DB
  Fast writes, but risk of data loss

Pattern 4: Read-Through
  Application -> Cache -> [Miss] -> Cache fetches from DB
  Cache handles DB interaction
```

### Cache Eviction Policies

| Policy | Description | Use Case |
|--------|------------|----------|
| LRU | Least Recently Used | General purpose |
| LFU | Least Frequently Used | Skewed access patterns |
| FIFO | First In First Out | Simple, predictable |
| TTL | Time To Live | Data with expiry |

### Cache Invalidation Strategies

```
1. Time-based (TTL)
   Set expiration: cache.set(key, value, ttl=3600)
   
2. Event-based
   On write: cache.delete(key)
   
3. Version-based
   Key includes version: "user:123:v2"
```

---

## Step 6: Scaling

### Horizontal Scaling

```
Before (Vertical):
  [SERVER: 64 cores, 256GB RAM]
  
After (Horizontal):
  [SERVER: 4 cores, 16GB RAM] x 16
  + Load Balancer
  
Benefits:
  - Fault tolerance (one server fails, others continue)
  - Cost-effective (commodity hardware)
  - Linear scaling (add more servers)
```

### Database Scaling

```
Read Scaling: Replication
  PRIMARY (writes) --> REPLICA1 (reads)
                    --> REPLICA2 (reads)
                    --> REPLICA3 (reads)

Write Scaling: Sharding
  Shard 1: users A-M    [DB Server 1]
  Shard 2: users N-Z    [DB Server 2]

Combined:
  Shard 1 PRIMARY --> Shard 1 REPLICA1
                  --> Shard 1 REPLICA2
  Shard 2 PRIMARY --> Shard 2 REPLICA1
                  --> Shard 2 REPLICA2
```

### CDN Strategy

```
Static Assets:
  User -> CDN Edge -> [Cache Hit] -> Return
  User -> CDN Edge -> [Cache Miss] -> Origin Server -> CDN Edge -> User

Dynamic Content:
  User -> Load Balancer -> App Server -> Database
  
When to use CDN:
  - Static files (images, CSS, JS)
  - Video streaming
  - API responses with high cache hit rate
  - Global user base
```

---

## Step 7: Reliability & Availability

### Redundancy Patterns

```
Active-Passive:
  [ACTIVE]  ----heartbeat----  [STANDBY]
  All traffic -> ACTIVE
  On failure -> STANDBY becomes ACTIVE

Active-Active:
  [ACTIVE1] <-----> [ACTIVE2]
  Both handle traffic
  Load balancer distributes
```

### Failure Handling

| Failure Type | Detection | Recovery |
|-------------|-----------|----------|
| Server crash | Health checks | Auto-restart, failover |
| Database failure | Replication lag | Promote replica |
| Network partition | Timeout, retries | Circuit breaker |
| Disk full | Monitoring | Auto-scaling, cleanup |
| Memory leak | OOM kills | Restart, memory limits |

### Circuit Breaker Pattern

```
State Machine:
  CLOSED  --(failure threshold)--> OPEN
  OPEN    --(timeout)--> HALF-OPEN
  HALF-OPEN --(success)--> CLOSED
  HALF-OPEN --(failure)--> OPEN

  CLOSED: Normal operation, requests flow through
  OPEN: Requests fail immediately (fast fail)
  HALF-OPEN: Allow one request to test
```

---

## Step 8: Monitoring & Observability

### Three Pillars

```
1. METRICS
   - QPS, latency percentiles (p50, p95, p99)
   - Error rates (4xx, 5xx)
   - Resource utilization (CPU, memory, disk)
   - Business metrics (DAU, revenue)

2. LOGGING
   - Structured logs (JSON format)
   - Correlation IDs for request tracing
   - Log levels (DEBUG, INFO, WARN, ERROR)
   - Centralized logging (ELK, CloudWatch)

3. TRACING
   - Distributed tracing (Jaeger, Zipkin)
   - Request flow across services
   - Latency breakdown per service
   - Error propagation
```

### Alerting Strategy

```
Severity Levels:
  P1 (Critical): System down, data loss -> Page immediately
  P2 (High): Major feature broken -> Notify within 30 min
  P3 (Medium): Degraded performance -> Notify within 4 hours
  P4 (Low): Minor issue -> Daily digest

Alert Rules:
  - Error rate > 1% for 5 minutes -> P2
  - P99 latency > 1s for 10 minutes -> P3
  - Disk usage > 80% -> P3
  - CPU usage > 90% for 15 minutes -> P4
```

---

## Common Design Patterns

### CQRS (Command Query Responsibility Segregation)
```
Write Model (Commands):
  Client -> Command Handler -> Write DB -> Event Store

Read Model (Queries):
  Client -> Query Handler -> Read DB (denormalized)
  
Events sync write DB to read DB asynchronously
```

### Event Sourcing
```
Instead of storing current state, store all events:
  Events: [UserCreated, EmailChanged, NameChanged]
  Current State: derived by replaying events

Benefits:
  - Complete audit trail
  - Temporal queries (state at any point in time)
  - Event replay for debugging
```

### Strangler Fig Pattern (Migration)
```
Old System:
  [MONOLITH] <-- All traffic
  
Migration:
  [MONOLITH] <--- traffic split ---> [NEW SERVICE]
  
Complete:
  [NEW SERVICE] <-- All traffic
  [MONOLITH] (deprecated)
```

---

## Design Template for Interviews

```
1. Requirements (3-5 min)
   "Let me clarify the requirements..."
   - Functional: What features?
   - Non-functional: Scale, latency, availability?
   - Constraints: Budget, timeline, team?

2. Estimation (3-5 min)
   "Let's estimate the scale..."
   - Users, requests, storage
   - Bandwidth, QPS

3. High-Level Design (10-15 min)
   "Here's the architecture..."
   - Draw major components
   - Show data flow
   - Explain choices

4. Deep Dive (15-20 min)
   "Let's dive into the key components..."
   - Database schema
   - API design
   - Caching strategy
   - Algorithms

5. Scale & Wrap Up (5-10 min)
   "How do we handle growth..."
   - Bottlenecks and solutions
   - Monitoring and alerts
   - Trade-offs and alternatives
```

## Resources

- "Designing Data-Intensive Applications" by Martin Kleppmann
- "System Design Interview" by Alex Xu (Volumes 1 & 2)
- "Building Microservices" by Sam Newman
- "The Art of Scalability" by Abbott & Fisher
- High Scalability blog
- Company engineering blogs (Netflix, Uber, Airbnb, Stripe)
