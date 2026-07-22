# ⚡ Quick Reference Cheat Sheet

> Essential formulas, patterns, and templates for quick review before interviews or competitions.

## 📊 Big O Notation Cheat Sheet

| Complexity | Name | Example |
|------------|------|---------|
| O(1) | Constant | Array access, hash table lookup |
| O(log n) | Logarithmic | Binary search, heap operations |
| O(n) | Linear | Linear search, array traversal |
| O(n log k) | Linearithmic | Heap sort, sorting k lists |
| O(n log n) | Linearithmic | Merge sort, quicksort, heap sort |
| O(n²) | Quadratic | Bubble sort, insertion sort, nested loops |
| O(n³) | Cubic | Triple nested loops, matrix multiplication |
| O(2^n) | Exponential | Brute force subsets, naive Fibonacci |
| O(n!) | Factorial | Permutations, traveling salesman brute force |

## 🔢 Common Summations & Formulas

### Arithmetic Series
- Sum of 1 to n: n(n+1)/2
- Sum of arithmetic sequence: n/2 × (first + last)

### Geometric Series
- Sum of 2⁰ + 2¹ + ... + 2ⁿ = 2ⁿ⁺¹ - 1
- Sum of a⁰ + a¹ + ... + aⁿ = (aⁿ⁺¹ - 1)/(a - 1) for a ≠ 1

### Other Useful Formulas
- Number of subsets of set with n elements: 2ⁿ
- Number of permutations of n distinct elements: n!
- Number of combinations: C(n,k) = n!/(k!(n-k)!)
- Harmonic series Hₙ = 1 + 1/2 + 1/3 + ... + 1/n ≈ ln(n) + γ
- Sum of squares: 1² + 2² + ... + n² = n(n+1)(2n+1)/6
- Sum of cubes: 1³ + 2³ + ... + n³ = [n(n+1)/2]²

## 🌳 Tree Traversal Patterns

### Depth-First Search (DFS)
```python
# Recursive Preorder (Root-Left-Right)
def preorder(node):
    if not node: return []
    return [node.val] + preorder(node.left) + preorder(node.right)

# Recursive Inorder (Left-Root-Right)
def inorder(node):
    if not node: return []
    return inorder(node.left) + [node.val] + inorder(node.right)

# Recursive Postorder (Left-Right-Root)
def postorder(node):
    if not node: return []
    return postorder(node.left) + postorder(node.right) + [node.val]

# Iterative Inorder using Stack
def inorder_iterative(root):
    stack, result = [], []
    curr = root
    while curr or stack:
        while curr:
            stack.append(curr)
            curr = curr.left
        curr = stack.pop()
        result.append(curr.val)
        curr = curr.right
    return result
```

### Breadth-First Search (BFS) / Level Order
```python
from collections import deque

def level_order(root):
    if not root: return []
    
    queue = deque([root])
    result = []
    
    while queue:
        level_size = len(queue)
        current_level = []
        
        for _ in range(level_size):
            node = queue.popleft()
            current_level.append(node.val)
            if node.left:
                queue.append(node.left)
            if node.right:
                queue.append(node.right)
                
        result.append(current_level)
    
    return result
```

## 🔍 Search Patterns

### Binary Search Template
```python
def binary_search(arr, target):
    left, right = 0, len(arr) - 1
    while left <= right:
        mid = left + (right - left) // 2
        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    return -1  # not found

# Find first occurrence
def first_occurrence(arr, target):
    left, right = 0, len(arr) - 1
    result = -1
    while left <= right:
        mid = left + (right - left) // 2
        if arr[mid] == target:
            result = mid
            right = mid - 1  # continue searching left
        elif arr[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    return result

# Find last occurrence
def last_occurrence(arr, target):
    left, right = 0, len(arr) - 1
    result = -1
    while left <= right:
        mid = left + (right - left) // 2
        if arr[mid] == target:
            result = mid
            left = mid + 1  # continue searching right
        elif arr[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    return result
```

### Two Pointer Patterns
```python
# Opposite ends (sorted array)
def two_sum_sorted(numbers, target):
    left, right = 0, len(numbers) - 1
    while left < right:
        current_sum = numbers[left] + numbers[right]
        if current_sum == target:
            return [left+1, right+1]  # 1-indexed
        elif current_sum < target:
            left += 1
        else:
            right -= 1
    return []

# Same direction (fast/slow pointers)
def has_cycle(head):
    slow = fast = head
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next
        if slow == fast:
            return True
    return False

# Sliding window
def max_subarray_size_k(k, arr):
    max_sum, window_sum = 0, 0
    window_start = 0
    
    for window_end in range(len(arr)):
        window_sum += arr[window_end]  # add the next element
        
        # slide the window, we don't need to slide if we've not hit the required window size of 'k'
        if window_end >= k - 1:
            max_sum = max(max_sum, window_sum)
            window_sum -= arr[window_start]  # subtract the element going out
            window_start += 1  # slide the window ahead
            
    return max_sum
```

## 🔄 Dynamic Programming Patterns

### 1D DP Template
```python
def dp_1d(nums):
    if not nums:
        return 0
    
    n = len(nums)
    dp = [0] * n
    dp[0] = base_case
    
    for i in range(1, n):
        # State transition: dp[i] = f(dp[i-1], dp[i-2], ...)
        dp[i] = transition_function(dp[i-1], nums[i], ...) 
    
    return dp[n-1]  # or max(dp) depending on problem
```

### 2D DP Template
```python
def dp_2d(grid):
    if not grid or not grid[0]:
        return 0
    
    rows, cols = len(grid), len(grid[0])
    dp = [[0] * cols for _ in range(rows)]
    
    # Initialize base cases
    for i in range(rows):
        for j in range(cols):
            if i == 0 and j == 0:
                dp[i][j] = base_case
            elif i == 0:  # first row
                dp[i][j] = dp[i][j-1] + cost(i, j)
            elif j == 0:  # first column
                dp[i][j] = dp[i-1][j] + cost(i, j)
            else:
                # State transition: usually min/max of top, left, or diagonal
                dp[i][j] = min(dp[i-1][j], dp[i][j-1]) + cost(i, j)
    
    return dp[rows-1][cols-1]
```

### Common DP Problems
- **Fibonacci**: dp[i] = dp[i-1] + dp[i-2]
- **Coin Change**: dp[i] = min(dp[i-coin] + 1) for coin in coins
- **Longest Increasing Subsequence**: dp[i] = max(dp[j] + 1) for j < i and nums[j] < nums[i]
- **Edit Distance**: dp[i][j] = min(dp[i-1][j], dp[i][j-1], dp[i-1][j-1]) + cost
- **Knapsack**: dp[i][w] = max(dp[i-1][w], dp[i-1][w-weight[i]] + value[i])

## 🧠 Greedy Patterns

### Activity Selection
```python
def max_activities(start_times, finish_times):
    # Sort by finish time
    activities = sorted(zip(start_times, finish_times), key=lambda x: x[1])
    
    count = 1
    last_finish = activities[0][1]
    
    for start, finish in activities[1:]:
        if start >= last_finish:
            count += 1
            last_finish = finish
    
    return count
```

### Huffman Coding (Conceptual)
1. Create leaf node for each character and build min heap of all nodes
2. Extract two nodes with minimum frequency
3. Create new internal node with frequency = sum of two nodes' frequencies
4. Insert new node into min heap
5. Repeat steps 2-4 until heap contains only one node (the root)

## 🔗 Graph Algorithms

### BFS for Shortest Path (Unweighted)
```python
from collections import deque

def shortest_path_unweighted(graph, start, target):
    if start == target:
        return [start]
    
    queue = deque([(start, [start])])
    visited = set([start])
    
    while queue:
        node, path = queue.popleft()
        
        for neighbor in graph[node]:
            if neighbor == target:
                return path + [neighbor]
            if neighbor not in visited:
                visited.add(neighbor)
                queue.append((neighbor, path + [neighbor]))
    
    return []  # no path found
```

### Dijkstra's Algorithm (Weighted Graph - Non-negative weights)
```python
import heapq

def dijkstra(graph, start):
    # Initialize distances
    distances = {node: float('inf') for node in graph}
    distances[start] = 0
    
    # Priority queue: (distance, node)
    pq = [(0, start)]
    visited = set()
    
    while pq:
        current_dist, current_node = heapq.heappop(pq)
        
        if current_node in visited:
            continue
            
        visited.add(current_node)
        
        for neighbor, weight in graph[current_node].items():
            distance = current_dist + weight
            
            if distance < distances[neighbor]:
                distances[neighbor] = distance
                heapq.heappush(pq, (distance, neighbor))
    
    return distances
```

### Union-Find (Disjoint Set Union)
```python
class UnionFind:
    def __init__(self, n):
        self.parent = list(range(n))
        self.rank = [0] * n
    
    def find(self, x):
        if self.parent[x] != x:
            self.parent[x] = self.find(self.parent[x])  # Path compression
        return self.parent[x]
    
    def union(self, x, y):
        px, py = self.find(x), self.find(y)
        if px == py:
            return False  # Already in same set
        
        # Union by rank
        if self.px < self.py:
            self.parent[px] = py
        elif self.px > self.py:
            self.parent[py] = px
        else:
            self.parent[py] = px
            self.rank[px] += 1
        return True
```

## 📝 String Algorithms

### KMP Algorithm (Knuth-Morris-Pratt)
```python
def compute_lps(pattern):
    """Compute Longest Proper Prefix which is also Suffix"""
    m = len(pattern)
    lps = [0] * m
    length = 0  # length of previous longest prefix suffix
    
    i = 1
    while i < m:
        if pattern[i] == pattern[length]:
            length += 1
            lps[i] = length
            i += 1
        else:
            if length != 0:
                length = lps[length-1]
            else:
                lps[i] = 0
                i += 1
    return lps

def kmp_search(text, pattern):
    if not pattern:
        return 0
    
    lps = compute_lps(pattern)
    i = j = 0  # index for text and pattern
    
    while i < len(text):
        if pattern[j] == text[i]:
            i += 1
            j += 1
        
        if j == len(pattern):
            return i - j  # match found
            j = lps[j-1]  # for finding next match
        elif i < len(text) and pattern[j] != text[i]:
            if j != 0:
                j = lps[j-1]
            else:
                i += 1
    
    return -1  # no match
```

### Rabin-Karp (Rolling Hash)
```python
def rabin_karp(text, pattern):
    if not pattern or len(pattern) > len(text):
        return -1
    
    d = 256  # number of characters in input alphabet
    q = 101  # a prime number
    
    m = len(pattern)
    n = len(text)
    p = 0  # hash value for pattern
    t = 0  # hash value for text
    h = 1
    
    # The value of h would be "pow(d, m-1)%q"
    for i in range(m-1):
        h = (h * d) % q
    
    # Calculate hash value of pattern and first window of text
    for i in range(m):
        p = (d * p + ord(pattern[i])) % q
        t = (d * t + ord(text[i])) % q
    
    # Slide the pattern over text one by one
    for i in range(n - m + 1):
        # Check the hash values of current window of text and pattern
        if p == t:
            # Check for characters one by one
            if text[i:i+m] == pattern:
                return i
        
        # Calculate hash value for next window of text
        if i < n - m:
            t = (d * (t - ord(text[i]) * h) + ord(text[i+m])) % q
            # We might get negative value of t, converting it to positive
            if t < 0:
                t = t + q
    
    return -1
```

## 💡 Bit Manipulation Tricks

### Essential Bit Operations
```python
# Check if i-th bit is set: (num >> i) & 1
# Set i-th bit: num | (1 << i)
# Clear i-th bit: num & ~(1 << i)
# Toggle i-th bit: num ^ (1 << i)
# Rightmost set bit: num & (-num)
# Remove rightmost set bit: num & (num - 1)
# Get rightmost 0 bit: ~num & (num + 1)

# Count set bits (Brian Kernighan's algorithm)
def count_set_bits(n):
    count = 0
    while n:
        n &= (n - 1)
        count += 1
    return count

# Check if power of two
def is_power_of_two(n):
    return n > 0 and (n & (n - 1)) == 0

# Find single number where all others appear twice
def single_number(nums):
    result = 0
    for num in nums:
        result ^= num
    return result
```

## 🎯 Common Problem Patterns

### 1. Array Partition Problems
- **Pattern**: Sort + greedy or two pointers
- **Examples**: 
  - Array Partition I (LeetCode 561): Sort and sum every second element
  - Assign Cookies (LeetCode 455): Sort both arrays, use two pointers

### 2. Subarray / Substring Problems
- **Pattern**: Sliding window or prefix sum + hash map
- **Examples**:
  - Maximum Subarray (Kadane's algorithm)
  - Longest Substring Without Repeating Characters
  - Subarray Sum Equals K (prefix sum + hash map)

### 3. Tree Depth / Path Problems
- **Pattern**: DFS recursion returning height/path info
- **Examples**:
  - Maximum Depth of Binary Tree
  - Diameter of Binary Tree (height of left + height of right)
  - Binary Tree Maximum Path Sum

### 4. Graph Cycle Detection
- **Undirected Graph**: DFS with parent tracking or Union-Find
- **Directed Graph**: DFS with visited/recursion stack or topological sort
- **Example**: Course Schedule (LeetCode 207) - detect cycle in directed graph

### 5. Top K Elements
- **Pattern**: Min-heap of size K or QuickSelect
- **Examples**:
  - Top K Frequent Elements (heap or bucket sort)
  - Kth Largest Element in Array (min-heap or QuickSelect)
  - Find K Pairs with Smallest Sums (min-heap)

### 6. Interval Problems
- **Pattern**: Sort by start/end, then sweep line
- **Examples**:
  - Merge Intervals (sort by start, then merge overlapping)
  - Non-overlapping Intervals (sort by end, greedy)
  - Meeting Rooms II (chronological ordering)

### 7. String Matching / Pattern Finding
- **Pattern**: Sliding window, KMP, Rabin-Karp, or Z-algorithm
- **Examples**:
  - Find All Anagrams in a String (sliding window + frequency count)
  - Implement strStr() (KMP or built-in)
  - Repeated DNA Sequences (sliding window + hash set)

### 8. Matrix Traversal
- **Pattern**: BFS/DFS with direction arrays or spiral boundaries
- **Examples**:
  - Number of Islands (BFS/DFS on grid)
  - Rotate Image (layer by layer or transpose + reverse)
  - Spiral Matrix (boundary tracking)
  - Word Search (DFS with backtracking)

### 9. Backtracking / Combination Generation
- **Pattern**: Recursive exploration with pruning
- **Examples**:
  - Subsets, Permutations, Combinations
  - Combination Sum (with/without repetition)
  - N-Queens
  - Sudoku Solver

### 10. Monotonic Stack
- **Pattern**: Stack maintaining monotonically increasing/decreasing sequence
- **Examples**:
  - Daily Temperatures (next greater element)
  - Largest Rectangle in Histogram
  - Trapping Rain Water
  - Remove Duplicate Letters

## 📚 Language-Specific Tips

### Python
- Use `collections` module: `Counter`, `defaultdict`, `deque`, `OrderedDict`
- List comprehensions: `[x*2 for x in arr if x > 0]`
- Slicing: `arr[start:end:step]`, `arr[::-1]` for reverse
- `zip(*matrix)` for transpose
- `heapq` for min-heap (negate values for max-heap)
- `bisect` module for binary search on sorted lists

### Java
- `Arrays.sort()` for primitives (dual-pivot quicksort), `Collections.sort()` for objects
- `ArrayList` vs `LinkedList` trade-offs
- `HashMap`, `TreeMap`, `LinkedHashMap`
- `PriorityQueue` (min-heap by default)
- `StringBuilder` for string concatenation
- `BitSet` for efficient bit manipulation

### C++
- STL: `vector`, `list`, `map`, `set`, `unordered_map`, `unordered_set`, `priority_queue`
- Sorting: `sort(v.begin(), v.end())`, `stable_sort`
- Binary search: `binary_search`, `lower_bound`, `upper_bound`
- Make sure to handle integer overflow: use `long long` when needed
- `emplace_back` vs `push_back` for efficiency

### JavaScript
- Array methods: `map`, `filter`, `reduce`, `forEach`
- Object destructuring: `{a, b} = obj`
- Spread operator: `[...arr]`, `{...obj}`
- `Set` and `Map` for unique values and key-value pairs
- Be careful with `==` vs `===` (type coercion)
- Use `Number.isInteger()` for integer checks

## 🚨 Common Pitfalls to Avoid

### Off-by-One Errors
- Array indexing: 0 to n-1 inclusive
- Loop conditions: `i < n` vs `i <= n-1`
- Boundary conditions in binary search

### Integer Overflow
- Especially in languages with fixed integer sizes (C++, Java)
- Use long/BigInteger when sums/products might exceed int range
- In Python, less of an issue but still good practice

### Floating Point Precision
- Avoid equality checks with floats: use `abs(a-b) < epsilon`
- For monetary values, use integers (cents) or decimal libraries

### Memory Issues
- Space complexity: don't forget auxiliary space (recursion stack, hash maps)
- Clear data structures when reusing them
- Be careful with recursion depth (consider iterative solutions)

### Edge Cases
- Empty input: `[]`, `""`, `null`
- Single element: `[5]`, `"a"`
- All same elements: `[2,2,2,2]`
- Already sorted input
- Reverse sorted input
- Large inputs (test performance)

### Language-Specific Gotchas
- **Python**: Default mutable arguments, list reference copying
- **Java**: Integer cache (-128 to 127), string interning
- **C++**: Iterator invalidation, memory leaks (raw pointers)
- **JavaScript**: Floating point precision, `0.1 + 0.2 !== 0.3`

## 📈 Last-Minute Review Plan (1 Hour Before Interview)

### 0-10 Minutes: Mental Preparation
- Deep breathing exercises
- Positive visualization: See yourself succeeding
- Remind yourself: "I've prepared for this"

### 10-20 Minutes: Concept Flashcards
- Review data structure cheat sheet (when to use each)
- Review algorithm patterns (sliding window, two pointers, etc.)
- Recall time/space complexities of common operations

### 20-40 Minutes: Problem Practice
- Solve 1 medium problem from scratch (no looking at solutions)
- Focus on clear communication of approach
- Time yourself: aim for 20 minutes start to finish

### 40-50 Minutes: Review Your Solution
- Check for edge cases
- Verify time and space complexity
- Think about potential optimizations

### 50-60 Minutes: Final Preparation
- Review your "tell me about yourself" story
- Prepare 2-3 questions to ask the interviewer
- Do a quick posture/breathing check
- Smile and remind yourself: You've got this!

Remember: Interviewers are not just looking for the correct answer—they're evaluating your problem-solving process, communication skills, and ability to think under pressure. Trust your preparation, stay calm, and show them how you think.

> "It's not that I'm so smart, it's just that I stay with problems longer." - Albert Einstein