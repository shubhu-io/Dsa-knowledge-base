# Dynamic Programming Tutorial

## Introduction
Dynamic Programming (DP) is both a mathematical optimization method and a computer programming method. The method was developed by Richard Bellman in the 1950s and has found applications in numerous fields, from aerospace engineering to economics.

In computer science, dynamic programming is mainly used to solve problems that have overlapping subproblems and optimal substructure properties. The core idea is to break down a complex problem into simpler subproblems, solve each subproblem just once, and store their solutions - ideally, using a memory-based data structure.

## Core Principles

### 1. Overlapping Subproblems
A problem has overlapping subproblems if finding its solution involves solving the same subproblem multiple times. Rather than recompute these solutions, DP stores them for future reference.

**Example**: Computing Fibonacci numbers
- `fib(5) = fib(4) + fib(3)`
- `fib(4) = fib(3) + fib(2)`
- `fib(3) = fib(2) + fib(1)`
- Notice `fib(3)` and `fib(2)` are computed multiple times

### 2. Optimal Substructure
A problem exhibits optimal substructure if an optimal solution to the problem contains optimal solutions to its subproblems.

**Example**: Shortest path problem
- If a shortest path from A to C passes through B, then the path from A to B must be the shortest path from A to B
- Similarly, the path from B to C must be the shortest path from B to C

## Key Steps in Dynamic Programming

### Step 1: Characterize the Structure of an Optimal Solution
- Define what constitutes a subproblem
- Identify how the solution to the main problem relates to solutions of subproblems

### Step 2: Recursively Define the Value of an Optimal Solution
- Express the solution of the original problem in terms of optimal solutions for smaller subproblems
- This creates a recurrence relation

### Step 3: Compute the Value of an Optimal Solution (Bottom-Up)
- Solve subproblems in an order that ensures subproblems are solved before they're needed
- Typically done using iteration filling a table

### Step 4: Construct an Optimal Solution from Computed Information
- Often requires keeping track of choices made during the computation
- May involve backtracking through the computed table

## DP Implementation Approaches

### 1. Top-Down with Memoization
Start with the original problem and break it down into subproblems, storing results to avoid recomputation.

```python
def fib_memo(n, memo={}):
    if n in memo:
        return memo[n]
    if n <= 1:
        return n
    
    memo[n] = fib_memo(n-1, memo) + fib_memo(n-2, memo)
    return memo[n]
```

### 2. Bottom-Up (Tabulation)
Solve all related subproblems first, typically by filling up an n-dimensional table.

```python
def fib_tab(n):
    if n <= 1:
        return n
    
    dp = [0] * (n + 1)
    dp[0] = 0
    dp[1] = 1
    
    for i in range(2, n + 1):
        dp[i] = dp[i-1] + dp[i-2]
    
    return dp[n]
```

## Common DP Patterns

### 1. 1D DP (Linear DP)
Subproblems can be arranged in a line.

**Examples**:
- Fibonacci sequence
- Climbing stairs
- House robber
- Maximum subarray sum (Kadane's algorithm)

**Pattern**:
```python
dp[i] = f(dp[i-1], dp[i-2], ..., dp[i-k])
```

### 2. 2D DP (Grid DP)
Subproblems form a grid or matrix.

**Examples**:
- Unique paths in grid
- Edit distance
- Longest common subsequence
- Minimum path sum in triangle

**Pattern**:
```python
dp[i][j] = f(dp[i-1][j], dp[i][j-1], dp[i-1][j-1])
```

### 3. Knapsack Pattern
Resource allocation with constraints.

**Examples**:
- 0/1 Knapsack
- Unbounded knapsack
- Coin change (variations)
- Partition equal subset sum

### 4. DP on Strings
String processing with subsequences/substrings.

**Examples**:
- Longest common substring
- Longest palindromic substring
- Regular expression matching
- Word break

### 5. DP on Trees
Tree traversal with state passing.

**Examples**:
- Diameter of binary tree
- Maximum path sum in binary tree
- Vertex cover on tree
- Independent set on tree

### 6. DP with Bitmasking
State represented by bits in an integer.

**Examples**:
- Traveling Salesperson Problem (TSP)
- Assignment problems
- Subset DP
- Problems with small state spaces

## Classic DP Problems

### 1. Fibonacci Numbers
**Problem**: Compute the nth Fibonacci number.

**Recurrence**: `F(n) = F(n-1) + F(n-2)` with `F(0) = 0, F(1) = 1`

**Bottom-Up Solution**:
```python
def fib(n):
    if n <= 1:
        return n
    
    dp = [0] * (n + 1)
    dp[0] = 0
    dp[1] = 1
    
    for i in range(2, n + 1):
        dp[i] = dp[i-1] + dp[i-2]
    
    return dp[n]
```

**Space Optimization**:
```python
def fib_optimized(n):
    if n <= 1:
        return n
    
    a, b = 0, 1
    for _ in range(2, n + 1):
        a, b = b, a + b
    
    return b
```

### 2. Climbing Stairs
**Problem**: You are climbing a staircase. It takes n steps to reach the top. Each time you can either climb 1 or 2 steps. In how many distinct ways can you climb to the top?

**Recurrence**: `dp[i] = dp[i-1] + dp[i-2]`

**Solution**:
```python
def climbStairs(n):
    if n <= 2:
        return n
    
    dp = [0] * (n + 1)
    dp[1] = 1
    dp[2] = 2
    
    for i in range(3, n + 1):
        dp[i] = dp[i-1] + dp[i-2]
    
    return dp[n]
```

### 3. House Robber
**Problem**: You are a professional robber planning to rob houses along a street. Each house has a certain amount of money stashed. Adjacent houses have security systems connected, and it will automatically contact the police if two adjacent houses were broken into on the same night.

**Recurrence**: `dp[i] = max(dp[i-1], dp[i-2] + nums[i])`

**Solution**:
```python
def rob(nums):
    if not nums:
        return 0
    if len(nums) <= 2:
        return max(nums)
    
    dp = [0] * len(nums)
    dp[0] = nums[0]
    dp[1] = max(nums[0], nums[1])
    
    for i in range(2, len(nums)):
        dp[i] = max(dp[i-1], dp[i-2] + nums[i])
    
    return dp[-1]
```

**Space Optimized**:
```python
def rob_optimized(nums):
    if not nums:
        return 0
    if len(nums) <= 2:
        return max(nums)
    
    prev2, prev1 = nums[0], max(nums[0], nums[1])
    
    for i in range(2, len(nums)):
        current = max(prev1, prev2 + nums[i])
        prev2, prev1 = prev1, current
    
    return prev1
```

### 4. Unique Paths
**Problem**: A robot is located at the top-left corner of an m x n grid. The robot can only move either down or right at any point in time. The robot is trying to reach the bottom-right corner of the grid.

**Recurrence**: `dp[i][j] = dp[i-1][j] + dp[i][j-1]`

**Solution**:
```python
def uniquePaths(m, n):
    dp = [[0] * n for _ in range(m)]
    
    # Initialize first row and column
    for i in range(m):
        dp[i][0] = 1
    for j in range(n):
        dp[0][j] = 1
    
    # Fill the DP table
    for i in range(1, m):
        for j in range(1, n):
            dp[i][j] = dp[i-1][j] + dp[i][j-1]
    
    return dp[m-1][n-1]
```

**Space Optimized**:
```python
def uniquePaths_optimized(m, n):
    dp = [1] * n
    
    for i in range(1, m):
        for j in range(1, n):
            dp[j] += dp[j-1]
    
    return dp[-1]
```

### 5. Edit Distance (Levenshtein Distance)
**Problem**: Given two strings word1 and word2, return the minimum number of operations required to convert word1 to word2.

**Operations**:
- Insert a character
- Delete a character
- Replace a character

**Recurrence**:
```
if word1[i-1] == word2[j-1]:
    dp[i][j] = dp[i-1][j-1]
else:
    dp[i][j] = 1 + min(
        dp[i-1][j],    # Delete
        dp[i][j-1],    # Insert
        dp[i-1][j-1]   # Replace
    )
```

**Solution**:
```python
def minDistance(word1, word2):
    m, n = len(word1), len(word2)
    dp = [[0] * (n + 1) for _ in range(m + 1)]
    
    # Initialize base cases
    for i in range(m + 1):
        dp[i][0] = i
    for j in range(n + 1):
        dp[0][j] = j
    
    # Fill DP table
    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if word1[i-1] == word2[j-1]:
                dp[i][j] = dp[i-1][j-1]
            else:
                dp[i][j] = 1 + min(dp[i-1][j], dp[i][j-1], dp[i-1][j-1])
    
    return dp[m][n]
```

### 6. Longest Common Subsequence (LCS)
**Problem**: Given two strings text1 and text2, return the length of their longest common subsequence.

**Recurrence**:
```
if text1[i-1] == text2[j-1]:
    dp[i][j] = dp[i-1][j-1] + 1
else:
    dp[i][j] = max(dp[i-1][j], dp[i][j-1])
```

**Solution**:
```python
def longestCommonSubsequence(text1, text2):
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

### 7. 0/1 Knapsack Problem
**Problem**: Given weights and values of n items, put these items in a knapsack of capacity W to get the maximum total value in the knapsack. Each item can be used at most once.

**Recurrence**:
```
dp[i][w] = max(dp[i-1][w], dp[i-1][w-wt[i]] + val[i]) if wt[i] <= w
          dp[i-1][w] otherwise
```

**Solution**:
```python
def knapsack(W, wt, val, n):
    dp = [[0] * (W + 1) for _ in range(n + 1)]
    
    for i in range(1, n + 1):
        for w in range(W + 1):
            if wt[i-1] <= w:
                dp[i][w] = max(dp[i-1][w], dp[i-1][w-wt[i-1]] + val[i-1])
            else:
                dp[i][w] = dp[i-1][w]
    
    return dp[n][W]
```

**Space Optimized**:
```python
def knapsack_optimized(W, wt, val, n):
    dp = [0] * (W + 1)
    
    for i in range(n):
        for w in range(W, wt[i]-1, -1):  # Important: iterate backwards
            dp[w] = max(dp[w], dp[w-wt[i]] + val[i])
    
    return dp[W]
```

### 8. Coin Change (Number of Ways)
**Problem**: You are given an integer array coins representing coins of different denominations and an integer amount representing a total amount of money. Return the number of combinations that make up that amount.

**Recurrence** (Order doesn't matter combination):
```
dp[i] = sum(dp[i - coin] for coin in coins if i >= coin)
```

**Solution** (Combinations - order doesn't matter):
```python
def change(amount, coins):
    dp = [0] * (amount + 1)
    dp[0] = 1  # One way to make amount 0
    
    for coin in coins:
        for x in range(coin, amount + 1):
            dp[x] += dp[x - coin]
    
    return dp[amount]
```

### 9. Maximum Subarray Sum (Kadane's Algorithm)
**Problem**: Given an integer array nums, find the contiguous subarray (containing at least one number) which has the largest sum and return its sum.

**Recurrence**:
```
dp[i] = max(nums[i], dp[i-1] + nums[i])
```

**Solution**:
```python
def maxSubArray(nums):
    if not nums:
        return 0
    
    max_ending_here = max_so_far = nums[0]
    
    for i in range(1, len(nums)):
        max_ending_here = max(nums[i], max_ending_here + nums[i])
        max_so_far = max(max_so_far, max_ending_here)
    
    return max_so_far
```

### 10. Longest Increasing Subsequence (LIS)
**Problem**: Given an integer array nums, return the length of the longest strictly increasing subsequence.

**Recurrence**:
```
dp[i] = max(dp[j]) + 1 for all j < i where nums[j] < nums[i]
```

**Solution** (O(n^2)):
```python
def lengthOfLIS(nums):
    if not nums:
        return 0
    
    dp = [1] * len(nums)
    
    for i in range(len(nums)):
        for j in range(i):
            if nums[j] < nums[i]:
                dp[i] = max(dp[i], dp[j] + 1)
    
    return max(dp)
```

**Solution** (O(n log n) with binary search):
```python
def lengthOfLIS_optimized(nums):
    if not nums:
        return 0
    
    tails = []  # tails[i] = smallest tail of all increasing subsequences of length i+1
    
    for num in nums:
        # Find the first index in tails where tails[i] >= num
        left, right = 0, len(tails)
        while left < right:
            mid = left + (right - left) // 2
            if tails[mid] < num:
                left = mid + 1
            else:
                right = mid
        
        if left == len(tails):
            tails.append(num)
        else:
            tails[left] = num
    
    return len(tails)
```

## Advanced DP Techniques

### 1. DP with Bitmasking
Used when the state space can be represented by bits in an integer.

**Example**: Traveling Salesperson Problem (TSP)

```python
def tsp(graph):
    n = len(graph)
    # dp[mask][i] = minimum cost to visit all cities in mask ending at city i
    dp = [[float('inf')] * n for _ in range(1 << n)]
    
    # Base case: starting at city 0
    dp[1][0] = 0
    
    # Fill DP table
    for mask in range(1 << n):
        for u in range(n):
            if dp[mask][u] == float('inf'):
                continue
            
            # Try to visit all unvisited cities
            for v in range(n):
                if mask & (1 << v) == 0:  # If city v not visited in mask
                    new_mask = mask | (1 << v)
                    dp[new_mask][v] = min(dp[new_mask][v], dp[mask][u] + graph[u][v])
    
    # Return to starting city
    return min(dp[(1 << n) - 1][i] + graph[i][0] for i in range(n))
```

### 2. DP on Trees
Tree DP where we compute values for subtrees.

**Example**: Binary Tree Maximum Path Sum

```python
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

def maxPathSum(root):
    max_sum = float('-inf')
    
    def dfs(node):
        nonlocal max_sum
        if not node:
            return 0
        
        # Max gain from left and right subtrees (ignore negative gains)
        left_gain = max(dfs(node.left), 0)
        right_gain = max(dfs(node.right), 0)
        
        # Price of new path through current node
        price_newpath = node.val + left_gain + right_gain
        
        # Update global maximum
        max_sum = max(max_sum, price_newpath)
        
        # For recursion, return max gain that can be extended to parent
        return node.val + max(left_gain, right_gain)
    
    dfs(root)
    return max_sum
```

### 3. DP with Monotonic Queue Optimization
Optimizes DP transitions from O(n^2) to O(n) for certain patterns.

**Example**: Sliding window maximum (though this is more commonly solved with deque)

### 4. Divide and Conquer Optimization
Applies when the DP recurrence satisfies the quadrangle inequality or monotonicity of decision points.

**Example**: Certain DP problems where transition point opt[i][j] ≤ opt[i][j+1]

### 5. Convex Hull Trick Optimization
Used when DP recurrence involves finding minimum/maximum of linear functions.

## State Definition Strategies

### 1. **Prefix/Suffix Based**
- `dp[i]` = answer for prefix/suffix ending at position i
- Common in string and array problems

### 2. **Subarray/Substring Based**
- `dp[i][j]` = answer for substring/array from i to j
- Common in palindrome, matrix chain problems

### 3. **Knapsack Style**
- `dp[i][w]` = best value using first i items with weight limit w
- Resource allocation problems

### 4. **Subset/Mask Based**
- `dp[mask]` = answer for subset represented by mask
- Problems with small element sets (n ≤ 20)

### 5. **Two Sequence DP**
- `dp[i][j]` = answer considering first i elements of sequence 1 and first j elements of sequence 2
- LCS, edit distance, etc.

### 6. **Tree DP State**
- `dp[node][state]` = answer for subtree rooted at node with certain state
- Binary tree problems, graph problems on trees

## When to Use Dynamic Programming

### Indicators That Suggest DP
1. **Overlapping Subproblems**: Same subproblem solved multiple times
2. **Optimal Substructure**: Optimal solution contains optimal solutions to subproblems
3. **Maximization/Minimization**: Finding best/worst case scenario
4. **Counting Problems**: Number of ways to achieve something
5. **Decision Problems**: Yes/no questions with constraints
6. **Sequence Problems**: Problems involving arrays, strings, sequences

### Steps to Identify DP Problems
1. Can the problem be broken down into smaller, similar subproblems?
2. Do these subproblems overlap (get solved multiple times)?
3. Does the solution to the problem depend on solutions to subproblems?
4. Is there a clear recursive structure to the problem?

### Common DP Problem Categories
- **Sequence/Array Problems**: Maximum subarray, LIS, house robber
- **String Problems**: Edit distance, LCS, word break
- **Grid Problems**: Unique paths, minimum path sum, dungeon game
- **Knapsack Problems**: Resource allocation, coin change, partition problems
- **Tree Problems**: Maximum path sum, diameter, vertex cover
- **Graph Problems**: Shortest path with constraints, TSP
- **Game Theory**: Optimal game strategies, minimax with memoization
- **Advanced**: Bitmask DP, DP with optimization techniques

## DP Implementation Tips

### 1. **State Definition**
- Clearly define what dp[i] or dp[i][j] represents
- Include all necessary information to make future decisions
- Avoid redundant information in state

### 2. **Recurrence Relation**
- Derive from the problem statement and state definition
- Consider all possible transitions to current state
- Handle base cases explicitly

### 3. **Order of Computation**
- For bottom-up: Determine dependencies and compute in correct order
- For top-down: Memoization handles order automatically
- Watch out for circular dependencies

### 4. **Space Optimization**
- Often possible to reduce space complexity
- Common techniques:
  - Rolling arrays (keep only last k rows)
  - Two arrays (current and previous)
  - Single array with careful update order
  - In-place modification when possible

### 5. **Initialization/Base Cases**
- Critical for correctness
- Often represent smallest subproblems
- Match problem constraints exactly

### 6. **Result Extraction**
- Know where the final answer is stored in DP table
- May be dp[n], dp[n][W], max(dp), etc.
- Sometimes need to reconstruct solution

## Space Optimization Techniques

### 1. **Rolling Array**
When dp[i] depends only on dp[i-1] and dp[i-2]:

```python
# Instead of dp = [0] * (n+1)
# Use three variables or rotate through array
a, b = base_case_1, base_case_2
for i in range(2, n+1):
    c = f(a, b)
    a, b = b, c
# Result in b
```

### 2. **Single Array with Reverse Iteration**
Common in knapsack problems to prevent overwriting needed values:

```python
# For 0/1 knapsack: iterate backwards
dp = [0] * (W+1)
for item in items:
    for w in range(W, item.weight-1, -1):  # NOTE: backwards
        dp[w] = max(dp[w], dp[w-item.weight] + item.value)
```

### 3. **Two Arrays**
Keep only current and previous row/column:

```python
prev = [0] * (n+1)
curr = [0] * (n+1)
for i in range(1, m+1):
    for j in range(1, n+1):
        # Compute curr[j] using prev[*] and curr[*]
        curr[j] = f(prev[j], curr[j-1], prev[j-1])
    prev, curr = curr, [0] * (n+1)  # Reset curr
```

## Common Mistakes and How to Avoid Them

### 1. **Incorrect State Definition**
**Problem**: State doesn't capture enough information or includes irrelevant information
**Solution**: Clearly state what each dimension represents. Test with small examples.

### 2. **Wrong Recurrence Relation**
**Problem**: Missing transition cases or incorrect transitions
**Solution**: Derive carefully from problem definition. Verify with manual computation on small cases.

### 3. **Improper Initialization/Base Cases**
**Solution**: Explicitly handle smallest subproblems. Check edge cases (empty input, single element).

### 4. **Wrong Computation Order**
**Solution**: Ensure dependencies are computed before they're needed. Draw dependency graph if unclear.

### 5. **Off-by-One Errors**
**Solution**: Be consistent with indexing (0-based vs 1-based). Test with minimal cases.

### 6. **Not Considering All Cases in Transition**
**Solution**: List all possible ways to reach current state. Think about what choices led here.

### 7. **Incorrect Space Optimization**
**Solution**: Verify optimization doesn't break dependencies. Test unoptimized vs optimized versions.

### 8. **Modulo Errors**
**Solution**: Apply modulo at each step to prevent overflow. Remember (a+b)%m = ((a%m)+(b%m))%m.

### 9. **Forgetting to Handle Impossible States**
**Solution**: Use appropriate initial values (inf for min problems, 0 for count problems, -inf for max problems).

### 10. **Confusing Similar Problems**
**Solution**: Clearly distinguish between similar problems (e.g., combination sum permutations vs combinations).

## Optimization Strategies

### 1. **Pruning Impossible States**
Skip states that cannot lead to valid solutions.

### 2. **Early Termination**
Stop computation when answer is found or determined impossible.

### 3. **Preprocessing**
Sort inputs, remove duplicates, or compute lookup tables beforehand.

### 4. **Algorithm Selection**
Choose between DP, greedy, divide and conquer based on problem properties.

### 5. **Meet-in-the-Middle**
Split problem into two halves, solve each, then combine. Useful for 2^n problems when n ≤ 40.

## Applications of Dynamic Programming

### 1. **Bioinformatics**
- DNA sequence alignment (Needleman-Wunsch, Smith-Waterman)
- Protein folding prediction
- Gene finding

### 2. **Operations Research**
- Resource allocation
- Inventory management
- Production planning
- Shortest path routing

### 3. **Computer Science**
- Compiler optimization (register allocation)
- Graphics (image segmentation, curve fitting)
- AI (natural language processing, speech recognition)
- Cryptography (key generation, attack algorithms)

### 4. **Economics and Finance**
- Optimal investment strategies
- Option pricing
- Consumption-saving models
- Risk management

### 5. **Engineering**
- Control systems
- Signal processing
- Structural optimization
- Network design

## Learning


<tool_call>
<function=Write>
<parameter=content>
# Dynamic Programming Problems

This file contains a comprehensive collection of dynamic programming problems organized by difficulty level, each with detailed explanations, examples, and solutions.

## Easy Problems

### 1. Climbing Stairs
**Problem**: You are climbing a staircase. It takes n steps to reach the top. Each time you can either climb 1 or 2 steps. In how many distinct ways can you climb to the top?

**Examples**:
```
Input: n = 2
Output: 2
Explanation: There are two ways to climb to the top.
1. 1 step + 1 step
2. 2 steps

Input: n = 3
Output: 3
Explanation: There are three ways to climb to the top.
1. 1 step + 1 step + 1 step
2. 1 step + 2 steps
3. 2 steps + 1 step
```

**Solution Approach**:
This is a classic Fibonacci problem. The number of ways to reach step n is the sum of ways to reach step n-1 and step n-2.

**Recurrence Relation**:
```
dp[i] = dp[i-1] + dp[i-2]
Base cases: dp[0] = 1, dp[1] = 1
```

**Python Solution**:
```python
def climbStairs(n):
    if n <= 1:
        return 1
    
    dp = [0] * (n + 1)
    dp[0] = 1
    dp[1] = 1
    
    for i in range(2, n + 1):
        dp[i] = dp[i-1] + dp[i-2]
    
    return dp[n]
```

**Space Optimized Solution**:
```python
def climbStairsOptimized(n):
    if n <= 1:
        return 1
    
    a, b = 1, 1  # dp[0], dp[1]
    for _ in range(2, n + 1):
        a, b = b, a + b  # b becomes dp[i], a becomes old b (dp[i-1])
    
    return b
```

**Time Complexity**: O(n)
**Space Complexity**: O(n) for DP array, O(1) for optimized version

---

### 2. House Robber
**Problem**: You are a professional robber planning to rob houses along a street. Each house has a certain amount of money stashed, the only constraint stopping you from robbing each of them is that adjacent houses have security systems connected and it will automatically contact the police if two adjacent houses were broken into on the same night.

**Examples**:
```
Input: nums = [1,2,3,1]
Output: 4
Explanation: Rob house 1 (money = 1) and then rob house 3 (money = 3).
Total amount you can rob = 1 + 3 = 4.

Input: nums = [2,7,9,3,1]
Output: 12
Explanation: Rob house 1 (money = 2), rob house 3 (money = 9) and rob house 5 (money = 1).
Total amount you can rob = 2 + 9 + 1 = 12.
```

**Solution Approach**:
For each house i, we have two choices:
1. Rob it: Then we cannot rob house i-1, so total = nums[i] + dp[i-2]
2. Skip it: Then total = dp[i-1]
We choose the maximum of these two options.

**Recurrence Relation**:
```
dp[i] = max(dp[i-1], dp[i-2] + nums[i])
Base cases: dp[0] = nums[0], dp[1] = max(nums[0], nums[1])
```

**Python Solution**:
```python
def rob(nums):
    if not nums:
        return 0
    if len(nums) <= 2:
        return max(nums)
    
    dp = [0] * len(nums)
    dp[0] = nums[0]
    dp[1] = max(nums[0], nums[1])
    
    for i in range(2, len(nums)):
        dp[i] = max(dp[i-1], dp[i-2] + nums[i])
    
    return dp[-1]
```

**Space Optimized Solution**:
```python
def robOptimized(nums):
    if not nums:
        return 0
    if len(nums) <= 2:
        return max(nums)
    
    prev2, prev1 = nums[0], max(nums[0], nums[1])
    
    for i in range(2, len(nums)):
        current = max(prev1, prev2 + nums[i])
        prev2, prev1 = prev1, current
    
    return prev1
```

**Time Complexity**: O(n)
**Space Complexity**: O(n) for DP array, O(1) for optimized version

---

### 3. Maximum Subarray Sum (Kadane's Algorithm)
**Problem**: Given an integer array nums, find the contiguous subarray (containing at least one number) which has the largest sum and return its sum.

**Examples**:
```
Input: nums = [-2,1,-3,4,-1,2,1,-5,4]
Output: 6
Explanation: [4,-1,2,1] has the largest sum = 6.

Input: nums = [1]
Output: 1

Input: nums = [5,4,-1,7,8]
Output: 23
```

**Solution Approach**:
At each position, we decide whether to start a new subarray at the current element or extend the previous subarray.

**Recurrence Relation**:
```
dp[i] = max(nums[i], dp[i-1] + nums[i])
```

**Python Solution**:
```python
def maxSubArray(nums):
    if not nums:
        return 0
    
    max_ending_here = max_so_far = nums[0]
    
    for i in range(1, len(nums)):
        max_ending_here = max(nums[i], max_ending_here + nums[i])
        max_so_far = max(max_so_far, max_ending_here)
    
    return max_so_far
```

**DP Array Solution** (for clarity):
```python
def maxSubArrayDP(nums):
    if not nums:
        return 0
    
    dp = [0] * len(nums)
    dp[0] = nums[0]
    
    for i in range(1, len(nums)):
        dp[i] = max(nums[i], dp[i-1] + nums[i])
    
    return max(dp)
```

**Time Complexity**: O(n)
**Space Complexity**: O(1) for optimized version, O(n) for DP array

---

### 4. Best Time to Buy and Sell Stock
**Problem**: You are given an array prices where prices[i] is the price of a given stock on the ith day.

You want to maximize your profit by choosing a single day to buy one stock and choosing a different day in the future to sell that stock.

**Examples**:
```
Input: prices = [7,1,5,3,6,4]
Output: 5
Explanation: Buy on day 2 (price = 1) and sell on day 5 (price = 6), profit = 6-1 = 5.

Input: prices = [7,6,4,3,1]
Output: 0
Explanation: In this case, no transaction is done, i.e., max profit = 0.
```

**Solution Approach**:
Track the minimum price seen so far and calculate the profit if sold today.

**Recurrence Relation** (implicit):
```
min_price = min(min_price, price[i])
max_profit = max(max_profit, price[i] - min_price)
```

**Python Solution**:
```python
def maxProfit(prices):
    if not prices:
        return 0
    
    min_price = float('inf')
    max_profit = 0
    
    for price in prices:
        min_price = min(min_price, price)
        max_profit = max(max_profit, price - min_price)
    
    return max_profit
```

**Alternative DP Formulation**:
```python
def maxProfitDP(prices):
    if not prices:
        return 0
    
    # dp[i][0] = max profit on day i with no stock held
    # dp[i][1] = max profit on day i with stock held
    dp = [[0, 0] for _ in range(len(prices))]
    dp[0][1] = -prices[0]  # Bought stock on day 0
    
    for i in range(1, len(prices)):
        dp[i][0] = max(dp[i-1][0], dp[i-1][1] + prices[i])  # Sell or do nothing
        dp[i][1] = max(dp[i-1][1], dp[i-1][0] - prices[i])  # Buy or do nothing
    
    return dp[-1][0]
```

**Time Complexity**: O(n)
**Space Complexity**: O(1) for optimized version, O(n) for DP array

---

### 5. Pascal's Triangle
**Problem**: Given an integer numRows, return the first numRows of Pascal's triangle.

**Examples**:
```
Input: numRows = 5
Output: [[1],[1,1],[1,2,1],[1,3,3,1],[1,4,6,4,1]]

Input: numRows = 1
Output: [[1]]
```

**Solution Approach**:
Each number is the sum of the two numbers directly above it.

**Recurrence Relation**:
```
dp[i][j] = dp[i-1][j-1] + dp[i-1][j]
Base cases: dp[i][0] = dp[i][i] = 1
```

**Python Solution**:
```python
def generate(numRows):
    if numRows == 0:
        return []
    
    triangle = [[1]]  # First row
    
    for i in range(1, numRows):
        row = [1]  # First element is always 1
        for j in range(1, i):
            # Each element is sum of two elements above it
            row.append(triangle[i-1][j-1] + triangle[i-1][j])
        row.append(1)  # Last element is always 1
        triangle.append(row)
    
    return triangle
```

**Time Complexity**: O(numRows^2)
**Space Complexity**: O(numRows^2) for output

---

### 6. Triangle
**Problem**: Given a triangle array, return the minimum path sum from top to bottom.

For each step, you may move to an adjacent number of the row below. More formally, if you are on index i on the current row, you may move to either index i or index i + 1 on the next row.

**Examples**:
```
Input: triangle = [[2],[3,4],[6,5,7],[4,1,8,3]]
Output: 11
Explanation: The minimum path sum from top to bottom is 2 + 3 + 5 + 1 = 11.

Input: triangle = [[-10]]
Output: -10
```

**Solution Approach**:
For each element, the minimum path to reach it comes from either the element directly above or the element above-left.

**Recurrence Relation**:
```
dp[i][j] = triangle[i][j] + min(dp[i-1][j-1], dp[i-1][j])
Base case: dp[0][0] = triangle[0][0]
```

**Python Solution**:
```python
def minimumTotal(triangle):
    if not triangle:
        return 0
    
    # Start from the second last row and move upwards
    for i in range(len(triangle)-2, -1, -1):
        for j in range(len(triangle[i])):
            # Update current element with minimum path sum from below
            triangle[i][j] += min(triangle[i+1][j], triangle[i+1][j+1])
    
    return triangle[0][0]
```

**Alternative Top-Down Solution**:
```python
def minimumTotalTopDown(triangle):
    if not triangle:
        return 0
    
    dp = [0] * len(triangle)
    dp[0] = triangle[0][0]
    
    for i in range(1, len(triangle)):
        # Update from right to left to avoid overwriting values we still need
        for j in range(i, -1, -1):
            if j == i:  # Right edge
                dp[j] = dp[j-1] + triangle[i][j]
            elif j == 31:Commented out/removed line:                 dp[j] = dp[j] + triangle[i][j]  # This line was commented out in the original but seems to be an error - corrected below
            elif j == 0:  # Left edge
                dp[j] = dp[j] + triangle[i][j]
            else:  # Middle elements
                dp[j] = min(dp[j-1], dp[j]) + triangle[i][j]
    
    return min(dp)
```

**Time Complexity**: O(n^2) Solution**:

Let me rewrite based on the original pattern INotice I see was an error in my rewrite. Let me provide the correct version:]: Space Complexity**: O(n) where n number of rows