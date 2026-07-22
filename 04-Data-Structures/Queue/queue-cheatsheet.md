# Queue Cheat Sheet

## Core Concepts

### What is a Queue?
A linear data structure that follows the First-In-First-Out (FIFO) principle, meaning the first element added to the queue will be the first one to be removed.

### Key Characteristics
- **FIFO Principle**: First In, First Out - the earliest added element is the first to be removed
- **Two Ends**: Operations occur at two distinct ends (front for removal, rear for addition)
- **Dynamic Size**: Can grow and shrink as needed during runtime
- **Efficient Operations**: Enqueue and dequeue operations are O(1) time complexity
- **Ordered Processing**: Elements are processed in the order they arrive

## Queue Structure
```
Front                               Rear
 ↓                                  ↓
[ A ] -> [ B ] -> [ C ] -> [ D ] -> None
```
Where:
- **Front**: The end where elements are removed (dequeued)
- **Rear**: The end where elements are added (enqueued)
- Elements flow from rear to front

## Types of Queues

### 1. Linear Queue
- Standard implementation using array or linked list
- Simple but suffers from "false overflow" in array implementation

### 2. Circular Queue
- Optimized array implementation where rear wraps around to front
- Eliminates false overflow problem
- More efficient use of array space

### 3. Priority Queue
- Elements dequeued based on priority rather than arrival time
- Higher priority elements processed before lower priority ones
- Often implemented using heaps

### 4. Double Ended Queue (Deque)
- Allows insertion and deletion at both ends
- Combines features of stacks and queues

### 5. Circular Buffer
- Fixed-size buffer that overwrites oldest data when full
- Useful for streaming data and logging applications

## Core Operations and Time Complexities

### Standard Queue Operations
| Operation | Time Complexity | Space Complexity | Description |
|-----------|----------------|------------------|-------------|
| Enqueue | O(1) | O(1) | Add element to rear |
| Dequeue | O(1) | O(1) | Remove element from front |
| Front/Peek | O(1) | O(1) | View front element without removal |
| Rear | O(1) | O(1) | View rear element without removal |
| isEmpty | O(1) | O(1) | Check if queue has no elements |
| size | O(1) | O(1) | Return number of elements |

### Priority Queue Operations (Heap-based)
| Operation | Time Complexity | Space Complexity | Description |
|-----------|----------------|------------------|-------------|
| Insert | O(log n) | O(1) | Add element with priority |
| Extract Max/Min | O(log n) | O(1) | Remove and return highest/lowest priority element |
| Peek Max/Min | O(1) | O(1) | View highest/lowest priority element without removal |

## Implementation Techniques

### 1. Array-Based Circular Queue
```python
class CircularQueue:
    def __init__(self, k):
        self.capacity = k
        self.queue = [0] * k
        self.front = 0
        self.rear = -1
        self.count = 0
    
    def enQueue(self, value):
        if self.isFull():
            return False
        self.rear = (self.rear + 1) % self.capacity
        self.queue[self.rear] = value
        self.count += 1
        return True
    
    def deQueue(self):
        if self.isEmpty():
            return False
        self.front = (self.front + 1) % self.capacity
        self.count -= 1
        return True
    
    def isEmpty(self):
        return self.count == 0
    
    def isFull(self):
        return self.count == self.capacity
```

### 2. Linked List-Based Queue
```python
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class Queue:
    def __init__(self):
        self.front = None
        self.rear = None
        self.size = 0
    
    def enqueue(self, data):
        new_node = Node(data)
        if self.rear is None:
            self.front = self.rear = new_node
        else:
            self.rear.next = new_node
            self.rear = new_node
        self.size += 1
    
    def dequeue(self):
        if self.is_empty():
            raise IndexError("dequeue from empty queue")
        temp = self.front
        self.front = self.front.next
        if self.front is None:
            self.rear = None
        self.size -= 1
        return temp.data
```

## Common Algorithms and Patterns

### 1. Breadth-First Search (BFS)
**Use Case**: Graph traversal, shortest path in unweighted graphs
**Pattern**: 
- Use queue to store nodes to visit
- Process nodes level by level
- Enqueue unvisited neighbors
- Time: O(V+E), Space: O(V)

### 2. Sliding Window
**Use Case**: Fixed-size window processing, moving averages
**Pattern**: 
- Maintain window of fixed size
- Add new element to rear, remove old element from front
- Track aggregate values (sum, max, min) efficiently
- Time: O(n) for n elements, Space: O(k) for window size k

### 3. Resource Allocation
**Use Case**: Process scheduling, job queues, print spooling
**Pattern**: 
- Requests added to rear of queue
- Resources allocated to processes at front
- Ensures fair processing in order of arrival
- Variations: priority queues for preferential treatment

### 4. Buffering
**Use Case**: Asynchronous data transfer, I/O operations
**Pattern**: 
- Producer adds data to rear of queue
- Consumer reads data from front of queue
- Allows producer and consumer to operate at different speeds
- Prevents data loss when consumer is temporarily slow

### 5. Rate Limiting
**Use Case**: API rate limiting, request throttling
**Pattern**: 
- Store timestamps of recent requests in queue
- Remove old timestamps outside time window
- Count remaining requests in window
- Time: O(1) amortized per operation

### 6. Simulation
**Use Case**: Modeling real-world systems with waiting lines
**Pattern**: 
- Entities enter system and join queue
- Servers process entities from front of queue
- Collect statistics on wait times, queue lengths, etc.
- Discrete event simulation often uses priority queues

## Specialized Queue Variations

### Priority Queue
Elements processed by priority:
```python
import heapq

class PriorityQueue:
    def __init__(self):
        self.heap = []
    
    def push(self, item, priority):
        heapq.heappush(self.heap, (priority, item))
    
    def pop(self):
        return heapq.heappop(self.heap)[1]
```

### Double Ended Queue (Deque)
Insertion/deletion at both ends:
```python
from collections import deque

class Deque:
    def __init__(self):
        self.items = deque()
    
    def add_front(self, item):
        self.items.appendleft(item)
    
    def add_rear(self, item):
        self.items.append(item)
    
    def remove_front(self):
        return self.items.popleft()
    
    def remove_rear(self):
        return self.items.pop()
```

### Circular Buffer
Fixed-size buffer that overwrites old data:
```python
class CircularBuffer:
    def __init__(self, size):
        self.buffer = [0] * size
        self.size = size
        self.head = 0  # Points to oldest element
        self.tail = 0  # Points to next write position
        self.full = False
    
    def write(self, value):
        self.buffer[self.tail] = value
        self.tail = (self.tail + 1) % self.size
        if self.tail == self.head:
            self.full = True
            self.head = (self.head + 1) % self.size
    
    def read(self):
        if not self.full and self.head == self.tail:
            raise Exception("Buffer empty")
        value = self.buffer[self.head]
        self.head = (self.head + 1) % self.size
        self.full = False
        return value
```

## When to Use Queues

### ✅ Use Queues When:
- You need FIFO (First-In-First-Out) behavior
- Processing tasks in the order they arrive
- Implementing breadth-first search (BFS)
- Managing shared resources (printers, CPU, etc.)
- Handling asynchronous data streams
- Implementing buffering mechanisms
- Simulating real-world systems with waiting lines
- Implementing rate limiting or throttling mechanisms
- Handling interrupts or events in real-time systems
- Managing worker threads in thread pools

### ❌ Avoid Queues When:
- You need LIFO (Last-In-First-Out) behavior (use stack instead)
- You need random access to elements
- You need to access elements in the middle efficiently
- You need priority-based processing (use priority queue instead)
- You need to access both ends equally (use deque instead)
- You need to maintain sorted order (use tree or heap instead)
- You need to frequently search for specific elements (use hash table or tree instead)

## Space-Time Tradeoffs

### Array-Based vs Linked List-Based Queues
| Aspect | Array-Based (Circular) | Linked List-Based |
|--------|------------------------|-------------------|
| Enqueue/Dequeue | O(1) amortized | O(1) worst case |
| Memory Allocation | Contiguous | Non-contiguous |
| Cache Locality | Excellent | Poor |
| Allocation Overhead | Low (bulk allocation) | High (per-node) |
| Memory Wastage | Fixed size or resize cost | None (except pointers) |
| Size Limit | Fixed or resize cost | Limited only by memory |
| Implementation Simplicity | Moderate (index handling) | Simple (pointer manipulation) |

### Compared to Other Data Structures
| Aspect | Queue | Stack | Priority Queue | Array |
|--------|-------|-------|----------------|-------|
| Access Pattern | FIFO | LIFO | Priority-based | Random |
| Insertion | O(1) at rear | O(1) at top | O(log n) | O(n) at beginning/middle |
| Deletion | O(1) at front | O(1) at top | O(log n) | O(n) at beginning/middle |
| Peek | O(1) at front | O(1) at top | O(1) | O(1) |
| Use Case | Order preservation, BFS | Function calls, undo/redo | Scheduling, Dijkstra | General storage |

## Common Algorithms Using Queues

### 1. Breadth-First Search (BFS)
```python
from collections import deque

def bfs(graph, start):
    visited = set()
    queue = deque([start])
    visited.add(start)
    
    while queue:
        vertex = queue.popleft()
        # Process vertex
        for neighbor in graph[vertex]:
            if neighbor not in visited:
                visited.add(neighbor)
                queue.append(neighbor)
```

### 2. Level Order Tree Traversal
```python
from collections import deque

def level_order(root):
    if not root:
        return []
    
    result = []
    queue = deque([root])
    
    while queue:
        level_size = len(queue)
        current_level = []
        
        for _ in range(level_size):
            node = queue.popleft()
            current_level.append(node.val)
            
            if node.left:
                queue.append(node.left)
            if node.right:
                queue.append(node.right)
        
        result.append(current_level)
    
    return result
```

### 3. Sliding Window Maximum
```python
from collections import deque

def max_sliding_window(nums, k):
    if not nums:
        return []
    
    if k == 1:
        return nums
    
    deq = deque()
    result = []
    
    # Process first k elements
    for i in range(k):
        while deq and nums[i] >= nums[deq[-1]]:
            deq.pop()
        deq.append(i)
    
    # Process rest of elements
    for i in range(k, len(nums)):
        result.append(nums[deq[0]])
        
        # Remove elements out of this window
        while deq and deq[0] <= i - k:
            deq.popleft()
        
        # Remove elements smaller than current from rear
        while deq and nums[i] >= nums[deq[-1]]:
            deq.pop()
        
        deq.append(i)
    
    # Add maximum for last window
    result.append(nums[deq[0]])
    return result
```

### 4. Implement Stack Using Queues
```python
from collections import deque

class StackUsingQueues:
    def __init__(self):
        self.q1 = deque()
        self.q2 = deque()
    
    def push(self, x):
        self.q1.append(x)
    
    def pop(self):
        if not self.q1:
            raise IndexError("pop from empty stack")
        
        # Move all except last element from q1 to q2
        while len(self.q1) > 1:
            self.q2.append(self.q1.popleft())
        
        # Last element is the top of stack
        result = self.q1.popleft()
        
        # Swap q1 and q2
        self.q1, self.q2 = self.q2, self.q1
        
        return result
```

## Performance Characteristics

### Time Complexity Summary
| Operation | Array-Based (Circular) | Linked List-Based | Notes |
|-----------|------------------------|-------------------|-------|
| Enqueue | O(1) amortized | O(1) worst case | Amortized due to resizing |
| Dequeue | O(1) amortized | O(1) worst case | Same as enqueue |
| Front/Peek | O(1) | O(1) | Constant time |
| Rear | O(1) | O(1) | Constant time (with rear pointer) |
| isEmpty | O(1) | O(1) | Constant time |
| size | O(1) | O(1) | Constant time (with counter) |

### Space Complexity
- **Base Structure**: O(n) for n elements
- **Overhead**: 
  - Array-based: Minimal (just array storage)
  - Linked list-based: Pointer overhead per node (typically 8-16 bytes per node on 64-bit systems)
- **Auxiliary Space**: Varies by algorithm (O(1) to O(n))

### Amortized Analysis for Array-Based Queue
When using dynamic resizing (typically doubling size):
- Most enqueue operations: O(1) (no resize needed)
- Occasional enqueue operations: O(n) (when resize occurs)
- Amortized cost per operation: O(1)
- Proof: For n insertions starting from size 1:
  - Total cost = n (inserts) + (1 + 2 + 4 + ... + 2^k) where 2^k < n
  - Geometric series sum < 2n
  - Total cost < 3n
  - Amortized cost per operation < 3 = O(1)

## Real-World Examples

### 1. Printer Queue
Documents are added to the end of the queue and printed from the front, ensuring fair processing in order of arrival.

### 2. Call Center Systems
Incoming calls are queued and agents pick up calls from the front, ensuring fair distribution of calls.

### 3. Network Packet Routing
Packets arrive at routers and are queued for transmission. Routers process packets from the front of the queue, managing congestion and fairness.

### 4. CPU Process Scheduling
Ready processes are placed in a queue, and the scheduler picks processes from the front based on the scheduling algorithm (FIFO, Round Robin, etc.).

### 5. Asynchronous I/O Operations
I/O requests are placed in a queue and processed by the I/O subsystem from the front, enabling overlap of computation and I/O.

### 6. Message Queues in Distributed Systems
Messages are published to queues and consumed from the front, enabling decoupling of producers and consumers while providing buffering and load balancing.

## Common Pitfalls and How to Avoid Them

### 1. Confusing Front and Rear
**Problem**: Mixing up which end is for insertion and which for removal
**Solution**: 
- Remember: Enqueue at rear, Dequeue from front
- Visualize as a line of people: new people join at back, service happens at front
- Use consistent terminology in code and comments

### 2. Forgetting to Handle Wrap-Around in Circular Queues
**Problem**: Not using modulo operator for index calculation
**Solution**: 
- Always use `(index + 1) % capacity` for circular increment
- Test boundary conditions thoroughly
- Consider using helper methods for index calculation

### 3. Incorrect Empty/Full Conditions
**Problem**: Mixing up conditions for empty and full states
**Solution**:
- Empty: `front == rear` (when using count variable, `count == 0`)
- Full: `(rear + 1) % capacity == front` (when using count variable, `count == capacity`)
- Using a count variable simplifies these checks

### 4. Memory Leaks (Manual Memory Management)
**Problem**: Not freeing memory when nodes are dequeued
**Solution**:
- Always deallocate/free memory when removing nodes
- In garbage-collected languages, ensure references are properly removed
- Use tools like valgrind or memory profilers to detect leaks

### 5. Off-by-One Errors
**Problem**: Incorrect index calculations leading to buffer overruns or underruns
**Solution**:
- Draw diagrams to visualize indices
- Test with edge cases: empty queue, single element, full queue
- Use assertions to validate assumptions during development

### 6. Not Considering Thread Safety
**Problem**: Concurrent access leading to race conditions
**Solution**:
- Use mutexes or semaphores for synchronization
- Consider lock-free implementations for high-performance scenarios
- Use built-in concurrent queue implementations when available

## Interview Tips

### What Interviewers Look For
1. **Understanding of FIFO Principle**: Correctly applying queue behavior
2. **Implementation Skills**: Ability to implement queues using arrays or linked lists
3. **Problem Mapping**: Recognizing when a problem requires queue behavior
4. **Edge Case Handling**: Empty queue, single element, full queue (for bounded queues)
5. **Algorithm Knowledge**: Knowing classic queue-based algorithms (BFS, sliding window)
6. **Time/Space Complexity Awareness**: Optimizing for efficiency
7. **Clean Code**: Readable, well-commented implementations

### Common Interview Questions
1. Implement a queue using stacks
2. Implement a stack using queues
3. Binary tree level order traversal (BFS)
4. Sliding window maximum
5. Number of recent calls (LeetCode 933)
6. Design circular queue
7. Design circular deque
8. Implement queue using linked list
9. Moving average from data stream
10. First unique number in a stream

### Follow-up Questions to Expect
- How would you implement a queue using two stacks?
- Can you implement a queue that supports getting the maximum element in O(1) time?
- How would you design a circular queue?
- What's the difference between queue and deque?
- How would you implement a priority queue?
- How would you solve the sliding window maximum problem?
- How would you implement a queue using linked list?
- How would you handle a queue that needs to be thread-safe?
- What are the applications of queues in operating systems?
- How would you implement a queue that can survive process restarts?

### Best Practices for Interview Answers
1. **Clarify Requirements**: Ask about queue type, constraints, operations needed
2. **Discuss Trade-offs**: Mention time/space complexity and implementation choices
3. **Consider Edge Cases**: Empty queue, single element, full queue (if bounded)
4. **Talk Through Approach**: Explain algorithm before coding, justify choices
5. **Write Clean Code**: Meaningful variable names, proper formatting, comments
6. **Test Solution**: Walk through examples to catch logical errors
7. **Mention Alternatives**: Discuss other approaches and justify your choice
8. **Address Memory Management**: In relevant languages, discuss allocation/deallocation
9. **Consider Extensions**: How would solution change for enhanced functionality?
10. **Think About Real-World Applications**: Relate to practical use cases

## Summary
Queues are fundamental data structures that embody the First-In-First-Out (FIFO) principle. Their simplicity belies their power and versatility in solving a wide range of computational problems.

Whether implemented using arrays (with circular buffering to avoid wasted space) or linked lists, queues provide O(1) time complexity for their core operations (enqueue, dequeue, peek), making them highly efficient for their intended use cases. Their two-ended access pattern (enqueue at rear, dequeue from front) is both a defining characteristic and a source of their utility in modeling real-world waiting lines and processing pipelines.

Understanding queues is crucial for any programmer because they appear in numerous contexts:
- System-level: Process scheduling, interrupt handling, memory management
- Algorithm-level: Breadth-first search, sliding window problems, buffering
- Application-level: Print spooling, call center systems, network packet routing
- Concurrent systems: Thread pools, worker queues, message passing

The key to mastering queues is recognizing when a problem exhibits FIFO behavior and being able to apply queue-based solutions effectively. Common patterns to recognize include:
- Processing items in order of arrival
- Breadth-first traversal of graphs or trees
- Sliding window problems
- Resource allocation and scheduling
- Asynchronous data transfer and buffering
- Event handling and message passing

By understanding these patterns and practicing queue-based problems, you'll develop the intuition needed to apply queues effectively in both interview situations and real-world software development. Whether you're preparing for technical interviews, working on software projects, or studying computer science theory, a solid understanding of queues will serve you well across numerous applications and technologies.