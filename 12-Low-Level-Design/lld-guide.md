# Low-Level Design (LLD) — Complete Guide

## What is Low-Level Design?

Low-Level Design is the process of defining the detailed internal structure of each module, class, and component in a system. It bridges the gap between high-level architecture and actual code implementation.

---

## The LLD Interview Format

Most LLD interviews follow this pattern:
- **Duration**: 45-60 minutes
- **Problem**: Design a real-world system (e.g., Parking Lot, Elevator)
- **Expectation**: Class diagrams, relationships, code structure
- **Evaluation**: Design thinking, OOP usage, problem decomposition

---

## Step-by-Step Approach

### Step 1: Requirements Gathering (5-7 minutes)

Ask questions to clarify scope:

```
Functional Requirements:
- What features should the system support?
- What are the primary use cases?
- Who are the users of the system?

Non-Functional Requirements:
- What is the expected scale (users, data)?
- What are the performance requirements?
- What are the availability requirements?
```

**Example Questions for Parking Lot:**
- How many floors does the parking lot have?
- What types of vehicles are supported?
- Is there a payment system?
- Do we need real-time slot availability?
- Are there different parking rates?

---

### Step 2: Core Entity Identification (5-10 minutes)

Identify the main objects in your system.

```
Parking Lot System Entities:
├── ParkingLot (main controller)
├── ParkingFloor
├── ParkingSlot
│   ├── CompactSlot
│   ├── LargeSlot
│   └── HandicappedSlot
├── Vehicle
│   ├── Car
│   ├── Truck
│   └── Motorcycle
├── Ticket
├── Payment
└── DisplayBoard
```

---

### Step 3: Define Class Structures (10-15 minutes)

```python
from enum import Enum
from datetime import datetime
from typing import Optional

class VehicleType(Enum):
    CAR = "car"
    TRUCK = "truck"
    MOTORCYCLE = "motorcycle"

class SlotType(Enum):
    COMPACT = "compact"
    LARGE = "large"
    HANDICAPPED = "handicapped"

class Vehicle:
    def __init__(self, license_plate: str, vehicle_type: VehicleType):
        self.license_plate = license_plate
        self.vehicle_type = vehicle_type

class ParkingSlot:
    def __init__(self, slot_id: int, slot_type: SlotType):
        self.slot_id = slot_id
        self.slot_type = slot_type
        self.is_occupied = False
        self.vehicle: Optional[Vehicle] = None

    def assign_vehicle(self, vehicle: Vehicle) -> bool:
        if self.is_occupied:
            return False
        self.vehicle = vehicle
        self.is_occupied = True
        return True

    def remove_vehicle(self) -> Optional[Vehicle]:
        vehicle = self.vehicle
        self.vehicle = None
        self.is_occupied = False
        return vehicle

class ParkingFloor:
    def __init__(self, floor_number: int, total_slots: int):
        self.floor_number = floor_number
        self.slots: list[ParkingSlot] = []
        self._initialize_slots(total_slots)

    def _initialize_slots(self, total: int):
        for i in range(total):
            if i < total * 0.6:
                self.slots.append(ParkingSlot(i, SlotType.COMPACT))
            elif i < total * 0.9:
                self.slots.append(ParkingSlot(i, SlotType.LARGE))
            else:
                self.slots.append(ParkingSlot(i, SlotType.HANDICAPPED))

    def find_available_slot(self, slot_type: SlotType) -> Optional[ParkingSlot]:
        for slot in self.slots:
            if not slot.is_occupied and slot.slot_type == slot_type:
                return slot
        return None
```

---

### Step 4: Design Relationships (5-10 minutes)

Use UML-style notation:

```
ParkingLot "1" --- "*" ParkingFloor
ParkingFloor "1" --- "*" ParkingSlot
ParkingSlot "0..1" --- "0..1" Vehicle
ParkingSlot "1" --- "0..1" Ticket
Ticket "1" --- "1" Payment
```

**Relationship Types:**

| Relationship | Description | Example |
|-------------|-------------|---------|
| Association | General relationship | ParkingLot has Floors |
| Composition | Strong ownership (dies with parent) | Floor contains Slots |
| Aggregation | Weak ownership (independent) | Lot has Vehicles |
| Inheritance | IS-A relationship | Car IS-A Vehicle |
| Dependency | Uses temporarily | Ticket uses Payment |

---

### Step 5: Design APIs (5-10 minutes)

```python
class ParkingLotAPI:
    def __init__(self, parking_lot: ParkingLot):
        self.parking_lot = parking_lot

    def park_vehicle(self, vehicle: Vehicle) -> Optional[Ticket]:
        """Park a vehicle and return a ticket"""
        slot = self.parking_lot.find_slot(vehicle.vehicle_type)
        if not slot:
            return None
        slot.assign_vehicle(vehicle)
        return Ticket(vehicle, slot, datetime.now())

    def unpark_vehicle(self, ticket_id: str) -> float:
        """Unpark vehicle and return the fee"""
        ticket = self.parking_lot.get_ticket(ticket_id)
        if not ticket:
            raise ValueError("Invalid ticket")
        fee = self._calculate_fee(ticket)
        ticket.slot.remove_vehicle()
        return fee

    def get_available_slots(self, slot_type: SlotType) -> int:
        """Get count of available slots"""
        return self.parking_lot.count_available(slot_type)

    def get_floor_info(self, floor_number: int) -> dict:
        """Get occupancy info for a floor"""
        return self.parking_lot.get_floor(floor_number).get_info()
```

---

### Step 6: Data Model Design (5 minutes)

```sql
-- Database Schema
CREATE TABLE parking_lots (
    id BIGINT PRIMARY KEY,
    name VARCHAR(255),
    address TEXT,
    total_floors INT
);

CREATE TABLE parking_floors (
    id BIGINT PRIMARY KEY,
    parking_lot_id BIGINT REFERENCES parking_lots(id),
    floor_number INT,
    total_slots INT
);

CREATE TABLE parking_slots (
    id BIGINT PRIMARY KEY,
    floor_id BIGINT REFERENCES parking_floors(id),
    slot_type VARCHAR(50),
    is_occupied BOOLEAN DEFAULT FALSE
);

CREATE TABLE vehicles (
    id BIGINT PRIMARY KEY,
    license_plate VARCHAR(20) UNIQUE,
    vehicle_type VARCHAR(50),
    color VARCHAR(50)
);

CREATE TABLE tickets (
    id BIGINT PRIMARY KEY,
    vehicle_id BIGINT REFERENCES vehicles(id),
    slot_id BIGINT REFERENCES parking_slots(id),
    entry_time TIMESTAMP,
    exit_time TIMESTAMP,
    fee DECIMAL(10, 2)
);
```

---

### Step 7: Handle Edge Cases (5 minutes)

```python
class ParkingLot:
    def handle_edge_cases(self):
        # 1. Concurrent access
        self.lock = threading.Lock()

        # 2. Parking lot full
        if self.is_full():
            raise ParkingLotFullException("No slots available")

        # 3. Invalid vehicle type
        if vehicle_type not in self.supported_types:
            raise UnsupportedVehicleException(f"{vehicle_type} not supported")

        # 4. Double parking
        if self.is_already_parked(vehicle.license_plate):
            raise AlreadyParkedException(f"{vehicle.license_plate} already parked")

        # 5. Payment failure
        if not self.process_payment(amount):
            raise PaymentFailedException("Payment processing failed")
```

---

## Common Design Patterns Used in LLD

| Pattern | Use Case | Example |
|---------|----------|---------|
| **Singleton** | Single instance of a service | ParkingLot instance |
| **Factory** | Creating different vehicle types | VehicleFactory |
| **Strategy** | Different payment methods | PaymentStrategy |
| **Observer** | Notification system | DisplayBoard updates |
| **State** | Ticket states (active, expired) | TicketState |
| **Decorator** | Adding features to vehicles | Vehicle with extras |

---

## Quality Checklist

Before finalizing your design, verify:

- [ ] All functional requirements are covered
- [ ] Class responsibilities are clear (Single Responsibility)
- [ ] Relationships are correctly defined (Composition > Aggregation)
- [ ] API methods are intuitive and complete
- [ ] Edge cases are handled
- [ ] Design is extensible (Open/Closed Principle)
- [ ] Data model supports required queries
- [ ] Concurrency issues are addressed
- [ ] Error handling is comprehensive

---

## Sample LLD Problems by Difficulty

### Easy
- Design a Vending Machine
- Design a Book Reader

### Medium
- Design a Parking Lot
- Design an Elevator System
- Design a Library Management System

### Hard
- Design a Chess Game
- Design a Traffic Management System
- Design a Hotel Booking System (like OYO)
- Design an ATM Machine
