# Brute Force to Optimal: The Optimization Journey

How to systematically evolve a naive solution into an optimal one.

## The Optimization Mindset

Every optimal solution starts as brute force. The key is knowing how to improve.

```
Brute Force  -->  Observe Patterns  -->  Apply Technique  -->  Optimal Solution
   O(n^3)              -                     +                    O(n log n)
```

---

## Step 1: Start with Brute Force

Always begin by writing the simplest correct solution.

### Example: Two Sum

```python
# BRUTE FORCE — Check every pair
def two_sum_brute(nums, target):
    for i in range(len(nums)):
        for j in range(i + 1, len(nums)):
            if nums[i] + nums[j] == target:
                return [i, j]
    return []
# Time: O(n^2), Space: O(1)
```

This is correct but slow. Now ask: **"What makes this slow?"**

The answer: we're re-checking pairs we've already seen. This is the optimization opportunity.

---

## Step 2: Identify Redundancy

Analyze what work is being repeated.

```
Brute Force Two Sum:
i=0: check (0,1), (0,2), (0,3), (0,4)    <-- we check j=1
i=1: check (1,2), (1,3), (1,4)           <-- we RE-check if 1+? works
i=2: check (2,3), (2,4)                  <-- we RE-check if 2+? works
...
```

**Key insight**: For each `nums[i]`, we need `target - nums[i]`. If we could
check that instantly, we avoid the inner loop.

---

## Step 3: Apply the Right Technique

### Technique Mapping

| Redundancy Type | Technique | Complexity Gain |
|----------------|-----------|----------------|
| Repeated lookups | Hashing | O(n^2) -> O(n) |
| Repeated subproblems | Memoization/DP | Exponential -> Polynomial |
| Unnecessary iterations | Binary Search | O(n) -> O(log n) |
| Redundant comparisons | Sorting + Two Pointers | O(n^2) -> O(n log n) |
| Overlapping work | Prefix Sums | O(n) per query -> O(1) |
| Repeated computation | Sliding Window | O(n*k) -> O(n) |

### Applying Hashing to Two Sum

```python
# OPTIMIZED — Hash map lookup
def two_sum_optimal(nums, target):
    seen = {}
    for i, num in enumerate(nums):
        complement = target - num
        if complement in seen:
            return [seen[complement], i]
        seen[num] = i
    return []
# Time: O(n), Space: O(n)
```

---

## Step 4: Full Optimization Examples

### Example 1: Maximum Subarray Sum

**Brute Force** — Check every subarray:
```python
def max_subarray_brute(arr):
    max_sum = float('-inf')
    for i in range(len(arr)):
        current = 0
        for j in range(i, len(arr)):
            current += arr[j]
            max_sum = max(max_sum, current)
    return max_sum
# Time: O(n^2), Space: O(1)
```

**Observation**: We recompute the sum of `arr[i..j]` from scratch each time.

**Optimization** — Kadane's Algorithm (Dynamic Programming):
```python
def max_subarray_optimal(arr):
    max_sum = current = arr[0]
    for i in range(1, len(arr)):
        current = max(arr[i], current + arr[i])
        max_sum = max(max_sum, current)
    return max_sum
# Time: O(n), Space: O(1)
```

```
Array: [-2, 1, -3, 4, -1, 2, 1, -5, 4]

Index:   0   1   2   3   4   5   6   7   8
Value:  -2   1  -3   4  -1   2   1  -5   4

current: -2   1  -2   4   3   5   6   1   5
max_sum: -2   1   1   4   4   5   6   6   6
                                    ^
                              Answer = 6
```

### Example 2: Longest Consecutive Sequence

**Brute Force** — For each element, check consecutive numbers:
```python
def longest_consecutive_brute(nums):
    longest = 0
    for num in nums:
        current = num
        streak = 1
        while current + 1 in nums:
            current += 1
            streak += 1
        longest = max(longest, streak)
    return longest
# Time: O(n^2), Space: O(n)
```

**Observation**: We restart the streak from every number, even middle ones.

**Optimization** — Only start counting from the beginning of a sequence:
```python
def longest_consecutive_optimal(nums):
    num_set = set(nums)
    longest = 0
    for num in num_set:
        if num - 1 not in num_set:  # Start of a sequence
            current = num
            streak = 1
            while current + 1 in num_set:
                current += 1
                streak += 1
            longest = max(longest, streak)
    return longest
# Time: O(n), Space: O(n)
```

### Example 3: Product of Array Except Self

**Brute Force** — For each element, multiply all others:
```python
def product_except_self_brute(nums):
    result = []
    for i in range(len(nums)):
        product = 1
        for j in range(len(nums)):
            if i != j:
                product *= nums[j]
        result.append(product)
    return result
# Time: O(n^2), Space: O(1) (excluding output)
```

**Optimization** — Prefix and suffix products:
```python
def product_except_self_optimal(nums):
    n = len(nums)
    result = [1] * n

    # Left pass: result[i] = product of all elements to the left
    prefix = 1
    for i in range(n):
        result[i] = prefix
        prefix *= nums[i]

    # Right pass: multiply by product of all elements to the right
    suffix = 1
    for i in range(n - 1, -1, -1):
        result[i] *= suffix
        suffix *= nums[i]

    return result
# Time: O(n), Space: O(1) (excluding output)
```

---

## Optimization Decision Tree

```
                    Start with brute force
                           |
                   What's the bottleneck?
                   /         |         \
              Nested     Redundant    Unnecessary
               loops     lookups     iterations
                |           |            |
        Can you sort?   Use HashMap  Binary Search
        /          \         |            |
      Yes          No    Done        Done
      |             |
  Two Pointers   Can you use
  + Sorting      Dynamic Programming
      |              |
    Done        Memoization
                    |
              Done
```

---

## Common Optimization Patterns

### Pattern 1: Nested Loops to HashMap

```
Before:                          After:
for i in range(n):              seen = {}
  for j in range(n):            for i in range(n):
    if ...                        complement = ...
                                   if complement in seen
```

### Pattern 2: Repeated Work to Prefix Sums

```
Before:                          After:
sum(arr[i:j]) for               build prefix sum array
each query                       answer queries in O(1)
```

### Pattern 3: Sorting + Two Pointers

```
Before:                          After:
for i in range(n):              arr.sort()
  for j in range(i+1, n):       left, right = 0, n-1
    check pair                     while left < right:
```

### Pattern 4: Brute Force to Dynamic Programming

```
Before:                          After:
def solve(n):                   memo = {}
  if n in memo:                 def solve(n):
    return memo[n]                if n in memo:
  for each choice:                 return memo[n]
    result += solve(n-1)         for each choice:
  memo[n] = result                 result += solve(n-1)
                                  memo[n] = result
```

---

## Complexity Comparison Table

| Problem | Brute Force | Optimized | Technique Used |
|---------|------------|-----------|----------------|
| Two Sum | O(n^2) | O(n) | HashMap |
| Max Subarray | O(n^2) | O(n) | Kadane's (DP) |
| Longest Consecutive | O(n^2) | O(n) | HashSet + Bound |
| Product Except Self | O(n^2) | O(n) | Prefix/Suffix |
| 3Sum | O(n^3) | O(n^2) | Sort + Two Pointers |
| Valid Sudoku | O(n^2) | O(n) | HashSet per row/col/box |
| Group Anagrams | O(n*k*log k) | O(n*k) | HashMap + sorted key |
| Min Window Substring | O(n^2) | O(n) | Sliding Window |

---

## Interview Tips

1. **Always state brute force first** — Shows you understand the problem
2. **Identify what makes it slow** — Proves you can analyze code
3. **Propose one optimization** — Don't jump to the best solution
4. **Discuss trade-offs** — Space vs time, worst vs average case
5. **Verify your optimization** — Trace through an example

### What Interviewers Look For

| Level | What You Do | Impression |
|-------|------------|------------|
| Junior | Write brute force correctly | Good foundation |
| Mid | Brute force + one optimization | Strong problem solver |
| Senior | Multiple approaches + trade-off analysis | Excellent thinker |

---

## Practice Progression

1. **Week 1-2**: Solve 10 brute force solutions, identify redundancies
2. **Week 3-4**: Optimize each using the appropriate technique
3. **Week 5-6**: Practice recognizing patterns without hints
4. **Week 7-8**: Timed practice — brute force in 10 min, optimal in 20 min

## Resources

- NeetCode roadmap for structured optimization practice
- "Cracking the Coding Interview" Chapter 8: Optimization problems
- LeetCode study plans: Data Structure I/II, Algorithm I/II
