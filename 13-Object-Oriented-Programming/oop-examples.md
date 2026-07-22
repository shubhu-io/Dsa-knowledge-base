# Object-Oriented Programming — Real-World Examples

## Example 1: E-Commerce Product System

### Requirements
- Multiple product types (Electronics, Clothing, Books)
- Shopping cart with add/remove/calculate
- Discount system with different strategies
- Order processing

```python
from abc import ABC, abstractmethod
from enum import Enum
from datetime import datetime

# --- Product Hierarchy (Inheritance + Polymorphism) ---

class ProductCategory(Enum):
    ELECTRONICS = "electronics"
    CLOTHING = "clothing"
    BOOK = "book"

class Product(ABC):
    def __init__(self, name: str, price: float, category: ProductCategory):
        self.name = name
        self.price = price
        self.category = category
        self.created_at = datetime.now()

    @abstractmethod
    def get_info(self) -> dict:
        pass

    @abstractmethod
    def get_display_price(self) -> float:
        """Price after product-specific adjustments"""
        pass

    def __repr__(self):
        return f"{self.__class__.__name__}({self.name}, ${self.price})"

class Electronics(Product):
    def __init__(self, name: str, price: float, brand: str,
                 warranty_months: int = 12):
        super().__init__(name, price, ProductCategory.ELECTRONICS)
        self.brand = brand
        self.warranty_months = warranty_months

    def get_info(self) -> dict:
        return {
            "type": "Electronics",
            "name": self.name,
            "brand": self.brand,
            "price": self.price,
            "warranty": f"{self.warranty_months} months"
        }

    def get_display_price(self) -> float:
        return self.price  # No special adjustment

class Clothing(Product):
    def __init__(self, name: str, price: float, size: str,
                 material: str = "Cotton"):
        super().__init__(name, price, ProductCategory.CLOTHING)
        self.size = size
        self.material = material

    def get_info(self) -> dict:
        return {
            "type": "Clothing",
            "name": self.name,
            "size": self.size,
            "material": self.material,
            "price": self.price
        }

    def get_display_price(self) -> float:
        return self.price

class Book(Product):
    def __init__(self, name: str, price: float, author: str,
                 isbn: str, pages: int = 0):
        super().__init__(name, price, ProductCategory.BOOK)
        self.author = author
        self.isbn = isbn
        self.pages = pages

    def get_info(self) -> dict:
        return {
            "type": "Book",
            "title": self.name,
            "author": self.author,
            "isbn": self.isbn,
            "price": self.price
        }

    def get_display_price(self) -> float:
        # Books have 10% tax included in price
        return self.price

# --- Shopping Cart (Encapsulation) ---

class CartItem:
    def __init__(self, product: Product, quantity: int = 1):
        self.product = product
        self.quantity = quantity

    @property
    def subtotal(self) -> float:
        return self.product.get_display_price() * self.quantity

class ShoppingCart:
    def __init__(self):
        self._items: dict[str, CartItem] = {}

    def add_item(self, product: Product, quantity: int = 1):
        key = product.name
        if key in self._items:
            self._items[key].quantity += quantity
        else:
            self._items[key] = CartItem(product, quantity)

    def remove_item(self, product_name: str):
        if product_name in self._items:
            del self._items[product_name]

    def update_quantity(self, product_name: str, quantity: int):
        if product_name in self._items:
            if quantity <= 0:
                self.remove_item(product_name)
            else:
                self._items[product_name].quantity = quantity

    @property
    def subtotal(self) -> float:
        return sum(item.subtotal for item in self._items.values())

    @property
    def item_count(self) -> int:
        return sum(item.quantity for item in self._items.values())

    def get_items(self) -> list[dict]:
        return [
            {
                "product": item.product.name,
                "quantity": item.quantity,
                "price": item.product.get_display_price(),
                "subtotal": item.subtotal
            }
            for item in self._items.values()
        ]

    def clear(self):
        self._items.clear()

# --- Discount System (Strategy Pattern) ---

class DiscountStrategy(ABC):
    @abstractmethod
    def calculate(self, subtotal: float) -> float:
        pass

    @abstractmethod
    def description(self) -> str:
        pass

class NoDiscount(DiscountStrategy):
    def calculate(self, subtotal: float) -> float:
        return 0

    def description(self) -> str:
        return "No discount"

class PercentageDiscount(DiscountStrategy):
    def __init__(self, percentage: float):
        self.percentage = percentage

    def calculate(self, subtotal: float) -> float:
        return subtotal * (self.percentage / 100)

    def description(self) -> str:
        return f"{self.percentage}% off"

class FixedAmountDiscount(DiscountStrategy):
    def __init__(self, amount: float, minimum: float = 0):
        self.amount = amount
        self.minimum = minimum

    def calculate(self, subtotal: float) -> float:
        if subtotal >= self.minimum:
            return min(self.amount, subtotal)
        return 0

    def description(self) -> str:
        return f"${self.amount} off (min ${self.minimum})"

class BuyOneGetOneFree(DiscountStrategy):
    def calculate(self, subtotal: float) -> float:
        return subtotal * 0.5 if subtotal > 0 else 0

    def description(self) -> str:
        return "Buy one get one free"

# --- Order Processing ---

class Order:
    _counter = 0

    def __init__(self, cart: ShoppingCart, discount: DiscountStrategy = None):
        Order._counter += 1
        self.order_id = f"ORD-{Order._counter:06d}"
        self.items = cart.get_items()
        self.subtotal = cart.subtotal
        self.discount_strategy = discount or NoDiscount()
        self.discount_amount = self.discount_strategy.calculate(self.subtotal)
        self.tax_rate = 0.08
        self.tax = (self.subtotal - self.discount_amount) * self.tax_rate
        self.total = self.subtotal - self.discount_amount + self.tax
        self.created_at = datetime.now()
        self.status = "created"

    def confirm(self):
        self.status = "confirmed"

    def summary(self) -> dict:
        return {
            "order_id": self.order_id,
            "items": len(self.items),
            "subtotal": f"${self.subtotal:.2f}",
            "discount": f"-${self.discount_amount:.2f} ({self.discount_strategy.description()})",
            "tax": f"${self.tax:.2f}",
            "total": f"${self.total:.2f}",
            "status": self.status
        }

# --- Usage ---

# Create products
laptop = Electronics("MacBook Pro", 1999.99, "Apple", 24)
tshirt = Clothing("Classic Tee", 29.99, "M", "Cotton")
python_book = Book("Python Crash Course", 39.99, "Eric Matthes", "978-1593279288")

# Add to cart
cart = ShoppingCart()
cart.add_item(laptop)
cart.add_item(tshirt, 2)
cart.add_item(python_book)

# Create order with 15% discount
order = Order(cart, PercentageDiscount(15))
order.confirm()
print(order.summary())
```

---

## Example 2: Notification System (Observer Pattern)

```python
from abc import ABC, abstractmethod
from datetime import datetime
from enum import Enum

class EventType(Enum):
    ORDER_PLACED = "order_placed"
    ORDER_SHIPPED = "order_shipped"
    ORDER_DELIVERED = "order_delivered"
    PAYMENT_RECEIVED = "payment_received"

# Observer Interface
class Observer(ABC):
    @abstractmethod
    def update(self, event: EventType, data: dict):
        pass

# Subject
class EventManager:
    def __init__(self):
        self._subscribers: dict[EventType, list[Observer]] = {}

    def subscribe(self, event: EventType, observer: Observer):
        if event not in self._subscribers:
            self._subscribers[event] = []
        self._subscribers[event].append(observer)

    def unsubscribe(self, event: EventType, observer: Observer):
        if event in self._subscribers:
            self._subscribers[event].remove(observer)

    def notify(self, event: EventType, data: dict):
        for observer in self._subscribers.get(event, []):
            observer.update(event, data)

# Concrete Observers
class EmailService(Observer):
    def __init__(self):
        self.sent_emails = []

    def update(self, event: EventType, data: dict):
        email = {
            "to": data.get("email", "customer@store.com"),
            "subject": f"Store Notification: {event.value}",
            "body": self._generate_body(event, data),
            "timestamp": datetime.now()
        }
        self.sent_emails.append(email)
        print(f"📧 Email sent: {email['subject']}")

    def _generate_body(self, event: EventType, data: dict) -> str:
        templates = {
            EventType.ORDER_PLACED: f"Your order #{data.get('order_id')} has been placed!",
            EventType.ORDER_SHIPPED: f"Your order #{data.get('order_id')} has been shipped!",
            EventType.ORDER_DELIVERED: f"Your order #{data.get('order_id')} has been delivered!",
            EventType.PAYMENT_RECEIVED: f"Payment of ${data.get('amount')} received!",
        }
        return templates.get(event, "Event occurred")

class SMSNotifier(Observer):
    def __init__(self):
        self.messages = []

    def update(self, event: EventType, data: dict):
        msg = {
            "phone": data.get("phone", "+1234567890"),
            "message": f"{event.value}: {data.get('order_id', 'N/A')}",
            "timestamp": datetime.now()
        }
        self.messages.append(msg)
        print(f"📱 SMS sent: {msg['message']}")

class InventoryService(Observer):
    def __init__(self):
        self.stock_updates = []

    def update(self, event: EventType, data: dict):
        if event == EventType.ORDER_PLACED:
            items = data.get("items", [])
            for item in items:
                self.stock_updates.append({
                    "product": item["name"],
                    "quantity": -item["quantity"],
                    "timestamp": datetime.now()
                })
            print(f"📦 Inventory updated for {len(items)} items")

class AnalyticsService(Observer):
    def __init__(self):
        self.events = []

    def update(self, event: EventType, data: dict):
        self.events.append({
            "event": event.value,
            "data": data,
            "timestamp": datetime.now()
        })
        print(f"📊 Analytics tracked: {event.value}")

# Subject - Order Service
class OrderService:
    def __init__(self):
        self.events = EventManager()
        self.orders = {}

    def place_order(self, customer_email: str, items: list[dict]) -> str:
        order_id = f"ORD-{len(self.orders) + 1:06d}"
        self.orders[order_id] = {
            "email": customer_email,
            "items": items,
            "status": "placed"
        }
        self.events.notify(EventType.ORDER_PLACED, {
            "order_id": order_id,
            "email": customer_email,
            "items": items
        })
        return order_id

    def ship_order(self, order_id: str):
        self.orders[order_id]["status"] = "shipped"
        self.events.notify(EventType.ORDER_SHIPPED, {"order_id": order_id})

# --- Usage ---

# Setup services
email_service = EmailService()
sms_service = SMSNotifier()
inventory_service = InventoryService()
analytics_service = AnalyticsService()

# Create order service and subscribe observers
order_service = OrderService()
order_service.events.subscribe(EventType.ORDER_PLACED, email_service)
order_service.events.subscribe(EventType.ORDER_PLACED, inventory_service)
order_service.events.subscribe(EventType.ORDER_PLACED, analytics_service)
order_service.events.subscribe(EventType.ORDER_SHIPPED, email_service)
order_service.events.subscribe(EventType.ORDER_SHIPPED, sms_service)

# Place an order - triggers multiple notifications
order_id = order_service.place_order(
    "customer@example.com",
    [{"name": "Laptop", "quantity": 1}, {"name": "Mouse", "quantity": 2}]
)
order_service.ship_order(order_id)
```

---

## Example 3: Shape Drawing System (Polymorphism + Composition)

```python
from abc import ABC, abstractmethod
import math

class Point:
    def __init__(self, x: float, y: float):
        self.x = x
        self.y = y

    def distance_to(self, other: 'Point') -> float:
        return math.sqrt((self.x - other.x)**2 + (self.y - other.y)**2)

    def __repr__(self):
        return f"({self.x}, {self.y})"

class Color:
    def __init__(self, r: int, g: int, b: int, a: int = 255):
        self.r = max(0, min(255, r))
        self.g = max(0, min(255, g))
        self.b = max(0, min(255, b))
        self.a = max(0, min(255, a))

    def to_hex(self) -> str:
        return f"#{self.r:02x}{self.g:02x}{self.b:02x}"

    @classmethod
    def red(cls): return cls(255, 0, 0)
    @classmethod
    def green(cls): return cls(0, 255, 0)
    @classmethod
    def blue(cls): return cls(0, 0, 255)

class Shape(ABC):
    def __init__(self, color: Color = None):
        self.color = color or Color.red()
        self._visible = True

    @abstractmethod
    def area(self) -> float:
        pass

    @abstractmethod
    def perimeter(self) -> float:
        pass

    @abstractmethod
    def draw(self) -> str:
        pass

    def contains_point(self, point: Point) -> bool:
        return False

    def move(self, dx: float, dy: float):
        pass

    @property
    def visible(self) -> bool:
        return self._visible

    @visible.setter
    def visible(self, value: bool):
        self._visible = value

class Circle(Shape):
    def __init__(self, center: Point, radius: float, color: Color = None):
        super().__init__(color)
        self.center = center
        self.radius = radius

    def area(self) -> float:
        return math.pi * self.radius ** 2

    def perimeter(self) -> float:
        return 2 * math.pi * self.radius

    def draw(self) -> str:
        return f"Drawing circle at {self.center} with radius {self.radius}"

    def contains_point(self, point: Point) -> bool:
        return self.center.distance_to(point) <= self.radius

    def move(self, dx: float, dy: float):
        self.center.x += dx
        self.center.y += dy

class Rectangle(Shape):
    def __init__(self, top_left: Point, width: float, height: float,
                 color: Color = None):
        super().__init__(color)
        self.top_left = top_left
        self.width = width
        self.height = height

    def area(self) -> float:
        return self.width * self.height

    def perimeter(self) -> float:
        return 2 * (self.width + self.height)

    def draw(self) -> str:
        return f"Drawing rectangle at {self.top_left} ({self.width}x{self.height})"

    def contains_point(self, point: Point) -> bool:
        return (self.top_left.x <= point.x <= self.top_left.x + self.width and
                self.top_left.y <= point.y <= self.top_left.y + self.height)

    def move(self, dx: float, dy: float):
        self.top_left.x += dx
        self.top_left.y += dy

class Triangle(Shape):
    def __init__(self, p1: Point, p2: Point, p3: Point, color: Color = None):
        super().__init__(color)
        self.p1, self.p2, self.p3 = p1, p2, p3

    def area(self) -> float:
        return abs((self.p1.x*(self.p2.y-self.p3.y) +
                    self.p2.x*(self.p3.y-self.p1.y) +
                    self.p3.x*(self.p1.y-self.p2.y)) / 2)

    def perimeter(self) -> float:
        return (self.p1.distance_to(self.p2) +
                self.p2.distance_to(self.p3) +
                self.p3.distance_to(self.p1))

    def draw(self) -> str:
        return f"Drawing triangle: {self.p1}, {self.p2}, {self.p3}"

    def move(self, dx: float, dy: float):
        for p in [self.p1, self.p2, self.p3]:
            p.x += dx
            p.y += dy

class Canvas:
    def __init__(self):
        self.shapes: list[Shape] = []

    def add(self, shape: Shape):
        self.shapes.append(shape)

    def remove(self, shape: Shape):
        self.shapes.remove(shape)

    def total_area(self) -> float:
        return sum(s.area() for s in self.shapes if s.visible)

    def draw_all(self) -> list[str]:
        return [s.draw() for s in self.shapes if s.visible]

    def find_shapes_containing(self, point: Point) -> list[Shape]:
        return [s for s in self.shapes if s.contains_point(point)]

    def get_largest(self) -> Shape:
        return max(self.shapes, key=lambda s: s.area())

# Usage
canvas = Canvas()
canvas.add(Circle(Point(100, 100), 50, Color.blue()))
canvas.add(Rectangle(Point(200, 50), 100, 80, Color.green()))
canvas.add(Triangle(Point(50, 200), Point(150, 200), Point(100, 100)))

for drawing in canvas.draw_all():
    print(drawing)

print(f"Total area: {canvas.total_area():.2f}")
print(f"Largest shape: {canvas.get_largest()}")
```

---

## Example 4: File System (Composite Pattern)

```python
from abc import ABC, abstractmethod
from datetime import datetime

class FileSystemComponent(ABC):
    def __init__(self, name: str):
        self.name = name
        self.created_at = datetime.now()

    @abstractmethod
    def size(self) -> int:
        pass

    @abstractmethod
    def display(self, indent: int = 0) -> str:
        pass

    @abstractmethod
    def is_file(self) -> bool:
        pass

class File(FileSystemComponent):
    def __init__(self, name: str, size: int, content: str = ""):
        super().__init__(name)
        self._size = size
        self.content = content

    def size(self) -> int:
        return self._size

    def display(self, indent: int = 0) -> str:
        return f"{'  ' * indent}📄 {self.name} ({self._size} bytes)"

    def is_file(self) -> bool:
        return True

class Directory(FileSystemComponent):
    def __init__(self, name: str):
        super().__init__(name)
        self._children: list[FileSystemComponent] = []

    def add(self, component: FileSystemComponent):
        self._children.append(component)

    def remove(self, component: FileSystemComponent):
        self._children.remove(component)

    def get_child(self, name: str) -> FileSystemComponent:
        for child in self._children:
            if child.name == name:
                return child
        raise KeyError(f"Component {name} not found")

    @property
    def children(self) -> list[FileSystemComponent]:
        return self._children.copy()

    def size(self) -> int:
        return sum(child.size() for child in self._children)

    def display(self, indent: int = 0) -> str:
        lines = [f"{'  ' * indent}📁 {self.name}/ ({self.size()} bytes)"]
        for child in self._children:
            lines.append(child.display(indent + 1))
        return "\n".join(lines)

    def is_file(self) -> bool:
        return False

# Build file system
root = Directory("root")
docs = Directory("docs")
docs.add(File("readme.md", 1500))
docs.add(File("guide.pdf", 50000))
root.add(docs)

src = Directory("src")
src.add(File("main.py", 2000))
src.add(File("utils.py", 1500))
tests = Directory("tests")
tests.add(File("test_main.py", 3000))
src.add(tests)
root.add(src)

root.add(File("config.json", 500))

print(root.display())
print(f"\nTotal size: {root.size()} bytes")
```

---

## Summary — Patterns Demonstrated

| Example | OOP Concepts | Design Patterns |
|---------|-------------|-----------------|
| E-Commerce | Inheritance, Encapsulation, ABC | Strategy, Factory |
| Notification | Inheritance, Polymorphism | Observer |
| Shape Drawing | Polymorphism, Composition | Composite (partial) |
| File System | Composition, Polymorphism | Composite |
