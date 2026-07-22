# Low-Level Design — Interview Tips & Tricks

## Before the Interview

### Preparation Checklist
- [ ] Review SOLID principles thoroughly
- [ ] Practice 3-5 common LLD problems end-to-end
- [ ] Know at least 5 design patterns with use cases
- [ ] Practice drawing class diagrams on paper/whiteboard
- [ ] Time yourself — aim for 45-minute solutions
- [ ] Review OOP concepts (encapsulation, inheritance, polymorphism)

---

## During the Interview — The Framework

### Phase 1: Clarify (5-7 minutes)

**Always ask before designing:**

```
MUST ASK:
1. What are the core features?
2. What's the expected scale?
3. What are the constraints?
4. Who are the users?
5. Are there any non-functional requirements?

NICE TO ASK:
6. What's the deployment environment?
7. Are there existing systems to integrate with?
8. What's the expected latency/throughput?
9. Do we need to support multiple languages/platforms?
```

**Example — Parking Lot:**
```
You: "Before I start, I'd like to clarify a few things:
1. How many floors and total slots are we designing for?
2. What types of vehicles need to be supported?
3. Do we need a payment system or just tracking?
4. Is real-time availability tracking required?
5. Do we need to handle multiple payment methods?"

Interviewer: "3 floors, 100 slots each. Cars and motorcycles.
             Yes, payment with card/cash. Real-time tracking needed."
```

---

### Phase 2: High-Level Design (5-10 minutes)

Start with the big picture before diving into details:

```
1. List all major entities
2. Define relationships between them
3. Identify the main use cases/flows
4. Sketch the overall architecture
```

**Example — Parking Lot Entities:**
```
ParkingLot
├── ParkingFloor
│   └── ParkingSlot
├── Vehicle
├── Ticket
├── PaymentProcessor
└── DisplayBoard
```

---

### Phase 3: Detailed Design (15-20 minutes)

Now dive into each component:

```python
# Start with the most important class
class ParkingLot:
    def __init__(self):
        self.floors = []
        self.ticket_service = TicketService()
        self.payment_service = PaymentService()

    def park_vehicle(self, vehicle: Vehicle) -> Ticket:
        # Find available slot
        slot = self._find_slot(vehicle)
        if not slot:
            raise ParkingFullException()

        # Create ticket
        ticket = self.ticket_service.create(vehicle, slot)

        # Update display
        self._update_display()

        return ticket

    def unpark_vehicle(self, ticket_id: str) -> float:
        # Validate ticket
        ticket = self.ticket_service.get(ticket_id)

        # Calculate fee
        fee = self.payment_service.calculate(ticket)

        # Process payment
        self.payment_service.process(fee)

        # Free the slot
        ticket.slot.release()

        # Update display
        self._update_display()

        return fee
```

---

### Phase 4: Edge Cases & Extensions (5-10 minutes)

Discuss:
1. **Error handling** — What happens when things go wrong?
2. **Concurrency** — Multiple users accessing simultaneously
3. **Scalability** — How to handle growth
4. **Extensibility** — Adding new features

```
Edge Cases to Mention:
- Parking lot is full
- Invalid ticket on unpark
- Payment failure
- Concurrent parking of same slot
- Vehicle type mismatch with slot
- System restart/recovery
```

---

## Key Tips for Success

### 1. Think Out Loud

```python
# BAD: Silent coding
class ParkingLot:
    def park(self, v): ...

# GOOD: Explain as you go
class ParkingLot:
    """
    I'm designing ParkingLot as a singleton since we only
    need one instance. It will manage floors and coordinate
    between the ticket and payment services.
    """
    def __init__(self):
        # Using a list to store floors - we'll iterate to find slots
        self.floors = []
```

### 2. Start Simple, Then Iterate

```
Iteration 1: Basic parking/unparking
Iteration 2: Add payment calculation
Iteration 3: Add display board
Iteration 4: Handle concurrency
Iteration 5: Add reporting/analytics
```

### 3. Use Design Patterns Appropriately

| Scenario | Pattern | Why |
|----------|---------|-----|
| Single parking lot instance | Singleton | Only one lot in the system |
| Different vehicle types | Factory | Create vehicles without knowing concrete type |
| Payment methods (card/cash) | Strategy | Switch payment algorithms |
| Display updates | Observer | Notify displays when state changes |
| Ticket lifecycle | State | Ticket goes through states |
| Adding features to vehicles | Decorator | Add features dynamically |

### 4. Name Things Clearly

```python
# BAD
class A:
    def m1(self): pass
    def m2(self): pass

# GOOD
class ParkingSlot:
    def assign_vehicle(self, vehicle: Vehicle) -> bool: pass
    def release_vehicle(self) -> Optional[Vehicle]: pass
```

### 5. Show Trade-Off Awareness

```
"I'm choosing a HashMap for the ticket lookup because:
- O(1) lookup by ticket ID
- We need fast lookups during unpark
- Memory overhead is acceptable for our scale

An alternative would be a database, which would be better
for persistence but adds latency."
```

---

## Common Mistakes to Avoid

### 1. Jumping to Code Too Quickly
```
Mistake: "Let me start coding the classes..."
Correct: "Let me first clarify requirements and identify entities..."
```

### 2. Over-Engineering
```
Mistake: Adding 10 patterns when 2 would suffice
Correct: Start simple, add complexity only when needed
```

### 3. Ignoring Non-Functional Requirements
```
Mistake: Designing without considering scale/concurrency
Correct: Ask about and address these explicitly
```

### 4. Not Using OOP Properly
```
Mistake: Using only functions, no classes
Correct: Model real-world entities as classes
```

### 5. Forgetting Error Handling
```
Mistake: Happy path only
Correct: Handle exceptions, edge cases
```

---

## Communication Templates

### Starting the Problem
```
"I'd like to start by understanding the requirements better.
Let me ask a few clarifying questions..."
```

### Identifying Entities
```
"Based on our discussion, I've identified these core entities:
1. [Entity] - responsible for [purpose]
2. [Entity] - responsible for [purpose]
..."
```

### Presenting Your Design
```
"Here's my high-level design:
- [Component A] handles [responsibility]
- [Component B] manages [responsibility]
- They interact through [interface/event]
..."
```

### Discussing Trade-Offs
```
"There are two approaches here:
1. [Approach A] - pros: [...], cons: [...]
2. [Approach B] - pros: [...], cons: [...]
I'd go with [choice] because [reason]..."
```

### Wrapping Up
```
"To summarize:
- Core entities: [...]
- Main flows: [...]
- Key patterns used: [...]
- Areas for future enhancement: [...]
"
```

---

## Time Management

| Phase | Time | Focus |
|-------|------|-------|
| Clarify | 5-7 min | Requirements, constraints |
| High-Level | 5-10 min | Entities, relationships |
| Detailed | 15-20 min | Class design, methods |
| Edge Cases | 5-10 min | Errors, concurrency |
| Summary | 2-3 min | Recap, trade-offs |
| **Total** | **35-50 min** | |

---

## Practice Problems by Category

### Transportation
- Parking Lot System
- Elevator System
- Traffic Light Controller
- Ride Sharing (Uber/Lyft)

### Entertainment
- Chess Game
- Tic-Tac-Toe
- Card Game (Blackjack)
- Movie Ticket Booking

### E-Commerce
- Amazon Product Catalog
- Shopping Cart
- Order Management
- Payment Processing

### Social/Messaging
- Chat Application
- Social Media Feed
- Notification System
- URL Shortener

---

## Final Checklist

Before ending your interview, confirm:

- [ ] All functional requirements addressed
- [ ] Core classes defined with clear responsibilities
- [ ] Relationships between classes specified
- [ ] API methods documented
- [ ] At least 3 edge cases discussed
- [ ] Design patterns justified
- [ ] Trade-offs acknowledged
- [ ] Code is clean and readable
- [ ] You've summarized your design
