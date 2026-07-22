# Object-Oriented Programming — Interview Questions

## Conceptual Questions

### Q1: What is the difference between a Class and an Object?

| Aspect | Class | Object |
|--------|-------|--------|
| Definition | Blueprint/template | Instance of a class |
| Memory | No memory allocated | Memory allocated |
| Creation | `class Car:` | `my_car = Car()` |
| Quantity | Defined once | Many instances possible |
| Existence | Logical entity | Physical entity |

```python
# Class - the blueprint
class Dog:
    def __init__(self, name):
        self.name = name

    def bark(self):
        return "Woof!"

# Objects - instances of the class
dog1 = Dog("Rex")    # Object 1
dog2 = Dog("Buddy")  # Object 2

print(dog1.name)  # Rex
print(dog2.name)  # Buddy
print(dog1.bark())  # Woof!
```

---

### Q2: Explain the 4 Pillars of OOP

| Pillar | Definition | Real-World Analogy |
|--------|-----------|-------------------|
| **Encapsulation** | Bundling data + methods, hiding internals | TV remote (buttons hide complex circuits) |
| **Abstraction** | Showing only essential features | Car driving (steering wheel, not engine details) |
| **Inheritance** | Reusing code via parent-child relationship | Child inherits traits from parents |
| **Polymorphism** | Same interface, different behaviors | "Start" button starts different vehicles |

---

### Q3: What is the difference between Abstraction and Encapsulation?

| Feature | Abstraction | Encapsulation |
|---------|-------------|---------------|
| **Focus** | Hiding complexity | Hiding data |
| **Level** | Design level | Implementation level |
| **Implementation** | Abstract classes, interfaces | Access modifiers, properties |
| **Goal** | Reduce complexity | Protect data integrity |
| **Example** | `Shape.area()` (how to draw) | `self.__balance` (can't access directly) |

```python
# Abstraction - hides "how" (interface)
from abc import ABC, abstractmethod

class PaymentGateway(ABC):
    @abstractmethod
    def process_payment(self, amount: float) -> bool:
        pass

# Encapsulation - hides "data" (implementation)
class BankAccount:
    def __init__(self, balance: float):
        self.__balance = balance  # Hidden from outside

    @property
    def balance(self):
        return self.__balance  # Read-only access
```

---

### Q4: What is the Diamond Problem? How does Python handle it?

The Diamond Problem occurs when a class inherits from two classes that share a common ancestor.

```python
# Diamond Problem demonstration
class A:
    def greet(self):
        return "Hello from A"

class B(A):
    def greet(self):
        return "Hello from B"

class C(A):
    def greet(self):
        return "Hello from C"

class D(B, C):  # Inherits from both B and C
    pass

# Python uses C3 Linearization (MRO)
d = D()
print(d.greet())  # "Hello from B" (follows MRO: D -> B -> C -> A)
print(D.__mro__)  # Shows resolution order
```

**Python's Solution:** C3 Linearization algorithm determines a consistent method resolution order (MRO).

---

### Q5: Explain Composition vs Inheritance with examples

| Feature | Inheritance | Composition |
|---------|------------|-------------|
| Relationship | IS-A | HAS-A |
| Coupling | Tight | Loose |
| Reusability | Parent → Child | Object contains objects |
| Flexibility | Limited | High |
| When to use | Clear hierarchy | Flexible relationships |

```python
# INHERITANCE - Car IS-A Vehicle
class Vehicle:
    def start(self):
        return "Starting vehicle"

class Car(Vehicle):  # Car IS-A Vehicle
    pass

# COMPOSITION - Car HAS-A Engine
class Engine:
    def start(self):
        return "Engine started"

class Car:
    def __init__(self, engine: Engine):
        self.engine = engine  # Car HAS-A Engine

    def start(self):
        return self.engine.start()

# Composition is preferred in most cases
car = Car(Engine())
print(car.start())  # "Engine started"
```

---

### Q6: What are the SOLID principles?

| Principle | Meaning | Violation Example |
|-----------|---------|-------------------|
| **S**ingle Responsibility | One class, one job | Class doing DB + email + logging |
| **O**pen/Closed | Open for extension, closed for modification | Modifying existing code for new features |
| **L**iskov Substitution | Subclasses must be substitutable | Penguin inheriting Bird.fly() |
| **I**nterface Segregation | Small, specific interfaces | Fat interface forcing unused methods |
| **D**ependency Inversion | Depend on abstractions | High-level module importing low-level module |

---

### Q7: What is the difference between `__init__` and `__new__`?

```python
class MyClass:
    def __new__(cls, *args, **kwargs):
        """Called BEFORE __init__. Creates the instance."""
        print("Creating instance")
        instance = super().__new__(cls)
        return instance

    def __init__(self, value):
        """Called AFTER __new__. Initializes the instance."""
        print("Initializing instance")
        self.value = value

# Singleton pattern using __new__
class Singleton:
    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance

    def __init__(self):
        if not hasattr(self, '_initialized'):
            self._initialized = True
            print("Singleton initialized once")

a = Singleton()  # "Singleton initialized once"
b = Singleton()  # Nothing printed - same instance
print(a is b)    # True
```

---

### Q8: Explain `isinstance()` vs `type()`

```python
class Animal:
    pass

class Dog(Animal):
    pass

dog = Dog()

# type() - exact type
print(type(dog))           # <class 'Dog'>
print(type(dog) == Dog)    # True
print(type(dog) == Animal) # False (not exact match)

# isinstance() - checks inheritance chain
print(isinstance(dog, Dog))     # True
print(isinstance(dog, Animal))  # True (Dog inherits Animal)
print(isinstance(dog, object))  # True (everything inherits object)

# Prefer isinstance() for flexibility
def process(animal: Animal):
    if isinstance(animal, Dog):
        print("It's a dog!")
    elif isinstance(animal, Cat):
        print("It's a cat!")
```

---

### Q9: What are Class Methods vs Static Methods vs Instance Methods?

```python
class MyClass:
    class_var = "I belong to the class"

    def instance_method(self):
        """Has access to instance (self) and class variables"""
        return f"Instance method: {self.class_var}"

    @classmethod
    def class_method(cls):
        """Has access to class (cls) but NOT instance"""
        return f"Class method: {cls.class_var}"

    @staticmethod
    def static_method():
        """No access to instance or class - just a utility"""
        return "Static method: I'm independent"

# Instance method - needs an instance
obj = MyClass()
print(obj.instance_method())  # Works

# Class method - called on the class
print(MyClass.class_method())  # Works
print(obj.class_method())      # Also works

# Static method - no access to class/instance
print(MyClass.static_method())  # Works
print(obj.static_method())      # Also works
```

---

### Q10: What is the `super()` function?

```python
class Parent:
    def __init__(self, name):
        self.name = name

    def greet(self):
        return f"Hello, I'm {self.name}"

class Child(Parent):
    def __init__(self, name, age):
        super().__init__(name)  # Call Parent's __init__
        self.age = age

    def greet(self):
        parent_greet = super().greet()  # Call Parent's greet
        return f"{parent_greet} and I'm {self.age} years old"

child = Child("Alice", 10)
print(child.greet())  # "Hello, I'm Alice and I'm 10 years old"
```

---

## Code-Based Questions

### Q11: What will this code output?

```python
class Base:
    def __init__(self):
        self.x = 1

class Child(Base):
    def __init__(self):
        super().__init__()
        self.y = 2

    def method(self):
        return self.x + self.y

c = Child()
print(c.method())  # Output: 3
```

### Q12: Explain this code and identify the OOP concepts used

```python
from abc import ABC, abstractmethod

class Shape(ABC):
    @abstractmethod
    def area(self) -> float:
        pass

class Circle(Shape):
    def __init__(self, radius):
        self.radius = radius

    def area(self) -> float:
        return 3.14 * self.radius ** 2

shapes = [Circle(5), Circle(3)]
total_area = sum(s.area() for s in shapes)

print(f"Total area: {total_area}")  # 106.76
```

**Answer:**
- **Abstraction**: `Shape` is an abstract class with abstract `area()` method
- **Polymorphism**: `Circle.area()` implements the abstract method
- **Encapsulation**: `radius` is encapsulated within the Circle class

---

### Q13: Design a simple Animal class hierarchy

```python
from abc import ABC, abstractmethod

class Animal(ABC):
    def __init__(self, name: str, sound: str):
        self.name = name
        self._sound = sound

    @abstractmethod
    def habitat(self) -> str:
        pass

    def speak(self) -> str:
        return f"{self.name} says {self._sound}"

    def __repr__(self):
        return f"{self.__class__.__name__}('{self.name}')"

class Dog(Animal):
    def __init__(self, name: str, breed: str):
        super().__init__(name, "Woof")
        self.breed = breed

    def habitat(self) -> str:
        return "Domestic homes"

class Fish(Animal):
    def __init__(self, name: str, water_type: str):
        super().__init__(name, "*bubbles*")
        self.water_type = water_type

    def habitat(self) -> str:
        return f"{self.water_type} water"

# Usage
animals = [Dog("Rex", "German Shepherd"), Fish("Nemo", "Saltwater")]
for animal in animals:
    print(f"{animal}: {animal.speak()} (Lives in: {animal.habitat()})")
```

---

## Design Questions

### Q14: When would you use an Abstract Class vs an Interface?

| Use Abstract Class | Use Interface (Protocol) |
|-------------------|-------------------------|
| Share code between related classes | Define a contract for unrelated classes |
| Need constructors, fields | Only method signatures needed |
| Want to provide default behavior | Want multiple inheritance |
| IS-A relationship | CAN-DO relationship |

---

### Q15: Explain the Liskov Substitution Principle with an example

```python
# VIOLATION - Rectangle/Square problem
class Rectangle:
    def __init__(self, width, height):
        self.width = width
        self.height = height

    def set_width(self, w): self.width = w
    def set_height(self, h): self.height = h
    def area(self): return self.width * self.height

class Square(Rectangle):
    def set_width(self, w):
        self.width = w
        self.height = w  # Breaks Rectangle's behavior!

    def set_height(self, h):
        self.width = h
        self.height = h

def process_rectangle(r: Rectangle):
    r.set_width(5)
    r.set_height(4)
    assert r.area() == 20  # FAILS for Square!

# This violates LSP because Square can't substitute Rectangle
```

**Solution:** Don't create Square inheriting Rectangle. Instead, use composition or make them both implement a Shape interface.

---

## Quick Reference Table

| Question | Key Points |
|----------|-----------|
| Class vs Object | Blueprint vs Instance |
| 4 Pillars | Encapsulation, Abstraction, Inheritance, Polymorphism |
| SOLID | Single, Open/Closed, Liskov, Interface, Dependency |
| Composition > Inheritance | Prefer HAS-A over IS-A |
| Abstract vs Interface | Implementation vs Contract |
| `__new__` vs `__init__` | Create vs Initialize |
| `isinstance` vs `type` | Inheritance check vs Exact type |
| `super()` | Call parent class methods |
| Diamond Problem | C3 Linearization / MRO |
