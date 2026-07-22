# Data Structures Flashcards

Q&A flashcards covering essential data structures for coding interviews.

---

## Arrays

### Card 1: Array Basics

**Q:** What is an array and what are its key characteristics?

**A:** A contiguous block of memory storing elements of the same type.

- **Access:** O(1) - random access via index
- **Search:** O(n) - linear search
- **Insert/Delete at end:** O(1) amortized
- **Insert/Delete at position:** O(n) - shifting required

**Key Points:**
- Fixed size in most languages (dynamic arrays resize)
- Cache-friendly due to contiguous memory
- No overhead per element

---

### Card 2: Dynamic Array Resizing

**Q:** How does a dynamic array (e.g., Python list, Java ArrayList) handle growth?

**A:** Creates a new, larger array and copies elements.

- Typical growth factor: 2x
- Amortized O(1) for append
- Worst case O(n) for single append when resize needed

**Example:**
```python
# Python list resizing
import sys
lst = []
for i in range(20):
    old_size = sys.getsizeof(lst)
    lst.append(i)
    new_size = sys.getsizeof(lst)
    if old_size != new_size:
        print(f"Size changed: {old_size} -> {new_size}")
```

---

### Card 3: Array vs Linked List

**Q:** When would you use an array vs a linked list?

**A:**

| Array | Linked List |
|-------|-------------|
| O(1) access | O(n) access |
| Better cache locality | No wasted memory |
| Fixed size (or costly resize) | Dynamic size |
| Insert/delete at end O(1) | Insert/delete at head O(1) |

**Use Array when:**
- Random access needed
- Size is known or changes rarely
- Cache performance matters

**Use Linked List when:**
- Frequent insertions/deletions at head
- Size is unknown
- Don't need random access

---

## Linked Lists

### Card 4: Singly Linked List

**Q:** What are the operations and their complexities for a singly linked list?

**A:**

| Operation | Time | Space |
|-----------|------|-------|
| Access by index | O(n) | O(1) |
| Search | O(n) | O(1) |
| Insert at head | O(1) | O(1) |
| Insert at tail | O(n)* | O(1) |
| Delete at head | O(1) | O(1) |
| Delete at tail | O(n) | O(1) |

*O(1) if tail pointer maintained

---

### Card 5: Doubly Linked List

**Q:** What advantage does a doubly linked list have over singly linked?

**A:** Can traverse in both directions.

- Delete from tail: O(1) with tail pointer
- Insert before any node: O(1) with node reference
- More memory per node (prev pointer)
- More complex implementation

**Structure:**
```
null <- [A] <-> [B] <-> [C] -> null
```

---

### Card 6: Detecting a Cycle

**Q:** How do you detect a cycle in a linked list?

**A:** Floyd's Cycle Detection (Tortoise and Hare)

```python
def has_cycle(head):
    slow = fast = head
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next
        if slow == fast:
            return True
    return False
```

**Time:** O(n) | **Space:** O(1)

---

## Stacks

### Card 7: Stack Operations

**Q:** What are the basic stack operations and their complexities?

**A:**

| Operation | Description | Time |
|-----------|-------------|------|
| push | Add to top | O(1) |
| pop | Remove from top | O(1) |
| peek/top | View top element | O(1) |
| isEmpty | Check if empty | O(1) |
| size | Get element count | O(1) |

**LIFO:** Last In, First Out

---

### Card 8: Stack Applications

**Q:** Name 3 real-world applications of stacks.

**A:**

1. **Function call stack** - Managing function calls
2. **Undo/Redo** - Text editors, design tools
3. **Expression evaluation** - Postfix calculations
4. **Browser history** - Back button navigation
5. **Bracket matching** - Syntax validation

---

## Queues

### Card 9: Queue Operations

**Q:** What are the basic queue operations and their complexities?

**A:**

| Operation | Description | Time |
|-----------|-------------|------|
| enqueue | Add to rear | O(1) |
| dequeue | Remove from front | O(1) |
| front | View front element | O(1) |
| isEmpty | Check if empty | O(1) |
| size | Get element count | O(1) |

**FIFO:** First In, First Out

---

### Card 10: Queue Implementations

**Q:** What are different ways to implement a queue?

**A:**

1. **Array (circular)** - Fixed size, wraps around
2. **Linked list** - Dynamic size
3. **Python deque** - Efficient both ends
4. **Two stacks** - Queue using stacks

**Python Implementation:**
```python
from collections import deque

queue = deque()
queue.append(1)      # Enqueue
queue.append(2)
queue.popleft()      # Dequeue -> 1
queue[0]             # Front -> 2
```

---

### Card 11: Priority Queue

**Q:** What is a priority queue and how is it implemented?

**A:** Elements dequeued by priority, not arrival order.

**Implementations:**
| Method | Insert | Extract Min/Max |
|--------|--------|-----------------|
| Unsorted array | O(1) | O(n) |
| Sorted array | O(n) | O(1) |
| Binary heap | O(log n) | O(log n) |
| Fibonacci heap | O(1)* | O(log n) |

*Amortized

**Use cases:** Task scheduling, Dijkstra's algorithm

---

## Hash Tables

### Card 12: Hash Table Basics

**Q:** What is the average and worst case complexity for hash table operations?

**A:**

| Operation | Average | Worst Case |
|-----------|---------|------------|
| Insert | O(1) | O(n) |
| Search | O(1) | O(n) |
| Delete | O(1) | O(n) |

**Worst case occurs with many collisions.**

---

### Card 13: Collision Resolution

**Q:** What are the main strategies for handling hash collisions?

**A:**

1. **Chaining** - Each slot holds a linked list
2. **Open Addressing** - Find next empty slot
   - Linear probing
   - Quadratic probing
   - Double hashing
3. **Cuckoo hashing** - Multiple hash functions
4. **Robin Hood hashing** - Steal from richer slots

**Load factor:** α = n/m (elements/slots)

---

### Card 14: Hash Map Use Cases

**Q:** Name 5 common applications of hash maps.

**A:**

1. **Caching** - LRU cache implementation
2. **Counting** - Frequency of elements
3. **Two-pointer problems** - Two Sum
4. **Anagram detection** - Character frequency
5. **Deduplication** - Remove duplicates

---

## Trees

### Card 15: Binary Tree Traversals

**Q:** What are the three main tree traversal orders?

**A:**

```python
# Inorder: Left, Root, Right
def inorder(root):
    if root:
        inorder(root.left)
        print(root.val)
        inorder(root.right)

# Preorder: Root, Left, Right
def preorder(root):
    if root:
        print(root.val)
        preorder(root.left)
        preorder(root.right)

# Postorder: Left, Right, Root
def postorder(root):
    if root:
        postorder(root.left)
        postorder(root.right)
        print(root.val)
```

**For BST:** Inorder gives sorted order.

---

### Card 16: Binary Search Tree

**Q:** What are the operations and complexities for a BST?

**A:**

| Operation | Average | Worst Case |
|-----------|---------|------------|
| Search | O(log n) | O(n) |
| Insert | O(log n) | O(n) |
| Delete | O(log n) | O(n) |

**Worst case occurs with skewed tree (essentially a linked list).**

**Property:** Left < Root < Right

---

### Card 17: Balanced Trees

**Q:** Why are balanced trees important?

**A:** Guarantee O(log n) operations.

**Types:**
- **AVL Tree** - Strictly balanced (|height diff| ≤ 1)
- **Red-Black Tree** - Approximately balanced
- **B-Tree** - For disk storage
- **B+ Tree** - For databases

---

### Card 18: Heap Operations

**Q:** What are heap operations and their complexities?

**A:**

| Operation | Time |
|-----------|------|
| Find min/max | O(1) |
| Insert | O(log n) |
| Extract min/max | O(log n) |
| Heapify | O(n) |
| Decrease key | O(log n) |

**Use cases:** Priority queue, Heapsort, Dijkstra's

---

### Card 19: Trie

**Q:** What is a trie and when is it used?

**A:** A tree-like data structure for storing strings.

```
       root
      /    \
     a      b
    / \      \
   p   n      a
   |   |      |
   p   d      d
   |   |      |
   l   e      d
   |          |
   e          e
```

**Operations:**
- Insert: O(m) - m = word length
- Search: O(m)
- Prefix search: O(m)

**Use cases:** Autocomplete, spell checkers, IP routing

---

## Heaps

### Card 20: Min Heap vs Max Heap

**Q:** What's the difference between min heap and max heap?

**A:**

**Min Heap:** Parent ≤ Children
- Root is minimum
- Used for min-priority queue

**Max Heap:** Parent ≥ Children
- Root is maximum
- Used for max-priority queue, Heapsort

**Both are complete binary trees.**

---

## Graphs

### Card 21: Graph Representations

**Q:** What are the main ways to represent a graph?

**A:**

| Representation | Space | Edge Check | Iterate Neighbors |
|----------------|-------|------------|-------------------|
| Adjacency Matrix | O(V²) | O(1) | O(V) |
| Adjacency List | O(V+E) | O(degree) | O(degree) |

**Use Matrix when:** Dense graph, need fast edge check
**Use List when:** Sparse graph, memory efficient

---

### Card 22: BFS vs DFS

**Q:** What's the difference between BFS and DFS?

**A:**

| BFS | DFS |
|-----|-----|
| Uses Queue | Uses Stack/Recursion |
| Level by level | Goes deep first |
| Shortest path (unweighted) | May not be shortest |
| O(V+E) time | O(V+E) time |
| O(V) space | O(V) space |

**BFS:** Shortest path, level order, web crawling
**DFS:** Path finding, cycle detection, topological sort

---

## Advanced

### Card 23: Union-Find

**Q:** What is Union-Find and what operations does it support?

**A:** Tracks disjoint sets with near-constant operations.

```python
class UnionFind:
    def __init__(self, n):
        self.parent = list(range(n))
        self.rank = [0] * n
    
    def find(self, x):
        if self.parent[x] != x:
            self.parent[x] = self.find(self.parent[x])
        return self.parent[x]
    
    def union(self, x, y):
        px, py = self.find(x), self.find(y)
        if px == py:
            return False
        if self.rank[px] < self.rank[py]:
            px, py = py, px
        self.parent[py] = px
        if self.rank[px] == self.rank[py]:
            self.rank[px] += 1
        return True
```

**Operations:** Find and Union are O(α(n)) amortized (α = inverse Ackermann)

---

### Card 24: LRU Cache

**Q:** How do you implement an LRU Cache?

**A:** Hash Map + Doubly Linked List

```python
from collections import OrderedDict

class LRUCache:
    def __init__(self, capacity):
        self.cache = OrderedDict()
        self.capacity = capacity
    
    def get(self, key):
        if key in self.cache:
            self.cache.move_to_end(key)
            return self.cache[key]
        return -1
    
    def put(self, key, value):
        if key in self.cache:
            self.cache.move_to_end(key)
        self.cache[key] = value
        if len(self.cache) > self.capacity:
            self.cache.popitem(last=False)
```

**Both operations:** O(1)

---

### Card 25: Segment Tree

**Q:** What is a segment tree and when is it used?

**A:** A binary tree for range queries and updates.

**Operations:**
- Build: O(n)
- Query (range): O(log n)
- Update (point): O(log n)

**Use cases:**
- Range sum/min/max queries
- Range updates
- Problem: 2D range queries

---

## Quick Reference

### Complexity Cheat Sheet

| Data Structure | Access | Search | Insert | Delete |
|----------------|--------|--------|--------|--------|
| Array | O(1) | O(n) | O(n) | O(n) |
| Linked List | O(n) | O(n) | O(1)* | O(1)* |
| Stack | O(n) | O(n) | O(1) | O(1) |
| Queue | O(n) | O(n) | O(1) | O(1) |
| Hash Table | N/A | O(1) | O(1) | O(1) |
| BST | O(log n) | O(log n) | O(log n) | O(log n) |
| Heap | N/A | O(n) | O(log n) | O(log n) |

*At head/tail with pointer
