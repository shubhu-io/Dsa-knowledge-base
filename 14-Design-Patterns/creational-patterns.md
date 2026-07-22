# Creational Design Patterns

Creational patterns deal with object creation mechanisms, trying to create objects in a manner suitable to the situation.

---

## 1. Singleton Pattern

### Intent
Ensure a class has only one instance and provide a global point of access to it.

### When to Use
- Database connections
- Configuration management
- Logging
- Thread pools

### Implementation

```python
import threading

class Singleton:
    _instance = None
    _lock = threading.Lock()

    def __new__(cls):
        if cls._instance is None:
            with cls._lock:
                if cls._instance is None:
                    cls._instance = super().__new__(cls)
                    cls._instance._initialized = False
        return cls._instance

    def __init__(self):
        if not self._initialized:
            self.connection = "Established"
            self._initialized = True

# Usage
db1 = Singleton()
db2 = Singleton()
print(db1 is db2)  # True - same instance
```

### Thread-Safe Singleton (Python)

```python
import threading

class DatabaseConnection:
    _instance = None
    _lock = threading.Lock()

    def __new__(cls, *args, **kwargs):
        if cls._instance is None:
            with cls._lock:
                if cls._instance is None:
                    cls._instance = super().__new__(cls)
        return cls._instance

    def __init__(self, host="localhost", port=5432):
        if not hasattr(self, '_connected'):
            self.host = host
            self.port = port
            self._connected = True
            print(f"Connected to {host}:{port}")

# Test
db1 = DatabaseConnection("db.example.com")
db2 = DatabaseConnection("other.db.com")  # Ignores new params
print(db1 is db2)  # True
print(db1.host)    # db.example.com (not changed)
```

### Metaclass Singleton

```python
class SingletonMeta(type):
    _instances = {}
    _lock = threading.Lock()

    def __call__(cls, *args, **kwargs):
        with cls._lock:
            if cls not in cls._instances:
                instance = super().__call__(*args, **kwargs)
                cls._instances[cls] = instance
        return cls._instances[cls]

class Logger(metaclass=SingletonMeta):
    def __init__(self):
        self.logs = []

    def log(self, message: str):
        self.logs.append(message)
        print(f"LOG: {message}")

logger1 = Logger()
logger2 = Logger()
print(logger1 is logger2)  # True
```

### When NOT to Use Singleton
- When global state isn't needed
- When testing becomes difficult (hard to mock)
- When it creates hidden dependencies
- When it violates Single Responsibility Principle

---

## 2. Factory Method Pattern

### Intent
Define an interface for creating an object, but let subclasses decide which class to instantiate.

### When to Use
- When you don't know exact types at compile time
- When you want to provide flexibility in object creation
- When you want to reuse existing objects

### Implementation

```python
from abc import ABC, abstractmethod
from enum import Enum

class VehicleType(Enum):
    CAR = "car"
    TRUCK = "truck"
    MOTORCYCLE = "motorcycle"

class Vehicle(ABC):
    @abstractmethod
    def start(self) -> str:
        pass

    @abstractmethod
    def stop(self) -> str:
        pass

    @abstractmethod
    def get_type(self) -> str:
        pass

class Car(Vehicle):
    def start(self) -> str:
        return "Car engine started"

    def stop(self) -> str:
        return "Car engine stopped"

    def get_type(self) -> str:
        return "Car"

class Truck(Vehicle):
    def start(self) -> str:
        return "Truck engine started (diesel)"

    def stop(self) -> str:
        return "Truck engine stopped"

    def get_type(self) -> str:
        return "Truck"

class Motorcycle(Vehicle):
    def start(self) -> str:
        return "Motorcycle engine started"

    def stop(self) -> str:
        return "Motorcycle engine stopped"

    def get_type(self) -> str:
        return "Motorcycle"

# Factory Method
class VehicleFactory(ABC):
    @abstractmethod
    def create_vehicle(self) -> Vehicle:
        pass

    def order_vehicle(self) -> Vehicle:
        vehicle = self.create_vehicle()
        print(f"Created {vehicle.get_type()}")
        return vehicle

class CarFactory(VehicleFactory):
    def create_vehicle(self) -> Vehicle:
        return Car()

class TruckFactory(VehicleFactory):
    def create_vehicle(self) -> Vehicle:
        return Truck()

class MotorcycleFactory(VehicleFactory):
    def create_vehicle(self) -> Vehicle:
        return Motorcycle()

# Usage
def client_code(factory: VehicleFactory):
    vehicle = factory.order_vehicle()
    print(vehicle.start())
    print(vehicle.stop())

client_code(CarFactory())
client_code(TruckFactory())
```

### Simple Factory (Not GoF, but common)

```python
class NotificationFactory:
    @staticmethod
    def create(notification_type: str, **kwargs):
        types = {
            "email": EmailNotification,
            "sms": SMSNotification,
            "push": PushNotification,
        }
        if notification_type not in types:
            raise ValueError(f"Unknown type: {notification_type}")
        return types[notification_type](**kwargs)

class EmailNotification:
    def __init__(self, to: str, subject: str):
        self.to = to
        self.subject = subject

    def send(self, message: str):
        print(f"Email to {self.to}: {self.subject} - {message}")

class SMSNotification:
    def __init__(self, phone: str):
        self.phone = phone

    def send(self, message: str):
        print(f"SMS to {self.phone}: {message}")

class PushNotification:
    def __init__(self, device_id: str):
        self.device_id = device_id

    def send(self, message: str):
        print(f"Push to {self.device_id}: {message}")

# Usage
notif = NotificationFactory.create("email", to="user@example.com", subject="Alert")
notif.send("Server is down!")
```

---

## 3. Abstract Factory Pattern

### Intent
Provide an interface for creating families of related objects without specifying concrete classes.

### When to Use
- System must be independent of object creation
- System needs to work with multiple families of objects
- You want to enforce consistency among products

### Implementation

```python
from abc import ABC, abstractmethod

# Abstract Products
class Button(ABC):
    @abstractmethod
    def render(self) -> str:
        pass

    @abstractmethod
    def on_click(self, handler):
        pass

class Checkbox(ABC):
    @abstractmethod
    def render(self) -> str:
        pass

    @abstractmethod
    def toggle(self) -> bool:
        pass

class TextBox(ABC):
    @abstractmethod
    def render(self) -> str:
        pass

    @abstractmethod
    def set_text(self, text: str):
        pass

# Concrete Products - Light Theme
class LightButton(Button):
    def render(self) -> str:
        return '<button class="light-btn">Click Me</button>'

    def on_click(self, handler):
        return f"Light button clicked: {handler}"

class LightCheckbox(Checkbox):
    def __init__(self):
        self.checked = False

    def render(self) -> str:
        state = "checked" if self.checked else "unchecked"
        return f'<input type="checkbox" class="light-cb" {state}>'

    def toggle(self) -> bool:
        self.checked = not self.checked
        return self.checked

class LightTextBox(TextBox):
    def __init__(self):
        self.text = ""

    def render(self) -> str:
        return f'<input type="text" class="light-tb" value="{self.text}">'

    def set_text(self, text: str):
        self.text = text

# Concrete Products - Dark Theme
class DarkButton(Button):
    def render(self) -> str:
        return '<button class="dark-btn">Click Me</button>'

    def on_click(self, handler):
        return f"Dark button clicked: {handler}"

class DarkCheckbox(Checkbox):
    def __init__(self):
        self.checked = False

    def render(self) -> str:
        state = "checked" if self.checked else ""
        return f'<input type="checkbox" class="dark-cb" {state}>'

    def toggle(self) -> bool:
        self.checked = not self.checked
        return self.checked

class DarkTextBox(TextBox):
    def __init__(self):
        self.text = ""

    def render(self) -> str:
        return f'<input type="text" class="dark-tb" value="{self.text}">'

    def set_text(self, text: str):
        self.text = text

# Abstract Factory
class UIFactory(ABC):
    @abstractmethod
    def create_button(self) -> Button:
        pass

    @abstractmethod
    def create_checkbox(self) -> Checkbox:
        pass

    @abstractmethod
    def create_textbox(self) -> TextBox:
        pass

# Concrete Factories
class LightThemeFactory(UIFactory):
    def create_button(self) -> Button:
        return LightButton()

    def create_checkbox(self) -> Checkbox:
        return LightCheckbox()

    def create_textbox(self) -> TextBox:
        return LightTextBox()

class DarkThemeFactory(UIFactory):
    def create_button(self) -> Button:
        return DarkButton()

    def create_checkbox(self) -> Checkbox:
        return DarkCheckbox()

    def create_textbox(self) -> TextBox:
        return DarkTextBox()

# Client code
class UI:
    def __init__(self, factory: UIFactory):
        self.button = factory.create_button()
        self.checkbox = factory.create_checkbox()
        self.textbox = factory.create_textbox()

    def render(self):
        print(self.button.render())
        print(self.checkbox.render())
        print(self.textbox.render())

# Usage
print("=== Light Theme ===")
ui = UI(LightThemeFactory())
ui.render()

print("\n=== Dark Theme ===")
ui = UI(DarkThemeFactory())
ui.render()
```

---

## 4. Builder Pattern

### Intent
Separate construction of a complex object from its representation.

### When to Use
- Object has many optional parameters
- You want immutable objects
- Construction involves multiple steps

### Implementation

```python
from dataclasses import dataclass, field
from typing import Optional

@dataclass
class HTTPRequest:
    method: str = "GET"
    url: str = ""
    headers: dict = field(default_factory=dict)
    body: Optional[str] = None
    timeout: int = 30
    retries: int = 3
    auth_token: Optional[str] = None

class HTTPRequestBuilder:
    def __init__(self):
        self._request = HTTPRequest()

    def method(self, method: str) -> 'HTTPRequestBuilder':
        self._request.method = method
        return self

    def url(self, url: str) -> 'HTTPRequestBuilder':
        self._request.url = url
        return self

    def header(self, key: str, value: str) -> 'HTTPRequestBuilder':
        self._request.headers[key] = value
        return self

    def body(self, body: str) -> 'HTTPRequestBuilder':
        self._request.body = body
        return self

    def timeout(self, seconds: int) -> 'HTTPRequestBuilder':
        self._request.timeout = seconds
        return self

    def retries(self, count: int) -> 'HTTPRequestBuilder':
        self._request.retries = count
        return self

    def auth(self, token: str) -> 'HTTPRequestBuilder':
        self._request.auth_token = token
        return self

    def build(self) -> HTTPRequest:
        if not self._request.url:
            raise ValueError("URL is required")
        return self._request

# Director - knows the order of building
class RequestDirector:
    def __init__(self, builder: HTTPRequestBuilder):
        self.builder = builder

    def build_get_request(self, url: str) -> HTTPRequest:
        return (self.builder
                .method("GET")
                .url(url)
                .header("Accept", "application/json")
                .timeout(30)
                .build())

    def build_post_request(self, url: str, body: str) -> HTTPRequest:
        return (self.builder
                .method("POST")
                .url(url)
                .header("Content-Type", "application/json")
                .body(body)
                .timeout(60)
                .build())

# Usage
# Simple builder
request = (HTTPRequestBuilder()
    .method("PUT")
    .url("https://api.example.com/users/1")
    .header("Content-Type", "application/json")
    .header("Authorization", "Bearer token123")
    .body('{"name": "John"}')
    .timeout(10)
    .retries(5)
    .build())

print(f"{request.method} {request.url}")
print(f"Headers: {request.headers}")

# With Director
director = RequestDirector(HTTPRequestBuilder())
get_req = director.build_get_request("https://api.example.com/data")
```

### Builder with Validation

```python
from dataclasses import dataclass
from typing import Optional

@dataclass
class User:
    name: str
    email: str
    age: int
    phone: Optional[str] = None
    address: Optional[str] = None

class UserBuilder:
    def __init__(self):
        self._name = None
        self._email = None
        self._age = None
        self._phone = None
        self._address = None

    def name(self, name: str) -> 'UserBuilder':
        if not name or len(name) < 2:
            raise ValueError("Name must be at least 2 characters")
        self._name = name
        return self

    def email(self, email: str) -> 'UserBuilder':
        if "@" not in email:
            raise ValueError("Invalid email")
        self._email = email
        return self

    def age(self, age: int) -> 'UserBuilder':
        if age < 0 or age > 150:
            raise ValueError("Invalid age")
        self._age = age
        return self

    def phone(self, phone: str) -> 'UserBuilder':
        self._phone = phone
        return self

    def address(self, address: str) -> 'UserBuilder':
        self._address = address
        return self

    def build(self) -> User:
        if not self._name:
            raise ValueError("Name is required")
        if not self._email:
            raise ValueError("Email is required")
        if self._age is None:
            raise ValueError("Age is required")
        return User(
            name=self._name,
            email=self._email,
            age=self._age,
            phone=self._phone,
            address=self._address
        )

# Usage
user = (UserBuilder()
    .name("John Doe")
    .email("john@example.com")
    .age(30)
    .phone("+1234567890")
    .build())
```

---

## 5. Prototype Pattern

### Intent
Create new objects by cloning an existing instance.

### When to Use
- Object creation is expensive
- You want to avoid subclasses
- You need many similar objects

### Implementation

```python
import copy
from abc import ABC, abstractmethod

class Shape(ABC):
    def __init__(self, x: int = 0, y: int = 0, color: str = "red"):
        self.x = x
        self.y = y
        self.color = color

    @abstractmethod
    def clone(self) -> 'Shape':
        return copy.deepcopy(self)

    @abstractmethod
    def draw(self) -> str:
        pass

    def __repr__(self):
        return f"{self.__class__.__name__}({self.x}, {self.y}, {self.color})"

class Circle(Shape):
    def __init__(self, x: int = 0, y: int = 0, color: str = "red",
                 radius: int = 10):
        super().__init__(x, y, color)
        self.radius = radius

    def clone(self) -> 'Circle':
        return copy.deepcopy(self)

    def draw(self) -> str:
        return f"Drawing circle at ({self.x},{self.y}) with radius {self.radius}"

class Rectangle(Shape):
    def __init__(self, x: int = 0, y: int = 0, color: str = "red",
                 width: int = 20, height: int = 10):
        super().__init__(x, y, color)
        self.width = width
        self.height = height

    def clone(self) -> 'Rectangle':
        return copy.deepcopy(self)

    def draw(self) -> str:
        return f"Drawing rectangle at ({self.x},{self.y}) {self.width}x{self.height}"

# Prototype Registry
class ShapeRegistry:
    def __init__(self):
        self._shapes: dict[str, Shape] = {}

    def register(self, name: str, shape: Shape):
        self._shapes[name] = shape

    def clone(self, name: str) -> Shape:
        if name not in self._shapes:
            raise ValueError(f"Shape '{name}' not found")
        return self._shapes[name].clone()

# Usage
registry = ShapeRegistry()
registry.register("small_circle", Circle(0, 0, "blue", 5))
registry.register("large_circle", Circle(0, 0, "red", 50))
registry.register("button", Rectangle(0, 0, "gray", 100, 40))

# Clone and modify
circle1 = registry.clone("small_circle")
circle1.x = 100
circle1.color = "green"
print(circle1)  # Circle(100, 0, green)

circle2 = registry.clone("small_circle")
print(circle2)  # Circle(0, 0, blue) - original preserved

# Shallow vs Deep copy
class ComplexObject:
    def __init__(self):
        self.data = [1, 2, 3]
        self.nested = {"key": "value"}

obj = ComplexObject()
shallow = copy.copy(obj)      # Shares nested objects
deep = copy.deepcopy(obj)     # Independent copy of everything
```

---

## Creational Patterns Comparison

| Pattern | Use Case | Complexity | Flexibility |
|---------|----------|-----------|-------------|
| **Singleton** | Single instance | Low | Low |
| **Factory** | Create without specifying class | Medium | High |
| **Abstract Factory** | Create families of objects | High | High |
| **Builder** | Complex object construction | Medium | High |
| **Prototype** | Clone existing objects | Low | Medium |

---

## LLD Interview Usage

| Problem | Creational Pattern |
|---------|-------------------|
| Parking Lot | Singleton (ParkingLot), Factory (Vehicle creation) |
| Elevator | Singleton (Controller), Factory (Elevator types) |
| Chess Game | Prototype (clone board state) |
| E-Commerce | Factory (products), Builder (orders) |
| Chat App | Singleton (server), Factory (message types) |
