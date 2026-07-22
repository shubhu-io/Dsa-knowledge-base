# Structural Design Patterns

Structural patterns deal with object composition, creating relationships between objects to form larger structures.

---

## 1. Adapter Pattern

### Intent
Convert the interface of a class into another interface clients expect. Adapter lets classes work together that couldn't otherwise because of incompatible interfaces.

### When to Use
- Integrating legacy systems
- Third-party library integration
- Working with incompatible APIs

### Implementation

```python
from abc import ABC, abstractmethod

# Target interface (what client expects)
class PaymentProcessor(ABC):
    @abstractmethod
    def pay(self, amount: float, currency: str) -> bool:
        pass

    @abstractmethod
    def refund(self, transaction_id: str, amount: float) -> bool:
        pass

# Legacy system with different interface
class OldPaymentGateway:
    def make_payment(self, money: int, curr_code: str) -> dict:
        return {"status": "success", "id": "txn_123"}

    def process_refund(self, txn_id: str, money: int) -> dict:
        return {"status": "refunded"}

# Adapter - makes OldPaymentGateway compatible with PaymentProcessor
class OldPaymentAdapter(PaymentProcessor):
    def __init__(self, old_gateway: OldPaymentGateway):
        self._gateway = old_gateway

    def pay(self, amount: float, currency: str) -> bool:
        # Convert float to int (cents)
        cents = int(amount * 100)
        result = self._gateway.make_payment(cents, currency)
        return result["status"] == "success"

    def refund(self, transaction_id: str, amount: float) -> bool:
        cents = int(amount * 100)
        result = self._gateway.process_refund(transaction_id, cents)
        return result["status"] == "refunded"

# New payment gateway (already compatible)
class StripeGateway(PaymentProcessor):
    def pay(self, amount: float, currency: str) -> bool:
        print(f"Stripe: Charging ${amount} {currency}")
        return True

    def refund(self, transaction_id: str, amount: float) -> bool:
        print(f"Stripe: Refunding ${amount} from {transaction_id}")
        return True

# Client code works with both through adapter
def process_payment(processor: PaymentProcessor, amount: float):
    if processor.pay(amount, "USD"):
        print("Payment successful")
    else:
        print("Payment failed")

# Both work with client code
old_gateway = OldPaymentGateway()
adapter = OldPaymentAdapter(old_gateway)
process_payment(adapter, 99.99)  # Uses adapter

stripe = StripeGateway()
process_payment(stripe, 99.99)   # Direct usage
```

### Two-Way Adapter

```python
class MediaPlayer:
    def play_vlc(self, filename: str):
        print(f"Playing VLC: {filename}")

    def play_mp3(self, filename: str):
        print(f"Playing MP3: {filename}")

class VLCToMP3Adapter:
    def __init__(self, vlc_player: MediaPlayer):
        self.vlc = vlc_player

    def play(self, filename: str):
        self.vlc.play_vlc(filename)

class MP3ToVLCAdapter:
    def __init__(self, mp3_player: MediaPlayer):
        self.mp3 = mp3_player

    def play(self, filename: str):
        self.mp3.play_mp3(filename)
```

---

## 2. Decorator Pattern

### Intent
Attach additional responsibilities to an object dynamically. Decorators provide a flexible alternative to subclassing.

### When to Use
- Add responsibilities to individual objects
- Responsibilities can be removed
- Extending functionality through subclassing is impractical

### Implementation

```python
from abc import ABC, abstractmethod

# Component interface
class Coffee(ABC):
    @abstractmethod
    def cost(self) -> float:
        pass

    @abstractmethod
    def description(self) -> str:
        pass

# Concrete Component
class SimpleCoffee(Coffee):
    def cost(self) -> float:
        return 2.00

    def description(self) -> str:
        return "Simple coffee"

# Base Decorator
class CoffeeDecorator(Coffee):
    def __init__(self, coffee: Coffee):
        self._coffee = coffee

    def cost(self) -> float:
        return self._coffee.cost()

    def description(self) -> str:
        return self._coffee.description()

# Concrete Decorators
class MilkDecorator(CoffeeDecorator):
    def cost(self) -> float:
        return self._coffee.cost() + 0.50

    def description(self) -> str:
        return self._coffee.description() + " + milk"

class SugarDecorator(CoffeeDecorator):
    def cost(self) -> float:
        return self._coffee.cost() + 0.25

    def description(self) -> str:
        return self._coffee.description() + " + sugar"

class WhipCreamDecorator(CoffeeDecorator):
    def cost(self) -> float:
        return self._coffee.cost() + 0.75

    def description(self) -> str:
        return self._coffee.description() + " + whip cream"

class CaramelDecorator(CoffeeDecorator):
    def cost(self) -> float:
        return self._coffee.cost() + 0.60

    def description(self) -> str:
        return self._coffee.description() + " + caramel"

# Usage - stack decorators
coffee = SimpleCoffee()
print(f"{coffee.description()}: ${coffee.cost():.2f}")

coffee = MilkDecorator(coffee)
coffee = SugarDecorator(coffee)
coffee = WhipCreamDecorator(coffee)
print(f"{coffee.description()}: ${coffee.cost():.2f}")

# Different combination
mocha = CaramelDecorator(MilkDecorator(SimpleCoffee()))
print(f"{mocha.description()}: ${mocha.cost():.2f}")
```

### Python Decorator Function Pattern

```python
from functools import wraps
import time

def timer(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        end = time.time()
        print(f"{func.__name__} took {end-start:.4f}s")
        return result
    return wrapper

def retry(max_attempts=3):
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            for attempt in range(max_attempts):
                try:
                    return func(*args, **kwargs)
                except Exception as e:
                    if attempt == max_attempts - 1:
                        raise
                    print(f"Attempt {attempt+1} failed: {e}")
                    time.sleep(1)
        return wrapper
    return decorator

def cache(func):
    memo = {}
    @wraps(func)
    def wrapper(*args):
        if args not in memo:
            memo[args] = func(*args)
        return memo[args]
    return wrapper

# Usage
@timer
@retry(max_attempts=3)
def fetch_data(url: str):
    print(f"Fetching {url}")
    return {"data": "value"}

@cache
def fibonacci(n: int) -> int:
    if n < 2:
        return n
    return fibonacci(n-1) + fibonacci(n-2)

fetch_data("https://api.example.com")
print(fibonacci(50))
```

---

## 3. Proxy Pattern

### Intent
Provide a surrogate or placeholder for another object to control access to it.

### When to Use
- Lazy initialization
- Access control
- Logging/monitoring
- Caching
- Remote proxy (network access)

### Implementation

```python
from abc import ABC, abstractmethod
from datetime import datetime

# Subject interface
class Database(ABC):
    @abstractmethod
    def query(self, sql: str) -> list:
        pass

    @abstractmethod
    def execute(self, sql: str) -> bool:
        pass

# Real Subject
class RealDatabase(Database):
    def __init__(self, connection_string: str):
        self.connection_string = connection_string
        self.connected = True
        print(f"Connected to database: {connection_string}")

    def query(self, sql: str) -> list:
        print(f"Executing query: {sql}")
        return [{"id": 1, "name": "John"}, {"id": 2, "name": "Jane"}]

    def execute(self, sql: str) -> bool:
        print(f"Executing: {sql}")
        return True

# Protection Proxy - access control
class DatabaseProxy(Database):
    def __init__(self, database: RealDatabase, allowed_users: list[str]):
        self._database = database
        self._allowed_users = allowed_users
        self._current_user = None

    def login(self, user: str) -> bool:
        if user in self._allowed_users:
            self._current_user = user
            print(f"User '{user}' logged in")
            return True
        print(f"User '{user}' not authorized")
        return False

    def query(self, sql: str) -> list:
        if not self._current_user:
            raise PermissionError("Not logged in")
        print(f"[{self._current_user}] Query authorized")
        return self._database.query(sql)

    def execute(self, sql: str) -> bool:
        if not self._current_user:
            raise PermissionError("Not logged in")
        if sql.upper().startswith("DROP"):
            raise PermissionError("DROP not allowed")
        print(f"[{self._current_user}] Execute authorized")
        return self._database.execute(sql)

# Caching Proxy
class CachingDatabaseProxy(Database):
    def __init__(self, database: RealDatabase):
        self._database = database
        self._cache: dict[str, list] = {}
        self._cache_timestamps: dict[str, datetime] = {}
        self._cache_ttl = 300  # 5 minutes

    def query(self, sql: str) -> list:
        now = datetime.now()
        if sql in self._cache:
            timestamp = self._cache_timestamps[sql]
            if (now - timestamp).seconds < self._cache_ttl:
                print(f"Cache hit for: {sql}")
                return self._cache[sql]

        print(f"Cache miss for: {sql}")
        result = self._database.query(sql)
        self._cache[sql] = result
        self._cache_timestamps[sql] = now
        return result

    def execute(self, sql: str) -> bool:
        # Don't cache write operations
        self._cache.clear()
        return self._database.execute(sql)

# Logging Proxy
class LoggingDatabaseProxy(Database):
    def __init__(self, database: Database):
        self._database = database
        self._logs: list[dict] = []

    def query(self, sql: str) -> list:
        start = datetime.now()
        result = self._database.query(sql)
        duration = (datetime.now() - start).total_seconds()
        self._logs.append({
            "operation": "query",
            "sql": sql,
            "duration": duration,
            "rows": len(result)
        })
        return result

    def execute(self, sql: str) -> bool:
        start = datetime.now()
        result = self._database.execute(sql)
        duration = (datetime.now() - start).total_seconds()
        self._logs.append({
            "operation": "execute",
            "sql": sql,
            "duration": duration,
            "success": result
        })
        return result

    def get_logs(self) -> list[dict]:
        return self._logs

# Usage
db = RealDatabase("postgresql://localhost/mydb")
proxy = LoggingDatabaseProxy(CachingDatabaseProxy(db))

proxy.query("SELECT * FROM users")
proxy.query("SELECT * FROM users")  # Cache hit
```

---

## 4. Facade Pattern

### Intent
Provide a unified interface to a set of interfaces in a subsystem. Facade defines a higher-level interface that makes the subsystem easier to use.

### When to Use
- Simplify complex library APIs
- Provide a simple interface to a complex subsystem
- Layer your subsystems

### Implementation

```python
class CPU:
    def freeze(self):
        print("CPU: Freezing processor")

    def jump(self, address: int):
        print(f"CPU: Jumping to address {address}")

    def execute(self):
        print("CPU: Executing instructions")

class Memory:
    def load(self, address: int, data: str):
        print(f"Memory: Loading data at {address}")

    def free(self, address: int):
        print(f"Memory: Freeing address {address}")

class HardDrive:
    def read(self, sector: int, size: int) -> str:
        print(f"HardDrive: Reading {size} bytes from sector {sector}")
        return "boot_data"

    def write(self, sector: int, data: str):
        print(f"HardDrive: Writing to sector {sector}")

class BIOS:
    def run(self):
        print("BIOS: Running POST checks")

    def load_bootloader(self):
        print("BIOS: Loading bootloader")

class OperatingSystem:
    def load(self):
        print("OS: Loading operating system")

# Facade
class ComputerFacade:
    def __init__(self):
        self.cpu = CPU()
        self.memory = Memory()
        self.hard_drive = HardDrive()
        self.bios = BIOS()
        self.os = OperatingSystem()

    def start_computer(self):
        """Simplified interface to complex startup process"""
        print("=== Starting Computer ===")
        self.bios.run()
        self.bios.load_bootloader()
        boot_data = self.hard_drive.read(0, 1024)
        self.memory.load(0, boot_data)
        self.cpu.freeze()
        self.cpu.jump(0)
        self.cpu.execute()
        self.os.load()
        print("=== Computer Started ===\n")

    def shut_down(self):
        """Simplified shutdown"""
        print("=== Shutting Down ===")
        self.memory.free(0)
        print("=== Computer Off ===\n")

# Client uses only the facade
computer = ComputerFacade()
computer.start_computer()
computer.shut_down()
```

---

## 5. Composite Pattern

### Intent
Compose objects into tree structures to represent part-whole hierarchies. Composite lets clients treat individual objects and compositions uniformly.

### When to Use
- Tree structures (file systems, menus, org charts)
- Want to treat uniform and composite objects the same
- Part-whole hierarchy

### Implementation

```python
from abc import ABC, abstractmethod

# Component
class FileSystemComponent(ABC):
    def __init__(self, name: str):
        self.name = name

    @abstractmethod
    def size(self) -> int:
        pass

    @abstractmethod
    def display(self, indent: int = 0) -> str:
        pass

    @abstractmethod
    def is_composite(self) -> bool:
        pass

# Leaf
class File(FileSystemComponent):
    def __init__(self, name: str, size: int):
        super().__init__(name)
        self._size = size

    def size(self) -> int:
        return self._size

    def display(self, indent: int = 0) -> str:
        return f"{'  ' * indent}📄 {self.name} ({self._size}KB)"

    def is_composite(self) -> bool:
        return False

# Composite
class Directory(FileSystemComponent):
    def __init__(self, name: str):
        super().__init__(name)
        self._children: list[FileSystemComponent] = []

    def add(self, component: FileSystemComponent):
        self._children.append(component)

    def remove(self, component: FileSystemComponent):
        self._children.remove(component)

    def get_children(self) -> list[FileSystemComponent]:
        return self._children

    def size(self) -> int:
        return sum(child.size() for child in self._children)

    def display(self, indent: int = 0) -> str:
        lines = [f"{'  ' * indent}📁 {self.name}/ ({self.size()}KB)"]
        for child in self._children:
            lines.append(child.display(indent + 1))
        return "\n".join(lines)

    def is_composite(self) -> bool:
        return True

# Usage
root = Directory("project")
src = Directory("src")
src.add(File("main.py", 50))
src.add(File("utils.py", 30))

tests = Directory("tests")
tests.add(File("test_main.py", 40))
tests.add(File("test_utils.py", 25))

root.add(src)
root.add(tests)
root.add(File("README.md", 10))
root.add(File("setup.py", 15))

print(root.display())
print(f"\nTotal size: {root.size()}KB")
```

---

## 6. Bridge Pattern

### Intent
Decouple an abstraction from its implementation so that the two can vary independently.

### When to Use
- You want to avoid a permanent binding between abstraction and implementation
- Both abstraction and implementation should be extensible
- You don't want changes in one to affect the other

### Implementation

```python
from abc import ABC, abstractmethod

# Implementation interface
class Color(ABC):
    @abstractmethod
    def fill(self) -> str:
        pass

class Red(Color):
    def fill(self) -> str:
        return "Red"

class Blue(Color):
    def fill(self) -> str:
        return "Blue"

class Green(Color):
    def fill(self) -> str:
        return "Green"

# Abstraction
class Shape(ABC):
    def __init__(self, color: Color):
        self.color = color

    @abstractmethod
    def draw(self) -> str:
        pass

# Refined Abstractions
class Circle(Shape):
    def draw(self) -> str:
        return f"Drawing {self.color.fill()} circle"

class Square(Shape):
    def draw(self) -> str:
        return f"Drawing {self.color.fill()} square"

class Triangle(Shape):
    def draw(self) -> str:
        return f"Drawing {self.color.fill()} triangle"

# Usage - both can vary independently
shapes = [
    Circle(Red()),
    Circle(Blue()),
    Square(Green()),
    Triangle(Red()),
]

for shape in shapes:
    print(shape.draw())
```

---

## 7. Flyweight Pattern

### Intent
Use sharing to support large numbers of fine-grained objects efficiently.

### When to Use
- Large numbers of similar objects
- Memory is a concern
- Most object state can be made extrinsic

### Implementation

```python
class Flyweight:
    """Shared intrinsic state"""
    def __init__(self, shared_state: str):
        self.shared_state = shared_state

    def operation(self, unique_state: str):
        print(f"Flyweight: shared={self.shared_state}, unique={unique_state}")

class FlyweightFactory:
    _flyweights: dict[str, Flyweight] = {}

    @classmethod
    def get_flyweight(cls, key: str) -> Flyweight:
        if key not in cls._flyweights:
            cls._flyweights[key] = Flyweight(key)
            print(f"Creating flyweight for: {key}")
        return cls._flyweights[key]

    @classmethod
    def get_count(cls) -> int:
        return len(cls._flyweights)

# Context - stores unique state
class Context:
    def __init__(self, unique_state: str, flyweight: Flyweight):
        self.unique_state = unique_state
        self.flyweight = flyweight

    def operation(self):
        self.flyweight.operation(self.unique_state)

# Usage - text editor example
class Character:
    def __init__(self, char: str, font: str, size: int):
        self.char = char  # Unique
        self.font = font  # Shared (flyweight)
        self.size = size  # Shared (flyweight)

class TextEditor:
    def __init__(self):
        self.characters: list[Character] = []

    def add_character(self, char: str, font: str, size: int):
        self.characters.append(Character(char, font, size))

    def display(self):
        return "".join(c.char for c in self.characters)

# Without flyweight - each char stores font/size
# With flyweight - font/size stored once, shared

factory = FlyweightFactory()
for char in "Hello World":
    fw = factory.get_flyweight(f"font_arial_12")
    fw.operation(char)

print(f"Flyweights created: {factory.get_count()}")
```

---

## Structural Patterns Comparison

| Pattern | Purpose | Use Case | Complexity |
|---------|---------|----------|-----------|
| **Adapter** | Interface compatibility | Legacy integration | Low |
| **Decorator** | Dynamic behavior addition | Coffee/customization | Medium |
| **Proxy** | Access control | Caching/lazy loading | Medium |
| **Facade** | Simplify complex API | Subsystem interface | Low |
| **Composite** | Tree structures | File system/menu | Medium |
| **Bridge** | Separate abstraction/implementation | Cross-platform | High |
| **Flyweight** | Memory optimization | Text editors/games | High |

---

## LLD Interview Usage

| Problem | Structural Patterns |
|---------|---------------------|
| Parking Lot | Facade (simplified interface) |
| Elevator | Composite (floor structure) |
| Chess Game | Composite (board), Decorator (piece enhancements) |
| Text Editor | Flyweight (characters), Decorator (formatting) |
| E-Commerce | Adapter (payment gateways), Decorator (product features) |
