# Design Patterns — Complete Guide

## What Are Design Patterns?

Design patterns are **reusable solutions** to commonly occurring problems in software design. They are not finished code but templates that describe how to solve a problem in many different situations.

---

## The Gang of Four (GoF) Classification

### 1. Creational Patterns — How objects are created

| Pattern | Intent | Key Benefit |
|---------|--------|-------------|
| **Singleton** | Ensure single instance | Global state management |
| **Factory Method** | Create objects without specifying class | Loose coupling |
| **Abstract Factory** | Create families of related objects | Consistency |
| **Builder** | Construct complex objects step by step | Flexible construction |
| **Prototype** | Clone existing objects | Performance, simplicity |

### 2. Structural Patterns — How objects are composed

| Pattern | Intent | Key Benefit |
|---------|--------|-------------|
| **Adapter** | Interface compatibility | Legacy integration |
| **Decorator** | Add responsibilities dynamically | Open/closed principle |
| **Proxy** | Control access to object | Lazy loading, security |
| **Facade** | Simplify complex subsystems | Easy interface |
| **Composite** | Treat individual/composite uniformly | Tree structures |
| **Bridge** | Separate abstraction from implementation | Platform independence |
| **Flyweight** | Share common state efficiently | Memory optimization |

### 3. Behavioral Patterns — How objects communicate

| Pattern | Intent | Key Benefit |
|---------|--------|-------------|
| **Observer** | One-to-many notification | Loose coupling |
| **Strategy** | Algorithm selection at runtime | Flexibility |
| **Command** | Encapsulate requests as objects | Undo, queuing |
| **State** | Behavior changes with state | State machines |
| **Iterator** | Sequential access without exposing internals | Uniform traversal |
| **Template** | Define skeleton, defer steps | Code reuse |
| **Mediator** | Centralize complex communications | Reduced dependencies |
| **Chain of Responsibility** | Chain of processing objects | Flexible processing |
| **Visitor** | Add operations without modifying classes | Open/closed |
| **Memento** | Save/restore object state | Undo/redo |

---

## Pattern Relationships

```
Creational Patterns
├── Factory Method ──→ creates objects ──→ used by Abstract Factory, Singleton, Prototype
├── Abstract Factory ──→ uses ──→ Factory Method
├── Builder ──→ creates complex objects ──→ uses Composite
├── Prototype ──→ clones objects ──→ uses Composite
└── Singleton ──→ single instance ──→ used by many patterns

Structural Patterns
├── Adapter ──→ wraps object ──→ uses Bridge
├── Decorator ──→ wraps object ──→ uses Composite
├── Proxy ──→ controls access ──→ uses Decorator
├── Facade ──→ simplifies subsystem ──→ uses Adapter
├── Composite ──→ tree structure ──→ uses Decorator
├── Bridge ──→ separates concerns ──→ uses Adapter
└── Flyweight ──→ shares state ──→ uses Composite

Behavioral Patterns
├── Observer ──→ notification ──→ uses Mediator
├── Strategy ──→ algorithm selection ──→ uses Composite
├── Command ──→ request encapsulation ──→ uses Memento
├── State ──→ state management ──→ uses Strategy
├── Iterator ──→ traversal ──→ uses Composite
├── Template ──→ skeleton algorithm ──→ uses Factory Method
├── Mediator ──→ communication hub ──→ uses Observer
├── Chain of Responsibility ──→ processing chain ──→ uses Composite
├── Visitor ──→ operations ──→ uses Composite
└── Memento ──→ state preservation ──→ uses Command
```

---

## Quick Decision Flowchart

```
START
│
├── Need to create objects?
│   ├── Single instance needed? ──→ Singleton
│   ├── Family of objects? ──→ Abstract Factory
│   ├── Complex construction? ──→ Builder
│   ├── Need to clone? ──→ Prototype
│   └── Don't know exact type? ──→ Factory Method
│
├── Need to compose objects?
│   ├── Incompatible interfaces? ──→ Adapter
│   ├── Add responsibilities? ──→ Decorator
│   ├── Control access? ──→ Proxy
│   ├── Simplify subsystem? ──→ Facade
│   ├── Tree structure? ──→ Composite
│   ├── Separate abstraction? ──→ Bridge
│   └── Memory optimization? ──→ Flyweight
│
└── Need to handle communication?
    ├── One-to-many updates? ──→ Observer
    ├── Switch algorithms? ──→ Strategy
    ├── Undo/redo? ──→ Command
    ├── State-dependent behavior? ──→ State
    ├── Sequential access? ──→ Iterator
    ├── Define algorithm skeleton? ──→ Template
    ├── Centralize communication? ──→ Mediator
    ├── Chain of processing? ──→ Chain of Responsibility
    ├── Add operations? ──→ Visitor
    └── Save/restore state? ──→ Memento
```

---

## Real-World Pattern Usage

| System | Patterns Used |
|--------|--------------|
| **Web Framework** | Factory (views), Observer (events), Strategy (auth) |
| **Game Engine** | Singleton (engine), Command (input), State (AI) |
| **E-Commerce** | Factory (products), Strategy (payment), Observer (notifications) |
| **IDE** | Composite (file tree), Decorator (features), Command (operations) |
| **Database ORM** | Factory (models), Proxy (lazy loading), Strategy (query) |
| **Chat App** | Observer (messages), Mediator (chat room), Strategy (encryption) |

---

## Common Interview Combinations

In LLD interviews, patterns are rarely used alone. Common combinations:

```
Parking Lot: Singleton + Factory + Strategy + Observer
Elevator: State + Observer + Strategy + Mediator
Chess: Command + Strategy + Composite + Memento
Chat App: Observer + Mediator + Factory + Command
E-Commerce: Factory + Strategy + Observer + Decorator
```

---

## Anti-Patterns

| Anti-Pattern | Description | Solution |
|-------------|-------------|----------|
| **Pattern Overuse** | Using patterns everywhere | Use only when justified |
| **Gold Plating** | Adding unnecessary complexity | Follow YAGNI |
| **Copy-Paste Pattern** | Duplicating pattern code | Abstract common elements |
| **Wrong Pattern** | Pattern doesn't fit the problem | Understand intent first |

---

## Best Practices

1. **Understand the problem first** before choosing a pattern
2. **Know the intent** — why does this pattern exist?
3. **Learn the trade-offs** — every pattern has pros and cons
4. **Don't force patterns** — simple solutions are often better
5. **Combine wisely** — patterns work together, not in isolation
6. **Practice implementation** — read code, write code
7. **Know when NOT to use** — over-engineering is worse than no patterns
