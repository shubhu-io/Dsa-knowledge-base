# 13. Object-Oriented Programming (OOP)

## Overview

Object-Oriented Programming is a programming paradigm based on the concept of "objects" that contain data and code. OOP is fundamental to software design and a critical topic in technical interviews.

---

## Files in This Section

| File | Description |
|------|-------------|
| [oop-guide.md](oop-guide.md) | Complete guide to OOP concepts |
| [oop-principles.md](oop-principles.md) | Deep dive into the 4 pillars of OOP |
| [oop-examples.md](oop-examples.md) | Real-world code examples |
| [oop-interview-questions.md](oop-interview-questions.md) | Common OOP interview questions |

---

## The 4 Pillars of OOP

```
┌─────────────────────────────────────────────────┐
│           Object-Oriented Programming            │
├─────────────────────────────────────────────────┤
│  ┌───────────┐  ┌───────────┐  ┌────────────┐  │
│  │Encapsulation│  │Inheritance│  │Polymorphism│  │
│  │  (Hiding)  │  │ (Reusing) │  │ (Adapting) │  │
│  └───────────┘  └───────────┘  └────────────┘  │
│  ┌───────────────────────────────────────────┐  │
│  │         Abstraction (Simplifying)         │  │
│  └───────────────────────────────────────────┘  │
└─────────────────────────────────────────────────┘
```

---

## Key Concepts Quick Reference

| Concept | Definition | Example |
|---------|-----------|---------|
| **Class** | Blueprint for objects | `Car`, `Animal` |
| **Object** | Instance of a class | `my_car = Car()` |
| **Method** | Function inside a class | `car.start()` |
| **Attribute** | Variable inside a class | `car.color` |
| **Interface** | Contract of methods | `Shape.area()` |
| **Abstract Class** | Partial implementation | `Animal` with abstract `speak()` |
| **Constructor** | Object initializer | `__init__()` |
| **Destructor** | Object cleanup | `__del__()` |

---

## OOP vs Other Paradigms

| Feature | OOP | Procedural | Functional |
|---------|-----|-----------|------------|
| **Basic Unit** | Object | Function | Function |
| **Data Access** | Through methods | Global/free | Pure functions |
| **State** | Encapsulated in objects | Shared/global | Immutable |
| **Reusability** | Inheritance, composition | Copy/paste | Higher-order functions |
| **Real-world Modeling** | Natural | Manual | Abstract |
| **Examples** | Java, C++, Python | C, Pascal | Haskell, Erlang |

---

## Prerequisites

- Basic programming knowledge (variables, loops, functions)
- Understanding of data types and data structures
- Basic familiarity with at least one OOP language

---

## Study Path

```
1. Start with oop-guide.md for overview
2. Deep dive with oop-principles.md
3. Practice with oop-examples.md
4. Prepare for interviews with oop-interview-questions.md
5. Apply knowledge to LLD → ../12-Low-Level-Design/
6. Learn patterns → ../14-Design-Patterns/
```

---

## Related Topics

- **Low-Level Design** → [12-Low-Level-Design](../12-Low-Level-Design/)
- **Design Patterns** → [14-Design-Patterns](../14-Design-Patterns/)
- **Data Structures** → Uses OOP for implementation

---

## OOP in Different Languages

| Feature | Python | Java | C++ |
|---------|--------|------|-----|
| **Classes** | Yes | Yes | Yes |
| **Multiple Inheritance** | Yes | No (interfaces) | Yes |
| **Abstract Classes** | ABC module | `abstract class` | Pure virtual |
| **Interfaces** | Protocols | `interface` | Pure virtual classes |
| **Access Modifiers** | Convention (`_`, `__`) | `public/private/protected` | Same as Java |
| **Generics** | Type hints | `<T>` | Templates `<T>` |
