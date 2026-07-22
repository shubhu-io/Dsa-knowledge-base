# Python Programming

Comprehensive Python guide covering fundamentals, data structures, algorithms,
OOP, and advanced features. Python is the most popular language for data science,
machine learning, and rapid prototyping.

---

## Folder Structure

```
Python/
├── README.md                          # This file
├── python-introduction.md             # Getting started guide (in Data-Structures/)
├── Basics/
│   ├── basics.md                      # Quick reference
│   ├── syntax.md                      # Complete syntax guide
│   ├── file-handling.md               # File I/O operations
│   ├── error-handling.md              # Exception handling
│   ├── comprehensions.md              # List/dict/set comprehensions
│   ├── decorators.md                  # Decorators and closures
│   └── generators.md                  # Generators and iterators
├── OOP/
│   ├── oop.md                         # OOP concepts and theory
│   └── classes.py                     # Example implementations
├── Data-Structures/
│   ├── python-introduction.md         # Python overview and setup
│   ├── LinkedList/                    # Linked list implementations
│   ├── Stack/                         # Stack implementations
│   ├── Tree/                          # Tree implementations
│   ├── HashTable/                     # Hash map implementations
│   ├── Queue/                         # Queue implementations
│   └── Heap/                          # Heap/Priority Queue
├── Algorithms/
│   ├── Array/                         # Array algorithms
│   ├── String/                        # String algorithms
│   ├── Sorting/                       # Sorting algorithms
│   ├── Searching/                     # Searching algorithms
│   ├── Intervals/                     # Interval problems
│   ├── DynamicProgramming/            # DP problems
│   ├── Graph/                         # Graph algorithms
│   └── Recursion/                     # Recursion examples
```

---

## Learning Path

| Step | Topic | Files |
|------|-------|-------|
| 1 | Setup & Basics | `Data-Structures/python-introduction.md` |
| 2 | Syntax Deep Dive | `Basics/syntax.md` |
| 3 | File Handling | `Basics/file-handling.md` |
| 4 | Error Handling | `Basics/error-handling.md` |
| 5 | Comprehensions | `Basics/comprehensions.md` |
| 6 | OOP | `OOP/oop.md` + `OOP/classes.py` |
| 7 | Data Structures | `Data-Structures/` subfolders |
| 8 | Algorithms | `Algorithms/` subfolders |
| 9 | Decorators & Generators | `Basics/decorators.md` + `Basics/generators.md` |

---

## Python Quick Reference

### Data Structures

| Type | Mutable | Ordered | Syntax |
|------|---------|---------|--------|
| `list` | Yes | Yes | `[1, 2, 3]` |
| `tuple` | No | Yes | `(1, 2, 3)` |
| `dict` | Yes | Yes (3.7+) | `{"a": 1}` |
| `set` | Yes | No | `{1, 2, 3}` |
| `frozenset` | No | No | `frozenset([1, 2])` |
| `str` | No | Yes | `"hello"` |

### Time Complexity of Built-in Operations

| Operation | Average Case | Worst Case |
|-----------|-------------|------------|
| `list.append` | O(1) | O(n) |
| `list.pop()` | O(1) | O(1) |
| `list[i]` | O(1) | O(1) |
| `list.insert(0, x)` | O(n) | O(n) |
| `dict[key]` | O(1) | O(n) |
| `set.add` | O(1) | O(n) |
| `x in list` | O(n) | O(n) |
| `x in dict` | O(1) | O(n) |
| `x in set` | O(1) | O(n) |

---

## Common Patterns for Interviews

### Two Pointers

```python
def two_sum_sorted(nums, target):
    left, right = 0, len(nums) - 1
    while left < right:
        curr = nums[left] + nums[right]
        if curr == target:
            return [left, right]
        elif curr < target:
            left += 1
        else:
            right -= 1
    return []
```

### Sliding Window

```python
def max_subarray_sum(nums, k):
    window_sum = sum(nums[:k])
    max_sum = window_sum
    for i in range(k, len(nums)):
        window_sum += nums[i] - nums[i - k]
        max_sum = max(max_sum, window_sum)
    return max_sum
```

### BFS Template

```python
from collections import deque

def bfs(graph, start):
    visited = set([start])
    queue = deque([start])
    while queue:
        node = queue.popleft()
        for neighbor in graph[node]:
            if neighbor not in visited:
                visited.add(neighbor)
                queue.append(neighbor)
```

### DFS Template

```python
def dfs(graph, node, visited=None):
    if visited is None:
        visited = set()
    visited.add(node)
    for neighbor in graph[node]:
        if neighbor not in visited:
            dfs(graph, neighbor, visited)
    return visited
```

---

## See Also

- [[Algorithms]] — Algorithm implementations across languages
- [[Data-Structures]] — Data structure implementations
- [[Time-Complexity]] — Complexity analysis
