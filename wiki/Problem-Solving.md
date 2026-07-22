# Problem Solving

A structured approach to solving coding problems, with common patterns and techniques
used in technical interviews and competitive programming.

## Overview

Problem solving is a skill that improves with practice and a systematic approach. Rather
than diving into code immediately, experienced developers follow a framework that leads
to better solutions and fewer bugs.

This page presents a proven 5-step framework, 15 common patterns, and strategies for
optimizing solutions from brute force to efficient.

---

## The 5-Step Problem-Solving Framework

### Step 1: Understand the Problem

Before writing any code, make sure you fully understand what is being asked.

- Read the problem statement at least twice
- Identify the inputs and their constraints
- Determine what the expected output is
- Ask clarifying questions (in interviews)
- Work through 2-3 examples by hand

### Step 2: Identify Patterns

Look for recognizable patterns in the problem. Most coding problems fit one or more
of the 15 common patterns listed below. Matching a problem to a pattern significantly
reduces the time needed to find a solution.

### Step 3: Design a Solution

Start with a brute force approach to ensure correctness, then optimize.

- Write pseudocode before actual code
- Consider edge cases (empty input, single element, large input)
- Think about the data structures needed
- Consider time and space complexity tradeoffs

### Step 4: Implement the Solution

Write clean, readable code. Use meaningful variable names and break the solution
into helper functions when appropriate.

- Start with the core logic
- Handle edge cases explicitly
- Add comments for complex sections only
- Keep functions small and focused

### Step 5: Test and Optimize

Verify your solution works correctly and analyze its efficiency.

- Test with provided examples
- Test edge cases (empty, single element, duplicates, maximum size)
- Trace through the algorithm with small inputs
- Analyze time and space complexity
- Look for further optimizations if needed

---

## 15 Common Problem-Solving Patterns

### 1. Two Pointers

Use two pointers moving through a data structure to find pairs, compare elements,
or partition data. Common in sorted array problems.

**Example:** Two Sum II (sorted array), Valid Palindrome, Remove Duplicates.

### 2. Sliding Window

Maintain a window (subarray/substring) that slides across the data. Efficient for
contiguous subsequence problems.

**Example:** Maximum Sum Subarray of Size K, Longest Substring Without Repeats.

### 3. Fast and Slow Pointers

Use two pointers moving at different speeds. Primarily used in linked list problems
to detect cycles or find middle elements.

**Example:** Linked List Cycle, Happy Number, Middle of Linked List.

### 4. Merge Intervals

Sort intervals by start time and merge overlapping intervals. Useful for scheduling
and range problems.

**Example:** Merge Intervals, Insert Interval, Meeting Rooms II.

### 5. Cyclic Sort

For problems involving arrays with numbers in a given range, sort them by swapping
elements to their correct positions.

**Example:** Find Missing Number, Find All Duplicates, Find Smallest Missing.

### 6. In-place Reversal of Linked List

Reverse a portion or entire linked list by rearranging pointers without extra memory.

**Example:** Reverse Linked List, Reverse Sublist, Reverse Nodes in K-Group.

### 7. Tree Traversal (BFS / DFS)

Traverse tree structures level by level (BFS) or depth first (DFS). Many tree
problems are variations of these traversals.

**Example:** Maximum Depth, Level Order Traversal, Path Sum.

### 8. Two Heaps

Use two priority queues to track medians, or separate elements into two groups
based on a condition.

**Example:** Find Median of Data Stream, Sliding Window Median.

### 9. Subsets

Generate all possible subsets or combinations. Use backtracking or iterative
approaches to explore the power set.

**Example:** Subsets, Permutations, Combination Sum.

### 10. Top K Elements

Use a heap or bucket sort to find the K largest, K smallest, or K most frequent
elements efficiently.

**Example:** Top K Frequent Elements, Kth Largest Element, K Closest Points.

### 11. K-way Merge

Merge multiple sorted arrays or lists using a heap to track the smallest element
across all lists.

**Example:** Merge K Sorted Lists, Kth Smallest in Sorted Matrix.

### 12. Topological Sort

Order elements with dependencies. Used for task scheduling, course prerequisites,
and build systems.

**Example:** Course Schedule, Alien Dictionary, Task Scheduling.

### 13. Bit Manipulation

Use bitwise operations (AND, OR, XOR, shifts) to solve problems efficiently.
XOR is particularly useful for finding unique elements.

**Example:** Single Number, Number of 1 Bits, Reverse Bits.

### 14. Union-Find

Track connected components in a graph. Efficiently merge sets and query connectivity.

**Example:** Number of Provinces, Redundant Connection, Accounts Merge.

### 15. Trie (Prefix Tree)

Store and search strings efficiently by characters. Ideal for autocomplete and
prefix-based lookups.

**Example:** Implement Trie, Word Search II, Autocomplete System.

---

## Brute Force to Optimization

Every solution starts with brute force. The key is knowing how to optimize.

### Optimization Techniques

| Technique               | When to Use                          | Complexity Improvement       |
|-------------------------|--------------------------------------|------------------------------|
| Hash Table Lookup       | Repeated searches                    | O(n) -> O(1) per lookup      |
| Sorting First           | Order-dependent problems             | O(n^2) -> O(n log n)         |
| Binary Search           | Searching in sorted data             | O(n) -> O(log n)             |
| Memoization             | Overlapping subproblems              | Exponential -> Polynomial    |
| Two Pointers            | Pair/triplet in sorted data          | O(n^2) -> O(n)               |
| Sliding Window          | Contiguous subsequence               | O(n^2) -> O(n)               |

### Example: From Brute Force to Optimal (Two Sum)

**Brute Force:** Check every pair. O(n^2) time, O(1) space.

**Optimized:** Use a hash map for O(1) lookups. O(n) time, O(n) space.

```python
def two_sum_optimal(nums, target):
    seen = {}
    for i, num in enumerate(nums):
        complement = target - num
        if complement in seen:
            return [seen[complement], i]
        seen[num] = i
    return []
```

---

## Tips for Breaking Down Problems

- **Identify constraints**: Constraints hint at required time complexity. If n <= 10, O(2^n) might be fine. If n <= 10^6, you need O(n) or O(n log n).
- **Start with examples**: Work through small examples manually to reveal patterns.
- **Draw it out**: Visualize the data structure for graph/tree problems and pointer positions for array problems.
- **Simplify first**: Solve a simpler version, then extend the solution to handle all constraints.
- **Recognize patterns**: Many problems are variations of well-known problems. Practice builds pattern recognition.

---

## Common Interview Questions

1. **How do you approach an unfamiliar problem in an interview?**
   Clarify the problem, work through examples, identify which pattern applies,
   start with brute force, then optimize. Communicate your thought process.

2. **What should you do if your brute force solution is too slow?**
   Analyze where time is spent. Look for repeated work to cache, consider
   sorting or a different data structure, and check if a known pattern applies.

3. **How do you handle edge cases?**
   Consider: empty input, single element, all identical elements, maximum size,
   negative numbers, and boundary values. Test these explicitly.

4. **When should you use a hash map vs a tree?**
   Hash maps give O(1) average lookup but no ordering. Trees give O(log n)
   lookup but maintain sorted order. Choose based on whether you need ordering.

5. **How do you practice effectively?**
   Solve problems in themed batches. Review solutions even for problems you
   solved. Revisit after one week. Time yourself for interview pressure.

---

## See Also

- [[Algorithms]] — Algorithm paradigms and implementations
- [[Data-Structures]] — Choosing the right structure for your pattern
- [[Time-Complexity]] — Analyzing your solution's efficiency
- [[Programming-Languages]] — Implement solutions in your preferred language

---

> Full content: [02-Problem-Solving](../02-Problem-Solving/)
