# Algorithms Flashcards

Q&A flashcards covering essential algorithms for coding interviews.

---

## Sorting Algorithms

### Card 1: Comparison Sort Complexities

**Q:** What are the time and space complexities of common comparison sorts?

**A:**

| Algorithm | Best | Average | Worst | Space | Stable |
|-----------|------|---------|-------|-------|--------|
| Bubble Sort | O(n) | O(n²) | O(n²) | O(1) | Yes |
| Selection Sort | O(n²) | O(n²) | O(n²) | O(1) | No |
| Insertion Sort | O(n) | O(n²) | O(n²) | O(1) | Yes |
| Merge Sort | O(n log n) | O(n log n) | O(n log n) | O(n) | Yes |
| Quick Sort | O(n log n) | O(n log n) | O(n²) | O(log n) | No |
| Heap Sort | O(n log n) | O(n log n) | O(n log n) | O(1) | No |

**Lower bound for comparison sorts:** Ω(n log n)

---

### Card 2: Quick Sort

**Q:** How does Quick Sort work and why can it degrade to O(n²)?

**A:**

**Algorithm:**
1. Choose pivot (first, last, random, or median)
2. Partition: elements < pivot go left, > pivot go right
3. Recursively sort left and right partitions

**O(n²) happens when:**
- Array is already sorted
- Pivot is always min or max
- All elements equal

**Optimizations:**
- Random pivot selection
- Median-of-three pivot
- Switch to insertion sort for small arrays

---

### Card 3: Merge Sort

**Q:** What are the advantages and disadvantages of Merge Sort?

**A:**

**Advantages:**
- Guaranteed O(n log n)
- Stable sort
- Good for linked lists
- Parallelizable

**Disadvantages:**
- O(n) extra space
- Not in-place
- Slower than Quick Sort in practice (cache)

**Best for:** Linked lists, external sorting, stable sort needed

---

## Searching Algorithms

### Card 4: Binary Search

**Q:** What are the prerequisites and variations of Binary Search?

**A:**

**Prerequisites:**
- Array must be sorted
- Random access available

**Variations:**
```python
# Standard: Find exact value
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

# Lower bound: First element >= target
def lower_bound(arr, target):
    left, right = 0, len(arr)
    while left < right:
        mid = (left + right) // 2
        if arr[mid] < target:
            left = mid + 1
        else:
            right = mid
    return left
```

---

### Card 5: Binary Search on Answer

**Q:** When do you use Binary Search on Answer?

**A:** When the answer space is monotonic (if x works, x+1 works or vice versa).

**Template:**
```python
def binary_search_answer(low, high):
    while low < high:
        mid = (low + high) // 2
        if is_valid(mid):
            high = mid  # or low = mid + 1
        else:
            low = mid + 1  # or high = mid
    return low
```

**Examples:**
- Minimum capacity to ship packages
- Minimum speed to arrive on time
- Koko eating bananas

---

## Graph Algorithms

### Card 6: BFS

**Q:** When do you use BFS and what does it find?

**A:**

**Use BFS for:**
- Shortest path in unweighted graph
- Level-order traversal
- Finding connected components
- Bipartite checking

**Template:**
```python
from collections import deque

def bfs(graph, start):
    visited = {start}
    queue = deque([start])
    while queue:
        node = queue.popleft()
        for neighbor in graph[node]:
            if neighbor not in visited:
                visited.add(neighbor)
                queue.append(neighbor)
```

**Time:** O(V+E) | **Space:** O(V)

---

### Card 7: DFS

**Q:** When do you use DFS and what does it find?

**A:**

**Use DFS for:**
- Path finding
- Cycle detection
- Topological sort
- Connected components
- Solving mazes

**Template:**
```python
def dfs(graph, node, visited=None):
    if visited is None:
        visited = set()
    visited.add(node)
    for neighbor in graph[node]:
        if neighbor not in visited:
            dfs(graph, neighbor, visited)
```

**Time:** O(V+E) | **Space:** O(V)

---

### Card 8: Dijkstra's Algorithm

**Q:** When do you use Dijkstra's and what's its complexity?

**A:**

**Use when:** Finding shortest paths in weighted graph with non-negative weights.

**Algorithm:**
1. Initialize distances: source = 0, all others = ∞
2. Use min-priority queue
3. Extract min distance node
4. Update distances to neighbors
5. Repeat until queue empty

**Complexity:**
- With binary heap: O((V+E) log V)
- With Fibonacci heap: O(E + V log V)

---

### Card 9: Topological Sort

**Q:** What is topological sort and when is it used?

**A:** Linear ordering of vertices such that for every directed edge u→v, u comes before v.

**Use cases:**
- Task scheduling with dependencies
- Course prerequisites
- Build systems
- Spreadsheet formula evaluation

**Methods:**
1. **Kahn's Algorithm (BFS)** - Remove nodes with no incoming edges
2. **DFS** - Reverse of finishing times

---

### Card 10: Union-Find

**Q:** What problems does Union-Find solve?

**A:**

**Problems:**
- Dynamic connectivity
- Cycle detection in undirected graph
- Kruskal's MST algorithm
- Finding connected components

**Operations:**
- `find(x)`: Find root of x
- `union(x, y)`: Merge sets containing x and y

**Optimizations:**
- Path compression
- Union by rank/size

---

## Dynamic Programming

### Card 11: DP Basics

**Q:** What are the two main approaches to DP?

**A:**

**Top-Down (Memoization):**
- Start from main problem
- Recursively solve subproblems
- Cache results

**Bottom-Up (Tabulation):**
- Start from smallest subproblems
- Build up to main problem
- Usually more space efficient

**When to use DP:**
- Optimal substructure
- Overlapping subproblems
- Counting problems
- Optimization problems

---

### Card 12: Knapsack Problem

**Q:** What are the different knapsack variants?

**A:**

**0/1 Knapsack:**
```python
def knapsack(weights, values, capacity):
    n = len(weights)
    dp = [[0] * (capacity + 1) for _ in range(n + 1)]
    for i in range(1, n + 1):
        for w in range(1, capacity + 1):
            if weights[i-1] <= w:
                dp[i][w] = max(
                    dp[i-1][w],
                    dp[i-1][w-weights[i-1]] + values[i-1]
                )
            else:
                dp[i][w] = dp[i-1][w]
    return dp[n][capacity]
```

**Variants:**
- Unbounded: Can take unlimited items
- Bounded: Limited quantity of each item
- Fractional: Can take fractions (greedy)

---

### Card 13: Longest Common Subsequence

**Q:** How do you find the LCS of two strings?

**A:**

```python
def lcs(s1, s2):
    m, n = len(s1), len(s2)
    dp = [[0] * (n + 1) for _ in range(m + 1)]
    
    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if s1[i-1] == s2[j-1]:
                dp[i][j] = dp[i-1][j-1] + 1
            else:
                dp[i][j] = max(dp[i-1][j], dp[i][j-1])
    
    return dp[m][n]
```

**Time:** O(mn) | **Space:** O(mn)

**Variants:** Edit distance, Longest palindromic subsequence

---

### Card 14: Coin Change

**Q:** How do you solve the coin change problem?

**A:**

**Minimum coins to make amount:**
```python
def coin_change(coins, amount):
    dp = [float('inf')] * (amount + 1)
    dp[0] = 0
    
    for coin in coins:
        for x in range(coin, amount + 1):
            dp[x] = min(dp[x], dp[x - coin] + 1)
    
    return dp[amount] if dp[amount] != float('inf') else -1
```

**Time:** O(amount * len(coins))

**Variants:**
- Number of ways to make amount
- Limited coins

---

### Card 15: DP Patterns

**Q:** What are common DP patterns to recognize?

**A:**

| Pattern | Examples |
|---------|----------|
| Linear | Climbing stairs, House robber |
| Grid | Unique paths, Min path sum |
| Subsequence | LCS, LIS, Edit distance |
| Knapsack | Partition equal subset |
| String | Palindrome, Word break |
| Tree | Diameter, Max path sum |
| Interval | Matrix chain, Burst balloons |

---

## Greedy Algorithms

### Card 16: Greedy Approach

**Q:** When should you use a greedy approach?

**A:**

**Use greedy when:**
- Greedy choice property: Local optimal leads to global optimal
- Optimal substructure: Problem contains subproblems

**Classic problems:**
- Activity selection
- Huffman coding
- Fractional knapsack
- Minimum spanning tree (Kruskal's, Prim's)

**Caution:** Greedy doesn't always give optimal solution!

---

### Card 17: Activity Selection

**Q:** How does the activity selection algorithm work?

**A:**

**Problem:** Select maximum non-overlapping activities.

**Algorithm:**
1. Sort activities by finish time
2. Select first activity
3. For each remaining activity:
   - If start time ≥ last selected finish time
   - Select it

```python
def activity_selection(activities):
    activities.sort(key=lambda x: x[1])  # Sort by finish
    selected = [activities[0]]
    for act in activities[1:]:
        if act[0] >= selected[-1][1]:
            selected.append(act)
    return selected
```

**Time:** O(n log n)

---

## String Algorithms

### Card 18: KMP Algorithm

**Q:** What is the KMP algorithm and why is it efficient?

**A:**

**Problem:** Pattern searching in text.

**Naive:** O(mn) - checks every position
**KMP:** O(m+n) - uses failure function

**Key idea:** When mismatch occurs, use precomputed info to skip characters.

**Failure function:** Longest proper prefix that is also suffix.

---

### Card 19: Rabin-Karp Algorithm

**Q:** How does Rabin-Karp algorithm work?

**A:**

**Idea:** Use rolling hash to compare pattern with substrings.

```python
def rabin_karp(text, pattern):
    n, m = len(text), len(pattern)
    pattern_hash = hash(pattern)
    
    for i in range(n - m + 1):
        if hash(text[i:i+m]) == pattern_hash:
            if text[i:i+m] == pattern:
                return i
    return -1
```

**Average:** O(n+m) | **Worst:** O(nm) (with hash collisions)

---

## Bit Manipulation

### Card 20: Bit Operations

**Q:** What are common bit manipulation operations?

**A:**

| Operation | Code | Description |
|-----------|------|-------------|
| Set bit i | `x \| (1 << i)` | Turn on bit |
| Clear bit i | `x & ~(1 << i)` | Turn off bit |
| Toggle bit i | `x ^ (1 << i)` | Flip bit |
| Check bit i | `(x >> i) & 1` | Get bit value |
| Clear LSB | `x & (x-1)` | Remove rightmost 1 |
| Is power of 2 | `x & (x-1) == 0` | Single bit set |

---

## Complexity Analysis

### Card 21: Big O Notation

**Q:** What does O(1), O(log n), O(n), O(n log n), O(n²) mean?

**A:**

| Notation | Name | Example |
|----------|------|---------|
| O(1) | Constant | Array access, hash lookup |
| O(log n) | Logarithmic | Binary search |
| O(n) | Linear | Single loop |
| O(n log n) | Linearithmic | Merge sort |
| O(n²) | Quadratic | Nested loops |
| O(2ⁿ) | Exponential | Subset generation |
| O(n!) | Factorial | Permutations |

---

### Card 22: Space Complexity

**Q:** How do you analyze space complexity?

**A:**

**Count additional space used:**

```python
# O(1) space
def sum_array(arr):
    total = 0
    for x in arr:
        total += x
    return total

# O(n) space
def create_copy(arr):
    return arr[:]

# O(n) space (recursion stack)
def recursive_sum(n):
    if n == 0:
        return 0
    return n + recursive_sum(n-1)
```

**Note:** Input space usually not counted.

---

## Pattern Recognition

### Card 23: Two Pointer

**Q:** When do you use the two pointer technique?

**A:**

**Use when:**
- Searching in sorted array
- Palindrome checking
- Pair with target sum
- Container with most water

**Template:**
```python
def two_pointer(arr):
    left, right = 0, len(arr) - 1
    while left < right:
        current = calculate(arr, left, right)
        if current == target:
            return [left, right]
        elif condition:
            left += 1
        else:
            right -= 1
```

---

### Card 24: Sliding Window

**Q:** When do you use the sliding window technique?

**A:**

**Use when:**
- Contiguous subarray/substring
- Fixed or variable window size
- Maximum/minimum sum/length

**Template:**
```python
def sliding_window(arr, k):
    window = arr[:k]
    result = process(window)
    
    for i in range(k, len(arr)):
        window.remove(arr[i-k])
        window.append(arr[i])
        result = update(result, window)
    
    return result
```

---

### Card 25: Fast & Slow Pointers

**Q:** When do you use fast and slow pointers?

**A:**

**Use when:**
- Cycle detection in linked list
- Finding middle of linked list
- Detecting happy number

**Template:**
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

---

## Quick Reference

### Algorithm Selection Guide

| Problem Type | Algorithm |
|--------------|-----------|
| Shortest path (unweighted) | BFS |
| Shortest path (weighted, non-negative) | Dijkstra's |
| Shortest path (weighted, negative) | Bellman-Ford |
| Minimum spanning tree | Kruskal's or Prim's |
| Topological order | Kahn's or DFS |
| Connected components | BFS/DFS/Union-Find |
| Cycle detection | DFS/Union-Find/Floyd's |
| String matching | KMP/Rabin-Karp |
| Range queries | Segment Tree/Fenwick Tree |
| Optimization with subproblems | Dynamic Programming |
