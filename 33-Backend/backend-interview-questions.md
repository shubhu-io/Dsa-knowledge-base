# Backend Interview Questions

## Table of Contents

1. [HTTP & REST Questions](#http--rest-questions)
2. [Database Questions](#database-questions)
3. [Authentication Questions](#authentication-questions)
4. [Architecture Questions](#architecture-questions)
5. [Performance Questions](#performance-questions)
6. [Security Questions](#security-questions)
7. [System Design Questions](#system-design-questions)
8. [Coding Challenges](#coding-challenges)

---

## HTTP & REST Questions

### Q1: What is the difference between HTTP/1.1, HTTP/2, and HTTP/3?

**Answer:**
| Feature | HTTP/1.1 | HTTP/2 | HTTP/3 |
|---------|----------|--------|--------|
| Multiplexing | No | Yes | Yes |
| Header Compression | No | HPACK | QPACK |
| Protocol | TCP | TCP + TLS | QUIC (UDP) |
| Server Push | No | Yes | Yes |
| Connection | New per request | Single connection | Single connection |

### Q2: Explain the difference between cookies, localStorage, and sessionStorage.

**Answer:**
| Feature | Cookies | localStorage | sessionStorage |
|---------|---------|--------------|----------------|
| Storage | 4KB | 5-10MB | 5-10MB |
| Expiry | Configurable | Never | Session |
| Sent to server | Yes | No | No |
| Security | HttpOnly, Secure | None | None |
| Scope | Domain | Origin | Origin + Tab |

### Q3: What is CORS and how does it work?

**Answer:**
CORS (Cross-Origin Resource Sharing) is a security mechanism that allows or restricts resources from different origins.

```javascript
// Express CORS configuration
const cors = require('cors');

app.use(cors({
    origin: ['https://example.com', 'https://app.example.com'],
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    allowedHeaders: ['Content-Type', 'Authorization'],
    credentials: true,
    maxAge: 86400
}));

// Preflight request flow:
// 1. Browser sends OPTIONS request
// 2. Server responds with allowed origins/methods
// 3. Browser sends actual request if allowed
```

### Q4: What are HTTP caching mechanisms?

**Answer:**
```javascript
// Cache-Control headers
res.set({
    'Cache-Control': 'public, max-age=3600',        // Cache for 1 hour
    'Cache-Control': 'private, no-cache',            // User-specific, revalidate
    'Cache-Control': 'no-store',                     // Never cache
    'ETag': '"12345"',                               // Conditional requests
    'Last-Modified': 'Mon, 01 Jan 2024 00:00:00 GMT'
});

// Validation flow:
// 1. Client sends If-None-Match with ETag
// 2. Server checks if resource changed
// 3. If not changed, returns 304 Not Modified
```

### Q5: What is HTTP/2 Server Push?

**Answer:**
Server Push allows servers to proactively send resources to clients before they request them.

```javascript
// Express with HTTP/2
const http2 = require('http2');
const server = http2.createSecureServer({
    key: fs.readFileSync('server.key'),
    cert: fs.readFileSync('server.cert')
});

server.on('stream', (stream, headers) => {
    if (headers[':path'] === '/') {
        // Push CSS file before client requests it
        stream.pushStream({ ':path': '/styles.css' }, (err, pushStream) => {
            pushStream.respond({ ':status': 200 });
            pushStream.end(fs.readFileSync('styles.css'));
        });
    }
});
```

---

## Database Questions

### Q1: What is database normalization?

**Answer:**
Normalization organizes data to reduce redundancy and improve integrity.

```
1NF: Atomic values, no repeating groups
    user_id | name | orders
    1       | John | 1,2,3  ❌
    1       | John | 1      ✅
    1       | John | 2      ✅

2NF: 1NF + no partial dependencies
    order_id | user_id | user_name | product
    1        | 1       | John      | A      ❌
    1        | 1       | A
    1        | 1       | John

3NF: 2NF + no transitive dependencies
    user_id | user_name | dept_id | dept_name
    1       | John      | 10      | Sales    ❌
    1       | John      | 10
    10      | Sales
```

### Q2: Explain SQL vs NoSQL trade-offs.

**Answer:**
| Aspect | SQL | NoSQL |
|--------|-----|-------|
| Schema | Fixed, predefined | Dynamic, flexible |
| Relationships | Strong (JOINs) | Weak (denormalized) |
| Transactions | ACID | Eventual consistency |
| Scaling | Vertical | Horizontal |
| Query Language | SQL | Varies |
| Best for | Complex queries, relationships | Big data, rapid iteration |

### Q3: What are database indexes and when to use them?

**Answer:**
Indexes improve query performance by creating a data structure for faster lookups.

```sql
-- Create index
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_orders_user_date ON orders(user_id, created_at);

-- Composite index (order matters)
CREATE INDEX idx_composite ON table(col1, col2, col3);
-- Good for: WHERE col1 = ? AND col2 = ?
-- Bad for: WHERE col2 = ? AND col3 = ?

-- Partial index
CREATE INDEX idx_active_users ON users(email) WHERE active = true;

-- When to index:
-- ✅ Primary keys (automatic)
-- ✅ Foreign keys
-- ✅ Columns in WHERE clauses
-- ✅ Columns in JOIN conditions
-- ✅ Columns in ORDER BY

-- When NOT to index:
-- ❌ Small tables
-- ❌ Columns with low selectivity
-- ❌ Frequently updated columns
-- ❌ Columns with many NULLs
```

### Q4: What is a database transaction and isolation levels?

**Answer:**
A transaction is a sequence of operations performed as a single logical unit of work.

```sql
-- ACID properties
-- Atomicity: All or nothing
-- Consistency: Valid state transitions
-- Isolation: Concurrent transactions don't interfere
-- Durability: Committed data persists

-- Isolation levels
BEGIN TRANSACTION;
    -- READ UNCOMMITTED: Dirty reads allowed
    -- READ COMMITTED: No dirty reads
    -- REPEATABLE READ: No dirty/non-repeatable reads
    -- SERIALIZABLE: Full isolation
COMMIT;
```

### Q5: How do you optimize slow queries?

**Answer:**
```sql
-- 1. Analyze query plan
EXPLAIN ANALYZE SELECT * FROM orders WHERE user_id = 123;

-- 2. Add appropriate index
CREATE INDEX idx_orders_user ON orders(user_id);

-- 3. Avoid SELECT *
SELECT id, name, email FROM users WHERE active = true;

-- 4. Use LIMIT for large result sets
SELECT * FROM logs ORDER BY created_at DESC LIMIT 100;

-- 5. Optimize JOINs
SELECT u.name, o.total
FROM users u
INNER JOIN orders o ON u.id = o.user_id
WHERE o.status = 'completed';

-- 6. Use EXPLAIN to check for:
-- Full table scans (bad)
-- Index usage (good)
-- Correct join order
```

---

## Authentication Questions

### Q1: What is the difference between authentication and authorization?

**Answer:**
- **Authentication**: Verifying who you are (identity)
- **Authorization**: Determining what you can do (permissions)

```javascript
// Authentication: "Are you John?"
const user = await authenticate(email, password);

// Authorization: "Can John access this?"
if (user.role !== 'admin') {
    throw new ForbiddenError('Admin access required');
}
```

### Q2: Explain JWT tokens and their security considerations.

**Answer:**
```javascript
// JWT Structure: Header.Payload.Signature

// Header
{ "alg": "HS256", "typ": "JWT" }

// Payload
{
    "sub": "123",
    "name": "John",
    "exp": 1705312200  // Expiration time
}

// Signature
HMACSHA256(
    base64UrlEncode(header) + "." + base64UrlEncode(payload),
    secret
)

// Security considerations:
// ✅ Use HTTPS only
// ✅ Set short expiration (15 min for access tokens)
// ✅ Use refresh tokens for long sessions
// ✅ Store tokens securely (httpOnly cookies)
// ❌ Never store in localStorage (XSS vulnerable)
// ❌ Don't put sensitive data in payload (not encrypted)
```

### Q3: What is OAuth 2.0 and how does it work?

**Answer:**
OAuth 2.0 is an authorization framework for delegated access.

```
Authorization Code Flow:
1. Client redirects to authorization server
2. User logs in and grants consent
3. Auth server returns authorization code
4. Client exchanges code for tokens
5. Client uses access token to call API

Implementation:
// Step 1: Redirect to auth server
res.redirect('https://auth.example.com/authorize?' + 
    'client_id=xxx&redirect_uri=xxx&response_type=code&scope=openid');

// Step 2: Exchange code for token
const response = await axios.post('https://auth.example.com/token', {
    grant_type: 'authorization_code',
    code: authorizationCode,
    client_id: 'xxx',
    client_secret: 'xxx',
    redirect_uri: 'xxx'
});
```

### Q4: What is session-based vs token-based authentication?

**Answer:**
| Aspect | Session-based | Token-based |
|--------|---------------|-------------|
| Storage | Server (session store) | Client (cookie/header) |
| Scalability | Harder (shared state) | Easier (stateless) |
| Security | CSRF vulnerable | XSS vulnerable |
| Revocation | Easy (delete session) | Hard (blacklist needed) |
| Mobile support | Less ideal | Better |

### Q5: How do you implement role-based access control (RBAC)?

**Answer:**
```javascript
// Define roles and permissions
const roles = {
    admin: ['users:read', 'users:write', 'users:delete', 'orders:read', 'orders:write'],
    manager: ['users:read', 'orders:read', 'orders:write'],
    user: ['orders:read']
};

// Middleware
function authorize(resource, action) {
    return (req, res, next) => {
        const userRoles = req.user.roles;
        const requiredPermission = `${resource}:${action}`;

        const hasPermission = userRoles.some(role =>
            roles[role]?.includes(requiredPermission)
        );

        if (!hasPermission) {
            return res.status(403).json({
                error: { code: 'FORBIDDEN', message: 'Insufficient permissions' }
            });
        }

        next();
    };
}

// Usage
app.get('/api/users', authorize('users', 'read'), getUsers);
app.delete('/api/users/:id', authorize('users', 'delete'), deleteUser);
```

---

## Architecture Questions

### Q1: Explain microservices vs monolith.

**Answer:**
| Aspect | Monolith | Microservices |
|--------|----------|---------------|
| Deployment | Single unit | Independent |
| Scaling | Whole application | Per service |
| Technology | Single stack | Polyglot |
| Team structure | Centralized | Decentralized |
| Complexity | Lower initially | Higher initially |
| Data management | Shared database | Database per service |

### Q2: What is event-driven architecture?

**Answer:**
Event-driven architecture uses events to communicate between decoupled services.

```javascript
// Event producer
class OrderService {
    async createOrder(orderData) {
        const order = await this.db.orders.create(orderData);
        
        // Publish event
        await this.eventBus.publish('order.created', {
            orderId: order.id,
            userId: order.userId,
            items: order.items
        });
        
        return order;
    }
}

// Event consumer
class NotificationService {
    async handleOrderCreated(event) {
        await this.sendEmail(event.userId, {
            subject: 'Order Confirmed',
            body: `Your order ${event.orderId} has been confirmed`
        });
    }
}

// Register handler
eventBus.subscribe('order.created', notificationService.handleOrderCreated);
```

### Q3: What is CQRS?

**Answer:**
CQRS (Command Query Responsibility Segregation) separates read and write operations.

```javascript
// Command side (writes)
class OrderCommandHandler {
    async createOrder(command) {
        const order = new Order(command.userId, command.items);
        await this.repository.save(order);
        await this.eventStore.append('OrderCreated', order);
    }
}

// Query side (reads)
class OrderQueryService {
    async getOrder(orderId) {
        // Optimized read model
        return this.readModel.findById(orderId);
    }
    
    async getUserOrders(userId) {
        return this.readModel.findByUserId(userId);
    }
}
```

### Q4: What is the Saga pattern?

**Answer:**
The Saga pattern manages distributed transactions through a sequence of local transactions.

```javascript
// Choreography-based Saga
class OrderSaga {
    async handleOrderCreated(event) {
        // Step 1: Reserve inventory
        await this.inventoryService.reserve(event.items);
        
        // Step 2: Process payment
        await this.paymentService.charge(event.userId, event.total);
        
        // Step 3: Confirm order
        await this.orderService.confirm(event.orderId);
    }
    
    async handlePaymentFailed(event) {
        // Compensating transaction
        await this.inventoryService.release(event.items);
        await this.orderService.cancel(event.orderId);
    }
}

// Orchestration-based Saga
class OrderSagaOrchestrator {
    async execute(orderData) {
        try {
            await this.step1_ReserveInventory(orderData);
            await this.step2_ProcessPayment(orderData);
            await this.step3_ConfirmOrder(orderData);
        } catch (error) {
            await this.compensate(orderData);
        }
    }
}
```

### Q5: How do you handle data consistency in microservices?

**Answer:**
Strategies:
1. **Saga Pattern**: Coordinated local transactions
2. **Event Sourcing**: Store events, replay state
3. **CQRS**: Separate read/write models
4. **Outbox Pattern**: Reliable event publishing
5. **Two-Phase Commit**: Distributed transactions (avoid if possible)

```javascript
// Outbox Pattern
async function createOrder(orderData) {
    const trx = await db.transaction();
    
    try {
        // Save order
        await trx('orders').insert(orderData);
        
        // Save event in outbox (same transaction)
        await trx('outbox').insert({
            aggregate_type: 'order',
            aggregate_id: orderData.id,
            event_type: 'OrderCreated',
            payload: JSON.stringify(orderData)
        });
        
        await trx.commit();
    } catch (error) {
        await trx.rollback();
        throw error;
    }
}

// Separate process publishes events
async function publishOutboxEvents() {
    const events = await db('outbox').where('published', false);
    
    for (const event of events) {
        await eventBus.publish(event.event_type, event.payload);
        await db('outbox')
            .where('id', event.id)
            .update({ published: true });
    }
}
```

---

## Performance Questions

### Q1: What are common performance bottlenecks?

**Answer:**
1. **Database**: N+1 queries, missing indexes, lock contention
2. **Network**: Latency, bandwidth, DNS resolution
3. **CPU**: Inefficient algorithms, serialization
4. **Memory**: Leaks, excessive garbage collection
5. **I/O**: Disk access, network calls

### Q2: How do you implement caching?

**Answer:**
```javascript
// Multi-level caching
class CacheService {
    constructor(redis, localCache) {
        this.redis = redis;
        this.localCache = localCache;
    }
    
    async get(key) {
        // Level 1: Local cache (in-memory)
        const localValue = this.localCache.get(key);
        if (localValue) return localValue;
        
        // Level 2: Redis cache
        const redisValue = await this.redis.get(key);
        if (redisValue) {
            this.localCache.set(key, redisValue, 60); // 1 min local
            return JSON.parse(redisValue);
        }
        
        return null;
    }
    
    async set(key, value, ttl = 3600) {
        this.localCache.set(key, value, 60); // 1 min local
        await this.redis.setEx(key, ttl, JSON.stringify(value));
    }
    
    async invalidate(key) {
        this.localCache.del(key);
        await this.redis.del(key);
    }
}
```

### Q3: What is connection pooling?

**Answer:**
Connection pooling maintains a cache of database connections for reuse.

```javascript
// PostgreSQL connection pool
const { Pool } = require('pg');

const pool = new Pool({
    user: 'user',
    host: 'localhost',
    database: 'mydb',
    password: 'password',
    max: 20,              // Maximum pool size
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: 2000,
});

// Benefits:
// - Reduces connection overhead
// - Limits concurrent connections
// - Improves performance
// - Prevents connection exhaustion
```

### Q4: How do you handle database scaling?

**Answer:**
Strategies:
1. **Read replicas**: Distribute read queries
2. **Sharding**: Partition data across databases
3. **Caching**: Reduce database load
4. **Connection pooling**: Optimize connections
5. **Query optimization**: Improve query performance

```javascript
// Read/write splitting
class Database {
    constructor() {
        this.writeDb = createConnection('primary');
        this.readDb = createConnection('replica');
    }
    
    async query(sql, params, options = {}) {
        const db = options.write ? this.writeDb : this.readDb;
        return db.query(sql, params);
    }
}
```

### Q5: What is database sharding?

**Answer:**
Sharding splits data across multiple database instances.

```javascript
// Shard selection
function getShard(userId, totalShards) {
    return userId % totalShards;
}

// Usage
const shard = getShard(userId, 4);
const db = shardConnections[shard];
const user = await db.query('SELECT * FROM users WHERE id = ?', [userId]);

// Challenges:
// - Cross-shard queries
// - Data migration
// - Consistent hashing
// - Shard key selection
```

---

## Security Questions

### Q1: What are common web security vulnerabilities?

**Answer:**
| Vulnerability | Description | Prevention |
|---------------|-------------|------------|
| SQL Injection | Malicious SQL in input | Parameterized queries |
| XSS | Malicious scripts in output | Input sanitization, CSP |
| CSRF | Unauthorized commands | CSRF tokens |
| Path Traversal | Access unauthorized files | Input validation |
| Authentication bypass | Skip auth checks | Proper middleware |

### Q2: How do you prevent SQL injection?

**Answer:**
```javascript
// ❌ Vulnerable
const query = `SELECT * FROM users WHERE id = ${userId}`;

// ✅ Safe: Parameterized queries
const query = 'SELECT * FROM users WHERE id = $1';
const result = await db.query(query, [userId]);

// ✅ Safe: ORM
const user = await User.findById(userId);

// ✅ Safe: Input validation
const validatedId = parseInt(userId, 10);
if (isNaN(validatedId)) {
    throw new Error('Invalid ID');
}
```

### Q3: How do you implement rate limiting?

**Answer:**
```javascript
// Sliding window rate limiter
class RateLimiter {
    constructor(redis) {
        this.redis = redis;
    }
    
    async isAllowed(key, limit, windowMs) {
        const now = Date.now();
        const windowStart = now - windowMs;
        
        // Remove old entries
        await this.redis.zremrangebyscore(key, 0, windowStart);
        
        // Count requests
        const count = await this.redis.zcard(key);
        
        if (count >= limit) {
            return { allowed: false, retryAfter: windowMs };
        }
        
        // Add current request
        await this.redis.zadd(key, now, now.toString());
        await this.redis.expire(key, Math.ceil(windowMs / 1000));
        
        return { allowed: true, remaining: limit - count - 1 };
    }
}
```

### Q4: What is Content Security Policy (CSP)?

**Answer:**
CSP is a security layer that prevents XSS and data injection attacks.

```javascript
// Express CSP
const helmet = require('helmet');

app.use(helmet.contentSecurityPolicy({
    directives: {
        defaultSrc: ["'self'"],
        scriptSrc: ["'self'", "'unsafe-inline'"],
        styleSrc: ["'self'", "'unsafe-inline'"],
        imgSrc: ["'self'", "data:", "https:"],
        connectSrc: ["'self'", "https://api.example.com"],
        fontSrc: ["'self'", "https://fonts.googleapis.com"],
        objectSrc: ["'none'"],
        mediaSrc: ["'none'"],
        frameSrc: ["'none'"]
    }
}));
```

### Q5: How do you handle sensitive data?

**Answer:**
```javascript
// Environment variables
process.env.DATABASE_URL
process.env.JWT_SECRET
process.env.API_KEY

// Encryption at rest
const crypto = require('crypto');

function encrypt(text, secret) {
    const cipher = crypto.createCipher('aes-256-cbc', secret);
    let encrypted = cipher.update(text, 'utf8', 'hex');
    encrypted += cipher.final('hex');
    return encrypted;
}

// Masking in logs
function maskSensitiveData(data) {
    return {
        ...data,
        email: data.email?.replace(/(.{2}).*(@.*)/, '$1***$2'),
        password: '***',
        creditCard: '****-****-****-' + data.creditCard?.slice(-4)
    };
}
```

---

## System Design Questions

### Q1: Design a URL shortener.

**Answer:**
```
Requirements:
- Shorten URLs
- Redirect to original URL
- Analytics (clicks, referrers)

Components:
1. API Gateway
2. URL Service (CRUD)
3. Redirect Service (fast lookup)
4. Analytics Service
5. Cache (Redis)
6. Database (NoSQL for scale)

Data Model:
{
    shortCode: "abc123",
    originalUrl: "https://example.com/very/long/url",
    userId: "user123",
    createdAt: timestamp,
    clicks: 0
}

Flow:
1. POST /shorten { url: "..." }
2. Generate short code (base62 or hash)
3. Store mapping in database
4. Cache in Redis
5. Return short URL

Redirect:
1. GET /abc123
2. Check Redis cache
3. If miss, query database
4. Redirect (301 or 302)
5. Log analytics asynchronously
```

### Q2: Design a chat application.

**Answer:**
```
Requirements:
- Real-time messaging
- Group chats
- Message history
- Online status

Components:
1. WebSocket Server
2. Message Service
3. User Service
4. Message Queue (Kafka)
5. Database (PostgreSQL + Redis)

Data Model:
User: { id, name, status }
Conversation: { id, type, participants }
Message: { id, conversationId, senderId, content, timestamp }

WebSocket Events:
- connect: User comes online
- message: Send/receive message
- typing: Typing indicator
- disconnect: User goes offline

Flow:
1. User connects via WebSocket
2. Server joins user to rooms
3. Message sent → persisted to DB
4. Message published to Kafka
5. Other servers receive and broadcast
```

### Q3: Design a notification system.

**Answer:**
```
Requirements:
- Multi-channel (email, push, SMS)
- Template management
- Scheduling
- Rate limiting

Components:
1. API Gateway
2. Notification Service
3. Template Engine
4. Channel Workers (Email, Push, SMS)
5. Queue (RabbitMQ)
6. Scheduler

Flow:
1. Request received → Validate
2. Check rate limits
3. Render template
4. Queue for channel worker
5. Worker sends notification
6. Log delivery status

Templates:
{
    "order_confirmed": {
        "email": { "subject": "Order {{orderId}} confirmed", "body": "..." },
        "push": { "title": "Order Confirmed", "body": "..." },
        "sms": { "body": "Order {{orderId}} confirmed" }
    }
}
```

### Q4: Design a real-time analytics dashboard.

**Answer:**
```
Requirements:
- Real-time metrics
- Historical data
- Custom dashboards
- Export capabilities

Architecture:
1. Data Ingestion (Kafka)
2. Stream Processing (Flink/Spark)
3. Time-Series DB (InfluxDB/TimescaleDB)
4. Cache (Redis)
5. WebSocket for real-time updates
6. REST API for queries

Data Flow:
1. Events sent to Kafka
2. Stream processor aggregates
3. Write to time-series DB
4. Update Redis cache
5. Push to WebSocket clients

Queries:
- Last 5 minutes: Real-time from Redis
- Last 24 hours: TimescaleDB
- Historical: Archive storage
```

### Q5: Design a distributed task queue.

**Answer:**
```
Requirements:
- Task scheduling
- Retry logic
- Priority queues
- Monitoring

Components:
1. Producer API
2. Queue (Redis/RabbitMQ)
3. Worker Pool
4. Result Store
5. Monitoring Dashboard

Features:
- Priority queues
- Delayed tasks
- Retries with backoff
- Dead letter queue
- Rate limiting
- Concurrency control

Data Model:
{
    taskId: "uuid",
    type: "email",
    payload: { ... },
    priority: 1,
    attempts: 0,
    maxAttempts: 3,
    status: "pending",
    createdAt: timestamp,
    scheduledAt: timestamp
}

Worker Logic:
1. Poll queue for tasks
2. Acquire lock
3. Execute task
4. Update status
5. Release lock
6. Handle failures (retry or dead letter)
```

---

## Coding Challenges

### Challenge 1: Implement a rate limiter

```javascript
class RateLimiter {
    constructor(maxRequests, windowMs) {
        this.maxRequests = maxRequests;
        this.windowMs = windowMs;
        this.requests = new Map();
    }

    isAllowed(key) {
        const now = Date.now();
        const windowStart = now - this.windowMs;

        // Get or create request history
        if (!this.requests.has(key)) {
            this.requests.set(key, []);
        }

        const timestamps = this.requests.get(key);

        // Remove old timestamps
        while (timestamps.length > 0 && timestamps[0] <= windowStart) {
            timestamps.shift();
        }

        // Check limit
        if (timestamps.length >= this.maxRequests) {
            return { allowed: false, retryAfter: timestamps[0] + this.windowMs - now };
        }

        // Add current request
        timestamps.push(now);
        return { allowed: true, remaining: this.maxRequests - timestamps.length };
    }
}

// Usage
const limiter = new RateLimiter(100, 60000); // 100 requests per minute
console.log(limiter.isAllowed('user123'));
```

### Challenge 2: Implement LRU cache

```javascript
class LRUCache {
    constructor(capacity) {
        this.capacity = capacity;
        this.cache = new Map();
    }

    get(key) {
        if (!this.cache.has(key)) {
            return -1;
        }

        // Move to end (most recently used)
        const value = this.cache.get(key);
        this.cache.delete(key);
        this.cache.set(key, value);
        return value;
    }

    put(key, value) {
        if (this.cache.has(key)) {
            this.cache.delete(key);
        } else if (this.cache.size >= this.capacity) {
            // Delete oldest (first item)
            const firstKey = this.cache.keys().next().value;
            this.cache.delete(firstKey);
        }

        this.cache.set(key, value);
    }

    size() {
        return this.cache.size;
    }
}

// Usage
const cache = new LRUCache(2);
cache.put(1, 1);
cache.put(2, 2);
console.log(cache.get(1)); // 1
cache.put(3, 3); // Evicts key 2
console.log(cache.get(2)); // -1
```

### Challenge 3: Implement a simple event emitter

```javascript
class EventEmitter {
    constructor() {
        this.events = new Map();
    }

    on(event, callback) {
        if (!this.events.has(event)) {
            this.events.set(event, []);
        }
        this.events.get(event).push(callback);
        return () => this.off(event, callback);
    }

    off(event, callback) {
        if (!this.events.has(event)) {
            return;
        }
        const callbacks = this.events.get(event);
        const index = callbacks.indexOf(callback);
        if (index > -1) {
            callbacks.splice(index, 1);
        }
    }

    emit(event, ...args) {
        if (!this.events.has(event)) {
            return;
        }
        this.events.get(event).forEach(callback => {
            callback(...args);
        });
    }

    once(event, callback) {
        const wrapper = (...args) => {
            callback(...args);
            this.off(event, wrapper);
        };
        return this.on(event, wrapper);
    }
}

// Usage
const emitter = new EventEmitter();
const unsubscribe = emitter.on('data', (msg) => console.log(msg));
emitter.emit('data', 'Hello'); // Hello
unsubscribe();
emitter.emit('data', 'Hello'); // Nothing happens
```

### Challenge 4: Implement a task scheduler

```javascript
class TaskScheduler {
    constructor() {
        this.tasks = new Map();
        this.intervals = new Map();
    }

    schedule(taskId, fn, delay, interval = null) {
        if (this.tasks.has(taskId)) {
            this.cancel(taskId);
        }

        const timeout = setTimeout(() => {
            fn();

            if (interval) {
                const intervalId = setInterval(fn, interval);
                this.intervals.set(taskId, intervalId);
            }
        }, delay);

        this.tasks.set(taskId, timeout);
    }

    cancel(taskId) {
        if (this.tasks.has(taskId)) {
            clearTimeout(this.tasks.get(taskId));
            this.tasks.delete(taskId);
        }

        if (this.intervals.has(taskId)) {
            clearInterval(this.intervals.get(taskId));
            this.intervals.delete(taskId);
        }
    }

    cancelAll() {
        this.tasks.forEach((timeout) => clearTimeout(timeout));
        this.intervals.forEach((interval) => clearInterval(interval));
        this.tasks.clear();
        this.intervals.clear();
    }
}

// Usage
const scheduler = new TaskScheduler();
scheduler.schedule('email', () => console.log('Send email'), 5000);
scheduler.schedule('cleanup', () => console.log('Cleanup'), 0, 60000);
scheduler.cancel('email');
```
