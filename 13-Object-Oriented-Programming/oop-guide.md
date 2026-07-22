# Object-Oriented Programming — Complete Guide

## What is OOP?

Object-Oriented Programming (OOP) is a programming paradigm that organizes software design around objects rather than functions and logic. An object is a data field that has its own unique attributes and behavior.

---

## Core Concepts

### 1. Classes and Objects

**Class** — A blueprint/template for creating objects.
**Object** — An instance of a class with actual values.

```python
class Car:
    """Blueprint for all cars"""

    def __init__(self, make: str, model: str, year: int):
        # Attributes (data)
        self.make = make
        self.model = model
        self.year = year
        self.is_running = False
        self.speed = 0

    # Methods (behavior)
    def start(self):
        self.is_running = True
        return f"{self.make} {self.model} started"

    def accelerate(self, amount: int):
        if not self.is_running:
            return "Start the car first!"
        self.speed += amount
        return f"Speed: {self.speed} mph"

    def stop(self):
        self.is_running = False
        self.speed = 0
        return f"{self.make} {self.model} stopped"

# Creating objects (instances)
car1 = Car("Toyota", "Camry", 2023)
car2 = Car("Honda", "Civic", 2024)

print(car1.start())      # "Toyota Camry started"
print(car1.accelerate(60))  # "Speed: 60 mph"
print(car2.start())      # "Honda Civic started"
```

---

### 2. The Four Pillars

#### Encapsulation
Bundling data and methods that operate on that data within a single unit, and restricting direct access to some components.

```python
class BankAccount:
    def __init__(self, owner: str, balance: float = 0):
        self.owner = owner
        self.__balance = balance  # Private attribute

    # Getter
    @property
    def balance(self) -> float:
        return self.__balance

    def deposit(self, amount: float):
        if amount <= 0:
            raise ValueError("Deposit must be positive")
        self.__balance += amount

    def withdraw(self, amount: float):
        if amount > self.__balance:
            raise ValueError("Insufficient funds")
        self.__balance -= amount

account = BankAccount("Alice", 1000)
print(account.balance)     # 1000 (via property)
account.deposit(500)
print(account.balance)     # 1500
# account.__balance = 1000000  # Won't work - name mangling
```

#### Inheritance
Creating new classes from existing ones, promoting code reuse.

```python
class Animal:
    def __init__(self, name: str, sound: str):
        self.name = name
        self.sound = sound

    def speak(self):
        return f"{self.name} says {self.sound}"

    def __repr__(self):
        return f"Animal({self.name})"

class Dog(Animal):
    def __init__(self, name: str, breed: str):
        super().__init__(name, sound="Woof")
        self.breed = breed

    def fetch(self, item: str):
        return f"{self.name} fetches the {item}"

class Cat(Animal):
    def __init__(self, name: str, indoor: bool = True):
        super().__init__(name, sound="Meow")
        self.indoor = indoor

    def purr(self):
        return f"{self.name} purrs..."

# Inheritance in action
dog = Dog("Rex", "German Shepherd")
cat = Cat("Whiskers", indoor=False)

print(dog.speak())      # "Rex says Woof" (inherited)
print(dog.fetch("ball"))  # "Rex fetches the ball"
print(cat.speak())      # "Whiskers says Meow"
print(cat.purr())       # "Whiskers purrs..."
```

#### Polymorphism
Same interface, different implementations.

```python
from abc import ABC, abstractmethod

class Shape(ABC):
    @abstractmethod
    def area(self) -> float:
        pass

    @abstractmethod
    def perimeter(self) -> float:
        pass

    def describe(self) -> str:
        return f"{self.__class__.__name__}: area={self.area():.2f}"

class Circle(Shape):
    def __init__(self, radius: float):
        self.radius = radius

    def area(self) -> float:
        return 3.14159 * self.radius ** 2

    def perimeter(self) -> float:
        return 2 * 3.14159 * self.radius

class Rectangle(Shape):
    def __init__(self, width: float, height: float):
        self.width = width
        self.height = height

    def area(self) -> float:
        return self.width * self.height

    def perimeter(self) -> float:
        return 2 * (self.width + self.height)

class Triangle(Shape):
    def __init__(self, a: float, b: float, c: float):
        self.a, self.b, self.c = a, b, c

    def area(self) -> float:
        s = (self.a + self.b + self.c) / 2
        return (s * (s-self.a) * (s-self.b) * (s-self.c)) ** 0.5

    def perimeter(self) -> float:
        return self.a + self.b + self.c

# Polymorphism in action
shapes = [Circle(5), Rectangle(4, 6), Triangle(3, 4, 5)]
for shape in shapes:
    print(shape.describe())
    # Each shape calculates area differently
```

#### Abstraction
Hiding complex implementation details, showing only necessary features.

```python
from abc import ABC, abstractmethod

class Database(ABC):
    """Abstraction - user doesn't need to know implementation details"""

    @abstractmethod
    def connect(self): pass

    @abstractmethod
    def query(self, sql: str): pass

    @abstractmethod
    def close(self): pass

class MySQLDatabase(Database):
    def connect(self):
        print("Connecting to MySQL...")

    def query(self, sql: str):
        print(f"MySQL executing: {sql}")
        return []

    def close(self):
        print("MySQL connection closed")

class PostgreSQLDatabase(Database):
    def connect(self):
        print("Connecting to PostgreSQL...")

    def query(self, sql: str):
        print(f"PostgreSQL executing: {sql}")
        return []

    def close(self):
        print("PostgreSQL connection closed")

# Client code doesn't know which database is being used
def run_report(db: Database):
    db.connect()
    results = db.query("SELECT * FROM users")
    db.close()
    return results

# Can swap implementations without changing client code
run_report(MySQLDatabase())
run_report(PostgreSQLDatabase())
```

---

## Access Modifiers

| Modifier | Python | Java | C++ | Access Level |
|----------|--------|------|-----|--------------|
| Public | `attr` | `public` | `public` | Everywhere |
| Protected | `_attr` | `protected` | `protected` | Class + subclasses |
| Private | `__attr` | `private` | `private` | Class only |

```python
class Employee:
    def __init__(self, name: str, salary: float):
        self.name = name          # Public
        self._department = "IT"   # Protected (convention)
        self.__ssn = "123-45-6789"  # Private (name mangling)

emp = Employee("John", 50000)
print(emp.name)          # OK - public
print(emp._department)   # Works but convention says don't
# print(emp.__ssn)       # AttributeError
print(emp._Employee__ssn)  # Access via name mangling (don't do this!)
```

---

## Special Methods (Magic/Dunder Methods)

```python
class Vector:
    def __init__(self, x: float, y: float):
        self.x = x
        self.y = y

    def __repr__(self):
        return f"Vector({self.x}, {self.y})"

    def __str__(self):
        return f"({self.x}, {self.y})"

    def __add__(self, other):
        return Vector(self.x + other.x, self.y + other.y)

    def __sub__(self, other):
        return Vector(self.x - other.x, self.y - other.y)

    def __mul__(self, scalar):
        return Vector(self.x * scalar, self.y * scalar)

    def __eq__(self, other):
        return self.x == other.x and self.y == other.y

    def __len__(self):
        return int((self.x**2 + self.y**2)**0.5)

    def __getitem__(self, index):
        if index == 0: return self.x
        if index == 1: return self.y
        raise IndexError("Vector index out of range")

v1 = Vector(3, 4)
v2 = Vector(1, 2)

print(v1 + v2)      # (4, 6)
print(v1 - v2)      # (2, 2)
print(v1 * 3)       # (9, 12)
print(v1 == v2)     # False
print(len(v1))      # 5
print(v1[0])        # 3
```

---

## Composition vs Inheritance

```python
# Composition (HAS-A relationship)
class Engine:
    def __init__(self, horsepower: int):
        self.horsepower = horsepower

    def start(self):
        return f"Engine ({self.horsepower}HP) started"

class Car:
    def __init__(self, make: str, engine: Engine):
        self.make = make
        self.engine = engine  # Composition - Car HAS an Engine

    def start(self):
        return f"{self.make}: {self.engine.start()}"

# Inheritance (IS-A relationship)
class ElectricEngine(Engine):
    def start(self):
        return f"Electric Engine ({self.horsepower}HP) silently started"

car = Car("Tesla", ElectricEngine(450))
print(car.start())  # "Tesla: Electric Engine (450HP) silently started"
```

---

## Best Practices

| Practice | Description |
|----------|-------------|
| **Favor composition** | Use composition over inheritance when possible |
| **Program to interface** | Depend on abstractions, not implementations |
| **Single Responsibility** | Each class should have one reason to change |
| **Use type hints** | Makes code self-documenting |
| **Keep classes small** | Large classes are hard to maintain |
| **Avoid deep inheritance** | Max 2-3 levels of inheritance |
