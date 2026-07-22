# Queue

## Overview

A Queue is a linear data structure that follows the FIFO (First In First Out) principle. Elements are added at the rear and removed from the front.

## Types of Queues

### Simple Queue
- FIFO order
- Fixed size (array) or dynamic (linked list)

### Circular Queue
- Wraps around to beginning
- Efficient use of space

### Deque (Double-Ended Queue)
- Insert/delete from both ends
- More flexible than simple queue

### Priority Queue
- Elements have priorities
- Highest priority removed first

## Operations

| Operation | Time Complexity | Description |
|-----------|-----------------|-------------|
| Enqueue | O(1) | Add element to rear |
| Dequeue | O(1) | Remove element from front |
| Peek | O(1) | View front element |
| isEmpty | O(1) | Check if queue is empty |

## Implementation

### Array-based
```python
class Queue:
    def __init__(self):
        self.items = []
    
    def enqueue(self, item):
        self.items.append(item)
    
    def dequeue(self):
        if not self.is_empty():
            return self.items.pop(0)
    
    def peek(self):
        if not self.is_empty():
            return self.items[0]
    
    def is_empty(self):
        return len(self.items) == 0
```

### Linked List-based
```python
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class Queue:
    def __init__(self):
        self.front = None
        self.rear = None
    
    def enqueue(self, data):
        new_node = Node(data)
        if self.rear is None:
            self.front = self.rear = new_node
            return
        self.rear.next = new_node
        self.rear = new_node
    
    def dequeue(self):
        if self.front is None:
            return None
        data = self.front.data
        self.front = self.front.next
        if self.front is None:
            self.rear = None
        return data
```

## Applications

1. **BFS (Breadth-First Search)**: Level-order traversal
2. **CPU Scheduling**: Process scheduling
3. **IO Buffer**: Buffering input/output
4. **Printer Spooling**: Print job management
5. **Message Queues**: Async communication

## Common Problems

- Implement Queue using Stacks
- Sliding Window Maximum
- Rotting Oranges (BFS)
- Open the Lock (BFS)