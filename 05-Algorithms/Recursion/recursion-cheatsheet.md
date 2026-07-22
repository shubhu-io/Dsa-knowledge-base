# Recursion Cheat Sheet

## Fundamental Concepts

### Definition
Recursion is a programming technique where a function calls itself to solve smaller instances of the same problem.

### Key Components
1. **Base Case**: Condition that stops recursion (prevents infinite recursion)
2. **Recursive Case**: Function calls itself with modified parameters
3. **Progress Toward Base**: Each recursive call must move closer to base case

### Syntax
```cpp
return_type function_name(parameters) {
    // Base case
    if (base_condition) {
        return base_value;
    }
    // Recursive case
    return_type result = function_name(modified_parameters);
    // Process result if needed
    return final_result;
}
```

## Common Recursive Patterns

### 1. Linear Recursion
Single recursive call per function invocation.
```cpp
int sum(int n) {
    if (n <= 0) return 0;
    return n + sum(n - 1);
}
```

### 2. Tail Recursion
Recursive call is the last operation.
```cpp
int factorial(int n, int acc = 1) {
    if (n <= 1) return acc;
    return factorial(n - 1, n * acc);
}
```

### 3. Binary Recursion
Two recursive calls per function invocation.
```cpp
int fibonacci(int n) {
    if (n <= 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}
```

### 4. Tree Recursion
Multiple recursive calls (more than two).
```cpp
void printTree(TreeNode* node) {
    if (!node) return;
    cout << node->val << " ";
    for (TreeNode* child : node->children) {
        printTree(child);
    }
}
```

### 5. Mutual Recursion
Functions call each other in a cycle.
```cpp
bool isEven(int n) {
    if (n == 0) return true;
    return isOdd(n - 1);
}

bool isOdd(int n) {
    if (n == 0) return false;
    return isEven(n - 1);
}
```

## Essential Recursive Algorithms

### Mathematical Functions
| Function | Recursive Formula | Base Case |
|----------|------------------|-----------|
| Factorial | n! = n × (n-1)! | 0! = 1, 1! = 1 |
| Fibonacci | F(n) = F(n-1) + F(n-2) | F(0) = 0, F(1) = 1 |
| GCD | gcd(a,b) = gcd(b, a mod b) | gcd(a,0) = a |
| Power | b^n = b × b^(n-1) | b^0 = 1 |
| LCM | lcm(a,b) = |a×b|/gcd(a,b) | Requires GCD |

### Array/String Operations
| Operation | Recursive Formula | Base Case |
|-----------|------------------|-----------|
| Sum | sum(arr,n) = arr[n-1] + sum(arr,n-1) | sum(arr,0) = 0 |
| Max | max(arr,n) = max(arr[n-1], max(arr,n-1)) | max(arr,1) = arr[0] |
| Linear Search | search(arr,n,x) = (arr[n-1]==x) || search(arr,n-1,x) | search(arr,0,x) = false |
| String Length | len(str) = 1 + len(str+1) | len("") = 0 |
| Reverse | reverse(str) = reverse(str+1) + str[0] | reverse("") = "" |
| Palindrome | pal(str) = (str[0]==str[n-1]) && pal(str[1..n-2]) | len ≤ 1 → true |

### Tree Traversals
| Traversal | Order | Recursive Formula |
|-----------|-------|-------------------|
| Preorder | Root-Left-Right | visit(root); preorder(left); preorder(right) |
| Inorder | Left-Root-Right | inorder(left); visit(root); inorder(right) |
| Postorder | Left-Right-Root | postorder(left); postorder(right); visit(root) |

## Problem-Solving Strategies

### 1. Identify the Pattern
- **Mathematical**: Factorial, Fibonacci, powers, GCD
- **Divide and Conquer**: Binary search, merge sort, quicksort
- **Backtracking**: Permutations, combinations, N-Queens, Sudoku
- **Tree/Graph Traversals**: DFS, BFS, tree height/diameter
- **String Processing**: Palindrome check, string conversion, parsing

### 2. Define the Base Case
- **Mathematical**: Usually n=0 or n=1
- **Array/String**: Empty array/string (size=0)
- **Tree/Graph**: Null node/empty graph
- **Search**: Element found or exhausted search space

### 3. Ensure Progress Toward Base
- **Decreasing Integer**: n → n-1, n → n/2
- **Reducing Size**: Array size n → n-1
- **Moving Pointer**: String index i → i+1
- **Tree Depth**: Moving from root to leaves

### 4. Handle Return Values
- **Accumulating Results**: Pass accumulator parameter
- **Combining Results**: Process results from recursive calls
- **Modifying Parameters**: Use reference parameters for in-place changes
- **Boolean Results**: Logical AND/OR of recursive results

### 5. Consider Optimization
- **Memoization**: Cache results for overlapping subproblems
- **Tail Recursion**: Optimize to eliminate stack buildup
- **Iterative Conversion**: Use explicit stack when needed
- **Early Termination**: Stop recursion when solution found

## Common Mistakes and Fixes

### 1. Missing Base Case
```cpp
// Wrong
int factorial(int n) {
    return n * factorial(n - 1); // No base case!
}

// Correct
int factorial(int n) {
    if (n <= 1) return 1; // Base case
    return n * factorial(n - 1);
}
```

### 2. No Progress Toward Base
```cpp
// Wrong
int countDown(int n) {
    if (n == 0) return 0;
    return 1 + countDown(n); // n never changes!
}

// Correct
int countDown(int n) {
    if (n == 0) return 0;
    return 1 + countDown(n - 1); // Progress: n decreases
}
```

### 3. Incorrect Base Case Condition
```cpp
// Wrong (for negative numbers)
int sum(int n) {
    if (n == 0) return 0;
    return n + sum(n - 1);
}
// sum(-1) = -1 + sum(-2) = -1 + (-2 + sum(-3)) = ... infinite

// Better
int sum(int n) {
    if (n <= 0) return 0; // Handles negatives too
    return n + sum(n - 1);
}
```

### 4. Stack Overflow from Deep Recursion
```cpp
// Problematic for large n
int sum(int n) {
    if (n <= 0) return 0;
    return n + sum(n - 1);
}

// Solutions:
// 1. Increase stack size (platform-specific)
// 2. Convert to iteration
// 3. Use tail recursion (if compiler optimizes)
// 4. Divide and conquer approach
int sumOptimized(int n) {
    if (n <= 0) return 0;
    if (n == 1) return 1;
    int mid = n / 2;
    return sumOptimized(mid) + sumOptimized(n - mid);
}
```

### 5. Inefficient Recomputation
```cpp
// Exponential time - recalculates same values
int fibonacci(int n) {
    if (n <= 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

// Solution: Memoization
int fibonacci(int n, vector<int>& memo) {
    if (n <= 1) return n;
    if (memo[n] != -1) return memo[n];
    return memo[n] = fibonacci(n - 1, memo) + fibonacci(n - 2, memo);
}
```

## Time and Space Complexity Guide

### Linear Recursion
| Pattern | Time | Space (Stack) | Example |
|---------|------|---------------|---------|
| f(n) = f(n-1) + O(1) | O(n) | O(n) | Factorial, sum |
| f(n) = f(n-1) + O(n) | O(n²) | O(n) | Some string operations |
| f(n) = f(n/2) + O(1) | O(log n) | O(log n) | Binary search |

### Binary Recursion
| Pattern | Time | Space (Stack) | Example |
|---------|------|---------------|---------|
| f(n) = 2f(n-1) + O(1) | O(2^n) | O(n) | Naive Fibonacci |
| f(n) = 2f(n/2) + O(n) | O(n log n) | O(log n) | Merge sort |
| f(n) = 2f(n-1) + O(n) | O(2^n) | O(n) | Subset generation |

### Tree Recursion (Branching Factor b)
| Pattern | Time | Space (Stack) | Example |
|---------|------|---------------|---------|
| f(n) = b·f(n-1) + O(1) | O(b^n) | O(n) | Permutations (b=n) |
| f(n) = b·f(n/b) + O(n) | O(n log b n) | O(log n) | Tree traversals |

## Optimization Techniques

### 1. Memoization (Top-Down DP)
```cpp
int fibonacci(int n, vector<int>& memo) {
    if (n <= 1) return n;
    if (memo[n] != -1) return memo[n];
    return memo[n] = fibonacci(n - 1, memo) + fibonacci(n - 2, memo);
}
```

### 2. Bottom-Up Dynamic Programming
```cpp
int fibonacci(int n) {
    if (n <= 1) return n;
    vector<int> dp(n + 1);
    dp[0] = 0;
    dp[1] = 1;
    for (int i = 2; i <= n; i++) {
        dp[i] = dp[i - 1] + dp[i - 2];
    }
    return dp[n];
}
```

### 3. Tail Recursion Elimination
```cpp
// Recursive version
int factorial(int n, int acc = 1) {
    if (n <= 1) return acc;
    return factorial(n - 1, n * acc);
}

// Iterative equivalent
int factorial(int n) {
    int acc = 1;
    for (int i = 2; i <= n; i++) {
        acc *= i;
    }
    return acc;
}
```

### 4. Divide and Conquer Optimization
```cpp
// Instead of: f(n) = f(n-1) + O(n) → O(n²)
// Use: f(n²(n/2) +
// Use: f(n) = 2f(n/2) + O(n) → O(n log n)
// Example: Merge sort instead of selection sort
```

### 5. Early Termination and Pruning
```cpp
// In backtracking, prune impossible branches early
bool solveSudoku(...) {
    // ... before placing number:
    if (!isValid(board, row, col, num)) {
        continue; // Prune this branch
    }
    // ... place number and recurse ...
}
```

## Language-Specific Considerations

### C++
```cpp
// Pass by reference to avoid copying
void process(vector<int>& data, int index) { ... }

// Use const references for read-only parameters
int calc(const vector<int>& data, int index) { ... }

// Static variables retain values between calls (use carefully)
int counter(int n) {
    static int count = 0; // Initialized once
    if (n <= 0) return count;
    count++;
    return counter(n - 1);
}
```

### Java
```cpp
// Similar to C++ but all objects are references
void process(List<Integer> list, int index) { ... }

// Strings are immutable - each operation creates new object
String reverse(String s) {
    if (s.isEmpty()) return s;
    return reverse(s.substring(1)) + s.charAt(0);
}
```

### Python
```python
# Default recursion limit (can be increased)
import sys
sys.setrecursionlimit(10000)  # Increase limit

# Memoization using lru_cache decorator
from functools import lru_cache

@lru_cache(maxsize=None)
def fibonacci(n):
    if n <= 1:
        return n
    return fibonacci(n-1) + fibonacci(n-2)
```

## When to Use Recursion

### ✅ USE RECURSION WHEN:
1. **Problem has natural recursive structure** (trees, graphs, hierarchical data)
2. **Divide and conquer** applies (merge sort, quicksort, binary search)
3. **Backtracking** is needed (combinatorial problems, constraint satisfaction)
4. **Code clarity** is more important than minor performance gains
5. **Depth is limited** (typically < 1000 calls depending on language/stack)
6. **Immutable data processing** (functional programming style)

### ❌ PREFER ITERATION WHEN:
1. **Simple loop** solves the problem efficiently
2. **Performance is critical** and recursion overhead is significant
3. **Deep recursion** might exceed stack limits
4. **Memory usage** must be minimized
5. **Tail recursion optimization** is not available/compilier-dependent
6. **State needs to be shared** across many recursive calls

## Template for Common Recursive Problems

### 1. Mathematical Computation
```cpp
return_type mathematical_function(parameters) {
    // Base case
    if (base_condition) {
        return base_value;
    }
    // Recursive case with progress
    return_type small_result = mathematical_function(modified_parameters);
    // Combine current step with recursive result
    return combine(current_step, small_result);
}
```

### 2. Array/String Processing
```cpp
return_type process_array(array, start_index) {
    // Base case
    if (start_index >= array.size()) {
        return base_value;
    }
    // Recursive case
    return_type result_rest = process_array(array, start_index + 1);
    // Process current element and combine
    return combine(array[start_index], result_rest);
}
```

### 3. Tree/Graph Traversal
```cpp
void traverse_tree(TreeNode* node) {
    // Base case
    if (!node) return;
    
    // Preorder: Process node before children
    // process(node);
    
    // Recursive case
    traverse_tree(node->left);
    
    // Inorder: Process node between children
    // process(node);
    
    traverse_tree(node->right);
    
    // Postorder: Process node after children
    // process(node);
}
```

### 4. Backtracking Framework
```cpp
void backtrack(state, depth) {
    // Base case: Solution found or invalid state
    if (is_solution(state)) {
        record_solution(state);
        return;
    }
    if (is_invalid(state)) {
        return; // Prune
    }
    
    // Recursive case: Try all possible moves
    for (each possible move) {
        apply_move(state, move);
        backtrack(state, depth + 1);
        undo_move(state, move); // Backtrack
    }
}
```

## Memory Management Tips

### 1. Stack Usage Estimation
- Each call typically uses: return address + parameters + local variables + alignment
- Estimate: ~100 bytes per call (varies by platform and compiler)
- Safe depth: ~1000-2000 calls for default stack (1MB)

### 2. Reducing Stack Pressure
```cpp
// Instead of passing large objects by value
void bad(vector<int> data, int index) { ... } // Copies vector

// Pass by const reference
void good(const vector<int>& data, int index) { ... }

// Or by pointer if modification needed
void also_good(vector<int>* data, int index) { ... }
```

### 3. Heap Accumulators for Large Results
```cpp
// For accumulating large results without stack growth
void collectResults(TreeNode* node, vector<int>& result) {
    if (!node) return;
    collectResults(node->left, result);
    result.push_back(node->val); // Heap allocation
    collectResults(node->right, result);
}
```

## Debugging Techniques

### 1. Trace Recursion Depth
```cpp
int factorial(int n, int depth = 0) {
    string indent(depth * 2, ' ');
    cout << indent << "factorial(" << n << ") called" << endl;
    
    if (n <= 1) {
        cout << indent << "returning 1" << endl;
        return 1;
    }
    
    int result = n * factorial(n - 1, depth + 1);
    cout << indent << "returning " << result << endl;
    return result;
}
```

### 2. Visualize Call Stack
```cpp
// Global or static variable to track depth
static int call_depth = 0;

void recursive_function(...) {
    call_depth++;
    // ... function body ...
    // ... recursive calls ...
    call_depth--;
}
```

### 3. Detect Infinite Recursion
```cpp
// Add depth limit guard
int safe_recursive(int n, int depth = 0, int max_depth = 1000) {
    if (depth > max_depth) {
        throw runtime_error("Maximum recursion depth exceeded");
    }
    // ... normal recursion ...
}
```

## Real-World Applications

### 1. Parsing and Compilers
- Recursive descent parsers
- Abstract syntax tree traversal
- Intermediate code generation

### 2. Artificial Intelligence
- Game tree search (minimax, alpha-beta pruning)
- Decision tree learning
- Bayesian network inference

### 3. Computer Graphics
- Fractal generation (Mandelbrot set, Koch snowflake)
- Ray tracing scene traversal
- Spatial partitioning (quadtrees, octrees)

### 4. Data Compression
- Huffman coding tree construction
- LZW dictionary traversal
- Recursive pattern matching

### 5. Network Algorithms
- Routing protocol calculations
- Spanning tree algorithms
- Network flow decompositions

## Summary

Mastering recursion requires understanding both the theoretical concepts and practical implementation details. Key takeaways:

1. **Always verify base cases** - they prevent infinite recursion
2. **Ensure measurable progress** - each call must simplify the problem
3. **Consider performance implications** - time and space complexity matter
4. **Use memoization** for overlapping subproblems
5. **Know when to iterate** - recursion isn't always the best solution
6. **Practice pattern recognition** - many problems follow common templates
7. **Debug systematically** - trace depth, visualize stack, check termination

Recursion, when applied correctly, leads to elegant, readable, and maintainable code for problems with inherent recursive structure. However, it's essential to balance elegance with practical considerations like performance and stack limitations.