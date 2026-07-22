# LeetCode Problem-Solving Patterns

## Why Patterns Matter

Most LeetCode problems follow recognizable patterns. Learning these patterns helps you:
- Identify the approach faster during interviews
- Apply known techniques to new problems
- Reduce problem-solving time from 30+ minutes to 10-15 minutes
- Build confidence and reduce anxiety

## Core Patterns

### 1. Sliding Window

**When to use**: Substring/subarray problems with contiguous elements

**Template**:
```python
def sliding_window(s):
    left = 0
    window = {}
    result = 0

    for right in range(len(s)):
        # Add element to window
        window[s[right]] = window.get(s[right], 0) + 1

        # Shrink window if needed
        while window_needs_shrink:
            window[s[left]] -= 1
            left += 1

        # Update result
        result = max(result, right - left + 1)

    return result
```

**Example Problems**:
- Longest Substring Without Repeating Characters (3)
- Minimum Window Substring (76)
- Sliding Window Maximum (239)
- Permutation in String (567)

---

### 2. Two Pointers

**When to use**: Sorted arrays, palindrome checks, pair problems

**Template**:
```python
def two_pointers(arr):
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
```

**Example Problems**:
- Two Sum II (167)
- 3Sum (15)
- Container With Most Water (11)
- Valid Palindrome (125)

---

### 3. Binary Search

**When to use**: Sorted arrays, search space reduction, optimization problems

**Template**:
```python
def binary_search(nums, target):
    left, right = 0, len(nums) - 1

    while left <= right:
        mid = left + (right - left) // 2

        if nums[mid] == target:
            return mid
        elif nums[mid] < target:
            left = mid + 1
        else:
            right = mid - 1

    return -1
```

**Example Problems**:
- Binary Search (704)
- Search in Rotated Sorted Array (33)
- Find Minimum in Rotated Sorted Array (153)
- Median of Two Sorted Arrays (4)

---

### 4. Backtracking

**When to use**: Permutations, combinations, constraint satisfaction

**Template**:
```python
def backtrack(path, choices):
    if need_to_record_result:
        result.append(path[:])
        return

    for choice in choices:
        if choice is invalid:
            continue

        path.append(choice)     # Make choice
        backtrack(path, new_choices)  # Explore
        path.pop()              # Undo choice (backtrack)
```

**Example Problems**:
- Subsets (78)
- Permutations (46)
- Combination Sum (39)
- N-Queens (51)

---

### 5. Depth-First Search (DFS)

**When to use**: Graph/tree traversal, connected components, path finding

**Template**:
```python
def dfs(node, visited):
    if node in visited:
        return

    visited.add(node)

    for neighbor in node.neighbors:
        dfs(neighbor, visited)
```

**Example Problems**:
- Number of Islands (200)
- Clone Graph (133)
- Course Schedule (207)
- Pacific Atlantic Water Flow (417)

---

### 6. Breadth-First Search (BFS)

**When to use**: Shortest path in unweighted graphs, level-order traversal

**Template**:
```python
from collections import deque

def bfs(start):
    queue = deque([start])
    visited = {start}

    while queue:
        node = queue.popleft()

        for neighbor in node.neighbors:
            if neighbor not in visited:
                visited.add(neighbor)
                queue.append(neighbor)
```

**Example Problems**:
- Binary Tree Level Order Traversal (102)
- Word Ladder (127)
- Rotting Oranges (994)
- Open the Lock (752)

---

### 7. Dynamic Programming

**When to use**: Optimization problems, overlapping subproblems, optimal substructure

**Approaches**:
- **Top-Down (Memoization)**: Recursive with cache
- **Bottom-Up (Tabulation)**: Iterative with table

**Template**:
```python
def dp(n):
    # Base cases
    if n == 0:
        return 0
    if n == 1:
        return 1

    # Initialize table
    table = [0] * (n + 1)
    table[1] = 1

    # Fill table
    for i in range(2, n + 1):
        table[i] = table[i-1] + table[i-2]

    return table[n]
```

**Example Problems**:
- Climbing Stairs (70)
- Coin Change (322)
- Longest Common Subsequence (1143)
- Word Break (139)

---

### 8. Monotonic Stack

**When to use**: Next greater/smaller element problems

**Template**:
```python
def monotonic_stack(nums):
    stack = []
    result = [-1] * len(nums)

    for i in range(len(nums)):
        while stack and nums[stack[-1]] < nums[i]:
            idx = stack.pop()
            result[idx] = nums[i]
        stack.append(i)

    return result
```

**Example Problems**:
- Daily Temperatures (739)
- Next Greater Element II (503)
- Largest Rectangle in Histogram (84)
- Trapping Rain Water (42)

---

### 9. Union-Find

**When to use**: Connected components, dynamic connectivity, cycle detection

**Template**:
```python
class UnionFind:
    def __init__(self, n):
        self.parent = list(range(n))
        self.rank = [0] * n

    def find(self, x):
        if self.parent[x] != x:
            self.parent[x] = self.find(self.parent[x])
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

**Example Problems**:
- Number of Connected Components (323)
- Redundant Connection (684)
- Accounts Merge (721)
- Surrounded Regions (130)

---

### 10. Trie (Prefix Tree)

**When to use**: Word storage, prefix matching, autocomplete

**Template**:
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

**Example Problems**:
- Implement Trie (208)
- Word Search II (212)
- Design Add and Search Words (211)
- Longest Word in Dictionary (720)

---

## Pattern Recognition Tips

| Problem Keywords | Likely Pattern |
|------------------|----------------|
| "subarray", "substring", "contiguous" | Sliding Window |
| "sorted array", "pair sum" | Two Pointers |
| "search", "minimum/maximum of function" | Binary Search |
| "permutation", "combination", "subset" | Backtracking |
| "shortest path", "level order" | BFS |
| "all paths", "connected" | DFS |
| "minimum/maximum", "how many ways" | Dynamic Programming |
| "next greater", "previous smaller" | Monotonic Stack |
| "connected components", "group" | Union-Find |
| "prefix", "dictionary" | Trie |
