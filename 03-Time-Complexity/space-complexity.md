# Space Complexity Analysis

Understanding how much memory your algorithm needs beyond the input.

## What is Space Complexity?

Space complexity measures the total memory an algorithm uses relative to input size. This includes input storage plus auxiliary (extra) space.

```
Total Space = Input Space + Auxiliary Space

Input Space:     Memory to store the input (usually fixed)
Auxiliary Space: Extra memory used by the algorithm
Space Complexity: Focus on Auxiliary Space
```

## Space Complexity Notation

Same as time complexity, we use Big O notation:

- **O(1)** — Constant: Fixed memory regardless of input
- **O(n)** — Linear: Memory grows proportionally with input
- **O(n^2)** — Quadratic: Memory grows quadratically
- **O(log n)** — Logarithmic: Memory grows slowly with input

---

## O(1) Space — Constant Extra Memory

```python
def swap(arr, i, j):
    arr[i], arr[j] = arr[j], arr[i]

def find_max(arr):
    max_val = arr[0]
    for num in arr:
        if num > max_val:
            max_val = num
    return max_val

def two_pointer_sum(arr, target):
    arr.sort()
    left, right = 0, len(arr) - 1
    while left < right:
        s = arr[left] + arr[right]
        if s == target:
            return [left, right]
        elif s < target:
            left += 1
        else:
            right -= 1
    return [-1, -1]
```
Only uses a fixed number of variables. No extra arrays or data structures.

---

## O(n) Space — Linear Extra Memory

```python
def create_prefix_sum(arr):
    prefix = [0] * (len(arr) + 1)  # O(n) extra space
    for i in range(len(arr)):
        prefix[i + 1] = prefix[i] + arr[i]
    return prefix

def count_frequencies(arr):
    freq = {}                          # O(n) extra space
    for num in arr:
        freq[num] = freq.get(num, 0) + 1
    return freq

def copy_array(arr):
    new_arr = arr[:]                   # O(n) extra space
    return new_arr
```

---

## O(log n) Space — Logarithmic Memory

```python
def binary_search_recursive(arr, lo, hi, target):
    if lo > hi:
        return -1
    mid = (lo + hi) // 2
    if arr[mid] == target:
        return mid
    elif arr[mid] < target:
        return binary_search_recursive(arr, mid + 1, hi, target)
    else:
        return binary_search_recursive(arr, lo, mid - 1, target)
# Call stack depth: O(log n)
```

```
Call stack visualization for n=16:

binary_search(arr, 0, 15)
  binary_search(arr, 0, 7)
    binary_search(arr, 0, 3)
      binary_search(arr, 0, 1)
        binary_search(arr, 0, 0)
        
Stack depth: log2(16) = 4 levels
```

---

## Analyzing Space Complexity

### Rule 1: Variables = O(1)

```python
def sum_array(arr):
    total = 0          # O(1)
    count = 0          # O(1)
    for num in arr:
        total += num
        count += 1
    return total / count
# Space: O(1)
```

### Rule 2: New Array = O(n)

```python
def double_elements(arr):
    doubled = [x * 2 for x in arr]    # O(n) space
    return doubled
# Space: O(n)
```

### Rule 3: Recursion = O(depth)

```python
def factorial(n):
    if n <= 1:
        return 1
    return n * factorial(n - 1)
# Stack depth: n
# Space: O(n)
```

### Rule 4: Nested Data Structures = Multiply

```python
def create_matrix(n):
    matrix = [[0] * n for _ in range(n)]   # O(n^2) space
    return matrix
# Space: O(n^2)
```

### Rule 5: Hash Maps/Sets = O(unique elements)

```python
def unique_elements(arr):
    return list(set(arr))  # O(unique elements) space
# Space: O(n) worst case, O(1) if bounded by constant
```

---

## Space Complexity of Data Structures

| Data Structure | Space | Notes |
|---------------|-------|-------|
| Array | O(n) | n elements |
| Linked List | O(n) | n nodes + n pointers |
| Stack | O(n) | n elements |
| Queue | O(n) | n elements |
| Hash Table | O(n) | n entries (may have load factor overhead) |
| Binary Tree | O(n) | n nodes |
| BST | O(n) | n nodes |
| Heap | O(n) | n elements |
| Graph (adj list) | O(V + E) | vertices + edges |
| Graph (adj matrix) | O(V^2) | V x V matrix |

---

## Space-Time Tradeoffs

### Example 1: Two Sum

```python
# Approach 1: No extra space (besides input)
def two_sum_sort(arr, target):
    arr.sort()                              # O(1) extra
    lo, hi = 0, len(arr) - 1                # O(1)
    while lo < hi:
        s = arr[lo] + arr[hi]
        if s == target: return [lo, hi]
        elif s < target: lo += 1
        else: hi -= 1
    return [-1, -1]
# Time: O(n log n), Space: O(1)

# Approach 2: Extra space for speed
def two_sum_hash(arr, target):
    seen = {}                               # O(n) extra
    for i, num in enumerate(arr):
        if target - num in seen:
            return [seen[target - num], i]
        seen[num] = i
    return [-1, -1]
# Time: O(n), Space: O(n)
```

| Approach | Time | Space | When to Use |
|----------|------|-------|-------------|
| Sort + Two Pointers | O(n log n) | O(1) | Memory constrained |
| Hash Map | O(n) | O(n) | Speed is priority |

### Example 2: Fibonacci

```python
# Approach 1: Naive recursion
def fib_naive(n):
    if n <= 1: return n
    return fib_naive(n-1) + fib_naive(n-2)
# Time: O(2^n), Space: O(n) call stack

# Approach 2: Memoization (top-down DP)
def fib_memo(n, memo={}):
    if n in memo: return memo[n]
    if n <= 1: return n
    memo[n] = fib_memo(n-1, memo) + fib_memo(n-2, memo)
    return memo[n]
# Time: O(n), Space: O(n) memo + O(n) stack

# Approach 3: Iterative (bottom-up DP)
def fib_iterative(n):
    if n <= 1: return n
    a, b = 0, 1
    for _ in range(2, n + 1):
        a, b = b, a + b
    return b
# Time: O(n), Space: O(1)

# Approach 4: Matrix exponentiation
def fib_matrix(n):
    def multiply(A, B):
        return [[A[0][0]*B[0][0] + A[0][1]*B[1][0],
                 A[0][0]*B[0][1] + A[0][1]*B[1][1]],
                [A[1][0]*B[0][0] + A[1][1]*B[1][0],
                 A[1][0]*B[0][1] + A[1][1]*B[1][1]]]

    def power(mat, p):
        result = [[1, 0], [0, 1]]
        while p:
            if p % 2 == 1:
                result = multiply(result, mat)
            mat = multiply(mat, mat)
            p //= 2
        return result

    if n <= 1: return n
    M = [[1, 1], [1, 0]]
    return power(M, n)[0][1]
# Time: O(log n), Space: O(1) (no recursion)
```

| Approach | Time | Space | Notes |
|----------|------|-------|-------|
| Naive Recursion | O(2^n) | O(n) | Exponential time |
| Memoization | O(n) | O(n) | Space for memo table |
| Iterative DP | O(n) | O(1) | Optimal space |
| Matrix Exponent | O(log n) | O(1) | Optimal time + space |

---

## In-Place Algorithms

In-place algorithms use O(1) extra space by modifying the input directly.

### Reversing an Array In-Place
```python
def reverse_array(arr):
    left, right = 0, len(arr) - 1
    while left < right:
        arr[left], arr[right] = arr[right], arr[left]
        left += 1
        right -= 1
# Space: O(1)
```

### In-Place Merge Sort (Complex)
```python
# Typically merge sort needs O(n) extra space
# In-place variants exist but are complex
# For interviews, O(n) space merge sort is standard
```

### Dutch National Flag (3-way Partition)
```python
def sort_colors(arr):
    lo, mid, hi = 0, 0, len(arr) - 1
    while mid <= hi:
        if arr[mid] == 0:
            arr[lo], arr[mid] = arr[mid], arr[lo]
            lo += 1; mid += 1
        elif arr[mid] == 1:
            mid += 1
        else:
            arr[mid], arr[hi] = arr[hi], arr[mid]
            hi -= 1
# Space: O(1), Time: O(n)
```

---

## Stack Space Analysis

### Linear Recursion
```python
def linear_recursion(n):
    if n <= 0: return
    linear_recursion(n - 1)
# Stack space: O(n)
```

### Binary Recursion
```python
def binary_recursion(n):
    if n <= 0: return
    binary_recursion(n - 1)
    binary_recursion(n - 1)
# Stack space: O(n) — max depth, not total calls
```

### Tail Recursion
```python
def tail_recursive(n, acc=0):
    if n <= 0: return acc
    return tail_recursive(n - 1, acc + n)
# Stack space: O(n) in Python (no tail call optimization)
# Some languages optimize to O(1)
```

---

## Memory Limits in Competitive Programming

| Platform | Memory Limit | Typical Complexity |
|----------|-------------|-------------------|
| LeetCode | 256-512 MB | O(n) or O(n^2) |
| Codeforces | 256 MB | O(n) or O(n log n) |
| AtCoder | 1024 MB | O(n^2) sometimes OK |
| HackerRank | 512 MB | O(n) |

### Quick Memory Calculation
```
1 integer  = 4 bytes (32-bit) or 8 bytes (64-bit)
1 string of length L = ~L bytes + overhead
1 array of n integers = ~4n bytes
1 hash map with n entries = ~32n-64n bytes (Python)
1 node of linked list = ~40 bytes (Python)
```

For n = 10^6:
- Integer array: ~4 MB
- Python list: ~8 MB
- Hash map: ~32-64 MB

---

## Space Optimization Techniques

### 1. Rolling Variables
```python
# Instead of storing entire DP table:
def fibonacci(n):
    a, b = 0, 1           # Only keep last two values
    for _ in range(n):
        a, b = b, a + b
    return a
# Space: O(n) -> O(1)
```

### 2. Bit Manipulation for Sets
```python
# Instead of a boolean array for subsets:
def subset_exists(arr, target):
    bitset = 1            # Bit i represents if sum i is possible
    for num in arr:
        bitset |= bitset << num
    return bool(bitset & (1 << target))
# Space: O(max_sum / 8) bytes
```

### 3. Path Compression in Union-Find
```python
def find(x):
    if parent[x] != x:
        parent[x] = find(parent[x])  # Path compression
    return parent[x]
# Amortized near-constant time, no extra space
```

### 4. Morris Traversal (Tree)
```python
# Inorder traversal without stack or recursion
def morris_inorder(root):
    current = root
    while current:
        if not current.left:
            yield current.val
            current = current.right
        else:
            predecessor = current.left
            while predecessor.right and predecessor.right != current:
                predecessor = predecessor.right
            if not predecessor.right:
                predecessor.right = current
                current = current.left
            else:
                predecessor.right = None
                yield current.val
                current = current.right
# Space: O(1) — modifies tree temporarily, restores after
```

---

## Space Complexity Decision Guide

```
Do you need to store results?
  |                |
  Yes              No
  |                |
  How many?        Can you compute on the fly?
  |                |          |
  Up to n         Yes         No
  |                |          |
  Use array      Stream     Use array
  O(n)           O(1)
  |
  More than n?
  |
  Use hash map/set
  O(n)
```

## Resources

- "Introduction to Algorithms" (CLRS) Chapter 17: Amortized Analysis
- "Algorithm Design Manual" by Skiena, Chapter 8
- Space complexity analysis practice on LeetCode
