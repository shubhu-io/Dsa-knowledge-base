# Competitive Programming Problems

## Curated Problem List with Solutions

This document contains a selection of important competitive programming problems organized by topic and difficulty, along with their solutions and explanations.

---

## Table of Contents
1. [Array Problems](#array-problems)
2. [String Problems](#string-problems)
3. [Mathematical Problems](#mathematical-problems)
4. [Graph Problems](#graph-problems)
5. [Dynamic Programming Problems](#dynamic-programming-problems)
6. [Greedy Problems](#greedy-problems)
7. [Data Structure Problems](#data-structure-problems)
8. [Geometry Problems](#geometry-problems)
9. [Advanced Problems](#advanced-problems)

---

## Array Problems

### 1. Maximum Subarray Sum (Kadane's Algorithm)
**Problem**: Given an integer array nums, find the contiguous subarray (containing at least one number) which has the largest sum and return its sum.

**Solution**:
```cpp
int maxSubArray(vector<int>& nums) {
    int max_sum = nums[0];
    int current_sum = nums[0];
    
    for (int i = 1; i < nums.size(); i++) {
        current_sum = max(nums[i], current_sum + nums[i]);
        max_sum = max(max_sum, current_sum);
    }
    return max_sum;
}
```

**Java**:
```java
public int maxSubArray(int[] nums) {
    int maxSum = nums[0];
    int currentSum = nums[0];
    
    for (int i = 1; i < nums.length; i++) {
        currentSum = Math.max(nums[i], currentSum + nums[i]);
        maxSum = Math.max(maxSum, currentSum);
    }
    return maxSum;
}
```

**Python**:
```python
def maxSubArray(nums):
    max_sum = nums[0]
    current_sum = nums[0]
    
    for i in range(1, len(nums)):
        current_sum = max(nums[i], current_sum + nums[i])
        max_sum = max(max_sum, current_sum)
    
    return max_sum
```

### 2. Best Time to Buy and Sell Stock
**Problem**: You are given an array prices where prices[i] is the price of a given stock on the ith day. Return the maximum profit you can achieve from this transaction.

**Solution**:
```cpp
int maxProfit(vector<int>& prices) {
    int min_price = INT_MAX;
    int max_profit = 0;
    
    for (int price : prices) {
        if (price < min_price) {
            min_price = price;
        } else if (price - min_price > max_profit) {
            max_profit = price - min_price;
        }
    }
    return max_profit;
}
```

### 3. Product of Array Except Self
**Problem**: Given an integer array nums, return an array answer such that answer[i] is equal to the product of all the elements of nums except nums[i].

**Solution**:
```cpp
vector<int> productExceptSelf(vector<int>& nums) {
    int n = nums.size();
    vector<int> answer(n, 1);
    
    // Calculate left products
    int left_product = 1;
    for (int i = 0; i < n; i++) {
        answer[i] = left_product;
        left_product *= nums[i];
    }
    
    // Calculate right products and multiply with left products
    int right_product = 1;
    for (int i = n - 1; i >= 0; i--) {
        answer[i] *= right_product;
        right_product *= nums[i];
    }
    
    return answer;
}
```

### 4. Container With Most Water
**Problem**: Given n non-negative integers a1, a2, ..., an, where each represents a point at coordinate (i, ai), find two lines that together with the x-axis form a container that holds the most water.

**Solution**:
```cpp
int maxArea(vector<int>& height) {
    int left = 0;
    int right = height.size() - 1;
    int max_area = 0;
    
    while (left < right) {
        int width = right - left;
        int container_height = min(height[left], height[right]);
        int area = width * container_height;
        max_area = max(max_area, area);
        
        if (height[left] < height[right]) {
            left++;
        } else {
            right--;
        }
    }
    return max_area;
}
```

### 5. 3Sum
**Problem**: Given an integer array nums, return all the triplets [nums[i], nums[j], nums[k]] such that i != j, i != k, and j != k, and nums[i] + nums[j] + nums[k] == 0.

**Solution**:
```cpp
vector<vector<int>> threeSum(vector<int>& nums) {
    vector<vector<int>> result;
    sort(nums.begin(), nums.end());
    
    for (int i = 0; i < nums.size() - 2; i++) {
        // Skip duplicates for the first number
        if (i > 0 && nums[i] == nums[i-1]) continue;
        
        int left = i + 1;
        int right = nums.size() - 1;
        int target = -nums[i];
        
        while (left < right) {
            int sum = nums[left] + nums[right];
            if (sum == target) {
                result.push_back({nums[i], nums[left], nums[right]});
                
                // Skip duplicates for second number
                while (left < right && nums[left] == nums[left+1]) left++;
                // Skip duplicates for third number
                while (left < right && nums[right] == nums[right-1]) right--;
                
                left++;
                right--;
            } else if (sum < target) {
                left++;
            } else {
                right--;
            }
        }
    }
    return result;
}
```

---

## String Problems

### 1. Longest Palindromic Substring
**Problem**: Given a string s, return the longest palindromic substring in s.

**Solution** (Expand Around Center):
```cpp
string longestPalindrome(string s) {
    if (s.empty()) return "";
    
    int start = 0, max_len = 1;
    
    auto expandAroundCenter = [&](int left, int right) {
        while (left >= 0 && right < s.size() && s[left] == s[right]) {
            left--;
            right++;
        }
        return make_pair(left + 1, right - left - 1);
    };
    
    for (int i = 0; i < s.size(); i++) {
        // Odd length palindromes
        auto [l1, len1] = expandAroundCenter(i, i);
        // Even length palindromes
        auto [l2, len2] = expandAroundCenter(i, i + 1);
        
        if (len1 > max_len) {
            start = l1;
            max_len = len1;
        }
        if (len2 > max_len) {
            start = l2;
            max_len = len2;
        }
    }
    
    return s.substr(start, max_len);
}
```

**Solution** (Manacher's Algorithm):
```cpp
string longestPalindrome(string s) {
    // Transform s into t
    string t = "#";
    for (char c : s) {
        t += c;
        t += '#';
    }
    
    int n = t.size();
    vector<int> p.assign(n, 0));
    int center = 0, right = 0;
    
    for (int i = 0; i < n; i++) {
        int mirror = 2 * center - i;
        
        if (i < right) {
            p[i] = min(right - i, p[mirror]);
        }
        
        // Attempt to expand palindrome centered at i
        while (i + (1 + p[i]) < n && i - (1 + p[i]) >= 0 && 
               t[i + (1 + p[i])] == t[i - (1 + p[i])]) {
            p[i]++;
        }
        
        // If palindrome centered at i expands past right, adjust center and right
        if (i + p[i] > right) {
            center = i;
            right = i + p[i];
        }
    }
    
    // Find the maximum element in p
    int max_len = 0;
    int center_index = 0;
    for (int i = 0; i < n; i++) {
        if (p[i] > max_len) {
            max_len = p[i];
            center_index = i;
        }
    }
    
    // Extract the longest palindrome from s
    int start = (center_index - max_len) / 2;
    return s.substr(start, max_len);
}
```

### 2. Valid Parentheses
**Problem**: Given a string s containing just the characters '(', ')', '{', '}', '[' and ']', determine if the input string is valid.

**Solution**:
```cpp
bool isValid(string s) {
    stack<char> st;
    unordered_map<char, char> brackets = {
        {')', '('},
        {']', '['},
        {'}', '{'}
    };
    
    for (char c : s) {
        if (brackets.count(c)) {
            // Closing bracket
            if (st.empty() || st.top() != brackets[c]) {
                return false;
            }
            st.pop();
        } else {
            // Opening bracket
            st.push(c);
        }
    }
    return st.empty();
}
```

### 3. Longest Common Subsequence
**Problem**: Given two strings text1 and text2, return the length of their longest common subsequence.

**Solution**:
```cpp
int longestCommonSubsequence(string text1, string text2) {
    int m = text1.size();
    int n = text2.size();
    vector<vector<int>> dp(m + 1, vector<int>(n + 1, 0));
    
    for (int i = 1; i <= m; i++) {
        for (int j = 1; j <= n; j++) {
            if (text1[i-1] == text2[j-1]) {
                dp[i][j] = dp[i-1][j-1] + 1;
            } else {
                dp[i][j] = max(dp[i-1][j], dp[i][j-1]);
            }
        }
    }
    return dp[m][n];
}
```

### 4. String to Integer (atoi)
**Problem**: Implement the myAtoi(string s) function, which converts a string to a 32-bit signed integer.

**Solution**:
```cpp
int myAtoi(string s) {
    int i = 0;
    int n = s.size();
    int sign = 1;
    long result = 0; // Use long to check for overflow
    
    // Skip whitespace
    while (i < n && s[i] == ' ') i++;
    
    // Check sign
    if (i < n && (s[i] == '+' || s[i] == '-')) {
        sign = (s[i] == '+') ? 1 : -1;
        i++;
    }
    
    // Convert digits
    while (i < n && isdigit(s[i])) {
        result = result * 10 + (s[i] - '0');
        
        // Check for overflow
        if (sign == 1 && result > INT_MAX) return INT_MAX;
        if (sign == -1 && -result < INT_MIN) return INT_MIN;
        
        i++;
    }
    
    return sign * result;
}
```

### 5. Word Break
**Problem**: Given a string s and a dictionary of strings wordDict, return true if s can be segmented into a space-separated sequence of one or more dictionary words.

**Solution**:
```cpp
bool wordBreak(string s, vector<string>& wordDict) {
    unordered_set<string> wordSet(wordDict.begin(), wordDict.end());
    vector<bool> dp(s.size() + 1, false);
    dp[0] = true; // Empty string is valid
    
    for (int i = 1; i <= s.size(); i++) {
        for (int j = 0; j < i; j++) {
            if (dp[j] && wordSet.count(s.substr(j, i - j))) {
                dp[i] = true;
                break;
            }
        }
    }
    return dp[s.size()];
}
```

---

## Mathematical Problems

### 1. Reverse Integer
**Problem**: Given a signed 32-bit integer x, return x with its digits reversed. If reversing x causes the value to go outside the signed 32-bit integer range [-2^31, 2^31 - 1], then return 0.

**Solution**:
```cpp
int reverse(int x) {
    long rev = 0; // Use long to handle overflow
    
    while (x != 0) {
        rev = rev * 10 + x % 10;
        x /= 10;
        
        // Check for overflow
        if (rev > INT_MAX || rev < INT_MIN) {
            return 0;
        }
    }
    
    return static_cast<int>(rev);
}
```

### 2. Palindrome Number
**Problem**: Given an integer x, return true if x is palindrome integer.

**Solution**:
```cpp
bool isPalindrome(int x) {
    // Negative numbers are not palindromes
    if (x < 0) return false;
    
    // Numbers ending with 0 (except 0 itself) are not palindromes
    if (x % 10 == 0 && x != 0) return false;
    
    int reversed = 0;
    while (x > reversed) {
        reversed = reversed * 10 + x % 10;
        x /= 10;
    }
    
    // When the length is odd, we can get rid of the middle digit by reversed/10
    return x == reversed || x == reversed/10;
}
```

### 3. Roman to Integer
**Problem**: Roman numerals are represented by seven different symbols: I, V, X, L, C, D and M.

**Solution**:
```cpp
int romanToInt(string s) {
    unordered_map<char, int> roman = {
        {'I', 1},
        {'V', 5},
        {'X', 10},
        {'L', 50},
        {'C', 100},
        {'D', 500},
        {'M', 1000}
    };
    
    int result = 0;
    int n = s.size();
    
    for (int i = 0; i < n; i++) {
        // If current value is less than next value, subtract it
        if (i < n - 1 && roman[s[i]] < roman[s[i+1]]) {
            result -= roman[s[i]];
        } else {
            result += roman[s[i]];
        }
    }
    return result;
}
```

### 4. Integer to Roman
**Problem**: Given an integer, convert it to a roman numeral.

**Solution**:
```cpp
string intToRoman(int num) {
    vector<pair<int, string>> roman = {
        {1000, "M"},
        {900, "CM"},
        {500, "D"},
        {400, "CD"},
        {100, "C"},
        {90, "XC"},
        {50, "L"},
        {40, "XL"},
        {10, "X"},
        {9, "IX"},
        {5, "V"},
        {4, "IV"},
        {1, "I"}
    };
    
    string result = "";
    for (auto& p : roman) {
        while (num >= p.first) {
            result += p.second;
            num -= p.first;
        }
    }
    return result;
}
```

### 5. Pow(x, n)
**Problem**: Implement pow(x, n), which calculates x raised to the power n (i.e., x^n).

**Solution** (Binary Exponentiation):
```cpp
double myPow(double x, int n) {
    if (n == 0) return 1.0;
    if (n == INT_MIN) return 1.0 / (myPow(x, INT_MAX) * x); // Handle INT_MIN special case
    
    long exp = labs(n);
    double result = 1.0;
    
    while (exp > 0) {
        if (exp & 1) result *= x;
        x *= x;
        exp >>= 1;
    }
    
    return (n < 0) ? 1.0 / result : result;
}
```

### 6. Sqrt(x)
**Problem**: Given a non-negative integer x, compute and return the square root of x.

**Solution** (Binary Search):
```cpp
int mySqrt(int x) {
    if (x < 2) return x;
    
    long left = 1;
    long right = x / 2;
    
    while (left <= right) {
        long mid = left + (right - left) / 2;
        long square = mid * mid;
        
        if (square == x) {
            return mid;
        } else if (square < x) {
            left = mid + 1;
        } else {
            right = mid - 1;
        }
    }
    
    return right;
}
```

### 7. Excel Sheet Column Number
**Problem**: Given a columnTitle as appear in an Excel sheet, return its corresponding column number.

**Solution**:
```cpp
int titleToNumber(string columnTitle) {
    int result = 0;
    for (char c : columnTitle) {
        result = result * 26 + (c - 'A' + 1);
    }
    return result;
}
```

### 8. Excel Sheet Column Title
**Problem**: Given an integer columnNumber, return its corresponding column title as it appears in an Excel sheet.

**Solution**:
```cpp
string convertToTitle(int columnNumber) {
    string result = "";
    
    while (columnNumber > 0) {
        columnNumber--; // Adjust for 1-indexed
        result += ('A' + columnNumber % 26);
        columnNumber /= 26;
    }
    
    reverse(result.begin(), result.end());
    return result;
}
```

### 9. Factorial Trailing Zeroes
**Problem**: Given an integer n, return the number of trailing zeroes in n!.

**Solution**:
```cpp
int trailingZeroes(int n) {
    int count = 0;
    for (long i = 5; n / i >= 1; i *= 5) {
        count += n / i;
    }
    return count;
}
```

### 10. Power of Three
**Problem**: Given an integer n, return true if it is a power of three.

**Solution**:
```cpp
bool isPowerOfThree(int n) {
    // The largest power of 3 that fits in 32-bit signed integer is 3^19 = 1162261467
    return n > 0 && 1162261467 % n == 0;
}
```

**Alternative solution**:
```cpp
bool isPowerOfThree(int n) {
    if (n <= 0) return false;
    while (n % 3 == 0) {
        n /= 3;
    }
    return n == 1;
}
```

---

## Graph Problems

### 1. Number of Islands
**Problem**: Given an m x n 2D binary grid grid which represents a map of '1's (land) and '0's (water), return the number of islands.

**Solution** (DFS):
```cpp
int numIslands(vector<vector<char>>& grid) {
    if (grid.empty() || grid[0].empty()) return 0;
    
    int rows = grid.size();
    int cols = grid[0].size();
    int islands = 0;
    
    function<void(int, int)> dfs = [&](int r, int c) {
        // Check boundaries and if it's water
        if (r < 0 || r >= rows || c < 0 || c >= cols || grid[r][c] == '0') {
            return;
        }
        
        // Mark as visited
        grid[r][c] = '0';
        
        // Visit all adjacent cells
        dfs(r + 1, c);
        dfs(r - 1, c);
        dfs(r, c + 1);
        dfs(r, c - 1);
    };
    
    for (int r = 0; r < rows; r++) {
        for (int c = 0; c < cols; c++) {
            if (grid[r][c] == '1') {
                islands++;
                dfs(r, c);
            }
        }
    }
    return islands;
}
```

**Solution** (BFS):
```cpp
int numIslands(vector<vector<char>>& grid) {
    if (grid.empty() || grid[0].empty()) return 0;
    
    int rows = grid.size();
    int cols = grid[0].size();
    int islands = 0;
    vector<pair<int, int>> directions = {{0,1}, {0,-1}, {1,0}, {-1,0}};
    
    for (int r = 0; r < rows; r++) {
        for (int c = 0; c < cols; c++) {
            if (grid[r][c] == '1') {
                islands++;
                queue<pair<int, int>> q;
                q.push({r, c});
                grid[r][c] = '0'; // Mark as visited
                
                while (!q.empty()) {
                    auto [row, col] = q.front();
                    q.pop();
                    
                    for (auto [dr, dc] : directions) {
                        int new_r = row + dr;
                        int new_c = col + dc;
                        
                        if (new_r >= 0 && new_r < rows && new_c >= 0 && new_c < cols && grid[new_r][new_c] == '1') {
                            q.push({new_r, new_c});
                            grid[new_r][new_c] = '0'; // Mark as visited
                        }
                    }
                }
            }
        }
    }
    return islands;
}
```

### 2. Course Schedule
**Problem**: There are a total of numCourses courses you have to take, labeled from 0 to numCourses - 1. You are given an array prerequisites where prerequisites[i] = [ai, bi] indicates that you must take course bi first if you want to take course ai.

**Solution** (Topological Sort - Kahn's Algorithm):
```cpp
bool canFinish(int numCourses, vector<vector<int>>& prerequisites) {
    vector<vector<int>> adj(numCourses);
    vector<int> in_degree(numCourses, 0);
    
    // Build graph
    for (auto& edge : prerequisites) {
        adj[edge[1]].push_back(edge[0]);
        in_degree[edge[0]]++;
    }
    
    // Queue for nodes with zero in-degree
    queue<int> q;
    for (int i = 0; i < numCourses; i++) {
        if (in_degree[i] == 0) {
            q.push(i);
        }
    }
    
    int count = 0;
    while (!q.empty()) {
        int course = q.front();
        q.pop();
        count++;
        
        for (int neighbor : adj[course]) {
            in_degree[neighbor]--;
            if (in_degree[neighbor] == 0) {
                q.push(neighbor);
            }
        }
    }
    
    return count == numCourses;
}
```

### 3. Clone Graph
**Problem**: Given a reference of a node in a connected undirected graph, return a deep copy (clone) of the graph.

**Solution** (DFS with Hash Map):
```cpp
/*
// Definition for a Node.
class Node {
public:
    int val;
    vector<Node*> neighbors;
    Node() {
        val = 0;
        neighbors = vector<Node*>();
    }
    Node(int _val) {
        val = _val;
        neighbors = vector<Node*>();
    }
    Node(int _val, vector<Node*> _neighbors) {
        val = _val;
        neighbors = _neighbors;
    }
};
*/

class Solution {
private:
    unordered_map<Node*, Node*> visited;
    
public:
    Node* cloneGraph(Node* node) {
        if (!node) return nullptr;
        
        // If the node was already visited, return the clone from the visited map
        if (visited.find(node) != visited.end()) {
            return visited[node];
        }
        
        // Create a clone for the given node
        Node* clone = new Node(node->val);
        visited[node] = clone; // Save the clone in the visited map
        
        // Recursively clone the neighbors
        for (Node* neighbor : node->neighbors) {
            clone->neighbors.push_back(cloneGraph(neighbor));
        }
        
        return clone;
    }
};
```

### 4. Graph Valid Tree
**Problem**: Given n nodes labeled from 0 to n - 1 and a list of undirected edges (each edge is a pair of nodes), write a function to check whether these edges make up a valid tree.

**Solution** (Union-Find):
```cpp
bool validTree(int n, vector<vector<int>>& edges) {
    // A tree with n nodes must have exactly n-1 edges
    if (edges.size() != n - 1) return false;
    
    DSU dsu(n);
    
    // Check for cycles
    for (auto& edge : edges) {
        if (!dsu.unite(edge[0], edge[1])) {
            return false; // Cycle detected
        }
    }
    
    // If we have exactly n-1 edges and no cycles, it's a tree
    return dsu.getComponents() == 1;
}
```

### 5. Network Delay Time
**Problem**: You are given a network of n nodes, labeled from 1 to n. You are also given times, a list of travel times as directed edges times[i] = (ui, vi, wi), where ui is the source node, vi is the target node, and wi is the time it takes for a signal to travel from source to target.

**Solution** (Dijkstra's Algorithm):
```cpp
int networkDelayTime(vector<vector<int>>& times, int n, int k) {
    // Build adjacency list
    vector<vector<pair<int, int>>> adj(n + 1);
    for (auto& time : times) {
        adj[time[0]].push_back({time[1], time[2]});
    }
    
    // Dijkstra's algorithm
    vector<int> dist(n + 1, INT_MAX);
    priority_queue<pair<int, int>, vector<pair<int, int>>, greater<pair<int, int>>> pq;
    
    dist[k] = 0;
    pq.push({0, k});
    
    while (!pq.empty()) {
        int time = pq.top().first;
        int node = pq.top().second;
        pq.pop();
        
        if (time > dist[node]) continue; // Skip if we found a better path already
        
        for (auto& edge : adj[node]) {
            int neighbor = edge.first;
            int travel_time = edge.second;
            
            if (dist[node] + travel_time < dist[neighbor]) {
                dist[neighbor] = dist[node] + travel_time;
                pq.push({dist[neighbor], neighbor});
            }
        }
    }
    
    // Find the maximum time needed to reach any node
    int max_time = 0;
    for (int i = 1; i <= n; i++) {
        if (dist[i] == INT_MAX) return -1; // Unreachable node
        max_time = max(max_time, dist[i]);
    }
    return max_time;
}
```

### 6. Pacific Atlantic Water Flow
**Problem**: Given an m x n matrix of non-negative integers representing the height of each unit cell in a continent, the "Pacific ocean" touches the left and top edges of the matrix and the "Atlantic ocean" touches the right and bottom edges.

**Solution** (DFS from Oceans):
```cpp
vector<vector<int>> pacificAtlantic(vector<vector<int>>& heights) {
    if (heights.empty() || heights[0].empty()) return {};
    
    int rows = heights.size();
    int cols = heights[0].size();
    
    vector<vector<bool>> pacific_reachable(rows, vector<bool>(cols, false));
    vector<vector<bool>> atlantic_reachable(rows, vector<bool>(cols, false));
    
    // Helper function for DFS
    function<void(int, int, vector<vector<bool>>&)> dfs = [&](int r, int c, vector<vector<bool>>& reachable) {
        reachable[r][c] = true;
        vector<pair<int, int>> directions = {{0,1}, {0,-1}, {1,0}, {-1,0}};
        
        for (auto [dr, dc] : directions) {
            int new_r = r + dr;
            int new_c = c + dc;
            
            // Check boundaries and if we can flow to this cell (height must be >= current)
            if (new_r >= 0 && new_r < rows && new_c >= 0 && new_c < cols && 
                !reachable[new_r][new_c] && heights[new_r][new_c] >= heights[r][c]) {
                dfs(new_r, new_c, reachable);
            }
        }
    };
    
    // Start DFS from Pacific Ocean borders (top and left)
    for (int c = 0; c < cols; c++) {
        dfs(0, c, pacific_reachable); // Top row
    }
    for (int r = 0; r < rows; r++) {
        dfs(r, 0, pacific_reachable); // Left column
    }
    
    // Start DFS from Atlantic Ocean borders (bottom and right)
    for (int c = 0; c < cols; c++) {
        dfs(rows - 1, c, atlantic_reachable); // Bottom row
    }
    for (int r = 0; r < rows; r++) {
        dfs(r, cols - 1, atlantic_reachable); // Right column
    }
    
    // Find intersection of cells reachable from both oceans
    vector<vector<int>> result;
    for (int r = 0; r < rows; r++) {
        for (int c = 0; c < cols; c++) {
            if (pacific_reachable[r][c] && atlantic_reachable[r][c]) {
                result.push_back({r, c});
            }
        }
    }
    return result;
}
```

---

## Dynamic Programming Problems

### 1. Climbing Stairs
**Problem**: You are climbing a stair case. It takes n steps to reach the top. Each time you can either climb 1 or 2 steps. In how many distinct ways can you climb to the top?

**Solution**:
```cpp
int climbStairs(int n) {
    if (n <= 2) return n;
    
    int prev2 = 1; // Ways to reach step i-2
    int prev1 = 2; // Ways to reach step i-1
    
    for (int i = 3; i <= n; i++) {
        int current = prev1 + prev2;
        prev2 = prev1;
        prev1 = current;
    }
    return prev1;
}
```

### 2. House Robber
**Problem**: You are a professional robber planning to rob houses along a street. Each house has a certain amount of money stashed, the only constraint stopping you from robbing each of them is that adjacent houses have security system connected and it will automatically contact the police if two adjacent houses were broken into on the same night.

**Solution**:
```cpp
int rob(vector<int>& nums) {
    int prev2 = 0; // Max money up to i-2
    int prev1 = 0; // Max money up to i-1
    
    for (int money : nums) {
        int current = max(prev1, prev2 + money);
        prev2 = prev1;
        prev1 = current;
    }
    return prev1;
}
```

### 3. Unique Paths
**Problem**: A robot is located at the top-left corner of a m x n grid (marked 'Start' in the diagram below). The robot can only move either down or right at any point in time. The robot is trying to reach the bottom-right corner of the grid (marked 'Finish').

**Solution**:
```cpp
int uniquePaths(int m, int n) {
    // Use 1D DP to save space
    vector<int> dp(n, 1);
    
    for (int i = 1; i < m; i++) {
        for (int j = 1; j < n; j++) {
            dp[j] += dp[j-1];
        }
    }
    return dp[n-1];
}
```

### 4. Unique Paths II
**Problem**: Same as Unique Paths but now some cells are obstacles.

**Solution**:
```cpp
int uniquePathsWithObstacles(vector<vector<int>>& obstacleGrid) {
    int m = obstacleGrid.size();
    int n = obstacleGrid[0].size();
    
    // If start or end is blocked
    if (obstacleGrid[0][0] == 1 || obstacleGrid[m-1][n-1] == 1) return 0;
    
    vector<long> dp(n, 0);
    dp[0] = 1;
    
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            if (obstacleGrid[i][j] == 1) {
                dp[j] = 0; // Obstacle
            } else if (j > 0) {
                dp[j] += dp[j-1]; // From left
            }
            // For j=0, dp[j] remains as is (from top only)
        }
    }
    return dp[n-1];
}
```

### 5. Minimum Path Sum
**Problem**: Given a m x n grid filled with non-negative numbers, find a path from top left to bottom right which minimizes the sum of all numbers along its path.

**Solution**:
```cpp
int minPathSum(vector<vector<int>>& grid) {
    int m = grid.size();
    int n = grid[0].size();
    
    // Modify the grid in-place to save space
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            if (i == 0 && j == 0) continue; // Starting point
            else if (i == 0) { // First row - can only come from left
                grid[i][j] += grid[i][j-1];
            } else if (j == 0) { // First column - can only come from top
                grid[i][j] += grid[i-1][j];
            } else { // Can come from top or left
                grid[i][j] += min(grid[i-1][j], grid[i][j-1]);
            }
        }
    }
    return grid[m-1][n-1];
}
```

### 6. Triangle
**Problem**: Given a triangle array, return the minimum path sum from top to bottom.

**Solution**:
```cpp
int minimumTotal(vector<vector<int>>& triangle) {
    int n = triangle.size();
    vector<int> dp = triangle.back(); // Start with the last row
    
    // Bottom-up DP
    for (int i = n - 2; i >= 0; i--) {
        for (int j = 0; j <= i; j++) {
            dp[j] = triangle[i][j] + min(dp[j], dp[j+1]);
        }
    }
    return dp[0];
}
```

### 7. Maximum Subarray
**Problem**: Given an integer array nums, find the contiguous subarray (containing at least one number) which has the largest sum and return its sum.

**Solution** (Kadane's Algorithm):
```cpp
int maxSubArray(vector<int>& nums) {
    int max_sum = nums[0];
    int current_sum = nums[0];
    
    for (int i = 1; i < nums.size(); i++) {
        current_sum = max(nums[i], current_sum + nums[i]);
        max_sum = max(max_sum, current_sum);
    }
    return max_sum;
}
```

### 8. Maximum Product Subarray
**Problem**: Given an integer array nums, find the contiguous subarray within an array (containing at least one number) which has the largest product.

**Solution**:
```cpp
int maxProduct(vector<int>& nums) {
    if (nums.empty()) return 0;
    
    int max_prod = nums[0];
    int min_prod = nums[0]; // Track min because negative * negative = positive
    int result = nums[0];
    
    for (int i = 1; i < nums.size(); i++) {
        int num = nums[i];
        
        // If current number is negative, swap max and min
        if (num < 0) swap(max_prod, min_prod);
        
        max_prod = max(num, max_prod * num);
        min_prod = min(num, min_prod * num);
        
        result = max(result, max_prod);
    }
    return result;
}
```

### 9. Best Time to Buy and Sell Stock III
**Problem**: You are given an array prices where prices[i] is the price of a given stock on the ith day. Find the maximum profit you can achieve. You may complete at most two transactions.

**Solution**:
```cpp
int maxProfit(vector<int>& prices) {
    int n = prices.size();
    if (n <= 1) return 0;
    
    // DP approach: track 4 states
    int buy1 = INT_MIN, sell1 = 0;
    int buy2 = INT_MIN, sell2 = 0;
    
    for (int price : prices) {
        buy1 = max(buy1, -price);           // Max profit after 1st buy
        sell1 = max(sell1, buy1 + price);   // Max profit after 1st sell
        buy2 = max(buy2, sell1 - price);    // Max profit after 2nd buy
        sell2 = max(sell2, buy2 + price);   // Max profit after 2nd sell
    }
    return sell2;
}
```

### 10. Best Time to Buy and Sell Stock IV
**Problem**: You are given an integer array prices where prices[i] is the price of a given stock on the ith day, and an integer k. Find the maximum profit you can achieve. You may complete at most k transactions.

**Solution**:
```cpp
int maxProfit(int k, vector<int>& prices) {
    int n = prices.size();
    if (n <= 1) return 0;
    
    // If k >= n/2, we can make as many transactions as we want
    if (k >= n / 2) {
        int profit = 0;
        for (int i = 1; i < n; i++) {
            if (prices[i] > prices[i-1]) {
                profit += prices[i] - prices[i-1];
            }
        }
        return profit;
    }
    
    // DP approach for limited transactions
    vector<int> buy(k + 1, INT_MIN);
    vector<int> sell(k + 1, 0);
    
    for (int price : prices) {
        for (int i = 1; i <= k; i++) {
            buy[i] = max(buy[i], sell[i-1] - price);
            sell[i] = max(sell[i], buy[i] + price);
        }
    }
    return sell[k];
}
```

### 11. Longest Increasing Subsequence
**Problem**: Given an integer array nums, return the length of the longest strictly increasing subsequence.

**Solution** (DP with Binary Search - O(n log n)):
```cpp
int lengthOfLIS(vector<int>& nums) {
    if (nums.empty()) return 0;
    
    vector<int> tails;
    tails.push_back(nums[0]);
    
    for (int i = 1; i < nums.size(); i++) {
        if (nums[i] > tails.back()) {
            tails.push_back(nums[i]);
        } else {
            // Find the first element >= nums[i] and replace it
            auto it = lower_bound(tails.begin(), tails.end(), nums[i]);
            *it = nums[i];
        }
    }
    return tails.size();
}
```

### 12. Longest Common Subsequence
**Problem**: Given two strings text1 and text2, return the length of their longest common subsequence.

**Solution**:
```cpp
int longestCommonSubsequence(string text1, string text2) {
    int m = text1.size();
    int n = text2.size();
    vector<vector<int>> dp(m + 1, vector<int>(n + 1, 0));
    
    for (int i = 1; i <= m; i++) {
        for (int j = 1; j <= n; j++) {
            if (text1[i-1] == text2[j-1]) {
                dp[i][j] = dp[i-1][j-1] + 1;
            } else {
                dp[i][j] = max(dp[i-1][j], dp[i][j-1]);
            }
        }
    }
    return dp[m][n];
}
```

### 13. Edit Distance
**Problem**: Given two strings word1 and word2, return the minimum number of operations required to convert word1 to word2.

**Solution**:
```cpp
int minDistance(string word1, string word2) {
    int m = word1.size();
    int n = word2.size();
    vector<vector<int>> dp(m + 1, vector<int>(n + 1, 0));
    
    // Initialize base cases
    for (int i = 0; i <= m; i++) dp[i][0] = i;
    for (int j = 0; j <= n; j++) dp[0][j] = j;
    
    for (int i = 1; i <= m; i++) {
        for (int j = 1; j <= n; j++) {
            if (word1[i-1] == word2[j-1]) {
                dp[i][j] = dp[i-1][j-1];
            } else {
                dp[i][j] = 1 + min({dp[i-1][j], dp[i][j-1], dp[i-1][j-1]});
            }
        }
    }
    return dp[m][n];
}
```

### 14. Word Break
**Problem**: Given a string s and a dictionary of strings wordDict, return true if s can be segmented into a space-separated sequence of one or more dictionary words.

**Solution**:
```cpp
bool wordBreak(string s, vector<string>& wordDict) {
    unordered_set<string> wordSet(wordDict.begin(), wordDict.end());
    vector<bool> dp(s.size() + 1, false);
    dp[0] = true;
    
    for (int i = 1; i <= s.size(); i++) {
        for (int j = 0; j < i; j++) {
            if (dp[j] && wordSet.count(s.substr(j, i - j))) {
                dp[i] = true;
                break;
            }
        }
    }
    return dp[s.size()];
}
```

### 15. Decode Ways
**Problem**: A message containing letters from A-Z can be encoded into numbers using the following mapping: 'A' -> "1", 'B' -> "2", ..., 'Z' -> "26".

**Solution**:
```cpp
int numDecodings(string s) {
    if (s.empty() || s[0] == '0') return 0;
    
    int n = s.size();
    vector<int> dp(n + 1, 0);
    dp[0] = 1; // Empty string
    dp[1] = 1; // First character (if not '0')
    
    for (int i = 2; i <= n; i++) {
        // One digit decode
        if (s[i-1] != '0') {
            dp[i] += dp[i-1];
        }
        
        // Two digit decode
        int two_digit = stoi(s.substr(i-2, 2));
        if (two_digit >= 10 && two_digit <= 26) {
            dp[i] += dp[i-2];
        }
    }
    return dp[n];
}
```

### 16. Coin Change
**Problem**: Given an integer array coins representing coins of different denominations and an integer amount representing a total amount of money, return the fewest number of coins that you need to make up that amount.

**Solution**:
```cpp
int coinChange(vector<int>& coins, int amount) {
    vector<int> dp(amount + 1, amount + 1); // Initialize with a value larger than max possible
    dp[0] = 0;
    
    for (int i = 1; i <= amount; i++) {
        for (int coin : coins) {
            if (coin <= i) {
                dp[i] = min(dp[i], dp[i - coin] + 1);
            }
        }
    }
    
    return dp[amount] > amount ? -1 : dp[amount];
}
```

### 17. Coin Change 2
**Problem**: You are given an integer array coins representing coins of different denominations and an integer amount representing a total amount of money. Return the number of combinations that make up that amount.

**Solution**:
```cpp
int change(int amount, vector<int>& coins) {
    vector<int> dp(amount + 1, 0);
    dp[0] = 1; // One way to make amount 0
    
    for (int coin : coins) {
        for (int i = coin; i <= amount; i++) {
            dp[i] += dp[i - coin];
        }
    }
    return dp[amount];
}
```

### 18. Longest Palindromic Subsequence
**Problem**: Given a string s, find the longest palindromic subsequence's length in s.

**Solution**:
```cpp
int longestPalindromeSubseq(string s) {
    int n = s.size();
    vector<vector<int>> dp(n, vector<int>(n, 0));
    
    // Every single character is a palindrome of length 1
    for (int i = 0; i < n; i++) {
        dp[i][i] = 1;
    }
    
    // Fill the DP table
    for (int len = 2; len <= n; len++) {
        for (int i = 0; i <= n - len; i++) {
            int j = i + len - 1;
            if (s[i] == s[j]) {
                dp[i][j] = 2 + (len == 2 ? 0 : dp[i+1][j-1]);
            } else {
                dp[i][j] = max(dp[i+1][j], dp[i][j-1]);
            }
        }
    }
    return dp[0][n-1];
}
```

### 19. Regular Expression Matching
**Problem**: Given an input string s and a pattern p, implement regular expression matching with support for '.' and '*'.

**Solution**:
```cpp
bool isMatch(string s, string p) {
    int m = s.size();
    int n = p.size();
    vector<vector<bool>> dp(m + 1, vector<bool>(n + 1, false));
    
    // Empty pattern matches empty string
    dp[0][0] = true;
    
    // Handle patterns like a*, a*b*, a*b*c* etc. that can match empty string
    for (int j = 1; j <= n; j++) {
        if (p[j-1] == '*') {
            dp[0][j] = dp[0][j-2];
        }
    }
    
    for (int i = 1; i <= m; i++) {
        for (int j = 1; j <= n; j++) {
            if (p[j-1] == '.' || p[j-1] == s[i-1]) {
                dp[i][j] = dp[i-1][j-1];
            } else if (p[j-1] == '*') {
                dp[i][j] = dp[i][j-2]; // Zero occurrences of preceding element
                if (p[j-2] == '.' || p[j-2] == s[i-1]) {
                    dp[i][j] = dp[i][j] || dp[i-1][j]; // One or more occurrences
                }
            }
        }
    }
    return dp[m][n];
}
```

### 20. Interleaving String
**Problem**: Given strings s1, s2, and s3, determine whether s3 is formed by an interleaving of s1 and s2.

**Solution**:
```cpp
bool isInterleave(string s1, string s2, string s3) {
    int m = s1.size();
    int n = s2.size();
    
    if (m + n != s3.size()) return false;
    
    vector<vector<bool>> dp(m + 1, vector<bool>(n + 1, false));
    dp[0][0] = true;
    
    // Initialize first row (s2 only)
    for (int j = 1; j <= n; j++) {
        dp[0][j] = dp[0][j-1] && (s2[j-1] == s3[j-1]);
    }
    
    // Initialize first column (s1 only)
    for (int i = 1; i <= m; i++) {
        dp[i][0] = dp[i-1][0] && (s1[i-1] == s3[i-1]);
    }
    
    for (int i = 1; i <= m; i++) {
        for (int j = 1; j <= n; j++) {
            dp[i][j] = (dp[i-1][j] && s1[i-1] == s3[i+j-1]) ||
                       (dp[i][j-1] && s2[j-1] == s3[i+j-1]);
        }
    }
    return dp[m][n];
}
```

---

## Greedy Problems

### 1. Jump Game
**Problem**: Given an array of non-negative integers nums, you are initially positioned at the first index of the array. Each element in the array represents your maximum jump length at that position. Determine if you are able to reach the last index.

**Solution**:
```cpp
bool canJump(vector<int>& nums) {
    int max_reach = 0;
    for (int i = 0; i < nums.size(); i++) {
        if (i > max_reach) return false; // Cannot reach this position
        max_reach = max(max_reach, i + nums[i]);
        if (max_reach >= nums.size() - 1) return true; // Can reach or surpass last index
    }
    return true;
}
```

### 2. Jump Game II
**Problem**: Given an array of non-negative integers nums, you are initially positioned at the first index of the array. Each element in the array represents your maximum jump length at that position. Your goal is to reach the last index in the minimum number of jumps.

**Solution**:
```cpp
int jump(vector<int>& nums) {
    if (nums.size() <= 1) return 0;
    
    int jumps = 0;
    int current_end = 0;
    int farthest = 0;
    
    for (int i = 0; i < nums.size() - 1; i++) {
        farthest = max(farthest, i + nums[i]);
        
        if (i == current_end) {
            jumps++;
            current_end = farthest;
            
            if (current_end >= nums.size() - 1) break;
        }
    }
    return jumps;
}
```

### 3. Gas Station
**Problem**: There are n gas stations along a circular route, where the amount of gas at the ith station is gas[i]. You have a car with an unlimited gas tank and it costs cost[i] of gas to travel from the ith station to its next (i + 1)th station.

**Solution**:
```cpp
int canCompleteCircuit(vector<int>& gas, vector<int>& cost) {
    int total_tank = 0;
    int curr_tank = 0;
    int start_station = 0;
    
    for (int i = 0; i < gas.size(); i++) {
        total_tank += gas[i] - cost[i];
        curr_tank += gas[i] - cost[i];
        
        if (curr_tank < 0) {
            // Cannot reach next station, reset starting point
            start_station = i + 1;
            curr_tank = 0;
        }
    }
    
    return total_tank >= 0 ? start_station : -1;
}
```

### 4. Candy
**Problem**: There are n children standing in a line. Each child is assigned a rating value given in the integer array ratings. You are giving candies to these children subjected to the following requirements: Each child must have at least one candy. Children with a higher rating get more candies than their neighbors.

**Solution**:
```cpp
int candy(vector<int>& ratings) {
    int n = ratings.size();
    if (n == 0) return 0;
    
    vector<int> candies(n, 1);
    
    // Left to right pass
    for (int i = 1; i < n; i++) {
        if (ratings[i] > ratings[i-1]) {
            candies[i] = candies[i-1] + 1;
        }
    }
    
    // Right to left pass
    for (int i = n - 2; i >= 0; i--) {
        if (ratings[i] > ratings[i+1]) {
            candies[i] = max(candies[i], candies[i+1] + 1);
        }
    }
    
    return accumulate(candies.begin(), candies.end(), 0);
}
```

### 5. Partition Labels
**Problem**: You are given a string s. We want to partition the string into as many parts as possible so that each letter appears in at most one part.

**Solution**:
```cpp
vector<int> partitionLabels(string s) {
    vector<int> last(26, 0);
    for (int i = 0; i < s.size(); i++) {
        last[s[i] - 'a'] = i;
    }
    
    vector<int> result;
    int start = 0;
    int end = 0;
    
    for (int i = 0; i < s.size(); i++) {
        end = max(end, last[s[i] - 'a']);
        if (i == end) {
            result.push_back(end - start + 1);
            start = i + 1;
        }
    }
    return result;
}
```

### 6. Queue Reconstruction by Height
**Problem**: Suppose you have a random list of people standing in a queue. Each person is described by a pair of integers (h, k), where h is the height of the person and k is the number of people in front of this person who have a height greater than or equal to h.

**Solution**:
```cpp
vector<vector<int>> reconstructQueue(vector<vector<int>>& people) {
    // Sort by height descending, and by k ascending for same height
    sort(people.begin(), people.end(), [](const vector<int>& a, const vector<int>& b) {
        return a[0] > b[0] || (a[0] == b[0] && a[1] < b[1]);
    });
    
    vector<vector<int>> result;
    for (const auto& person : people) {
        result.insert(result.begin() + person[1], person);
    }
    return result;
}
```

### 7. Lemonade Change
**Problem**: At a lemonade stand, each lemonade costs $5. Customers are standing in a queue to buy from you and order one at a time. Each customer will only buy one lemonade and pay with either a $5, $10, or $20 bill.

**Solution**:
```cpp
bool lemonadeChange(vector<int>& bills) {
    int five = 0;
    int ten = 0;
    
    for (int bill : bills) {
        if (bill == 5) {
            five++;
        } else if (bill == 10) {
            if (five == 0) return false;
            five--;
            ten++;
        } else { // bill == 20
            if (ten > 0 && five > 0) {
                ten--;
                five--;
            } else if (five >= 3) {
                five -= 3;
            } else {
                return false;
            }
        }
    }
    return true;
}
```

### 8. Task Scheduler
**Problem**: Given a characters array tasks, representing the tasks a CPU needs to do, where each letter represents a different task. Tasks could be done in any order. Each task is done in one unit of time. For each unit of time, the CPU could complete either one task or just be idle.

**Solution**:
```cpp
int leastInterval(vector<char>& tasks, int n) {
    vector<int> count(26, 0);
    for (char c : tasks) {
        count[c - 'A']++;
    }
    
    sort(count.begin(), count.end());
    
    int max_count = count[25]; // Maximum frequency
    int max_count_tasks = 1;   // Number of tasks with maximum frequency
    
    for (int i = 24; i >= 0 && count[i] == max_count; i--) {
        max_count_tasks++;
    }
    
    int part_count = max_count - 1;
    int part_length = n - (max_count_tasks - 1);
    int empty_slots = part_count * part_length;
    int available_tasks = tasks.size() - max_count * max_count_tasks;
    int idles = max(0, empty_slots - available_tasks);
    
    return tasks.size() + idles;
}
```

### 9. Flatten Binary Tree to Linked List
**Problem**: Given the root of a binary tree, flatten the tree into a "linked list": The "linked list" should use the same TreeNode class where the right child pointer points to the next node in the list and the left child pointer is always null.

**Solution** (Morris Traversal):
```cpp
void flatten(TreeNode* root) {
    TreeNode* curr = root;
    while (curr) {
        if (curr->left) {
            // Find the rightmost node in left subtree
            TreeNode* prev = curr->left;
            while (prev->right) {
                prev = prev->right;
            }
            
            // Connect rightmost node of left subtree to right subtree
            prev->right = curr->right;
            
            // Move left subtree to right
            curr->right = curr->left;
            curr->left = nullptr;
        }
        curr = curr->right;
    }
}
```

### 10. Meeting Rooms II
**Problem**: Given an array of meeting time intervals intervals where intervals[i] = [starti, endi], return the minimum number of conference rooms required.

**Solution**:
```cpp
int minMeetingRooms(vector<vector<int>>& intervals) {
    if (intervals.empty()) return 0;
    
    vector<int> starts;
    vector<int> ends;
    
    for (auto& interval : intervals) {
        starts.push_back(interval[0]);
        ends.push_back(interval[1]);
    }
    
    sort(starts.begin(), starts.end());
    sort(ends.begin(), ends.end());
    
    int rooms = 0;
    int ended = 0;
    
    for (int i = 0; i < starts.size(); i++) {
        if (starts[i] < ends[ended]) {
            rooms++; // Need a new room
        } else {
            ended++; // A meeting ended, reuse the room
        }
    }
    return rooms;
}
```

---

## Data Structure Problems

### 1. LRU Cache
**Problem**: Design a data structure that follows the constraints of a Least Recently Used (LRU) cache.

**Solution**:
```cpp
class LRUCache {
private:
    struct Node {
        int key, value;
        Node* prev;
        Node* next;
        Node(int k, int v) : key(k), value(v), prev(nullptr), next(nullptr) {}
    };
    
    int capacity;
    unordered_map<int, Node*> cache;
    Node* head; // Dummy head
    Node* tail; // Dummy tail
    
    void addNode(Node* node) {
        node->prev = head;
        node->next = head->next;
        head->next->prev = node;
        head->next = node;
    }
    
    void removeNode(Node* node) {
        Node* prev_node = node->prev;
        Node* next_node = node->next;
        prev_node->next = next_node;
        next_node->prev = prev_node;
    }
    
    void moveToHead(Node* node) {
        removeNode(node);
        addNode(node);
    }
    
    Node* popTail() {
        Node* res = tail->prev;
        removeNode(res);
        return res;
    }
    
public:
    LRUCache(int capacity) {
        this->capacity = capacity;
        head = new Node(0, 0);
        tail = new Node(0, 0);
        head->next = tail;
        tail->prev = head;
    }
    
    int get(int key) {
        auto it = cache.find(key);
        if (it == cache.end()) return -1;
        
        Node* node = it->second;
        moveToHead(node);
        return node->value;
    }
    
    void put(int key, int value) {
        auto it = cache.find(key);
        if (it != cache.end()) {
            // Key exists, update value and move to head
            Node* node = it->second;
            node->value = value;
            moveToHead(node);
        } else {
            // New key
            Node* newNode = new Node(key, value);
            cache[key] = newNode;
            addNode(newNode);
            
            if (cache.size() > capacity) {
                // Remove the least recently used item
                Node* tail_node = popTail();
                cache.erase(tail_node->key);
                delete tail_node;
            }
        }
    }
};
```

### 2. Design Twitter
**Problem**: Design a simplified version of Twitter where users can post tweets, follow/unfollow another user, and is able to see the 10 most recent tweets in the user's news feed.

**Solution**:
```cpp
class Twitter {
private:
    struct Tweet {
        int id;
        int time;
        Tweet* next;
        Tweet(int i, int t) : id(i), time(t), next(nullptr) {}
    };
    
    unordered_map<int, Tweet*> userTweets; // userID -> head of tweet list
    unordered_map<int, unordered_set<int>> followers; // userID -> set of followees
    int timestamp;
    
public:
    Twitter() {
        timestamp = 0;
    }
    
    void postTweet(int userId, int tweetId) {
        Tweet* newTweet = new Tweet(tweetId, timestamp++);
        newTweet->next = userTweets[userId];
        userTweets[userId] = newTweet;
    }
    
    vector<int> getNewsFeed(int userId) {
        vector<int> result;
        // Min-heap to get the 10 most recent tweets
        auto cmp = [](Tweet* a, Tweet* b) { return a->time < b->time; };
        priority_queue<Tweet*, vector<Tweet*>, decltype(cmp)> pq(cmp);
        
        // Add user's own tweets
        if (userTweets.find(userId) != userTweets.end()) {
            pq.push(userTweets[userId]);
        }
        
        // Add followees' tweets
        if (followers.find(userId) != followers.end()) {
            for (int followee : followers[userId]) {
                if (userTweets.find(followee) != userTweets.end()) {
                    pq.push(userTweets[followee]);
                }
            }
        }
        
        // Extract up to 10 most recent tweets
        while (!pq.empty() && result.size() < 10) {
            Tweet* tweet = pq.top();
            pq.pop();
            result.push_back(tweet->id);
            
            if (tweet->next) {
                pq.push(tweet->next);
            }
        }
        return result;
    }
    
    void follow(int followerId, int followeeId) {
        if (followerId == followeeId) return; // Cannot follow yourself
        followers[followerId].insert(followeeId);
    }
    
    void unfollow(int followerId, int followeeId) {
        if (followerId == followeeId) return; // Cannot unfollow yourself
        if (followers.find(followerId) != followers.end()) {
            followers[followerId].erase(followeeId);
        }
    }
};
```

### 3. Number of Islands II
**Problem**: You are given an empty 2D binary grid of size m x n. The grid represents a map where 0's represent water and 1's represent land. Initially, all the cells of the grid are water cells.

**Solution** (Union-Find):
```cpp
class DSU {
public:
    vector<int> parent;
    vector<int> rank;
    int count;
    
    DSU(int n) {
        parent.resize(n);
        rank.assign(n, 0);
        count = 0;
        for (int i = 0; i < n; i++) {
            parent[i] = i;
        }
    }
    
    int find(int x) {
        if (x != parent[x]) parent[x] = find(parent[x]);
        return parent[x];
    }
    
    bool unite(int x, int y) {
        int rootX = find(x);
        int rootY = find(y);
        if (rootX == rootY) return false;
        
        if (rank[rootX] < rank[rootY]) {
            swap(rootX, rootY);
        }
        parent[rootY] = rootX;
        if (rank[rootX] == rank[rootY]) rank[rootX]++;
        count--;
        return true;
    }
    
    void setParent(int x) {
        parent[x] = x;
        rank[x] = 0;
        count++;
    }
};

vector<int> numIslands2(int m, int n, vector<vector<int>>& positions) {
    DSU dsu(m * n);
    vector<int> result;
    vector<vector<bool>> grid(m, vector<bool>(n, false));
    vector<pair<int, int>> directions = {{0,1}, {0,-1}, {1,0}, {-1,0}};
    
    for (auto& pos : positions) {
        int r = pos[0];
        int c = pos[1];
        
        if (grid[r][c]) {
            // Land already exists
            result.push_back(dsu.count);
            continue;
        }
        
        // Mark as land
        grid[r][c] = true;
        int index = r * n + c;
        dsu.setParent(index);
        
        // Check neighbors and unite if they are also land
        for (auto [dr, dc] : directions) {
            int nr = r + dr;
            int nc = c + dc;
            
            if (nr >= 0 && nr < m && nc >= 0 && nc < n && grid[nr][nc]) {
                int nindex = nr * n + nc;
                dsu.unite(index, nindex);
            }
        }
        
        result.push_back(dsu.count);
    }
    return result;
}
```

### 4. The Maze
**Problem**: There is a ball in a maze with empty spaces and walls. The ball can go through empty spaces by rolling up, down, left or right, but it won't stop rolling until hitting a wall.

**Solution** (BFS):
```cpp
bool hasPath(vector<vector<int>>& maze, vector<int>& start, vector<int>& destination) {
    int rows = maze.size();
    int cols = maze[0].size();
    vector<vector<bool>> visited(rows, vector<bool>(cols, false));
    vector<pair<int, int>> directions = {{0,1}, {0,-1}, {1,0}, {-1,0}};
    
    queue<vector<int>> q;
    q.push(start);
    visited[start[0]][start[1]] = true;
    
    while (!q.empty()) {
        auto pos = q.front();
        q.pop();
        int r = pos[0];
        int c = pos[1];
        
        // If we reached destination
        if (r == destination[0] && c == destination[1]) {
            return true;
        }
        
        // Try rolling in all four directions
        for (auto [dr, dc] : directions) {
            int nr = r;
            int nc = c;
            
            // Roll until hitting a wall
            while (nr >= 0 && nr < rows && nc >= 0 && nc < cols && maze[nr][nc] == 0) {
                nr += dr;
                nc += dc;
            }
            
            // Step back to the last valid position
            nr -= dr;
            nc -= dc;
            
            // If we haven't visited this stopping position
            if (!visited[nr][nc]) {
                visited[nr][nc] = true;
                q.push({nr, nc});
            }
        }
    }
    return false;
}
```

### 5. Design Add and Search Words Data Structure
**Problem**: Design a data structure that supports adding new words and finding if a string matches any previously added string.

**Solution** (Trie with DFS):
```cpp
class WordDictionary {
private:
    struct TrieNode {
        bool isEnd;
        unordered_map<char, TrieNode*> children;
        TrieNode() : isEnd(false) {}
    };
    
    TrieNode* root;
    
    bool searchInNode(string& word, int index, TrieNode* node) {
        if (index == word.size()) {
            return node->isEnd;
        }
        
        char c = word[index];
        if (c == '.') {
            // Try all possible children
            for (auto& p : node->children) {
                if (searchInNode(word, index + 1, p.second)) {
                    return true;
                }
            }
            return false;
        } else {
            if (node->children.find(c) == node->children.end()) {
                return false;
            }
            return searchInNode(word, index + 1, node->children[c]);
        }
    }
    
public:
    WordDictionary() {
        root = new TrieNode();
    }
    
    void addWord(string word) {
        TrieNode* curr = root;
        for (char c : word) {
            if (curr->children.find(c) == curr->children.end()) {
                curr->children[c] = new TrieNode();
            }
            curr = curr->children[c];
        }
        curr->isEnd = true;
    }
    
    bool search(string word) {
        return searchInNode(word, 0, root);
    }
};
```

### 6. Evaluate Reverse Polish Notation
**Problem**: Evaluate the value of an arithmetic expression in Reverse Polish Notation.

**Solution**:
```cpp
int evalRPN(vector<string>& tokens) {
    stack<int> st;
    
    for (string& token : tokens) {
        if (token == "+" || token == "-" || token == "*" || token == "/") {
            int b = st.top(); st.pop();
            int a = st.top(); st.pop();
            
            if (token == "+") st.push(a + b);
            else if (token == "-") st.push(a - b);
            else if (token == "*") st.push(a * b);
            else if (token == "/") st.push(a / b);
        } else {
            st.push(stoi(token));
        }
    }
    return st.top();
}
```

---

## Geometry Problems

### 1. Valid Triangle Number
**Problem**: Given an array consists of non-negative integers, your task is to count the number of triplets chosen from the array that can make triangles if we take them as side lengths of a triangle.

**Solution**:
```cpp
int triangleNumber(vector<int>& nums) {
    sort(nums.begin(), nums.end());
    int count = 0;
    int n = nums.size();
    
    for (int i = n - 1; i >= 2; i--) {
        int left = 0;
        int right = i - 1;
        
        while (left < right) {
            if (nums[left] + nums[right] > nums[i]) {
                // All elements from left to right-1 can form triangle with nums[right] and nums[i]
                count += right - left;
                right--;
            } else {
                left++;
            }
        }
    }
    return count;
}
```

### 2. Convex Hull
**Problem**: Given a list of points, return the convex hull of these points.

**Solution** (Monotone Chain):
```cpp
vector<Point> convexHull(vector<Point>& points) {
    if (points.size() <= 1) return points;
    
    sort(points.begin(), points.end(), [](const Point& a, const Point& b) {
        return a.x < b.x || (a.x == b.x && a.y < b.y);
    });
    
    vector<Point> hull;
    
    // Build lower hull
    for (Point& p : points) {
        while (hull.size() >= 2 && cross(hull[hull.size()-2], hull.back(), p) <= 0) {
            hull.pop_back();
        }
        hull.push_back(p);
    }
    
    // Build upper hull
    int lower_hull_size = hull.size();
    for (int i = points.size() - 2; i >= 0; i--) {
        while (hull.size() > lower_hull_size && cross(hull[hull.size()-2], hull.back(), points[i]) <= 0) {
            hull.pop_back();
        }
        hull.push_back(points[i]);
    }
    
    // Remove duplicates (first and last point are the same)
    if (hull.size() > 1) {
        hull.pop_back();
    }
    
    return hull;
}

// Helper function for cross product
long long cross(const Point& a, const Point& b, const Point& c) {
    return (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x);
}
```

### 3. Line Reflection
**Problem**: Given n points on a 2D plane, find if there is such a line parallel to y-axis that reflect the given points.

**Solution**:
```cpp
bool isReflected(vector<vector<int>>& points) {
    if (points.empty()) return true;
    
    int min_x = INT_MAX;
    int max_x = INT_MIN;
    unordered_set<string> pointSet;
    
    for (auto& point : points) {
        min_x = min(min_x, point[0]);
        max_x = max(max_x, point[0]);
        pointSet.insert(to_string(point[0]) + "," + to_string(point[1]));
    }
    
    int sum = min_x + max_x;
    
    for (auto& point : points) {
        int reflected_x = sum - point[0];
        string reflected_point = to_string(reflected_x) + "," + to_string(point[1]);
        if (pointSet.find(reflected_point) == pointSet.end()) {
            return false;
        }
    }
    return true;
}
```

### 4. Rectangle Area
**Problem**: Find the total area covered by two rectilinear rectangles in a 2D plane.

**Solution**:
```cpp
int computeArea(int ax1, int ay1, int ax2, int ay2, int bx1, int by1, int bx2, int by2) {
    int area1 = (ax2 - ax1) * (ay2 - ay1);
    int area2 = (bx2 - bx1) * (by2 - by1);
    
    int overlap_width = max(0, min(ax2, bx2) - max(ax1, bx1));
    int overlap_height = max(0, min(ay2, by2) - max(ay1, by1));
    int overlap_area = overlap_width * overlap_height;
    
    return area1 + area2 - overlap_area;
}
```

### 5. Rectangle Overlap
**Problem**: Determine if two rectangles overlap.

**Solution**:
```cpp
bool isRectangleOverlap(vector<int>& rec1, vector<int>& rec2) {
    // Check if one rectangle is to the left of the other
    if (rec1[2] <= rec2[0] || rec2[2] <= rec1[0]) return false;
    
    // Check if one rectangle is above the other
    if (rec1[3] <= rec2[1] || rec2[3] <= rec1[1]) return false;
    
    return true;
}
```

### 6. Construct Binary Tree from Preorder and Inorder Traversal
**Problem**: Given two integer arrays preorder and inorder where preorder is the preorder traversal of a binary tree and inorder is the inorder traversal of the same tree, construct the binary tree.

**Solution**:
```cpp
/*
Definition for a binary tree node.
struct TreeNode {
    int val;
    TreeNode *left;
    TreeNode *right;
    TreeNode() : val(0), left(nullptr), right(nullptr) {}
    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
    TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
};
*/

class Solution {
private:
    unordered_map<int, int> indexMap;
    int preIndex;
    
    TreeNode* buildTreeHelper(vector<int>& preorder, vector<int>& inorder, int start, int end) {
        if (start > end) return nullptr;
        
        int rootVal = preorder[preIndex++];
        TreeNode* root = new TreeNode(rootVal);
        
        int inIndex = indexMap[rootVal];
        
        root->left = buildTreeHelper(preorder, inorder, start, inIndex - 1);
        root->right = buildTreeHelper(preorder, inorder, inIndex + 1, end);
        
        return root;
    }
    
public:
    TreeNode* buildTree(vector<int>& preorder, vector<int>& inorder) {
        for (int i = 0; i < inorder.size(); i++) {
            indexMap[inorder[i]] = i;
        }
        preIndex = 0;
        return buildTreeHelper(preorder, inorder, 0, inorder.size() - 1);
    }
};
```

### 7. Construct Binary Tree from Inorder and Postorder Traversal
**Problem**: Given two integer arrays inorder and postorder where inorder is the inorder traversal of a binary tree and postorder is the postorder traversal of the same tree, construct the binary tree.

**Solution**:
```cpp
/*
Definition for a binary tree node.
struct TreeNode {
    int val;
    TreeNode *left;
    TreeNode *right;
    TreeNode() : val(0), left(nullptr), right(nullptr) {}
    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
    TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
};
*/

class Solution {
private:
    unordered_map<int, int> indexMap;
    int postIndex;
    
    TreeNode* buildTreeHelper(vector<int>& inorder, vector<int>& postorder, int start, int end) {
        if (start > end) return nullptr;
        
        int rootVal = postorder[postIndex--];
        TreeNode* root = new TreeNode(rootVal);
        
        int inIndex = indexMap[rootVal];
        
        // Build right subtree first because we're filling from the end of postorder
        root->right = buildTreeHelper(inorder, postorder, inIndex + 1, end);
        root->left = buildTreeHelper(inorder, postorder, start, inIndex - 1);
        
        return root;
    }
    
public:
    TreeNode* buildTree(vector<int>& inorder, vector<int>& postorder) {
        for (int i = 0; i < inorder.size(); i++) {
            indexMap[inorder[i]] = i;
        }
        postIndex = inorder.size() - 1;
        return buildTreeHelper(inorder, postorder, 0, inorder.size() - 1);
    }
};
```

### 8. Binary Tree Maximum Path Sum
**Problem**: A path in a binary tree is a sequence of nodes where each pair of adjacent nodes in the sequence has an edge connecting them. You can only visit each node in the sequence once.

**Solution**:
```cpp
/*
Definition for a binary tree node.
struct TreeNode {
    int val;
    TreeNode *left;
    TreeNode *right;
    TreeNode() : val(0), left(nullptr), right(nullptr) {}
    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
    TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
};
*/

class Solution {
private:
    int maxSum;
    
    int maxPathSumHelper(TreeNode* node) {
        if (!node) return 0;
        
        // Max sum from left and right subtrees (if negative, take 0)
        int leftMax = max(maxPathSumHelper(node->left), 0);
        int rightMax = max(maxPathSumHelper(node->right), 0);
        
        // Price of the node
        int currentPathSum = node->val + leftMax + rightMax;
        maxSum = max(maxSum, currentPathSum);
        
        // Return max sum for a path with at most one child
        return node->val + max(leftMax, rightMax);
    }
    
public:
    int maxPathSum(TreeNode* root) {
        maxSum = INT_MIN;
        maxPathSumHelper(root);
        return maxSum;
    }
};
```

### 9. Serialize and Deserialize Binary Tree
**Problem**: Design an algorithm to serialize and deserialize a binary tree.

**Solution**:
```cpp
/*
Definition for a binary tree node.
struct TreeNode {
    int val;
    TreeNode *left;
    TreeNode *right;
    TreeNode() : val(0), left(nullptr), right(nullptr) {}
    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
    TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
};
*/

class Codec {
public:
    // Encodes a tree to a single string.
    string serialize(TreeNode* root) {
        if (!root) return "X";
        
        string leftSerialized = serialize(root->left);
        string rightSerialized = serialize(root->right);
        
        return to_string(root->val) + "," + leftSerialized + "," + rightSerialized;
    }
    
    // Decodes your encoded data to tree.
    TreeNode* deserialize(string data) {
        queue<string> nodes;
        stringstream ss(data);
        string token;
        
        while (getline(ss, token, ',')) {
            nodes.push(token);
        }
        
        return deserializeHelper(nodes);
    }
    
private:
    TreeNode* deserializeHelper(queue<string>& nodes) {
        string val = nodes.front();
        nodes.pop();
        
        if (val == "X") return nullptr;
        
        TreeNode* node = new TreeNode(stoi(val));
        node->left = deserializeHelper(nodes);
        node->right = deserializeHelper(nodes);
        
        return node;
    }
};

// Your Codec object will be instantiated and called as such:
// Codec* ser = new Codec();
// Codec* deser = new Codec();
// string tree = ser->serialize(root);
// TreeNode* ans = deser->deserialize(tree);
// delete ser;
// delete deser;
```

### 10. Binary Tree Right Side View
**Problem**: Given the root of a binary tree, imagine yourself standing on the right side of it, return the values of the nodes you can see ordered from top to bottom.

**Solution**:
```cpp
/*
Definition for a binary tree node.
struct TreeNode {
    int val;
    TreeNode *left;
    TreeNode *right;
    TreeNode() : val(0), left(nullptr), right(nullptr) {}
    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
    TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
};
*/

class Solution {
public:
    vector<int> rightSideView(TreeNode* root) {
        vector<int> result;
        if (!root) return result;
        
        queue<TreeNode*> q;
        q.push(root);
        
        while (!q.empty()) {
            int levelSize = q.size();
            for (int i = 0; i < levelSize; i++) {
                TreeNode* node = q.front();
                q.pop();
                
                // If it's the last node in this level, add to result
                if (i == levelSize - 1) {
                    result.push_back(node->val);
                }
                
                if (node->left) q.push(node->left);
                if (node->right) q.push(node->right);
            }
        }
        return result;
    }
};
```

---

## Advanced Problems

### 1. Longest Valid Parentheses
**Problem**: Given a string containing just the characters '(' and ')', find the length of the longest valid (well-formed) parentheses substring.

**Solution** (DP):
```cpp
int longestValidParentheses(string s) {
    if (s.size() < 2) return 0;
    
    vector<int> dp(s.size(), 0);
    int max_len = 0;
    
    for (int i = 1; i < s.size(); i++) {
        if (s[i] == ')') {
            if (s[i-1] == '(') {
                // Pattern: ...()
                dp[i] = (i >= 2 ? dp[i-2] : 0) + 2;
            } else if (i - dp[i-1] > 0 && s[i - dp[i-1] - 1] == '(') {
                // Pattern: ...((...)) where ... is a valid parentheses string
                int prev_len = dp[i-1];
                int before_last_open = i - prev_len - 2;
                dp[i] = prev_len + 2 + (before_last_open >= 0 ? dp[before_last_open] : 0);
            }
            max_len = max(max_len, dp[i]);
        }
    }
    return max_len;
}
```

**Solution** (Stack):
```cpp
int longestValidParentheses(string s) {
    stack<int> st;
    st.push(-1); // Base for calculating length
    int max_len = 0;
    
    for (int i = 0; i < s.size(); i++) {
        if (s[i] == '(') {
            st.push(i);
        } else {
            st.pop();
            if (st.empty()) {
                st.push(i); // Reset base
            } else {
                max_len = max(max_len, i - st.top());
            }
        }
    }
    return max_len;
}
```

**Solution** (Two Passes):
```cpp
int longestValidParentheses(string s) {
    int left = 0, right = 0, max_len = 0;
    
    // Left to right pass
    for (int i = 0; i < s.size(); i++) {
        if (s[i] == '(') left++;
        else right++;
        
        if (left == right) {
            max_len = max(max_len, 2 * right);
        } else if (right > left) {
            left = right = 0;
        }
    }
    
    // Right to left pass
    left = right = 0;
    for (int i = s.size() - 1; i >= 0; i--) {
        if (s[i] == '(') left++;
        else right++;
        
        if (left == right) {
            max_len = max(max_len, 2 * left);
        } else if (left > right) {
            left = right = 0;
        }
    }
    return max_len;
}
```

### 2. Largest Rectangle in Histogram
**Problem**: Given an array of integers heights representing the histogram's bar height where the width of each bar is 1, return the area of the largest rectangle in the histogram.

**Solution** (Stack):
```cpp
int largestRectangleArea(vector<int>& heights) {
    stack<int> st;
    int max_area = 0;
    int n = heights.size();
    
    for (int i = 0; i <= n; i++) {
        int h = (i == n) ? 0 : heights[i];
        
        while (!st.empty() && heights[st.top()] > h) {
            int height = heights[st.top()];
            st.pop();
            int width = st.empty() ? i : i - st.top() - 1;
            max_area = max(max_area, height * width);
        }
        st.push(i);
    }
    return max_area;
}
```

### 3. Maximal Rectangle
**Problem**: Given a rows x cols binary matrix filled with 0's and 1's, find the largest rectangle containing only 1's and return its area.

**Solution**:
```cpp
int maximalRectangle(vector<vector<char>>& matrix) {
    if (matrix.empty() || matrix[0].empty()) return 0;
    
    int rows = matrix.size();
    int cols = matrix[0].size();
    vector<int> heights(cols, 0);
    int max_area = 0;
    
    for (int i = 0; i < rows; i++) {
        // Update heights array
        for (int j = 0; j < cols; j++) {
            if (matrix[i][j] == '1') {
                heights[j]++;
            } else {
                heights[j] = 0;
            }
        }
        
        // Calculate largest rectangle in histogram
        stack<int> st;
        for (int j = 0; j <= cols; j++) {
            int h = (j == cols) ? 0 : heights[j];
            
            while (!st.empty() && heights[st.top()] > h) {
                int height = heights[st.top()];
                st.pop();
                int width = st.empty() ? j : j - st.top() - 1;
                max_area = max(max_area, height * width);
            }
            st.push(j);
        }
    }
    return max_area;
}
```

### 4. Word Search II
**Problem**: Given an m x n board of characters and a list of strings words, return all words on the board.

**Solution** (Trie + DFS):
```cpp
/*
 * Your TrieNode object will be instantiated and called as such:
 * TrieNode* node = new TrieNode();
 * node->insert(word);
 * bool found = node->search(word);
 * bool startsWith = node->startsWith(prefix);
 */
struct TrieNode {
    bool isEnd;
    unordered_map<char, TrieNode*> children;
    TrieNode() : isEnd(false) {}
    
    void insert(string word) {
        TrieNode* curr = this;
        for (char c : word) {
            if (curr->children.find(c) == curr->children.end()) {
                curr->children[c] = new TrieNode();
            }
            curr = curr->children[c];
        }
        curr->isEnd = true;
    }
};

class Solution {
private:
    TrieNode* root;
    vector<string> result;
    vector<vector<bool>> visited;
    vector<pair<int, int>> directions = {{0,1}, {0,-1}, {1,0}, {-1,0}};
    
    void dfs(vector<vector<char>>& board, int i, int j, TrieNode* node, string& currentWord) {
        char c = board[i][j];
        if (visited[i][j] || node->children.find(c) == node->children.end()) {
            return;
        }
        
        node = node->children[c];
        currentWord += c;
        visited[i][j] = true;
        
        if (node->isEnd) {
            result.push_back(currentWord);
            node->isEnd = false; // Avoid duplicates
        }
        
        for (auto [dr, dc] : directions) {
            int ni = i + dr;
            int nj = j + dc;
            
            if (ni >= 0 && ni < board.size() && nj >= 0 && nj < board[0].size()) {
                dfs(board, ni, nj, node, currentWord);
            }
        }
        
        visited[i][j] = false;
        currentWord.pop_back();
    }
    
public:
    vector<string> findWords(vector<vector<char>>& board, vector<string>& words) {
        // Build trie
        root = new TrieNode();
        for (string& word : words) {
            root->insert(word);
        }
        
        int m = board.size();
        int n = board[0].size();
        visited.assign(m, vector<bool>(n, false));
        
        // Start DFS from each cell
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                string currentWord = "";
                dfs(board, i, j, root, currentWord);
            }
        }
        
        return result;
    }
};
```

### 5. Substring with Concatenation of All Words
**Problem**: You are given a string s and an array of strings words. All the strings of words are of the same length. Find all starting indices of substring(s) in s that is a concatenation of each word in words exactly once and without any intervening characters.

**Solution**:
```cpp
vector<int> findSubstring(string s, vector<string>& words) {
    vector<int> result;
    if (s.empty() || words.empty()) return result;
    
    int word_len = words[0].size();
    int word_count = words.size();
    int total_len = word_len * word_count;
    
    if (s.size() < total_len) return result;
    
    unordered_map<string, int> wordCount;
    for (string& word : words) {
        wordCount[word]++;
    }
    
    for (int i = 0; i < word_len; i++) {
        int left = i;
        int right = i;
        int count = 0;
        unordered_map<string, int> seen;
        
        while (right + word_len <= s.size()) {
            string word = s.substr(right, word_len);
            right += word_len;
            
            if (wordCount.find(word) != wordCount.end()) {
                seen[word]++;
                count++;
                
                while (seen[word] > wordCount[word]) {
                    string left_word = s.substr(left, word_len);
                    left += word_len;
                    seen[left_word]--;
                    count--;
                }
                
                if (count == word_count) {
                    result.push_back(left);
                }
            } else {
                seen.clear();
                count = 0;
                left = right;
            }
        }
    }
    return result;
}
```

### 6. Minimum Window Substring
**Problem**: Given two strings s and t, return the minimum window in s which will contain all the characters in t.

**Solution**:
```cpp
string minWindow(string s, string t) {
    if (s.empty() || t.empty()) return "";
    
    unordered_map<char, int> tCount;
    for (char c : t) {
        tCount[c]++;
    }
    
    int required = tCount.size();
    int formed = 0;
    unordered_map<char, int> windowCount;
    
    int left = 0, right = 0;
    int min_len = INT_MAX;
    int min_left = 0;
    
    while (right < s.size()) {
        char c = s[right];
        windowCount[c]++;
        
        if (tCount.find(c) != tCount.end() && windowCount[c] == tCount[c]) {
            formed++;
        }
        
        while (left <= right && formed == required) {
            c = s[left];
            
            if (right - left + 1 < min_len) {
                min_len = right - left + 1;
                min_left = left;
            }
            
            windowCount[c]--;
            if (tCount.find(c) != tCount.end() && windowCount[c] < tCount[c]) {
                formed--;
            }
            left++;
        }
        
        right++;
    }
    
    return min_len == INT_MAX ? "" : s.substr(min_left, min_len);
}
```

### 7. Edit Distance
**Problem**: Given two strings word1 and word2, return the minimum number of operations required to convert word1 to word2.

**Solution** (DP with Space Optimization):
```cpp
int minDistance(string word1, string word2) {
    int m = word1.size();
    int n = word2.size();
    
    // Make sure word2 is the shorter one for space optimization
    if (m < n) return minDistance(word2, word1);
    
    vector<int> dp(n + 1);
    for (int j = 0; j <= n; j++) {
        dp[j] = j;
    }
    
    for (int i = 1; i <= m; i++) {
        int prev_diagonal = dp[0];
        dp[0] = i;
        
        for (int j = 1; j <= n; j++) {
            int temp = dp[j];
            
            if (word1[i-1] == word2[j-1]) {
                dp[j] = prev_diagonal;
            } else {
                dp[j] = 1 + min({prev_diagonal, dp[j-1], dp[j]});
            }
            
            prev_diagonal = temp;
        }
    }
    return dp[n];
}
```

### 8. Regular Expression Matching
**Problem**: Given an input string s and a pattern p, implement regular expression matching with support for '.' and '*'.

**Solution** (DP):
```cpp
bool isMatch(string s, string p) {
    int m = s.size();
    int n = p.size();
    vector<vector<bool>> dp(m + 1, vector<bool>(n + 1, false));
    
    // Empty pattern matches empty string
    dp[0][0] = true;
    
    // Handle patterns like a*, a*b*, a*b*c* etc. that can match empty string
    for (int j = 1; j <= n; j++) {
        if (p[j-1] == '*') {
            dp[0][j] = dp[0][j-2];
        }
    }
    
    for (int i = 1; i <= m; i++) {
        for (int j = 1; j <= n; j++) {
            if (p[j-1] == '.' || p[j-1] == s[i-1]) {
                dp[i][j] = dp[i-1][j-1];
            } else if (p[j-1] == '*') {
                dp[i][j] = dp[i][j-2]; // Zero occurrences of preceding element
                if (p[j-2] == '.' || p[j-2] == s[i-1]) {
                    dp[i][j] = dp[i][j] || dp[i-1][j]; // One or more occurrences
                }
            }
        }
    }
    return dp[m][n];
}
```

### 9. Wildcard Matching
**Problem**: Given an input string s and a pattern p, implement wildcard pattern matching with support for '?' and '*'.

**Solution** (Greedy):
```cpp
bool isMatch(string s, string p) {
    int s_idx = 0, p_idx = 0;
    int star_idx = -1;
    int match_idx = 0;
    
    while (s_idx < s.size()) {
        // Match single character or '?'
        if (p_idx < p.size() && (p[p_idx] == s[s_idx] || p[p_idx] == '?')) {
            s_idx++;
            p_idx++;
        }
        // Encounter '*'
        else if (p_idx < p.size() && p[p_idx] == '*') {
            star_idx = p_idx;
            match_idx = s_idx;
            p_idx++;
        }
        // Last pattern was *, move back in string
        else if (star_idx != -1) {
            p_idx = star_idx + 1;
            match_idx++;
            s_idx = match_idx;
        }
        // No match
        else {
            return false;
        }
    }
    
    // Check remaining characters in pattern
    while (p_idx < p.size() && p[p_idx] == '*') {
        p_idx++;
    }
    
    return p_idx == p.size();
}
```

### 10. Text Justification
**Problem**: Given an array of words and a width maxWidth, format the text such that each line has exactly maxWidth characters and is fully (left and right) justified.

**Solution**:
```cpp
vector<string> fullJustify(vector<string>& words, int maxWidth) {
    vector<string> result;
    int i = 0;
    int n = words.size();
    
    while (i < n) {
        int len = words[i].size();
        int j = i + 1;
        
        // Find how many words can fit in current line
        while (j < n && len + 1 + words[j].size() <= maxWidth) {
            len += 1 + words[j].size();
            j++;
        }
        
        int wordCount = j - i;
        int spaces = maxWidth - (len - (wordCount - 1)); // Subtract extra spaces we added
        
        string line;
        
        // Last line or single word line: left justified
        if (j == n || wordCount == 1) {
            for (int k = i; k < j; k++) {
                line += words[k];
                if (k < j - 1) line += " ";
            }
            line.append(spaces, ' ');
        } 
        // Middle line: distribute spaces evenly
        else {
            int spaceBetweenWords = spaces / (wordCount - 1);
            int extraSpaces = spaces % (wordCount - 1);
            
            for (int k = i; k < j; k++) {
                line += words[k];
                if (k < j - 1) {
                    line.append(spaceBetweenWords, ' ');
                    if (extraSpaces > 0) {
                        line += ' ';
                        extraSpaces--;
                    }
                }
            }
        }
        
        result.push_back(line);
        i = j;
    }
    return result;
}
```

---

## References and Further Reading

### Key Concepts to Master
1. **Time and Space Complexity Analysis**
2. **Common Data Structures and their Trade-offs**
3. **Dynamic Programming Patterns**
4. **Graph Algorithms (DFS, BFS, Dijkstra, Floyd-Warshall)**
5. **String Matching algorithms (KMP, Rabin-Karp, Z-algorithm)**
6. **Greedy Algorithm principles**
7. **Divide and Conquer techniques**
8. **Bit Manipulation tricks**

### Useful Resources
- **Books**: "Competitive Programming 4" by Steven Halim & Felix Halim
- **Websites**: Codeforces, LeetCode, AtCoder, HackerRank
- **Practice**: Focus on understanding patterns rather than memorizing solutions
- **Community**: Participate in virtual contests and discuss solutions

### Tips for Success
1. **Start with brute force** to understand the problem
2. **Look for patterns** in problems and solutions
3. **Practice regularly** with timed contests
4. **Learn from mistakes** by reviewing incorrect solutions
5. **Master one concept at a time** before moving to the next
6. **Use templates** to save time during contests
7. **Stay calm** and think before coding

---

## Conclusion

This document provides a comprehensive collection of competitive programming problems with detailed solutions. By studying these problems and their solutions, you will develop a strong foundation in algorithmic thinking and problem-solving skills essential for competitive programming success.

Remember that the key to mastering competitive programming is not just memorizing solutions, but understanding the underlying patterns and techniques that can be applied to solve new problems. Practice regularly, participate in contests, and always strive to improve your approach and optimization skills.

Good luck in your coding journey! 🚀