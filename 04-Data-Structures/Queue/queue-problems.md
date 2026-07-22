# Queue Problems

## Easy Problems

### 1. Implement Queue using Linked List
**Problem**: Implement a queue using a linked list.

**Solution Approach**:
- Use a linked list with head (front) and tail (rear) pointers
- Enqueue at tail, dequeue from head
- Time: O(1) for both operations, Space: O(n)

**Python Solution**:
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
    
    def is_empty(self):
        return self.front is None
    
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
    
    def peek(self):
        if self.is_empty():
            raise IndexError("peek from empty queue")
        return self.front.data
```

### 2. Number of Recent Calls
**Problem**: Implement a RecentCounter class that counts recent requests within a 3000 millisecond window.

**Example**:
```
Input
["RecentCounter", "ping", "ping", "ping", "ping"]
[[], [1], [100], [3001], [3002]]
Output
[null, 1, 2, 3, 3]
```

**Solution Approach**:
- Use queue to store timestamps
- Remove timestamps older than 3000ms from front
- Time: O(1) amortized per ping, Space: O(n)

**Python Solution**:
```python
from collections import deque

class RecentCounter:
    def __init__(self):
        self.queue = deque()
    
    def ping(self, t: int) -> int:
        self.queue.append(t)
        # Remove timestamps older than t-3000
        while self.queue and self.queue[0] < t - 3000:
            self.queue.popleft()
        return len(self.queue)
```

### 3. Moving Average from Data Stream
**Problem**: Given a stream of integers and a window size, calculate the moving average of all integers in the sliding window.

**Example**:
```
Input
["MovingAverage", "next", "next", "next", "next"]
[[3], [1], [10], [3], [5]]
Output
[null, 1.0, 5.5, 4.66667, 6.0]
```

**Solution Approach**:
- Use queue to store window elements
- Maintain running sum for efficient average calculation
- Time: O(1) per next operation, Space: O(k)

**Python Solution**:
```python
from collections import deque

class MovingAverage:
    def __init__(self, size: int):
        self.queue = deque()
        self.size = size
        self.sum = 0
    
    def next(self, val: int) -> float:
        self.queue.append(val)
        self.sum += val
        
        if len(self.queue) > self.size:
            self.sum -= self.queue.popleft()
        
        return self.sum / len(self.queue)
```

### 4. Design Circular Queue
**Problem**: Design your implementation of the circular queue. The circular queue is a linear data structure in which the operations are performed based on FIFO (First In First Out) principle and the last position is connected back to the first position to make a circle.

**Example**:
```
Input
["MyCircularQueue", "enQueue", "enQueue", "enQueue", "enQueue", "deQueue", "deQueue", "isEmpty"]
[[3], [1], [2], [3], [4], [], [], []]
Output
[null, null, null, null, true, 1, 2, false]
```

**Solution Approach**:
- Use array with front and rear pointers
- Use modulo arithmetic for wrap-around
- Track count to distinguish empty vs full states
- Time: O(1) for all operations, Space: O(k)

**Python Solution**:
```python
class MyCircularQueue:
    def __init__(self, k: int):
        self.capacity = k
        self.queue = [0] * k
        self.front = 0
        self.rear = -1
        self.count = 0
    
    def enQueue(self, value: int) -> bool:
        if self.isFull():
            return False
        self.rear = (self.rear + 1) % self.capacity
        self.queue[self.rear] = value
        self.count += 1
        return True
    
    def deQueue(self) -> bool:
        if self.isEmpty():
            return False
        self.front = (self.front + 1) % self.capacity
        self.count -= 1
        return True
    
    def Front(self) -> int:
        if self.isEmpty():
            return -1
        return self.queue[self.front]
    
    def Rear(self) -> int:
        if self.isEmpty():
            return -1
        return self.queue[self.rear]
    
    def isEmpty(self) -> bool:
        return self.count == 0
    
    def isFull(self) -> bool:
        return self.count == self.capacity
```

### 5. First Unique Character in a Stream
**Problem**: Given a stream of characters, find the first non-repeating character from the stream at any given time.

**Example**:
```
Input: stream = "aabc"
Output: ["a", "a", "b", "b"]
```

**Solution Approach**:
- Use queue to maintain order of characters
- Use hash map to count frequencies
- When querying, remove from front of queue until finding non-repeating
- Time: O(1) amortized per operation, Space: O(σ) where σ is charset size

**Python Solution**:
```python
from collections import deque, defaultdict

class FirstUnique:
    def __init__(self, nums):
        self.queue = deque()
        self.freq = defaultdict(int)
        for num in nums:
            self.add(num)
    
    def showFirstUnique(self) -> int:
        while self.queue and self.freq[self.queue[0]] > 1:
            self.queue.popleft()
        return self.queue[0] if self.queue else -1
    
    def add(self, value: int) -> None:
        self.freq[value] += 1
        if self.freq[value] == 1:
            self.queue.append(value)
```

## Medium Problems

### 1. Sliding Window Maximum
**Problem**: Given an array nums, there is a sliding window of size k which is moving from the very left of the array to the very right. You can only see the k numbers in the window. Each time the sliding window moves right by one position.

Return the max sliding window.

**Example**:
```
Input: nums = [1,3,-1,-3,5,3,6,7], k = 3
Output: [3,3,5,5,6,7]
```

**Solution Approach**:
- Use deque to store indices of useful elements in current window
- Maintain decreasing order in deque (front has maximum)
- Remove indices outside window from front
- Remove smaller elements from rear before adding new element
- Time: O(n), Space: O(k)

**Python Solution**:
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
        # Remove elements smaller than current from rear
        while deq and nums[i] >= nums[deq[-1]]:
            deq.pop()
        deq.append(i)
    
    # Process rest of elements
    for i in range(k, len(nums)):
        # Add front of deque to result
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

### 2. Design Circular Deque
**Problem**: Design your implementation of the circular double-ended queue (deque).

**Example**:
```
Input
["MyCircularDeque", "insertLast", "insertLast", "insertFront", "insertFront", "getRear", "isFull", "deleteLast", "insertFront", "getFront"]
[[3], [1], [2], [3], [4], [], [], [4], [], []]
Output
[null, null, null, null, 2, true, false, true, 4, 4]
```

**Solution Approach**:
- Use array with front and rear pointers
- Use modulo arithmetic for wrap-around
- Track count to distinguish empty vs full states
- Support operations at both ends
- Time: O(1) for all operations, Space: O(k)

**Python Solution**:
```python
class MyCircularDeque:
    def __init__(self, k: int):
        self.capacity = k
        self.deque = [0] * k
        self.front = 0
        self.rear = -1
        self.count = 0
    
    def insertFront(self, value: int) -> bool:
        if self.isFull():
            return False
        self.front = (self.front - 1 + self.capacity) % self.capacity
        self.deque[self.front] = value
        self.count += 1
        return True
    
    def insertLast(self, value: int) -> bool:
        if self.isFull():
            return False
        self.rear = (self.rear + 1) % self.capacity
        self.deque[self.rear] = value
        self.count += 1
        return True
    
    def deleteFront(self) -> bool:
        if self.isEmpty():
            return False
        self.front = (self.front + 1) % self.capacity
        self.count -= 1
        return True
    
    def deleteLast(self) -> bool:
        if self.isEmpty():
            return False
        self.rear = (self.rear - 1 + self.capacity) % self.capacity
        self.count -= 1
        return True
    
    def getFront(self) -> int:
        if self.isEmpty():
            return -1
        return self.deque[self.front]
    
    def getRear(self) -> int:
        if self.isEmpty():
            return -1
        return self.deque[self.rear]
    
    def isEmpty(self) -> bool:
        return self.count == 0
    
    def isFull(self) -> bool:
        return self.count == self.capacity
```

### 3. Binary Tree Level Order Traversal
**Problem**: Given the root of a binary tree, return the level order traversal of its nodes' values. (i.e., from left to right, level by level).

**Example**:
```
Input: root = [3,9,20,null,null,15,7]
Output: [[3],[9,20],[15,7]]
```

**Solution Approach**:
- Use queue for breadth-first search (BFS)
- Process nodes level by level
- For each level, record all node values
- Time: O(n), Space: O(w) where w is maximum width of tree

**Python Solution**:
```python
from collections import deque

# Definition for a binary tree node.
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

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

### 4. Implement Stack using Queues
**Problem**: Implement a last-in-first-out (LIFO) stack using only two queues.

**Example**:
```
Input
["MyStack", "push", "push", "top", "pop", "empty"]
[[], [1], [2], [], [], []]
Output
[null, null, 2, 2, false]
```

**Solution Approach**:
- Use two queues: q1 for main storage, q2 for temporary
- For push: add to q1
- For pop/top: move all elements except last from q1 to q2, operate on last element, swap q1 and q2
- Time: O(n) for pop/top, O(1) for push, Space: O(n)

**Python Solution**:
```python
from collections import deque

class MyStack:
    def __init__(self):
        self.q1 = deque()
        self.q2 = deque()
    
    def push(self, x: int) -> None:
        self.q1.append(x)
    
    def pop(self) -> int:
        if self.empty():
            raise IndexError("pop from empty stack")
        
        # Move all except last element from q1 to q2
        while len(self.q1) > 1:
            self.q2.append(self.q1.popleft())
        
        # Last element is the top of stack
        result = self.q1.popleft()
        
        # Swap q1 and q2
        self.q1, self.q2 = self.q2, self.q1
        
        return result
    
    def top(self) -> int:
        if self.empty():
            raise IndexError("top from empty stack")
        
        # Move all except last element from q1 to q2
        while len(self.q1) > 1:
            self.q2.append(self.q1.popleft())
        
        # Last element is the top of stack
        result = self.q1.popleft()
        
        # Put it back in q1 and swap
        self.q2.append(result)
        self.q1, self.q2 = self.q2, self.q1
        
        return result
    
    def empty(self) -> bool:
        return not self.q1
```

### 5. Design Hit Counter
**Problem**: Design a hit counter which counts the number of hits received in the past 5 minutes.

**Example**:
```
Input
["HitCounter", "hit", "hit", "hit", "getHits", "hit", "getHits", "getHits"]
[[], [1], [2], [3], [], [300], [], []]
Output
[null, null, null, null, 3, null, 4, 3]
```

**Solution Approach**:
- Use queue to store timestamps of hits
- Remove timestamps older than 300 seconds from front
- Time: O(1) amortized per hit/getHits, Space: O(n)

**Python Solution**:
```python
from collections import deque

class HitCounter:
    def __init(self):
        self.queue = deque()
    
    def hit(self, timestamp: int) -> None:
        self.queue.append(timestamp)
    
    def getHits(self, timestamp: int) -> int:
        # Remove timestamps older than timestamp-300
        while self.queue and self.queue[0] <= timestamp - 300:
            self.queue.popleft()
        return len(self.queue)
```

## Hard Problems

### 1. Maximum of Minimum for Every Window Size
**Problem**: Given an integer array of size N, find the maximum of the minimum of every window size in the array.

**Example**:
```
Input: arr = [10, 20, 30, 50, 10, 70, 30]
Output: [70, 30, 20, 10, 10, 10, 10]
```

**Solution Approach**:
- Use stack to find previous smaller and next smaller elements
- For each element, determine window sizes where it's minimum
- Update result array with maximum minimums for each window size
- Time: O(n), Space: O(n)

**Python Solution**:
```python
def max_of_min(arr, n):
    # Arrays to store left and right boundaries
    left = [-1] * n
    right = [n] * n
    
    # Stack for previous smaller element
    stack = []
    for i in range(n):
        while stack and arr[stack[-1]] >= arr[i]:
            stack.pop()
        if stack:
            left[i] = stack[-1]
        stack.append(i)
    
    # Clear stack for next smaller element
    stack = []
    for i in range(n-1, -1, -1):
        while stack and arr[stack[-1]] > arr[i]:
            stack.pop()
        if stack:
            right[i] = stack[-1]
        stack.append(i)
    
    # Result array for window sizes
    result = [0] * (n + 1)
    
    # Fill result with maximum minimums
    for i in range(n):
        length = right[i] - left[i] - 1
        result[length] = max(result[length], arr[i])
    
    # Fill empty entries (maximum of minimums for smaller windows)
    for i in range(n-1, 0, -1):
        result[i] = max(result[i], result[i+1])
    
    return result[1:]
```

### 2. Reorganize String
**Problem**: Given a string s, rearrange the characters of s so that any two adjacent characters are not the same.

**Example**:
```
Input: s = "aab"
Output: "aba"
```

**Solution Approach**:
- Use max heap to store characters by frequency
- Always pick two most frequent different characters
- Time: O(n log σ), Space: O(σ) where σ is charset size

**Python Solution**:
```python
import heapq
from collections import Counter

def reorganize_string(s):
    # Count frequencies
    freq = Counter(s)
    
    # Create max heap (using negative frequencies)
    max_heap = [(-count, char) for char, count in freq.items()]
    heapq.heapify(max_heap)
    
    result = []
    prev_char = None
    prev_count = 0
    
    while max_heap:
        count, char = heapq.heappop(max_heap)
        result.append(char)
        
        # If we have a previous character, push it back if count remains
        if prev_count < 0:
            heapq.heappush(max_heap, (prev_count, prev_char))
        
        # Update previous character
        prev_char = char
        prev_count = count + 1  # Increment because we used one instance
    
    # Check if reorganization was possible
    if len(result) != len(s):
        return ""
    
    return ''.join(result)
```

### 3. Task Scheduler
**Problem**: Given a characters array tasks, representing the tasks a CPU needs to do, where each letter represents a different task. Tasks could be done in any order. Each task is done in one unit of time. For each unit of time, the CPU could complete either one task or just be idle.

However, there is a non-negative integer n that represents the cooldown period between two same tasks (the same letter in the array), that is that there must be at least n units of time between any two same tasks.

Return the least number of units of times that the CPU will take to finish all the given tasks.

**Example**:
```
Input: tasks = ["A","A","A","B","B","B"], n = 2
Output: 8
Explanation: A -> B -> idle -> A -> B -> idle -> A -> B.
```

**Solution Approach**:
- Use max heap to store task frequencies
- Use queue to track cooldown
- Always execute most frequent available task
- Time: O(n log σ), Space: O(σ) where σ is number of unique tasks

**Python Solution**:
```python
import heapq
from collections import Counter, deque

def least_interval(tasks, n):
    # Count frequencies
    freq = Counter(tasks)
    
    # Create max heap
    max_heap = [-count for count in freq.values()]
    heapq.heapify(max_heap)
    
    time = 0
    cooldown_queue = deque()  # Stores (available_time, count)
    
    while max_heap or cooldown_queue:
        time += 1
        
        # If there's an available task, use it
        if max_heap:
            count = heapq.heappop(max_heap) + 1  # Use one instance (negative count)
            if count < 0:  # Still has remaining instances
                cooldown_queue.append((time + n, count))
        
        # Check if any task has finished cooldown
        if cooldown_queue and cooldown_queue[0][0] == time:
            heapq.heappush(max_heap, cooldown_queue.popleft()[1])
    
    return time
```

### 4. Generate Binary Numbers
**Problem**: Given a number N, generate binary numbers from 1 to N.

**Example**:
```
Input: N = 5
Output: 1, 10, 11, 100, 101
```

**Solution Approach**:
- Use queue to generate binary numbers level by level
- Start with "1"
- For each number, append "0" and "1" to generate next numbers
- Time: O(n), Space: O(n)

**Python Solution**:
```python
from collections import deque

def generate_binary_numbers(n):
    if n < 1:
        return []
    
    result = []
    queue = deque(["1"])
    
    for _ in range(n):
        # Get front of queue
        front = queue.popleft()
        result.append(front)
        
        # Generate next binary numbers
        queue.append(front + "0")
        queue.append(front + "1")
    
    return result
```

### 5. First Circular Tour to Visit All Petrol Pumps
**Problem**: Suppose there is a circle. There are N petrol pumps on that circle. Petrol pumps are given as a pair of (petrol, distance) where petrol is the amount of petrol the pump gives and distance is the distance to the next pump.

Find the first petrol pump from where a truck can start to complete the circle (The truck will stop at each petrol pump and it has infinite capacity).

**Example**:
```
Input: N = 4
Petrol = [4, 6, 7, 4]
Distance = [6, 5, 3, 5]
Output: 1
```

**Solution Approach**:
- Use queue to simulate the tour
- Try starting from each pump, but optimize using insights
- Time: O(n), Space: O(1)

**Python Solution**:
```python
def print_tour(petrol, distance):
    n = len(petrol)
    
    # Consider first_p
 surplus_petrol[i
    [i]
    total_surplus
    start 
= 0
    
for i 
in range(n:
        total
_surplus
+=
petrol
[i]
- distance[i]
        if
current
surplus
< 
0:
            # Reset
            start
= i + 1
            current
_surplus
= 0
    
    return
start
if total
_surplus
>= 0
else
-1
```

## Additional Practice Problems

### Easy
1. Implement Queue using Array
2. Implement Queue using Two Stacks
3. Print First Negative Integer in Every Window of Size k
4. Find First Circular Tour to Visit All Petrol Pumps (already covered)
5. Queue using Two Stacks
6. Reverse a Queue
7. Keep track of maximum element in a queue
8. Interleave first half of queue with second half
9. Generate binary numbers (already covered)
10. LRU Cache implementation

### Medium
1. Maximum of Minimum for Every Window Size (already covered)
2. Reorganize String (already covered)
3. Task Scheduler (already covered)
4. Design Hanoi
5. The Celebrity Problem
6. Sliding Window Problem
7. Minimum Time Required to Rot
8. Diesel Pump Problem
9. Flood Fill Algorithm
10. Rotten Oranges Problem

### Hard
1. Distance of Nearest Cell Having 1 in a Binary Matrix
2. Minimum Time to Rot All Oranges
3. Wales and Hoard Problem
4. Collecting Gold in a Mine
5. Snake and Ladder Problem
6. Jollybee Problem
7. Maximum Sum Rectangle
8. Minimum Cost Path
9. Box Stacking Problem
10. Maximum Profit Job Scheduling

## Summary
Queues are fundamental data structures that excel in scenarios requiring First-In-First-Out (FIFO) behavior. Mastering queue-based problems is crucial for technical interviews as they test your ability to recognize when a problem fits the queue paradigm and apply appropriate queue-based solutions.

Key patterns to remember:
- **FIFO Processing**: Elements processed in order of arrival
- **Breadth-First Search**: Level-by-level traversal of graphs/trees
- **Sliding Window**: Fixed-size window processing with efficient updates
- **Resource Allocation**: Managing shared resources in order of request
- **Rate Limiting**: Tracking recent events within time windows
- **Buffering**: Temporary storage for asynchronous data transfer
- **Event Handling**: Processing events in order of occurrence
- **Simulation**: Modeling real-world systems with waiting lines

When solving queue problems, always consider:
1. Whether the problem involves FIFO behavior
2. What information needs to be stored in each queue element
3. How to efficiently retrieve required information (sometimes requiring auxiliary data structures)
4. Edge cases: empty queue, single element, full queue (for bounded queues), all same elements
5. Time and space complexity optimization
6. Whether to use array-based (circular) or linked-list-based implementation based on requirements

Common real-world applications of queues include:
- Process scheduling in operating systems
- Print spooling and job scheduling
- Network packet routing and buffering
- Call center systems and customer service lines
- Asynchronous I/O operations in high-performance applications
- Message queues in distributed systems
- Event handling in graphical user interfaces
- Simulation of real-world systems (traffic, manufacturing, telecommunications)
- Algorithm implementations (BFS, level order traversal, sliding window problems)

By practicing these problems and understanding the underlying patterns, you'll develop the intuition needed to quickly recognize when a queue-based approach is appropriate and implement efficient solutions.