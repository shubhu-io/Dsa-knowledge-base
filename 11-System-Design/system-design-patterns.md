# System Design Patterns

## Architectural Patterns

### 1. Monolithic Architecture
Single codebase, all components together.
- **Pros**: Simple to develop, test, deploy
- **Cons**: Hard to scale, single point of failure
- **Use**: Small applications, MVPs

### 2. Microservices Architecture
Independent services communicating via APIs.
- **Pros**: Independent scaling, fault isolation
- **Cons**: Complexity, distributed transactions
- **Use**: Large-scale applications, teams

### 3. Serverless Architecture
Functions as a Service (FaaS).
- **Pros**: No server management, auto-scaling
- **Cons**: Cold start, vendor lock-in
- **Use**: Event-driven, variable workloads

## Design Patterns

### CQRS (Command Query Responsibility Segregation)
Separate read and write models.
```
Write Model → Database → Read Model
    ↓                         ↓
Commands                  Queries
```

### Event Sourcing
Store state changes as sequence of events.
```
Event Store → Current State
  ↓
Add Order
Ship Order
Deliver Order
```

### Circuit Breaker
Prevent cascade failures.
```
Closed → Open → Half-Open → Closed
  ↓        ↓         ↓
Normal   Fail    Testing
```

### Saga Pattern
Manage distributed transactions.
```
Order Service → Payment Service → Inventory Service
     ↓                ↓                ↓
  Create           Charge          Reserve
     ↓                ↓                ↓
  Success          Success          Success
```

### API Gateway Pattern
Single entry point for all clients.
```
Client → API Gateway → Service A
                    → Service B
                    → Service C
```

### Sidecar Pattern
Deploy helper components alongside main service.
```
┌─────────────┐
│   Service   │
├─────────────┤
│   Sidecar   │ ← Logging, Monitoring, Proxy
└─────────────┘
```

## Data Patterns

### Sharding
Split data across multiple databases.
```
User 1-1M → Shard 1
User 1-2M → Shard 2
User 2-3M → Shard 3
```

### Replication
Copy data for redundancy.
```
Primary DB → Replica 1
          → Replica 2
          → Replica 3
```

### CQRS + Event Sourcing
Combined pattern for complex systems.

## Scaling Patterns

### Horizontal Scaling
Add more machines.
```
Load Balancer → Server 1
             → Server 2
             → Server 3
```

### Database Scaling
- Read replicas
- Sharding
- Caching layer
- Connection pooling

## Resilience Patterns

### Retry with Backoff
```python
def retry(func, max_attempts=3):
    for attempt in range(max_attempts):
        try:
            return func()
        except Exception:
            if attempt < max_attempts - 1:
                time.sleep(2 ** attempt)
```

### Bulkhead Isolation
Isolate components to prevent failures.

### Timeout Pattern
Set maximum wait time for operations.

## References

- Enterprise Integration Patterns
- Building Microservices
- Release It!