# 12. Low-Level Design (LLD)

## Overview

Low-Level Design (LLD) is the detailed design phase where high-level system architecture is translated into detailed, class-level specifications. It defines the internal components, their relationships, data structures, and algorithms that implement the system's functionality.

---

## Why LLD Matters

| Aspect | High-Level Design | Low-Level Design |
|--------|------------------|------------------|
| **Scope** | System-wide architecture | Module/class level |
| **Abstraction** | Broad strokes | Detailed specifications |
| **Output** | Block diagrams, component maps | Class diagrams, sequence diagrams |
| **Focus** | What the system does | How each component works internally |
| **Audience** | Architects, stakeholders | Developers, engineers |

---

## Files in This Section

| File | Description |
|------|-------------|
| [lld-guide.md](lld-guide.md) | Complete guide to approaching LLD problems |
| [lld-principles.md](lld-principles.md) | Core principles and SOLID design rules |
| [lld-common-problems.md](lld-common-problems.md) | Common LLD interview problems with solutions |
| [lld-tips.md](lld-tips.md) | Tips and tricks for LLD interviews |

---

## The LLD Problem-Solving Framework

```
Step 1: Clarify Requirements
    └── Ask about scale, features, constraints

Step 2: Identify Core Entities
    └── Define the main objects in the system

Step 3: Define Relationships
    └── How entities relate to each other (1:1, 1:N, M:N)

Step 4: Design APIs
    └── Define the public interface for each component

Step 5: Create Class Diagrams
    └── Draw UML-style class relationships

Step 6: Design Data Models
    └── Database schemas, storage structures

Step 7: Handle Edge Cases
    └── Concurrency, error handling, scaling
```

---

## Key Topics

### Design Principles
- SOLID Principles
- DRY (Don't Repeat Yourself)
- KISS (Keep It Simple, Stupid)
- YAGNI (You Aren't Gonna Need It)
- Composition over Inheritance

### Design Patterns
- Creational: Factory, Singleton, Builder
- Structural: Adapter, Decorator, Proxy
- Behavioral: Observer, Strategy, Command

### Common LLD Problems
- Parking Lot System
- Elevator System
- Chess Game
- Traffic Light Controller
- Library Management System
- Hotel Booking System

---

## Prerequisites

Before diving into LLD, ensure you have a solid understanding of:

1. **Object-Oriented Programming** → [13-Object-Oriented-Programming](../13-Object-Oriented-Programming/)
2. **Design Patterns** → [14-Design-Patterns](../14-Design-Patterns/)
3. **Data Structures** → Arrays, Hash Maps, Trees, Graphs
4. **Concurrency** → Threads, locks, synchronization

---

## Interview Tips

1. **Always start by asking clarifying questions** — never assume requirements
2. **Think out loud** — interviewers want to see your reasoning process
3. **Start simple, then iterate** — begin with a basic design, then add complexity
4. **Use real-world analogies** — explain your design as if teaching someone
5. **Know trade-offs** — every design decision has pros and cons

---

## Recommended Study Order

```
1. Read lld-principles.md (understand the foundation)
2. Study lld-guide.md (learn the methodology)
3. Practice lld-common-problems.md (apply knowledge)
4. Review lld-tips.md (polish interview technique)
5. Read ../13-Object-Oriented-Programming/ (strengthen OOP)
6. Study ../14-Design-Patterns/ (learn reusable solutions)
```

---

## Resources

- *Designing Data-Intensive Applications* by Martin Kleppmann
- *Head First Design Patterns* by Eric Freeman
- *Clean Architecture* by Robert C. Martin
- *System Design Interview* by Alex Xu
