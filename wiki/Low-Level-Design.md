# Low-Level Design

## Overview

Low-Level Design (LLD) is the detailed design phase where you define classes,
methods, relationships, and data structures for specific components. While HLD
focuses on the big picture, LLD dives into implementation details.

LLD is critical for object-oriented design interviews where you are asked to
design a specific system like a parking lot, elevator, or chess game.

---

## LLD vs HLD

| Aspect          | HLD                        | LLD                        |
|----------------|----------------------------|----------------------------|
| Scope          | Entire system              | Single component/module    |
| Focus          | Architecture, services     | Classes, methods, patterns |
| Output         | Architecture diagrams      | Class/sequence diagrams    |
| Abstraction    | High                       | Low (implementation-level) |
| Interview Type | Senior/Staff interviews    | Mid-level/Fresh grad       |

---

## SOLID Principles

### S - Single Responsibility Principle

A class should have only one reason to change.

```python
# Bad: Class does too much
class User:
    def __init__(self, name, email):
        self.name = name
        self.email = email

    def save_to_database(self):
        pass

    def send_email(self):
        pass

# Good: Separate responsibilities
class User:
    def __init__(self, name, email):
        self.name = name
        self.email = email

class UserRepository:
    def save(self, user):
        pass

class EmailService:
    def send(self, user, message):
        pass
```

### O - Open/Closed Principle

Open for extension, closed for modification.

```python
class Notification:
    def send(self, message):
        pass

class EmailNotification(Notification):
    def send(self, message):
        pass

class SMSNotification(Notification):
    def send(self, message):
        pass
```

### L - Liskov Substitution Principle

Subtypes must be substitutable for their base types without breaking behavior.

```python
class Bird:
    def move(self):
        pass

class FlyingBird(Bird):
    def move(self):
        return "flying"

class Penguin(Bird):
    def move(self):
        return "swimming"  # Still a valid Bird, still moves
```

### I - Interface Segregation Principle

Clients should not be forced to depend on methods they do not use.

```python
class Workable:
    def work(self):
        pass

class Eatable:
    def eat(self):
        pass

class Robot(Workable):
    def work(self):
        return "Robot working"

class Human(Workable, Eatable):
    def work(self):
        return "Human working"
    def eat(self):
        return "Human eating"
```

### D - Dependency Inversion Principle

Depend on abstractions, not concretions.

```python
from abc import ABC, abstractmethod

class Database(ABC):
    @abstractmethod
    def save(self, data):
        pass

class MySQLDatabase(Database):
    def save(self, data):
        print(f"Saving to MySQL: {data}")

class UserRepository:
    def __init__(self, db: Database):  # Depends on abstraction
        self.db = db

    def save(self, user):
        self.db.save(user)

# Works with any database
repo = UserRepository(MySQLDatabase())
```

---

## UML Class Diagram Basics

### Relationships

- **Association**: Two classes use each other
- **Aggregation**: "Has-a" relationship (weak)
- **Composition**: "Has-a" relationship (strong, lifecycle-bound)
- **Inheritance**: "Is-a" relationship
- **Dependency**: One class depends on another

### Notation

```
+-------------------+
|     ClassName     |
+-------------------+
| - privateField    |
| # protectedField  |
| + publicField     |
+-------------------+
| + method()        |
| - helper()        |
+-------------------+
```

### Example: Library System

```
+----------+     +------------+     +----------+
|  Person  |     |    Book    |     |  Library |
+----------+     +------------+     +----------+
| -name    |     | -title     |     | -books   |
| -email   |     | -author    |     +----------+
+----------+     | -ISBN      |     | +addBook()|
| +borrow()|     +------------+     | +remove()|
| +return()|     | +getInfo() |     +----------+
+----------+     +------------+
      |                |
      |  borrows       |  contains
      +--------+-------+
               |
               v
        +-------------+
        | Transaction |
        +-------------+
        | -date       |
        | -dueDate    |
        +-------------+
```

---

## Common LLD Problems

### 1. Parking Lot System

- Enum for vehicle types (Car, Truck, Motorcycle)
- ParkingSpot hierarchy (Compact, Regular, Large)
- ParkingLot singleton with floor management
- Ticket system with entry/exit

### 2. Elevator System

- Elevator controller (scheduler)
- Request queue per elevator
- State machine: Idle, Moving, DoorOpen
- Algorithms: SCAN, FCFS

### 3. Library Management System

- Book, User, Librarian classes
- Borrowing system with due dates
- Fine calculation
- Search functionality

### 4. Chess Game

- Board, Piece, Player classes
- Move validation per piece type
- Game state management (check, checkmate)
- Turn management

### 5. Vending Machine

- State pattern (Idle, HasMoney, Dispensing)
- Product inventory management
- Coin/bill handling
- Change calculation

---

## Design Process for LLD Interviews

1. **Clarify Requirements** (3-5 min)
   - Ask about scope and constraints
   - Identify core features

2. **Identify Core Objects** (5-10 min)
   - Nouns become classes
   - Define attributes and methods

3. **Define Relationships** (5-10 min)
   - Inheritance, composition, aggregation
   - Draw class diagram

4. **Design Patterns** (5 min)
   - Singleton, Factory, Observer, State, Strategy

5. **Implement Key Classes** (15-20 min)
   - Write clean, production-quality code

6. **Edge Cases and Testing** (5 min)
   - Error handling, validation
   - Discuss trade-offs

---

## Common Interview Questions

1. How would you design a parking lot system with multiple floors?
2. Explain the difference between composition and inheritance
3. When would you use the Factory pattern vs the Builder pattern?
4. How do you handle concurrency in a shared resource like a parking lot?
5. Design a vending machine that accepts coins and dispenses products

---

## See Also

- [[System-Design]]
- [[Data-Structures]]
- [[Databases]]
- [[Networking]]

---

> Full content: [12-Low-Level-Design](../12-Low-Level-Design/)
