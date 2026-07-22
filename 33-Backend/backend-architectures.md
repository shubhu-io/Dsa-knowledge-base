# Backend Architecture Patterns

## Table of Contents

1. [Monolithic Architecture](#monolithic-architecture)
2. [Microservices Architecture](#microservices-architecture)
3. [Event-Driven Architecture](#event-driven-architecture)
4. [Clean Architecture](#clean-architecture)
5. [Domain-Driven Design](#domain-driven-design)
6. [Serverless Architecture](#serverless-architecture)
7. [Service Mesh](#service-mesh)
8. [Architecture Decision Framework](#architecture-decision-framework)

---

## Monolithic Architecture

### Overview

A monolithic architecture is a single, unified application where all components run as one unit.

```
┌─────────────────────────────────────────────────┐
│                  MONOLITH                        │
├─────────────┬─────────────┬─────────────────────┤
│  Web Layer  │  Business   │  Data Access Layer  │
│  (Routes)   │  Logic      │  (ORM/SQL)          │
├─────────────┴─────────────┴─────────────────────┤
│              Single Database                     │
└─────────────────────────────────────────────────┘
```

### Pros and Cons

| Pros | Cons |
|------|------|
| Simple to develop | Hard to scale individually |
| Easy to deploy | Single point of failure |
| Simple debugging | Technology lock-in |
| Low latency (in-process) | Large codebase |
| ACID transactions | Difficult to understand |

### When to Use

- Startups and MVPs
- Small teams (< 10 developers)
- Simple domains
- Quick time-to-market

---

## Microservices Architecture

### Overview

Microservices decompose applications into small, independent services that communicate over the network.

```
┌──────────┐  ┌──────────┐  ┌──────────┐
│  User    │  │  Order   │  │ Product  │
│ Service  │  │ Service  │  │ Service  │
└────┬─────┘  └────┬─────┘  └────┬─────┘
     │             │             │
┌────▼─────┐  ┌────▼─────┐  ┌────▼─────┐
│ User DB  │  │ Order DB │  │Product DB│
└──────────┘  └──────────┘  └──────────┘
```

### Implementation Example

```javascript
// User Service
const express = require('express');
const app = express();

app.get('/api/users/:id', async (req, res) => {
    const user = await User.findById(req.params.id);
    if (!user) return res.status(404).json({ error: 'User not found' });
    res.json(user);
});

app.post('/api/users', async (req, res) => {
    const user = await User.create(req.body);
    // Publish event
    await messageQueue.publish('user.created', user);
    res.status(201).json(user);
});

// Order Service (consumes user events)
const consumer = kafka.consumer({ groupId: 'order-service' });

await consumer.run({
    eachMessage: async ({ message }) => {
        const event = JSON.parse(message.value.toString());
        if (event.type === 'user.created') {
            await OrderService.initializeUserOrders(event.userId);
        }
    }
});
```

### Communication Patterns

```javascript
// Synchronous (HTTP/gRPC)
const response = await axios.get('http://user-service/api/users/123');

// Asynchronous (Message Queue)
await messageQueue.publish('order.created', {
    orderId: 123,
    userId: 456,
    items: [...]
});

// Event Sourcing
await eventStore.append({
    stream: 'order-123',
    type: 'OrderCreated',
    data: { orderId: 123, userId: 456 }
});
```

### Pros and Cons

| Pros | Cons |
|------|------|
| Independent deployment | Distributed complexity |
| Technology flexibility | Network latency |
| Scalable per service | Data consistency challenges |
| Fault isolation | Operational overhead |
| Team autonomy | Testing complexity |

---

## Event-Driven Architecture

### Overview

Event-driven architecture uses events to communicate between decoupled services.

```
┌─────────┐    ┌─────────┐    ┌─────────┐
│Producer │───▶│  Event  │───▶│Consumer │
│Service  │    │  Bus    │    │ Service │
└─────────┘    └─────────┘    └─────────┘
                    │
                    ▼
              ┌─────────┐
              │Consumer │
              │ Service │
              └─────────┘
```

### Event Types

```javascript
// Domain Event
{
    "eventId": "uuid-123",
    "eventType": "OrderCreated",
    "timestamp": "2024-01-15T10:30:00Z",
    "aggregateId": "order-456",
    "data": {
        "orderId": "order-456",
        "userId": "user-123",
        "items": [...],
        "total": 99.99
    },
    "metadata": {
        "correlationId": "req-789",
        "causationId": "cmd-012"
    }
}

// Integration Event
{
    "eventType": "OrderShipped",
    "source": "order-service",
    "data": {
        "orderId": "order-456",
        "trackingNumber": "1Z999AA10123456784"
    }
}
```

### Event Sourcing

```javascript
// Event Store
class EventStore {
    async append(streamId, events) {
        const position = await this.getLastPosition(streamId);
        const eventsWithPosition = events.map((event, index) => ({
            ...event,
            position: position + index + 1,
            timestamp: new Date()
        }));

        await this.db.events.insertMany(eventsWithPosition);
        await this.publishToSubscribers(streamId, eventsWithPosition);
    }

    async getStream(streamId) {
        return this.db.events
            .find({ streamId })
            .sort({ position: 1 });
    }
}

// Aggregate
class OrderAggregate {
    constructor() {
        this.state = {};
        this.changes = [];
    }

    apply(event) {
        switch (event.type) {
            case 'OrderCreated':
                this.state = { ...event.data, status: 'created' };
                break;
            case 'OrderPaid':
                this.state.status = 'paid';
                break;
            case 'OrderShipped':
                this.state.status = 'shipped';
                break;
        }
    }

    createOrder(data) {
        const event = {
            type: 'OrderCreated',
            data
        };
        this.apply(event);
        this.changes.push(event);
    }
}
```

### Pros and Cons

| Pros | Cons |
|------|------|
| Loose coupling | Eventual consistency |
| Scalability | Complex debugging |
| Audit trail | Event versioning |
| Temporal queries | Storage growth |
| Replay capability | Learning curve |

---

## Clean Architecture

### Overview

Clean Architecture separates concerns into concentric layers with dependencies pointing inward.

```
┌─────────────────────────────────────┐
│         Frameworks & Drivers        │ ← Outer Layer
│  ┌─────────────────────────────┐    │
│  │      Interface Adapters      │    │ ← Middle Layer
│  │  ┌─────────────────────┐    │    │
│  │  │    Use Cases         │    │    │ ← Inner Layer
│  │  │  ┌─────────────┐    │    │    │
│  │  │  │   Entities   │    │    │    │ ← Core
│  │  │  └─────────────┘    │    │    │
│  │  └─────────────────────┘    │    │
│  └─────────────────────────────┘    │
└─────────────────────────────────────┘
```

### Implementation

```typescript
// Entities (Core)
interface User {
    id: string;
    email: string;
    name: string;
    createdAt: Date;
}

interface UserRepository {
    findById(id: string): Promise<User | null>;
    findByEmail(email: string): Promise<User | null>;
    save(user: User): Promise<User>;
    delete(id: string): Promise<void>;
}

// Use Cases
class CreateUserUseCase {
    constructor(private userRepository: UserRepository) {}

    async execute(input: CreateUserInput): Promise<User> {
        const existingUser = await this.userRepository.findByEmail(input.email);
        if (existingUser) {
            throw new Error('Email already exists');
        }

        const user: User = {
            id: generateId(),
            email: input.email,
            name: input.name,
            createdAt: new Date()
        };

        return this.userRepository.save(user);
    }
}

// Interface Adapters (Controllers)
class UserController {
    constructor(private createUserUseCase: CreateUserUseCase) {}

    async create(req: Request, res: Response) {
        try {
            const user = await this.createUserUseCase.execute({
                email: req.body.email,
                name: req.body.name
            });
            res.status(201).json(user);
        } catch (error) {
            res.status(400).json({ error: error.message });
        }
    }
}

// Frameworks & Drivers (Infrastructure)
class PostgresUserRepository implements UserRepository {
    constructor(private db: Database) {}

    async findById(id: string): Promise<User | null> {
        const result = await this.db.query(
            'SELECT * FROM users WHERE id = $1',
            [id]
        );
        return result.rows[0] || null;
    }

    async save(user: User): Promise<User> {
        await this.db.query(
            'INSERT INTO users (id, email, name, created_at) VALUES ($1, $2, $3, $4)',
            [user.id, user.email, user.name, user.createdAt]
        );
        return user;
    }
}
```

### Dependency Rule

```typescript
// ❌ Bad: Inner layer depends on outer layer
class CreateUserUseCase {
    constructor(private db: PostgresDatabase) {} // Depends on infrastructure
}

// ✅ Good: Inner layer defines interface
class CreateUserUseCase {
    constructor(private userRepository: UserRepository) {} // Depends on interface
}
```

---

## Domain-Driven Design

### Strategic Design

```
Domain
├── Bounded Contexts
│   ├── User Management
│   ├── Order Management
│   └── Inventory Management
│
├── Context Map
│   ├── User Context ──▶ Order Context (Customer ID)
│   └── Order Context ──▶ Inventory Context (Product IDs)
│
└── Ubiquitous Language
    ├── User, Account, Profile
    ├── Order, Cart, Checkout
    └── Product, Stock, Warehouse
```

### Tactical Patterns

```typescript
// Value Object
class Money {
    constructor(
        public readonly amount: number,
        public readonly currency: string
    ) {
        if (amount < 0) throw new Error('Amount cannot be negative');
    }

    add(other: Money): Money {
        if (this.currency !== other.currency) {
            throw new Error('Cannot add different currencies');
        }
        return new Money(this.amount + other.amount, this.currency);
    }

    equals(other: Money): boolean {
        return this.amount === other.amount && this.currency === other.currency;
    }
}

// Entity
class Order {
    private items: OrderItem[] = [];
    private status: OrderStatus = 'pending';

    constructor(
        public readonly id: string,
        public readonly userId: string
    ) {}

    addItem(product: Product, quantity: number): void {
        if (this.status !== 'pending') {
            throw new Error('Cannot modify order after processing');
        }
        this.items.push(new OrderItem(product, quantity));
    }

    calculateTotal(): Money {
        return this.items.reduce(
            (total, item) => total.add(item.subtotal),
            new Money(0, 'USD')
        );
    }

    submit(): void {
        if (this.items.length === 0) {
            throw new Error('Cannot submit empty order');
        }
        this.status = 'submitted';
    }
}

// Aggregate Root
class OrderAggregate {
    private order: Order;
    private events: DomainEvent[] = [];

    constructor(order: Order) {
        this.order = order;
    }

    addItem(product: Product, quantity: number): void {
        this.order.addItem(product, quantity);
        this.events.push({
            type: 'ItemAdded',
            data: { orderId: this.order.id, productId: product.id }
        });
    }

    submit(): void {
        this.order.submit();
        this.events.push({
            type: 'OrderSubmitted',
            data: { orderId: this.order.id }
        });
    }

    getUncommittedEvents(): DomainEvent[] {
        return [...this.events];
    }
}
```

---

## Serverless Architecture

### Overview

Serverless architecture abstracts infrastructure management, focusing on code deployment.

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│    API       │     │   Lambda     │     │   DynamoDB   │
│   Gateway    │────▶│  Functions   │────▶│   Database   │
└──────────────┘     └──────────────┘     └──────────────┘
                            │
                            ▼
                     ┌──────────────┐
                     │     SQS      │
                     │    Queue     │
                     └──────────────┘
```

### AWS Lambda Example

```javascript
// handler.js
const { DynamoDBClient } = require('@aws-sdk/client-dynamodb');
const { DynamoDBDocumentClient, PutCommand } = require('@aws-sdk/lib-dynamodb');

const client = new DynamoDBClient({});
const docClient = DynamoDBDocumentClient.from(client);

exports.createUser = async (event) => {
    const { name, email } = JSON.parse(event.body);

    const user = {
        id: Date.now().toString(),
        name,
        email,
        createdAt: new Date().toISOString()
    };

    await docClient.send(new PutCommand({
        TableName: process.env.TABLE_NAME,
        Item: user
    }));

    return {
        statusCode: 201,
        headers: {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        },
        body: JSON.stringify(user)
    };
};

// serverless.yml
service: my-api

provider:
  name: aws
  runtime: nodejs18.x
  region: us-east-1
  environment:
    TABLE_NAME: ${self:service}-users

functions:
  createUser:
    handler: handler.createUser
    events:
      - httpApi:
          path: /users
          method: POST

resources:
  Resources:
    UsersTable:
      Type: AWS::DynamoDB::Table
      Properties:
        TableName: ${self:provider.environment.TABLE_NAME}
        BillingMode: PAY_PER_REQUEST
        AttributeDefinitions:
          - AttributeName: id
            AttributeType: S
        KeySchema:
          - AttributeName: id
            KeyType: HASH
```

### Pros and Cons

| Pros | Cons |
|------|------|
| No server management | Cold starts |
| Auto-scaling | Vendor lock-in |
| Pay per use | Debugging difficulty |
| High availability | Execution limits |
| Reduced operational cost | State management |

---

## Service Mesh

### Overview

A service mesh provides infrastructure layer for service-to-service communication.

```
┌─────────────────────────────────────────────┐
│                  Service Mesh                │
├─────────────────────────────────────────────┤
│  ┌─────────┐  ┌─────────┐  ┌─────────┐    │
│  │  User   │  │  Order  │  │ Product │    │
│  │ Service │  │ Service │  │ Service │    │
│  └────┬────┘  └────┬────┘  └────┬────┘    │
│       │             │            │         │
│  ┌────▼────┐  ┌────▼────┐  ┌────▼────┐    │
│  │  Sidecar │  │  Sidecar │  │  Sidecar │   │
│  │  Proxy   │  │  Proxy   │  │  Proxy   │   │
│  └─────────┘  └─────────┘  └─────────┘    │
└─────────────────────────────────────────────┘
```

### Istio Configuration

```yaml
# Virtual Service
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: user-service
spec:
  hosts:
  - user-service
  http:
  - route:
    - destination:
        host: user-service
        subset: v1
      weight: 90
    - destination:
        host: user-service
        subset: v2
      weight: 10

# Destination Rule
apiVersion: networking.istio.io/v1beta1
kind: DestinationRule
metadata:
  name: user-service
spec:
  host: user-service
  subsets:
  - name: v1
    labels:
      version: v1
  - name: v2
    labels:
      version: v2

# Circuit Breaker
apiVersion: networking.istio.io/v1beta1
kind: DestinationRule
metadata:
  name: user-service-circuit-breaker
spec:
  host: user-service
  trafficPolicy:
    connectionPool:
      tcp:
        maxConnections: 100
      http:
        h2UpgradePolicy: DEFAULT
        http1MaxPendingRequests: 100
        http2MaxRequests: 1000
    outlierDetection:
      consecutive5xxErrors: 5
      interval: 30s
      baseEjectionTime: 3m
      maxEjectionPercent: 100
```

---

## Architecture Decision Framework

### Decision Matrix

| Factor | Monolith | Microservices | Serverless |
|--------|----------|---------------|------------|
| Team Size | < 10 | 10-100+ | Any |
| Complexity | Low | High | Medium |
| Scalability | Limited | High | Auto |
| Deployment | Simple | Complex | Simple |
| Cost | Predictable | Variable | Pay-per-use |
| Latency | Low | Medium-High | Variable |

### When to Choose What

```
Starting Point:
│
├── MVP/Startup?
│   └── Monolith
│
├── Growing team?
│   ├── 10-30 developers → Modular Monolith
│   └── 30+ developers → Microservices
│
├── Variable load?
│   └── Serverless or Auto-scaling Microservices
│
├── Need for independence?
│   ├── Team independence → Microservices
│   └── Deployment independence → Microservices
│
└── Regulatory requirements?
    └── Consider compliance needs
```

### Migration Path

```
1. Start: Monolith
2. Extract: Shared libraries
3. Modularize: Define bounded contexts
4. Split: Extract services for high-change areas
5. Optimize: Add caching, message queues
6. Scale: Kubernetes, service mesh
```

---

## Common Interview Questions

### Q1: When would you choose microservices over a monolith?

**Answer:**
Choose microservices when: large team needing independence, different scaling requirements per service, need for technology flexibility, or complex domain with clear bounded contexts. Choose monolith for: small teams, simple domains, quick MVP, or limited operational resources.

### Q2: Explain the CAP theorem with examples.

**Answer:**
- **CP** (Consistency + Partition Tolerance): MongoDB with majority write concern, HBase
- **AP** (Availability + Partition Tolerance): Cassandra, DynamoDB
- **CA** (Consistency + Availability): Traditional RDBMS (no partition tolerance)

### Q3: What is eventual consistency?

**Answer:**
Eventual consistency means that after a write, subsequent reads may return old values temporarily, but will eventually return the new value. It's a trade-off for higher availability and partition tolerance in distributed systems.

### Q4: How do you handle distributed transactions?

**Answer:**
- Saga pattern (choreography or orchestration)
- Two-phase commit (2PC)
- Event sourcing with eventual consistency
- Outbox pattern
- Compensation for failures

### Q5: What is the strangler fig pattern?

**Answer:**
The strangler fig pattern is a migration strategy where you gradually replace parts of a monolith with microservices. You build new features as services while keeping existing functionality in the monolith, eventually "strangling" the old system.
