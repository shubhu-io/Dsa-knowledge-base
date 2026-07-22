# Backend Development Complete Guide

## Table of Contents

1. [HTTP Fundamentals](#http-fundamentals)
2. [RESTful API Design](#restful-api-design)
3. [Authentication & Security](#authentication--security)
4. [Database Integration](#database-integration)
5. [Caching Strategies](#caching-strategies)
6. [Message Queues](#message-queues)
7. [Logging & Monitoring](#logging--monitoring)
8. [Error Handling](#error-handling)
9. [Testing](#testing)
10. [Deployment](#deployment)

---

## HTTP Fundamentals

### HTTP Methods

| Method | Purpose | Idempotent | Safe |
|--------|---------|------------|------|
| GET | Retrieve resource | Yes | Yes |
| POST | Create resource | No | No |
| PUT | Replace resource | Yes | No |
| PATCH | Partial update | No | No |
| DELETE | Remove resource | Yes | No |
| HEAD | Get headers only | Yes | Yes |
| OPTIONS | Get allowed methods | Yes | Yes |

### Status Codes

```
1xx: Informational
├── 100 Continue
└── 102 Processing

2xx: Success
├── 200 OK
├── 201 Created
├── 202 Accepted
├── 204 No Content
└── 206 Partial Content

3xx: Redirection
├── 301 Moved Permanently
├── 302 Found
├── 304 Not Modified
└── 307 Temporary Redirect

4xx: Client Error
├── 400 Bad Request
├── 401 Unauthorized
├── 403 Forbidden
├── 404 Not Found
├── 405 Method Not Allowed
├── 409 Conflict
├── 422 Unprocessable Entity
├── 429 Too Many Requests
└── 503 Service Unavailable

5xx: Server Error
├── 500 Internal Server Error
├── 501 Not Implemented
├── 502 Bad Gateway
├── 503 Service Unavailable
└── 504 Gateway Timeout
```

### Request/Response Structure

```http
POST /api/users HTTP/1.1
Host: api.example.com
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJIUzI1NiIs...
Accept: application/json
Cache-Control: no-cache

{
    "name": "John Doe",
    "email": "john@example.com"
}
```

```http
HTTP/1.1 201 Created
Content-Type: application/json
Location: /api/users/123
X-Request-Id: abc-123

{
    "id": 123,
    "name": "John Doe",
    "email": "john@example.com",
    "createdAt": "2024-01-15T10:30:00Z"
}
```

---

## RESTful API Design

### Resource Naming

```
✅ Good:
GET    /api/users
GET    /api/users/123
POST   /api/users
PUT    /api/users/123
DELETE /api/users/123
GET    /api/users/123/orders
GET    /api/users/123/orders/456

❌ Bad:
GET    /api/getUsers
POST   /api/createUser
GET    /api/user/123/getOrders
```

### Versioning

```
# URL Versioning
/api/v1/users
/api/v2/users

# Header Versioning
Accept: application/vnd.api.v1+json

# Query Parameter Versioning
/api/users?version=1
```

### Pagination

```json
// Cursor-based pagination
{
    "data": [...],
    "pagination": {
        "cursor": "eyJpZCI6MTIzfQ==",
        "hasMore": true,
        "limit": 20
    }
}

// Offset-based pagination
{
    "data": [...],
    "pagination": {
        "page": 1,
        "pageSize": 20,
        "totalItems": 150,
        "totalPages": 8
    }
}
```

### Filtering and Sorting

```
GET /api/products?category=electronics&price_min=100&price_max=500
GET /api/products?sort=-created_at,name
GET /api/products?fields=id,name,price
```

---

## Authentication & Security

### JWT Authentication

```javascript
// Token Structure
Header.Payload.Signature

// Header
{
    "alg": "HS256",
    "typ": "JWT"
}

// Payload
{
    "sub": "1234567890",
    "name": "John Doe",
    "iat": 1516239022,
    "exp": 1516242622,
    "roles": ["user", "admin"]
}

// Implementation
const jwt = require('jsonwebtoken');

// Generate token
function generateToken(user) {
    return jwt.sign(
        {
            sub: user.id,
            email: user.email,
            roles: user.roles
        },
        process.env.JWT_SECRET,
        { expiresIn: '24h' }
    );
}

// Verify token
function verifyToken(token) {
    return jwt.verify(token, process.env.JWT_SECRET);
}

// Middleware
function authenticate(req, res, next) {
    const token = req.headers.authorization?.split(' ')[1];

    if (!token) {
        return res.status(401).json({ error: 'No token provided' });
    }

    try {
        const decoded = verifyToken(token);
        req.user = decoded;
        next();
    } catch (error) {
        return res.status(401).json({ error: 'Invalid token' });
    }
}
```

### OAuth 2.0 Flows

```
Authorization Code Flow (Web Apps)
├── Client redirects to authorization server
├── User logs in and grants consent
├── Authorization server returns code
├── Client exchanges code for tokens
└── Client uses access token

Client Credentials Flow (Server-to-Server)
├── Client sends credentials to auth server
├── Auth server validates and returns tokens
└── Client uses access token

PKCE Flow (Mobile/SPA)
├── Client generates code verifier/challenge
├── Client redirects with challenge
├── Auth server returns code
├── Client exchanges code with verifier
└── Client receives tokens
```

### Security Headers

```javascript
// Helmet.js for Express
const helmet = require('helmet');

app.use(helmet());

// Sets headers:
// X-Content-Type-Options: nosniff
// X-Frame-Options: DENY
// X-XSS-Protection: 1; mode=block
// Strict-Transport-Security: max-age=31536000; includeSubDomains
// Content-Security-Policy: default-src 'self'
```

### Rate Limiting

```javascript
const rateLimit = require('express-rate-limit');

const limiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 100, // limit each IP to 100 requests per windowMs
    message: 'Too many requests',
    standardHeaders: true,
    legacyHeaders: false,
});

app.use('/api/', limiter);

// Stricter limit for auth endpoints
const authLimiter = rateLimit({
    windowMs: 60 * 60 * 1000, // 1 hour
    max: 5, // 5 attempts per hour
    message: 'Too many login attempts',
});

app.use('/api/auth/login', authLimiter);
```

---

## Database Integration

### SQL vs NoSQL

| Feature | SQL | NoSQL |
|---------|-----|-------|
| Structure | Fixed schema | Flexible schema |
| Scaling | Vertical | Horizontal |
| ACID | Yes | Eventually consistent |
| Relationships | Strong | Weak |
| Query Language | SQL | Various |

### Connection Pooling

```javascript
// PostgreSQL with pg-pool
const { Pool } = require('pg');

const pool = new Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: 5432,
    max: 20, // Maximum pool size
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: 2000,
});

async function query(text, params) {
    const start = Date.now();
    const res = await pool.query(text, params);
    const duration = Date.now() - start;
    console.log('Executed query', { text, duration, rows: res.rowCount });
    return res;
}

// Using the pool
async function getUser(id) {
    const result = await query('SELECT * FROM users WHERE id = $1', [id]);
    return result.rows[0];
}
```

### ORM Examples

```javascript
// Prisma (Node.js)
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

// Create
const user = await prisma.user.create({
    data: {
        email: 'john@example.com',
        name: 'John Doe',
        posts: {
            create: [{ title: 'Hello World' }]
        }
    }
});

// Read with relations
const users = await prisma.user.findMany({
    where: { active: true },
    include: { posts: true },
    orderBy: { createdAt: 'desc' }
});

// Update
const updated = await prisma.user.update({
    where: { id: 1 },
    data: { name: 'Jane Doe' }
});

// Delete
await prisma.user.delete({ where: { id: 1 } });
```

---

## Caching Strategies

### Redis Caching

```javascript
const redis = require('redis');
const client = redis.createClient();

// Basic caching
async function getUser(id) {
    const cacheKey = `user:${id}`;

    // Check cache first
    const cached = await client.get(cacheKey);
    if (cached) {
        return JSON.parse(cached);
    }

    // Fetch from database
    const user = await db.users.findById(id);

    // Cache for 1 hour
    await client.setEx(cacheKey, 3600, JSON.stringify(user));

    return user;
}

// Cache invalidation
async function updateUser(id, data) {
    const user = await db.users.update(id, data);

    // Invalidate cache
    await client.del(`user:${id}`);

    return user;
}

// Cache patterns
// Cache-Aside: Check cache, then DB
// Write-Through: Write to cache and DB simultaneously
// Write-Behind: Write to cache, async write to DB
```

### CDN Caching

```javascript
// Cache headers
app.get('/api/products', (req, res) => {
    res.set({
        'Cache-Control': 'public, max-age=3600',
        'ETag': '"12345"',
        'Last-Modified': 'Mon, 01 Jan 2024 00:00:00 GMT'
    });
    res.json(products);
});

// Vary header for content negotiation
res.set('Vary', 'Accept-Encoding, Authorization');
```

---

## Message Queues

### RabbitMQ Example

```javascript
const amqp = require('amqplib');

// Producer
async function sendToQueue(queue, message) {
    const connection = await amqp.connect('amqp://localhost');
    const channel = await connection.createChannel();

    await channel.assertQueue(queue, { durable: true });
    channel.sendToQueue(queue, Buffer.from(message), {
        persistent: true
    });

    setTimeout(() => connection.close(), 500);
}

// Consumer
async function consumeFromQueue(queue) {
    const connection = await amqp.connect('amqp://localhost');
    const channel = await connection.createChannel();

    await channel.assertQueue(queue, { durable: true });
    channel.prefetch(1);

    console.log('Waiting for messages...');

    channel.consume(queue, async (msg) => {
        const content = msg.content.toString();
        console.log('Received:', content);

        // Process message
        await processMessage(content);

        // Acknowledge
        channel.ack(msg);
    });
}
```

### Kafka Example

```javascript
const { Kafka } = require('kafkajs');

const kafka = new Kafka({
    clientId: 'my-app',
    brokers: ['localhost:9092']
});

// Producer
const producer = kafka.producer();
await producer.connect();
await producer.send({
    topic: 'user-events',
    messages: [
        { value: JSON.stringify({ type: 'user.created', userId: 123 }) }
    ]
});

// Consumer
const consumer = kafka.consumer({ groupId: 'my-group' });
await consumer.connect();
await consumer.subscribe({ topic: 'user-events', fromBeginning: true });

await consumer.run({
    eachMessage: async ({ topic, partition, message }) => {
        const event = JSON.parse(message.value.toString());
        console.log('Received event:', event);
    }
});
```

---

## Logging & Monitoring

### Structured Logging

```javascript
const winston = require('winston');

const logger = winston.createLogger({
    level: 'info',
    format: winston.format.combine(
        winston.format.timestamp(),
        winston.format.json()
    ),
    transports: [
        new winston.transports.File({ filename: 'error.log', level: 'error' }),
        new winston.transports.File({ filename: 'combined.log' })
    ]
});

if (process.env.NODE_ENV !== 'production') {
    logger.add(new winston.transports.Console({
        format: winston.format.simple()
    }));
}

// Usage
logger.info('User created', {
    userId: 123,
    email: 'john@example.com',
    ip: '192.168.1.1'
});

logger.error('Database connection failed', {
    error: err.message,
    stack: err.stack
});
```

### Request Logging Middleware

```javascript
// Morgan for HTTP logging
const morgan = require('morgan');

// Custom format
morgan.token('id', (req) => req.id);
morgan.token('user', (req) => req.user?.id || 'anonymous');

app.use(morgan(':id :method :url :status :response-time ms - :user'));

// Request context middleware
app.use((req, res, next) => {
    req.id = uuid.v4();
    req.startTime = Date.now();

    res.on('finish', () => {
        const duration = Date.now() - req.startTime;
        logger.info('Request completed', {
            requestId: req.id,
            method: req.method,
            url: req.url,
            status: res.statusCode,
            duration
        });
    });

    next();
});
```

### Health Checks

```javascript
// Health check endpoint
app.get('/health', async (req, res) => {
    const checks = {
        database: await checkDatabase(),
        redis: await checkRedis(),
        externalApi: await checkExternalApi()
    };

    const healthy = Object.values(checks).every(c => c.status === 'ok');

    res.status(healthy ? 200 : 503).json({
        status: healthy ? 'healthy' : 'unhealthy',
        checks,
        timestamp: new Date().toISOString()
    });
});

async function checkDatabase() {
    try {
        await db.query('SELECT 1');
        return { status: 'ok', latency: Date.now() };
    } catch (error) {
        return { status: 'error', error: error.message };
    }
}
```

---

## Error Handling

### Global Error Handler

```javascript
// Custom error classes
class AppError extends Error {
    constructor(message, statusCode, code) {
        super(message);
        this.statusCode = statusCode;
        this.code = code;
        this.isOperational = true;
    }
}

class ValidationError extends AppError {
    constructor(message, errors) {
        super(message, 400, 'VALIDATION_ERROR');
        this.errors = errors;
    }
}

class NotFoundError extends AppError {
    constructor(resource) {
        super(`${resource} not found`, 404, 'NOT_FOUND');
    }
}

// Error handler middleware
app.use((err, req, res, next) => {
    if (err.isOperational) {
        return res.status(err.statusCode).json({
            error: {
                code: err.code,
                message: err.message,
                details: err.errors
            }
        });
    }

    // Unknown error
    logger.error('Unexpected error', {
        error: err.message,
        stack: err.stack,
        requestId: req.id
    });

    res.status(500).json({
        error: {
            code: 'INTERNAL_ERROR',
            message: 'An unexpected error occurred'
        }
    });
});

// Async error wrapper
function asyncHandler(fn) {
    return (req, res, next) => {
        Promise.resolve(fn(req, res, next)).catch(next);
    };
}

// Usage
app.get('/api/users/:id', asyncHandler(async (req, res) => {
    const user = await User.findById(req.params.id);
    if (!user) {
        throw new NotFoundError('User');
    }
    res.json(user);
}));
```

---

## Testing

### Unit Testing

```javascript
// Jest test example
const { calculateDiscount, validateEmail } = require('./utils');

describe('calculateDiscount', () => {
    it('should apply percentage discount', () => {
        expect(calculateDiscount(100, { type: 'percentage', value: 20 }))
            .toBe(80);
    });

    it('should apply fixed discount', () => {
        expect(calculateDiscount(100, { type: 'fixed', value: 25 }))
            .toBe(75);
    });

    it('should not allow negative price', () => {
        expect(() => calculateDiscount(-10, { type: 'percentage', value: 20 }))
            .toThrow('Price cannot be negative');
    });
});

describe('validateEmail', () => {
    it('should validate correct email', () => {
        expect(validateEmail('user@example.com')).toBe(true);
    });

    it('should reject invalid email', () => {
        expect(validateEmail('invalid-email')).toBe(false);
    });
});
```

### Integration Testing

```javascript
const request = require('supertest');
const app = require('../app');

describe('User API', () => {
    describe('POST /api/users', () => {
        it('should create a new user', async () => {
            const res = await request(app)
                .post('/api/users')
                .send({
                    name: 'John Doe',
                    email: 'john@example.com',
                    password: 'securePassword123'
                })
                .expect(201);

            expect(res.body).toHaveProperty('id');
            expect(res.body.name).toBe('John Doe');
            expect(res.body).not.toHaveProperty('password');
        });

        it('should return 400 for invalid data', async () => {
            await request(app)
                .post('/api/users')
                .send({
                    name: '',
                    email: 'invalid-email'
                })
                .expect(400);
        });
    });
});
```

---

## Deployment

### Docker Configuration

```dockerfile
# Dockerfile
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build

FROM node:18-alpine AS runner
WORKDIR /app
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001
COPY --from=builder --chown=nextjs:nodejs /app/dist ./dist
COPY --from=builder --chown=nextjs:nodejs /app/node_modules ./node_modules
USER nextjs
EXPOSE 3000
CMD ["node", "dist/main.js"]
```

### Docker Compose

```yaml
# docker-compose.yml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgresql://postgres:password@db:5432/myapp
      - REDIS_URL=redis://redis:6379
    depends_on:
      - db
      - redis

  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=password
      - POSTGRES_DB=myapp
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

volumes:
  postgres_data:
```

---

## Common Interview Questions

### Q1: What is the difference between REST and GraphQL?

**Answer:**
- **REST**: Multiple endpoints, fixed data structure, HTTP methods for operations
- **GraphQL**: Single endpoint, client specifies data requirements, queries/mutations

REST is simpler and more cacheable; GraphQL is more flexible and reduces over-fetching.

### Q2: How do you handle database transactions?

**Answer:**
```javascript
const trx = await db.transaction();
try {
    await trx('accounts').where('id', 1).decrement('balance', 100);
    await trx('accounts').where('id', 2).increment('balance', 100);
    await trx.commit();
} catch (error) {
    await trx.rollback();
    throw error;
}
```

### Q3: What is connection pooling and why use it?

**Answer:**
Connection pooling maintains a cache of database connections that can be reused. Benefits:
- Reduces connection overhead
- Limits concurrent connections
- Improves performance
- Prevents connection exhaustion

### Q4: How do you secure a REST API?

**Answer:**
- Use HTTPS
- Implement authentication (JWT, OAuth)
- Rate limiting
- Input validation
- CORS configuration
- Security headers (Helmet)
- SQL injection prevention
- XSS prevention

### Q5: Explain CAP theorem.

**Answer:**
CAP theorem states a distributed system can only provide two of three guarantees:
- **Consistency**: Every read receives the most recent write
- **Availability**: Every request receives a response
- **Partition Tolerance**: System continues despite network failures

In practice, partition tolerance is required, so you choose between CP (consistency) or AP (availability).
