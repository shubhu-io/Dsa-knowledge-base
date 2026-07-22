# Problem Solving Frameworks

Structured approaches to tackle any programming problem systematically.

## Framework 1: Polya's Four Steps (Adapted for Programming)

George Polya's classic framework, adapted for coding interviews.

### Step 1: Understand the Problem (2-3 minutes)

Ask yourself these questions before writing any code:

```
CHECKLIST:
[x] What are the inputs? (types, sizes, constraints)
[x] What are the outputs? (type, format)
[x] What are the edge cases? (empty, single, large)
[x] Are there any constraints? (time, space, values)
[x] Can I restate the problem in my own words?
[x] Are the examples clear? Do I understand why?
```

```python
# Example: "Find the majority element"
# INPUT: integer array of size n
# OUTPUT: the element that appears more than n/2 times
# CONSTRAINTS: 1 <= n <= 10^4, majority element always exists
# EDGE CASES: single element, two elements, all same
```

### Step 2: Devise a Plan (5-10 minutes)

```
PLANNING CHECKLIST:
[x] Can I solve a simpler version first?
[x] Is this similar to a problem I've seen before?
[x] Can I break it into subproblems?
[x] What data structures should I use?
[x] What's my brute force approach?
[x] Can I optimize from brute force?
```

### Step 3: Carry Out the Plan (15-20 minutes)

```
IMPLEMENTATION CHECKLIST:
[x] Write pseudocode first
[x] Handle edge cases explicitly
[x] Test with the given examples
[x] Test with edge cases
[x] Check for off-by-one errors
[x] Verify variable initialization
```

### Step 4: Review and Extend (3-5 minutes)

```
REVIEW CHECKLIST:
[x] Does it handle all edge cases?
[x] Can I simplify the code?
[x] What's the time and space complexity?
[x] Are there test cases I missed?
[x] How would I extend this solution?
```

---

## Framework 2: The STOP Method

**S**ee it, **T**hink it, **O**ptimize it, **P**rogram it

### See It (Understand)
```
- Read the problem twice
- Write down inputs and outputs
- Draw a small example
- Trace through manually
```

### Think It (Plan)
```
- Identify the problem type
- List possible approaches
- Choose the best approach
- Plan your code structure
```

### Optimize It (Improve)
```
- Can you reduce time complexity?
- Can you reduce space complexity?
- Are there redundant operations?
- Can you use a better data structure?
```

### Program It (Implement)
```
- Write clean, readable code
- Handle edge cases
- Add meaningful variable names
- Test thoroughly
```

---

## Framework 3: The Interviewer's Framework

What interviewers expect at each stage:

### Stage 1: Problem Clarification (2-5 min)
```
DO:
  "Can I ask a few clarifying questions?"
  "Is the input guaranteed to be non-empty?"
  "Should I handle duplicate values?"
  "What should I return if no solution exists?"

DON'T:
  Jump straight to coding
  Make assumptions without asking
  Waste too long on this phase
```

### Stage 2: Solution Exploration (5-10 min)
```
DO:
  Start with brute force
  Talk through your thinking
  Discuss trade-offs between approaches
  Draw examples and trace through

DON'T:
  Go silent for long periods
  Jump to code without a plan
  Ignore the interviewer's hints
```

### Stage 3: Coding (15-20 min)
```
DO:
  Write clean, modular code
  Use meaningful variable names
  Handle edge cases
  Think out loud while coding

DON'T:
  Write everything in one go without pausing
  Ignore the interviewer
  Write overly complex one-liners
```

### Stage 4: Testing (5-10 min)
```
DO:
  Test with the given examples
  Test edge cases
  Trace through your code manually
  Identify and fix any bugs

DON'T:
  Say "it works" without testing
  Skip edge case testing
  Ignore runtime errors
```

---

## Framework 4: The 4-Pillar Approach

Four pillars to evaluate any solution:

### Pillar 1: Correctness
```
CHECK:
  Does it produce the right answer for all inputs?
  Does it handle edge cases?
  Does it handle corner cases?
  Are there any infinite loops?
  Are there any off-by-one errors?
```

### Pillar 2: Efficiency
```
CHECK:
  What's the time complexity?
  What's the space complexity?
  Can we do better?
  Are there redundant computations?
  Can we use memoization?
```

### Pillar 3: Readability
```
CHECK:
  Are variable names descriptive?
  Is the code well-structured?
  Would another developer understand it?
  Are there unnecessary comments?
  Is the logic clear?
```

### Pillar 4: Maintainability
```
CHECK:
  Is the code modular?
  Are functions small and focused?
  Is it easy to modify?
  Are there clear boundaries?
  Is it testable?
```

---

## Framework 5: The Complexity Analyzer

A systematic way to analyze complexity:

### For Iterative Code
```python
# Step 1: Identify loops
total = 0
for i in range(n):          # n iterations
    for j in range(n):      # n iterations
        total += arr[i][j]  # O(1)
# Step 2: Multiply nested loops: n * n = n^2
# Step 3: Add sequential code: O(n^2)
```

### For Recursive Code
```python
# Step 1: Write recurrence relation
def merge_sort(arr):
    if len(arr) <= 1:       # O(1)
        return arr
    mid = len(arr) // 2     # O(1)
    left = merge_sort(arr[:mid])    # T(n/2)
    right = merge_sort(arr[mid:])   # T(n/2)
    return merge(left, right)       # O(n)

# Step 2: T(n) = 2T(n/2) + O(n)
# Step 3: Solve using Master Theorem
# a=2, b=2, f(n)=O(n) => O(n log n)
```

### Master Theorem Quick Reference
```
T(n) = aT(n/b) + O(n^d)

Compare log_b(a) with d:
  If log_b(a) > d => O(n^log_b(a))
  If log_b(a) = d => O(n^d * log n)
  If log_b(a) < d => O(n^d)

Examples:
  Merge sort:    a=2, b=2, d=1 => O(n log n)
  Binary search: a=1, b=2, d=0 => O(log n)
  Karatsuba:     a=3, b=2, d=1 => O(n^1.585)
  Strassen:      a=7, b=2, d=2 => O(n^2.807)
```

---

## Framework 6: The Debugging Framework

When your solution isn't working:

### Level 1: Quick Check
```
[x] Does it compile/parse?
[x] Are variable names consistent?
[x] Are all variables initialized?
[x] Are there typos?
```

### Level 2: Edge Case Testing
```
[x] Empty input
[x] Single element
[x] Two elements
[x] Already sorted
[x] Reverse sorted
[x] All same elements
[x] Maximum size input
[x] Negative numbers (if applicable)
```

### Level 3: Trace Through
```
[x] Pick a small example (n=5)
[x] Draw the state at each step
[x] Compare expected vs actual
[x] Find where they diverge
```

### Level 4: Divide and Conquer
```
[x] Comment out half the code
[x] Does it still fail?
[x] If yes, the bug is in the active half
[x] Repeat until bug is isolated
```

---

## Framework 7: The Data Structure Selector

Choose the right data structure for the problem:

```
Need to do this?                    Use this:
─────────────────────────────────────────────────────
Find element by index               Array
Find element by value               Hash Set / Hash Map
Find min/max frequently             Heap / Priority Queue
Maintain sorted order               BST / Balanced BST
FIFO processing                     Queue
LIFO processing / undo              Stack
Frequent insert/delete at end       Linked List
Frequent insert/delete at middle    Linked List
Random access + frequent insert     Dynamic Array (Python list)
Find group membership               Union-Find
Prefix matching                     Trie
Shortest path                       Graph (BFS/Dijkstra)
Level-order traversal               Queue (BFS)
Exhaustive search                   Stack/Recursion (DFS)
Top-K elements                      Min-Heap
K-th element                        Quickselect / Heap
```

### Decision Matrix

| Operation Needed | Array | LinkedList | HashMap | BST | Heap |
|-----------------|-------|-----------|---------|-----|------|
| Access by index | O(1) | O(n) | - | O(log n) | - |
| Search | O(n) | O(n) | O(1) avg | O(log n) | O(n) |
| Insert | O(n) | O(1)* | O(1) avg | O(log n) | O(log n) |
| Delete | O(n) | O(1)* | O(1) avg | O(log n) | O(log n) |
| Find min/max | O(n) | O(n) | O(n) | O(1) | O(1) |

*Assuming you already have the reference to the node

---

## Framework 8: The Optimization Framework

Step-by-step optimization process:

```
Step 1: Write brute force
         |
Step 2: Analyze complexity
         |
Step 3: Identify bottleneck
         |
         +-- Nested loops?  -----> Can you use a hash map?
         |
         +-- Repeated work? -----> Can you use memoization?
         |
         +-- Linear search? -----> Can you sort + binary search?
         |
         +-- Redundant space? ---> Can you optimize in-place?
         |
Step 4: Implement optimized version
         |
Step 5: Verify correctness
         |
Step 6: Analyze new complexity
```

### Example Walkthrough

**Problem**: Find all pairs in array that sum to target

```
Step 1: Brute force
  for i: for j: check arr[i] + arr[j] == target
  Time: O(n^2), Space: O(1)

Step 2: Analyze bottleneck
  We check every pair, but for each arr[i], we need
  target - arr[i]. If we could check that in O(1)...

Step 3: Hash map optimization
  For each element, check if complement exists in hash map

Step 4: Optimized code
  seen = {}
  for num in arr:
      if target - num in seen: return [seen[target-num], num]
      seen[num] = index

Step 5: Verify: O(n) time, O(n) space
```

---

## Common Problem Solving Mistakes

| Mistake | Prevention |
|---------|-----------|
| Not reading the problem fully | Read twice, write down constraints |
| Jumping to code too early | Spend 5-10 minutes planning |
| Ignoring edge cases | Make a checklist, test systematically |
| Overcomplicating solutions | Start with brute force |
| Not talking during interviews | Explain your thought process |
| Giving up too quickly | Try a different approach |
| Not testing your solution | Always trace through examples |
| Optimizing too early | Get correct first, optimize second |

---

## Quick Decision Framework

```
What type of problem is this?

  SEARCH --------> Is data sorted?
  |                   |         |
  |                  Yes        No
  |                   |         |
  |              Binary     Can you sort?
  |              Search       |       |
  |                          Yes      No
  |                           |       |
  |                      Sort+BS   Linear scan
  |
  OPTIMIZE -------> Overlapping subproblems?
  |                   |              |
  |                  Yes             No
  |                   |              |
  |              DP with          Greedy or
  |              memoization      two pointers
  |
  GENERATE ------> All possibilities?
  |                   |              |
  |                  All           Specific
  |                   |              |
  |              Backtracking    Build incrementally
  |
  CONNECT --------> Static or dynamic?
                      |              |
                    Static        Dynamic
                      |              |
                  BFS/DFS       Union-Find
```

---

## Time Management for Interviews

```
55-Minute Interview Breakdown:

  0-3 min:   Clarify the problem
  3-8 min:   Explore solutions, discuss trade-offs
  8-10 min:  Agree on approach with interviewer
 10-30 min:  Write the code
 30-40 min:  Test and debug
 40-50 min:  Optimize (if time permits)
 50-55 min:  Discuss complexity and alternatives
```

## Resources

- "How to Solve It" by George Polya
- "Cracking the Coding Interview" by Gayle McDowell
- "Think Like a Programmer" by V. Anton Spraul
- "Elements of Programming Interviews" by Adnan Aziz et al.
- NeetCode.io for pattern-based practice
