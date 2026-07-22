# System Design Interview Questions

Common system design interview problems with structured solutions.

## How to Approach System Design Interviews

```
TIME ALLOCATION (45-60 minutes):

  0-5 min:   Requirements & Scope
  5-15 min:  High-Level Design
  15-35 min: Deep Dive (choose 2-3 components)
  35-50 min: Scale & Bottlenecks
  50-55 min: Wrap Up & Trade-offs
```

---

## Question 1: Design a URL Shortener (like bit.ly)

### Requirements

```
Functional:
  - Given a long URL, generate a short URL
  - Given a short URL, redirect to original URL
  - Custom aliases (optional)
  - Link expiration (optional)
  - Analytics (click counts, referrers)

Non-Functional:
  - 100M URLs generated per day
  - 10:1 read:write ratio (1B redirects/day)
  - Low latency (< 100ms redirect)
  - High availability
```

### Capacity Estimation

```
Writes: 100M / 86400 ≈ 1,200 QPS
Reads: 10 * 1,200 = 12,000 QPS
Storage (5 years): 100M * 365 * 5 * 500 bytes ≈ 91 TB
Short URL length: 7 characters (62^7 ≈ 3.5 trillion URLs)
```

### High-Level Design

```
┌────────┐     ┌──────────┐     ┌────────────┐
│ Client │────>│   Load   │────>│   URL      │
│        │     │ Balancer │     │ Service    │
└────────┘     └──────────┘     └─────┬──────┘
                                      │
                    ┌─────────────────┼─────────────────┐
                    v                 v                 v
              ┌──────────┐     ┌──────────┐     ┌──────────┐
              │   Cache   │     │ Database │     │ Analytics│
              │  (Redis)  │     │(NoSQL)   │     │ Service  │
              └──────────┘     └──────────┘     └──────────┘
```

### API Design

```
POST /api/shorten
  Request:  { "long_url": "https://...", "custom_alias": "mylink", "expiry": "2025-12-31" }
  Response: { "short_url": "https://bit.ly/abc123", "expires_at": "2025-12-31" }

GET /:short_code
  Response: 301 Redirect to original URL

GET /api/analytics/:short_code
  Response: { "clicks": 12345, "referrers": {...}, "countries": {...} }
```

### URL Generation Strategies

| Strategy | Example | Pros | Cons |
|----------|---------|------|------|
| MD5 hash (first 7 chars) | abc1234 | Simple | Collisions possible |
| Counter-based | 000001, 000002 | No collisions | Predictable |
| Base62 encoding | k98sdF | Compact | Need collision handling |
| Pre-generated keys | Use key service | No collisions | Storage overhead |

### Database Design

```sql
CREATE TABLE urls (
    id          BIGINT PRIMARY KEY AUTO_INCREMENT,
    short_code  VARCHAR(10) UNIQUE NOT NULL,
    original_url TEXT NOT NULL,
    user_id     BIGINT,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at  TIMESTAMP,
    click_count BIGINT DEFAULT 0
);

CREATE TABLE clicks (
    id          BIGINT PRIMARY KEY AUTO_INCREMENT,
    url_id      BIGINT REFERENCES urls(id),
    ip_address  VARCHAR(45),
    user_agent  TEXT,
    referrer    TEXT,
    clicked_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_short_code ON urls(short_code);
CREATE INDEX idx_clicks_url ON clicks(url_id, clicked_at);
```

### Scaling Considerations

```
1. Cache hot URLs in Redis
   - 80/20 rule: 20% of URLs get 80% of traffic
   - Cache hit rate > 90% possible

2. Database sharding by short_code hash

3. Read replicas for analytics queries

4. Async analytics processing via message queue
```

---

## Question 2: Design a Chat Application (like WhatsApp/Slack)

### Requirements

```
Functional:
  - 1:1 messaging
  - Group messaging
  - Online/offline status
  - Message delivery status (sent, delivered, read)
  - Media sharing (images, files)
  - Message history

Non-Functional:
  - 50M daily active users
  - Low latency (< 200ms message delivery)
  - Message ordering guaranteed within conversation
  - Support 100K concurrent connections per server
```

### High-Level Design

```
┌────────┐     ┌──────────┐     ┌──────────────────┐
│ Client │◄───►│ WS Gateway│◄───►│  Chat Service     │
│ (Phone)│     │ (WebSocket)│     │  (Business Logic) │
└────────┘     └──────────┘     └────────┬─────────┘
                                         │
              ┌──────────────────────────┼──────────────────┐
              v                          v                  v
        ┌──────────┐            ┌──────────────┐    ┌────────────┐
        │  Redis   │            │  Message DB  │    │  Push      │
        │ (Pub/Sub)│            │ (Cassandra)  │    │  Notification│
        └──────────┘            └──────────────┘    └────────────┘
```

### WebSocket vs HTTP Long Polling

| Approach | Latency | Server Resources | Complexity |
|----------|---------|-----------------|-----------|
| HTTP Polling | High (periodic) | Low | Low |
| Long Polling | Medium | Medium | Medium |
| WebSocket | Low (real-time) | High (connections) | High |
| SSE | Low (server push) | Medium | Low |

### Message Flow (1:1 Chat)

```
1. User A sends message to User B
2. Chat Service validates and stores message
3. Chat Service checks if User B is online:
   a. Online: Push via WebSocket connection
   b. Offline: Queue for later delivery + push notification
4. User B receives message
5. User B sends ACK (delivered)
6. User B opens message -> sends read receipt
```

### Message Storage Schema

```sql
CREATE TABLE messages (
    message_id    BIGINT PRIMARY KEY,
    conversation_id UUID NOT NULL,
    sender_id     BIGINT NOT NULL,
    content       TEXT,
    message_type  ENUM('text', 'image', 'file'),
    created_at    TIMESTAMP,
    status        ENUM('sent', 'delivered', 'read')
);

CREATE TABLE conversations (
    conversation_id UUID PRIMARY KEY,
    type           ENUM('direct', 'group'),
    created_at     TIMESTAMP
);

CREATE TABLE conversation_members (
    conversation_id UUID,
    user_id        BIGINT,
    joined_at      TIMESTAMP,
    PRIMARY KEY (conversation_id, user_id)
);

-- Partition by conversation_id for locality
CREATE INDEX idx_messages_conv ON messages(conversation_id, created_at);
```

### Presence Service

```
Track online/offline status:

Redis approach:
  SET user:{id}:status "online"
  SET user:{id}:last_seen timestamp
  EXPIRE user:{id}:status 300  (5 min timeout)

  Heartbeat: Client pings every 60s
  If no heartbeat for 5 min -> mark offline
```

### Scaling Strategies

```
1. WebSocket Connection Management:
   - Each server handles ~100K connections
   - 50M DAU / 10% concurrent = 5M concurrent
   - Need ~50 WebSocket servers

2. Message Fan-out:
   - Group of 100: broadcast to 100 connections
   - Use message queue for async delivery

3. Message Storage:
   - Cassandra: partition by conversation_id
   - Time-ordered within partition
   - TTL for old messages
```

---

## Question 3: Design a Rate Limiter

### Requirements

```
Functional:
  - Limit requests per client per time window
  - Support different limits per API/endpoint
  - Return appropriate HTTP headers
  - Support distributed rate limiting

Non-Functional:
  - Sub-millisecond decision time
  - High accuracy (within 1%)
  - Handle 10M+ requests/second
  - Fault tolerant
```

### Algorithms

**Token Bucket**
```
Bucket capacity: 100 tokens
Refill rate: 10 tokens/sec

Request arrives:
  Add tokens based on elapsed time
  If tokens >= 1:
    Consume 1 token, allow request
  Else:
    Reject request

Pros: Allows bursts, smooth rate
Cons: Two parameters to tune
```

**Sliding Window Log**
```
Store timestamp of each request in sorted set

Request arrives:
  Remove entries older than window
  Count remaining entries
  If count < limit: allow, add timestamp
  Else: reject

Pros: Precise
Cons: High memory (stores every timestamp)
```

**Sliding Window Counter**
```
Combine current window count with weighted previous window

current_count + (previous_count * overlap_percentage)

Example: Window = 1 min, current = 7, previous = 12, overlap = 30%
  Effective count = 7 + (12 * 0.3) = 10.6
  If limit = 10: reject

Pros: Memory efficient, accurate
Cons: Approximate
```

### Architecture

```
┌────────┐     ┌──────────────────┐     ┌──────────┐
│ Client │────>│   Rate Limiter   │────>│  Server  │
│        │     │                  │     │          │
│  HTTP  │<────│ Redis Counter    │     │ Business │
│ Request│     │                  │     │ Logic    │
└────────┘     └──────────────────┘     └──────────┘

Headers returned:
  X-RateLimit-Limit: 100
  X-RateLimit-Remaining: 75
  X-RateLimit-Reset: 1640000000
```

### Response Codes

```
200 OK: Request allowed
429 Too Many Requests: Rate limit exceeded
  Retry-After: 30  (seconds to wait)
```

### Distributed Rate Limiting

```python
# Redis-based sliding window counter
def is_rate_limited(user_id, limit, window_seconds):
    key = f"rate:{user_id}:{int(time.time()) // window_seconds}"
    
    pipe = redis.pipeline()
    pipe.incr(key)
    pipe.expire(key, window_seconds * 2)
    current_count = pipe.execute()[0]
    
    return current_count > limit
```

---

## Question 4: Design a Notification System

### Requirements

```
Functional:
  - Push notifications (mobile)
  - SMS notifications
  - Email notifications
  - In-app notifications
  - User notification preferences
  - Notification history

Non-Functional:
  - 10M notifications/day
  - Support 100M users
  - Delivery within seconds
  - At-least-once delivery
  - Retry failed deliveries
```

### High-Level Design

```
┌─────────┐    ┌──────────────┐    ┌──────────────┐
│ Event   │───>│ Notification │───>│  Message     │
│ Source  │    │ Service      │    │  Queue       │
└─────────┘    └──────────────┘    └──────┬───────┘
                                          │
                    ┌─────────────────────┼─────────────────────┐
                    v                     v                     v
             ┌────────────┐       ┌────────────┐       ┌────────────┐
             │   Email    │       │    Push    │       │    SMS     │
             │  Worker    │       │   Worker   │       │   Worker   │
             └──────┬─────┘       └──────┬─────┘       └──────┬─────┘
                    v                     v                     v
             ┌────────────┐       ┌────────────┐       ┌────────────┐
             │  SendGrid  │       │   FCM/APNs │       │   Twilio   │
             └────────────┘       └────────────┘       └────────────┘
```

### Notification Flow

```
1. Event triggers notification (new order, comment, etc.)
2. Notification Service:
   a. Check user preferences (opted in?)
   b. Check rate limits (not spamming?)
   c. Enrich content (template + personalization)
   d. Route to appropriate channel
3. Message Queue: Ensures reliable delivery
4. Worker: Calls external provider (SendGrid, FCM, Twilio)
5. Retry: Failed deliveries retried with exponential backoff
6. Tracking: Record delivery status
```

### Database Schema

```sql
CREATE TABLE notifications (
    id          BIGINT PRIMARY KEY,
    user_id     BIGINT NOT NULL,
    type        ENUM('push', 'email', 'sms', 'in_app'),
    title       VARCHAR(255),
    body        TEXT,
    data        JSON,
    status      ENUM('pending', 'sent', 'delivered', 'failed'),
    created_at  TIMESTAMP,
    sent_at     TIMESTAMP,
    delivered_at TIMESTAMP
);

CREATE TABLE user_preferences (
    user_id     BIGINT PRIMARY KEY,
    push_enabled BOOLEAN DEFAULT TRUE,
    email_enabled BOOLEAN DEFAULT TRUE,
    sms_enabled  BOOLEAN DEFAULT FALSE,
    quiet_hours_start TIME,
    quiet_hours_end TIME
);

CREATE INDEX idx_notifications_user ON notifications(user_id, created_at);
```

### Delivery Guarantees

```
At-Least-Once Delivery:
  - Message queue ensures message is not lost
  - Worker ACKs after successful delivery
  - Failed deliveries retried from queue
  
Idempotency:
  - Each notification has unique ID
  - Provider checks for duplicates
  - Prevents duplicate SMS/emails
```

---

## Question 5: Design a News Feed (like Twitter)

### Requirements

```
Functional:
  - Post tweets (text, images, videos)
  - Follow/unfollow users
  - View feed (tweets from followed users)
  - Like, retweet, reply
  - Search tweets

Non-Functional:
  - 300M daily active users
  - 600 tweets/second write
  - 600K tweets/second read
  - Feed latency < 200ms
```

### Feed Generation Strategies

**Pull Model (Fan-out on read)**
```
When user requests feed:
  1. Get list of followed users
  2. Fetch recent tweets from each
  3. Merge and sort by time
  4. Return top N

Pros: Write is simple, no stale data
Cons: Slow read (high latency), heavy on reads
```

**Push Model (Fan-out on write)**
```
When user posts a tweet:
  1. Write tweet to database
  2. Get all followers
  3. Push tweet to each follower's feed cache

Pros: Fast reads (feed pre-computed)
Cons: Heavy writes, celebrity problem (1M followers = 1M pushes)
```

**Hybrid Model (Twitter's approach)**
```
For users with < 10K followers: Push (fan-out on write)
For users with > 10K followers: Pull (fan-out on read)
Merge both at read time

Celebrity tweets are pulled on-demand
Regular tweets are pre-computed
```

### Architecture

```
┌────────┐     ┌──────────┐     ┌──────────────┐
│ Client │────>│   Load   │────>│  Tweet       │
│        │     │ Balancer │     │  Service     │
└────────┘     └──────────┘     └──────┬───────┘
                                       │
         ┌─────────────────────────────┼─────────────────────────────┐
         v                             v                             v
  ┌──────────────┐           ┌──────────────┐           ┌──────────────┐
  │ Tweet Store  │           │ Fan-out      │           │ Feed Cache   │
  │ (Cassandra)  │           │ Service      │           │ (Redis)      │
  └──────────────┘           └──────────────┘           └──────────────┘
                                       │
                                 ┌─────┴─────┐
                                 v           v
                          ┌──────────┐ ┌──────────┐
                          │ User     │ │ Social   │
                          │ Graph DB │ │ Graph    │
                          └──────────┘ └──────────┘
```

### Feed Storage

```
Feed Cache (Redis):
  key: feed:{user_id}
  value: sorted set of tweet_ids (scored by timestamp)
  
  ZADD feed:123 <timestamp> <tweet_id>
  ZREVRANGE feed:123 0 19  (get latest 20)
  
Tweet Store (Cassandra):
  Partition by tweet_id
  Or partition by user_id + time range
```

### Feed Retrieval

```python
def get_feed(user_id, page, page_size):
    # 1. Get feed from cache
    feed_key = f"feed:{user_id}"
    start = page * page_size
    tweet_ids = redis.zrevrange(feed_key, start, start + page_size - 1)
    
    # 2. If cache miss or not enough, fetch from social graph
    if not tweet_ids:
        followed_users = get_followed_users(user_id)
        tweet_ids = fetch_recent_tweets(followed_users, page_size)
    
    # 3. Fetch tweet details
    tweets = batch_fetch_tweets(tweet_ids)
    
    return tweets
```

---

## Question 6: Design a Distributed Cache (like Redis)

### Requirements

```
Functional:
  - GET/SET/DELETE operations
  - TTL (time-to-live) for entries
  - Support different data structures (string, list, set, hash)
  - Pub/Sub messaging

Non-Functional:
  - Sub-millisecond latency
  - 1M+ operations/second
  - High availability (no data loss)
  - Horizontal scaling
```

### Architecture

```
┌────────┐     ┌──────────────┐     ┌──────────────┐
│ Client │────>│  Proxy/Router│────>│ Cache Node 1 │
│        │     │  (Consistent │────>│ Cache Node 2 │
│        │     │   Hashing)   │────>│ Cache Node 3 │
└────────┘     └──────────────┘     └──────────────┘
                                           │
                                    ┌──────┴──────┐
                                    v             v
                              ┌──────────┐ ┌──────────┐
                              │ Replica  │ │ Replica  │
                              │ Node 1a  │ │ Node 2a  │
                              └──────────┘ └──────────┘
```

### Data Partitioning

```
Consistent Hashing:
  Hash ring with virtual nodes
  
  Client request for key "user:123":
    hash("user:123") = 0x7B2F
    Find next node on ring clockwise
    Route to that cache node
    
  Adding node: Only remaps ~1/N keys
  Removing node: Only remaps ~1/N keys
```

### Replication

```
Synchronous (for strong consistency):
  Primary: SET key value
  Primary -> Replica: Replicate
  Replica -> Primary: ACK
  Primary -> Client: OK
  
Asynchronous (for performance):
  Primary: SET key value -> OK to client
  Primary -> Replica: Replicate (async)
```

---

## Common Follow-up Questions

### Performance
- "How would you handle a traffic spike?"
- "What are the bottlenecks in your design?"
- "How would you reduce latency?"

### Reliability
- "What happens if a server fails?"
- "How do you handle network partitions?"
- "What's your disaster recovery plan?"

### Scalability
- "How would this work at 10x the scale?"
- "What if data grows to petabytes?"
- "How would you handle global distribution?"

### Trade-offs
- "Why did you choose this database?"
- "What are the trade-offs of your approach?"
- "How would the design differ with different requirements?"

## Resources

- "System Design Interview" by Alex Xu (Volumes 1 & 2)
- SystemDesignOne.com
- GitHub repo: donnemartin/system-design-primer
- YouTube: Gaurav Sen, Hussein Nasser, ByteByteGo
