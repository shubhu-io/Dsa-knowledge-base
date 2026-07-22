# System Design

## Overview

System Design is the process of defining the architecture, components, modules,
interfaces, and data flow of a system to satisfy specified requirements. It is a
critical part of senior engineering interviews and real-world software development.

High-Level Design (HLD) focuses on the big picture: how services communicate,
where data lives, and how the system scales.

---

## Key Concepts

### Scalability

- **Horizontal scaling**: Add more machines
- **Vertical scaling**: Add more power (CPU, RAM) to existing machines
- Most modern systems favor horizontal scaling

### Availability

- Measured in "nines": 99.9% = 8.76 hours downtime/year
- Achieved through redundancy and failover mechanisms

### Consistency

- Every read returns the most recent write (strong consistency)
- Eventual consistency: reads may return stale data temporarily

### CAP Theorem

A distributed system can guarantee at most two of three:

| Guarantee   | Description                              |
|------------|------------------------------------------|
| Consistency| Every read receives the most recent write |
| Availability| Every request receives a response        |
| Partition Tolerance| System works despite network failures|

In practice, partition tolerance is required, so systems choose between CP and AP.

---

## Common Components

### Load Balancer

Distributes incoming traffic across multiple servers.

```
Client Request
      |
      v
[ Load Balancer ]
   /    |    \
  v     v     v
[S1]  [S2]  [S3]
```

### Cache

Stores frequently accessed data in memory (Redis, Memcached).
Reduces database load and improves response time.

### CDN (Content Delivery Network)

Distributes static content globally (images, CSS, JS).
Examples: Cloudflare, AWS CloudFront, Akamai.

### Message Queue

Enables asynchronous communication between services.
Examples: Kafka, RabbitMQ, SQS.

### Database

- **SQL**: Structured data, ACID transactions (PostgreSQL, MySQL)
- **NoSQL**: Flexible schema, horizontal scaling (MongoDB, DynamoDB)

---

## Design Process (6 Steps)

1. **Understand Requirements**
   - Functional: What should the system do?
   - Non-functional: Scale, latency, availability

2. **Estimation**
   - Users, requests/sec, storage, bandwidth

3. **High-Level Design**
   - Draw the main components and data flow

4. **Detailed Design**
   - API design, database schema, algorithms

5. **Identify bottlenecks and Trade-offs**
   - Single points of failure, scaling limits

6. **Wrap Up**
   - Monitoring, future improvements, alternatives

---

## Typical Web Architecture Diagram

```
                        [ Users ]
                            |
                            v
                    [   CDN   ]
                            |
                            v
                    [ Load Balancer ]
                     /            \
                    v              v
             [ Web Server ]  [ Web Server ]
                    |              |
                    v              v
             [ Application  ]  [ Application  ]
               [  Server   ]    [  Server   ]
                    |              |
                    +------+-------+
                           |
                           v
                    [  Cache (Redis) ]
                           |
                    +------+-------+
                    |              |
                    v              v
             [ Primary DB ]  [ Read Replica ]
                    |
                    v
             [ Message Queue ]
                    |
                    v
             [ Background Workers ]
```

---

## 5 Classic Interview Problems

### 1. URL Shortener (TinyURL)

- Hash-based or base62 encoding
- Database: mapping short URL -> long URL
- Cache hot URLs in Redis
- Rate limiting to prevent abuse

### 2. Chat System (WhatsApp)

- WebSocket for real-time communication
- Message queue for offline delivery
- Database: store messages with user/thread
- Presence service for online status

### 3. News Feed (Twitter/Facebook)

- Fan-out on write vs fan-out on read
- Timeline stored in cache (Redis sorted sets)
- Graph service for follow relationships
- Media service for image/video uploads

### 4. Rate Limiter

- Token bucket algorithm
- Sliding window counter
- Distributed: use Redis for centralized counting
- Return 429 Too Many Requests

### 5. Key-Value Store (DynamoDB-like)

- Consistent hashing for partitioning
- Replication across nodes
- Vector clocks for conflict resolution
- Gossip protocol for membership

---

## Common Interview Questions

1. How would you design a URL shortener like TinyURL?
2. Explain the trade-offs between SQL and NoSQL for a given use case
3. How do you handle a sudden traffic spike?
4. What is consistent hashing and why is it useful?
5. How would you design a chat application that supports millions of users?

---

## See Also

- [[Low-Level-Design]]
- [[Databases]]
- [[Networking]]
- [[Operating-System]]
- [[Competitive-Programming]]

---

> Full content: [11-System-Design](../11-System-Design/)
