# Time and Space Complexity Analysis

Understanding time and space complexity is crucial for analyzing and comparing algorithms. This helps us predict how an algorithm will perform as the input size grows.

## Why Complexity Analysis Matters

- **Predict Performance**: Understand how runtime/memory usage grows with input size
- **Compare Algorithms**: Choose the most efficient solution for a problem
- **Identify Bottlenecks**: Spot parts of code that need optimization
- **Interview Essential**: Fundamental topic in technical interviews

## Asymptotic Notations

### Big O Notation (O) - Upper Bound
Describes the worst-case scenario of an algorithm's growth rate.

**Examples:**
- O(1): Constant time - Accessing array element by index
- O(log n): Logarithmic time - Binary search
- O(n): Linear time - Linear search, iterating through array
- O(n log n): Linearithmic time - Merge sort, Quick sort (average)
- O(n²): Quadratic time - Bubble sort, nested loops
- O(2^n): Exponential time - Recursive Fibonacci (naive)
- O(n!): Factorial time - Traveling salesman (brute force)

### Big Omega Notation (Ω) - Lower Bound
Describes the best-case scenario.

### Big Theta Notation (Θ) - Tight Bound
Describes when upper and lower bounds are the same (average case).

## Common Time Complexities

| Complexity | Name | Example |
|------------|------|---------|
| O(1) | Constant | Array lookup, hash table access |
| O(log n) | Logarithmic | Binary search, tree operations |
| O(n) | Linear | Linear search, array traversal |
| O(n log n) | Linearithmic | Merge sort, heap sort |
| O(n²) | Quadratic | Bubble sort, selection sort |
| O(n³) | Cubic | Matrix multiplication (naive) |
| O(2^n) | Exponential | Subset generation, TSP |
| O(n!) | Factorial | Permutations, traveling salesman |

## Space Complexity

Space complexity measures the amount of memory an algorithm uses relative to input size.

**Components:**
- **Input Space**: Memory required to store the input
- **Auxiliary Space**: Extra space used by the algorithm (excluding input)
- **Total Space**: Input Space + Auxiliary Space

**Examples:**
- O(1) Space: Swapping two variables
- O(n) Space: Creating a copy of an array
- O(log n) Space: Recursive binary search (call stack)
- O(n) Space: Merge sort (temporary arrays)

## Analysis Techniques

### 1. Counting Operations
Count how many times each line executes as a function of input size.

### 2. Recurrence Relations
For recursive algorithms, express time as T(n) = aT(n/b) + f(n) and solve using:
- Substitution method
- Recursion tree method
- Master theorem

### 3. Amortized Analysis
Average time per operation over a sequence of operations (useful for dynamic arrays).

## Common Algorithms and Their Complexities

### Sorting Algorithms
| Algorithm | Best | Average | Worst | Space |
|-----------|------|---------|-------|-------|
| Bubble Sort | O(n) | O(n²) | O(n²) | O(1) |
| Selection Sort | O(n²) | O(n²) | O(n²) | O(1) |
| Insertion Sort | O(n) | O(n²) | O(n²) | O(1) |
| Merge Sort | O(n log n) | O(n log n) | O(n log n) | O(n) |
| Quick Sort | O(n log n) | O(n log n) | O(n²) | O(log n) |
| Heap Sort | O(n log n) | O(n log n) | O(n log n) | O(1) |

### Search Algorithms
| Algorithm | Time | Space | Notes |
|-----------|------|-------|-------|
| Linear Search | O(n) | O(1) | Unsorted arrays |
| Binary Search | O(log n) | O(1) | Sorted arrays |
| Hash Table Lookup | O(1) avg | O(n) | With good hash function |

### Graph Algorithms
| Algorithm | Time | Space | Use Case |
|-----------|------|-------|----------|
| BFS/DFS | O(V+E) | O(V) | Graph traversal |
| Dijkstra's | O(E log V) | O(V) | Shortest path (weighted) |
| Bellman-Ford | O(VE) | O(V) | Shortest path (negative weights) |
| Floyd-Warshall | O(V³) | O(V²) | All pairs shortest path |
| Kruskal's | O(E log E) | O(V) | MST (Union-Find) |
| Prim's | O(E log V) | O(V) | MST (Priority Queue) |

## Practical Tips

### For Iterative Algorithms:
1. Single loop: O(n)
2. Nested loops: O(n^k) where k = nesting level
3. Loop with halving/doubling: O(log n)
4. Loop with constant work inside: O(n)

### For Recursive Algorithms:
1. Draw recursion tree to visualize work at each level
2. Use Master Theorem when applicable: T(n) = aT(n/b) + f(n)
3. Consider memoization for overlapping subproblems

### Optimization Strategies:
1. **Reduce nested loops**: Can often be improved with better data structures
2. **Use hash tables**: For O(1) lookups instead of O(n) scans
3. **Precompute results**: Trade space for time (prefix sums, DP tables)
4. **Early termination**: Break loops when possible
5. **Bit manipulation**: For certain problems, can reduce complexity

## Common Mistakes

1. **Ignoring constants**: O(2n) is still O(n), but constants matter in practice
2. **Confusing best/worst/average case**: Always specify which you're analyzing
3. **Forgetting space complexity**: Especially important in memory-constrained environments
4. **Overlooking hidden loops**: Library functions might have their own complexity
5. **Misapplying Big O**: It describes growth rate, not exact timing

## Exercises

1. **Analyze the following code**:
```python
def example(arr):
    total = 0  # O(1)
    for i in range(len(arr)):  # O(n)
        for j in range(i, len(arr)):  # O(n-i) on average
            total += arr[i] * arr[j]  # O(1)
    return total
```
What's the time complexity?

2. **Compare these two approaches** for finding duplicates in an array:
   - Approach 1: Nested loops (O(n²) time, O(1) space)
   - Approach 2: Hash set (O(n) time, O(n) space)
   When would you prefer each?

3. **Analyze the space complexity** of recursive Fibonacci:
```python
def fib(n):
    if n <= 1:
        return n
    return fib(n-1) + fib(n-2)
```

## Resources

- **Books**: "Introduction to Algorithms" by CLRS (Chapter 3: Growth of Functions)
- **Courses**: MIT 6.006 Introduction to Algorithms, Stanford CS161
- **Practice**: LeetCode problems tagged with "binary search", "sorting", "dynamic programming"
- **Tools**: Online Big-O calculators, complexity visualizers

Remember: The goal isn't just to memorize complexities, but to develop intuition for how algorithms scale and how to improve them when needed.
