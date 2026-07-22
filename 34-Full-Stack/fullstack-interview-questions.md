# Full-Stack Interview Questions

## Table of Contents

1. [General Questions](#general-questions)
2. [Frontend Questions](#frontend-questions)
3. [Backend Questions](#backend-questions)
4. [Database Questions](#database-questions)
5. [System Design Questions](#system-design-questions)
6. [Behavioral Questions](#behavioral-questions)
7. [Coding Challenges](#coding-challenges)
8. [Project-Based Questions](#project-based-questions)

---

## General Questions

### Q1: What is the difference between frontend and backend?

**Answer:**
- **Frontend**: Client-side code that runs in the browser, handles UI/UX, makes API calls
- **Backend**: Server-side code that handles business logic, database operations, authentication

```
Frontend (Client)              Backend (Server)
┌─────────────────┐           ┌─────────────────┐
│ HTML/CSS/JS     │  HTTP     │ API Routes      │
│ React/Vue       │ ◄──────► │ Business Logic  │
│ State Management│           │ Database Access │
└─────────────────┘           └─────────────────┘
                                      │
                                      ▼
                               ┌─────────────────┐
                               │ Database        │
                               │ (PostgreSQL)    │
                               └─────────────────┘
```

### Q2: What is a RESTful API?

**Answer:**
REST (Representational State Transfer) is an architectural style for APIs:

- **Resources**: Nouns (e.g., `/users`, `/orders`)
- **HTTP Methods**: GET, POST, PUT, DELETE
- **Stateless**: Each request contains all needed information
- **Uniform Interface**: Consistent response format

```javascript
// RESTful endpoints
GET    /api/users          → List users
GET    /api/users/123      → Get user 123
POST   /api/users          → Create user
PUT    /api/users/123      → Update user 123
DELETE /api/users/123      → Delete user 123
```

### Q3: What is the difference between authentication and authorization?

**Answer:**
- **Authentication**: Verifying identity ("Are you John?")
- **Authorization**: Determining permissions ("Can John access this?")

```javascript
// Authentication: JWT token verification
const authenticate = (req, res, next) => {
    const token = req.headers.authorization?.split(' ')[1];
    const decoded = jwt.verify(token, SECRET);
    req.user = decoded;
    next();
};

// Authorization: Role-based access
const authorize = (roles) => (req, res, next) => {
    if (!roles.includes(req.user.role)) {
        return res.status(403).json({ error: 'Forbidden' });
    }
    next();
};
```

### Q4: What is CORS?

**Answer:**
CORS (Cross-Origin Resource Sharing) is a security mechanism that controls which origins can access resources.

```javascript
// Express CORS configuration
const cors = require('cors');

app.use(cors({
    origin: 'https://example.com',
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    credentials: true
}));

// How it works:
// 1. Browser sends OPTIONS request (preflight)
// 2. Server responds with allowed origins
// 3. Browser sends actual request if allowed
```

### Q5: What is the difference between cookies, localStorage, and sessionStorage?

**Answer:**
| Feature | Cookies | localStorage | sessionStorage |
|---------|---------|--------------|----------------|
| Storage | 4KB | 5-10MB | 5-10MB |
| Expiry | Configurable | Never | Session |
| Sent to server | Yes | No | No |
| Scope | Domain | Origin | Origin + Tab |

---

## Frontend Questions

### Q1: What is the Virtual DOM?

**Answer:**
The Virtual DOM is a lightweight JavaScript representation of the actual DOM that enables efficient updates.

```
State Change
     │
     ▼
New Virtual DOM Tree
     │
     ▼
Diffing (Compare old vs new)
     │
     ▼
Reconciliation (Update only changed parts)
     │
     ▼
Real DOM Updated
```

Benefits:
- Batched updates
- Minimal DOM manipulation
- Cross-platform compatibility

### Q2: Explain React hooks.

**Answer:**
Hooks let you use state and lifecycle in functional components:

```javascript
// useState - State management
const [count, setCount] = useState(0);

// useEffect - Side effects
useEffect(() => {
    document.title = `Count: ${count}`;
    return () => cleanup();
}, [count]);

// useContext - Context consumption
const theme = useContext(ThemeContext);

// useRef - Mutable references
const inputRef = useRef(null);

// useMemo - Memoized values
const memoized = useMemo(() => compute(a, b), [a, b]);

// useCallback - Memoized functions
const fn = useCallback(() => doSomething(a), [a]);
```

### Q3: What is the difference between controlled and uncontrolled components?

**Answer:**
```jsx
// Controlled: React controls the input value
function Controlled() {
    const [value, setValue] = useState('');
    return (
        <input
            value={value}
            onChange={(e) => setValue(e.target.value)}
        />
    );
}

// Uncontrolled: DOM controls the input value
function Uncontrolled() {
    const ref = useRef();
    return (
        <input defaultValue="" ref={ref} />
    );
}
```

| Aspect | Controlled | Uncontrolled |
|--------|------------|--------------|
| State | React state | DOM state |
| Value | `value` prop | `defaultValue` |
| Validation | On change | On submit |
| Dynamic control | Yes | No |

### Q4: What is code splitting?

**Answer:**
Code splitting breaks code into smaller chunks that can be loaded on demand.

```jsx
// Route-based splitting
const Dashboard = lazy(() => import('./Dashboard'));
const Settings = lazy(() => import('./Settings'));

function App() {
    return (
        <Suspense fallback={<Loading />}>
            <Routes>
                <Route path="/dashboard" element={<Dashboard />} />
                <Route path="/settings" element={<Settings />} />
            </Routes>
        </Suspense>
    );
}

// Component-based splitting
function HeavyComponent() {
    const [showChart, setShowChart] = useState(false);
    return (
        <div>
            <button onClick={() => setShowChart(true)}>Show Chart</button>
            {showChart && (
                <Suspense fallback={<Spinner />}>
                    <Chart />
                </Suspense>
            )}
        </div>
    );
}
```

### Q5: How do you optimize React performance?

**Answer:**
1. **Memoization**: `React.memo`, `useMemo`, `useCallback`
2. **Code splitting**: Lazy load routes and components
3. **Virtualization**: For long lists (react-window)
4. **Avoid re-renders**: Stable references, proper keys
5. **Bundle analysis**: Remove unused code

```jsx
// Memoize expensive computations
function ProductList({ products }) {
    const sorted = useMemo(() => {
        return [...products].sort((a, b) => a.price - b.price);
    }, [products]);

    return <List items={sorted} />;
}

// Memoize callbacks
function Parent() {
    const handleClick = useCallback(() => {
        console.log('clicked');
    }, []);

    return <Child onClick={handleClick} />;
}
```

---

## Backend Questions

### Q1: What is middleware?

**Answer:**
Middleware functions have access to request, response, and next function.

```javascript
// Logging middleware
const logger = (req, res, next) => {
    console.log(`${req.method} ${req.url} - ${Date.now()}`);
    next();
};

// Authentication middleware
const auth = (req, res, next) => {
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) {
        return res.status(401).json({ error: 'No token' });
    }
    try {
        req.user = jwt.verify(token, SECRET);
        next();
    } catch (err) {
        res.status(401).json({ error: 'Invalid token' });
    }
};

// Error handling middleware
const errorHandler = (err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({ error: 'Something went wrong' });
};

// Usage
app.use(logger);
app.use('/api', auth);
app.use(errorHandler);
```

### Q2: What is the difference between SQL and NoSQL?

**Answer:**
| Aspect | SQL | NoSQL |
|--------|-----|-------|
| Schema | Fixed | Dynamic |
| Relationships | Strong (JOINs) | Weak |
| Scaling | Vertical | Horizontal |
| Transactions | ACID | Eventual consistency |
| Query | SQL | Various |

```sql
-- SQL: PostgreSQL
SELECT u.name, COUNT(o.id) as order_count
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id;

// NoSQL: MongoDB
db.users.aggregate([
    { $lookup: {
        from: 'orders',
        localField: '_id',
        foreignField: 'userId',
        as: 'orders'
    }},
    { $project: {
        name: 1,
        orderCount: { $size: '$orders' }
    }}
]);
```

### Q3: How do you handle authentication?

**Answer:**
```javascript
// JWT Authentication Flow
// 1. User logs in
const token = jwt.sign(
    { id: user.id, email: user.email },
    SECRET,
    { expiresIn: '24h' }
);

// 2. Client stores token
localStorage.setItem('token', token);

// 3. Client sends token with requests
axios.get('/api/users', {
    headers: { Authorization: `Bearer ${token}` }
});

// 4. Server verifies token
const verify = (req, res, next) => {
    const token = req.headers.authorization?.split(' ')[1];
    const decoded = jwt.verify(token, SECRET);
    req.user = decoded;
    next();
};
```

### Q4: What is connection pooling?

**Answer:**
Connection pooling maintains a cache of database connections for reuse.

```javascript
const { Pool } = require('pg');

const pool = new Pool({
    user: 'user',
    host: 'localhost',
    database: 'mydb',
    password: 'password',
    max: 20, // Maximum pool size
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: 2000,
});

// Benefits:
// - Reduces connection overhead
// - Limits concurrent connections
// - Improves performance
// - Prevents connection exhaustion
```

### Q5: How do you handle errors?

**Answer:**
```javascript
// Custom error classes
class AppError extends Error {
    constructor(message, statusCode) {
        super(message);
        this.statusCode = statusCode;
        this.isOperational = true;
    }
}

// Error handler middleware
const errorHandler = (err, req, res, next) => {
    if (err.isOperational) {
        return res.status(err.statusCode).json({
            error: { message: err.message }
        });
    }

    // Unknown error
    console.error(err);
    res.status(500).json({
        error: { message: 'Internal server error' }
    });
};

// Async error wrapper
const asyncHandler = (fn) => (req, res, next) => {
    Promise.resolve(fn(req, res, next)).catch(next);
};

// Usage
app.get('/api/users/:id', asyncHandler(async (req, res) => {
    const user = await User.findById(req.params.id);
    if (!user) {
        throw new AppError('User not found', 404);
    }
    res.json(user);
}));
```

---

## Database Questions

### Q1: What is database normalization?

**Answer:**
Normalization reduces data redundancy and improves integrity.

```
1NF: Atomic values
    orders: [1,2,3] ❌ → Separate rows ✅

2NF: No partial dependencies
    user_name depends on user_id only ✅

3NF: No transitive dependencies
    department_name depends on department_id ✅
```

### Q2: What are indexes?

**Answer:**
Indexes improve query performance by creating a data structure for faster lookups.

```sql
-- Create index
CREATE INDEX idx_users_email ON users(email);

-- Composite index
CREATE INDEX idx_orders_user_date ON orders(user_id, created_at);

-- When to use:
-- ✅ Primary keys (automatic)
-- ✅ Foreign keys
-- ✅ Columns in WHERE clauses
-- ✅ Columns in JOIN conditions

-- When NOT to use:
-- ❌ Small tables
-- ❌ Low selectivity columns
-- ❌ Frequently updated columns
```

### Q3: What is a transaction?

**Answer:**
A transaction is a sequence of operations performed as a single unit.

```sql
BEGIN TRANSACTION;
    UPDATE accounts SET balance = balance - 100 WHERE id = 1;
    UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;

-- ACID Properties:
-- Atomicity: All or nothing
-- Consistency: Valid state transitions
-- Isolation: Concurrent transactions don't interfere
-- Durability: Committed data persists
```

### Q4: How do you optimize slow queries?

**Answer:**
```sql
-- 1. Analyze query plan
EXPLAIN ANALYZE SELECT * FROM orders WHERE user_id = 123;

-- 2. Add index
CREATE INDEX idx_orders_user ON orders(user_id);

-- 3. Avoid SELECT *
SELECT id, name FROM users WHERE active = true;

-- 4. Use LIMIT
SELECT * FROM logs ORDER BY created_at DESC LIMIT 100;

-- 5. Optimize JOINs
SELECT u.name, o.total
FROM users u
INNER JOIN orders o ON u.id = o.user_id
WHERE o.status = 'completed';
```

### Q5: What is the difference between SQL joins?

**Answer:**
```sql
-- INNER JOIN: Only matching rows
SELECT * FROM users u
INNER JOIN orders o ON u.id = o.user_id;

-- LEFT JOIN: All left rows + matching right rows
SELECT * FROM users u
LEFT JOIN orders o ON u.id = o.user_id;

-- RIGHT JOIN: All right rows + matching left rows
SELECT * FROM users u
RIGHT JOIN orders o ON u.id = o.user_id;

-- FULL JOIN: All rows from both tables
SELECT * FROM users u
FULL JOIN orders o ON u.id = o.user_id;
```

---

## System Design Questions

### Q1: Design a URL shortener.

**Answer:**
```
Requirements:
- Shorten URLs
- Redirect to original
- Analytics

Components:
1. API Gateway
2. URL Service
3. Cache (Redis)
4. Database (NoSQL)

Flow:
1. POST /shorten { url: "..." }
2. Generate short code
3. Store in database
4. Cache in Redis
5. Return short URL

Redirect:
1. GET /abc123
2. Check cache
3. If miss, query database
4. Redirect (301/302)
```

### Q2: Design a chat application.

**Answer:**
```
Requirements:
- Real-time messaging
- Group chats
- Message history

Components:
1. WebSocket Server
2. Message Service
3. Database (PostgreSQL)
4. Cache (Redis)

Flow:
1. User connects via WebSocket
2. Message sent → persisted
3. Published to message queue
4. Other servers broadcast
5. Recipients receive message
```

### Q3: How would you scale a web application?

**Answer:**
```
Scaling Strategies:
├── Horizontal: Add more servers
├── Vertical: Upgrade server resources
├── Database: Read replicas, sharding
├── Caching: Redis, CDN
├── Load Balancing: Distribute traffic
└── Microservices: Split by domain

Implementation:
1. Stateless servers
2. Load balancer (Nginx/HAProxy)
3. Redis for session/cache
4. Read replicas for database
5. CDN for static assets
```

### Q4: How do you handle real-time features?

**Answer:**
```javascript
// WebSockets
const io = new Server(server);

io.on('connection', (socket) => {
    socket.on('message', (data) => {
        io.to(data.room).emit('message', data);
    });
});

// Server-Sent Events
app.get('/events', (req, res) => {
    res.setHeader('Content-Type', 'text/event-stream');
    res.setHeader('Cache-Control', 'no-cache');
    res.setHeader('Connection', 'keep-alive');

    const sendEvent = (data) => {
        res.write(`data: ${JSON.stringify(data)}\n\n`);
    };

    eventEmitter.on('update', sendEvent);
    req.on('close', () => eventEmitter.off('update', sendEvent));
});
```

### Q5: Design an e-commerce checkout.

**Answer:**
```
Components:
1. Cart Service
2. Inventory Service
3. Payment Service
4. Order Service
5. Notification Service

Flow:
1. User clicks checkout
2. Validate cart items
3. Check inventory
4. Reserve items
5. Process payment
6. Create order
7. Send confirmation email
8. Update inventory

Error Handling:
- Payment fails → Release inventory
- Inventory unavailable → Notify user
- Network error → Retry with backoff
```

---

## Behavioral Questions

### Q1: Tell me about a challenging project.

**Answer:**
Use STAR method:
- **Situation**: Context and background
- **Task**: Your responsibility
- **Action**: What you did
- **Result**: Outcome and learnings

Example:
"I worked on migrating a monolith to microservices. The challenge was maintaining uptime while splitting the codebase. I started by identifying bounded contexts, then extracted services one by one using the strangler fig pattern. We achieved zero downtime and reduced deployment time by 60%."

### Q2: How do you handle disagreements?

**Answer:**
- Listen to understand all perspectives
- Focus on data and facts
- Propose experiments or A/B tests
- Document decisions and rationale
- Support team decision even if disagreeing

### Q3: How do you stay updated?

**Answer:**
- Follow tech blogs and newsletters
- Join communities (Dev.to, Reddit)
- Attend meetups and conferences
- Contribute to open source
- Build side projects
- Take online courses

### Q4: Describe a time you failed.

**Answer:**
- Be honest about the failure
- Explain what you learned
- Show how you improved
- Demonstrate growth mindset

### Q5: Why should we hire you?

**Answer:**
- Technical skills match requirements
- Problem-solving ability
- Team collaboration
- Passion for learning
- Cultural fit

---

## Coding Challenges

### Challenge 1: Implement Promise.all

```javascript
function promiseAll(promises) {
    return new Promise((resolve, reject) => {
        const results = [];
        let completed = 0;

        if (promises.length === 0) {
            resolve(results);
            return;
        }

        promises.forEach((promise, index) => {
            Promise.resolve(promise)
                .then(result => {
                    results[index] = result;
                    completed++;
                    if (completed === promises.length) {
                        resolve(results);
                    }
                })
                .catch(reject);
        });
    });
}
```

### Challenge 2: Implement debounce

```javascript
function debounce(func, delay) {
    let timeoutId;

    return function (...args) {
        clearTimeout(timeoutId);
        timeoutId = setTimeout(() => {
            func.apply(this, args);
        }, delay);
    };
}
```

### Challenge 3: Deep clone object

```javascript
function deepClone(obj) {
    if (obj === null || typeof obj !== 'object') {
        return obj;
    }

    if (obj instanceof Date) {
        return new Date(obj.getTime());
    }

    if (obj instanceof Array) {
        return obj.map(item => deepClone(item));
    }

    const cloned = {};
    for (const key in obj) {
        if (obj.hasOwnProperty(key)) {
            cloned[key] = deepClone(obj[key]);
        }
    }
    return cloned;
}
```

### Challenge 4: Implement rate limiter

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

        if (!this.requests.has(key)) {
            this.requests.set(key, []);
        }

        const timestamps = this.requests.get(key);
        while (timestamps.length > 0 && timestamps[0] <= windowStart) {
            timestamps.shift();
        }

        if (timestamps.length >= this.maxRequests) {
            return false;
        }

        timestamps.push(now);
        return true;
    }
}
```

### Challenge 5: Implement LRU cache

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
        const value = this.cache.get(key);
        this.cache.delete(key);
        this.cache.set(key, value);
        return value;
    }

    put(key, value) {
        if (this.cache.has(key)) {
            this.cache.delete(key);
        } else if (this.cache.size >= this.capacity) {
            const firstKey = this.cache.keys().next().value;
            this.cache.delete(firstKey);
        }
        this.cache.set(key, value);
    }
}
```

---

## Project-Based Questions

### Q1: Walk me through your e-commerce project.

**Answer:**
Structure your response:
1. **Overview**: What it does, tech stack
2. **Architecture**: Frontend, backend, database
3. **Key Features**: Product catalog, cart, checkout
4. **Challenges**: Payment integration, inventory management
5. **Solutions**: How you solved them
6. **Results**: Metrics, learnings

### Q2: How did you handle authentication?

**Answer:**
- JWT tokens with refresh tokens
- HTTP-only cookies for security
- Role-based access control
- Session management
- Password hashing with bcrypt

### Q3: How did you test your application?

**Answer:**
- Unit tests: Jest for business logic
- Integration tests: Supertest for APIs
- E2E tests: Cypress for user flows
- Test coverage: Maintained 80%+
- CI/CD: Automated testing pipeline

### Q4: How did you deploy your application?

**Answer:**
- Frontend: Vercel/Netlify
- Backend: Railway/Render
- Database: Supabase/Neon
- CI/CD: GitHub Actions
- Monitoring: Sentry, LogRocket

### Q5: What would you do differently?

**Answer:**
- Start with TypeScript from day one
- Implement comprehensive logging earlier
- Set up CI/CD before feature development
- Write more integration tests
- Use a monorepo for better code sharing
