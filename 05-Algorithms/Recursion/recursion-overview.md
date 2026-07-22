# Recursion Overview

## What is Recursion?
Recursion is a programming technique where a function calls itself to solve a problem by breaking it down into smaller, identical subproblems.

## Key Components
- **Base Case**: Stops the recursion
- **Recursive Case**: Breaks problem into smaller instances

## Types
- Direct Recursion: Function calls itself
- Indirect Recursion: Functions call each other
- Tail Recursion: Recursive call is last operation
- Head Recursion: Recursive call is first operation

## When to Use
- Naturally recursive problems (trees, factorials)
- When recursive solution is cleaner
- For backtracking algorithms
- When depth is reasonable (<1000 calls)

## Advantages
- Simplicity and elegance
- Natural fit for tree-like problems
- Reduced code complexity

## Disadvantages
- Function call overhead
- Stack space usage
- Risk of stack overflow
- Potential recomputation

## Common Examples
- Factorial calculation
- Fibonacci sequence
- Tree traversals (pre/in/post-order)
- Binary search
- Sorting (merge/quick sort)
- Backtracking (N-Queens, Sudoku)

## Related Topics
- Dynamic Programming (memoization)
- Backtracking
- Divide and Conquer
- Tail Call Optimization

## Practice Suggestions
Start with simple problems like factorial, Fibonacci, and basic tree traversals before moving to complex backtracking problems.
