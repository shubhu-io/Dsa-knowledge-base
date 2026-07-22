# Searching Algorithms Cheat Sheet

## Fundamental Concepts

### Definition
Searching is the process of finding a specific element (key/target) within a collection of data.

### Key Concepts
- **Search Space**: The set of elements where the target might be located
- **Comparison Function**: Defines the ordering relationship between elements
- **Success Condition**: When the target element is found
- **Termination Condition**: When the search space is exhausted

### Classification by Approach
1. **Sequential Search**: Check elements one by one (Linear Search)
2. **Interval Search**: Divide search space into intervals (Binary Search, Interpolation Search)
3. **Hash-based**: Use hash function to map keys to positions (Hash Tables)
4. **Tree-based**: Use tree structure for efficient search (BST, Trie)
5. **Graph-based**: Traverse graph to find target (BFS, DFS)

## Essential Searching Algorithms

### 1. Linear Search
```cpp
int linearSearch(const vector<int>& arr, int target) {
    for (int i = 0; i < arr.size(); i++) {
        if (arr[i] == target) return i;
    }
    return -1;
}
```
- Time: O(n) worst/average, O(1) best
- Space: O(1)
- Works on: Unsorted/sorted data
- Use when: Small dataset, infrequent searches, unsorted data

### 2. Binary Search
```cpp
int binarySearch(const vector<int>& arr, int target) {
    int left = 0, right = arr.size() - 1;
    while (left <= right) {
        int mid = left + (right - left) / 2;
        if (arr[mid] == target) return mid;
        if (arr[mid] < target) left = mid + 1;
        else right = mid - 1;
    }
    return -1;
}
```
- Time: O(log n) worst/average, O(1) best
- Space: O(1) iterative, O(log n) recursive
- Works on: Sorted data only
- Variants: Lower bound, upper bound, exponential search

### 3. Hash Table Search
```cpp
// Simple hash table with separate chaining
int hashSearch(const vector<list<pair<int,int>>>& table, int key) {
    int index = hash(key);
    for (auto& kv : table[index]) {
        if (kv.first == key) return kv.second;
    }
    return -1; // Not found
}
```
- Time: O(1) average, O(n) worst-case (all collisions)
- Space: O(n)
- Works on: Key-value pairs
- Collision resolution: Separate chaining, linear probing, quadratic probing, double hashing

### 4. Binary Search Tree (BST) Search
```cpp
TreeNode* bstSearch(TreeNode* root, int target) {
    if (!root || root->val == target) return root;
    if (target < root->val) return bstSearch(root->left, target);
    else return bstSearch(root->right, target);
}
```
- Time: O(h) where h is tree height
- Space: O(h) recursive, O(1) iterative
- Works on: Binary Search Trees
- Self-balancing variants: AVL, Red-Black (guarantee O(log n))

### 5. Trie (Prefix Tree) Search
```cpp
bool trieSearch(TrieNode* root, const string& word) {
    TrieNode* current = root;
    for (char c : word) {
        int index = c - 'a';
        if (!current->children[index]) return false;
        current = current->children[index];
    }
    return current->isEndOfWord;
}
```
- Time: O(L) where L is length of key
- Space: O(N*L*M) where N=words, L=avg length, M=alphabet size
- Works on: String keys
- Specialty: Prefix searches, autocomplete

### 6. Breadth-First Search (BFS)
```cpp
vector<int> bfs(const vector<vector<int>>& graph, int start) {
    int n = graph.size();
    vector<bool> visited(n, false);
    vector<int> result;
    queue<int> q;
    
    visited[start] = true;
    q.push(start);
    
    while (!q.empty()) {
        int node = q.front(); q.pop();
        result.push_back(node);
        
        for (int neighbor : graph[node]) {
            if (!visited[neighbor]) {
                visited[neighbor] = true;
                q.push(neighbor);
            }
        }
    }
    return result;
}
```
- Time: O(V + E)
- Space: O(V)
- Works on: Graphs
- Specialty: Shortest path in unweighted graphs, level-order traversal

### 7. Depth-First Search (DFS)
```cpp
void dfsHelper(const vector<vector<int>>& graph, int node, 
              vector<bool>& visited, vector<int>& result) {
    visited[node] = true;
    result.push_back(node);
    
    for (int neighbor : graph[node]) {
        if (!visited[neighbor]) {
            dfsHelper(graph, neighbor, visited, result);
        }
    }
}

vector<int> dfs(const vector<vector<int>>& graph, int start) {
    int n = graph.size();
    vector<bool> visited(n, false);
    vector<int> result;
    dfsHelper(graph, start, visited, result);
    return result;
}
```
- Time: O(V + E)
- Space: O(V)
- Works on: Graphs
- Specialty: Deep exploration, memory efficient for deep graphs

## Advanced Searching Algorithms

### 1. Interpolation Search
```cpp
int interpolationSearch(const vector<int>& arr, int target) {
    int left = 0, right = arr.size() - 1;
    while (left <= right && target >= arr[left] && target <= arr[right]) {
        if (left == right) {
            if (arr[left] == target) return left;
            return -1;
        }
        
        int pos = left + (((double)(right - left) / 
                          (arr[right] - arr[left])) * 
                         (target - arr[left]));
        
        if (arr[pos] == target) return pos;
        if (arr[pos] < target) left = pos + 1;
        else right = pos - 1;
    }
    return -1;
}
```
- Time: O(log log n) avg (uniform dist), O(n) worst
- Space: O(1)
- Works on: Sorted, uniformly distributed data

### 2. Exponential Search
```cpp
int exponentialSearch(const vector<int>& arr, int target) {
    if (arr.empty()) return -1;
    if (arr[0] == target) return 0;
    
    int bound = 1;
    while (bound < arr.size() && arr[bound] <= target) {
        bound *= 2;
    }
    
    return binarySearch(arr, target, bound/2, min(bound, (int)arr.size()-1));
}
```
- Time: O(log n)
- Space: O(1)
- Works on: Sorted arrays (especially unbounded)

### 3. Jump Search
```cpp
int jumpSearch(const vector<int>& arr, int target) {
    int n = arr.size();
    if (n == 0) return -1;
    
    int step = sqrt(n);
    int prev = 0;
    
    while (arr[min(step, n)-1] < target) {
        prev = step;
        step += sqrt(n);
        if (prev >= n) return -1;
    }
    
    while (arr[prev] < target) {
        prev++;
        if (prev == min(step, n)) return -1;
    }
    
    if (arr[prev] == target) return prev;
    return -1;
}
```
- Time: O(√n)
- Space: O(1)
- Works on: Sorted arrays

### 4. Fibonacci Search
```cpp
int fibonacciSearch(const vector<int>& arr, int target) {
    int n = arr.size();
    if (n == 0) return -1;
    
    int fibMMm2 = 0; // (m-2)th Fibonacci
    int fibMMm1 = 1; // (m-1)th Fibonacci
    int fibM = fibMMm2 + fibMMm1; // mth Fibonacci
    
    while (fibM < n) {
        fibMMm2 = fibMMm1;
        fibMMm1 = fibM;
        fibM = fibMMm2 + fibMMm1;
    }
    
    int offset = -1;
    
    while (fibM > 1) {
        int i = min(offset + fibMMm2, n-1);
        
        if (arr[i] < target) {
            fibM = fibMMm1;
            fibMMm1 = fibMMm2;
            fibMMm2 = fibM - fibMMm1;
            offset = i;
        } else if (arr[i] > target) {
            fibM = fibMMm2;
            fibMMm1 = fibMMm1 - fibMMm2;
            fibMMm2 = fibM - fibMMm1;
        } else {
            return i;
        }
    }
    
    if (fibMMm1 && arr[offset+1] == target) return offset+1;
    return -1;
}
```
- Time: O(log n)
- Space: O(1)
- Works on: Sorted arrays

## String Matching Algorithms

### 1. Naive String Matching
```cpp
vector<int> naiveSearch(string text, string pattern) {
    vector<int> matches;
    int n = text.length(), m = pattern.length();
    
    for (int i = 0; i <= n - m; i++) {
        int j;
        for (j = 0; j < m; j++) {
            if (text[i + j] != pattern[j]) break;
        }
        if (j == m) matches.push_back(i);
    }
    return matches;
}
```
- Time: O((n-m+1)*m) worst-case
- Space: O(1)
- Simple but inefficient for large texts

### 2. Rabin-Karp Algorithm
```cpp
vector<int> rabinKarp(string text, string pattern) {
    vector<int> matches;
    int n = text.length(), m = pattern.length();
    
    if (n < m) return matches;
    
    const int d = 256; // Alphabet size
    const int q = 101; // Prime number
    
    long long patternHash = 0;
    long long textHash = 0;
    long long h = 1;
    
    // Calculate h = pow(d, m-1) % q
    for (int i = 0; i < m-1; i++)
        h = (h * d) % q;
    
    // Calculate hash values
    for (int i = 0; i < m; i++) {
        patternHash = (d * patternHash + pattern[i]) % q;
        textHash = (d * textHash + text[i]) % q;
    }
    
    // Slide pattern over text
    for (int i = 0; i <= n - m; i++) {
        if (patternHash == textHash) {
            // Check characters one by one
            int j;
            for (j = 0; j < m; j++) {
                if (text[i + j] != pattern[j]) break;
            }
            if (j == m) matches.push_back(i);
        }
        
        // Calculate hash for next window
        if (i < n - m) {
            textHash = (d * (textHash - text[i] * h) + text[i + m]) % q;
            if (textHash < 0) textHash += q;
        }
    }
    
    return matches;
}
```
- Time: O(n+m) average, O(n*m) worst-case (spurious hits)
- Space: O(1)
- Good for multiple pattern search

### 3. Knuth-Morris-Pratt (KMP) Algorithm
```cpp
vector<int> computeLPS(string pattern) {
    int m = pattern.length();
    vector<int> lps(m, 0);
    
    int len = 0;
    int i = 1;
    while (i < m) {
        if (pattern[i] == pattern[len]) {
            len++;
            lps[i] = len;
            i++;
        } else {
            if (len != 0) {
                len = lps[len-1];
            } else {
                lps[i] = 0;
                i++;
            }
        }
    }
    return lps;
}

vector<int> kmpSearch(string text, string pattern) {
    vector<int> matches;
    int n = text.length(), m = pattern.length();
    
    if (m == 0) return matches;
    
    vector<int> lps = computeLPS(pattern);
    
    int i = 0, j = 0;
    while (i < n) {
        if (pattern[j] == text[i]) {
            i++;
            j++;
        }
        
        if (j == m) {
            matches.push_back(i - j);
            j = lps[j-1];
        } else if (i < n && pattern[j] != text[i]) {
            if (j != 0) {
                j = lps[j-1];
            } else {
                i++;
            }
        }
    }
    
    return matches;
}
```
- Time: O(n+m)
- Space: O(m)
- Efficient, avoids backtracking in text

## Graph Search Applications

### 1. Shortest Path in Unweighted Graph (BFS)
```cpp
vector<int> bfsShortestPath(vector<vector<int>>& graph, int source, int destination) {
    int n = graph.size();
    vector<int> distance(n, -1);
    vector<int> parent(n, -1);
    queue<int> q;
    
    distance[source] = 0;
    q.push(source);
    
    while (!q.empty()) {
        int node = q.front(); q.pop();
        
        for (int neighbor : graph[node]) {
            if (distance[neighbor] == -1) {
                distance[neighbor] = distance[node] + 1;
                parent[neighbor] = node;
                q.push(neighbor);
                
                if (neighbor == destination) {
                    // Reconstruct path
                    vector<int> path;
                    for (int v = destination; v != -1; v = parent[v])
                        path.push_back(v);
                    reverse(path.begin(), path.end());
                    return path;
                }
            }
        }
    }
    
    return {}; // No path found
}
```

### 2. Cycle Detection in Directed Graph (DFS)
```cpp
bool isCyclicUtil(int v, vector<bool>& visited, vector<bool>& recStack, 
                 const vector<vector<int>>& graph) {
    if (!visited[v]) {
        visited[v] = true;
        recSRC[v] = true;
        
        for (int neighbor : graph[v]) {
            if (!visited[neighbor] && isCyclicUtil(neighbor, visited, recStack, graph))
                return true;
            else if (recStack[neighbor])
                return true;
        }
    }
    recStack[v] = false;
    return false;
}

bool isCyclic(int V, vector<vector<int>>& graph) {
    vector<bool> visited(V, false);
    vector<bool> recStack(V, false);
    
    for (int i = 0; i < V; i++)
        if (!visited[i] && isCyclicUtil(i, visited, recStack, graph))
            return true;
    
    return false;
}
```

## Choosing the Right Algorithm

### Decision Matrix

| Data Structure | Operation | Best Algorithm | Time Complexity |
|----------------|-----------|----------------|-----------------|
| Unsorted Array | Search | Linear Search | O(n) |
| Sorted Array | Search | Binary Search | O(log n) |
| Sorted Array | Insert/Delete | Binary Search Tree | O(log n) avg |
| Key-Value Pairs | Lookup | Hash Table | O(1) avg |
| String Keys | Prefix Search | Trie | O(L) |
| Graph | Shortest Path (unweighted) | BFS | O(V+E) |
| Graph | Connectivity/Maze | DFS | O(V+E) |
| Sorted Array | Uniform Distribution | Interpolation Search | O(log log n) avg |
| Unbounded Sorted Array | Search | Exponential Search | O(log n) |

### When to Use Which

#### Use Linear Search When:
- Dataset is small (n < 50)
- Data is unsorted
- Memory is extremely constrained
- Simplicity is preferred over performance

#### Use Binary Search When:
- Data is sorted
- Performing multiple searches on same dataset
- Need guaranteed O(log n) performance
- Memory usage must be O(1)

#### Use Hash Tables When:
- Average-case O(1) lookup is critical
- Dataset is static or infrequently updated
- Memory is available for the table
- Ordering is not required

#### Use BST When:
- Need ordered operations (min, max, predecessor, successor)
- Frequent insertions and deletions
- Memory overhead of tree nodes is acceptable
- Self-balancing variants needed for guaranteed performance

#### Use Trie When:
- Storing strings with common prefixes
- Need prefix-based searching/auto-completion
- Memory overhead is acceptable for string-specific operations
- Alphabet size is reasonable

#### Use BFS When:
- Finding shortest path in unweighted graph
- Need level-by-level traversal
- Graph is wide but not extremely deep
- Memory available for queue storage

#### Use DFS When:
- Memory is limited (uses call stack)
- Graph is deep but not wide
- Need to explore as far as possible along each branch
- Detecting cycles or topological sorting

## Implementation Best Practices

### 1. Boundary Checking
```cpp
// Always check for empty containers
if (container.empty()) return -1;

// Handle single element case
if (container.size() == 1) 
    return (container[0] == target) ? 0 : -1;
```

### 2. Avoiding Overflow
```cpp
// Dangerous: (left + right) / 2 can overflow
int mid = (left + right) / 2;

// Safe alternatives:
int mid = left + (right - left) / 2;
int mid = (left >> 1) + (right >> 1) + ((left & 1) & (right & 1));
```

### 3. Working with Comparators
```cpp
// Generic binary search with custom comparator
template<typename T, typename Compare>
int binarySearch(const vector<T>& arr, const T& target, Compare comp) {
    int left = 0, right = arr.size() - 1;
    
    while (left <= right) {
        int mid = left + (right - left) / 2;
        
        if (!comp(arr[mid], target) && !comp(target, arr[mid])) {
            return mid; // Found
        }
        if (comp(arr[mid], target)) {
            left = mid + 1; // Search right
        } else {
            right = mid - 1; // Search left
        }
    }
    return -1; // Not found
}
```

### 4. Returning Insertion Position
```cpp
// Returns index where target should be inserted to maintain sorted order
int searchInsert(vector<int>& nums, int target) {
    int left = 0, right = nums.size();
    
    while (left < right) {
        int mid = left + (right - left) / 2;
        if (nums[mid] >= target)
            right = mid;
        else
            left = mid + 1;
    }
    return left;
}
```

### 5. Handling Duplicates
```cpp
// Find first occurrence of target
int firstOccurrence(vector<int>& arr, int target) {
    int left = 0, right = arr.size() - 1;
    int result = -1;
    
    while (left <= right) {
        int mid = left + (right - left) / 2;
        
        if (arr[mid] == target) {
            result = mid;
            right = mid - 1; // Continue searching left
        } else if (arr[mid] < target) {
            left = mid + 1;
        } else {
            right = mid - 1;
        }
    }
    return result;
}

// Find last occurrence of target
int lastOccurrence(vector<int>& arr, int target) {
    int left = 0, right = arr.size() - 1;
    int result = -1;
    
    while (left <= right) {
        int mid = left + (right - left) / 2;
        
        if (arr[mid] == target) {
            result = mid;
            left = mid + 1; // Continue searching right
        } else if (arr[mid] < target) {
            left = mid + 1;
        } else {
            right = mid - 1;
        }
    }
    return result;
}
```

## Time and Space Complexity Reference

### Array-Based Searching
| Algorithm | Best Case | Average Case | Worst Case | Space |
|-----------|-----------|--------------|------------|-------|
| Linear Search | O(1) | O(n) | O(n) | O(1) |
| Binary Search | O(1) | O(log n) | O(log n) | O(1) |
| Interpolation Search | O(1) | O(log log n) | O(n) | O(1) |
| Exponential Search | O(1) | O(log n) | O(log n) | O(1) |
| Jump Search | O(1) | O(√n) | O(√n) | O(1) |
| Fibonacci Search | O(1) | O(log n) | O(log n) | O(1) |

### Hash-Based Searching
| Algorithm | Best Case | Average Case | Worst Case | Space |
|-----------|-----------|--------------|------------|-------|
| Hash Table (good hash) | O(1) | O(1) | O(n) | O(n) |
| Hash Table (bad hash) | O(n) | O(n) | O(n) | O(n) |

### Tree-Based Searching
| Algorithm | Best Case | Average Case | Worst Case | Space |
|-----------|-----------|--------------|------------|-------|
| BST (unbalanced) | O(1) | O(log n) | O(n) | O(n) |
| AVL/Red-Black Tree | O(log n) | O(log n) | O(log n) | O(n) |
| Trie | O(L) | O(L) | O(L) | O(N*L*M) |

### Graph-Based Searching
| Algorithm | Time Complexity | Space Complexity | Notes |
|-----------|-----------------|------------------|-------|
| BFS | O(V + E) | O(V) | Queue storage |
| DFS | O(V + E) | O(V) | Recursion stack or explicit stack |
| Bidirectional BFS | O(V + E) | O(V) | Two frontiers meet in middle |
| A* Search | O(b^d) | O(b^d) | b=branching factor, d=depth |

## Common Pitfalls and How to Avoid Them

### 1. Off-by-One Errors
**Problem**: Incorrect loop bounds or mid calculations
**Solution**: 
- Use `left < right` vs `left <= right` consistently
- Test with edge cases: empty array, single element, two elements
- Use `left + (right - left) / 2` to avoid overflow

### 2. Infinite Loops
**Problem**: Search bounds not changing properly
**Solution**:
- Ensure each iteration reduces search space
- Verify update conditions: `left = mid + 1` or `right = mid - 1`
- Add iteration counter as safety check in debugging

### 3. Incorrect Comparison Logic
**Problem**: Wrong direction when moving search bounds
**Solution**:
- Draw out examples on paper
- Test with known values
- Remember: if target > mid, search right; if target < mid, search left

### 4. Missing Base Cases (Recursive)
**Problem**: Recursion never terminates
**Solution**:
- Always define clear base case
- Ensure each recursive call moves toward base case
- Test with minimal inputs

### 5. Integer Overflow
**Problem**: `(left + right) / 2` overflows for large indices
**Solution**: Use `left + (right - left) / 2`

### 6. Floating Point Precision Issues
**Problem**: Equality checks with floating point numbers
**Solution**:
- Use epsilon comparisons: `abs(a - b) < EPSILON`
- Avoid direct equality checks with floats/doubles
- Consider integer alternatives when possible

### 7. Not Handling Edge Cases
**Problem**: Code fails on empty input, single element, etc.
**Solution**:
- Test with: empty array, single element, all same elements
- Test with target at beginning, middle, end
- Test with target not present (less than min, greater than max)

## Performance Optimization Tips

### 1. Cache Efficiency
- Access memory sequentially when possible
- Consider block-based search for large datasets
- Use blocked or cache-oblivious algorithms for huge datasets

### 2. Branch Prediction
- Sort likelihood of branches in if-else chains
- Use lookup tables instead of complex conditionals when possible
- Profile to identify mispredicted branches

### 3. Memory Access Patterns
- Prefer contiguous memory access (arrays) over linked structures
- Consider data locality when choosing between array-based and tree-based structures
- Use memory pools for frequent allocations

### 4. Compiler Optimizations
- Enable optimization flags (-O2, -O3)
- Use constexpr for compile-time computations
- Consider inline functions for small, frequently called functions

### 5. Parallelization
- Divide and conquer algorithms often parallelize well
- Consider parallel binary search for massive datasets
- GPU acceleration possible for certain search patterns

## When Not to Use Certain Algorithms

### Avoid Binary Search When:
- Data is frequently inserted/deleted (maintaining sort is expensive)
- Dataset is very small (linear search may be faster due to cache effects)
- Need to find all occurrences (better to use linear scan after finding one)

### Avoid Hash Tables When:
- Need ordered traversal of elements
- Memory is extremely limited
- Worst-case O(n) performance is unacceptable
- Keys are not easily hashable

### Avoid Trees When:
- Memory overhead of pointers is prohibitive
- Need cache-friendly access patterns
- Simpler array-based solutions suffice
- Random access by index is frequently needed

### Avoid Tries When:
- Alphabet size is very large (memory explosion)
- Strings are very short (overhead outweighs benefits)
- Only exact matches needed (hash table may be better)
- String data doesn't share common prefixes

## Real-World Applications

### 1. Databases
- B-Tree and B+ Tree indexes for range queries
- Hash indexes for exact match queries
- Bitmap indexing for low-cardinality columns

### 2. Compilers and Interpreters
- Symbol table lookups (hash tables or balanced trees)
- Keyword scanning (tries or finite automata)
- Instruction caching (hash tables)

### 3. Web Search Engines
- Inverted indexing (hash maps + posting lists)
- Trie-based autocomplete suggestions
- PageRank computation (graph algorithms)

### 4. Networking
- Routing table lookups (tries for longest prefix match)
- ARP cache (hash tables)
- Packet filtering (various data structures)

### 5. Operating Systems
- Process scheduling (priority queues)
- File system directories (B-trees or hash tables)
- Virtual memory management (page tables, often multi-level trees)

### 6. Game Development
- Pathfinding (A*, Dijkstra's on grids)
- Collision detection (spatial hashing, quadtrees)
- Game state transposition tables (hash tables)

### 7. Bioinformatics
- DNA sequence matching (suffix trees/arrays, BWT)
- Protein database searching (BLAST uses heuristic seeding)
- Genome alignment (dynamic programming with optimization)

## Summary

Mastering searching algorithms requires understanding both the theoretical foundations and practical implementation considerations. Key takeaways:

1. **Know Your Data**: Choose algorithms based on data characteristics (sorted/unsorted, static/dynamic, size, distribution)
2. **Understand Trade-offs**: Time vs. space, average vs. worst case, implementation complexity
3. **Consider Memory Hierarchy**: Cache performance often matters more than theoretical complexity
4. **Test Thoroughly**: Edge cases, empty inputs, duplicates, boundary conditions
5. **Profile and Optimize**: Real performance may differ from theoretical predictions
6. **Stay Updated**: New variants and hybrid approaches continue to emerge

The most skilled programmers don't just know algorithms—they understand when and why to apply each one, and can adapt or combine them to solve novel problems efficiently.