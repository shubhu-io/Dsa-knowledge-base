# Algorithms

A comprehensive guide to algorithm categories, paradigms, and techniques essential for
computer science and technical interviews.

## Overview

Algorithms are step-by-step procedures for solving problems or performing computations.
Understanding algorithm design and analysis is fundamental to writing efficient software
and succeeding in technical interviews.

This page covers the major algorithm categories, common design paradigms, and provides
code examples for frequently used algorithms.

---

## Key Concepts

### Algorithm Categories

1. **Sorting** — Arranging elements in a specific order
2. **Searching** — Finding elements in a collection
3. **Graph** — Traversing and analyzing network structures
4. **Dynamic Programming** — Solving problems with overlapping subproblems
5. **Greedy** — Making locally optimal choices at each step
6. **Divide and Conquer** — Breaking problems into smaller subproblems
7. **Backtracking** — Exploring all possibilities and pruning invalid paths
8. **String** — Processing and manipulating text data

### Design Paradigms

Understanding paradigms helps you recognize which approach fits a given problem.

- **Brute Force**: Try all possibilities. Simple but often slow.
- **Divide and Conquer**: Split the problem, solve recursively, combine results.
- **Greedy**: Choose the best option locally, hope for global optimum.
- **Dynamic Programming**: Cache results of subproblems to avoid recomputation.
- **Backtracking**: Build solutions incrementally, undo when a dead end is reached.

---

## Sorting Algorithm Comparison

| Algorithm        | Best       | Average     | Worst       | Space     | Stable | Method      |
|------------------|------------|-------------|-------------|-----------|--------|-------------|
| Bubble Sort      | O(n)       | O(n^2)     | O(n^2)     | O(1)      | Yes    | Exchange    |
| Selection Sort   | O(n^2)    | O(n^2)     | O(n^2)     | O(1)      | No     | Selection   |
| Insertion Sort   | O(n)       | O(n^2)     | O(n^2)     | O(1)      | Yes    | Insertion   |
| Merge Sort       | O(n log n) | O(n log n) | O(n log n) | O(n)      | Yes    | Divide      |
| Quick Sort       | O(n log n) | O(n log n) | O(n^2)     | O(log n)  | No     | Divide      |
| Heap Sort        | O(n log n) | O(n log n) | O(n log n) | O(1)      | No     | Selection   |
| Counting Sort    | O(n + k)   | O(n + k)   | O(n + k)   | O(k)      | Yes    | Non-compare |
| Radix Sort       | O(nk)      | O(nk)      | O(nk)      | O(n + k)  | Yes    | Non-compare |

---

## Code Example: Binary Search

```python
"""
Binary Search Implementation
Efficiently finds a target in a sorted array.
Time Complexity: O(log n)
Space Complexity: O(1) iterative, O(log n) recursive
"""


def binary_search_iterative(arr, target):
    """
    Iterative binary search.
    Returns the index of target, or -1 if not found.
    """
    left, right = 0, len(arr) - 1

    while left <= right:
        mid = left + (right - left) // 2  # Avoids integer overflow

        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            left = mid + 1
        else:
            right = mid - 1

    return -1


def binary_search_recursive(arr, target, left=0, right=None):
    """
    Recursive binary search.
    Returns the index of target, or -1 if not found.
    """
    if right is None:
        right = len(arr) - 1

    if left > right:
        return -1

    mid = left + (right - left) // 2

    if arr[mid] == target:
        return mid
    elif arr[mid] < target:
        return binary_search_recursive(arr, target, mid + 1, right)
    else:
        return binary_search_recursive(arr, target, left, mid - 1)


def main():
    sorted_array = [2, 5, 8, 12, 16, 23, 38, 45, 56, 72, 91]
    target = 23

    result = binary_search_iterative(sorted_array, target)
    print(f"Iterative: Found {target} at index {result}")  # 5

    result = binary_search_recursive(sorted_array, target)
    print(f"Recursive: Found {target} at index {result}")  # 5

    result = binary_search_iterative(sorted_array, 99)
    print(f"Search for 99: {result}")  # -1


if __name__ == "__main__":
    main()
```

---

## Code Example: Merge Sort

```python
"""
Merge Sort Implementation
Stable, divide-and-conquer sorting algorithm.
Time Complexity: O(n log n) in all cases
Space Complexity: O(n)
"""


def merge_sort(arr):
    """Sort array using merge sort. Returns new sorted array."""
    if len(arr) <= 1:
        return arr

    mid = len(arr) // 2
    left = merge_sort(arr[:mid])
    right = merge_sort(arr[mid:])

    return merge(left, right)


def merge(left, right):
    """Merge two sorted arrays into one sorted array."""
    result = []
    i = j = 0

    while i < len(left) and j < len(right):
        if left[i] <= right[j]:
            result.append(left[i])
            i += 1
        else:
            result.append(right[j])
            j += 1

    # Append remaining elements
    result.extend(left[i:])
    result.extend(right[j:])
    return result


def main():
    unsorted = [38, 27, 43, 3, 9, 82, 10]
    print(f"Unsorted: {unsorted}")
    print(f"Sorted:   {merge_sort(unsorted)}")


if __name__ == "__main__":
    main()
```

---

## Algorithm Design Paradigms

### Divide and Conquer

Break a problem into smaller subproblems, solve each independently, and combine
the results. Common in merge sort, quick sort, and binary search.

**Key insight**: If subproblems can be solved independently, consider this paradigm.

### Dynamic Programming

Solve problems with overlapping subproblems and optimal substructure. Store results
to avoid recomputation. Used in longest common subsequence, knapsack, and more.

**Key insight**: If the same subproblem appears multiple times, cache its result.

### Greedy Algorithms

Make the locally optimal choice at each step. Used in activity selection, Huffman
coding, and Dijkstra's shortest path.

**Key insight**: If a locally optimal choice leads to a globally optimal solution,
use greedy.

### Backtracking

Explore all valid configurations by building candidates incrementally and pruning
invalid paths. Used in N-Queens, Sudoku, and permutation generation.

**Key insight**: If you need to explore all valid configurations, use backtracking.

---

## Common Interview Questions

1. **Implement merge sort and explain its time complexity.**
   O(n log n) in all cases: log n levels of recursion, O(n) merge per level.

2. **When would you choose quick sort over merge sort?**
   Quick sort has better cache performance and sorts in-place. Merge sort
   is preferred when stability or guaranteed O(n log n) is needed.

3. **Explain the difference between BFS and DFS.**
   BFS explores level by level using a queue; DFS explores depth first
   using a stack/recursion. BFS finds shortest paths; DFS detects cycles.

4. **What makes a problem suitable for dynamic programming?**
   Overlapping subproblems (same subproblem solved multiple times) and
   optimal substructure (optimal solution contains optimal subproblems).

5. **How do you determine which algorithm paradigm to use?**
   Overlapping subproblems -> DP, independent subproblems -> divide and
   conquer, locally optimal choices -> greedy, exhaustive search -> backtracking.

---

## See Also

- [[Data-Structures]] — The structures these algorithms operate on
- [[Time-Complexity]] — Analyzing algorithm performance
- [[Problem-Solving]] — Frameworks for approaching algorithm problems
- [[Getting-Started]] — Recommended learning paths

---

> Full content: [05-Algorithms](../05-Algorithms/)
