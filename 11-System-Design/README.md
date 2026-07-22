# System Design

System design is the process of defining architecture, components, modules, interfaces, and data for a system to satisfy specified requirements. It is a critical skill for senior engineers and a key topic in technical interviews.

## What You'll Find Here

- **System Design Guide** — Comprehensive foundation for designing scalable systems
- **Scalability Patterns** — Techniques for handling growth in users, data, and traffic
- **Distributed Systems** — Core concepts for building reliable distributed architectures
- **System Design Interview Questions** — Practice problems with detailed solutions
- **Real-World Systems** — How popular services are designed at scale

## Core Concepts

```
                     SYSTEM DESIGN
                          |
          +---------------+---------------+
          |               |               |
      SCALABILITY    RELIABILITY     PERFORMANCE
          |               |               |
    +-----+-----+   +----+----+    +----+----+
    |     |     |   |    |    |    |    |    |
  Horiz Vert  CDNs  Redund Replic FTLB Cache
```

## Key Topics

| Topic | Description | Difficulty |
|-------|------------|-----------|
| Load Balancing | Distributing traffic across servers | Beginner |
| Caching | Temporary storage for fast access | Beginner |
| Database Sharding | Partitioning data across databases | Intermediate |
| Message Queues | Asynchronous communication | Intermediate |
| CAP Theorem | Consistency, Availability, Partition tolerance | Intermediate |
| Microservices | Independent, loosely coupled services | Intermediate |
| Consistent Hashing | Even data distribution | Advanced |
| CRDTs | Conflict-free replicated data types | Advanced |

## Architecture Patterns

| Pattern | Use Case | Pros | Cons |
|---------|----------|------|------|
| Monolith | Small teams, MVPs | Simple, fast to build | Hard to scale |
| Microservices | Large systems | Independent scaling | Complexity overhead |
| Serverless | Event-driven | No infrastructure mgmt | Vendor lock-in |
| Event-Driven | Real-time systems | Loose coupling | Eventual consistency |
| CQRS | Read-heavy systems | Optimized read/write | Complexity |

## The 5-Step Design Process

1. **Understand Requirements** — Functional + non-functional
2. **High-Level Design** — Major components and data flow
3. **Deep Dive** — APIs, database schema, algorithms
4. **Scale & Optimize** — Handle growth and bottlenecks
5. **Discuss Trade-offs** — Consistency vs availability, cost vs performance

## Common Numbers to Know

| Metric | Value |
|--------|-------|
| L1 cache reference | 0.5 ns |
| L2 cache reference | 7 ns |
| Main memory reference | 100 ns |
| SSD random read | 150 μs |
| HDD random read | 10 ms |
| Read 1 MB from memory | 250 μs |
| Read 1 MB from SSD | 1 ms |
| Read 1 MB from disk | 20 ms |
| Send 1 MB over network | 10 ms |
| Read from same datacenter | 0.5 ms |
| Read cross-continent | 150 ms |

## Files in This Directory

| File | Description |
|------|------------|
| `README.md` | This overview |
| `overview.md` | Introduction to system design |
| `system-design-guide.md` | Comprehensive design guide |
| `scalability-patterns.md` | Patterns for scaling systems |
| `distributed-systems.md` | Distributed systems concepts |
| `system-design-interview-questions.md` | Interview problems with solutions |
| `real-world-systems.md` | How popular services are designed |

## Recommended Resources

- **Books**: "Designing Data-Intensive Applications" by Martin Kleppmann
- **Books**: "System Design Interview" by Alex Xu
- **Courses**: MIT 6.824 Distributed Systems
- **Practice**: Mock system design interviews with peers
- **Reading**: High Scalability blog, Netflix Tech Blog, Uber Engineering Blog
