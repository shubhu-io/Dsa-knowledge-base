# Object-Oriented Programming in Python

## Overview

Python supports multiple OOP paradigms: encapsulation, inheritance, polymorphism,
and abstraction. Everything in Python is an object — including functions and classes.

---

## Classes and Objects

```python
class Dog:
    # Class attribute (shared by all instances)
    species = "Canis familiaris"

    # Initializer (constructor)
    def __init__(self, name, age):
        # Instance attributes (unique to each instance)
        self.name = name
        self.age = age

    # Instance method
    def bark(self):
        return f"{self.name} says Woof!"

    # String representation
    def __repr__(self):
        return f"Dog('{self.name}', {self.age})"

# Creating objects
buddy = Dog("Buddy", 3)
print(buddy.bark())    # "Buddy says Woof!"
print(buddy.species)   # "Canis familiaris"
print(buddy)           # Dog('Buddy', 3)
```

---

## Encapsulation

Python uses naming conventions (not strict access modifiers) for encapsulation.

```python
class BankAccount:
    def __init__(self, owner, balance=0):
        self.owner = owner        # Public
        self._bank = "Chase"      # Protected (convention: don't access directly)
        self.__balance = balance  # Private (name mangled to _BankAccount__balance)

    def deposit(self, amount):
        if amount > 0:
            self.__balance += amount
            return True
        return False

    def withdraw(self, amount):
        if 0 < amount <= self.__balance:
            self.__balance -= amount
            return True
        return False

    def get_balance(self):
        return self.__balance

account = BankAccount("Alice", 1000)
account.deposit(500)
print(account.get_balance())  # 1500
# print(account.__balance)    # AttributeError (private)
```

---

## Inheritance

```python
class Animal:
    def __init__(self, name, sound):
        self.name = name
        self.sound = sound

    def speak(self):
        return f"{self.name} says {self.sound}!"

    def __str__(self):
        return f"{self.__class__.__name__}({self.name})"

class Dog(Animal):
    def __init__(self, name, breed):
        super().__init__(name, sound="Woof")
        self.breed = breed

    def fetch(self, item):
        return f"{self.name} fetches the {item}!"

class Cat(Animal):
    def __init__(self, name, indoor=True):
        super().__init__(name, sound="Meow")
        self.indoor = indoor

    def purr(self):
        return f"{self.name} purrs..."

# Usage
dog = Dog("Buddy", "Golden Retriever")
cat = Cat("Whiskers")

print(dog.speak())      # "Buddy says Woof!"
print(dog.fetch("ball")) # "Buddy fetches the ball!"
print(cat.speak())      # "Whiskers says Meow!"
print(cat.purr())       # "Whiskers purrs..."
```

---

## Polymorphism

```python
class Shape:
    def area(self):
        raise NotImplementedError("Subclasses must implement area()")

class Circle(Shape):
    def __init__(self, radius):
        self.radius = radius

    def area(self):
        return 3.14159 * self.radius ** 2

class Rectangle(Shape):
    def __init__(self, width, height):
        self.width = width
        self.height = height

    def area(self):
        return self.width * self.height

class Triangle(Shape):
    def __init__(self, base, height):
        self.base = base
        self.height = height

    def area(self):
        return 0.5 * self.base * self.height

# Polymorphism in action
shapes = [Circle(5), Rectangle(4, 6), Triangle(3, 8)]
for shape in shapes:
    print(f"{shape.__class__.__name__}: {shape.area():.2f}")
# Circle: 78.54
# Rectangle: 24.00
# Triangle: 12.00
```

---

## Abstraction

```python
from abc import ABC, abstractmethod

class Vehicle(ABC):
    @abstractmethod
    def start(self):
        pass

    @abstractmethod
    def stop(self):
        pass

    @abstractmethod
    def fuel_type(self):
        pass

    def info(self):
        return f"{self.__class__.__name__} uses {self.fuel_type()}"

class ElectricCar(Vehicle):
    def __init__(self, model):
        self.model = model

    def start(self):
        return f"{self.model} starts silently"

    def stop(self):
        return f"{self.model} stops"

    def fuel_type(self):
        return "electricity"

class GasCar(Vehicle):
    def __init__(self, model):
        self.model = model

    def start(self):
        return f"{self.model} roars to life"

    def stop(self):
        return f"{self.model} shuts off"

    def fuel_type(self):
        return "gasoline"

# vehicle = Vehicle()  # TypeError: Can't instantiate abstract class
car = ElectricCar("Tesla Model 3")
print(car.start())  # "Tesla Model 3 starts silently"
print(car.info())   # "ElectricCar uses electricity"
```

---

## Magic Methods (Dunder Methods)

```python
class Vector:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __add__(self, other):
        return Vector(self.x + other.x, self.y + other.y)

    def __sub__(self, other):
        return Vector(self.x - other.x, self.y - other.y)

    def __mul__(self, scalar):
        return Vector(self.x * scalar, self.y * scalar)

    def __eq__(self, other):
        return self.x == other.x and self.y == other.y

    def __len__(self):
        return int((self.x ** 2 + self.y ** 2) ** 0.5)

    def __repr__(self):
        return f"Vector({self.x}, {self.y})"

    def __getitem__(self, index):
        if index == 0:
            return self.x
        elif index == 1:
            return self.y
        raise IndexError("Vector index out of range")

# Usage
v1 = Vector(1, 2)
v2 = Vector(3, 4)
print(v1 + v2)    # Vector(4, 6)
print(v1 - v2)    # Vector(-2, -2)
print(v1 * 3)     # Vector(3, 6)
print(v1 == v2)   # False
print(len(v1))    # 2
print(v1[0])      # 1
```

---

## Property Decorators

```python
class Temperature:
    def __init__(self, celsius=0):
        self._celsius = celsius

    @property
    def celsius(self):
        return self._celsius

    @celsius.setter
    def celsius(self, value):
        if value < -273.15:
            raise ValueError("Temperature below absolute zero")
        self._celsius = value

    @property
    def fahrenheit(self):
        return self._celsius * 9/5 + 32

    @fahrenheit.setter
    def fahrenheit(self, value):
        self.celsius = (value - 32) * 5/9

# Usage
temp = Temperature(25)
print(temp.celsius)      # 25
print(temp.fahrenheit)   # 77.0
temp.fahrenheit = 212
print(temp.celsius)      # 100.0
```

---

## Class Methods and Static Methods

```python
class Date:
    def __init__(self, day, month, year):
        self.day = day
        self.month = month
        self.year = year

    @classmethod
    def from_string(cls, date_string):
        day, month, year = map(int, date_string.split("-"))
        return cls(day, month, year)

    @staticmethod
    def is_valid(day, month, year):
        return 1 <= day <= 31 and 1 <= month <= 12

    def __str__(self):
        return f"{self.day:02d}-{self.month:02d}-{self.year}"

# Usage
date1 = Date(15, 6, 2024)
date2 = Date.from_string("25-12-2024")
print(date1)  # 15-06-2024
print(date2)  # 25-12-2024
print(Date.is_valid(31, 13, 2024))  # False
```

---

## Multiple Inheritance

```python
class Flyer:
    def fly(self):
        return f"{self.__class__.__name__} is flying"

class Swimmer:
    def swim(self):
        return f"{self.__class__.__name__} is swimming"

class Duck(Flyer, Swimmer):
    def __init__(self, name):
        self.name = name

    def quack(self):
        return f"{self.name} says Quack!"

# Usage
donald = Duck("Donald")
print(donald.fly())    # "Donald is flying"
print(donald.swim())   # "Donald is swimming"
print(donald.quack())  # "Donald says Quack!"

# Method Resolution Order (MRO)
print(Duck.__mro__)
# (<class 'Duck'>, <class 'Flyer'>, <class 'Swimmer'>, <class 'object'>)
```

---

## Composition vs Inheritance

```python
# Composition: "has-a" relationship
class Engine:
    def start(self):
        return "Engine started"

class Car:
    def __init__(self, engine):
        self.engine = engine  # Car HAS an Engine

    def start(self):
        return self.engine.start()

# Inheritance: "is-a" relationship
class ElectricEngine(Engine):
    def start(self):
        return "Electric engine started silently"

# Composition is often preferred over inheritance
# for code reuse (more flexible, less coupling)
```

---

## Interview Questions

1. What is the difference between `__str__` and `__repr__`?
2. Explain method resolution order (MRO) in multiple inheritance.
3. What is the difference between class methods and static methods?
4. When would you use composition over inheritance?
5. How does Python implement encapsulation without access modifiers?
6. What are abstract classes and when should you use them?
7. Explain the difference between `@property` and getter/setter methods.
8. What are magic methods and give examples of when you'd use them?

---

## See Also

- [[Python]] — Python overview and quick reference
- [[Data-Structures]] — Data structure implementations
- [[Algorithms]] — Algorithm implementations
