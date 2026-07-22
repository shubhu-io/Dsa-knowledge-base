# Object-Oriented Programming — The 4 Pillars Deep Dive

## The Four Pillars at a Glance

| Pillar | Core Idea | Key Benefit |
|--------|-----------|-------------|
| **Encapsulation** | Hide internal state | Data protection, simpler interface |
| **Abstraction** | Show only essentials | Reduced complexity |
| **Inheritance** | Reuse via hierarchy | Code reuse, logical structure |
| **Polymorphism** | One interface, many forms | Flexibility, extensibility |

---

## Pillar 1: Encapsulation

### Definition
Encapsulation is the bundling of data (attributes) and methods that operate on that data into a single unit (class), while restricting direct access to some components.

### Purpose
- Protect object integrity by controlling access
- Reduce coupling between components
- Provide a clean, simple public interface

### Implementation in Python

```python
class TemperatureSensor:
    def __init__(self, location: str):
        self.location = location
        self._reading: float = 0.0    # Protected
        self.__calibration: float = 1.0  # Private

    @property
    def reading(self) -> float:
        """Public read-only access to temperature"""
        return self._reading * self.__calibration

    def update_reading(self, raw_value: float):
        """Controlled write access with validation"""
        if -50 <= raw_value <= 150:
            self._reading = raw_value
        else:
            raise ValueError(f"Invalid temperature: {raw_value}")

    def calibrate(self, factor: float):
        """Only authorized code can calibrate"""
        if 0.9 <= factor <= 1.1:
            self.__calibration = factor
        else:
            raise ValueError("Calibration factor out of range")

    def __repr__(self):
        return f"TempSensor({self.location}: {self.reading}°C)"
```

### Real-World Example: Bank Account

```python
from datetime import datetime
from typing import Optional

class Transaction:
    def __init__(self, amount: float, txn_type: str):
        self.amount = amount
        self.type = txn_type
        self.timestamp = datetime.now()
        self.balance_after: Optional[float] = None

class BankAccount:
    def __init__(self, owner: str, initial_balance: float = 0):
        self._owner = owner
        self.__balance = initial_balance
        self.__transactions: list[Transaction] = []

    @property
    def balance(self) -> float:
        return self.__balance

    @property
    def owner(self) -> str:
        return self._owner

    def deposit(self, amount: float) -> Transaction:
        if amount <= 0:
            raise ValueError("Deposit amount must be positive")
        self.__balance += amount
        txn = Transaction(amount, "DEPOSIT")
        txn.balance_after = self.__balance
        self.__transactions.append(txn)
        return txn

    def withdraw(self, amount: float) -> Transaction:
        if amount <= 0:
            raise ValueError("Withdrawal must be positive")
        if amount > self.__balance:
            raise ValueError("Insufficient funds")
        self.__balance -= amount
        txn = Transaction(-amount, "WITHDRAWAL")
        txn.balance_after = self.__balance
        self.__transactions.append(txn)
        return txn

    def get_statement(self) -> list[dict]:
        return [
            {
                "type": t.type,
                "amount": t.amount,
                "balance": t.balance_after,
                "date": t.timestamp.isoformat()
            }
            for t in self.__transactions
        ]

# Usage
account = BankAccount("Alice", 1000)
account.deposit(500)
account.withdraw(200)
print(account.balance)  # 1300
# account.__balance = 999999  # Doesn't work!
```

---

## Pillar 2: Abstraction

### Definition
Abstraction is the process of hiding implementation details and showing only the essential features of an object.

### Purpose
- Reduce programming complexity
- Focus on what an object does, not how
- Enable loose coupling

### Abstract Classes vs Interfaces

```python
from abc import ABC, abstractmethod

# Abstract Class - can have implementation
class Vehicle(ABC):
    def __init__(self, make: str, model: str):
        self.make = make
        self.model = model
        self._odometer = 0

    @abstractmethod
    def start_engine(self) -> str:
        """Each vehicle starts differently"""
        pass

    @abstractmethod
    def fuel_type(self) -> str:
        pass

    def drive(self, miles: int) -> str:
        """Concrete method - shared by all vehicles"""
        self._odometer += miles
        return f"Drove {miles} miles. Total: {self._odometer}"

    def info(self) -> str:
        return f"{self.make} {self.model} ({self.fuel_type()})"

# Interface (Protocol) - pure contract
from typing import Protocol

class Drivable(Protocol):
    def drive(self, miles: int) -> str: ...

class Fuelable(Protocol):
    def fuel_type(self) -> str: ...
```

### Real-World Example: Payment System

```python
from abc import ABC, abstractmethod
from dataclasses import dataclass
from typing import Optional

@dataclass
class PaymentResult:
    success: bool
    transaction_id: Optional[str]
    message: str

class PaymentProcessor(ABC):
    """Abstraction - hides payment implementation details"""

    @abstractmethod
    def authorize(self, amount: float) -> bool:
        pass

    @abstractmethod
    def capture(self, amount: float) -> PaymentResult:
        pass

    @abstractmethod
    def refund(self, transaction_id: str, amount: float) -> PaymentResult:
        pass

class StripeProcessor(PaymentProcessor):
    def authorize(self, amount: float) -> bool:
        print(f"Authorizing ${amount} via Stripe...")
        return True

    def capture(self, amount: float) -> PaymentResult:
        print(f"Capturing ${amount} via Stripe")
        return PaymentResult(True, "stripe_txn_123", "Success")

    def refund(self, transaction_id: str, amount: float) -> PaymentResult:
        print(f"Refunding ${amount} from {transaction_id}")
        return PaymentResult(True, "stripe_refund_456", "Refunded")

class PayPalProcessor(PaymentProcessor):
    def authorize(self, amount: float) -> bool:
        print(f"Authorizing ${amount} via PayPal...")
        return True

    def capture(self, amount: float) -> PaymentResult:
        print(f"Capturing ${amount} via PayPal")
        return PaymentResult(True, "paypal_txn_789", "Success")

    def refund(self, transaction_id: str, amount: float) -> PaymentResult:
        print(f"Refunding ${amount} from {transaction_id}")
        return PaymentResult(True, "paypal_refund_012", "Refunded")

# Client code - doesn't know which processor is used
class CheckoutService:
    def __init__(self, processor: PaymentProcessor):
        self.processor = processor

    def process_order(self, amount: float) -> PaymentResult:
        if self.processor.authorize(amount):
            return self.processor.capture(amount)
        return PaymentResult(False, None, "Authorization failed")

# Easy to swap implementations
checkout = CheckoutService(StripeProcessor())
checkout.process_order(99.99)

checkout = CheckoutService(PayPalProcessor())
checkout.process_order(49.99)
```

---

## Pillar 3: Inheritance

### Definition
Inheritance allows a class to inherit attributes and methods from another class, promoting code reuse and establishing relationships.

### Types of Inheritance

```python
# 1. Single Inheritance
class Animal:
    def __init__(self, name: str):
        self.name = name

    def speak(self) -> str:
        return "..."

class Dog(Animal):
    def speak(self) -> str:
        return "Woof!"

# 2. Multilevel Inheritance
class ServiceAnimal(Dog):
    def __init__(self, name: str, job: str):
        super().__init__(name)
        self.job = job

    def work(self) -> str:
        return f"{self.name} is working as {self.job}"

# 3. Hierarchical Inheritance
class Cat(Animal):
    def speak(self) -> str:
        return "Meow!"

class Bird(Animal):
    def speak(self) -> str:
        return "Tweet!"

    def fly(self) -> str:
        return f"{self.name} is flying"
```

### When to Use Inheritance

| Use Inheritance | Use Composition |
|----------------|-----------------|
| Clear IS-A relationship | HAS-A relationship |
| Need to reuse interface | Need to reuse behavior |
| Hierarchy is shallow (2-3 levels) | Flexibility is important |
| Frameworks requiring inheritance | Most real-world scenarios |

### Example: Employee Hierarchy

```python
from abc import ABC, abstractmethod
from datetime import datetime

class Employee(ABC):
    def __init__(self, name: str, emp_id: int, base_salary: float):
        self.name = name
        self.emp_id = emp_id
        self.base_salary = base_salary
        self.hire_date = datetime.now()

    @abstractmethod
    def calculate_pay(self) -> float:
        pass

    @abstractmethod
    def role(self) -> str:
        pass

    def __repr__(self):
        return f"{self.role()}({self.name}, ID:{self.emp_id})"

class FullTimeEmployee(Employee):
    def __init__(self, name: str, emp_id: int, salary: float,
                 benefits: float = 0):
        super().__init__(name, emp_id, salary)
        self.benefits = benefits

    def calculate_pay(self) -> float:
        return self.base_salary + self.benefits

    def role(self) -> str:
        return "FullTime"

class Contractor(Employee):
    def __init__(self, name: str, emp_id: int, hourly_rate: float,
                 hours_worked: int):
        super().__init__(name, emp_id, hourly_rate * hours_worked)
        self.hourly_rate = hourly_rate
        self.hours_worked = hours_worked

    def calculate_pay(self) -> float:
        return self.hourly_rate * self.hours_worked

    def role(self) -> str:
        return "Contractor"

class Manager(FullTimeEmployee):
    def __init__(self, name: str, emp_id: int, salary: float,
                 bonus: float = 0):
        super().__init__(name, emp_id, salary)
        self.bonus = bonus
        self.direct_reports: list[Employee] = []

    def add_report(self, employee: Employee):
        self.direct_reports.append(employee)

    def calculate_pay(self) -> float:
        return super().calculate_pay() + self.bonus

    def role(self) -> str:
        return "Manager"

# Polymorphic usage
employees = [
    FullTimeEmployee("Alice", 1, 80000),
    Contractor("Bob", 2, 50, 160),
    Manager("Carol", 3, 120000, bonus=20000),
]

for emp in employees:
    print(f"{emp}: ${emp.calculate_pay():,.2f}")
```

---

## Pillar 4: Polymorphism

### Definition
Polymorphism allows objects of different classes to be treated as objects of a common base class, with each class providing its own implementation.

### Types of Polymorphism

```python
from abc import ABC, abstractmethod

# 1. Compile-time (Method Overloading) - Python doesn't support directly
# Use default arguments instead
class Calculator:
    def add(self, a, b=0, c=0):
        return a + b + c

# 2. Runtime (Method Overriding) - True polymorphism
class PaymentMethod(ABC):
    @abstractmethod
    def pay(self, amount: float) -> str:
        pass

class CreditCard(PaymentMethod):
    def __init__(self, number: str):
        self.number = number

    def pay(self, amount: float) -> str:
        return f"Charged ${amount:.2f} to card ending {self.number[-4:]}"

class PayPal(PaymentMethod):
    def __init__(self, email: str):
        self.email = email

    def pay(self, amount: float) -> str:
        return f"Paid ${amount:.2f} via PayPal ({self.email})"

class ApplePay(PaymentMethod):
    def pay(self, amount: float) -> str:
        return f"Paid ${amount:.2f} via Apple Pay"
```

### Duck Typing (Python's Polymorphism)

```python
# "If it walks like a duck and quacks like a duck, it's a duck"

class PDFExporter:
    def export(self, data: str) -> bytes:
        return f"[PDF] {data}".encode()

class CSVExporter:
    def export(self, data: str) -> bytes:
        return f"[CSV] {data}".encode()

class JSONExporter:
    def export(self, data: str) -> bytes:
        return f'{{"data": "{data}}"}}'.encode()

# No common base class needed - just the same method name
def generate_report(exporter, data: str):
    return exporter.export(data)

# All work because they have the same method signature
print(generate_report(PDFExporter(), "sales data"))
print(generate_report(CSVExporter(), "sales data"))
print(generate_report(JSONExporter(), "sales data"))
```

### Real-World: Notification System

```python
from abc import ABC, abstractmethod
from typing import Protocol

class Notifiable(Protocol):
    def send(self, message: str) -> bool: ...

class EmailNotification:
    def __init__(self, email: str):
        self.email = email

    def send(self, message: str) -> bool:
        print(f"Email to {self.email}: {message}")
        return True

class SMSNotification:
    def __init__(self, phone: str):
        self.phone = phone

    def send(self, message: str) -> bool:
        print(f"SMS to {self.phone}: {message}")
        return True

class SlackNotification:
    def __init__(self, channel: str):
        self.channel = channel

    def send(self, message: str) -> bool:
        print(f"Slack #{self.channel}: {message}")
        return True

class NotificationService:
    def __init__(self, channels: list[Notifiable]):
        self.channels = channels

    def notify_all(self, message: str) -> dict[str, bool]:
        results = {}
        for channel in self.channels:
            channel_name = channel.__class__.__name__
            results[channel_name] = channel.send(message)
        return results

# Works with any object that has a send() method
service = NotificationService([
    EmailNotification("user@example.com"),
    SMSNotification("+1234567890"),
    SlackNotification("general"),
])
service.notify_all("Server is down!")
```

---

## Putting It All Together

### Complete OOP Design Example

```python
from abc import ABC, abstractmethod
from enum import Enum
from datetime import datetime

# Encapsulation + Abstraction
class OrderStatus(Enum):
    PENDING = "pending"
    CONFIRMED = "confirmed"
    SHIPPED = "shipped"
    DELIVERED = "delivered"

class Order(ABC):
    def __init__(self, order_id: str, customer: str):
        self._order_id = order_id
        self._customer = customer
        self._status = OrderStatus.PENDING
        self._created_at = datetime.now()
        self._items: list[dict] = []

    @property
    def status(self) -> OrderStatus:
        return self._status

    def add_item(self, name: str, price: float, qty: int):
        self._items.append({"name": name, "price": price, "qty": qty})

    @property
    def total(self) -> float:
        return sum(i["price"] * i["qty"] for i in self._items)

    @abstractmethod
    def calculate_shipping(self) -> float:
        pass

    # Polymorphism - each order type ships differently
    def ship(self):
        if self._status != OrderStatus.CONFIRMED:
            raise Exception("Order must be confirmed first")
        self._status = OrderStatus.SHIPPED

# Inheritance + Polymorphism
class DomesticOrder(Order):
    def calculate_shipping(self) -> float:
        return self.total * 0.05  # 5% domestic shipping

    def ship(self):
        super().ship()
        print(f"Shipping via ground transport")

class InternationalOrder(Order):
    def __init__(self, order_id: str, customer: str, country: str):
        super().__init__(order_id, customer)
        self.country = country

    def calculate_shipping(self) -> float:
        base = self.total * 0.10
        return base + 25.00  # 10% + $25 flat fee

    def ship(self):
        super().ship()
        print(f"Shipping internationally to {self.country}")

# Usage - polymorphic
orders = [DomesticOrder("D001", "Alice"), InternationalOrder("I001", "Bob", "UK")]
for order in orders:
    order.add_item("Widget", 9.99, 3)
    print(f"{order._order_id}: ${order.total:.2f} + ${order.calculate_shipping():.2f} shipping")
```

---

## Key Takeaways

| Principle | Remember |
|-----------|----------|
| **Encapsulation** | Hide internals, expose interface |
| **Abstraction** | Show what, hide how |
| **Inheritance** | IS-A relationship, code reuse |
| **Polymorphism** | Same interface, different behavior |
