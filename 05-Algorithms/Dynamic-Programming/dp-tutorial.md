# Dynamic Programming Tutorial

## Introduction to Dynamic Programming

Dynamic Programming (DP) is an algorithmic technique for solving optimization problems by breaking them down into simpler subproblems and utilizing the fact that the optimal solution to the overall problem depends on the optimal solution to its subproblems. DP is particularly effective for problems that exhibit overlapping subproblems and optimal substructure.

### Key Concepts

1. **Overlapping Subproblems**: The problem can be broken down into subproblems which are reused several times. A recursive algorithm solves the same subproblem repeatedly, leading to exponential time complexity. DP solves each subproblem only once and stores the result.

2. **Optimal Substructure**: An optimal solution to the problem contains within it optimal solutions to subproblems. This property allows us to build up solutions to larger problems from solutions to smaller problems.

3. **Memoization vs Tabulation**:
   - **Memoization (Top-down)**: Solve the problem recursively and store results of subproblems to avoid recomputation.
   - **Tabulation (Bottom-up)**: Solve all related subproblems first, typically by filling up an n-dimensional table. Based on the results in the table, the solution to the original problem is computed.

### When to Use Dynamic Programming

DP is applicable when:
- The problem can be divided into stages with a decision required at each stage
- Each stage has a number of states associated with it
- The decision at each stage transforms one state into a state in the next stage
- The solution procedure aims to find the optimal sequence of decisions
- The principle of optimality holds: whatever the initial state and decisions are, the remaining decisions must constitute an optimal policy with regard to the state resulting from the first decision

### Steps to Develop a DP Solution

1. **Identify the subproblems**: Break the problem into smaller, overlapping subproblems
2
**Define the state**: Determine what information is needed to describe a subproblem
3
**Formulate the recurrence relation**: Express the solution to a subproblem in terms of solutions to smaller subproblems
4
**Identify the base cases**: Determine the solutions for the smallest subproblems
5
**Determine the order of computation**: Decide whether to use memoization (top-down) or tabulation (bottom-up)
6
**Build the solution**: Compute the solution to the original solution from the subproblem solutions
7
**Optimize space if possible**: Often we can reduce space complexity from O(n^n) to O(n^k) where k < n