# Problem Solving

## Overview
Problem solving is the core skill in computer science and programming. It involves understanding problems, breaking them down, devising solutions, and implementing them effectively.

## Problem Solving Framework

### 1. Understand the Problem
- Read the problem carefully
- Identify inputs and outputs
- Determine constraints and edge cases
- Restate the problem in your own words
- Ask clarifying questions if needed

### 2. Explore Examples
- Work through simple examples manually
- Try edge cases (empty inputs, single elements, large values)
- Look for patterns in the examples
- Consider what makes the problem difficult

### 3. Develop a Plan
- Break the problem into smaller subproblems
- Consider different approaches (brute force, greedy, DP, etc.)
- Choose the most appropriate algorithm/data structure
- Outline the steps in pseudocode
- Estimate time and space complexity

### 4. Implement the Solution
- Write clean, readable code
- Choose appropriate data structures
- Handle edge cases properly
- Follow coding best practices and style guides
- Test incrementally as you build

### 5. Review and Optimize
- Test with various inputs (including edge cases)
- Analyze time and space complexity
- Look for optimization opportunities
- Consider alternative approaches
- Refactor for clarity and efficiency

## Common Problem Solving Patterns

### 1. Brute Force
- Try all possible solutions
- Good for small input sizes
- Baseline for comparison
- Often O(n²) or worse

### 2. Greedy Algorithms
- Make locally optimal choices
- Works when problem has greedy choice property
- Examples: Activity selection, Huffman coding
- Usually O(n log n) due to sorting

### 3. Dynamic Programming
- Break into overlapping subproblems
- Store results to avoid recomputation
- Optimal substructure property required
- Can be top-down (memoization) or bottom-up
- Examples: Fibonacci, Knapsack, LCS

### 4. Divide and Conquer
- Divide problem into subproblems
- Conquer subproblems recursively
- Combine solutions
- Examples: Merge sort, Quick sort, Binary search
- Often leads to O(n log n) solutions

### 5. Backtracking
- Build solution incrementally
- Backtrack when constraints violated
- Systematic exploration of solution space
- Examples: N-Queens, Sudoku, Permutations
- Can be exponential but pruned by constraints

### 6. Two Pointers
- Use two pointers to traverse data
- Often for sorted arrays or linked lists
- Reduces time complexity from O(n²) to O(n)
- Examples: Pair sum, Palindrome check, Merge sorted arrays

### 7. Sliding Window
- Maintain a window that slides through data
- Useful for substring/subarray problems
- Typically O(n) time complexity
- Examples: Maximum sum subarray, Longest substring without repeating characters

### 8. Recursion
- Function calls itself
- Must have base case to terminate
- Good for tree/graph traversals
- Can lead to stack overflow if not careful
- Often converted to iterative solutions

## Essential Techniques

### 1. Sorting First
- Many problems become easier after sorting
- Enables two-pointer technique
- Facilitates binary search
- Examples: Meeting rooms, Interval merging, Three sum

### 2. Hashing
- O(1) average lookup/insertion
- Great for counting frequencies
- Useful for finding pairs/triplets
- Watch out for hash collisions and space usage

### 3. Preprocessing
- Do work upfront to speed up queries
- Prefix sums for range queries
- Sorting for binary search
- Building indices for faster lookups

### 4. Space-Time Tradeoffs
- Sometimes using extra space reduces time
- Examples: Hash tables vs sorting, Lookup tables
- Consider memory constraints in embedded systems

### 5. Invariant Maintenance
- Keep certain properties true throughout algorithm
- Helps in proving correctness
- Examples: Heap property, BST property, Loop invariants

## Common Mistakes to Avoid

### 1. Not Understanding the Problem
- Jumping to solution without full comprehension
- Missing edge cases or constraints
- Solving the wrong problem

### 2. Overcomplicating Solutions
- Using advanced techniques when simple ones work
- Not starting with brute force as baseline
- Premature optimization

### 3. Ignoring Edge Cases
- Empty inputs
- Single element inputs
- Large inputs (overflow concerns)
- Duplicate values
- Negative numbers (when not expected)

### 4. Poor Testing
- Not testing with examples from problem statement
- Missing corner cases
- Only testing happy path
- Not verifying correctness

### 5. Code Quality Issues
- Unreadable variable names
- Lack of comments for complex logic
- Not handling errors/exceptions
- Violating language conventions

## Practice Strategy

### 1. Start Simple
- Begin with easy problems to build confidence
- Master basic patterns before moving to hard ones
- Focus on correctness before optimization

### 2. Learn by Doing
- Implement algorithms from scratch first
- Then use built-in libraries for efficiency
- Understand what libraries are doing underneath

### 3. Pattern Recognition
- Categorize problems by type
- Learn signature techniques for each type
- Build a mental library of problem-solving approaches

### 4. Time Yourself
- Practice under timed conditions (like interviews)
- Start with generous time limits, then reduce
- Learn to identify when to move on from a problem

### 5. Review Thoroughly
- Re-solve problems after a few days
- Compare different approaches
- Explain your solution to someone else
- Identify what you would do differently next time

## Resources
- Books: "Cracking the Coding Interview", "Elements of Programming Interviews"
- Websites: LeetCode, Codeforces, GeeksforGeeks, HackerRank
- Practice: Start with easy problems, gradually increase difficulty
- Community: Discuss solutions, learn from others' approaches

Remember: Problem solving is a skill that improves with deliberate practice. The key is not just solving many problems, but learning from each one and building your intuition for which approaches work in different situations.
