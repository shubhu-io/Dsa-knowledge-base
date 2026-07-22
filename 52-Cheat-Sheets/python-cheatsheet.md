# Python Cheat Sheet for DSA

Quick reference for Python data structures, algorithms, and common patterns.

---

## Variables and Data Types

```python
# Basic types
x = 10              # int
y = 3.14            # float
name = "Alice"       # str
is_valid = True     # bool
nothing = None      # NoneType

# Type checking
type(x)             # <class 'int'>
isinstance(x, int)  # True
```

---

## Built-in Data Structures

### Lists

```python
# Creation
arr = [1, 2, 3, 4, 5]
empty = []
matrix = [[0]*3 for _ in range(3)]

# Operations
arr.append(6)           # Add to end
arr.insert(0, 0)        # Insert at index
arr.pop()               # Remove and return last
arr.pop(0)              # Remove and return at index
arr.remove(3)           # Remove first occurrence
arr.sort()              # Sort in place
arr.reverse()           # Reverse in place
arr.index(4)            # Find index of value
arr.count(2)            # Count occurrences
arr.extend([7, 8])      # Add multiple elements
arr.copy()              # Shallow copy

# Slicing
arr[1:3]                # [2, 3]
arr[:2]                 # [1, 2]
arr[2:]                 # [3, 4, 5]
arr[::2]                # [1, 3, 5] (every 2nd)
arr[::-1]               # [5, 4, 3, 2, 1] (reverse)

# List comprehension
squares = [x**2 for x in range(10)]
evens = [x for x in range(10) if x % 2 == 0]
```

### Dictionaries

```python
# Creation
d = {"name": "Alice", "age": 30}
empty = {}
from_pairs = dict([("a", 1), ("b", 2)])
default = dict.fromkeys(["x", "y"], 0)

# Operations
d["name"]               # Get value
d.get("name", "N/A")   # Get with default
d["email"] = "a@b.com" # Add/update
d.update({"age": 31})  # Update multiple
d.pop("age")           # Remove and return
d.popitem()            # Remove last item
d.keys()               # View keys
d.values()             # View values
d.items()              # View key-value pairs

# Dictionary comprehension
square_map = {x: x**2 for x in range(5)}
```

### Sets

```python
# Creation
s = {1, 2, 3}
empty = set()
from_list = set([1, 2, 2, 3])  # {1, 2, 3}

# Operations
s.add(4)               # Add element
s.remove(1)            # Remove (raises error if not found)
s.discard(1)           # Remove (no error if not found)
s.pop()                # Remove and return arbitrary element
s.union({4, 5})        # {1, 2, 3, 4, 5}
s.intersection({2, 3, 4})  # {2, 3}
s.difference({2, 3})   # {1}
s.symmetric_difference({3, 4})  # {1, 2, 4}

# Set comprehension
even_set = {x for x in range(10) if x % 2 == 0}
```

### Tuples

```python
# Creation
t = (1, 2, 3)
single = (1,)          # Note the comma
empty = ()

# Operations
t[0]                   # Access by index
t[1:3]                 # Slicing
len(t)                 # Length

# Unpacking
a, b, c = t
first, *rest = (1, 2, 3, 4)  # first=1, rest=[2,3,4]
```

---

## Strings

```python
# Operations
s = "Hello World"
s.lower()              # "hello world"
s.upper()              # "HELLO WORLD"
s.strip()              # Remove whitespace
s.split()              # ['Hello', 'World']
"-".join(['a','b'])    # "a-b"
s.replace("H", "J")    # "Jello World"
s.find("World")        # 6
s.count("l")           # 2
s.startswith("H")      # True
s.endswith("d")        # True

# String formatting
f"Hello {name}"        # f-string (Python 3.6+)
"Hello {}".format(name)  # format method
```

---

## Stacks and Queues

### Stack (using list)

```python
class Stack:
    def __init__(self):
        self.items = []

    def push(self, item):
        self.items.append(item)

    def pop(self):
        if not self.is_empty():
            return self.items.pop()
        raise IndexError("Stack is empty")

    def peek(self):
        if not self.is_empty():
            return self.items[-1]
        raise IndexError("Stack is empty")

    def is_empty(self):
        return len(self.items) == 0

    def size(self):
        return len(self.items)
```

### Queue (using deque)

```python
from collections import deque

class Queue:
    def __init__(self):
        self.items = deque()

    def enqueue(self, item):
        self.items.append(item)

    def dequeue(self):
        if not self.is_empty():
            return self.items.popleft()
        raise IndexError("Queue is empty")

    def front(self):
        if not self.is_empty():
            return self.items[0]
        raise IndexError("Queue is empty")

    def is_empty(self):
        return len(self.items) == 0

    def size(self):
        return len(self.items)
```

---

## Linked List

```python
class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next

class LinkedList:
    def __init__(self):
        self.head = None

    def add_first(self, val):
        self.head = ListNode(val, self.head)

    def add_last(self, val):
        if not self.head:
            self.head = ListNode(val)
            return
        curr = self.head
        while curr.next:
            curr = curr.next
        curr.next = ListNode(val)

    def remove(self, val):
        dummy = ListNode(0, self.head)
        prev = dummy
        curr = self.head
        while curr:
            if curr.val == val:
                prev.next = curr.next
                break
            prev = curr
            curr = curr.next
        self.head = dummy.next

    def find(self, val):
        curr = self.head
        while curr:
            if curr.val == val:
                return curr
            curr = curr.next
        return None
```

---

## Binary Tree

```python
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

def inorder(root):
    if root:
        yield from inorder(root.left)
        yield root.val
        yield from inorder(root.right)

def preorder(root):
    if root:
        yield root.val
        yield from preorder(root.left)
        yield from preorder(root.right)

def postorder(root):
    if root:
        yield from postorder(root.left)
        yield from postorder(root.right)
        yield root.val
```

---

## Graph

```python
# Adjacency list
graph = {
    'A': ['B', 'C'],
    'B': ['A', 'D'],
    'C': ['A', 'D'],
    'D': ['B', 'C']
}

# BFS
from collections import deque

def bfs(graph, start):
    visited = set([start])
    queue = deque([start])
    result = []
    while queue:
        node = queue.popleft()
        result.append(node)
        for neighbor in graph[node]:
            if neighbor not in visited:
                visited.add(neighbor)
                queue.append(neighbor)
    return result

# DFS (recursive)
def dfs(graph, node, visited=None):
    if visited is None:
        visited = set()
    visited.add(node)
    result = [node]
    for neighbor in graph[node]:
        if neighbor not in visited:
            result.extend(dfs(graph, neighbor, visited))
    return result
```

---

## Sorting Algorithms

```python
# Bubble Sort - O(n²)
def bubble_sort(arr):
    n = len(arr)
    for i in range(n):
        for j in range(0, n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

# Merge Sort - O(n log n)
def merge_sort(arr):
    if len(arr) <= 1:
        return arr
    mid = len(arr) // 2
    left = merge_sort(arr[:mid])
    right = merge_sort(arr[mid:])
    return merge(left, right)

def merge(left, right):
    result = []
    i = j = 0
    while i < len(left) and j < len(right):
        if left[i] <= right[j]:
            result.append(left[i])
            i += 1
        else:
            result.append(right[j])
            j += 1
    result.extend(left[i:])
    result.extend(right[j:])
    return result

# Quick Sort - O(n log n) average
def quick_sort(arr):
    if len(arr) <= 1:
        return arr
    pivot = arr[len(arr) // 2]
    left = [x for x in arr if x < pivot]
    middle = [x for x in arr if x == pivot]
    right = [x for x in arr if x > pivot]
    return quick_sort(left) + middle + quick_sort(right)
```

---

## Common Algorithms

```python
# Binary Search - O(log n)
def binary_search(arr, target):
    left, right = 0, len(arr) - 1
    while left <= right:
        mid = (left + right) // 2
        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    return -1

# Two Pointers - Two Sum
def two_sum(arr, target):
    left, right = 0, len(arr) - 1
    while left < right:
        current = arr[left] + arr[right]
        if current == target:
            return [left, right]
        elif current < target:
            left += 1
        else:
            right -= 1
    return []

# Sliding Window - Max Sum
def max_subarray_sum(arr, k):
    window_sum = sum(arr[:k])
    max_sum = window_sum
    for i in range(k, len(arr)):
        window_sum += arr[i] - arr[i-k]
        max_sum = max(max_sum, window_sum)
    return max_sum
```

---

## Important Imports

```python
from collections import deque, defaultdict, Counter, OrderedDict
from heapq import heappush, heappop, heapify
from bisect import bisect_left, bisect_right
from functools import lru_cache
from itertools import combinations, permutations, product
from typing import List, Dict, Set, Optional
import sys
```

---

## Common Patterns

### Memoization

```python
from functools import lru_cache

@lru_cache(maxsize=None)
def fibonacci(n):
    if n <= 1:
        return n
    return fibonacci(n-1) + fibonacci(n-2)
```

### Default Dictionary

```python
from collections import defaultdict

graph = defaultdict(list)
for u, v in edges:
    graph[u].append(v)
```

### Counter

```python
from collections import Counter

words = ["hello", "world", "hello"]
count = Counter(words)  # Counter({'hello': 2, 'world': 1})
```
