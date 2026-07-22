# Time Complexity: A Complete Guide

A thorough explanation of how to analyze and understand the time complexity of algorithms.

## What is Time Complexity?

Time complexity measures how the number of operations in an algorithm grows with the input size. It abstracts away hardware differences and focuses on growth rate.

```
Input size (n):    1     10     100     1,000     10,000
─────────────────────────────────────────────────────────
O(1)               1      1       1         1          1
O(log n)           0      3       7        10         13
O(n)               1     10     100      1,000     10,000
O(n log n)         0     33     664     10,000    130,000
O(n^2)             1    100   10,000 1,000,000         -
O(2^n)             2  1,024        -          -         -
O(n!)              1      -        -          -         -
```

## Big O Notation

Big O describes the **upper bound** of growth rate — the worst case.

```
f(n) = O(g(n)) means:
  There exist constants c > 0 and n0 >= 0 such that:
  f(n) <= c * g(n) for all n >= n0
```

### Intuition
```
If your algorithm does 3n^2 + 5n + 100 operations:
  - Ignore constants: drop the 3
  - Ignore lower terms: drop 5n and 100
  - Result: O(n^2)
```

## All Common Complexities

### O(1) — Constant Time

```python
def get_first(arr):
    return arr[0]

def check_even(n):
    return n % 2 == 0

def hash_lookup(hashmap, key):
    return hashmap[key]  # average case
```
No matter how large the input, the operation takes the same time.

### O(log n) — Logarithmic Time

```python
def binary_search(arr, target):
    lo, hi = 0, len(arr) - 1
    while lo <= hi:
        mid = (lo + hi) // 2
        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            lo = mid + 1
        else:
            hi = mid - 1
    return -1
```
Each step cuts the problem in half. For n = 1,000,000, only ~20 steps needed.

```
n:        1   2   4   8   16   32   64   128   256   512  1024
log n:    0   1   2   3    4    5    6     7     8     9    10
```

### O(n) — Linear Time

```python
def linear_search(arr, target):
    for i in range(len(arr)):
        if arr[i] == target:
            return i
    return -1

def find_max(arr):
    max_val = arr[0]
    for num in arr:
        if num > max_val:
            max_val = num
    return max_val
```
Proportional to input size. Double the input = double the time.

### O(n log n) — Linearithmic Time

```python
def merge_sort(arr):
    if len(arr) <= 1:
        return arr
    mid = len(arr) // 2
    left = merge_sort(arr[:mid])
    right = merge_sort(arr[mid:])
    return merge(left, right)
```
Optimal for comparison-based sorting. Divides and conquers efficiently.

### O(n^2) — Quadratic Time

```python
def bubble_sort(arr):
    n = len(arr)
    for i in range(n):
        for j in range(0, n - i - 1):
            if arr[j] > arr[j + 1]:
                arr[j], arr[j + 1] = arr[j + 1], arr[j]
    return arr
```
Nested loops over the same data. Ten times slower than O(n).

### O(2^n) — Exponential Time

```python
def fibonacci(n):
    if n <= 1:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)
```
Doubles with each additional input. Impractical for n > 40.

```
n:     1   2   3   4    5    10      20         30
2^n:   2   4   8  16   32  1024  1,048,576  1,073,741,824
```

### O(n!) — Factorial Time

```python
def permutations(arr):
    if len(arr) <= 1:
        return [arr]
    result = []
    for i, val in enumerate(arr):
        rest = arr[:i] + arr[i+1:]
        for perm in permutations(rest):
            result.append([val] + perm)
    return result
```
Grows extremely fast. Only feasible for n <= 12.

---

## How to Analyze Code

### Rule 1: Sequential Statements Add

```python
def example(arr):
    a = arr[0]          # O(1)
    b = arr[1]          # O(1)
    return a + b        # O(1)
# Total: O(1) + O(1) + O(1) = O(1)
```

### Rule 2: Nested Loops Multiply

```python
def example(arr):
    n = len(arr)
    for i in range(n):          # n iterations
        for j in range(n):      # n iterations each
            print(arr[j])       # O(1)
# Total: O(n * n * 1) = O(n^2)
```

### Rule 3: Ignore Constants and Lower Terms

```python
def example(arr):
    for i in range(len(arr)):    # O(n)
        print(arr[i])             # O(1)
    for i in range(len(arr)):    # O(n)
        for j in range(len(arr)): # O(n)
            print(i + j)          # O(1)
# Naive: O(n) + O(n^2) = O(n^2 + n)
# Simplified: O(n^2)
```

### Rule 4: Loops That Halve = O(log n)

```python
def example(n):
    i = n
    while i > 1:
        i = i // 2
# i goes: n, n/2, n/4, ..., 2, 1
# Number of steps: log2(n)
# Total: O(log n)
```

### Rule 5: Sequential Loops Add

```python
def example(arr):
    for i in range(len(arr)):   # O(n)
        print(arr[i])

    for i in range(len(arr)):   # O(n)
        print(arr[i] * 2)
# Total: O(n) + O(n) = O(2n) = O(n)
```

### Rule 6: If-Else Takes the Maximum

```python
def example(arr, use_fast):
    if use_fast:
        return arr[0]             # O(1)
    else:
        for i in range(len(arr)):
            if arr[i] == 0:
                return i          # O(n) worst case
    return -1
# Total: O(max(1, n)) = O(n)
```

---

## Analyzing Nested Loops

### Pattern 1: Independent Nested Loops
```python
for i in range(n):
    for j in range(n):
        print(i, j)
# O(n * n) = O(n^2)
```

### Pattern 2: Dependent Nested Loops (Triangular)
```python
for i in range(n):
    for j in range(i, n):
        print(i, j)
# Inner loop runs n-i times: n + (n-1) + ... + 1 = n(n+1)/2
# O(n^2 / 2) = O(n^2)
```

### Pattern 3: Multiplicative Inner Loop
```python
i = 1
while i < n:
    j = 0
    while j < n:
        print(i, j)
        j += 1
    i *= 2
# Outer: log n iterations, Inner: n iterations each
# O(n * log n)
```

### Pattern 4: Decreasing Work
```python
for i in range(n):
    for j in range(n - i):
        print(i, j)
# Same as Pattern 2: O(n^2)
```

---

## Common Time Complexity Cheat Sheet

| Complexity | Name | Example Algorithm |
|-----------|------|------------------|
| O(1) | Constant | Array index access |
| O(log n) | Logarithmic | Binary search |
| O(n) | Linear | Linear search |
| O(n log n) | Linearithmic | Merge sort |
| O(n^2) | Quadratic | Bubble sort |
| O(n^3) | Cubic | Naive matrix multiply |
| O(2^n) | Exponential | Brute force subsets |
| O(n!) | Factorial | Generate permutations |
| O(n^n) | - | Naive string matching |

## Growth Rate Comparison

```
Operations vs Input Size:

n=10:    O(n)=10  O(n^2)=100  O(n^3)=1000  O(2^n)=1024
n=20:    O(n)=20  O(n^2)=400  O(n^3)=8000  O(2^n)=1,048,576
n=100:   O(n)=100 O(n^2)=10K  O(n^3)=1M    O(2^n)=1.27e30

Key insight: At n=100, O(2^n) is already astronomical.
For competitive programming, solutions must be O(n log n) or better
for n up to 10^5-10^6.
```

---

## Analyzing Recursive Algorithms

### Recurrence Relation Method

```python
def divide_and_conquer(arr, n):
    if n <= 1:
        return                    # O(1)
    mid = n // 2                  # O(1)
    divide_and_conquer(arr, mid)   # T(n/2)
    divide_and_conquer(arr + mid, n - mid)  # T(n/2)
    for i in range(n):            # O(n)
        process(arr[i])
```

**Recurrence**: T(n) = 2T(n/2) + O(n)

**Solution using Master Theorem**: O(n log n)

### Recursion Tree Visualization

```
T(n) = 2T(n/2) + n

Level 0:              n                    work = n
                     / \
Level 1:          n/2   n/2                work = n
                  / \   / \
Level 2:      n/4 n/4 n/4 n/4              work = n
                ...
Level k:     1  1  1  1 ... 1              work = n

Total levels: log2(n)
Total work: n * log2(n) = O(n log n)
```

---

## Time Complexity by Algorithm Type

### Sorting Algorithms

| Algorithm | Best | Average | Worst | Stable |
|-----------|------|---------|-------|--------|
| Bubble Sort | O(n) | O(n^2) | O(n^2) | Yes |
| Selection Sort | O(n^2) | O(n^2) | O(n^2) | No |
| Insertion Sort | O(n) | O(n^2) | O(n^2) | Yes |
| Merge Sort | O(n log n) | O(n log n) | O(n log n) | Yes |
| Quick Sort | O(n log n) | O(n log n) | O(n^2) | No |
| Heap Sort | O(n log n) | O(n log n) | O(n log n) | No |
| Counting Sort | O(n+k) | O(n+k) | O(n+k) | Yes |
| Radix Sort | O(d(n+k)) | O(d(n+k)) | O(d(n+k)) | Yes |

### Searching Algorithms

| Algorithm | Time | Space | Requirement |
|-----------|------|-------|------------|
| Linear Search | O(n) | O(1) | None |
| Binary Search | O(log n) | O(1) | Sorted |
| BFS | O(V+E) | O(V) | Graph |
| DFS | O(V+E) | O(V) | Graph |

### Data Structure Operations

| Structure | Access | Search | Insert | Delete |
|-----------|--------|--------|--------|--------|
| Array | O(1) | O(n) | O(n) | O(n) |
| Linked List | O(n) | O(n) | O(1) | O(1) |
| Stack | O(n) | O(n) | O(1) | O(1) |
| Queue | O(n) | O(n) | O(1) | O(1) |
| Hash Table | - | O(1) avg | O(1) avg | O(1) avg |
| BST | O(log n) | O(log n) | O(log n) | O(log n) |
| Heap | - | O(n) | O(log n) | O(log n) |

---

## Time Complexity of Common Operations

| Operation | Python | Java | C++ |
|-----------|--------|------|-----|
| Array access | O(1) | O(1) | O(1) |
| List append | O(1)* | O(1)* | O(1)* |
| List insert at index | O(n) | O(n) | O(n) |
| Dict/HashMap get | O(1) avg | O(1) avg | O(1) avg |
| Dict/HashMap set | O(1) avg | O(1) avg | O(1) avg |
| Set contains | O(1) avg | O(1) avg | O(1) avg |
| String concatenation | O(n) | O(n) | O(n) |
| Sort | O(n log n) | O(n log n) | O(n log n) |

*Amortized constant time

---

## Competitive Programming Rules of Thumb

| Input Size (n) | Required Complexity | Common Techniques |
|----------------|--------------------|--------------------|
| n <= 10 | O(n!) | Backtracking, brute force |
| n <= 20 | O(2^n) | Bitmask DP, subsets |
| n <= 500 | O(n^3) | Floyd-Warshall, DP |
| n <= 5,000 | O(n^2) | Nested loops, DP |
| n <= 10^6 | O(n log n) | Sorting, divide & conquer |
| n <= 10^8 | O(n) | Single pass, two pointers |
| n > 10^8 | O(log n) | Binary search, math |

## Common Pitfalls

1. **Ignoring hidden operations**: `arr.pop()` is O(n) for lists, O(1) for stacks
2. **String concatenation in loops**: `s += char` is O(n^2), use list + join for O(n)
3. **Sorting when not needed**: Sometimes O(n) is better than O(n log n)
4. **Recursion depth**: Python default limit is 1000
5. **Integer overflow**: Python handles big integers, but C++/Java don't

## Resources

- "Introduction to Algorithms" (CLRS) Chapter 3
- MIT 6.006 Lecture 1-2: Asymptotic Analysis
- Big-O Cheat Sheet: https://www.bigocheatsheet.com
