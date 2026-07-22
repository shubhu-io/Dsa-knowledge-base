# Dynamic Programming (DP) Overview

## What is Dynamic Programming?
Dynamic Programming is a method for solving complex problems by breaking them down into simpler subproblems. It is applicable when the problem can be divided into overlapping subproblems that can be solved independently.

## Key Concepts

### Optimal Substructure
A problem has optimal substructure if an optimal solution can be constructed from optimal solutions of its subproblems.

### Overlapping Subproblems
When a recursive algorithm would visit the same subproblems repeatedly, the problem has overlapping subproblems.

## Approaches to DP

### 1. Memoization (Top-Down)
- Solve the problem recursively
- Store results of subproblems to avoid recomputation
- Natural but may use stack space

### 2. Tabulation (Bottom-Up)
- Solve all related subproblems first
- Build up solutions to larger subproblems
- Iterative, usually more space-efficient

## When to Use DP
Use DP when:
- Problem can be divided into stages
- Decision at each stage affects future states
- Same subproblems are solved multiple times
- Optimal solution depends on solutions to subproblems

## Common DP Patterns

### 1. 1D/Linear DP
Examples: Fibonacci, Climbing Stairs, House Robber
- State: dp[i] = answer for prefix ending at i
- Transition: dp[i] = f(dp[i-1], dp[i-2], ...)

### 2. 2D/Grid DP
Examples: Unique Paths, Minimum Path Sum, Edit Distance
- State: dp[i][j] = answer for subgrid (0,0) to (i,j)
- Transition: Depends on neighboring cells

### 3. Interval DP
Examples: Matrix Chain Multiplication, Palindrome Partitioning
- State: dp[i][j] = answer for substring i to j
- Transition: Try all possible splits k: dp[i][j] = f(dp[i][k], dp[k+1][j])

### 4. Knapsack DP
Examples: 0/1 Knapsack, Unbounded Knapsack
- State: dp[i][w] = max value using first i items with weight w
- Transition: Include or exclude current item

## Steps to Solve DP Problems

### 1. Identify the State
What information defines a subproblem?
- Position/index
- Count/amount
- Bitmask (for subsets)
- Other relevant parameters

### 2. Define State Transition
How do we compute the current state from previous states?
- Write recurrence relation
- Consider all possible choices/decisions

### 3. Determine Base Cases
What are the smallest subproblems?
- Usually when index is 0 or size isEmpty string
3)
- Any bottom: condismal/5

4. Implementation  
Choose:  
- Top-down (recursive + memoization)  
- Bottom-up (iterative)  

### 5. Optimize if Needed  
- Space optimization (e.g., rolling arrays)  
- Time optimization (e.g., prefix sums)  

## Classic Examples  

### Fibonacci Sequence  
- F(0) = 0, F(1) = 1  
- F(n) = F(n-1) + F(n-2) for n ≥ 2  

How to: 0, 1, 1, 2, 3, 5, 8, ...

### Coin Change  
Given coins [1,2,5] and amount 11:  
Minimum coins needed is 3 (5+5+1)  

DP approach:  
dp[0] = 0  
For each coin:  
  for amount from coin to target:  
    dp[amount] = min(dp[amount], dp[amount-coin] + 1)

### Longest Increasing Subsequence (LIS)  
Find longest subsequence (not necessarily contiguous)  
where elements are in increasing order  

DP approach:  
dp[i] = length of LIS ending at index i  
dp[i] = max(dp[j] + 1) for all j < i where nums[j] < nums[i]  
Answer = max(dp[i]) for all i  

## Key Tips  

1. Start with brute force to understand problem  
2. Look for patterns in subproblems  
3. Consider both directions (forward/backward)  
4. Think about what information you need to store  
5. Test with small examples first  
6. Check base cases carefully  
7. Optimize space when possible  
8. Verify the transition logic  

## When NOT to Use DP  
- No overlapping subproblems (use divide and conquer)  
- Greedy choice property holds (use greedy)  
- Problem doesn't have optimal substructure  
- Simple mathematical formula exists  

## State Reduction Techniques  
- Only keep last k states  
- Use rolling array for 1D DP  
- Compress state space  
- Meet in the middle for large states  

## Time/Space Complexity  
- Time: Usually O(number of states × cost per state)  
- Space: O(number of states stored)  
- Often trade space for time or vice versa  

## Practice Problems  
Beginner:  
1. Fibonacci Number  
2. Climbing Stairs  
3. House Robber  
4. Coin Change  
5. Jump Game  

Intermediate:  
1. Longest Increasing Subsequence  
2. Longest Common Subsequence  
3. Edit Distance  
4. Word Break  
5. Unique Paths  

Advanced:  
1. Regular Expression Matching  
2. Distinct Subsequences  
3. Interleaving String  
4. Palindrome Partitioning II  
5. Cherry Pickup  

## Resources  
- Book: "Introduction to Algorithms" by CLRS (Dynamic Programming chapter)  
- Website: GeeksforGeeks DP section  
- Platform: LeetCode Dynamic Programming tag  
- Video: MIT OCW 6.006 Dynamic Programming lectures  
- Practice: Codeforces DP educational rounds  

Remember: The key to mastering DP is practice. Start with simple problems, understand the pattern, then move to more complex variations.
