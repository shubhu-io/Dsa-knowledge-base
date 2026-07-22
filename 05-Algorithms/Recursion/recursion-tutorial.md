# Recursion Tutorial

## Introduction to Recursion

Recursion is a programming technique where a function calls itself to solve smaller instances of the same problem. It's based on the principle of breaking down complex problems into simpler, more manageable sub-problems.

### Key Concepts

1. **Base Case**: The condition that stops the recursion. Without a base case, recursion would continue infinitely, leading to a stack overflow.
2. **Recursive Case**: The part where the function calls itself with a modified parameter, moving closer to the base case.
3. **Call Stack**: Each recursive call adds a new frame to the call stack, which keeps track of function calls and their local variables.

### Why Use Recursion?

- **Simplicity**: Recursive solutions are often more intuitive and easier to understand than iterative ones, especially for problems with inherent recursive structure.
- **Elegance**: Many algorithms (tree traversals, divide-and-conquer, backtracking) are naturally expressed recursively.
- **Problem Decomposition**: Breaks complex problems into smaller, similar sub-problems.

### When to Avoid Recursion

- **Performance**: Recursive calls have overhead due to function calls and stack usage.
- **Stack Overflow**: Deep recursion can exhaust the call stack.
- **Simple Iterative Solutions**: When a simple loop suffices, iteration is usually more efficient.

## Types of Recursion

### 1. Direct Recursion
A function directly calls itself.
```cpp
void countdown(int n) {
    if (n <= 0) { // Base case
        return;
    }
    cout << n << " ";
    countdown(n - 1); // Recursive call
}
```

### 2. Indirect Recursion
Function A calls function B, which in turn calls function A.
```cpp
void functionA(int n);
void functionB(int n);

void functionA(int n) {
    if (n <= 0) return;
    cout << "A " << n << " ";
    functionB(n - 1);
}

void functionB(int n) {
    if (n <= 0) return;
    cout << "B " << n << " ";
    functionA(n - 1);
}
```

### 3. Tail Recursion
The recursive call is the last operation in the function. Some compilers can optimize this to avoid stack buildup.
```cpp
void factorial_tail(int n, int accumulator = 1) {
    if (n <= 1) {
        cout << accumulator;
        return;
    }
    factorial_tail(n - 1, n * accumulator); // Tail call
}
```

### 4. Head Recursion
The recursive call is the first operation in the function.
```cpp
void print_numbers(int n) {
    if (n <= 0) return;
    print_numbers(n - 1); // Head recursion
    cout << n << " ";
}
```

### 5. Tree Recursion
A function makes multiple recursive calls.
```cpp
int fibonacci(int n) {
    if (n <= 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2); // Two recursive calls
}
```

## Classic Recursive Algorithms

### 1. Factorial
```cpp
// Iterative version
int factorial_iterative(int n) {
    int result = 1;
    for (int i = 2; i <= n; i++) {
        result *= i;
    }
    return result;
}

// Recursive version
int factorial_recursive(int n) {
    if (n <= 1) { // Base case
        return 1;
    }
    return n * factorial_recursive(n - 1); // Recursive case
}
```

### 2. Fibonacci Sequence
```cpp
// Naive recursive (exponential time)
int fibonacci_naive(int n) {
    if (n <= 1) return n;
    return fibonacci_naive(n - 1) + fibonacci_naive(n - 2);
}

// Memoized version (linear time)
int fibonacci_memo(int n, vector<int>& memo) {
    if (n <= 1) return n;
    if (memo[n] != -1) return memo[n];
    return memo[n] = fibonacci_memo(n - 1, memo) + fibonacci_memo(n - 2, memo);
}

// Bottom-up DP version (linear time, constant space)
int fibonacci_dp(int n) {
    if (n <= 1) return n;
    int a = 0, b = 1;
    for (int i = 2; i <= n; i++) {
        int temp = a + b;
        a = b;
        b = temp;
    }
    return b;
}
```

### 3. Greatest Common Divisor (Euclidean Algorithm)
```cpp
int gcd(int a, int b) {
    if (b == 0) {
        return a;
    }
    return gcd(b, a % b);
}
```

### 4. Power Calculation
```cpp
// Simple recursive (O(n))
double power_simple(double base, int exp) {
    if (exp == 0) return 1;
    if (exp < 0) return 1 / power_simple(base, -exp);
    return base * power_simple(base, exp - 1);
}

// Optimized using divide and conquer (O(log n))
double power_fast(double base, int exp) {
    if (exp == 0) return 1;
    if (exp < 0) return 1 / power_fast(base, -exp);
    
    double half = power_fast(base, exp / 2);
    if (exp % 2 == 0) {
        return half * half;
    } else {
        return base * half * half;
    }
}
```

## Recursion with Arrays

### 1. Sum of Array Elements
```cpp
int array_sum(int arr[], int n) {
    if (n <= 0) return 0;
    return arr[n - 1] + array_sum(arr, n - 1);
}
```

### 2. Maximum Element in Array
```cpp
int array_max(int arr[], int n) {
    if (n == 1) return arr[0];
    int max_in_rest = array_max(arr, n - 1);
    return max(arr[n - 1], max_in_rest);
}
```

### 3. Linear Search
```cpp
bool linear_search(int arr[], int n, int target) {
    if (n == 0) return false;
    if (arr[n - 1] == target) return true;
    return linear_search(arr, n - 1, target);
}
```

### 4. Binary Search (Recursive)
```cpp
int binary_search(int arr[], int left, int right, int target) {
    if (left > right) return -1; // Not found
    
    int mid = left + (right - left) / 2;
    
    if (arr[mid] == target) return mid;
    if (arr[mid] > target) 
        return binary_search(arr, left, mid - 1, target);
    else
        return binary_search(arr, mid + 1, right, target);
}
```

## Recursion with Strings

### 1. String Length
```cpp
int string_length(const char* str) {
    if (*str == '\0') return 0;
    return 1 + string_length(str + 1);
}
```

### 2. Palindrome Check
```cpp
bool is_palindrome(const char* str, int start, int end) {
    if (start >= end) return true;
    if (str[start] != str[end]) return false;
    return is_palindrome(str, start + 1, end - 1);
}

// Wrapper function
bool is_palindrome(const char* str) {
    int len = strlen(str);
    return is_palindrome(str, 0, len - 1);
}
```

### 3. Reverse String
```cpp
void reverse_string(char* str, int start, int end) {
    if (start >= end) return;
    swap(str[start], str[end]);
    reverse_string(str, start + 1, end - 1);
}
```

## Recursion with Trees and Graphs

### 1. Tree Traversals
```cpp
struct TreeNode {
    int val;
    TreeNode* left;
    TreeNode* right;
    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
};

// Preorder: Root-Left-Right
void preorder(TreeNode* root) {
    if (!root) return;
    cout << root->val << " ";
    preorder(root->left);
    preorder(root->right);
}

// Inorder: Left-Root-Right
void inorder(TreeNode* root) {
    if (!root) return;
    inorder(root->left);
    cout << root->val << " ";
    inorder(root->right);
}

// Postorder: Left-Right-Root
void postorder(TreeNode* root) {
    if (!root) return;
    postorder(root->left);
    postorder(root->right);
    cout << root->val << " ";
}
```

### 2. Graph Depth-First Search (DFS)
```cpp
void dfs(int node, vector<bool>& visited, const vector<vector<int>>& adj) {
    visited[node] = true;
    cout << node << " ";
    
    for (int neighbor : adj[node]) {
        if (!visited[neighbor]) {
            dfs(neighbor, visited, adj);
        }
    }
}
```

## Backtracking with Recursion

Backtracking is a general algorithm for finding all (or some) solutions to computational problems that incrementally builds candidates and abandons a candidate as soon as it determines that the candidate cannot possibly be completed to a valid solution.

### 1. N-Queens Problem
```cpp
vector<vector<string>> solveNQueens(int n) {
    vector<vector<string>> solutions;
    vector<string> board(n, string(n, '.'));
    vector<bool> cols(n, false);
    vector<bool> diag1(2 * n - 1, false); // r + c
    vector<bool> diag2(2 * n - 1, false); // r - c + n - 1
    
    function<void(int)> backtrack = [&](int row) {
        if (row == n) {
            solutions.push_back(board);
            return;
        }
        
        for (int col = 0; col < n; col++) {
            int d1 = row + col;
            int d2 = row - col + n - 1;
            
            if (!cols[col] && !diag1[d1] && !diag2[d2]) {
                board[row][col] = 'Q';
                cols[col] = diag1[d1] = dia2[d2] = true;
                
                backtrack(row + 1);
                
                board[row][col] = '.';
                cols[col] = diag1[d1] = dia2[d2] = false;
            }
        }
    };
    
    backtrack(0);
    return solutions;
}
```

### 2. Sudoku Solver
```cpp
bool solveSudoku(vector<vector<char>>& board) {
    function<bool(int, int)> backtrack = [&](int row, int col) {
        if (row == 9) return true; // All rows processed
        if (col == 9) return backtrack(row + 1, 0); // Move to next row
        
        if (board[row][col] != '.') 
            return backtrack(row, col + 1); // Skip filled cells
        
        for (char c = '1'; c <= '9'; c++) {
            if (isValid(board, row, col, c)) {
                board[row][col] = c;
                if (backtrack(row, col + 1)) return true;
                board[row][col] = '.'; // Backtrack
            }
        }
        return false; // Trigger backtracking
    };
    
    return backtrack(0, 0);
}

bool isValid(vector<vector<char>>& board, int row, int col, char c) {
    for (int i = 0; i < 9; i++) {
        if (board[i][col] == c) return false; // Check column
        if (board[row][i] == c) return false; // Check row
        if (board[3 * (row / 3) + i / 3][3 * (col / 3) + i % 3] == c) 
            return false; // Check 3x3 box
    }
    return true;
}
```

## Dynamic Programming vs Recursion

Many dynamic programming problems can be solved with recursion + memoization.

### Example: Climbing Stairs
```cpp
// Pure recursion (exponential)
int climbStairs_naive(int n) {
    if (n <= 2) return n;
    return climbStairs_naive(n - 1) + climbStairs_naive(n - 2);
}

// Memoization (linear)
int climbStairs_memo(int n, vector<int>& memo) {
    if (n <= 2) return n;
    if (memo[n] != 0) return memo[n];
    return memo[n] = climbStairs_memo(n - 1, memo) + climbStairs_memo(n - 2, memo);
}

// Bottom-up DP (linear)
int climbStairs_dp(int n) {
    if (n <= 2) return n;
    vector<int> dp(n + 1);
    dp[1] = 1;
    dp[2] = 2;
    for (int i = 3; i <= n; i++) {
        dp[i] = dp[i - 1] + dp[i - 2];
    }
    return dp[n];
}
```

## Common Mistakes and Pitfalls

### 1. Missing Base Case
```cpp
// Wrong: No base case
int factorial(int n) {
    return n * factorial(n - 1); // Will cause stack overflow
}

// Correct: Has base case
int factorial(int n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}
```

### 2. Incorrect Base Case
```cpp
// Wrong: Base case too restrictive
int sum(int n) {
    if (n == 0) return 0; // Works for positive n
    return n + sum(n - 1);
}
// Fails for n < 0

// Better: Handle edge case
int sum(int n) {
    if (n <= 0) return 0;
    return n + sum(n - 1);
}
```

### 3. Not Making Progress Toward Base Case
```cpp
// Wrong: n doesn't change
int problematic(int n) {
    if (n == 0) return 0;
    return 1 + problematic(n); // Infinite recursion
}

// Correct: n decreases
int correct(int n) {
    if (n == 0) return 0;
    return 1 + correct(n - 1);
}
```

### 4. Excessive Memory Usage
```cpp
// Inefficient: Creates new strings in each call
string reverse_inefficient(string s) {
    if (s.empty()) return s;
    return reverse_inefficient(s.substr(1)) + s[0];
}

// Better: Pass by reference and use indices
void reverse_efficient(string& s, int left, int right) {
    if (left >= right) return;
    swap(s[left], s[right]);
    reverse_efficient(s, left + 1, right - 1);
}
```

## Optimization Techniques

### 1. Memoization
Store results of expensive function calls and reuse them when the same inputs occur again.
```cpp
int fibonacci_memo(int n, vector<int>& memo) {
    if (n <= 1) return n;
    if (memo[n] != -1) return memo[n];
    return memo[n] = fibonacci_memo(n - 1, memo) + fibonacci_memo(n - 2, memo);
}
```

### 2. Tail Recursion Optimization
Convert recursive functions to tail-recursive form when possible.
```cpp
// Not tail-recursive (operation after recursive call)
int factorial_not_tail(int n) {
    if (n <= 1) return 1;
    return n * factorial_not_tail(n - 1);
}

// Tail-recursive (recursive call is last operation)
int factorial_tail(int n, int accumulator = 1) {
    if (n <= 1) return accumulator;
    return factorial_tail(n - 1, n * accumulator);
}
```

### 3. Converting Recursion to Iteration
Use explicit stack to simulate recursion.
```cpp
// Recursive DFS
void dfs_recursive(int node, vector<bool>& visited, const vector<vector<int>>& adj) {
    visited[node] = true;
    // ... process node ...
    for (int neighbor : adj[node]) {
        if (!visited[neighbor]) 
            dfs_recursive(neighbor, visited, adj);
    }
}

// Iterative DFS using stack
void dfs_iterative(int start, vector<bool>& visited, const vector<vector<int>>& adj) {
    stack<int> st;
    st.push(start);
    
    while (!st.empty()) {
        int node = st.top();
        st.pop();
        
        if (visited[node]) continue;
        visited[node] = true;
        // ... process node ...
        
        // Push neighbors in reverse order to maintain same order as recursive
        for (auto it = adj[node].rbegin(); it != adj[node].rend(); ++it) {
            if (!visited[*it]) 
                st.push(*it);
        }
    }
}
```

## Practice Problems

### Easy Level
1. **Factorial**: Compute n!
2. **Fibonacci**: Compute nth Fibonacci number
3. **Sum of Digits**: Given n, return sum of its digits
4. **Power Function**: Compute base^exponent
5. **Reverse String**: Reverse a string using recursion
6. **Palindrome Check**: Check if a string is palindrome
7. **Count Zeros**: Count number of zeros in a number
8. **Array Sum**: Sum all elements in an array
9. **Print 1 to N**: Print numbers from 1 to N
10. **Print N to 1**: Print numbers from N to 1

### Medium Level
1. **Tower of Hanoi**: Solve the Tower of Hanoi puzzle
2. **Permutations**: Generate all permutations of a string
3. **Combinations**: Generate all combinations of k elements from n
4. **Subsets**: Generate all subsets of a set
5. **String to Integer**: Convert string to integer (atoi)
6. **Print Linked List**: Print elements of linked list in reverse
7. **Merge Two Sorted Lists**: Merge two sorted linked lists
8. **Binary Tree Depth**: Find maximum depth of binary tree
9. **Balanced Parentheses**: Generate all combinations of balanced parentheses
10. **Word Break**: Determine if string can be segmented into dictionary words

### Hard Level
1. **N-Queens**: Place N queens on N×N chessboard so no two attack each other
2. **Sudoku Solver**: Solve Sudoku puzzle
3. **Word Search II**: Find all words from dictionary in board
4. **Expression Add Operators**: Add operators to digits to reach target
5. **Regex Matching**: Implement regular expression matching
6. **Wildcard Matching**: Implement wildcard pattern matching
7. **Distinct Subsequences**: Count distinct subsequences of string
8. **Interleaving String**: Check if string is interleaving of two others
9. **Remove Invalid Parentheses**: Remove minimum parentheses to make valid
10. **Sudoku Solver with Backtracking**: Advanced Sudoku solving techniques

## Time and Space Complexity Analysis

### Basic Recursive Functions
| Function | Time Complexity | Space Complexity (Call Stack) |
|----------|----------------|-------------------------------|
| Factorial | O(n) | O(n) |
| Fibonacci (naive) | O(2^n) | O(n) |
| GCD | O(log(min(a,b))) | O(log(min(a,b))) |
| Power (simple) | O(n) | O(n) |
| Power (optimized) | O(log n) | O(log n) |
| Array Sum | O(n) | O(n) |
| Array Max | O(n) | O(n) |
| Linear Search | O(n) | O(n) |
| Binary Search | O(log n) | O(log n) |
| String Length | O(n) | O(n) |
| Palindrome Check | O(n) | O(n) |
| String Reverse | O(n) | O(n) |

### Tree and Graph Traversals
| Algorithm | Time Complexity | Space Complexity |
|-----------|----------------|------------------|
| DFS (Tree) | O(n) | O(h) where h is height |
| BFS (Tree) | O(n) | O(w) where w is max width |
| DFS (Graph) | O(V + E) | O(V) |
| BFS (Graph) | O(V + E) | O(V) |

### Backtracking Algorithms
| Problem | Time Complexity | Space Complexity |
|---------|----------------|------------------|
| N-Queens | O(N!) | O(N) |
| Sudoku | O(9^(n*n)) | O(n*n) |
| Subsets | O(2^n) | O(n) |
| Permutations | O(n!) | O(n) |
| Combination Sum | O(2^n) | O(target/min(candidates)) |

## When to Use Recursion

### Use Recursion When:
1. **Problem has natural recursive structure** (trees, graphs, fractals)
2. **Divide and conquer approach** is applicable
3. **Backtracking** is needed to explore all possibilities
4. **Code simplicity and readability** are prioritized over performance
5. **Depth of recursion** is limited and predictable

### Prefer Iteration When:
1. **Simple iterative solution** exists
2. **Performance is critical**
3. **Deep recursion** might cause stack overflow
4. **Memory usage** needs to be minimized
5. **Tail recursion optimization** is not available

## Summary

Recursion is a powerful technique that simplifies code for problems with recursive structure. Key takeaways:

1. **Always define a clear base case** to prevent infinite recursion
2. **Ensure each recursive call makes progress** toward the base case
3. **Consider memoization** for overlapping subproblems
4. **Be aware of stack limitations** for deep recursion
5. **Use recursion when it leads to cleaner, more readable code**
6. **Consider iterative alternatives** for performance-critical applications
7. **Practice with classic problems** to develop intuition

Recursion, when used appropriately, leads to elegant and maintainable code. However, it's essential to understand its trade-offs and apply it judiciously based on the problem constraints and requirements.