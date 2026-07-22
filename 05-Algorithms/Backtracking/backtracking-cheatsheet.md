# Backtracking Cheat Sheet

## Core Concept

**Backtracking** is a general algorithm for finding all (or some) solutions to computational problems, notably constraint satisfaction problems, that incrementally builds candidates to the solutions and abandons a candidate ("backtracks") as soon as it determines that the candidate cannot possibly be completed to a valid solution.

## When to Use Backtracking
- Need to find all or some solutions
- Solution can be constructed incrementally
- Constraints can be checked early (enabling pruning)
- Problem exhibits optimal substructure (not for optimization, but for constraint satisfaction)
- Search space is discrete and finite

## Backtracking Template

### Recursive Form
```python
def backtrack(candidates, state, solutions):
    # BASE CASE: If state is a complete solution
    if is_solution(state):
        solutions.append(list(state))  # Make a copy
        return
    
    # PRUNING: If state cannot lead to solution, abandon this path
    if not is_promising(state):
        return
    
    # RECURSE: Try each candidate
    for candidate in get_candidates(state):
        # MAKE CHOICE
        state.append(candidate)
        make_change(state, candidate)
        
        # EXPLORE FURTHER
        backtrack(candidates, state, solutions)
        
        # UNDO CHOICE (BACKTRACK)
        undo_change(state, candidate)
        state.pop()
```

### Iterative Form (Explicit Stack)
```python
def backtrack_iterative(candidates):
    stack = [([], 0)]  # (current_state, next_index)
    solutions = []
    
    while stack:
        state, index = stack.pop()
        
        if is_solution(state):
            solutions.append(list(state))
            continue
            
        if index >= len(candidates):
            continue
            
        # Option 1: Skip current candidate
        stack.append((state, index + 1))
        
        # Option 2: Take current candidate (if valid)
        new_state = state + [candidates[index]]
        if is_promising(new_state):
            stack.append((new_state, 0))  # Reset index for next level
            
    return solutions
```

## Key Functions to Implement

### 1. `is_solution(state)`
Determines if current state represents a complete solution.
```python
def is_solution(state):
    # Example: for combinations of size k
    return len(state) == k
```

### 2. `is_promising(state)`
Determines if current state can potentially lead to a solution (PRUNING).
```python
def is_promising(state):
    # Example: for subset sum, check if sum <= target
    return sum(state) <= target
```

### 3. `get_candidates(state)`
Returns list of valid choices that can extend current state.
```python
def get_candidates(state):
    # Example: for combinations, return numbers greater than last used
    start = state[-1] + 1 if state else 1
    return list(range(start, n+1))
```

### 4. `make_change(state, choice)` / `undo_change(state, choice)`
Modify and restore state when making/undoing choices.
```python
def make_handle(state, choice):
    state.append(choice)
    # Update any auxiliary data structures

def undo_handle(state, choice):
    state.pop()
    # Restore any auxiliary data structures
```

## Common State Representations

| Problem Type | State Representation | Purpose |
|--------------|---------------------|---------|
| Combinations | List of chosen elements | Track what's been selected |
| Permutations | List + used[] boolean array | Track order and usage |
| Subsets | List of chosen elements | Build power set |
| Board Games | 2D grid/matrix | Represent game board state |
| String Problems | Index/position + current string | Track parsing progress |
| Numerical Problems | Current sum/product + list | Track arithmetic expressions |
| Graph Problems | Path/node list + visited set | Track traversal state |

## Essential Patterns

### 1. Combination Pattern (Order Doesn't Matter)
```python
def backtrack(start, path):
    if len(path) == k:
        result.append(list(path))
        return
    
    for i in range(start, n):
        path.append(nums[i])
        backtrack(i + 1, path)  # i+1 to avoid reuse
        path.pop()
```
**Variations**:
- Allow reuse: `backtrack(i, path)` instead of `i+1`
- With duplicates: Skip if `i > start and nums[i] == nums[i-1]`

### 2. Permutation Pattern (Order Matters)
```python
def backtrack(path, used):
    if len(path) == n:
        result.append(list(path))
        return
    
    for i in range(n):
        if not used[i]:
            used[i] = True
            path.append(nums[i])
            backtrack(path, used)
            path.pop()
            used[i] = False
```

### 3. Subset Pattern (All Sizes)
```python
def backtrack(start, path):
    result.append(list(path))  # Add every prefix
    
    for i in range(start, n):
        path.append(nums[i])
        backtrack(i + 1, path)
        pop()
```

### 4. Board/Grid Pattern
```python
def backtrack(row, col):
    if is_solution(board):
        process_solution()
        return
    
    for val in possible_values:
        if is_valid(board, row, col, val):
            place_piece(board, row, col, val)
            next_row, next_col = get_next_position(row, col)
            backtrack(next_row, next_col)
            remove_piece(board, row, col, val)  # Backtrack
```

### 5. String Partition Pattern
```python
def backtrack(start, path):
    if start == len(s):
        result.append(list(path))
        return
    
    for end in range(start + 1, len(s) + 1):
        prefix = s[start:end]
        if is_valid(prefix):
            path.append(prefix)
            backtrack(end, path)
            path.pop()
```

### 6. Numerical Expression Pattern
```python
def backtrack(index, path, current_value, prev_value):
    if index == len(num_str):
        if current_value == target:
            result.append("".join(path))
        return
    
    for i in range(index, len(num_str)):
        if i > index and num_str[index] == '0':  # No leading zero
            break
        
        curr_str = num_str[index:i+1]
        curr_num = int(curr_str)
        
        if index == 0:  # First number
            backtrack(i+1, path + [curr_str], curr_num, curr_num)
        else:
            # Addition
            backtrack(i+1, path + ['+', curr_str], 
                     current_value + curr_num, curr_num)
            # Subtraction
            backtrack(i+1, path + ['-', curr_str], 
                     current_value - curr_num, -curr_num)
            # Multiplication
            backtrack(i+1, path + ['*', curr_str], 
                     current_value - prev_val + prev_val * curr_num, 
                     prev_val * curr_num)
```

## Pruning Techniques

### 1. **Constraint-Based Pruning**
Stop when current partial solution violates constraints.
```python
# Example: N-Queens
if not is_safe(row, col):  # Check if queen placement is valid
    return  # Prune this branch
```

### 2. **Bound-Based Pruning**
Stop when it's impossible to improve upon current best.
```python
# Example: Combination Sum (finding minimum)
if current_sum > target:
    return  # Prune - sum already too big
```

### 3. **Look-Ahead Pruning**
Predict if future choices will lead to dead end.
```python
# Example: Sudoku
def is_solvable(board):
    # Check if any empty cell has zero possible values
    for each empty cell:
        if count_possible_values(cell) == 0:
            return False
    return True
```

### 4. **Symmetry Breaking**
Avoid exploring equivalent solutions.
```python
# Example: Avoid duplicate permutations
if i > 0 and nums[i] == nums[i-1] and not used[i-1]:
    continue  # Skip duplicate
```

### 5. **Forward Checking**
Look ahead to see if choice leads to immediate contradiction.
```python
# Example: Graph coloring
def is_safe(node, color):
    for neighbor in graph[node]:
        if colors[neighbor] == color:
            return False
    return True
```

## Optimization Strategies

### 1. **Variable Ordering (Most Constrained First)**
Choose the variable with fewest legal values next.
```python
# Instead of fixed order, pick variable with minimum domain
def select_unassigned_variable(variables, domains):
    return min(variables, key=lambda v: len(domains[v]))
```

### 2. **Value Ordering (Least Constraining Value)**
Try values that leave most options for neighboring variables.
```python
def order_domain_values(var, domain):
    # Sort by how many options they eliminate from neighbors
    return sorted(domain, key=lambda val: count_constraints_removed(var, val))
```

### 3. **Constraint Propagation**
Enforce constraints early to reduce search space.
```python
# Example: Sudoku - eliminate impossible values from peers
def propagate_constraints(board, row, col, digit):
    # Remove digit from same row, column, and box
    # If any cell ends up with zero options, contradiction found
```

### 4. **Memoization (Dynamic Programming + Backtracking)**
Cache results of subproblems.
```python
memo = {}
def backtrack(state):
    if state in memo:
        return memo[state]
    # ... compute result ...
    memo[state] = result
    return result
```

### 5. **Iterative Deepening**
Combine BFS completeness with DFS efficiency.
```python
def iterative_deepening(root):
    for depth in range(MAX_DEPTH):
        result = depth_limited_search(root, depth)
        if result is not None:
            return result
    return None
```

## Common Problem Types and Variations

### A. Combination Problems
| Problem | Variations | Key Points |
|---------|------------|------------|
| Combinations | k-combinations from n | Order doesn't matter |
| Combination Sum | Reuse allowed/not allowed | Sum constraint |
| Combination Sum II | Duplicates in input, no reuse | Handle duplicates |
| Combination Sum III | Fixed size (k=9), 1-9 only | Additional constraints |

### B. Permutation Problems
| Problem | Variations | Key Points |
|---------|------------|------------|
| Permutations | Distinct elements | Used[] array |
| Permutations II | With duplicates | Skip duplicates |
| Permutation Sequence | k-th permutation | Factorial number system |
| Next Permutation | In-place modification | Specific algorithm |

### C. Subset Problems
| Problem | Variations | Key Points |
|---------|------------|------------|
| Subsets | All sizes | Include empty set |
| Subsets II | With duplicates | Skip duplicates |
| Subarray Problems | Contiguous elements | Sliding window often better |
| Partition Problems | Divide into groups | Sum/product constraints |

### D. Board Games & Puzzles
| Problem | Key Techniques |
|---------|----------------|
| N-Queens | Column, diagonal tracking |
| Sudoku | Row/col/box constraints, backtracking |
| Word Search | DFS + pruning, Trie optimization |
| Solve Sudoku | Constraint propagation + backtracking |
| Word Search II | Trie + DFS + pruning |

### E. String Problems
| Problem | Key Techniques |
|---------|----------------|
| Word Break | DP + backtracking, memoization |
| Word Break II | Memoization to avoid recomputation |
| Generate Parentheses | Open/close count tracking |
| Remove Invalid Parentheses | Min removal calculation first |
| Restore IP Addresses | Segment validation (0-255, no leading zero) |

### F. Numerical Problems
| Problem | Key Techniques |
|---------|----------------|
| Expression Add Operators | precedence handling (multiply first) |
| Split Array Fibonacci | Leading zero, overflow checks |
| Factor Combinations | Start from 2, avoid duplicates |
| Euclidean Algorithm Variants | GCD/LCM based constraints |

## Data Structures for Efficient Backtracking

### 1. **Boolean Arrays** (for used/unused tracking)
```python
used = [False] * n  # O(1) access/update
```

### 2. **Bitsets** (for small n)
```python
# Use integer bits to represent used state
# Bit i set means element i is used
state |= (1 << i)  # Mark as used
state &= ~(1 << i)  # Mark as unused
if state & (1 << i):  # Check if used
```

### 3. **Sets/Hash Tables** (for dynamic constraints)
```python
cols = set()      # Used columns
diag1 = set()     # r - c (main diagonal)
diag2 = set()     # r + c (anti-diagonal)
```

### 4. **Frequency Counters** (for duplicate handling)
```python
from collections import Counter
count = Counter(nums)
# Decrement when using, increment when backtracking
```

### 5. **Boolean Matrices** (for subgrid tracking)
```python
# For Sudoku: rows[9][9], cols[9][9], boxes[9][9]
rows[row][num] = True  # Number used in row
```

## Complexity Analysis

### Time Complexity
- **Worst Case**: O(k^n) where k = avg branching factor, n = depth
- **With Pruning**: Often much better, depends on problem constraints
- **Examples**:
  - Permutations: O(n!)  
  - Combinations: O(C(n,k)) = O(n choose k)
  - Subsets: O(2^n)
  - N-Queens: O(n!) (much better than O(n^n))
  - Sudoku: O(9^(n*n)) worst case, but practical due to pruning

### Space Complexity
- **Recursion Stack**: O(n) where n = depth of recursion
- **State Storage**: O(n) for current solution being built
- **Auxiliary Data**: Varies by problem (O(n²) for boards, O(n) for arrays, etc.)
- **Result Storage**: O(number_of_solutions × solution_size)

## Common Mistakes and How to Avoid Them

### 1. Forgetting to Undo Changes (State Corruption)
**Mistake**: Modifying state but not restoring it when backtracking
**Fix**: Always pair modifications with restoration
```python
# WRONG
state.append(value)
make_change(state, value)
backtrack(...)
# Forgot to undo!

# CORRECT
state.append(value)
make_change(state, value)
backtrack(...)
undo_change(state, value)  # Essential!
state.pop()
```

### 2. Inefficient State Copying
**Mistake**: Making deep copies at every step when not needed
**Fix**: Use mutable state with explicit undo operations
```python
# INEFFICIENT (O(n) copy at each call)
def backtrack(path):
    if is_solution(path):
        result.append(list(path))  # Still need copy for result
        return
    for choice in choices:
        new_path = path + [choice]  # O(n) copy!
        backtrack(new_path)

# EFFICIENT
def backtrack(path):
    if is_solution(path):
        result.append(list(path))  # Only copy when needed
        return
    for choice in choices:
        path.append(choice)
        make_change(...)
        backtrack(...)
        undo_change(...)
        population()  # O(1)
```

### 3. Missing Base Cases
**Mistake**: Infinite recursion or premature termination
**Fix**: Clearly define all termination conditions
```python
def backtrack(state):
    # SUCCESS: Found valid solution
    if is_solution(state):
        process_solution()
        return
    
    # FAILURE: Cannot be extended to solution
    if not is_promising(state):
        return  # Prune
    
    # EXHAUSTION: No more choices to try
    if not get_candidates(state):
        return  # Backtrack naturally
    
    # NORMAL CASE: Try extensions
    for choice in get_candidates(state):
        # ... recursion ...
```

### 4. Not Handling Duplicates Properly
**Mistake**: Generating duplicate solutions
**Fix**: Sort input and skip duplicates at same recursion level
```python
# WRONG - generates duplicates for input [1,1,2]
def backtrack(path):
    if len(path) == k:
        result.append(list(path))
        return
    for i in range(len(nums)):
        if not used[i]:
            used[i] = True
            path.append(nums[i])
            backtrack(path)
            path.pop()
            used[i] = False

# CORRECT
def backtrack(start, path):
    if len(path) == k:
        result.append(list(path))
        return
    for i in range(start, len(nums)):
        if i > start and nums[i] == nums[i-1]:  # Skip duplicates
            continue
        if not used[i]:
            used[i] = True
            path.append(nums[i])
            backtrack(i+1, path)  # or i depending on reuse
            path.pop()
            used[i] = False
```

### 5. Incorrect Pruning Conditions
**Mistake**: Pruning too aggressively (cutting valid solutions) or not enough
**FIX**: Validate pruning conditions with small examples
```python
# Test your pruning logic:
def test_pruning():
    # Case 1: Should NOT prune (valid solution exists)
    state1 = [1, 2]  # For target=6, k=3
    assert is_promising(state1) == True  # [1,2,3] works
    
    # Case 2: Should prune (cannot reach target)
    state2 = [4, 4]  # For target=6, k=3
    assert is_promising(state2) == False  # Min sum > 6
    
    # Case 3: Should prune (already exceeded)
    state3 = [5, 2]  # For target=6, k=2
    assert is_promising(state3) == False  # Sum already 7 > 6
```

### 6. Not Considering All Choices
**Mistake**: Missing valid candidates in get_candidates()
**FIX**: Double-check candidate generation logic
```python
# For combinations from 1..n:
def get_candidates(state):
    if not state:
        return list(range(1, n+1))  # Start from 1
    else:
        # Start from last_element + 1 to maintain order
        return list(range(state[-1]+1, n+1))
    
# WRONG: return list(range(1, n+1)) always - allows [2,1] which violates ordering
```

### 7. Incorrect State Restoration
**Mistake**: Not restoring auxiliary data structures properly
**FIX**: Track all state changes and reverse them exactly
```python
# For Sudoku with row/col/box tracking:
def place_number(row, col, num):
    board[row][col] = num
    rows[row][num] = True
    cols[col][num] = True
    boxes[3*(row//3) + col//3][num] = True

def remove_number(row, col, num):
    board[row][col] = '.'
    rows[row][num] = False  # Exact inverse
    cols[col][num] = False
    boxes[3*(row//3) + col//3][num] = False
```

## Language-Specific Tips

### Python
- Use list.append()/pop() for O(1) stack operations
- Be careful with mutable default arguments
- Use `nonlocal` for nested function state modification
- Consider generators (`yield`) for memory efficiency
- `@lru_cache` for memoization (hashable arguments only)

### Java/C++
- Backtracking often more natural with mutable state
- Remember to undo all changes (arrays, objects, etc.)
- Pass by reference when modifying large structures
- Consider early returns to minimize nesting
- Use `Arrays.fill()` for efficient array reset

### JavaScript
- Watch out for array/object mutation side effects
- Use slice() or spread `[...]` for copying when needed
- Be aware of limited tail call optimization
- Use Map/Set for efficient lookups instead of object properties when appropriate

## Decision Flow: Should You Use Backtracking?

```
Start
 |
 |-> Is the problem asking for ALL or SOME solutions? 
 |        |
 |        No -> Try other approaches (DP, Greedy, etc.)
 |        |
 |        Yes
 |
 |-> Can solution be built incrementally?
 |        |
 |        No -> Not suitable for backtracking
 |        |
 |        Yes
 |
 |-> Can constraints be checked PARTIALLY (early pruning)?
 |        |
 |        No -> May still work but less efficient
 |        |
 |        Yes
 |
 |-> Is search space manageable with pruning?
 |        |
 |        No -> Consider heuristics, approximation, or other methods
 |        |
 |        Yes -> USE BACKTRACKING
```

## Advanced Variations

### 1. **Branch and Bound**
Extension for optimization problems (find best solution, not just any solution)
- Keep track of best solution found so far
- Prune if current path cannot beat best solution
- Used for: Traveling Salesman, Knapsack variants

### 2. **Iterative Deepening Depth-First Search (IDDFS)**
Combines benefits of BFS (optimal depth) and DFS (space efficiency)
- Perform DFS with increasing depth limits
- Useful when solution depth unknown but bounded
- Memory: O(d) where d = depth limit
- Time: O(b^d) where b = branching factor

### 3. **Bidirectional Search**
Search from both start and goal simultaneously
- Effective when branching factor is high
- Meet-in-the-middle approach
- Memory intensive but can be much faster

### 4. **Constraint Programming**
Specialized solvers for constraint satisfaction
- AI-based techniques like arc consistency
- More sophisticated than basic backtracking
- Libraries: OR-Tools, Choco, Gecode

## Summary

### Key Takeaways
1. **Backtracking = DFS + Pruning**
2. **State Representation** is crucial - choose wisely
3. **Pruning** makes exponential problems tractable
4. **Always undo** your changes (state mutation symmetry)
5. **Start simple**, then optimize
6. **Test comprehensively** with edge cases

### When to Choose Backtracking Over Alternatives
| Approach | Use When |
|----------|----------|
| **Backtracking** | Need all/some solutions, constraints checkable early |
| **Dynamic Programming** | Optimization problems with overlapping subproblems |
| **Greedy** | Optimization problems with optimal substructure & greedy choice property |
| **BFS/DFS** | Shortest path, connectivity, level-order traversal |
| **Branch and Bound** | Optimization problems where you can bound subproblem solutions |

### Pro Tips
1. **Always draw the state space tree** for small examples to understand the pattern
2. **Start with the brute force version**, then add pruning
3. **Test with minimal examples** (n=0, n=1, n=2) to catch base case errors
4. **Verify your undo operations** by checking state invariants
5. **Consider time limits** - if worst-case is truly infeasible, look for alternative approaches
6. **Remember**: Backtracking finds solutions; it doesn't guarantee efficiency for all cases

With practice, you'll develop intuition for recognizing backtracking opportunities, designing effective state representations, and implementing powerful pruning strategies that make seemingly intractable problems solvable.