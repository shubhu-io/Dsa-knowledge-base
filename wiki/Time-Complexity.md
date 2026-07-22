# Time Complexity

Understanding Big O notation and how to analyze the efficiency of algorithms is
essential for writing performant code and succeeding in technical interviews.

## Overview

Time complexity measures how the runtime of an algorithm grows as the input size
increases. It is expressed using Big O notation, which describes the upper bound
of the growth rate.

Big O notation focuses on the dominant term and ignores constants. For example,
O(3n^2 + 5n + 10) simplifies to O(n^2) because the quadratic term dominates
as n grows large.

---

## Key Concepts

### What Big O Measures

Big O describes the **worst-case** growth rate of an algorithm. It tells you how
the number of operations scales with input size, not the actual runtime in seconds.

### Why Constants Are Dropped

Big O describes the **shape** of the growth curve, not the exact count. A constant
factor (like 2x or 10x) does not change the fundamental growth pattern. O(2n) and
O(n) have the same growth rate.

### Why Lower-Order Terms Are Dropped

As n becomes very large, higher-order terms dominate. In O(n^2 + n), the n^2 term
grows much faster than n, so the result is O(n^2).

---

## Common Time Complexities

### O(1) — Constant Time

The runtime does not depend on the input size. Every input takes the same time.

```python
def get_first_element(arr):
    """O(1) - Direct index access."""
    return arr[0]

def hash_lookup(hash_map, key):
    """O(1) average - Hash table lookup."""
    return hash_map.get(key)
```

**Examples:** Array index access, hash table lookup, stack push/pop.

### O(log n) — Logarithmic Time

The problem size is halved with each step. Very efficient for large inputs.

```python
def binary_search(arr, target):
    """O(log n) - Halving the search space each step."""
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
```

**Examples:** Binary search, balanced BST operations, exponentiation by squaring.

### O(n) — Linear Time

The runtime grows proportionally with the input size. Each element is processed
once.

```python
def find_max(arr):
    """O(n) - Must check every element."""
    maximum = arr[0]
    for element in arr[1:]:
        if element > maximum:
            maximum = element
    return maximum
```

**Examples:** Linear search, finding min/max, counting occurrences, array traversal.

### O(n log n) — Linearithmic Time

Combines linear and logarithmic growth. Common in efficient sorting algorithms.

```python
def merge_sort(arr):
    """O(n log n) - log n levels, O(n) work per level."""
    if len(arr) <= 1:
        return arr
    mid = len(arr) // 2
    left = merge_sort(arr[:mid])
    right = merge_sort(arr[mid:])
    return merge(left, right)
```

**Examples:** Merge sort, heap sort, Timsort (Python's built-in sort).

### O(n^2) — Quadratic Time

The runtime grows with the square of the input size. Common in nested loops.

```python
def bubble_sort(arr):
    """O(n^2) - Two nested loops over the array."""
    n = len(arr)
    for i in range(n):
        for j in range(0, n - i - 1):
            if arr[j] > arr[j + 1]:
                arr[j], arr[j + 1] = arr[j + 1], arr[j]
    return arr
```

**Examples:** Bubble sort, selection sort, insertion sort, comparing all pairs.

### O(2^n) — Exponential Time

The runtime doubles with each additional input element. Becomes impractical fast.

```python
def fibonacci(n):
    """O(2^n) - Each call branches into two recursive calls."""
    if n <= 1:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)
```

**Examples:** Naive recursion (fibonacci, subsets), brute force on subsets.

---

## Space Complexity

Space complexity measures how much **extra memory** an algorithm uses relative to
the input size. It is also expressed in Big O notation.

### Common Space Complexities

| Space Complexity | Description                    | Example                         |
|------------------|--------------------------------|---------------------------------|
| O(1)             | Constant extra space           | Two pointers, in-place swap     |
| O(n)             | Linear extra space             | Creating a copy of the array    |
| O(n)             | Linear (recursive call stack)  | DFS on a linear chain           |
| O(log n)         | Logarithmic stack space        | Recursive binary search         |
| O(n^2)           | Quadratic space                | 2D matrix, adjacency matrix    |

### In-Place vs Out-of-Place

An **in-place** algorithm uses O(1) extra space (or O(log n) for recursion stacks).
An **out-of-place** algorithm uses additional space proportional to the input.

```python
# In-place: O(1) extra space
def swap_elements(arr, i, j):
    arr[i], arr[j] = arr[j], arr[i]

# Out-of-place: O(n) extra space
def reverse_array(arr):
    return arr[::-1]  # Creates a new array
```

---

## How to Analyze Code Complexity

### Step-by-Step Analysis

1. **Identify loops**: A single loop over n elements is O(n).
2. **Check nesting**: Nested loops multiply complexities (O(n) * O(n) = O(n^2)).
3. **Look for halving**: If the problem size halves each step, it is O(log n).
4. **Count recursive calls**: Each level of recursion adds to the complexity.
5. **Add sequential parts**: Sequential code blocks add their complexities.
6. **Keep the dominant term**: Drop constants and lower-order terms.

### Example Analysis

```python
def complex_function(arr):
    # O(n) - single loop
    for i in range(len(arr)):
        pass

    # O(n^2) - nested loops
    for i in range(len(arr)):
        for j in range(len(arr)):
            pass

    # Total: O(n) + O(n^2) = O(n^2)
```

---

## Quick Reference Table

| Complexity     | Name            | n=10     | n=100     | n=1000     | Example Algorithm       |
|----------------|-----------------|----------|-----------|------------|-------------------------|
| O(1)           | Constant        | 1        | 1         | 1          | Array access            |
| O(log n)       | Logarithmic     | 3        | 7         | 10         | Binary search           |
| O(n)           | Linear          | 10       | 100       | 1,000      | Linear search           |
| O(n log n)     | Linearithmic    | 33       | 664       | 9,966      | Merge sort              |
| O(n^2)         | Quadratic       | 100      | 10,000    | 1,000,000  | Bubble sort             |
| O(n^3)         | Cubic           | 1,000    | 1,000,000 | 10^9       | Matrix multiplication   |
| O(2^n)         | Exponential     | 1,024    | 10^30     | 10^301     | Naive recursion         |
| O(n!)          | Factorial       | 3,628,800| Huge      | Huge       | Permutations            |

---

## Common Interview Questions

1. **Array vs linked list access time?**
   Array: O(1) direct index. Linked list: O(n) traversal from head.

2. **Why is O(n log n) the lower bound for comparison sorts?**
   Each comparison gives one bit; sorting n elements needs log2(n!) = O(n log n).

3. **Can an algorithm be O(n) time but O(n) space?**
   Yes. Creating a copy of an array is O(n) time and O(n) space.

4. **What is amortized time complexity?**
   Average time per operation over a sequence. Dynamic array push is O(1) amortized.

5. **How do you handle varying input patterns?**
   Analyze best, average, worst cases separately. Clarify which case is needed.

---

## See Also

- [[Algorithms]] — Applying complexity analysis to specific algorithms
- [[Data-Structures]] — Time complexities of data structure operations
- [[Problem-Solving]] — Using complexity to guide optimization
- [[Getting-Started]] — Start learning from the beginning

---

> Full content: [03-Time-Complexity](../03-Time-Complexity/)
