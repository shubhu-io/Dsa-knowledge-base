# Low-Level Design — Common Interview Problems

## 1. Parking Lot System

### Requirements
- Multiple floors with different slot types (compact, large, handicapped)
- Vehicle types: car, truck, motorcycle
- Ticket generation on entry, payment on exit
- Real-time availability display

### Class Design

```python
from enum import Enum
from datetime import datetime
from typing import Optional
import threading

class VehicleType(Enum):
    CAR = "car"
    TRUCK = "truck"
    MOTORCYCLE = "motorcycle"

class SlotType(Enum):
    COMPACT = "compact"
    LARGE = "large"
    HANDICAPPED = "handicapped"

class Vehicle:
    def __init__(self, plate: str, vtype: VehicleType, color: str = ""):
        self.plate = plate
        self.vtype = vtype
        self.color = color

class ParkingSlot:
    def __init__(self, slot_id: int, slot_type: SlotType, floor: int):
        self.slot_id = slot_id
        self.slot_type = slot_type
        self.floor = floor
        self.vehicle: Optional[Vehicle] = None

    @property
    def is_available(self) -> bool:
        return self.vehicle is None

    def park(self, vehicle: Vehicle) -> bool:
        if not self.is_available:
            return False
        self.vehicle = vehicle
        return True

    def unpark(self) -> Optional[Vehicle]:
        v = self.vehicle
        self.vehicle = None
        return v

class Ticket:
    def __init__(self, ticket_id: str, vehicle: Vehicle, slot: ParkingSlot):
        self.ticket_id = ticket_id
        self.vehicle = vehicle
        self.slot = slot
        self.entry_time = datetime.now()
        self.exit_time: Optional[datetime] = None

    def close(self):
        self.exit_time = datetime.now()

    @property
    def duration_hours(self) -> float:
        end = self.exit_time or datetime.now()
        return (end - self.entry_time).total_seconds() / 3600

class ParkingFloor:
    def __init__(self, floor_num: int, compact: int, large: int, handicapped: int):
        self.floor_num = floor_num
        self.slots: list[ParkingSlot] = []
        self._create_slots(compact, large, handicapped)

    def _create_slots(self, c: int, l: int, h: int):
        sid = 0
        for _ in range(c):
            self.slots.append(ParkingSlot(sid, SlotType.COMPACT, self.floor_num))
            sid += 1
        for _ in range(l):
            self.slots.append(ParkingSlot(sid, SlotType.LARGE, self.floor_num))
            sid += 1
        for _ in range(h):
            self.slots.append(ParkingSlot(sid, SlotType.HANDICAPPED, self.floor_num))
            sid += 1

    def find_slot(self, slot_type: SlotType) -> Optional[ParkingSlot]:
        for slot in self.slots:
            if slot.is_available and slot.slot_type == slot_type:
                return slot
        return None

    def availability(self) -> dict:
        counts = {st: 0 for st in SlotType}
        for s in self.slots:
            if s.is_available:
                counts[s.slot_type] += 1
        return counts

class ParkingLot:
    _instance = None
    _lock = threading.Lock()

    def __new__(cls, *args, **kwargs):
        if not cls._instance:
            with cls._lock:
                if not cls._instance:
                    cls._instance = super().__new__(cls)
        return cls._instance

    def __init__(self):
        if not hasattr(self, 'initialized'):
            self.floors: list[ParkingFloor] = []
            self.tickets: dict[str, Ticket] = {}
            self.ticket_counter = 0
            self.initialized = True

    def add_floor(self, floor: ParkingFloor):
        self.floors.append(floor)

    def _vehicle_to_slot_type(self, vtype: VehicleType) -> SlotType:
        mapping = {
            VehicleType.MOTORCYCLE: SlotType.COMPACT,
            VehicleType.CAR: SlotType.COMPACT,
            VehicleType.TRUCK: SlotType.LARGE,
        }
        return mapping[vtype]

    def park_vehicle(self, vehicle: Vehicle) -> Optional[Ticket]:
        slot_type = self._vehicle_to_slot_type(vehicle.vtype)
        for floor in self.floors:
            slot = floor.find_slot(slot_type)
            if slot:
                slot.park(vehicle)
                self.ticket_counter += 1
                tid = f"T{self.ticket_counter:06d}"
                ticket = Ticket(tid, vehicle, slot)
                self.tickets[tid] = ticket
                return ticket
        return None

    def unpark(self, ticket_id: str) -> float:
        ticket = self.tickets.get(ticket_id)
        if not ticket:
            raise ValueError("Invalid ticket")
        ticket.close()
        ticket.slot.unpark()
        return self._calculate_fee(ticket)

    def _calculate_fee(self, ticket: Ticket) -> float:
        return ticket.duration_hours * 2.0  # $2/hour

    def get_availability(self) -> list[dict]:
        return [
            {"floor": f.floor_num, "slots": f.availability()}
            for f in self.floors
        ]
```

---

## 2. Elevator System

### Requirements
- Multiple elevators in a building
- Support UP/DOWN movement
- Floor requests from inside and outside
- Efficient scheduling algorithm

### Class Design

```python
from enum import Enum
from collections import deque

class Direction(Enum):
    UP = 1
    DOWN = -1
    IDLE = 0

class ElevatorState(Enum):
    MOVING = "moving"
    STOPPED = "stopped"
    DOORS_OPEN = "doors_open"

class Elevator:
    def __init__(self, elevator_id: int, total_floors: int):
        self.elevator_id = elevator_id
        self.total_floors = total_floors
        self.current_floor = 0
        self.direction = Direction.IDLE
        self.state = ElevatorState.STOPPED
        self.up_requests: set[int] = set()
        self.down_requests: set[int] = set()

    def add_request(self, floor: int):
        if floor == self.current_floor:
            self._open_doors()
            return
        if floor > self.current_floor:
            self.up_requests.add(floor)
        else:
            self.down_requests.add(floor)
        if self.direction == Direction.IDLE:
            self._start_moving()

    def _start_moving(self):
        if self.up_requests:
            self.direction = Direction.UP
        elif self.down_requests:
            self.direction = Direction.DOWN
        self.state = ElevatorState.MOVING

    def _open_doors(self):
        self.state = ElevatorState.DOORS_OPEN
        self.up_requests.discard(self.current_floor)
        self.down_requests.discard(self.current_floor)

    def _close_doors(self):
        self.state = ElevatorState.STOPPED

    def step(self):
        if self.state == ElevatorState.DOORS_OPEN:
            self._close_doors()

        if self.direction == Direction.UP:
            if self.current_floor in self.up_requests:
                self._open_doors()
                return
            if self.up_requests:
                self.current_floor += 1
            elif self.down_requests:
                self.direction = Direction.DOWN
                self.current_floor -= 1
            else:
                self.direction = Direction.IDLE

        elif self.direction == Direction.DOWN:
            if self.current_floor in self.down_requests:
                self._open_doors()
                return
            if self.down_requests:
                self.current_floor -= 1
            elif self.up_requests:
                self.direction = Direction.UP
                self.current_floor += 1
            else:
                self.direction = Direction.IDLE

class ElevatorController:
    def __init__(self, num_elevators: int, total_floors: int):
        self.elevators = [
            Elevator(i, total_floors) for i in range(num_elevators)
        ]

    def request_elevator(self, floor: int, direction: Direction):
        elevator = self._find_best_elevator(floor, direction)
        elevator.add_request(floor)

    def _find_best_elevator(self, floor: int, direction: Direction) -> Elevator:
        best = None
        best_distance = float('inf')
        for elev in self.elevators:
            if elev.direction == Direction.IDLE:
                dist = abs(elev.current_floor - floor)
                if dist < best_distance:
                    best_distance = dist
                    best = elev
            elif elev.direction == direction:
                if (direction == Direction.UP and elev.current_floor <= floor) or \
                   (direction == Direction.DOWN and elev.current_floor >= floor):
                    dist = abs(elev.current_floor - floor)
                    if dist < best_distance:
                        best_distance = dist
                        best = elev
        return best or self.elevators[0]

    def step_all(self):
        for elev in self.elevators:
            elev.step()
```

---

## 3. Library Management System

### Requirements
- Book catalog with search
- Member registration and borrowing
- Return handling with due dates
- Fine calculation for late returns

```python
from datetime import datetime, timedelta
from enum import Enum

class BookStatus(Enum):
    AVAILABLE = "available"
    BORROWED = "borrowed"
    RESERVED = "reserved"
    LOST = "lost"

class Book:
    def __init__(self, isbn: str, title: str, author: str):
        self.isbn = isbn
        self.title = title
        self.author = author
        self.status = BookStatus.AVAILABLE

class BookItem:
    def __init__(self, book: Book, item_id: str):
        self.book = book
        self.item_id = item_id
        self.status = BookStatus.AVAILABLE

class Member:
    def __init__(self, member_id: str, name: str, email: str):
        self.member_id = member_id
        self.name = name
        self.email = email
        self.borrowed_books: list[BookItem] = []
        self.fines: float = 0.0
        self.max_books = 5

    @property
    def can_borrow(self) -> bool:
        return len(self.borrowed_books) < self.max_books

class Reservation:
    def __init__(self, member: Member, book: Book):
        self.member = member
        self.book = book
        self.created_at = datetime.now()
        self.expiry = self.created_at + timedelta(days=7)

class Library:
    def __init__(self):
        self.books: dict[str, Book] = {}
        self.items: dict[str, BookItem] = {}
        self.members: dict[str, Member] = {}
        self.reservations: list[Reservation] = []
        self.borrow_duration = timedelta(days=14)
        self.fine_per_day = 1.0

    def add_book(self, book: Book):
        self.books[book.isbn] = book

    def register_member(self, member: Member):
        self.members[member.member_id] = member

    def search(self, query: str) -> list[Book]:
        q = query.lower()
        return [
            b for b in self.books.values()
            if q in b.title.lower() or q in b.author.lower() or q in b.isbn
        ]

    def borrow_book(self, member_id: str, isbn: str) -> BookItem:
        member = self.members.get(member_id)
        book = self.books.get(isbn)
        if not member or not book:
            raise ValueError("Invalid member or book")
        if not member.can_borrow:
            raise Exception("Borrowing limit reached")
        available = next(
            (i for i in self.items.values()
             if i.book.isbn == isbn and i.status == BookStatus.AVAILABLE),
            None
        )
        if not available:
            raise Exception("No copies available")
        available.status = BookStatus.BORROWED
        member.borrowed_books.append(available)
        return available

    def return_book(self, member_id: str, item_id: str) -> float:
        member = self.members.get(member_id)
        item = self.items.get(item_id)
        if not member or not item:
            raise ValueError("Invalid member or item")
        fine = self._calculate_fine(item, datetime.now())
        member.fines += fine
        item.status = BookStatus.AVAILABLE
        member.borrowed_books = [
            b for b in member.borrowed_books if b.item_id != item_id
        ]
        return fine

    def _calculate_fine(self, item: BookItem, return_date: datetime) -> float:
        due = return_date - self.borrow_duration
        if return_date > due:
            days_late = (return_date - due).days
            return days_late * self.fine_per_day
        return 0.0
```

---

## 4. Vending Machine

### Requirements
- Accept coins/bills
- Display products and prices
- Dispense products and return change
- Handle inventory

```python
from enum import Enum

class ProductState(Enum):
    HAS_ITEM = "has_item"
    NO_ITEM = "no_item"
    SOLD_OUT = "sold_out"

class Product:
    def __init__(self, name: str, price: float, code: str):
        self.name = name
        self.price = price
        self.code = code

class VendingMachine:
    def __init__(self):
        self.products: dict[str, Product] = {}
        self.inventory: dict[str, int] = {}
        self.balance = 0.0

    def add_product(self, product: Product, quantity: int):
        self.products[product.code] = product
        self.inventory[product.code] = self.inventory.get(product.code, 0) + quantity

    def insert_coin(self, amount: float):
        self.balance += amount

    def select_product(self, code: str) -> Product:
        if code not in self.products:
            raise ValueError("Invalid product code")
        if self.inventory.get(code, 0) <= 0:
            raise Exception("Product sold out")
        product = self.products[code]
        if self.balance < product.price:
            raise Exception(f"Insufficient balance. Need ${product.price}")
        return product

    def dispense(self, code: str) -> tuple[Product, float]:
        product = self.select_product(code)
        self.inventory[code] -= 1
        change = self.balance - product.price
        self.balance = 0.0
        return product, change

    def get_state(self, code: str) -> ProductState:
        qty = self.inventory.get(code, 0)
        if qty <= 0:
            return ProductState.SOLD_OUT
        return ProductState.HAS_ITEM
```

---

## 5. Chess Game

### Requirements
- 8x8 board with standard chess pieces
- All standard moves (castling, en passant, promotion)
- Turn-based play
- Check/checkmate detection

```python
from enum import Enum
from typing import Optional

class Color(Enum):
    WHITE = "white"
    BLACK = "black"

class PieceType(Enum):
    KING = "king"
    QUEEN = "queen"
    ROOK = "rook"
    BISHOP = "bishop"
    KNIGHT = "knight"
    PAWN = "pawn"

class Piece:
    def __init__(self, color: Color, piece_type: PieceType):
        self.color = color
        self.piece_type = piece_type
        self.has_moved = False

    def __repr__(self):
        symbols = {
            PieceType.KING: "K", PieceType.QUEEN: "Q",
            PieceType.ROOK: "R", PieceType.BISHOP: "B",
            PieceType.KNIGHT: "N", PieceType.PAWN: "P"
        }
        s = symbols[self.piece_type]
        return s.upper() if self.color == Color.WHITE else s.lower()

class Position:
    def __init__(self, row: int, col: int):
        self.row = row
        self.col = col

    def is_valid(self) -> bool:
        return 0 <= self.row < 8 and 0 <= self.col < 8

    def __eq__(self, other):
        return self.row == other.row and self.col == other.col

class ChessBoard:
    def __init__(self):
        self.grid: list[list[Optional[Piece]]] = [[None]*8 for _ in range(8)]
        self._setup_board()

    def _setup_board(self):
        back_row = [
            PieceType.ROOK, PieceType.KNIGHT, PieceType.BISHOP,
            PieceType.QUEEN, PieceType.KING,
            PieceType.BISHOP, PieceType.KNIGHT, PieceType.ROOK
        ]
        for col in range(8):
            self.grid[0][col] = Piece(Color.BLACK, back_row[col])
            self.grid[1][col] = Piece(Color.BLACK, PieceType.PAWN)
            self.grid[6][col] = Piece(Color.WHITE, PieceType.PAWN)
            self.grid[7][col] = Piece(Color.WHITE, back_row[col])

    def get_piece(self, pos: Position) -> Optional[Piece]:
        return self.grid[pos.row][pos.col]

    def move(self, start: Position, end: Position) -> bool:
        piece = self.get_piece(start)
        if not piece:
            return False
        target = self.get_piece(end)
        if target and target.color == piece.color:
            return False  # Can't capture own piece
        self.grid[end.row][end.col] = piece
        self.grid[start.row][start.col] = None
        piece.has_moved = True
        return True

    def is_in_bounds(self, row: int, col: int) -> bool:
        return 0 <= row < 8 and 0 <= col < 8

class ChessGame:
    def __init__(self):
        self.board = ChessBoard()
        self.current_turn = Color.WHITE
        self.move_history: list[tuple[Position, Position]] = []

    def switch_turn(self):
        self.current_turn = (
            Color.BLACK if self.current_turn == Color.WHITE else Color.WHITE
        )

    def make_move(self, start: Position, end: Position) -> bool:
        piece = self.board.get_piece(start)
        if not piece or piece.color != self.current_turn:
            return False
        if self.board.move(start, end):
            self.move_history.append((start, end))
            self.switch_turn()
            return True
        return False
```

---

## Problem Difficulty Matrix

| Problem | Difficulty | Key Concepts | Time (Interview) |
|---------|-----------|--------------|-----------------|
| Parking Lot | Medium | Singleton, Factory, Strategy | 30-40 min |
| Elevator | Hard | State, Observer, Scheduler | 40-50 min |
| Library | Medium | OOP basics, Collections | 25-35 min |
| Vending Machine | Easy-Medium | State pattern, Inventory | 20-30 min |
| Chess | Hard | Game logic, Validation | 40-50 min |

---

## Quick Reference — Common Patterns Used

| Problem | Primary Pattern | Supporting Patterns |
|---------|----------------|-------------------|
| Parking Lot | Singleton, Strategy | Factory, Observer |
| Elevator | State, Observer | Strategy, Command |
| Library | Repository, Service | Strategy (search) |
| Vending Machine | State | Strategy (payment) |
| Chess | Command, Memento | Strategy (AI) |
