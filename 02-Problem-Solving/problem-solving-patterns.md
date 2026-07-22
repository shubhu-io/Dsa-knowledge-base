# Problem Solving Patterns

## Master Patterns for Coding Interviews

### 1. Array Patterns

#### Two Sum Pattern
```python
def two_sum(nums, target):
    seen = {}
    for i, num in enumerate(nums):
        complement = target - num
        if complement in seen:
            return [seen[complement], i]
        seen[num] = i
```

#### Sliding Window Pattern
```python
def max_subarray_sum(arr, k):
    window_sum = sum(arr[:k])
    max_sum = window_sum
    
    for i in range(k, len(arr)):
        window_sum += arr[i] - arr[i - k]
        max_sum = max(max_sum, window_sum)
    
    return max_sum
```

### 2. String Patterns

#### Anagram Pattern
```python
from collections import Counter

def is_anagram(s1, s2):
    return Counter(s1) == Counter(s2)
```

#### Palindrome Pattern
```python
def is_palindrome(s):
    left, right = 0, len(s) - 1
    while left < right:
        if s[left] != s[right]:
            return False
        left += 1
        right -= 1
    return True
```

### 3. Linked List Patterns

#### Fast-Slow Pointer
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

### 4. Tree Patterns

#### BFS (Level Order)
```python
from collections import deque

def level_order(root):
    if not root:
        return []
    
    result = []
    queue = deque([root])
    
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
```

#### DFS (Recursive)
```python
def inorder_traversal(root):
    if not root:
        return []
    return (inorder_traversal(root.left) + 
            [root.val] + 
            inorder_traversal(root.right))
```

### 5. Graph Patterns

#### BFS Shortest Path
```python
from collections import deque

def bfs(graph, start):
    visited = set([start])
    queue = deque([start])
    order = []
    
    while queue:
        vertex = queue.popleft()
        order.append(vertex)
        
        for neighbor in graph[vertex]:
            if neighbor not in visited:
                visited.add(neighbor)
                queue.append(neighbor)
    
    return order
```

### 6. Dynamic Programming Patterns

#### Fibonacci Pattern
```python
def fibonacci(n):
    if n <= 1:
        return n
    
    dp = [0] * (n + 1)
    dp[1] = 1
    
    for i in range(2, n + 1):
        dp[i] = dp[i-1] + dp[i-2]
    
    return dp[n]
```

#### Knapsack Pattern
```python
def knapsack(weights, values, capacity):
    n = len(weights)
    dp = [[0] * (capacity + 1) for _ in range(n + 1)]
    
    for i in range(1, n + 1):
        for w in range(1, capacity + 1):
            if weights[i-1] <= w:
                dp[i][w] = max(
                    values[i-1] + dp[i-1][w-weights[i-1]],
                    dp[i-1][w]
                )
            else:
                dp[i][w] = dp[i-1][w]
    
    return dp[n][capacity]
```

## Pattern Recognition Guide

| Pattern | When to Use | Time Complexity |
|---------|-------------|-----------------|
| Two Pointers | Sorted arrays, pairs | O(n) |
| Sliding Window | Subarray/Substring | O(n) |
| Fast-Slow Pointer | Linked list cycle | O(n) |
| Binary Search | Sorted array | O(log n) |
| BFS | Level-by-level, shortest path | O(V + E) |
| DFS | Path finding, backtracking | O(V + E) |
| Dynamic Programming | Overlapping subproblems | Varies |
| Greedy | Local optimal choice | O(n log n) |
| Backtracking | All possible solutions | O(2^n) |