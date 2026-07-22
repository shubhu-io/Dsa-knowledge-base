# Pattern Recognition in Problem Solving

Recognizing patterns is the fastest way to solve problems. Most interview problems map to 15-20 core patterns.

## Why Patterns Matter

```
Problem: "Find the longest substring with at most k distinct characters"
         |
         v
Pattern Recognition: Sliding Window + HashMap
         |
         v
Solution: O(n) time, O(k) space
```

Without pattern recognition, you solve from scratch. With it, you recognize the blueprint and adapt.

---

## Core Pattern Catalog

### Pattern 1: Sliding Window

**Signature**: Contiguous subarray/substring with a constraint

```
Keywords: "subarray", "substring", "window", "contiguous", 
          "maximum/minimum length", "at most k"
```

```python
# Template
def sliding_window(s, condition):
    left = 0
    result = 0
    window = {}
    for right in range(len(s)):
        # Expand: add s[right]
        window[s[right]] = window.get(s[right], 0) + 1
        # Shrink: while condition violated
        while not_valid(window, condition):
            window[s[left]] -= 1
            if window[s[left]] == 0:
                del window[s[left]]
            left += 1
        # Update result
        result = max(result, right - left + 1)
    return result
```

**Problems**: Longest Substring Without Repeating Characters, Minimum Window Substring, Longest Substring with K Distinct Characters, Permutation in String

---

### Pattern 2: Two Pointers

**Signature**: Sorted array, pair/triplet with target sum

```
Keywords: "sorted array", "pair sum", "three sum", "container",
          "rain water", "palindrome"
```

```python
# Template for sorted array
def two_pointers(arr, target):
    left, right = 0, len(arr) - 1
    while left < right:
        current = arr[left] + arr[right]
        if current == target:
            return [left, right]
        elif current < target:
            left += 1    # Need bigger sum
        else:
            right -= 1   # Need smaller sum
```

**Problems**: Two Sum II, 3Sum, Container With Most Water, Valid Palindrome, Remove Duplicates

---

### Pattern 3: Fast & Slow Pointers

**Signature**: Linked list cycle, middle element, happy number

```
Keywords: "cycle", "middle of list", "happy number", "loop",
          "circular", "linked list"
```

```python
# Cycle detection (Floyd's)
def has_cycle(head):
    slow = fast = head
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next
        if slow == fast:
            return True
    return False

# Find cycle start
def detect_cycle_start(head):
    slow = fast = head
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next
        if slow == fast:
            # Reset one pointer to head
            slow = head
            while slow != fast:
                slow = slow.next
                fast = fast.next
            return slow
    return None
```

**Problems**: Linked List Cycle, Happy Number, Middle of Linked List, Find the Duplicate Number

---

### Pattern 4: Binary Search

**Signature**: Sorted data, search space optimization

```
Keywords: "sorted", "find minimum/maximum", "search space",
          "capacity", "allocation", "minimum maximum"
```

```python
# Template
def binary_search(arr, target):
    lo, hi = 0, len(arr) - 1
    while lo <= hi:
        mid = lo + (hi - lo) // 2
        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            lo = mid + 1
        else:
            hi = mid - 1
    return -1

# Binary search on answer
def search_answer(arr):
    lo, hi = MIN_POSSIBLE, MAX_POSSIBLE
    while lo < hi:
        mid = lo + (hi - lo) // 2
        if is_valid(mid):    # Can we achieve mid?
            hi = mid         # Try smaller
        else:
            lo = mid + 1     # Need bigger
    return lo
```

**Problems**: Search in Rotated Array, Koko Eating Bananas, Capacity to Ship Packages, Median of Two Sorted Arrays

---

### Pattern 5: Merge Intervals

**Signature**: Overlapping ranges, insert/merge intervals

```
Keywords: "intervals", "overlap", "merge", "insert",
          "non-overlapping", "meeting rooms"
```

```python
def merge_intervals(intervals):
    intervals.sort(key=lambda x: x[0])
    merged = [intervals[0]]
    for start, end in intervals[1:]:
        if start <= merged[-1][1]:
            merged[-1][1] = max(merged[-1][1], end)
        else:
            merged.append([start, end])
    return merged
```

**Problems**: Merge Intervals, Insert Interval, Meeting Rooms II, Non-overlapping Intervals, Minimum Platforms

---

### Pattern 6: Tree Traversal (DFS/BFS)

**Signature**: Binary tree operations, level-order, path problems

```
Keywords: "binary tree", "level order", "depth", "path",
          "root to leaf", "zigzag", "serialize"
```

```python
# BFS - Level Order
from collections import deque
def level_order(root):
    if not root:
        return []
    result, queue = [], deque([root])
    while queue:
        level = []
        for _ in range(len(queue)):
            node = queue.popleft()
            level.append(node.val)
            if node.left:
                queue.append(node.left)
            if node.right:
                queue.append(node.right)
        result.append(level)
    return result

# DFS - Preorder
def preorder(root):
    if not root:
        return []
    return [root.val] + preorder(root.left) + preorder(root.right)
```

**Problems**: Binary Tree Level Order, Validate BST, Maximum Depth, Path Sum, Serialize/Deserialize Tree

---

### Pattern 7: Graph Traversal (BFS/DFS)

**Signature**: Connected components, shortest path, cycle detection

```
Keywords: "graph", "connected", "island", "shortest path",
          "topological sort", "clone", "course schedule"
```

```python
# BFS shortest path
def bfs_shortest_path(graph, start, end):
    queue = deque([(start, 0)])
    visited = {start}
    while queue:
        node, dist = queue.popleft()
        if node == end:
            return dist
        for neighbor in graph[node]:
            if neighbor not in visited:
                visited.add(neighbor)
                queue.append((neighbor, dist + 1))
    return -1

# DFS to count islands
def num_islands(grid):
    count = 0
    for i in range(len(grid)):
        for j in range(len(grid[0])):
            if grid[i][j] == '1':
                dfs(grid, i, j)
                count += 1
    return count
```

**Problems**: Number of Islands, Clone Graph, Course Schedule, Word Ladder, Pacific Atlantic Water Flow

---

### Pattern 8: Dynamic Programming (Linear)

**Signature**: Sequence, optimize over choices at each step

```
Keywords: "maximum/minimum", "number of ways", "can reach",
          "climbing stairs", "house robber", "decode ways"
```

```python
# 1D DP Template
def dp_linear(arr):
    n = len(arr)
    dp = [0] * n
    dp[0] = base_case_0
    if n > 1:
        dp[1] = base_case_1
    for i in range(2, n):
        dp[i] = dp[i-1] + arr[i]   # or min/max with other choices
    return dp[-1]
```

**Problems**: Climbing Stairs, House Robber, Decode Ways, Maximum Product Subarray, Word Break

---

### Pattern 9: Dynamic Programming (2D / Knapsack)

**Signature**: Two sequences, items with choices

```
Keywords: "two strings", "subsequence", "knapsack", "items",
          "include/exclude", "coin change", "partition"
```

```python
# 2D DP Template
def dp_2d(text1, text2):
    m, n = len(text1), len(text2)
    dp = [[0] * (n + 1) for _ in range(m + 1)]
    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if text1[i-1] == text2[j-1]:
                dp[i][j] = dp[i-1][j-1] + 1
            else:
                dp[i][j] = max(dp[i-1][j], dp[i][j-1])
    return dp[m][n]
```

**Problems**: Longest Common Subsequence, Edit Distance, 0/1 Knapsack, Coin Change, Unique Paths

---

### Pattern 10: Backtracking

**Signature**: Generate all combinations/permutations, constraint satisfaction

```
Keywords: "all combinations", "permutations", "generate",
          "n-queens", "sudoku", "word search", "partition"
```

```python
def backtrack(candidates, path, result):
    if is_solution(path):
        result.append(path[:])
        return
    for i in range(len(candidates)):
        if is_valid(candidates[i], path):
            path.append(candidates[i])
            backtrack(candidates[i+1:], path, result)
            path.pop()
```

**Problems**: Subsets, Permutations, Combination Sum, N-Queens, Sudoku Solver, Word Search

---

### Pattern 11: Heap / Priority Queue

**Signature**: Top-K, median, merge sorted streams

```
Keywords: "top k", "kth largest", "median", "merge k sorted",
          "reorganize string", "task scheduler"
```

```python
import heapq

# Top K elements
def top_k(nums, k):
    return heapq.nlargest(k, nums)

# Kth largest element
def kth_largest(nums, k):
    min_heap = []
    for num in nums:
        heapq.heappush(min_heap, num)
        if len(min_heap) > k:
            heapq.heappop(min_heap)
    return min_heap[0]
```

**Problems**: Kth Largest Element, Top K Frequent Elements, Merge K Sorted Lists, Find Median from Data Stream

---

### Pattern 12: Union-Find

**Signature**: Connected components, dynamic connectivity

```
Keywords: "connected components", "merge groups", "redundant connection",
          "accounts merge", "is similar to"
```

```python
class UnionFind:
    def __init__(self, n):
        self.parent = list(range(n))
        self.rank = [0] * n

    def find(self, x):
        if self.parent[x] != x:
            self.parent[x] = self.find(self.parent[x])  # Path compression
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

**Problems**: Number of Provinces, Redundant Connection, Accounts Merge, Smallest String With Swaps

---

### Pattern 13: Trie (Prefix Tree)

**Signature**: Prefix matching, word autocomplete, dictionary operations

```
Keywords: "prefix", "autocomplete", "dictionary", "word search",
          "boggle", "replace words"
```

```python
class TrieNode:
    def __init__(self):
        self.children = {}
        self.is_end = False

class Trie:
    def __init__(self):
        self.root = TrieNode()

    def insert(self, word):
        node = self.root
        for char in word:
            if char not in node.children:
                node.children[char] = TrieNode()
            node = node.children[char]
        node.is_end = True

    def search(self, word):
        node = self.root
        for char in word:
            if char not in node.children:
                return False
            node = node.children[char]
        return node.is_end
```

**Problems**: Implement Trie, Word Search II, Design Add and Search Words, Longest Word in Dictionary

---

### Pattern 14: Monotonic Stack

**Signature**: Next greater/smaller element, stock span

```
Keywords: "next greater", "next smaller", "stock span", 
          "daily temperatures", "trapping rain water"
```

```python
def next_greater_element(arr):
    n = len(arr)
    result = [-1] * n
    stack = []  # stores indices
    for i in range(n):
        while stack and arr[stack[-1]] < arr[i]:
            result[stack.pop()] = arr[i]
        stack.append(i)
    return result
```

**Problems**: Next Greater Element, Daily Temperatures, Trapping Rain Water, Largest Rectangle in Histogram

---

### Pattern 15: Topological Sort

**Signature**: Ordering with dependencies, course scheduling

```
Keywords: "prerequisites", "dependencies", "order", "schedule",
          "task ordering", "alien dictionary"
```

```python
from collections import deque

def topological_sort(num_courses, prerequisites):
    in_degree = [0] * num_courses
    graph = [[] for _ in range(num_courses)]
    for dest, src in prerequisites:
        graph[src].append(dest)
        in_degree[dest] += 1

    queue = deque([i for i in range(num_courses) if in_degree[i] == 0])
    order = []
    while queue:
        node = queue.popleft()
        order.append(node)
        for neighbor in graph[node]:
            in_degree[neighbor] -= 1
            if in_number[neighbor] == 0:
                queue.append(neighbor)

    return order if len(order) == num_courses else []
```

**Problems**: Course Schedule, Course Schedule II, Alien Dictionary, Parallel Courses

---

## Pattern Recognition Flowchart

```
Read the problem
      |
      v
Identify the DATA STRUCTURE
      |
      +-- Array/String -----> Is it sorted?
      |                         |        |
      |                        Yes       No
      |                         |        |
      |                    Two Pointers  Can you sort?
      |                    Binary Search    |       |
      |                    Sliding Window  Yes      No
      |                                    |       |
      |                              Sort+Apply  HashMap
      |
      +-- Linked List -----> Cycle? Fast/Slow Pointers
      |                      Reverse? In-place pointer manipulation
      |
      +-- Tree -----------> Traversal (DFS/BFS)
      |                     Level order (BFS)
      |                     Path problems (DFS + backtracking)
      |
      +-- Graph ----------> Connectivity? Union-Find
      |                     Shortest path? BFS/Dijkstra
      |                     Ordering? Topological Sort
      |                     All paths? DFS + Backtracking
      |
      +-- String ---------> Prefix matching? Trie
      |                     Substring? Sliding Window
      |                     Matching? DP
      |
      v
Look for KEYWORDS
      |
      +-- "Maximum/Minimum" -------> DP or Greedy
      +-- "Number of ways" --------> DP
      +-- "All combinations" ------> Backtracking
      +-- "Top K" ----------------> Heap
      +-- "Next greater" ---------> Monotonic Stack
      +-- "Connected" ------------> BFS/DFS/Union-Find
```

---

## Quick Reference Table

| Pattern | Time | Space | When to Use |
|---------|------|-------|-------------|
| Sliding Window | O(n) | O(k) | Subarray/substring with constraint |
| Two Pointers | O(n) | O(1) | Sorted array pair problems |
| Binary Search | O(log n) | O(1) | Sorted or searchable space |
| BFS | O(V+E) | O(V) | Shortest path, level order |
| DFS | O(V+E) | O(V) | Exhaustive search, paths |
| Union-Find | O(n*α(n)) | O(n) | Dynamic connectivity |
| Trie | O(L) | O(N*L) | Prefix operations |
| Monotonic Stack | O(n) | O(n) | Next greater/smaller element |
| Topological Sort | O(V+E) | O(V) | Dependency ordering |
| Heap | O(n log k) | O(k) | Top-K, median maintenance |

---

## Practice Strategy

1. **Master 5 patterns first**: Sliding Window, Two Pointers, Binary Search, BFS/DFS, DP
2. **Group problems by pattern**: Solve 3-5 problems of each pattern consecutively
3. **Flashcard the signatures**: Know the keywords that signal each pattern
4. **Mix patterns**: Advanced problems combine 2-3 patterns

## Resources

- NeetCode 150 (organized by pattern)
- LeetCode Study Plans (Data Structure I/II, Algorithm I/II)
- "Grokking the Coding Interview" (pattern-based learning)
- Sean Prashad's LeetCode patterns (github.com/seanprashad/leetcode-patterns)
