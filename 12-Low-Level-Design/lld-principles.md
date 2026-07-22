# Low-Level Design — Core Principles

## SOLID Principles

The SOLID principles are five fundamental principles of object-oriented design that help create maintainable, flexible, and robust systems.

---

### 1. Single Responsibility Principle (SRP)

> A class should have only one reason to change.

**Bad Design:**
```java
class UserManager {
    void createUser(String name) { }
    void sendEmail(String email) { }
    void generateReport() { }
    void saveToDatabase() { }
}
```

**Good Design:**
```java
class UserService {
    void createUser(String name) { }
}

class EmailService {
    void sendEmail(String email) { }
}

class ReportGenerator {
    void generateReport() { }
}

class UserRepository {
    void save(User user) { }
}
```

**Real-World Example:** A ticket booking system
- `BookingService` — handles booking logic
- `PaymentService` — handles payments
- `NotificationService` — sends confirmations
- `SeatSelector` — manages seat selection

---

### 2. Open/Closed Principle (OCP)

> Software entities should be open for extension but closed for modification.

**Bad Design:**
```python
class Shape:
    def __init__(self, shape_type):
        self.shape_type = shape_type

    def area(self):
        if self.shape_type == "circle":
            return 3.14 * self.radius ** 2
        elif self.shape_type == "rectangle":
            return self.width * self.height
        # Adding new shapes requires modifying this method
```

**Good Design:**
```python
from abc import ABC, abstractmethod

class Shape(ABC):
    @abstractmethod
    def area(self) -> float:
        pass

class Circle(Shape):
    def __init__(self, radius: float):
        self.radius = radius

    def area(self) -> float:
        return 3.14 * self.radius ** 2

class Rectangle(Shape):
    def __init__(self, width: float, height: float):
        self.width = width
        self.height = height

    def area(self) -> float:
        return self.width * self.height

# New shapes can be added without modifying existing code
class Triangle(Shape):
    def __init__(self, base: float, height: float):
        self.base = base
        self.height = height

    def area(self) -> float:
        return 0.5 * self.base * self.height
```

---

### 3. Liskov Substitution Principle (LSP)

> Subtypes must be substitutable for their base types without altering correctness.

**Bad Design:**
```python
class Bird:
    def fly(self):
        return "Flying"

class Penguin(Bird):
    def fly(self):
        raise Exception("Penguins can't fly!")  # Violates LSP
```

**Good Design:**
```python
class Bird(ABC):
    @abstractmethod
    def move(self):
        pass

class FlyingBird(Bird):
    def move(self):
        return "Flying through the air"

class Penguin(Bird):
    def move(self):
        return "Swimming in water"
```

**Key Rule:** If a subclass breaks the behavior expected by the parent class, it violates LSP.

---

### 4. Interface Segregation Principle (ISP)

> Clients should not be forced to depend on interfaces they don't use.

**Bad Design:**
```python
class Worker(ABC):
    @abstractmethod
    def work(self): pass

    @abstractmethod
    def eat(self): pass

    @abstractmethod
    def sleep(self): pass

class Robot(Worker):
    def work(self): return "Working"
    def eat(self): raise Exception("Robots don't eat!")  # Forced to implement
    def sleep(self): raise Exception("Robots don't sleep!")
```

**Good Design:**
```python
class Workable(ABC):
    @abstractmethod
    def work(self): pass

class Feedable(ABC):
    @abstractmethod
    def eat(self): pass

class Sleepable(ABC):
    @abstractmethod
    def sleep(self): pass

class Human(Workable, Feedable, Sleepable):
    def work(self): return "Working"
    def eat(self): return "Eating"
    def sleep(self): return "Sleeping"

class Robot(Workable):
    def work(self): return "Working"
```

---

### 5. Dependency Inversion Principle (DIP)

> High-level modules should not depend on low-level modules. Both should depend on abstractions.

**Bad Design:**
```python
class MySQLDatabase:
    def save(self, data):
        print(f"Saving {data} to MySQL")

class UserService:
    def __init__(self):
        self.db = MySQLDatabase()  # Direct dependency on concrete class

    def save_user(self, user):
        self.db.save(user)
```

**Good Design:**
```python
from abc import ABC, abstractmethod

class Database(ABC):
    @abstractmethod
    def save(self, data): pass

class MySQLDatabase(Database):
    def save(self, data):
        print(f"Saving {data} to MySQL")

class PostgresDatabase(Database):
    def save(self, data):
        print(f"Saving {data} to PostgreSQL")

class UserService:
    def __init__(self, database: Database):  # Depends on abstraction
        self.db = database

    def save_user(self, user):
        self.db.save(user)

# Usage - easy to swap implementations
service = UserService(MySQLDatabase())
service = UserService(PostgresDatabase())
```

---

## Additional Design Principles

### DRY (Don't Repeat Yourself)

Every piece of knowledge should have a single, unambiguous representation.

```python
# Bad
def calculate_tax_regular(price): return price * 0.10
def calculate_tax_imported(price): return price * 0.15
def calculate_tax_luxury(price): return price * 0.25

# Good
def calculate_tax(price, tax_rate): return price * tax_rate
```

### KISS (Keep It Simple, Stupid)

Prefer simple solutions over complex ones. Complexity should be justified.

```python
# Bad
def is_even(n):
    if n % 2 == 0:
        return True
    else:
        return False

# Good
def is_even(n):
    return n % 2 == 0
```

### YAGNI (You Aren't Gonna Need It)

Don't build functionality until it's actually needed.

### Composition Over Inheritance

```python
# Bad - Deep inheritance hierarchy
class Vehicle:
    pass
class Car(Vehicle):
    pass
class ElectricCar(Car):
    pass

# Good - Composition
class Engine:
    def start(self): pass

class Battery:
    def charge(self): pass

class Car:
    def __init__(self, engine: Engine, battery: Battery = None):
        self.engine = engine
        self.battery = battery
```

---

## Principle Comparison Table

| Principle | Focus | Problem Solved |
|-----------|-------|----------------|
| **SRP** | Class responsibility | Tight coupling |
| **OCP** | Extension vs modification | Rigidity |
| **LSP** | Subtype behavior | Incorrect abstractions |
| **ISP** | Interface size | Fat interfaces |
| **DIP** | Dependency direction | Tight coupling |
| **DRY** | Code duplication | Maintenance overhead |
| **KISS** | Complexity | Over-engineering |
| **YAGNI** | Premature features | Wasted effort |

---

## Applying Principles in LLD Interviews

### Parking Lot Example

```python
# SRP - Separate concerns
class ParkingLot:
    def __init__(self, floors: List[ParkingFloor]):
        self.floors = floors

class PaymentProcessor:
    def process(self, amount: float): pass

class DisplayBoard:
    def update(self, availability: dict): pass

# OCP - Extensible vehicle types
class Vehicle(ABC):
    @abstractmethod
    def get_size(self) -> VehicleSize: pass

class Car(Vehicle):
    def get_size(self) -> VehicleSize:
        return VehicleSize.COMPACT

# DIP - Depend on abstractions
class ParkingStrategy(ABC):
    @abstractmethod
    def find_slot(self, vehicle: Vehicle) -> ParkingSlot: pass

class NearestFirstStrategy(ParkingStrategy):
    def find_slot(self, vehicle: Vehicle) -> ParkingSlot:
        # Find nearest available slot
        pass

class RandomStrategy(ParkingStrategy):
    def find_slot(self, vehicle: Vehicle) -> ParkingSlot:
        # Find random available slot
        pass
```

---

## Anti-Patterns to Avoid

| Anti-Pattern | Description | Solution |
|-------------|-------------|----------|
| **God Class** | One class doing everything | Split into focused classes |
| **Spaghetti Code** | Untangled, unstructured code | Apply SRP, use design patterns |
| **Golden Hammer** | Using one solution for all problems | Evaluate alternatives |
| **Copy-Paste** | Duplicating code blocks | Extract to shared functions |
| **Premature Optimization** | Optimizing before needed | Follow YAGNI |
| **Magic Numbers** | Hardcoded numeric values | Use constants or enums |
