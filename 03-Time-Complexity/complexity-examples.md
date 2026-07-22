# Complexity Analysis: Worked Examples

Practice analyzing the time and space complexity of real code.

## Example 1: Nested Loops with Dependencies

```python
def example1(arr):
    n = len(arr)
    total = 0
    for i in range(n):
        for j in range(i, n):
            total += arr[i] * arr[j]
    return total
```

**Analysis:**
```
i=0: j runs 0 to n-1    => n iterations
i=1: j runs 1 to n-1    => n-1 iterations
i=2: j runs 2 to n-1    => n-2 iterations
...
i=n-1: j runs n-1 to n-1 => 1 iteration

Total: n + (n-1) + (n-2) + ... + 1 = n(n+1)/2
Time: O(n^2)
Space: O(1) — only `total`, `i`, `j` variables
```

---

## Example 2: Hash Map Inside Loop

```python
def example2(arr):
    result = []
    seen = set()
    for num in arr:                         # O(n)
        if num not in seen:                 # O(1) average
            seen.add(num)                   # O(1) average
            complement = -num               # O(1)
            if complement in seen:          # O(1) average
                result.append(complement)   # O(1) amortized
    return result
```

**Analysis:**
```
Each iteration: O(1) for set operations + O(1) for append
Total iterations: n
Time: O(n)
Space: O(n) — the set can grow up to size n
```

---

## Example 3: Recursive with Redundant Calls

```python
def example3(n):
    if n <= 1:
        return 1
    if n == 2:
        return 2
    return example3(n-1) + example3(n-2) + example3(n-3)
```

**Analysis:**
```
Recurrence: T(n) = 3T(n-1) + O(1)

Recursion tree:
                    T(n)
              /      |      \
          T(n-1)  T(n-2)  T(n-3)
         / | \    / | \    / | \
       ... (triples at each level)

This is O(3^n) — exponential!

Space: O(n) — max recursion depth
```

**Optimized with memoization:**
```python
def example3_memo(n, memo={}):
    if n in memo: return memo[n]
    if n <= 1: return 1
    if n == 2: return 2
    memo[n] = (example3_memo(n-1, memo) + 
               example3_memo(n-2, memo) + 
               example3_memo(n-3, memo))
    return memo[n]
# Time: O(n), Space: O(n)
```

---

## Example 4: Sorting Then Processing

```python
def example4(arr, target):
    arr.sort()                          # O(n log n)
    for num in arr:                     # O(n)
        complement = target - num       # O(1)
        idx = binary_search(arr, complement)  # O(log n)
        if idx != -1:
            return True
    return False

def binary_search(arr, target):
    lo, hi = 0, len(arr) - 1
    while lo <= hi:
        mid = (lo + hi) // 2
        if arr[mid] == target: return mid
        elif arr[mid] < target: lo = mid + 1
        else: hi = mid - 1
    return -1
```

**Analysis:**
```
Sorting: O(n log n)
Loop: n iterations × O(log n) binary search = O(n log n)
Total Time: O(n log n) + O(n log n) = O(n log n)
Space: O(1) — in-place sort, constant extra variables
```

---

## Example 5: Matrix Operations

```python
def example5(matrix):
    n = len(matrix)
    result = [[0] * n for _ in range(n)]      # O(n^2) space
    
    for i in range(n):                         # O(n)
        for j in range(n):                     # O(n)
            for k in range(n):                 # O(n)
                result[i][j] += matrix[i][k] * matrix[k][j]
    return result
```

**Analysis:**
```
Three nested loops, each runs n times:
n × n × n = n^3 operations

Time: O(n^3)
Space: O(n^2) — the result matrix
```

---

## Example 6: Two Pointer on Sorted Array

```python
def example6(arr):
    arr.sort()                                 # O(n log n)
    count = 0
    left, right = 0, len(arr) - 1
    while left < right:                        # O(n)
        s = arr[left] + arr[right]
        if s == 0:
            count += 1
            left += 1
            right -= 1
        elif s < 0:
            left += 1
        else:
            right -= 1
    return count
```

**Analysis:**
```
Sorting: O(n log n)
Two pointers: Each pointer moves at most n times total: O(n)
Time: O(n log n) + O(n) = O(n log n)
Space: O(1) — in-place sort, two pointer variables
```

---

## Example 7: Graph BFS

```python
def example7(graph, start):
    from collections import deque
    visited = set()                            # O(V)
    queue = deque([start])                     # O(V)
    visited.add(start)
    order = []

    while queue:
        node = queue.popleft()                 # O(1)
        order.append(node)
        for neighbor in graph[node]:           # Total O(E) across all nodes
            if neighbor not in visited:        # O(1) average
                visited.add(neighbor)          # O(1) average
                queue.append(neighbor)         # O(1) amortized
    return order
```

**Analysis:**
```
Each node enqueued once: O(V)
Each edge checked once: O(E)
Set operations: O(1) average each
Time: O(V + E)
Space: O(V) — visited set + queue
```

---

## Example 8: Dynamic Programming — Knapsack

```python
def example8(weights, values, capacity):
    n = len(weights)
    dp = [[0] * (capacity + 1) for _ in range(n + 1)]  # O(n * W) space

    for i in range(1, n + 1):                             # O(n)
        for w in range(1, capacity + 1):                  # O(W)
            dp[i][w] = dp[i-1][w]                         # O(1)
            if weights[i-1] <= w:
                dp[i][w] = max(dp[i][w],
                    dp[i-1][w - weights[i-1]] + values[i-1])  # O(1)
    return dp[n][capacity]
```

**Analysis:**
```
Two nested loops: n × (capacity + 1)
Time: O(n × W)  where W = capacity
Space: O(n × W)

Note: This is pseudo-polynomial.
For n=100, W=1000: 100,000 operations — very fast.
For n=100, W=10^9: 10^11 operations — too slow!
```

---

## Example 9: Trie Operations

```python
class TrieNode:
    def __init__(self):
        self.children = {}
        self.is_end = False

class Trie:
    def __init__(self):
        self.root = TrieNode()

    def insert(self, word):                    # O(L)
        node = self.root
        for char in word:
            if char not in node.children:
                node.children[char] = TrieNode()
            node = node.children[char]
        node.is_end = True

    def search(self, word):                    # O(L)
        node = self.root
        for char in word:
            if char not in node.children:
                return False
            node = node.children[char]
        return node.is_end

    def starts_with(self, prefix):             # O(L)
        node = self.root
        for char in prefix:
            if char not in node.children:
                return False
            node = node.children[char]
        return True
```

**Analysis (per operation):**
```
L = length of word/prefix
Each character: O(1) dict lookup + O(1) dict insert
Time per operation: O(L)
Space: O(N × L) total where N = number of words
  (shared prefixes reduce actual space)
```

---

## Example 10: Sliding Window Maximum

```python
from collections import deque

def example10(arr, k):
    dq = deque()                              # O(k) max size
    result = []

    for i in range(len(arr)):                 # O(n)
        # Remove elements outside window
        while dq and dq[0] < i - k + 1:
            dq.popleft()                      # O(1) amortized

        # Remove smaller elements (they're useless)
        while dq and arr[dq[-1]] < arr[i]:
            dq.pop()                          # O(1) amortized

        dq.append(i)                          # O(1)

        # Record result once window is full
        if i >= k - 1:
            result.append(arr[dq[0]])         # O(1)
    return result
```

**Analysis:**
```
Each element added to deque once: O(n)
Each element removed from deque at most once: O(n)
Total deque operations: O(n)
Time: O(n)
Space: O(k) — deque holds at most k elements
```

---

## Quick Complexity Reference

| Code Pattern | Time | Space |
|-------------|------|-------|
| Single loop to n | O(n) | O(1) |
| Nested loops (independent) | O(n^2) | O(1) |
| Nested loops (dependent) | O(n^2) | O(1) |
| Loop that halves | O(log n) | O(1) |
| Loop with inner loop halving | O(n log n) | O(1) |
| Recursive tree (balanced) | O(n) | O(log n) |
| Recursive tree (unbalanced) | O(n) | O(n) |
| Recursive with 3 branches | O(3^n) | O(n) |
| Sorting then processing | O(n log n) | O(1) to O(n) |
| HashMap construction + lookup | O(n) | O(n) |

## Practice Problems

Analyze the complexity of each:

1. **Missing Number** (LeetCode 268):
```python
def missing_number(nums):
    return sum(range(len(nums) + 1)) - sum(nums)
```

2. **Contains Duplicate** (LeetCode 217):
```python
def contains_duplicate(nums):
    return len(nums) != len(set(nums))
```

3. **Valid Anagram** (LeetCode 242):
```python
def is_anagram(s, t):
    if len(s) != len(t):
        return False
    count = {}
    for c in s:
        count[c] = count.get(c, 0) + 1
    for c in t:
        if c not in count or count[c] == 0:
            return False
        count[c] -= 1
    return True
```

### Answers
1. Time: O(n), Space: O(1)
2. Time: O(n), Space: O(n)
3. Time: O(n), Space: O(1) — bounded by alphabet size

## Resources

- LeetCode problems tagged "Time Complexity"
- Big-O Cheat Sheet for quick reference
- "Introduction to Algorithms" (CLRS) for formal analysis
