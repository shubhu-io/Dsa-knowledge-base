# Dynamic Programming Cheat Sheet

## Core Concept

**Dynamic Programming (DP)** is an algorithmic technique for solving optimization problems by breaking them down into simpler subproblems and utilizing the fact that the optimal solution to the overall problem depends on the optimal solution to its subproblems.

DP is applicable when the problem has:
1. **Overlapping Subproblems**: The problem can be broken down into subproblems which are reused several times.
2. **Optimal Substructure**: An optimal solution to the problem contains within it optimal solutions to subproblems.

## When to Use DP
- Optimization problems (minimize/maximize something)
- Counting problems (count the number of ways to do something)
- Decision problems (determine if something is possible)
- Problems involving sequences, arrays, strings, trees, or grids
- When brute force solution is exponential but subproblems overlap

## Fundamental Steps in DP

### 1. **Define the State**
What does `dp[i]` or `dp[i][j]` represent?
- Must be sufficient to determine future choices
- Should be as small as possible while capturing necessary information

### 2. **Formulate the Recurrence**
How do we compute `dp[i]` from previous states?
- Identify all possible ways to reach state `i`
- Express `dp[i]` in terms of previous states
- Include base cases

### 3. **Determine the Order of Computation**
- Bottom-up: Fill table in order of increasing subproblem size
- Top-down: Use memoization with recursion

### 4. **Find the Answer**
Where is the final answer stored in our DP table?

## Common DP Patterns

### 1. **1D DP (Linear)**
`dp[i]` depends on a fixed number of previous values

**Examples**: Fibonacci, Climbing Stairs, House Robber, Max Subarray

**Template**:
```python
dp[0] = base1
dp[1] = base2
for i from 2 to n:
    dp[i] = f(dp[i-1], dp[i-2], ..., dp[i-k])
```

### 2. **2D DP (Grid)**
`dp[i][j]` depends on neighboring cells

**Examples**: Unique Paths, Edit Distance, Longest Common Subsequence

**Template**:
```python
for i from 1 to m:
    for j from 1 to n:
        dp[i][j] = f(dp[i-1][j], dp[i][j-1], dp[i-1][j-1])
```

### 3. **Knapsack Pattern**
`dp[i][w]` = best value using first i items with weight limit w

**Variants**: 0/1 Knapsack, Unbounded Knapsack, Coin Change

**0/1 Knapsack**:
```python
for i from 1 to n:
    for w from 0 to W:
        if weight[i] <= w:
            dp[i][w] = max(dp[i-1][w], dp[i-1][w-weight[i]] + value[i])
        else:
            dp[i][w] = dp[i-1][w]
```

**Unbounded Knapsack** (note forward iteration):
```python
for i from 1 to n:
    for w from weight[i] to W:
        dp[i][w] = max(dp[i-1][w], dp[i][w-weight[i]] + value[i])
# or with 1D array (forward iteration for unbounded):
for w from weight[i] to W:
    dp[w] = max(dp[w], dp[w-weight[i]] + value[i])
```

### 4. **String DP**
`dp[i][j]` often relates to prefixes/suffixes of two strings

**Examples**: Edit Distance, LCS, Longest Palindromic Substring

**Edit Distance**:
```python
if s1[i-1] == s2[j-1]:
    dp[i][j] = dp[i-1][j-1]
else:
    dp[i][j] = 1 + min(dp[i-1][j], dp[i][j-1], dp[i-1][j-1])  # delete, insert, replace
```

### 5. **DP on Intervals**
`dp[i][j]` = answer for substring/array from i to j

**Examples**: Palindromic Substrings, Matrix Chain Multiplication, Boolean Parenthesization

**Template**:
```python
for length from 2 to n:
    for i from 0 to n-length:
        j = i + length - 1
        dp[i][j] = f(dp[i][k], dp[k+1][j]) for k in [i, j-1]
```

### 6. **Tree DP**
`dp[node][state]` = answer for subtree rooted at node

**Examples**: Maximum Path Sum in Binary Tree, Vertex Cover on Tree

**Approach**: Post-order traversal, combine results from children

### 7. **Bitmask DP**
State represented by bits in an integer

**Examples**: Traveling Salesperson, Assignment Problems

**Template**:
```python
dp[mask][last] = min cost to visit cities in mask ending at last
for mask in all_subsets:
    for last in set_bits(mask):
        for next in unset_bits(mask):
            new_mask = mask | (1 << next)
            dp[new_mask][next] = min(dp[new_mask][next],
                                   dp[mask][last] + cost[last][next])
```

## State Definition Strategies

### By Dimensions
| Dimensions | Typical Use Cases |
|------------|-------------------|
| 1D (`dp[i]`) | Sequences where state depends on fixed predecessors |
| 2D (`dp[i][j]`) | Pairs of indices in two sequences, grid coordinates, i items with j weight |
| 3D (`dp[i][j][k]`) | Three varying parameters (less common) |
| +1 for boolean | Adding feasibility dimension (can/cannot achieve something) |

### Common State Meanings
- `dp[i]`: Best answer for prefix ending at i
- `dp[i][j]`: Best answer for substring s[i:j] or grid position (i,j)
- `dp[i][w]`: Best value using first i items with weight capacity w
- `dp[mask]`: Best answer for subset represented by bitmask
- `dp[i][j][k]`: Complex state with three parameters

## Initialization and Base Cases

### 1. **Empty/Zero Cases**
- `dp[0]` or `dp[0][0]` often represents empty input
- Set according to problem definition (0, 1, -inf, etc.)

### 2. **First Row/Column**
- Often represents boundaries or single-element cases
- Initialize based on problem constraints

### 3. **Impossible States**
- Use large positive number for minimization problems
- Use -1 or negative large for maximization problems
- Use 0 for counting problems where 0 ways is valid

### 4. **Multiple Starting Points**
- For problems where you can start anywhere (e.g., maximum subarray)
- Initialize all possible starting positions

## Computation Order

### 1. **Bottom-Up (Iterative)**
- Fill table in order of increasing complexity
- Ensure dependencies are computed before needed
- Common patterns:
  - Row by row, left to right (for grid DP)
  - Increasing substring length (for interval DP)
  - Increasing subset size (for bitmask DP)
  - Increasing knapsack capacity

### 2. **Top-Down (Memoization)**
- Recursive function with caching
- Natural expression of recurrence
- Automatic handling of dependency order
- May cause stack overflow for deep recursion

## Space Optimization Techniques

### 1. **Rolling Array**
When `dp[i]` depends only on last k rows:
```python
# Instead of dp[n+1][m+1]
dp = [[0] * (m+1) for _ in range(k+1)]
for i in range(1, n+1):
    curr = i % k
    prev = (i-1) % k
    for j in range(1, m+1):
        dp[curr][j] = f(dp[prev][j], dp[curr][j-1], ...)
```

### 2. **Two Rows/Columns**
Keep only current and previous row:
```python
prev = [0] * (m+1)
curr = [0] * (m+1)
for i in range(1, n+1):
    for j in range(1, m+1):
        curr[j] = f(prev[j], curr[j-1], prev[j-1])
    prev, curr = curr, [0] * (m+1)  # Reset current row
```

### 3. **In-Place Updates (Careful!)**
Only when safe (e.g., Fibonacci):
```python
a, b = 0, 1
for _ in range(n):
    a, b = b, a+b
```

### 4. **1D Optimization for 2D DP**
When `dp[i][j]` depends only on `dp[i-1][*]` and `dp[i][*-1]`:
```python
dp = [0] * (n+1)
for i in range(1, m+1):
    prev = 0  # dp[i-1][0]
    for j in range(1, n+1):
        temp = dp[j]  # Save current value (will become dp[i-1][j] next)
        dp[j] = f(dp[j], dp[j-1], prev)  # dp[j] is dp[i-1][j], dp[j-1] is dp[i][j-1]
        prev = temp  # Update prev for next iteration
```

## Common Mistakes and How to Avoid Them

### 1. **Incorrect State Definition**
**Symptom**: Can't express transitions clearly or missing information
**Fix**: Write out exactly what `dp[i]` represents. Test with examples.

### 2. **Missing Base Cases**
**Symptom**: Wrong answers for small inputs
**Fix**: Explicitly handle n=0, n=1, empty string cases.

### 3. **Wrong Transition Direction**
**Symptom**: Using future values that haven't been computed yet
**Fix**: Draw dependency graph. For bottom-up, ensure dependencies are computed first.

### 4. **Off-by-One Errors**
**Symptom**: Index out of bounds or wrong answers by consistent offset
**Fix**: Be consistent with 0-indexing vs 1-indexing. Test boundary cases.

### 5. **Incorrect Initialization**
**Symptom**: Everything is zero or wrong values propagate
**Fix**: Initialize based on meaning of state. Use appropriate sentinel values.

### 6. **Not Considering All Transitions**
**Symptom**: Missing better solutions
**Fix**: Enumerate all possible ways to reach current state.

### 7. **Space Optimization Errors**
**Symptom**: Optimized version gives different answer than unoptimized
**Fix**: Verify dependencies are preserved. Test unoptimized vs optimized versions.

### 8. **Integer Overflow**
**Symptom**: Negative numbers when positive expected, or vice versa
**Fix**: Use modulo if specified. Use larger data types if needed.

### 9. **Confusing Similar Problems**
**Symptom**: Applying wrong variation (e.g., permutation vs combination)
**Fix**: Clearly identify if order matters and if repetition is allowed.

### 10. **Incorrect Modulo Application**
**Symptom**: Wrong answers in modular arithmetic problems
**Fix**: Apply modulo at each step: `(a + b) % m = ((a % m) + (b % m)) % m`

## Optimization Strategies

### 1. **Early Termination**
Stop computation when answer is determined or impossible.

### 2. **Pruning Impossible States**
Skip states that clearly cannot lead to valid solutions.

### 3. **Preprocessing**
Sort inputs, remove duplicates, compute lookups.

### 4. **Algorithm Selection**
Choose between DP, greedy, divide-and-conquer based on problem properties.

### 5. **Meet-in-the-Middle**
For 2^n problems: split into two 2^(n/2) halves.

### 6. **Monotonic Queue Optimization**
For DP of form `dp[i] = min/max_{j in [i-k,i-1]} (dp[j] + C(i,j))` with special properties.

### 7. **Divide and Conquer Optimization**
When opt[i][j] ≤ opt[i][j+1] (Knuth optimization or Divide and Conquer DP).

### 8. **Convex Hull Trick**
When DP recurrence involves min/max of linear functions.

## Template Library

### Template 1: Fibonacci-style 1D DP
```python
def fibonacci_style(n):
    if n <= 1:
        return base_case(n)

    dp = [0] * (n + 1)
    dp[0] = base0
    dp[1] = base1

    for i in range(2, n + 1):
        dp[i] = f(dp[i-1], dp[i-2])

    return dp[n]
```

### Template 2: 2D Grid DP (row-major)
```python
def grid_dp(m, n):
    dp = [[0] * n for _ in range(m)]

    # Initialize boundaries
    for i in range(m):
        dp[i][0] = left_edge(i)
    for j in range(n):
        dp[0][j] = top_edge(j)

    for i in range(1, m):
        for j in range(1, n):
            if is_blocked(i, j):
                dp[i][j] = blocked_value
            else:
                dp[i][j] = f(dp[i-1][j], dp[i][j-1], diag_value)

    return dp[m-1][n-1]
```

### Template 3: 0/1 Knapsack
```python
def knapsack_01(W, weights, values):
    n = len(weights)
    dp = [[0] * (W + 1) for _ in range(n + 1)]

    for i in range(1, n + 1):
        for w in range(W + 1):
            if weights[i-1] <= w:
                dp[i][w] = max(dp[i-1][w],
                             dp[i-1][w-weights[i-1]] + values[i-1])
            else:
                dp[i][w] = dp[i-1][w]

    return dp[n][W]
```

### Template 4: Unbounded Knapsack (1D optimized)
```python
def knapsack_unbounded(W, weights, values):
    dp = [0] * (W + 1)

    for w in range(1, W + 1):
        for i in range(len(weights)):
            if weights[i] <= w:
                dp[w] = max(dp[w], dp[w-weights[i]] + values[i])

    return dp[W]
```

### Template 5: Edit Distance
```python
def edit_distance(s1, s2):
    m, n = len(s1), len(s2)
    dp = [[0] * (n + 1) for _ in range(m + 1)]

    for i in range(m + 1):
        dp[i][0] = i
    for j in range(n + 1):
        dp[0][j] = j

    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if s1[i-1] == s2[j-1]:
                dp[i][j] = dp[i-1][j-1]
            else:
                dp[i][j] = 1 + min(dp[i-1][j], dp[i][j-1], dp[i-1][j-1])  # delete, insert, replace

    return dp[m][n]
```

## Remember

1. **DP is about trade-off**: trading space for time by storing subproblem solutions
2. **State is key**: a good state definition makes everything else easier
3. **Base cases matter**: they anchor the entire computation
4. **Order is crucial**: dependencies must be resolved before use
5. **Optimize later**: get correct solution first, then optimize space/time
6. **Practice pattern recognition**: the more you solve, the faster you'll identify applicable patterns

With practice, you'll develop intuition for when to use DP, how to define states, and how to derive transitions efficiently. The patterns here cover most common DP problems encountered in interviews and competitive programming.