# Real-World Systems

How popular technology services are designed and scaled.

## System Architecture Overview

```
                ┌─────────────────────────────────────┐
                │            CDN (CloudFront)          │
                │    Static assets, edge caching       │
                └───────────────┬─────────────────────┘
                                │
                ┌───────────────┴─────────────────────┐
                │         API Gateway / Load Balancer  │
                │    Routing, rate limiting, auth      │
                └───────────────┬─────────────────────┘
                                │
         ┌──────────────────────┼──────────────────────┐
         v                      v                      v
   ┌──────────┐          ┌──────────┐          ┌──────────┐
   │ Service 1│          │ Service 2│          │ Service 3│
   │ (Users)  │          │ (Posts)  │          │ (Feed)   │
   └────┬─────┘          └────┬─────┘          └────┬─────┘
        │                     │                     │
   ┌────┴─────┐          ┌────┴─────┐          ┌────┴─────┐
   │ Primary DB│          │ Cache    │          │ Message  │
   │ + Replicas│          │ (Redis)  │          │ Queue    │
   └──────────┘          └──────────┘          └──────────┘
```

---

## 1. URL Shortener (Bit.ly)

### Scale

```
100M new URLs/month
10B redirects/month
Read:Write ratio = 100:1
```

### Architecture

```
┌────────┐    ┌────────────┐    ┌──────────┐    ┌──────────┐
│ Client │───>│  API Server│───>│ Key Gen  │───>│ Database │
│        │    │            │    │ Service  │    │ (MySQL)  │
└────────┘    └────────────┘    └──────────┘    └──────────┘
                     │
               ┌─────┴─────┐
               v           v
          ┌────────┐  ┌────────┐
          │ Redis  │  │Analytics│
          │ Cache  │  │ Service │
          └────────┘  └──────────┘
```

### Key Design Decisions

| Decision | Choice | Reasoning |
|----------|--------|-----------|
| ID Generation | Base62 encoding | Compact, URL-safe |
| Storage | MySQL + Redis cache | Read-heavy workload |
| Caching | Redis with TTL | 80% cache hit rate |
| Analytics | Async via Kafka | Don't block redirects |

### URL Generation Flow

```
1. Client sends long URL
2. Check Redis for existing mapping
3. If miss: Generate unique ID (Base62 counter)
4. Store mapping in MySQL
5. Cache in Redis with TTL
6. Return short URL

Redirect Flow:
1. Client requests short URL
2. Check Redis cache
3. If hit: 301 redirect to long URL
4. If miss: Query MySQL, cache, redirect
```

---

## 2. Social Media Feed (Twitter/X)

### Scale

```
300M daily active users
600 tweets/second write
600K timeline reads/second
Average follower count: 200
```

### Architecture

```
┌──────────┐     ┌──────────┐     ┌───────────────┐
│  Tweet   │────>│ Fan-out  │────>│  Feed Cache   │
│  Service │     │ Service  │     │  (Redis)      │
└──────────┘     └──────────┘     └───────┬───────┘
                                          │
┌──────────┐     ┌──────────┐     ┌───────┴───────┐
│  Client  │────>│   Feed   │────>│  Social Graph │
│          │     │ Service  │     │  (Graph DB)   │
└──────────┘     └──────────┘     └───────────────┘
                                          │
                                   ┌──────┴──────┐
                                   v             v
                             ┌──────────┐  ┌──────────┐
                             │Tweet DB  │  │User DB   │
                             │(Cassandra)│  │(MySQL)   │
                             └──────────┘  └──────────┘
```

### Feed Generation (Hybrid Model)

```
Fan-out on Write (for regular users):
  User posts tweet -> push to all followers' feed cache
  
Fan-out on Read (for celebrities):
  Celebrity posts tweet -> stored in tweet DB only
  When follower requests feed: pull celebrity tweets on-demand

Celebrity threshold: > 10,000 followers
```

### Database Choices

| Component | Database | Reason |
|-----------|----------|--------|
| Tweets | Cassandra | Write-heavy, time-series |
| User profiles | MySQL | Structured, relational |
| Social graph | Neo4j / custom | Relationship queries |
| Feed cache | Redis | Fast reads, sorted sets |
| Search | Elasticsearch | Full-text search |

---

## 3. Chat System (WhatsApp)

### Scale

```
2B monthly active users
100B messages/day
Peak: 70M messages/second
```

### Architecture

```
┌──────────┐     ┌──────────────┐     ┌──────────────┐
│  Client  │◄───►│  WebSocket   │◄───►│  Chat Server │
│  (Phone) │     │  Gateway     │     │              │
└──────────┘     └──────────────┘     └──────┬───────┘
                                             │
              ┌──────────────────────────────┼──────────────────┐
              v                              v                  v
       ┌──────────┐                ┌──────────────┐    ┌────────────┐
       │  Redis   │                │  Message DB  │    │  Push      │
       │ (Pub/Sub)│                │ (Cassandra)  │    │  Service   │
       └──────────┘                └──────────────┘    └────────────┘
```

### Message Flow

```
Alice sends message to Bob:

1. Alice's client -> WebSocket -> Chat Server A
2. Chat Server A:
   a. Validate message
   b. Store in Cassandra (partitioned by conversation)
   c. Publish to Redis Pub/Sub channel for Bob
3. Chat Server B (connected to Bob):
   a. Receives from Redis Pub/Sub
   b. Pushes to Bob's WebSocket connection
4. Bob's client receives message
5. Bob sends ACK -> Chat Server B -> Chat Server A -> Alice sees "delivered"
```

### Message Ordering

```
Causal Ordering:
  - Each message has monotonic timestamp
  - Within a conversation: sequence numbers
  - Between conversations: no ordering guarantee
  
Implementation:
  - Lamport timestamps or hybrid logical clocks
  - Client-side sequencing for display
```

### End-to-End Encryption

```
Signal Protocol (used by WhatsApp):

1. Key Generation:
   Each user generates identity key pair
   Each device generates signed pre-key pair
   
2. Key Exchange:
   Alice requests Bob's public keys from server
   Alice creates shared secret using X3DH
   
3. Message Encryption:
   Alice encrypts with shared secret
   Server stores encrypted message
   Bob decrypts with his private key
   
Server never sees plaintext
```

---

## 4. Video Streaming (YouTube/Netflix)

### Scale

```
YouTube: 500 hours of video uploaded per minute
Netflix: 15% of global internet bandwidth
1B+ hours of video watched daily
```

### Architecture

```
┌──────────┐     ┌──────────────┐     ┌──────────────┐
│  Client  │────>│   CDN Edge   │────>│  Origin      │
│          │     │   Server     │     │  Storage     │
└──────────┘     └──────────────┘     └──────────────┘
                                            │
┌──────────┐     ┌──────────────┐     ┌─────┴──────┐
│  Client  │────>│  API Server  │────>│  Video     │
│  (Browse)│     │              │     │  Metadata  │
└──────────┘     └──────────────┘     │  DB        │
                                      └────────────┘
```

### Video Processing Pipeline

```
Upload -> Transcode -> Distribute -> Stream

1. Upload:
   Client uploads raw video to object storage (S3)
   Upload service validates and stores

2. Transcode:
   Message queue triggers transcoding workers
   Multiple formats: 240p, 360p, 480p, 720p, 1080p, 4K
   Multiple codecs: H.264, H.265, VP9, AV1
   Generate thumbnails and preview frames

3. Distribute:
   Push transcoded files to CDN edge locations
   Store originals in cold storage (S3 Glacier)

4. Stream:
   Client requests video manifest (HLS/DASH)
   Manifest lists available qualities and segments
   Client downloads segments from nearest CDN edge
   Adaptive bitrate: quality adjusts to bandwidth
```

### Adaptive Bitrate Streaming

```
HLS (HTTP Live Streaming):

Master Playlist:
  #EXTM3U
  #EXT-X-STREAM-INF:BANDWIDTH=800000,RESOLUTION=640x360
  360p.m3u8
  #EXT-X-STREAM-INF:BANDWIDTH=2000000,RESOLUTION=1280x720
  720p.m3u8

Segment Playlist (360p):
  #EXTM3U
  #EXT-X-TARGETDURATION:10
  #EXTINF:10.0
  segment001.ts
  #EXTINF:10.0
  segment002.ts

Player logic:
  - Monitor buffer level and bandwidth
  - Switch to higher quality when bandwidth allows
  - Switch to lower quality when bandwidth drops
```

### CDN Strategy

```
Edge Locations: 200+ globally
  - Store popular content (80/20 rule)
  - 90%+ cache hit rate
  
Cache Hierarchy:
  Edge: Closest to user (< 50ms)
  Regional: Regional data center (< 100ms)
  Origin: Source storage (US regions)

Cache Invalidation:
  - Content-addressed URLs (hash in filename)
  - Versioned URLs for updates
  - TTL for temporary content
```

---

## 5. E-Commerce (Amazon)

### Scale

```
300M+ active users
100K purchases per minute during peak
1 billion+ products
```

### Architecture

```
┌──────────┐     ┌──────────────┐     ┌──────────────┐
│  Client  │────>│  API Gateway │────>│  Product     │
│          │     │              │     │  Service     │
└──────────┘     └──────┬───────┘     └──────────────┘
                        │
         ┌──────────────┼──────────────┐
         v              v              v
   ┌──────────┐  ┌──────────┐  ┌──────────┐
   │  Cart    │  │  Order   │  │ Payment  │
   │  Service │  │  Service │  │ Service  │
   └────┬─────┘  └────┬─────┘  └────┬─────┘
        │             │             │
   ┌────┴─────┐  ┌────┴─────┐  ┌────┴─────┐
   │  Redis   │  │  Order   │  │ Payment  │
   │  Cache   │  │  DB      │  │ Gateway  │
   └──────────┘  └──────────┘  └──────────┘
```

### Key Services

| Service | Responsibility | Database |
|---------|---------------|----------|
| Product | Catalog, search, details | Elasticsearch + MySQL |
| Cart | Shopping cart management | Redis |
| Order | Order processing, history | MySQL (sharded) |
| Payment | Payment processing | PostgreSQL |
| Inventory | Stock management | PostgreSQL |
| Recommendation | Product suggestions | ML pipeline + Redis |
| Shipping | Delivery tracking | MySQL |

### Cart Design

```
Guest Cart:
  - Stored in browser localStorage
  - On login: merge with user cart

User Cart:
  - Stored in Redis
  - Key: cart:{user_id}
  - Value: Hash of {product_id: quantity}
  - TTL: 30 days

Cart Persistence:
  - Redis for fast access
  - Periodic sync to MySQL for durability
```

### Flash Sale Handling

```
Problem: 100K users hit "buy" simultaneously for limited item

Solution:
  1. Queue-based processing
     - User clicks "buy" -> enters queue
     - Queue processes sequentially
     - Return position in queue to user

  2. Inventory reservation
     - Reserve stock for 10 minutes
     - If not paid: release reservation
     - Deduct stock only on payment

  3. Rate limiting
     - Limit checkout attempts per user
     - Prevent bot/scalper abuse

  4. Read replicas for product page
     - High read throughput
     - Eventual consistency OK for product info
```

---

## 6. Search Engine (Google)

### Scale

```
100B+ pages indexed
100K+ queries per second
Response time: < 200ms
```

### Architecture

```
┌──────────┐     ┌──────────────┐     ┌──────────────┐
│  Client  │────>│   DNS +      │────>│   Web        │
│          │     │   LB         │     │   Server     │
└──────────┘     └──────────────┘     └──────┬───────┘
                                             │
              ┌──────────────────────────────┼──────────────────┐
              v                              v                  v
       ┌──────────┐                ┌──────────────┐    ┌────────────┐
       │  Index   │                │  Query       │    │  Ranking   │
       │  Service │                │  Parser      │    │  Service   │
       └────┬─────┘                └──────────────┘    └────────────┘
            │
       ┌────┴─────┐
       v          v
  ┌──────────┐ ┌──────────┐
  │ Web Crawler│ │ Index DB │
  │ (Distributed)│ │ (BigTable)│
  └──────────┘ └──────────┘
```

### Search Pipeline

```
User Query: "best restaurants in NYC"

1. Query Parsing:
   - Tokenize: ["best", "restaurants", "in", "NYC"]
   - Identify intent: local search
   - Spell correction if needed

2. Query Expansion:
   - Synonyms: "restaurants" -> "dining", "eateries"
   - Location: "NYC" -> "New York City"

3. Index Lookup:
   - Inverted index: term -> document list
   - Retrieve candidate documents

4. Ranking:
   - PageRank: Link analysis
   - Relevance: TF-IDF, BM25
   - Freshness: Publication date
   - User signals: Click-through rate

5. Personalization:
   - Location-based results
   - Search history
   - User preferences

6. Results:
   - Top 10 results
   - Featured snippets
   - Knowledge panel
   - Local pack (map results)
```

### Inverted Index

```
Document: "The cat sat on the mat"

Inverted Index:
  "the"   -> [doc1, doc3, doc7]
  "cat"   -> [doc1, doc5]
  "sat"   -> [doc1, doc2]
  "on"    -> [doc1, doc4, doc6]
  "mat"   -> [doc1]

Query: "cat mat"
  Intersect(doc1, doc5) AND (doc1) = [doc1]
```

### Web Crawler

```
Architecture:
  - Distributed crawlers (1000s of machines)
  - URL frontier (priority queue)
  - Politeness (respect robots.txt)
  - Deduplication (URL and content)
  
Crawl Loop:
  1. Pick URL from frontier
  2. Fetch page
  3. Parse HTML, extract links
  4. Add new URLs to frontier
  5. Store page content
  6. Update index
```

---

## Common Patterns Across Systems

| Pattern | URL Shortener | Social Feed | Chat | Video | E-commerce |
|---------|--------------|-------------|------|-------|-----------|
| Caching | Redis | Redis | Redis | CDN | Redis |
| Database | MySQL | Cassandra | Cassandra | S3 + MySQL | MySQL (sharded) |
| Message Queue | Optional | Kafka | Redis Pub/Sub | SQS | SQS |
| CDN | No | Yes | No | Yes | Yes |
| Search | No | Elasticsearch | No | No | Elasticsearch |

## Key Takeaways

1. **Start simple, scale later** — Don't over-engineer from day one
2. **Use the right tool for the job** — SQL for transactions, NoSQL for scale
3. **Cache aggressively** — Most reads can be cached
4. **Design for failure** — Redundancy, replication, graceful degradation
5. **Monitor everything** — You can't improve what you can't measure
6. **Think about data growth** — Plan for 10x current scale

## Resources

- Company engineering blogs: Netflix, Uber, Airbnb, Stripe, Discord
- "Designing Data-Intensive Applications" by Martin Kleppmann
- "System Design Interview" by Alex Xu
- High Scalability blog (highscalability.com)
- Paper: "The Google File System", "MapReduce", "BigTable"
