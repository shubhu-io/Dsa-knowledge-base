# Backend API Design

## Table of Contents

1. [REST API Design](#rest-api-design)
2. [GraphQL API Design](#graphql-api-design)
3. [API Versioning](#api-versioning)
4. [Authentication & Authorization](#authentication--authorization)
5. [Rate Limiting & Throttling](#rate-limiting--throttling)
6. [Error Handling](#error-handling)
7. [Pagination & Filtering](#pagination--filtering)
8. [Documentation](#documentation)
9. [Testing APIs](#testing-apis)
10. [API Gateway](#api-gateway)

---

## REST API Design

### Resource Naming Conventions

```
# Good: Plural nouns, lowercase, hyphens
GET    /api/v1/users
GET    /api/v1/users/123
POST   /api/v1/users
PUT    /api/v1/users/123
DELETE /api/v1/users/123

# Nested resources
GET    /api/v1/users/123/orders
GET    /api/v1/users/123/orders/456

# Bad: Verbs, singular nouns, camelCase
GET    /api/getUsers
POST   /api/createUser
GET    /api/user/123
```

### HTTP Methods

```javascript
// GET - Retrieve resources
GET /api/users           → List all users
GET /api/users/123       → Get user 123
GET /api/users?role=admin → Filter users

// POST - Create resource
POST /api/users
{
    "name": "John Doe",
    "email": "john@example.com"
}
Response: 201 Created
{
    "id": 123,
    "name": "John Doe",
    "email": "john@example.com",
    "createdAt": "2024-01-15T10:30:00Z"
}

// PUT - Replace entire resource
PUT /api/users/123
{
    "name": "John Doe",
    "email": "john.new@example.com"
}
Response: 200 OK

// PATCH - Partial update
PATCH /api/users/123
{
    "email": "john.new@example.com"
}
Response: 200 OK

// DELETE - Remove resource
DELETE /api/users/123
Response: 204 No Content
```

### Response Structure

```javascript
// Success response
{
    "status": "success",
    "data": {
        "id": 123,
        "name": "John Doe",
        "email": "john@example.com"
    },
    "meta": {
        "requestId": "req-abc-123",
        "timestamp": "2024-01-15T10:30:00Z"
    }
}

// List response with pagination
{
    "status": "success",
    "data": [
        { "id": 1, "name": "User 1" },
        { "id": 2, "name": "User 2" }
    ],
    "pagination": {
        "page": 1,
        "pageSize": 20,
        "totalItems": 150,
        "totalPages": 8,
        "hasNext": true,
        "hasPrevious": false
    }
}

// Error response
{
    "status": "error",
    "error": {
        "code": "VALIDATION_ERROR",
        "message": "Invalid input data",
        "details": [
            {
                "field": "email",
                "message": "Email is required"
            }
        ]
    },
    "meta": {
        "requestId": "req-abc-123",
        "timestamp": "2024-01-15T10:30:00Z"
    }
}
```

### Status Codes Usage

```javascript
// 2xx Success
200 OK                    // GET, PUT, PATCH successful
201 Created               // POST successful
202 Accepted              // Async operation initiated
204 No Content            // DELETE successful

// 3xx Redirection
301 Moved Permanently     // Resource moved permanently
304 Not Modified          // Cache is still valid

// 4xx Client Error
400 Bad Request           // Invalid request body
401 Unauthorized          // Authentication required
403 Forbidden             // Insufficient permissions
404 Not Found             // Resource doesn't exist
409 Conflict              // Resource already exists
422 Unprocessable Entity  // Validation failed
429 Too Many Requests     // Rate limit exceeded

// 5xx Server Error
500 Internal Server Error // Unexpected server error
502 Bad Gateway           // Upstream service error
503 Service Unavailable   // Server temporarily unavailable
504 Gateway Timeout       // Upstream service timeout
```

---

## GraphQL API Design

### Schema Definition

```graphql
type Query {
    user(id: ID!): User
    users(filter: UserFilter, pagination: PaginationInput): UserConnection!
    order(id: ID!): Order
}

type Mutation {
    createUser(input: CreateUserInput!): User!
    updateUser(id: ID!, input: UpdateUserInput!): User!
    deleteUser(id: ID!): Boolean!
    createOrder(input: CreateOrderInput!): Order!
}

type Subscription {
    orderStatusChanged(orderId: ID!): OrderStatus!
}

type User {
    id: ID!
    name: String!
    email: String!
    orders: [Order!]!
    createdAt: DateTime!
    updatedAt: DateTime!
}

type Order {
    id: ID!
    user: User!
    items: [OrderItem!]!
    total: Money!
    status: OrderStatus!
    createdAt: DateTime!
}

type OrderItem {
    product: Product!
    quantity: Int!
    price: Money!
}

type Product {
    id: ID!
    name: String!
    description: String
    price: Money!
    inStock: Boolean!
}

scalar DateTime
scalar Money

enum OrderStatus {
    PENDING
    CONFIRMED
    SHIPPED
    DELIVERED
    CANCELLED
}

input CreateUserInput {
    name: String!
    email: String!
}

input UserFilter {
    search: String
    role: UserRole
    createdAfter: DateTime
}

input PaginationInput {
    first: Int
    after: String
    last: Int
    before: String
}

type UserConnection {
    edges: [UserEdge!]!
    pageInfo: PageInfo!
    totalCount: Int!
}

type UserEdge {
    node: User!
    cursor: String!
}

type PageInfo {
    hasNextPage: Boolean!
    hasPreviousPage: Boolean!
    startCursor: String
    endCursor: String
}
```

### Resolver Implementation

```javascript
const resolvers = {
    Query: {
        user: async (_, { id }, context) => {
            const user = await context.dataSources.userAPI.getUser(id);
            if (!user) {
                throw new UserInputError('User not found');
            }
            return user;
        },

        users: async (_, { filter, pagination }, context) => {
            return context.dataSources.userAPI.getUsers(filter, pagination);
        }
    },

    Mutation: {
        createUser: async (_, { input }, context) => {
            // Validate input
            validateEmail(input.email);

            // Check for duplicates
            const existing = await context.dataSources.userAPI.findByEmail(input.email);
            if (existing) {
                throw new UserInputError('Email already exists');
            }

            return context.dataSources.userAPI.createUser(input);
        }
    },

    User: {
        orders: async (user, _, context) => {
            return context.dataSources.orderAPI.getOrdersByUser(user.id);
        }
    },

    Order: {
        user: async (order, _, context) => {
            return context.dataSources.userAPI.getUser(order.userId);
        }
    }
};
```

---

## API Versioning

### URL Versioning

```javascript
// Express routes
const v1Router = require('./routes/v1');
const v2Router = require('./routes/v2');

app.use('/api/v1', v1Router);
app.use('/api/v2', v2Router);

// v1/routes/users.js
router.get('/users', async (req, res) => {
    const users = await User.findAll();
    res.json(users);
});

// v2/routes/users.js (with new fields)
router.get('/users', async (req, res) => {
    const users = await User.findAll({
        include: ['profile', 'settings']
    });
    res.json(users);
});
```

### Header Versioning

```javascript
// Middleware to extract version
function versionMiddleware(req, res, next) {
    const accept = req.headers['accept'];
    const versionMatch = accept?.match(/application\/vnd\.api\.v(\d+)\+json/);

    if (versionMatch) {
        req.apiVersion = parseInt(versionMatch[1]);
    } else {
        req.apiVersion = 1; // Default version
    }

    next();
}

// Usage
app.get('/api/users', versionMiddleware, async (req, res) => {
    if (req.apiVersion === 1) {
        // V1 response
    } else if (req.apiVersion === 2) {
        // V2 response
    }
});
```

### Version Deprecation

```javascript
// Deprecation headers
function deprecationNotice(version, sunsetDate) {
    return (req, res, next) => {
        res.set({
            'Deprecation': 'true',
            'Sunset': new Date(sunsetDate).toUTCString(),
            'Link': `</api/v${version + 1}>; rel="successor-version"`
        });
        next();
    };
}

// Apply to old version
app.use('/api/v1', deprecationNotice(1, '2025-01-01'));
```

---

## Authentication & Authorization

### JWT Implementation

```javascript
const jwt = require('jsonwebtoken');

// Generate tokens
function generateTokens(user) {
    const accessToken = jwt.sign(
        {
            sub: user.id,
            email: user.email,
            roles: user.roles
        },
        process.env.JWT_SECRET,
        { expiresIn: '15m' }
    );

    const refreshToken = jwt.sign(
        { sub: user.id },
        process.env.JWT_REFRESH_SECRET,
        { expiresIn: '7d' }
    );

    return { accessToken, refreshToken };
}

// Verify token middleware
function authenticate(req, res, next) {
    const authHeader = req.headers.authorization;
    const token = authHeader?.split(' ')[1];

    if (!token) {
        return res.status(401).json({
            error: { code: 'UNAUTHORIZED', message: 'No token provided' }
        });
    }

    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        req.user = decoded;
        next();
    } catch (error) {
        if (error.name === 'TokenExpiredError') {
            return res.status(401).json({
                error: { code: 'TOKEN_EXPIRED', message: 'Token has expired' }
            });
        }
        return res.status(401).json({
            error: { code: 'INVALID_TOKEN', message: 'Invalid token' }
        });
    }
}

// Role-based authorization
function authorize(...roles) {
    return (req, res, next) => {
        if (!req.user) {
            return res.status(401).json({
                error: { code: 'UNAUTHORIZED', message: 'Not authenticated' }
            });
        }

        const hasRole = roles.some(role => req.user.roles.includes(role));
        if (!hasRole) {
            return res.status(403).json({
                error: { code: 'FORBIDDEN', message: 'Insufficient permissions' }
            });
        }

        next();
    };
}

// Usage
app.get('/api/admin/users', authenticate, authorize('admin'), adminController.getUsers);
```

### OAuth 2.0 Implementation

```javascript
const passport = require('passport');
const GoogleStrategy = require('passport-google-oauth20').Strategy;

passport.use(new GoogleStrategy({
    clientID: process.env.GOOGLE_CLIENT_ID,
    clientSecret: process.env.GOOGLE_CLIENT_SECRET,
    callbackURL: '/auth/google/callback'
},
async (accessToken, refreshToken, profile, done) => {
    try {
        let user = await User.findOne({ googleId: profile.id });

        if (!user) {
            user = await User.create({
                googleId: profile.id,
                email: profile.emails[0].value,
                name: profile.displayName
            });
        }

        return done(null, user);
    } catch (error) {
        return done(error, null);
    }
}));

// Routes
app.get('/auth/google',
    passport.authenticate('google', { scope: ['profile', 'email'] })
);

app.get('/auth/google/callback',
    passport.authenticate('google', { failureRedirect: '/login' }),
    (req, res) => {
        const tokens = generateTokens(req.user);
        res.redirect(`http://localhost:3000/auth/callback?token=${tokens.accessToken}`);
    }
);
```

---

## Rate Limiting & Throttling

### Implementation

```javascript
const rateLimit = require('express-rate-limit');
const RedisStore = require('rate-limit-redis');

// Basic rate limiter
const basicLimiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 100, // 100 requests per window
    standardHeaders: true,
    legacyHeaders: false,
    message: {
        error: {
            code: 'RATE_LIMIT_EXCEEDED',
            message: 'Too many requests, please try again later'
        }
    }
});

// Stricter limit for auth endpoints
const authLimiter = rateLimit({
    windowMs: 60 * 60 * 1000, // 1 hour
    max: 5, // 5 attempts per hour
    skipSuccessfulRequests: true,
    message: {
        error: {
            code: 'AUTH_RATE_LIMIT_EXCEEDED',
            message: 'Too many authentication attempts'
        }
    }
});

// User-based rate limiting
const userLimiter = rateLimit({
    windowMs: 60 * 1000, // 1 minute
    max: 60, // 60 requests per minute
    keyGenerator: (req) => req.user?.id || req.ip,
    standardHeaders: true
});

// Apply to routes
app.use('/api/', basicLimiter);
app.use('/api/auth/login', authLimiter);
app.use('/api/users', authenticate, userLimiter);
```

### Custom Rate Limiter

```javascript
class SlidingWindowRateLimiter {
    constructor(redis, options) {
        this.redis = redis;
        this.windowMs = options.windowMs || 60000;
        this.maxRequests = options.maxRequests || 100;
    }

    async isAllowed(key) {
        const now = Date.now();
        const windowStart = now - this.windowMs;

        // Remove old entries
        await this.redis.zremrangebyscore(key, 0, windowStart);

        // Count current requests
        const count = await this.redis.zcard(key);

        if (count >= this.maxRequests) {
            return { allowed: false, retryAfter: this.windowMs };
        }

        // Add current request
        await this.redis.zadd(key, now, `${now}-${Math.random()}`);
        await this.redis.expire(key, Math.ceil(this.windowMs / 1000));

        return {
            allowed: true,
            remaining: this.maxRequests - count - 1,
            resetAt: now + this.windowMs
        };
    }
}
```

---

## Error Handling

### Error Response Format

```javascript
// Custom error classes
class AppError extends Error {
    constructor(message, statusCode, code, details = null) {
        super(message);
        this.statusCode = statusCode;
        this.code = code;
        this.details = details;
        this.isOperational = true;
    }
}

class ValidationError extends AppError {
    constructor(errors) {
        super('Validation failed', 400, 'VALIDATION_ERROR', errors);
    }
}

class NotFoundError extends AppError {
    constructor(resource, id) {
        super(`${resource} not found`, 404, 'NOT_FOUND', { id });
    }
}

class ConflictError extends AppError {
    constructor(message) {
        super(message, 409, 'CONFLICT');
    }
}

// Error handler middleware
function errorHandler(err, req, res, next) {
    if (err.isOperational) {
        return res.status(err.statusCode).json({
            status: 'error',
            error: {
                code: err.code,
                message: err.message,
                details: err.details
            },
            meta: {
                requestId: req.id,
                timestamp: new Date().toISOString()
            }
        });
    }

    // Unknown error
    console.error('Unexpected error:', err);

    res.status(500).json({
        status: 'error',
        error: {
            code: 'INTERNAL_ERROR',
            message: 'An unexpected error occurred'
        },
        meta: {
            requestId: req.id,
            timestamp: new Date().toISOString()
        }
    });
}

// Async error wrapper
const asyncHandler = (fn) => (req, res, next) => {
    Promise.resolve(fn(req, res, next)).catch(next);
};
```

---

## Pagination & Filtering

### Cursor-Based Pagination

```javascript
// Implementation
async function getProducts({ cursor, limit = 20, filters }) {
    const query = {};

    if (cursor) {
        query.createdAt = { $lt: new Date(cursor) };
    }

    if (filters.category) {
        query.category = filters.category;
    }

    if (filters.priceMin || filters.priceMax) {
        query.price = {};
        if (filters.priceMin) query.price.$gte = filters.priceMin;
        if (filters.priceMax) query.price.$lte = filters.priceMax;
    }

    const products = await Product.find(query)
        .sort({ createdAt: -1 })
        .limit(limit + 1);

    const hasMore = products.length > limit;
    const data = hasMore ? products.slice(0, limit) : products;
    const nextCursor = hasMore ? data[data.length - 1].createdAt : null;

    return {
        data,
        pagination: {
            nextCursor,
            hasMore
        }
    };
}
```

### Filtering

```javascript
// Query builder
class QueryBuilder {
    constructor(query) {
        this.query = query;
        this.filters = {};
        this.sort = {};
        this.fields = null;
    }

    filter(field, operator, value) {
        if (operator === 'eq') {
            this.filters[field] = value;
        } else if (operator === 'gt') {
            this.filters[field] = { $gt: value };
        } else if (operator === 'lt') {
            this.filters[field] = { $lt: value };
        } else if (operator === 'in') {
            this.filters[field] = { $in: value };
        }
        return this;
    }

    sort(field, direction = 'asc') {
        this.sort[field] = direction === 'asc' ? 1 : -1;
        return this;
    }

    select(fields) {
        this.fields = fields.join(' ');
        return this;
    }

    async execute() {
        let query = this.query.find(this.filters);

        if (this.fields) {
            query = query.select(this.fields);
        }

        if (Object.keys(this.sort).length) {
            query = query.sort(this.sort);
        }

        return query;
    }
}

// Usage
const products = await new QueryBuilder(Product.find())
    .filter('category', 'eq', 'electronics')
    .filter('price', 'gt', 100)
    .sort('price', 'asc')
    .select(['name', 'price', 'category'])
    .execute();
```

---

## Documentation

### OpenAPI/Swagger

```yaml
openapi: 3.0.0
info:
  title: User API
  version: 1.0.0
  description: API for managing users

paths:
  /api/users:
    get:
      summary: List all users
      tags: [Users]
      parameters:
        - name: page
          in: query
          schema:
            type: integer
            default: 1
        - name: limit
          in: query
          schema:
            type: integer
            default: 20
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                type: object
                properties:
                  data:
                    type: array
                    items:
                      $ref: '#/components/schemas/User'
                  pagination:
                    $ref: '#/components/schemas/Pagination'

    post:
      summary: Create a new user
      tags: [Users]
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateUserInput'
      responses:
        '201':
          description: User created
        '400':
          description: Validation error

components:
  schemas:
    User:
      type: object
      properties:
        id:
          type: string
        name:
          type: string
        email:
          type: string
          format: email
        createdAt:
          type: string
          format: date-time

    CreateUserInput:
      type: object
      required: [name, email]
      properties:
        name:
          type: string
          minLength: 2
        email:
          type: string
          format: email
```

---

## Common Interview Questions

### Q1: What are the constraints of REST?

**Answer:**
REST constraints include:
- Client-server architecture
- Stateless communication
- Cacheable responses
- Uniform interface
- Layered system
- Code on demand (optional)

### Q2: How do you handle API versioning?

**Answer:**
Common approaches:
- **URL versioning**: `/api/v1/users` (most common)
- **Header versioning**: `Accept: application/vnd.api.v1+json`
- **Query parameter**: `/api/users?version=1`
- **Content negotiation**: Media types

Trade-offs: URL is simplest but pollutes URLs; header is cleaner but harder to test.

### Q3: What is HATEOAS?

**Answer:**
HATEOAS (Hypermedia as the Engine of Application State) means responses include links to related resources, allowing clients to discover actions dynamically.

```json
{
    "id": 123,
    "name": "John",
    "links": [
        { "rel": "self", "href": "/api/users/123" },
        { "rel": "orders", "href": "/api/users/123/orders" }
    ]
}
```

### Q4: How do you design a public API?

**Answer:**
- Use consistent naming conventions
- Version the API from the start
- Provide comprehensive documentation
- Implement rate limiting
- Use authentication (API keys, OAuth)
- Return appropriate status codes
- Support pagination
- Handle errors gracefully
- Consider backwards compatibility

### Q5: What is the difference between REST and gRPC?

**Answer:**
| Feature | REST | gRPC |
|---------|------|------|
| Protocol | HTTP/1.1 | HTTP/2 |
| Format | JSON | Protobuf |
| Schema | OpenAPI | .proto files |
| Streaming | Limited | Full support |
| Browser | Native | Requires proxy |
| Performance | Good | Better |

Use REST for public APIs, gRPC for internal service communication.
