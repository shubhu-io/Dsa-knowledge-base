# Behavioral Design Patterns

Behavioral patterns are concerned with algorithms and the assignment of responsibilities between objects.

---

## 1. Observer Pattern

### Intent
Define a one-to-many dependency between objects so that when one object changes state, all its dependents are notified and updated automatically.

### When to Use
- Event handling systems
- UI data binding
- News tickers
- Stock price updates
- Chat applications

### Implementation

```python
from abc import ABC, abstractmethod
from datetime import datetime
from typing import Any

# Observer interface
class Observer(ABC):
    @abstractmethod
    def update(self, subject: 'Subject', event: str, data: Any = None):
        pass

# Subject
class Subject(ABC):
    def __init__(self):
        self._observers: list[Observer] = []
        self._state: Any = None

    def attach(self, observer: Observer):
        if observer not in self._observers:
            self._observers.append(observer)

    def detach(self, observer: Observer):
        self._observers.remove(observer)

    def notify(self, event: str, data: Any = None):
        for observer in self._observers:
            observer.update(self, event, data)

    @property
    def state(self):
        return self._state

# Concrete Subject - Stock Market
class StockMarket(Subject):
    def __init__(self):
        super().__init__()
        self._stocks: dict[str, float] = {}

    def add_stock(self, symbol: str, price: float):
        self._stocks[symbol] = price
        self.notify("stock_added", {"symbol": symbol, "price": price})

    def update_price(self, symbol: str, new_price: float):
        old_price = self._stocks.get(symbol, 0)
        self._stocks[symbol] = new_price
        change = new_price - old_price
        self.notify("price_changed", {
            "symbol": symbol,
            "old_price": old_price,
            "new_price": new_price,
            "change": change
        })

    def remove_stock(self, symbol: str):
        if symbol in self._stocks:
            del self._stocks[symbol]
            self.notify("stock_removed", {"symbol": symbol})

    def get_price(self, symbol: str) -> float:
        return self._stocks.get(symbol, 0)

# Concrete Observers
class MobileApp(Observer):
    def __init__(self, user_id: str):
        self.user_id = user_id

    def update(self, subject: Subject, event: str, data: Any = None):
        if event == "price_changed":
            change = data["change"]
            symbol = data["symbol"]
            emoji = "📈" if change > 0 else "📉"
            print(f"📱 Mobile App [{self.user_id}]: {emoji} {symbol}: "
                  f"${data['new_price']:.2f} ({change:+.2f})")

class WebDashboard(Observer):
    def __init__(self):
        self.updates: list[dict] = []

    def update(self, subject: Subject, event: str, data: Any = None):
        self.updates.append({
            "event": event,
            "data": data,
            "timestamp": datetime.now()
        })
        if event == "price_changed":
            print(f"🌐 Dashboard: Updated {data['symbol']} → ${data['new_price']:.2f}")

class EmailAlert(Observer):
    def __init__(self, email: str, threshold: float = 5.0):
        self.email = email
        self.threshold = threshold

    def update(self, subject: Subject, event: str, data: Any = None):
        if event == "price_changed" and abs(data["change"]) > self.threshold:
            direction = "up" if data["change"] > 0 else "down"
            print(f"📧 Alert to {self.email}: {data['symbol']} moved {direction} "
                  f"by ${abs(data['change']):.2f}")

# Usage
market = StockMarket()

# Register observers
mobile = MobileApp("user123")
dashboard = WebDashboard()
alert = EmailAlert("trader@example.com", threshold=3.0)

market.attach(mobile)
market.attach(dashboard)
market.attach(alert)

# Add stocks
market.add_stock("AAPL", 150.00)
market.add_stock("GOOG", 2800.00)

# Update prices - notifies all observers
print("\n--- Price Updates ---")
market.update_price("AAPL", 155.50)  # Small change
market.update_price("GOOG", 2780.00)  # Large change, triggers email

# Remove observer
market.detach(alert)
print("\n--- After removing email alert ---")
market.update_price("AAPL", 145.00)
```

---

## 2. Strategy Pattern

### Intent
Define a family of algorithms, encapsulate each one, and make them interchangeable. Strategy lets the algorithm vary independently from clients that use it.

### When to Use
- Multiple algorithms for a specific task
- Need to switch algorithms at runtime
- Eliminate conditional statements

### Implementation

```python
from abc import ABC, abstractmethod
from dataclasses import dataclass

@dataclass
class Order:
    items: list[dict]
    total: float

# Strategy Interface
class DiscountStrategy(ABC):
    @abstractmethod
    def calculate(self, order: Order) -> float:
        pass

    @abstractmethod
    def name(self) -> str:
        pass

# Concrete Strategies
class NoDiscount(DiscountStrategy):
    def calculate(self, order: Order) -> float:
        return 0

    def name(self) -> str:
        return "No Discount"

class PercentageDiscount(DiscountStrategy):
    def __init__(self, percentage: float):
        self.percentage = percentage

    def calculate(self, order: Order) -> float:
        return order.total * (self.percentage / 100)

    def name(self) -> str:
        return f"{self.percentage}% Off"

class FixedDiscount(DiscountStrategy):
    def __init__(self, amount: float, minimum: float = 0):
        self.amount = amount
        self.minimum = minimum

    def calculate(self, order: Order) -> float:
        if order.total >= self.minimum:
            return min(self.amount, order.total)
        return 0

    def name(self) -> str:
        return f"${self.amount} Off (min ${self.minimum})"

class BuyOneGetOneFree(DiscountStrategy):
    def calculate(self, order: Order) -> float:
        if len(order.items) >= 2:
            cheapest = min(order.items, key=lambda x: x["price"])
            return cheapest["price"]
        return 0

    def name(self) -> str:
        return "Buy One Get One Free"

class LoyaltyDiscount(DiscountStrategy):
    def __init__(self, points: int):
        self.points = points

    def calculate(self, order: Order) -> float:
        discount_rate = min(self.points / 1000, 0.20)  # Max 20%
        return order.total * discount_rate

    def name(self) -> str:
        return f"Loyalty ({self.points} pts)"

# Context
class ShoppingCart:
    def __init__(self):
        self.items: list[dict] = []
        self._discount_strategy: DiscountStrategy = NoDiscount()

    def add_item(self, name: str, price: float, quantity: int = 1):
        self.items.append({"name": name, "price": price, "quantity": quantity})

    @property
    def subtotal(self) -> float:
        return sum(i["price"] * i["quantity"] for i in self.items)

    def set_discount(self, strategy: DiscountStrategy):
        self._discount_strategy = strategy

    def calculate_discount(self) -> float:
        return self._discount_strategy.calculate(
            Order(self.items, self.subtotal)
        )

    def checkout(self) -> dict:
        discount = self.calculate_discount()
        total = self.subtotal - discount
        return {
            "subtotal": f"${self.subtotal:.2f}",
            "discount": f"-${discount:.2f} ({self._discount_strategy.name()})",
            "total": f"${total:.2f}"
        }

# Usage
cart = ShoppingCart()
cart.add_item("Laptop", 999.99)
cart.add_item("Mouse", 29.99, 2)
cart.add_item("Keyboard", 79.99)

# Try different strategies
strategies = [
    NoDiscount(),
    PercentageDiscount(15),
    FixedDiscount(50, minimum=200),
    BuyOneGetOneFree(),
    LoyaltyDiscount(500),
]

for strategy in strategies:
    cart.set_discount(strategy)
    result = cart.checkout()
    print(f"\n{strategy.name()}:")
    for k, v in result.items():
        print(f"  {k}: {v}")
```

---

## 3. Command Pattern

### Intent
Encapsulate a request as an object, thereby letting you parameterize clients with different requests, queue requests, and support undoable operations.

### When to Use
- Undo/redo functionality
- Queue operations
- Logging operations
- Remote controls
- Transaction systems

### Implementation

```python
from abc import ABC, abstractmethod
from datetime import datetime

# Command interface
class Command(ABC):
    @abstractmethod
    def execute(self) -> str:
        pass

    @abstractmethod
    def undo(self) -> str:
        pass

    @abstractmethod
    def description(self) -> str:
        pass

# Receiver
class TextDocument:
    def __init__(self):
        self.content = ""
        self.cursor_pos = 0

    def insert(self, text: str, position: int):
        self.content = self.content[:position] + text + self.content[position:]
        self.cursor_pos = position + len(text)

    def delete(self, position: int, length: int) -> str:
        deleted = self.content[position:position+length]
        self.content = self.content[:position] + self.content[position+length:]
        self.cursor_pos = position
        return deleted

    def replace(self, position: int, length: int, new_text: str) -> str:
        old = self.content[position:position+length]
        self.content = (self.content[:position] + new_text +
                       self.content[position+length:])
        self.cursor_pos = position + len(new_text)
        return old

    def __str__(self):
        return self.content

# Concrete Commands
class InsertCommand(Command):
    def __init__(self, document: TextDocument, text: str, position: int):
        self.document = document
        self.text = text
        self.position = position

    def execute(self) -> str:
        self.document.insert(self.text, self.position)
        return f"Inserted '{self.text}' at position {self.position}"

    def undo(self) -> str:
        self.document.delete(self.position, len(self.text))
        return f"Undid insert of '{self.text}'"

    def description(self) -> str:
        return f"Insert('{self.text}', pos={self.position})"

class DeleteCommand(Command):
    def __init__(self, document: TextDocument, position: int, length: int):
        self.document = document
        self.position = position
        self.length = length
        self._deleted_text = ""

    def execute(self) -> str:
        self._deleted_text = self.document.delete(self.position, self.length)
        return f"Deleted '{self._deleted_text}'"

    def undo(self) -> str:
        self.document.insert(self._deleted_text, self.position)
        return f"Restored '{self._deleted_text}'"

    def description(self) -> str:
        return f"Delete(pos={self.position}, len={self.length})"

class ReplaceCommand(Command):
    def __init__(self, document: TextDocument, old_text: str, new_text: str):
        self.document = document
        self.old_text = old_text
        self.new_text = new_text
        self._position = -1

    def execute(self) -> str:
        self._position = self.document.content.find(self.old_text)
        if self._position == -1:
            return f"'{self.old_text}' not found"
        self.document.replace(self._position, len(self.old_text), self.new_text)
        return f"Replaced '{self.old_text}' with '{self.new_text}'"

    def undo(self) -> str:
        self.document.replace(self._position, len(self.new_text), self.old_text)
        return f"Reverted '{self.new_text}' to '{self.old_text}'"

    def description(self) -> str:
        return f"Replace('{self.old_text}' → '{self.new_text}')"

# Invoker
class TextEditor:
    def __init__(self, document: TextDocument):
        self.document = document
        self._history: list[Command] = []
        self._redo_stack: list[Command] = []

    def execute(self, command: Command):
        result = command.execute()
        self._history.append(command)
        self._redo_stack.clear()
        print(f"✓ {command.description()}: {result}")

    def undo(self):
        if not self._history:
            print("Nothing to undo")
            return
        command = self._history.pop()
        result = command.undo()
        self._redo_stack.append(command)
        print(f"↩ Undo: {result}")

    def redo(self):
        if not self._redo_stack:
            print("Nothing to redo")
            return
        command = self._redo_stack.pop()
        result = command.execute()
        self._history.append(command)
        print(f"↪ Redo: {result}")

    def show_history(self):
        print("\n--- History ---")
        for i, cmd in enumerate(self._history):
            print(f"  {i+1}. {cmd.description()}")

# Usage
doc = TextDocument()
editor = TextEditor(doc)

editor.execute(InsertCommand(doc, "Hello World", 0))
editor.execute(InsertCommand(doc, " Beautiful", 5))
print(f"Document: {doc}\n")

editor.execute(DeleteCommand(doc, 5, 9))
print(f"Document: {doc}\n")

editor.undo()
print(f"Document: {doc}\n")

editor.redo()
print(f"Document: {doc}\n")

editor.show_history()
```

---

## 4. State Pattern

### Intent
Allow an object to alter its behavior when its internal state changes. The object will appear to change its class.

### When to Use
- Object behavior depends on its state
- Complex state transitions
- State machines (elevators, traffic lights, games)

### Implementation

```python
from abc import ABC, abstractmethod
from enum import Enum

# State interface
class State(ABC):
    @abstractmethod
    def insert_coin(self, machine: 'VendingMachine'):
        pass

    @abstractmethod
    def select_product(self, machine: 'VendingMachine', code: str):
        pass

    @abstractmethod
    def dispense(self, machine: 'VendingMachine'):
        pass

    @abstractmethod
    def refund(self, machine: 'VendingMachine'):
        pass

# Concrete States
class IdleState(State):
    def insert_coin(self, machine: 'VendingMachine'):
        machine.balance = 0
        machine.state = HasCoinState()
        print(f"💰 Coin inserted. Balance: ${machine.balance:.2f}")

    def select_product(self, machine: 'VendingMachine', code: str):
        print("⚠️  Please insert coin first")

    def dispense(self, machine: 'VendingMachine'):
        print("⚠️  Please insert coin and select product")

    def refund(self, machine: 'VendingMachine'):
        print("⚠️  No money to refund")

class HasCoinState(State):
    def insert_coin(self, machine: 'VendingMachine'):
        print("⚠️  Coin already inserted. Select product or refund.")

    def select_product(self, machine: 'VendingMachine', code: str):
        if code not in machine.inventory:
            print(f"❌ Product {code} not found")
            return
        if machine.inventory[code] <= 0:
            print(f"❌ Product {code} sold out")
            return

        product = machine.products[code]
        if machine.balance < product.price:
            needed = product.price - machine.balance
            print(f"❌ Insufficient funds. Need ${needed:.2f} more")
            return

        machine.selected_product = code
        machine.state = DispensingState()
        print(f"✅ Product selected: {product.name} (${product.price:.2f})")
        machine.dispense()

    def dispense(self, machine: 'VendingMachine'):
        print("⚠️  Select a product first")

    def refund(self, machine: 'VendingMachine'):
        refund_amount = machine.balance
        machine.balance = 0
        machine.state = IdleState()
        print(f"💵 Refunded ${refund_amount:.2f}")

class DispensingState(State):
    def insert_coin(self, machine: 'VendingMachine'):
        print("⚠️  Please wait, dispensing product...")

    def select_product(self, machine: 'VendingMachine', code: str):
        print("⚠️  Please wait, dispensing product...")

    def dispense(self, machine: 'VendingMachine'):
        code = machine.selected_product
        product = machine.products[code]
        change = machine.balance - product.price

        machine.inventory[code] -= 1
        machine.balance = 0
        machine.selected_product = None

        print(f"📦 Dispensing {product.name}")
        if change > 0:
            print(f"💵 Change: ${change:.2f}")

        machine.state = IdleState()
        print("✅ Transaction complete")

    def refund(self, machine: 'VendingMachine'):
        print("⚠️  Cannot refund while dispensing")

# Context
class VendingMachine:
    def __init__(self):
        self.state: State = IdleState()
        self.balance: float = 0
        self.selected_product: str = None
        self.products: dict[str, 'Product'] = {}
        self.inventory: dict[str, int] = {}

    def add_product(self, code: str, product: 'Product', quantity: int):
        self.products[code] = product
        self.inventory[code] = self.inventory.get(code, 0) + quantity

    def insert_coin(self, amount: float):
        self.balance += amount
        self.state.insert_coin(self)

    def select_product(self, code: str):
        self.state.select_product(self, code)

    def refund(self):
        self.state.refund(self)

from dataclasses import dataclass

@dataclass
class Product:
    name: str
    price: float

# Usage
machine = VendingMachine()
machine.add_product("A1", Product("Cola", 1.50), 5)
machine.add_product("B2", Product("Chips", 2.00), 3)
machine.add_product("C3", Product("Candy", 1.00), 10)

# Normal transaction
print("=== Normal Transaction ===")
machine.insert_coin(1.00)
machine.insert_coin(1.00)  # Already have coin
machine.select_product("A1")

# Insufficient funds
print("\n=== Insufficient Funds ===")
machine.insert_coin(0.50)
machine.select_product("B2")  # Not enough

# Refund
print("\n=== Refund ===")
machine.insert_coin(0.50)
machine.refund()
```

---

## 5. Iterator Pattern

### Intent
Provide a way to access elements of an aggregate object sequentially without exposing its underlying representation.

### Implementation

```python
from typing import Any, Optional

class Iterator:
    def __init__(self, collection: list):
        self._collection = collection
        self._index = 0

    def __iter__(self):
        return self

    def __next__(self):
        if self._index >= len(self._collection):
            raise StopIteration
        value = self._collection[self._index]
        self._index += 1
        return value

    def has_next(self) -> bool:
        return self._index < len(self._collection)

    def reset(self):
        self._index = 0

class BookCollection:
    def __init__(self):
        self._books: list[str] = []

    def add(self, book: str):
        self._books.append(book)

    def __iter__(self):
        return Iterator(self._books)

    def __len__(self):
        return len(self._books)

    def filter(self, predicate) -> 'BookCollection':
        result = BookCollection()
        for book in self._books:
            if predicate(book):
                result.add(book)
        return result

# Pythonic iterator using generators
class Range:
    def __init__(self, start: int, end: int, step: int = 1):
        self.start = start
        self.end = end
        self.step = step

    def __iter__(self):
        current = self.start
        while current < self.end:
            yield current
            current += self.step

# Usage
collection = BookCollection()
collection.add("Python Crash Course")
collection.add("Clean Code")
collection.add("Design Patterns")
collection.add("The Pragmatic Programmer")

for book in collection:
    print(f"📖 {book}")

# Generator-based iterator
for num in Range(0, 10, 2):
    print(num, end=" ")
print()
```

---

## 6. Template Method Pattern

### Intent
Define the skeleton of an algorithm in an operation, deferring some steps to subclasses. Lets subclasses redefine certain steps without changing the algorithm's structure.

### Implementation

```python
from abc import ABC, abstractmethod
from datetime import datetime

class DataProcessor(ABC):
    """Template class defining the algorithm skeleton"""

    def process(self, data: str) -> dict:
        """Template method"""
        start_time = datetime.now()

        cleaned = self.clean_data(data)
        validated = self.validate(cleaned)
        transformed = self.transform(validated)
        result = self.save(transformed)

        duration = (datetime.now() - start_time).total_seconds()

        return {
            "success": True,
            "records_processed": len(transformed),
            "duration_seconds": duration,
            "output": result
        }

    @abstractmethod
    def clean_data(self, data: str) -> list:
        """Step 1: Clean the raw data"""
        pass

    @abstractmethod
    def validate(self, data: list) -> list:
        """Step 2: Validate the data"""
        pass

    @abstractmethod
    def transform(self, data: list) -> list:
        """Step 3: Transform the data"""
        pass

    @abstractmethod
    def save(self, data: list) -> str:
        """Step 4: Save the processed data"""
        pass

class CSVProcessor(DataProcessor):
    def clean_data(self, data: str) -> list:
        lines = data.strip().split("\n")
        return [line.split(",") for line in lines if line]

    def validate(self, data: list) -> list:
        return [row for row in data if len(row) >= 2]

    def transform(self, data: list) -> list:
        return [{"name": row[0], "value": float(row[1])} for row in data]

    def save(self, data: list) -> str:
        return f"Saved {len(data)} records to CSV"

class JSONProcessor(DataProcessor):
    def clean_data(self, data: str) -> list:
        import json
        return json.loads(data)

    def validate(self, data: list) -> list:
        return [item for item in data if "name" in item and "value" in item]

    def transform(self, data: list) -> list:
        return [{"name": item["name"].upper(), "value": item["value"] * 2}
                for item in data]

    def save(self, data: list) -> str:
        return f"Saved {len(data)} records to JSON"

# Usage
csv_data = """Alice,100
Bob,200
Charlie,150"""

json_data = '[{"name": "Dave", "value": 50}, {"name": "Eve", "value": 75}]'

csv_processor = CSVProcessor()
result = csv_processor.process(csv_data)
print(f"CSV: {result}")

json_processor = JSONProcessor()
result = json_processor.process(json_data)
print(f"JSON: {result}")
```

---

## 7. Chain of Responsibility Pattern

### Intent
Avoid coupling the sender of a request to its receiver by giving more than one object a chance to handle the request. Chain the receiving objects and pass the request along the chain.

### Implementation

```python
from abc import ABC, abstractmethod
from dataclasses import dataclass
from typing import Optional

@dataclass
class SupportTicket:
    level: str  # low, medium, high, critical
    message: str
    customer: str

class Handler(ABC):
    def __init__(self):
        self._next: Optional['Handler'] = None

    def set_next(self, handler: 'Handler') -> 'Handler':
        self._next = handler
        return handler

    def handle(self, ticket: SupportTicket) -> str:
        if self.can_handle(ticket):
            return self.process(ticket)
        elif self._next:
            return self._next.handle(ticket)
        else:
            return f"No handler available for {ticket.level} ticket"

    @abstractmethod
    def can_handle(self, ticket: SupportTicket) -> bool:
        pass

    @abstractmethod
    def process(self, ticket: SupportTicket) -> str:
        pass

class Level1Support(Handler):
    def can_handle(self, ticket: SupportTicket) -> bool:
        return ticket.level == "low"

    def process(self, ticket: SupportTicket) -> str:
        return f"L1 Support: Resolved '{ticket.message}' for {ticket.customer}"

class Level2Support(Handler):
    def can_handle(self, ticket: SupportTicket) -> bool:
        return ticket.level == "medium"

    def process(self, ticket: SupportTicket) -> str:
        return f"L2 Support: Escalated and resolved '{ticket.message}' for {ticket.customer}"

class Level3Support(Handler):
    def can_handle(self, ticket: SupportTicket) -> bool:
        return ticket.level in ("high", "critical")

    def process(self, ticket: SupportTicket) -> str:
        return f"L3 Support: Critical fix applied for '{ticket.message}' ({ticket.customer})"

# Build the chain
l1 = Level1Support()
l2 = Level2Support()
l3 = Level3Support()
l1.set_next(l2).set_next(l3)

# Test
tickets = [
    SupportTicket("low", "Password reset", "Alice"),
    SupportTicket("medium", "Can't access dashboard", "Bob"),
    SupportTicket("high", "Server down", "Charlie"),
    SupportTicket("critical", "Data breach detected", "Dave"),
]

for ticket in tickets:
    result = l1.handle(ticket)
    print(f"  {result}")
```

---

## Behavioral Patterns Comparison

| Pattern | Purpose | Use Case | Complexity |
|---------|---------|----------|-----------|
| **Observer** | One-to-many notification | Events, UI updates | Medium |
| **Strategy** | Algorithm selection | Payment, sorting, routing | Low |
| **Command** | Request encapsulation | Undo/redo, queuing | Medium |
| **State** | State-dependent behavior | Vending machine, games | Medium |
| **Iterator** | Sequential access | Collections, traversals | Low |
| **Template** | Algorithm skeleton | Data processing, workflows | Low |
| **Chain of Responsibility** | Processing chain | Request handling, middleware | Medium |
| **Mediator** | Centralized communication | Chat rooms, air traffic | Medium |
| **Visitor** | Add operations | AST processing, reporting | High |
| **Memento** | State preservation | Undo/redo, snapshots | Medium |

---

## LLD Interview Usage

| Problem | Behavioral Patterns |
|---------|---------------------|
| Parking Lot | State (ticket states), Strategy (payment) |
| Elevator | State (elevator states), Observer (floor requests) |
| Chess | Command (moves), Strategy (AI), State (game state) |
| Chat App | Observer (messages), Mediator (chat room) |
| E-Commerce | Strategy (discounts), Command (orders), Observer (notifications) |
| Traffic Light | State (light states), Observer (sensor updates) |
