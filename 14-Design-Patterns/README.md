# 14. Design Patterns

## Overview

Design Patterns are reusable solutions to commonly occurring problems in software design. They are templates for solving problems that can be adapted to many different situations. The 23 Gang of Four (GoF) patterns are generally considered the foundation for all other patterns.

---

## Files in This Section

| File | Description |
|------|-------------|
| [design-patterns-guide.md](design-patterns-guide.md) | Complete overview of all 23 GoF patterns |
| [creational-patterns.md](creational-patterns.md) | Singleton, Factory, Abstract Factory, Builder, Prototype |
| [structural-patterns.md](structural-patterns.md) | Adapter, Decorator, Proxy, Facade, Composite, Bridge |
| [behavioral-patterns.md](behavioral-patterns.md) | Observer, Strategy, Command, State, Iterator, Template |

---

## Pattern Categories

```
┌─────────────────────────────────────────────────────────┐
│                   Design Patterns                        │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │  CREATIONAL   │  │  STRUCTURAL   │  │  BEHAVIORAL   │  │
│  │              │  │              │  │              │  │
│  │ Singleton    │  │ Adapter      │  │ Observer     │  │
│  │ Factory      │  │ Decorator    │  │ Strategy     │  │
│  │ Abs. Factory │  │ Proxy        │  │ Command      │  │
│  │ Builder      │  │ Facade       │  │ State        │  │
│  │ Prototype    │  │ Composite    │  │ Iterator     │  │
│  │              │  │ Bridge       │  │ Template     │  │
│  │ Focus:       │  │ Flyweight    │  │ Mediator     │  │
│  │ Object       │  │              │  │ Chain of Resp│  │
│  │ Creation     │  │ Focus:       │  │ Visitor      │  │
│  │              │  │ Object       │  │ Memento      │  │
│  │              │  │ Composition  │  │              │  │
│  │              │  │              │  │ Focus:       │  │
│  │              │  │              │  │ Object       │  │
│  │              │  │              │  │ Communication│  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Pattern Selection Guide

| Problem | Recommended Pattern | Category |
|---------|-------------------|----------|
| Need single instance | Singleton | Creational |
| Create objects without specifying class | Factory | Creational |
| Complex object construction | Builder | Creational |
| Need to clone objects | Prototype | Creational |
| Incompatible interfaces | Adapter | Structural |
| Add responsibilities dynamically | Decorator | Structural |
| Control access to object | Proxy | Structural |
| Simplify complex subsystem | Facade | Structural |
| Treat individual/composite uniformly | Composite | Structural |
| Bridge abstraction from implementation | Bridge | Structural |
| One-to-many notification | Observer | Behavioral |
| Algorithm selection at runtime | Strategy | Behavioral |
| Encapsulate requests as objects | Command | Behavioral |
| Object behavior changes with state | State | Behavioral |
| Sequential access to collection | Iterator | Behavioral |
| Define skeleton, defer steps | Template | Behavioral |
| Centralize complex communications | Mediator | Behavioral |
| Chain of processing objects | Chain of Responsibility | Behavioral |
| Add operations without modifying | Visitor | Behavioral |
| Save/restore object state | Memento | Behavioral |

---

## Prerequisites

- Solid understanding of OOP → [13-Object-Oriented-Programming](../13-Object-Oriented-Programming/)
- Understanding of LLD principles → [12-Low-Level-Design](../12-Low-Level-Design/)
- Familiarity with Python or Java

---

## Study Path

```
1. Start with design-patterns-guide.md (overview)
2. Study creational-patterns.md (object creation)
3. Study structural-patterns.md (object composition)
4. Study behavioral-patterns.md (object communication)
5. Apply patterns in → ../12-Low-Level-Design/
6. Master OOP fundamentals → ../13-Object-Oriented-Programming/
```

---

## When to Use (and Not Use) Design Patterns

### Use Patterns When:
- The problem matches a known pattern's intent
- You need a proven, tested solution
- You want to communicate design ideas efficiently
- Flexibility and extensibility are needed

### Don't Use Patterns When:
- Simple solution works (YAGNI)
- Pattern adds unnecessary complexity
- You're using it just for the sake of patterns
- The overhead isn't justified by the benefits

---

## Resources

- *Design Patterns: Elements of Reusable Object-Oriented Software* (GoF Book)
- *Head First Design Patterns* by Eric Freeman
- *Pattern-Oriented Software Architecture* by Buschmann
- Refactoring.Guru - https://refactoring.guru/design-patterns
