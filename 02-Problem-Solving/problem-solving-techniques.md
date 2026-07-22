# Problem Solving Techniques

A deep dive into the most effective techniques used in competitive programming and technical interviews.

## 1. Brute Force Approach

The simplest solution that tries every possible option.

```python
# Find the maximum element in an unsorted array
def find_max_brute(arr):
    max_val = arr[0]
    for i in range(len(arr)):          # O(n)
        if arr[i] > max_val:
            max_val = arr[i]
    return max_val
# Time: O(n), Space: O(1)
```

### When to Use
- As a baseline to compare optimized solutions
- When input size is small (n <= 20)
- When the problem is simple enough
- During interviews to show you understand the problem

### Common Brute Force Patterns
| Pattern | Complexity | Example |
|---------|-----------|---------|
| Generate all subsets | O(2^n) | Power set problems |
| Generate all permutations | O(n!) | Arrangement problems |
| Nested loops | O(n^k) | k-Sum problems |
| Try all paths | O(n!) | Traveling salesman |

---

## 2. Two Pointers Technique

Use two indices to traverse a data structure, usually an array or string.

```python
# Check if a string is a palindrome
def is_palindrome(s):
    left, right = 0, len(s) - 1
    while left < right:
        if s[left] != s[right]:
            return False
        left += 1
        right -= 1
    return True
# Time: O(n), Space: O(1)
```

### Two Pointer Variants

**Opposite Ends** — Start from both ends moving inward:
```
[2, 7, 11, 15, 20]
 L              R    L+R == 22? No, move R left
 L           R       L+R == 17? No, move R left
 L        R          L+R == 13? Yes, found pair
```

**Same Direction** — Both move in the same direction (sliding window):
```
[1, 3, 2, 1, 5, 1]
 S        F          Fast finds target, Slow catches up
```

**Slow-Fast Pointer** — Used for cycle detection (Floyd's algorithm):
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

## 3. Sliding Window

Maintain a window (subarray/substring) that slides through the data.

```python
# Maximum sum subarray of size k
def max_sum_subarray(arr, k):
    window_sum = sum(arr[:k])
    max_sum = window_sum
    for i in range(k, len(arr)):
        window_sum += arr[i] - arr[i - k]
        max_sum = max(max_sum, window_sum)
    return max_sum
# Time: O(n), Space: O(1)
```

### Window Types

| Type | Use Case | Example Problem |
|------|----------|----------------|
| Fixed size | Subarray of exact size k | Max sum of k elements |
| Variable size | Find min window satisfying condition | Minimum window substring |
| Dynamic | Shrink/expand based on condition | Longest substring without repeating |

### Template
```python
def sliding_window(arr, condition):
    left = 0
    result = 0
    for right in range(len(arr)):
        # 1. Expand window (add arr[right])
        # 2. Check if window is valid
        # 3. If invalid, shrink from left
        while not condition(arr, left, right):
            # Remove arr[left] from window
            left += 1
        # 4. Update result
        result = max(result, right - left + 1)
    return result
```

---

## 4. Prefix Sum / Suffix Sum

Precompute cumulative sums to answer range queries in O(1).

```python
# Range sum query
class PrefixSum:
    def __init__(self, arr):
        n = len(arr)
        self.prefix = [0] * (n + 1)
        for i in range(n):
            self.prefix[i + 1] = self.prefix[i] + arr[i]

    def range_sum(self, left, right):
        return self.prefix[right + 1] - self.prefix[left]

# arr = [2, 4, 6, 8, 10]
# prefix = [0, 2, 6, 12, 20, 30]
# range_sum(1, 3) = prefix[4] - prefix[1] = 20 - 2 = 18
# Time: O(n) build, O(1) query
```

### 2D Prefix Sum
```python
def build_2d_prefix(matrix):
    rows, cols = len(matrix), len(matrix[0])
    prefix = [[0] * (cols + 1) for _ in range(rows + 1)]
    for i in range(rows):
        for j in range(cols):
            prefix[i+1][j+1] = (matrix[i][j] 
                + prefix[i][j+1] + prefix[i+1][j] 
                - prefix[i][j])
    return prefix
```

---

## 5. Binary Search on Answer

Search for the optimal value in a sorted range of possible answers.

```python
# Find minimum capacity to ship packages within D days
def min_ship_capacity(weights, D):
    def can_ship(capacity):
        days, current = 1, 0
        for w in weights:
            if current + w > capacity:
                days += 1
                current = 0
            current += w
        return days <= D

    lo, hi = max(weights), sum(weights)
    while lo < hi:
        mid = (lo + hi) // 2
        if can_ship(mid):
            hi = mid
        else:
            lo = mid + 1
    return lo
# Time: O(n * log(sum - max))
```

### When to Apply
- "Minimize the maximum" or "Maximize the minimum"
- The answer can be verified in O(n) or O(log n)
- The search space is monotonic (if x works, x+1 also works)

---

## 6. Hashing

Use hash maps/sets for O(1) average-case lookups.

```python
# Find two numbers that add up to target
def two_sum(nums, target):
    seen = {}
    for i, num in enumerate(nums):
        complement = target - num
        if complement in seen:
            return [seen[complement], i]
        seen[num] = i
    return []
# Time: O(n), Space: O(n)
```

### Hashing Applications
| Application | Technique | Example |
|------------|-----------|---------|
| Frequency counting | HashMap | Top K frequent elements |
| Duplicate detection | HashSet | Contains duplicate |
| Grouping | HashMap of lists | Group anagrams |
| Two sum variants | Complement lookup | Two sum, three sum |

---

## 7. Recursion and Backtracking

Systematically explore all possibilities by building solutions incrementally.

```python
# Generate all subsets of an array
def subsets(nums):
    result = []
    def backtrack(start, current):
        result.append(current[:])  # snapshot
        for i in range(start, len(nums)):
            current.append(nums[i])
            backtrack(i + 1, current)
            current.pop()  # undo choice
    backtrack(0, [])
    return result
# Time: O(2^n), Space: O(n) recursion depth
```

### Backtracking Template
```python
def backtrack(path, choices):
    if reach_end_condition:
        result.append(path[:])
        return
    for choice in choices:
        if is_valid(choice):
            path.append(choice)     # make choice
            backtrack(path, new_choices)  # recurse
            path.pop()              # undo choice (backtrack)
```

---

## 8. Divide and Conquer

Break the problem into smaller subproblems, solve recursively, combine results.

```python
# Count inversions in array
def count_inversions(arr):
    if len(arr) <= 1:
        return arr, 0
    mid = len(arr) // 2
    left, left_inv = count_inversions(arr[:mid])
    right, right_inv = count_inversions(arr[mid:])
    merged, split_inv = merge_and_count(left, right)
    return merged, left_inv + right_inv + split_inv

def merge_and_count(left, right):
    result, inversions = [], 0
    i = j = 0
    while i < len(left) and j < len(right):
        if left[i] <= right[j]:
            result.append(left[i]); i += 1
        else:
            result.append(right[j]); j += 1
            inversions += len(left) - i
    result.extend(left[i:])
    result.extend(right[j:])
    return result, inversions
# Time: O(n log n), Space: O(n)
```

---

## 9. Bit Manipulation

Leverage bitwise operations for efficient solutions.

```python
# Find the single number (all others appear twice)
def single_number(nums):
    result = 0
    for num in nums:
        result ^= num
    return result
# XOR of same numbers = 0, XOR of 0 and x = x
# Time: O(n), Space: O(1)
```

### Common Bit Tricks
| Operation | Code | Purpose |
|-----------|------|---------|
| Check if power of 2 | `n & (n-1) == 0` | Single bit set |
| Get ith bit | `(n >> i) & 1` | Check specific bit |
| Set ith bit | `n \| (1 << i)` | Turn on bit |
| Toggle ith bit | `n ^ (1 << i)` | Flip bit |
| Count set bits | `bin(n).count('1')` | Hamming weight |

---

## 10. Greedy Approach

Make the locally optimal choice at each step.

```python
# Activity selection problem
def max_activities(activities):
    # Sort by finish time
    activities.sort(key=lambda x: x[1])
    result = [activities[0]]
    last_end = activities[0][1]
    for start, end in activities[1:]:
        if start >= last_end:
            result.append((start, end))
            last_end = end
    return result
# Time: O(n log n)
```

### Greedy vs Dynamic Programming
| Aspect | Greedy | Dynamic Programming |
|--------|--------|-------------------|
| Decision | Local optimum | Global optimum |
| Subproblems | No overlap | Overlapping |
| Complexity | Usually faster | Usually slower |
| Correctness | Needs proof | Always correct |
| Example | Activity selection | Knapsack |

---

## Technique Selection Guide

```
Problem Analysis Flowchart:

                    Is the problem sorted?
                    /                    \
                  Yes                     No
                  /                        \
          Two Pointers              Can you sort it?
          Binary Search              /          \
          Sliding Window           Yes            No
                                    /              \
                              Sort + Apply     Use Hashing
                              Two Pointers     Two Pointers
                              Binary Search    Dynamic Programming
                                               Backtracking
```

## Practice Strategy

1. **Master one technique at a time** — Don't try to learn everything at once
2. **Identify problem patterns** — Most problems map to 2-3 techniques
3. **Build a mental toolbox** — Know when each technique applies
4. **Time yourself** — Practice under interview-like conditions
5. **Review and reflect** — After solving, think about what you learned

## Recommended Problems by Technique

| Technique | Beginner | Intermediate | Advanced |
|-----------|----------|-------------|----------|
| Two Pointers | Valid Palindrome | 3Sum | Container With Most Water |
| Sliding Window | Max Sum Subarray | Longest Substring Without Repeating | Minimum Window Substring |
| Binary Search | Binary Search | Search in Rotated Array | Median of Two Sorted Arrays |
| Hashing | Two Sum | Group Anagrams | LRU Cache |
| Backtracking | Subsets | Permutations II | N-Queens |
| Greedy | Best Time to Buy Stock | Jump Game | Merge Intervals |

## Resources

- **Books**: "Algorithm Design Manual" by Skiena, "Competitive Programming" by Halim
- **Practice**: LeetCode topic-based study plans, NeetCode 150
- **Visual**: VisuAlgo.net for algorithm visualization
