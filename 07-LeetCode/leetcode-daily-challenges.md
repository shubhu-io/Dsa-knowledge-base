# LeetCode Daily Challenge Solutions

This document provides solutions and explanations for selected LeetCode Daily Challenge problems, organized by topic.

## Array Problems

### Two Sum (Problem #1)
**Difficulty:** Easy | **Tags:** Array, Hash Table

**Problem:** Given an array of integers `nums` and an integer `target`, return indices of the two numbers such that they add up to `target`.

**Approach:** Use a hash map to store previously seen values. For each element, check if `target - nums[i]` exists in the map.

**Time Complexity:** O(n) | **Space Complexity:** O(n)

```python
def two_sum(nums, target):
    seen = {}
    for i, num in enumerate(nums):
        complement = target - num
        if complement in seen:
            return [seen[complement], i]
        seen[num] = i
    return []
```

### Best Time to Buy and Sell Stock (Problem #121)
**Difficulty:** Easy | **Tags:** Array, Dynamic Programming

**Problem:** Find the maximum profit from buying and selling stock on different days.

**Approach:** Track the minimum price seen so far and calculate the potential profit at each step.

**Time Complexity:** O(n) | **Space Complexity:** O(1)

```python
def max_profit(prices):
    min_price = float('inf')
    max_profit = 0
    for price in prices:
        min_price = min(min_price, price)
        max_profit = max(max_profit, price - min_price)
    return max_profit
```

## String Problems

### Valid Palindrome (Problem #125)
**Difficulty:** Easy | **Tags:** String, Two Pointers

**Problem:** Determine if a string is a palindrome, considering only alphanumeric characters and ignoring cases.

**Approach:** Use two pointers from both ends, skipping non-alphanumeric characters.

**Time Complexity:** O(n) | **Space Complexity:** O(1)

```python
def is_palindrome(s):
    left, right = 0, len(s) - 1
    while left < right:
        while left < right and not s[left].isalnum():
            left += 1
        while left < right and not s[right].isalnum():
            right -= 1
        if s[left].lower() != s[right].lower():
            return False
        left += 1
        right -= 1
    return True
```

## Linked List Problems

### Reverse Linked List (Problem #206)
**Difficulty:** Easy | **Tags:** Linked List, Recursion

**Problem:** Reverse a singly linked list.

**Approach:** Iterative approach with three pointers (prev, curr, next).

**Time Complexity:** O(n) | **Space Complexity:** O(1)

```python
def reverse_list(head):
    prev = None
    curr = head
    while curr:
        next_node = curr.next
        curr.next = prev
        prev = curr
        curr = next_node
    return prev
```

## Tree Problems

### Maximum Depth of Binary Tree (Problem #104)
**Difficulty:** Easy | **Tags:** Tree, DFS, BFS

**Problem:** Find the maximum depth of a binary tree.

**Approach:** Recursive DFS - depth is 1 + max of left and right subtree depths.

**Time Complexity:** O(n) | **Space Complexity:** O(h) where h is height

```python
def max_depth(root):
    if not root:
        return 0
    return 1 + max(max_depth(root.left), max_depth(root.right))
```

## Dynamic Programming Problems

### Climbing Stairs (Problem #70)
**Difficulty:** Easy | **Tags:** Dynamic Programming

**Problem:** Count the number of distinct ways to climb to the top of a staircase.

**Approach:** Fibonacci sequence - each step is the sum of ways to reach the previous two steps.

**Time Complexity:** O(n) | **Space Complexity:** O(1)

```python
def climb_stairs(n):
    if n <= 2:
        return n
    a, b = 1, 2
    for _ in range(3, n + 1):
        a, b = b, a + b
    return b
```

## Graph Problems

### Number of Islands (Problem #200)
**Difficulty:** Medium | **Tags:** Graph, DFS, BFS

**Problem:** Count the number of islands in a 2D grid.

**Approach:** Use DFS to mark all connected land cells as visited.

**Time Complexity:** O(m * n) | **Space Complexity:** O(m * n)

```python
def num_islands(grid):
    if not grid:
        return 0
    
    rows, cols = len(grid), len(grid[0])
    count = 0
    
    def dfs(r, c):
        if r < 0 or r >= rows or c < 0 or c >= cols or grid[r][c] != '1':
            return
        grid[r][c] = '#'  # Mark as visited
        dfs(r + 1, c)
        dfs(r - 1, c)
        dfs(r, c + 1)
        dfs(r, c - 1)
    
    for r in range(rows):
        for c in range(cols):
            if grid[r][c] == '1':
                count += 1
                dfs(r, c)
    
    return count
```

## Tips for Daily Challenges

1. **Read the problem carefully** - Don't rush into coding
2. **Start with a brute force solution** - Then optimize
3. **Consider edge cases** - Empty inputs, single elements, duplicates
4. **Think about time and space complexity** - Can you do better?
5. **Practice consistently** - Solve at least one problem per day
6. **Review your solutions** - Understand different approaches

## See Also

- [[leetcode-guide]]
- [[leetcode-patterns]]
- [[leetcode-tips]]
- [[leetcode-top-interview-questions]]
