# Scalability Patterns

Patterns and techniques for building systems that handle growth gracefully.

## What is Scalability?

Scalability is the ability of a system to handle increased load by adding resources.

```
Vertical Scaling (Scale Up)     Horizontal Scaling (Scale Out)
┌──────────────────┐            ┌─────┐ ┌─────┐ ┌─────┐
│   BIGGER SERVER  │            │ S1  │ │ S2  │ │ S3  │
│   64 cores       │            └─────┘ └─────┘ └─────┘
│   256GB RAM      │               + Load Balancer
└──────────────────┘

Pros: Simple, no code changes     Pros: Fault tolerant, linear scaling
Cons: Hardware limit, single      Cons: Complexity, distributed challenges
      point of failure
```

---

## Pattern 1: Load Balancing

### Algorithms

| Algorithm | Description | Best For |
|-----------|------------|----------|
| Round Robin | Cyclic distribution | Equal capacity servers |
| Least Connections | Route to least busy | Varying request durations |
| IP Hash | Hash-based routing | Session affinity needed |
| Weighted | Proportional to capacity | Heterogeneous servers |
| Least Response Time | Fastest server | Latency-sensitive |

### Architecture

```
                    ┌──────────────┐
                    │  Load Balancer│
                    │  (NGINX/ALB)  │
                    └──────┬───────┘
              ┌────────────┼────────────┐
              v            v            v
         ┌────────┐  ┌────────┐  ┌────────┐
         │ Web-1  │  │ Web-2  │  │ Web-3  │
         └────────┘  └────────┘  └────────┘
              │            │            │
              └────────────┼────────────┘
                           v
                    ┌──────────────┐
                    │   Database    │
                    └──────────────┘
```

### Health Checks

```
Active Health Checks:
  Load balancer periodically pings: GET /health
  Response: 200 OK (healthy), 503 (unhealthy)
  
Passive Health Checks:
  Monitor actual responses
  If error rate > threshold -> mark as unhealthy
  
Configuration:
  interval: 10s
  timeout: 5s
  unhealthy_threshold: 3 failures
  healthy_threshold: 2 successes
```

---

## Pattern 2: Caching

### Multi-Level Caching

```
Client Cache (Browser)
  ↓ [miss]
CDN Cache (Edge)
  ↓ [miss]
Application Cache (Redis/Memcached)
  ↓ [miss]
Database Cache (Query cache)
  ↓ [miss]
Database (Disk)
```

### Cache Topologies

**Local Cache (In-Process)**
```
Pros: Ultra-fast (no network), simple
Cons: Not shared, memory limited, inconsistent across instances

  ┌──────────────┐
  │ App Server   │
  │ ┌──────────┐ │
  │ │ LRU Cache│ │
  │ └──────────┘ │
  └──────────────┘
```

**Distributed Cache (Redis Cluster)**
```
Pros: Shared, consistent, scalable
Cons: Network latency, complexity

  ┌─────┐ ┌─────┐ ┌─────┐
  │App-1│ │App-2│ │App-3│
  └──┬──┘ └──┬──┘ └──┬──┘
     │       │       │
     └───────┼───────┘
             v
  ┌─────────────────────┐
  │   Redis Cluster     │
  │  [Shard1] [Shard2]  │
  └─────────────────────┘
```

### Cache-Aside Pattern

```python
def get_user(user_id):
    # 1. Check cache
    cached = redis.get(f"user:{user_id}")
    if cached:
        return json.loads(cached)
    
    # 2. Cache miss — query database
    user = db.query("SELECT * FROM users WHERE id = %s", user_id)
    
    # 3. Populate cache with TTL
    redis.setex(
        f"user:{user_id}",
        3600,  # 1 hour TTL
        json.dumps(user)
    )
    return user
```

### Cache Stampede Prevention

```
Problem: Many requests hit cache simultaneously after expiry

Solution 1: Mutex/Lock
  acquire_lock()
  if key_expired:
    value = fetch_from_db()
    cache.set(key, value)
  release_lock()

Solution 2: Probabilistic Early Expiration
  Before TTL expires, randomly refresh:
  if random() < probability_of_refresh:
    value = fetch_from_db()
    cache.set(key, value)

Solution 3: Background Refresh
  Use a scheduler to refresh cache before expiry
```

---

## Pattern 3: Database Scaling

### Read Replicas

```
         ┌─────────────┐
         │    Writer    │
         │   (Primary)  │
         └──────┬───────┘
                │ replication
        ┌───────┼───────┐
        v       v       v
  ┌─────────┐ ┌─────────┐ ┌─────────┐
  │ Reader  │ │ Reader  │ │ Reader  │
  │ Replica │ │ Replica │ │ Replica │
  └─────────┘ └─────────┘ └─────────┘

Routing:
  Writes -> Primary
  Reads -> Load balancer -> Reader replicas
```

### Sharding

```
Shard Key: user_id

Shard Assignment:
  Shard 0: user_id % 3 == 0
  Shard 1: user_id % 3 == 1
  Shard 2: user_id % 3 == 2

    Client Request (user_id=7)
         |
    Shard Router
    (hash(7) % 3 = 1)
         |
    Shard 1
    [DB Server]
```

### CQRS Pattern

```
Command Side (Write):
  User -> API -> Command Handler -> Write DB
                                        |
                                   Event Store
                                        |
Query Side (Read):
  User -> API -> Query Handler -> Read DB (denormalized)
                                        |
                              Event Processor (async)

Benefits:
  - Read and write can scale independently
  - Read models optimized for queries
  - Write models optimized for consistency
```

---

## Pattern 4: Message Queues

### When to Use

```
Use Message Queues When:
  - Processing can be async (email sending, image processing)
  - You need to decouple services
  - You need to handle traffic spikes (buffering)
  - You need guaranteed delivery
  - You need pub/sub (multiple consumers)
```

### Queue Patterns

```
Point-to-Point:
  Producer -> Queue -> Consumer
  One message, one consumer

Pub/Sub:
  Publisher -> Topic -> Consumer A
                   -> Consumer B
                   -> Consumer C
  One message, multiple consumers

Request-Reply:
  Client -> Request Queue -> Server
  Client <- Reply Queue  <- Server
```

### Kafka Architecture

```
Producer --> [Topic: orders]
                  |
          ┌───────┼───────┐
          v       v       v
      Partition0  P1      P2
          |       |       |
       Consumer Group
       ┌───┴───┐
       v       v
    Consumer1 Consumer2

Key Concepts:
  - Topics: Logical channels
  - Partitions: Parallel units
  - Consumer Groups: Scale consumers
  - Offsets: Track consumption progress
```

---

## Pattern 5: Consistent Hashing

### Problem with Simple Hashing

```
Simple: server = hash(key) % num_servers
Problem: Adding/removing a server rehashes everything

  4 servers: key "user123" -> server 2
  Add server 5: key "user123" -> server 4 (different!)
  Most keys need remapping
```

### Consistent Hashing Solution

```
Hash ring (0 to 2^32):

        Server1 (hash)
           |
     -----+-----+------
    /     |      |      \
   /   key1      |       \
  |     •        |   key2 |
  |              |     •  |
   \    Server4  |      /
    \     |      |     /
     -----+------+----
           |
        Server2        Server3
        (hash)         (hash)

Keys map to nearest server clockwise.
Adding/removing server only affects adjacent keys.
```

### Virtual Nodes

```
Problem: Uneven distribution with few physical nodes
Solution: Each physical node has multiple virtual nodes on the ring

  Physical Server 1 -> V1, V2, V3 on ring
  Physical Server 2 -> V4, V5, V6 on ring
  Physical Server 3 -> V7, V8, V9 on ring

Better distribution, easier balancing.
```

---

## Pattern 6: Content Delivery Network (CDN)

### CDN Architecture

```
Without CDN:
  User (Tokyo) -> Origin Server (New York) = 200ms latency

With CDN:
  User (Tokyo) -> Edge Server (Tokyo) = 10ms latency
  Edge Server -> Origin Server (cache miss) = 200ms (rare)
```

### Push vs Pull CDN

```
Push CDN (you push content to CDN):
  - Upload content directly to CDN edge
  - Good for: Small sites, infrequent updates
  - Example: Upload new blog post to CDN

Pull CDN (CDN pulls from origin):
  - First request goes to origin
  - CDN caches and serves subsequent requests
  - Good for: Large sites, dynamic content
  - Example: Image lazy loading
```

### Cache Invalidation

```
TTL (Time To Live):
  Cache-Control: max-age=3600 (1 hour)
  
Purge:
  CDN API: purge CDN cache for URL
  
Versioned URLs:
  style.css?v=2 instead of style.css
  
Content hashing:
  style.a1b2c3d4.css (filename includes hash)
```

---

## Pattern 7: Auto-Scaling

### Metrics-Based Scaling

```
Scale Out (Add instances) when:
  - CPU > 70% for 5 minutes
  - Request queue depth > 100
  - Response time > p95 threshold
  
Scale In (Remove instances) when:
  - CPU < 30% for 15 minutes
  - Request queue depth < 10
  - Cost optimization window

Cooldown period: 5-10 minutes between scaling actions
```

### Scaling Configuration

```yaml
# AWS Auto Scaling Group example
AutoScalingGroup:
  MinSize: 2
  MaxSize: 20
  DesiredCapacity: 4
  
  ScalingPolicy:
    - Metric: CPUUtilization
      Threshold: 70
      Action: Add 2 instances
      
    - Metric: CPUUtilization
      Threshold: 30
      Action: Remove 1 instance
      
  Cooldown: 300 seconds
```

---

## Pattern 8: Rate Limiting

### Token Bucket Algorithm

```
Bucket with capacity C tokens
Refill rate R tokens per second

Request arrives:
  If bucket has tokens:
    Remove 1 token, allow request
  Else:
    Reject/delay request

Example: C=100, R=10/sec
  Can handle burst of 100 requests
  Sustained rate: 10 requests/sec
```

### Distributed Rate Limiting

```
Problem: Multiple servers need coordinated rate limits

Solution: Centralized counter (Redis)
  
  key = f"rate_limit:{user_id}:{window}"
  count = redis.incr(key)
  if count == 1:
    redis.expire(key, window_seconds)
  if count > limit:
    return 429 Too Many Requests
    
Using sliding window for precision:
  Count requests in current window + 
  weighted portion of previous window
```

---

## Pattern 9: Idempotency

### Why Idempotency Matters

```
Problem: Network retries can cause duplicate operations

Client -> Request (create order) -> [Timeout]
Client -> Retry (create order)  -> Server

Without idempotency: Two orders created!
With idempotency: Server recognizes duplicate, returns original result
```

### Implementation

```python
def create_order(request):
    idempotency_key = request.headers['Idempotency-Key']
    
    # Check if we've seen this key
    existing = db.query(
        "SELECT * FROM idempotency WHERE key = %s", 
        idempotency_key
    )
    if existing:
        return existing.response  # Return cached response
    
    # Process the request
    order = process_order(request)
    
    # Store the idempotency key with response
    db.insert("INSERT INTO idempotency (key, response) VALUES (%s, %s)",
              idempotency_key, json.dumps(order))
    
    return order
```

---

## Scaling Decision Matrix

| Problem | Pattern | Complexity | Cost |
|---------|---------|-----------|------|
| High read traffic | Caching + Read replicas | Low | Low |
| High write traffic | Sharding + Message queues | High | High |
| Global users | CDN + Multi-region | Medium | High |
| Traffic spikes | Auto-scaling + Queue buffering | Medium | Medium |
| Data growth | Archival + Compression | Low | Low |
| Hot data access | Cache + In-memory DB | Low | Medium |

## Performance Targets

| Metric | Good | Acceptable | Poor |
|--------|------|-----------|------|
| API latency (p50) | < 50ms | < 200ms | > 500ms |
| API latency (p99) | < 200ms | < 1s | > 2s |
| Error rate | < 0.1% | < 1% | > 1% |
| Availability | 99.99% | 99.9% | 99% |
| Recovery time | < 1 min | < 5 min | > 30 min |

## Resources

- "Building Microservices" by Sam Newman
- "The Art of Scalability" by Abbott & Fisher
- "Site Reliability Engineering" by Google
- High Scalability blog
- AWS Architecture Center
