"""
OOP Example Implementations in Python

Demonstrates classes, inheritance, polymorphism, and design patterns.
"""

from abc import ABC, abstractmethod
from typing import List, Optional


# ============================================================
# 1. Basic Class with Encapsulation
# ============================================================

class Student:
    """Represents a student with grades."""

    def __init__(self, name: str, student_id: str):
        self.name = name
        self._student_id = student_id  # Protected
        self.__grades: List[float] = []  # Private

    @property
    def student_id(self) -> str:
        return self._student_id

    @property
    def gpa(self) -> float:
        if not self.__grades:
            return 0.0
        return sum(self.__grades) / len(self.__grades)

    def add_grade(self, grade: float) -> None:
        if 0 <= grade <= 100:
            self.__grades.append(grade)
        else:
            raise ValueError("Grade must be between 0 and 100")

    def is_honor_roll(self) -> bool:
        return self.gpa >= 3.5

    def __repr__(self) -> str:
        return f"Student('{self.name}', '{self._student_id}', GPA={self.gpa:.2f})"


# ============================================================
# 2. Inheritance Hierarchy
# ============================================================

class Employee(ABC):
    """Abstract base class for all employees."""

    def __init__(self, name: str, employee_id: str, base_salary: float):
        self.name = name
        self._employee_id = employee_id
        self._base_salary = base_salary

    @abstractmethod
    def calculate_pay(self) -> float:
        """Calculate total pay for this employee."""
        pass

    @abstractmethod
    def role(self) -> str:
        """Return the employee's role."""
        pass

    def __str__(self) -> str:
        return f"{self.role()}: {self.name} (ID: {self._employee_id})"


class Developer(Employee):
    """Software developer employee."""

    def __init__(self, name: str, employee_id: str, base_salary: float,
                 languages: List[str], years_experience: int = 0):
        super().__init__(name, employee_id, base_salary)
        self.languages = languages
        self.years_experience = years_experience

    def role(self) -> str:
        return "Developer"

    def calculate_pay(self) -> float:
        bonus = self.years_experience * 1000
        language_bonus = len(self.languages) * 500
        return self._base_salary + bonus + language_bonus

    def knows_language(self, lang: str) -> bool:
        return lang.lower() in [l.lower() for l in self.languages]


class Manager(Employee):
    """Engineering manager."""

    def __init__(self, name: str, employee_id: str, base_salary: float,
                 team_size: int = 0):
        super().__init__(name, employee_id, base_salary)
        self._team: List[Employee] = []
        self._team_size = team_size

    def role(self) -> str:
        return "Manager"

    def calculate_pay(self) -> float:
        team_bonus = len(self._team) * 2000
        return self._base_salary + team_bonus

    def add_report(self, employee: Employee) -> None:
        self._team.append(employee)

    def get_team(self) -> List[Employee]:
        return self._team.copy()

    def get_team_size(self) -> int:
        return len(self._team)


class Contractor(Employee):
    """Contractor with hourly rate."""

    def __init__(self, name: str, employee_id: str, hourly_rate: float,
                 hours_worked: int):
        super().__init__(name, employee_id, hourly_rate)
        self.hourly_rate = hourly_rate
        self.hours_worked = hours_worked

    def role(self) -> str:
        return "Contractor"

    def calculate_pay(self) -> float:
        return self.hourly_rate * self.hours_worked


# ============================================================
# 3. Composition Example
# ============================================================

class Address:
    """Represents a physical address."""

    def __init__(self, street: str, city: str, state: str, zip_code: str):
        self.street = street
        self.city = city
        self.state = state
        self.zip_code = zip_code

    def __str__(self) -> str:
        return f"{self.street}, {self.city}, {self.state} {self.zip_code}"


class Person:
    """Person with composition (has-a Address)."""

    def __init__(self, name: str, age: int, address: Address):
        self.name = name
        self.age = age
        self.address = address

    def move(self, new_address: Address) -> None:
        self.address = new_address

    def __repr__(self) -> str:
        return f"Person('{self.name}', {self.age}, {self.address})"


# ============================================================
# 4. Decorator Pattern
# ============================================================

class TextProcessor:
    """Base text processor."""

    def process(self, text: str) -> str:
        return text


class TextDecorator(TextProcessor):
    """Base decorator for text processors."""

    def __init__(self, wrapped: TextProcessor):
        self._wrapped = wrapped

    def process(self, text: str) -> str:
        return self._wrapped.process(text)


class UpperCaseDecorator(TextDecorator):
    """Converts text to uppercase."""

    def process(self, text: str) -> str:
        return super().process(text).upper()


class TrimDecorator(TextDecorator):
    """Trims whitespace from text."""

    def process(self, text: str) -> str:
        return super().process(text).strip()


class ReplaceDecorator(TextDecorator):
    """Replaces occurrences of a substring."""

    def __init__(self, wrapped: TextProcessor, old: str, new: str):
        super().__init__(wrapped)
        self.old = old
        self.new = new

    def process(self, text: str) -> str:
        return super().process(text).replace(self.old, self.new)


# ============================================================
# 5. Iterator Pattern
# ============================================================

class FibonacciIterator:
    """Iterates through Fibonacci numbers."""

    def __init__(self, max_count: int):
        self.max_count = max_count
        self.count = 0
        self.a, self.b = 0, 1

    def __iter__(self):
        return self

    def __next__(self) -> int:
        if self.count >= self.max_count:
            raise StopIteration
        self.count += 1
        result = self.a
        self.a, self.b = self.b, self.a + self.b
        return result


# ============================================================
# Demo
# ============================================================

if __name__ == "__main__":
    # Student example
    alice = Student("Alice", "S001")
    alice.add_grade(95)
    alice.add_grade(87)
    alice.add_grade(92)
    print(f"Student: {alice}")
    print(f"Honor Roll: {alice.is_honor_roll()}")

    print()

    # Employee hierarchy
    dev = Developer("Bob", "E001", 80000, ["Python", "Java"], 5)
    manager = Manager("Carol", "E002", 100000)
    manager.add_report(dev)
    contractor = Contractor("Dave", "C001", 75, 160)

    for emp in [dev, manager, contractor]:
        print(f"{emp} - Pay: ${emp.calculate_pay():,.2f}")

    print()

    # Composition
    addr = Address("123 Main St", "Springfield", "IL", "62704")
    person = Person("Eve", 30, addr)
    print(f"Before: {person}")
    new_addr = Address("456 Oak Ave", "Chicago", "IL", "60601")
    person.move(new_addr)
    print(f"After: {person}")

    print()

    # Decorator pattern
    processor = UpperCaseDecorator(TrimDecorator(TextProcessor()))
    result = processor.process("  hello world  ")
    print(f"Decorated: '{result}'")

    # Chained decorators
    processor2 = ReplaceDecorator(
        UpperCaseDecorator(TextProcessor()),
        "WORLD", "PYTHON"
    )
    result2 = processor2.process("hello world")
    print(f"Chained: '{result2}'")

    print()

    # Iterator
    print("Fibonacci:", list(FibonacciIterator(10)))
