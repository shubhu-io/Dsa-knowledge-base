# Searching Algorithms Tutorial

## Introduction to Searching

Searching is the process of finding a specific element (called the key or target) within a collection of data. It's one of the most fundamental operations in computer science, with applications ranging from databases and compilers to artificial intelligence and networking.

### Why Searching Matters

- **Database Systems**: Finding records matching criteria
- **Compilers**: Symbol table lookup for variables and functions
- **Networking**: Routing table lookups
- **AI**: State space search in problem-solving
- **Web Search**: Finding relevant documents
- **Security**: Intrusion detection and malware scanning

### Classification of Searching Algorithms

Searching algorithms can be classified along several dimensions:

1. **By Data Structure**:
   - Array-based search
   - Tree-based search (BST, AVL, Red-Black)
   - Hash-based search
   - Graph-based search

2. **By Approach**:
   - Sequential vs. Divide and Conquer
   - Deterministic vs. Probabilistic
   - Exact vs. Approximate

3. **By Requirements**:
   - Online vs. Offline (can preprocess?)
   - Static vs. Dynamic dataset
   - Exact match vs. Nearest neighbor

## Fundamental Searching Algorithms

### 1. Linear Search (Sequential Search)
The simplest searching algorithm that checks each element in sequence until the target is found or the end is reached.

**Algorithm**:
```cpp
int linearSearch(const vector<int>& arr, int target) {
    for (int i = 0; i < arr.size(); i++) {
        if (arr[i] == target) {
            return i; // Found at index i
        }
    }
    return -1; // Not found
}
```

**Characteristics**:
- Time Complexity: O(n) worst and average case, O(1) best case
- Space Complexity: O(1)
- Works on: Unsorted or sorted data
- Advantages: Simple, no preprocessing required
- Disadvantages: Slow for large datasets

**When to Use**:
- Small datasets
- Unsorted data with infrequent searches
- When simplicity is preferred over performance

### 2. Binary Search
A divide-and-conquer algorithm that works on sorted arrays by repeatedly dividing the search interval in half.

**Algorithm**:
```cpp
int binarySearch(const vector<int>& arr, int target) {
    int left = 0;
    int right = arr.size() - 1;
    
    while (left <= right) {
        int mid = left + (right - left) / 2;
        
        if (arr[mid] == target) {
            return mid; // Found
        }
        if (arr[mid] < target) {
            left = mid + 1; // Search right half
        } else {
            right = mid - 1; // Search left half
        }
    }
    return -1; // Not found
}
```

**Recursive Version**:
```cpp
int binarySearchRecursive(const vector<int>& arr, int target, 
                         int left, int right) {
    if (left > right) return -1;
    
    int mid = left + (right - left) / 2;
    
    if (arr[mid] == target) return mid;
    if (arr[mid] < target) 
        return binarySearchRecursive(arr, target, mid + 1, right);
    else
        return binarySearchRecursive(arr, target, left, mid - 1);
}
```

**Characteristics**:
- Time Complexity: O(log n) worst and average case, O(1) best case
- Space Complexity: O(1) iterative, O(log n) recursive
- Works on: Sorted data only
- Advantages: Very efficient for large sorted datasets
- Disadvantages: Requires sorted data (O(n log n) preprocessing)

**Variants**:
- Lower bound (first occurrence >= target)
- Upper bound (first occurrence > target)
- Exponential search (for unbounded arrays)
- Interpolation search (for uniformly distributed data)

### 3. Hash Table Search
Uses a hash function to map keys to array indices for O(1) average lookup time.

**Basic Concept**:
```cpp
class HashTable {
private:
    static const int TABLE_SIZE = 10007; // Prime number
    vector<list<pair<int, int>>> table; // Separate chaining
    
    int hash(int key) {
        return key % TABLE_SIZE;
    }
    
public:
    void insert(int key, int value) {
        int index = hash(key);
        // Check if key already exists
        for (auto& kv : table[index]) {
            if (kv.first == key) {
                kv.second = value; // Update
                return;
            }
        }
        // Insert new key-value pair
        table[index].push_back({key, value});
    }
    
    int search(int key) {
        int index = hash(key);
        for (auto& kv : table[index]) {
            if (kv.first == key) {
                return kv.second; // Found
            }
        }
        return -1; // Not found (or use optional)
    }
    
    void remove(int key) {
        int index = hash(key);
        auto& bucket = table[index];
        for (auto it = bucket.begin(); it != bucket.end(); ++it) {
            if (it->first == key) {
                bucket.erase(it);
                return;
            }
        }
    }
};
```

**Characteristics**:
- Time Complexity: O(1) average, O(n) worst case (all keys collide)
- Space Complexity: O(n)
- Works on: Key-value pairs
- Advantages: Extremely fast average case
- Disadvantages: Worst case O(n), requires good hash function, memory overhead

**Collision Resolution Techniques**:
1. **Separate Chaining**: Each bucket contains a linked list of entries
2. **Open Addressing**:
   - Linear Probing: Check next sequential slot
   - Quadratic Probing: Check slots at increasing quadratic intervals
   - Double Hashing: Use second hash function to determine step size

### 4. Binary Search Tree (BST) Search
Search in a binary tree where left child < parent < right child.

**Algorithm**:
```cpp
struct TreeNode {
    int val;
    TreeNode* left;
    TreeNode* right;
    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
};

TreeNode* bstSearch(TreeNode* root, int target) {
    if (!root || root->val == target) {
        return root;
    }
    if (target < root->val) {
        return bstSearch(root->left, target);
    } else {
        return bstSearch(root->right, target);
    }
}

// Iterative version
TreeNode* bstSearchIterative(TreeNode* root, int target) {
    TreeNode* current = root;
    while (current && current->val != target) {
        if (target < current->val) {
            current = current->left;
        } else {
            current = current->right;
        }
    }
    return current;
}
```

**Characteristics**:
- Time Complexity: O(h) where h is tree height
- Space Complexity: O(h) for recursion, O(1) for iteration
- Works on: Binary Search Trees
- Advantages: Efficient for balanced trees, supports ordered operations
- Disadvantages: Can degrade to O(n) for unbalanced trees

**Self-Balancing Variants**:
- AVL Trees: Height-balanced, O(log n) guarantee
- Red-Black Trees: Approximately balanced, O(log n) guarantee
- Splay Trees: Recently accessed elements are quick to access again

### 5. Trie (Prefix Tree) Search
Tree-like data structure for storing strings where each node represents a character.

**Algorithm**:
```cpp
struct TrieNode {
    bool isEndOfWord;
    TrieNode* children[26]; // Assuming lowercase English letters
    
    TrieNode() : isEndOfWord(false) {
        fill(begin(children), end(children), nullptr);
    }
};

class Trie {
private:
    TrieNode* root;
    
public:
    Trie() {
        root = new TrieNode();
    }
    
    void insert(const string& word) {
        TrieNode* current = root;
        for (char ch : word) {
            int index = ch - 'a';
            if (!current->children[index]) {
                current->children[index] = new TrieNode();
            }
            current = current->children[index];
        }
        current->isEndOfWord = true;
    }
    
    bool search(const string& word) {
        TrieNode* current = root;
        for (char ch : word) {
            int index = ch - 'a';
            if (!current->children[index]) {
                return false;
            }
            current = current->children[index];
        }
        return current->isEndOfWord;
    }
    
    bool startsWith(const string& prefix) {
        TrieNode* current = root;
        for (char ch : prefix) {
            int index = ch - 'a';
            if (!current->children[index]) {
                return false;
            }
            current = current->children[index];
        }
        return true; // Prefix exists
    }
};
```

**Characteristics**:
- Time Complexity: O(L) where L is length of key
- Space Complexity: O(N*L*M) where N is number of keys, L is avg length, M is alphabet size
- Works on: String keys
- Advantages: Fast prefix searches, excellent for autocomplete
- Disadvantages: High memory usage for large alphabets

### 6. Breadth-First Search (BFS)
Graph traversal algorithm that explores vertices in layers (by distance from source).

**Algorithm**:
```cpp
vector<int> bfs(const vector<vector<int>>& graph, int start) {
    int n = graph.size();
    vector<bool> visited(n, false);
    vector<int> result;
    queue<int> q;
    
    visited[start] = true;
    q.push(start);
    
    while (!q.empty()) {
        int node = q.front();
        q.pop();
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

// To find shortest path distances
vector<int> bfsShortestPath(const vector<vector<int>>& graph, int start) {
    int n = graph.size();
    vector<int> distance(n, -1);
    queue<int> q;
    
    distance[start] = 0;
    q.push(start);
    
    while (!q.empty()) {
        int node = q.front();
        q.pop();
        
        for (int neighbor : graph[node]) {
            if (distance[neighbor] == -1) {
                distance[neighbor] = distance[node] + 1;
                q.push(neighbor);
            }
        }
    }
    return distance;
}
```

**Characteristics**:
- Time Complexity: O(V + E)
- Space Complexity: O(V)
- Works on: Graphs (unweighted for shortest path)
- Advantages: Finds shortest path in unweighted graphs, level-order traversal
- Disadvantages: Higher memory usage than DFS for wide graphs

### 7. Depth-First Search (DFS)
Graph traversal algorithm that explores as far as possible along each branch before backtracking.

**Algorithm**:
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

// Iterative version using stack
vector<int> dfsIterative(const vector<vector<int>>& graph, int start) {
    int n = graph.size();
    vector<bool> visited(n, false);
    vector<int> result;
    stack<int> s;
    
    s.push(start);
    
    while (!s.empty()) {
        int node = s.top();
        s.pop();
        
        if (visited[node]) continue;
        visited[node] = true;
        result.push_back(node);
        
        // Push neighbors in reverse order to maintain same order as recursive
        for (auto it = graph[node].rbegin(); it != graph[node].rend(); ++it) {
            if (!visited[*it]) {
                s.push(*it);
            }
        }
    }
    return result;
}
```

**Characteristics**:
- Time Complexity: O(V + E)
- Space Complexity: O(V)
- Works on: Graphs
- Advantages: Lower memory usage than BFS for deep graphs, easy to implement recursively
- Disadvantages: Doesn't guarantee shortest path in unweighted graphs

## Advanced Searching Algorithms

### 1. Interpolation Search
Improved variant of binary search for uniformly distributed data.

**Algorithm**:
```cpp
int interpolationSearch(const vector<int>& arr, int target) {
    int left = 0;
    int right = arr.size() - 1;
    
    while (left <= right && target >= arr[left] && target <= arr[right]) {
        if (left == right) {
            if (arr[left] == target) return left;
            return -1;
        }
        
        // Probing the position with keeping uniform distribution in mind
        int pos = left + (((double)(right - left) / 
                          (arr[right] - arr[left])) * 
                         (target - arr[left]));
        
        if (arr[pos] == target) return pos;
        
        if (arr[pos] < target)
            left = pos + 1;
        else
            right = pos - 1;
    }
    return -1;
}
```

**Characteristics**:
- Time Complexity: O(log log n) average case for uniform distribution, O(n) worst case
- Space Complexity: O(1)
- Works on: Sorted and uniformly distributed data

### 2. Exponential Search
Useful for unbounded or infinite arrays.

**Algorithm**:
```cpp
int exponentialSearch(const vector<int>& arr, int target) {
    if (arr.empty()) return -1;
    if (arr[0] == target) return 0;
    
    // Find range where element might be present
    int bound = 1;
    while (bound < arr.size() && arr[bound] <= target) {
        bound *= 2;
    }
    
    // Call binary search for the found range
    return binarySearch(arr, target, 
                       bound/2, min(bound, (int)arr.size()-1));
}
```

**Characteristics**:
- Time Complexity: O(log n)
- Space Complexity: O(1)
- Works on: Sorted arrays (especially unbounded)

### 3. Jump Search
Searches by jumping ahead by fixed steps.

**Algorithm**:
```cpp
int jumpSearch(const vector<int>& arr, int target) {
    int n = arr.size();
    if (n == 0) return -1;
    
    // Finding block size to be jumped
    int step = sqrt(n);
    
    // Finding the block where element is present (if it is present)
    int prev = 0;
    while (arr[min(step, n)-1] < target) {
        prev = step;
        step += sqrt(n);
        if (prev >= n) return -1;
    }
    
    // Doing a linear search for target in block beginning with prev
    while (arr[prev] < target) {
        prev++;
        if (prev == min(step, n)) return -1;
    }
    
    // If element is found
    if (arr[prev] == target) return prev;
    
    return -1;
}
```

**Characteristics**:
- Time Complexity: O(√n)
- Space Complexity: O(1)
- Works on: Sorted arrays

### 4. Fibonacci Search
Uses Fibonacci numbers to divide the array.

**Algorithm**:
```cpp
int fibonacciSearch(const vector<int>& arr, int target) {
    int n = arr.size();
    if (n == 0) return -1;
    
    // Initialize Fibonacci numbers
    int fibMMm2 = 0; // (m-2)'th Fibonacci No.
    int fibMMm1 = 1; // (m-1)'th Fibonacci No.
    int fibM = fibMMm2 + fibMMm1; // m'th Fibonacci
    
    // fibM is going to store the smallest Fibonacci Number
    // greater than or equal to n
    while (fibM < n) {
        fibMMm2 = fibMMm1;
        fibMMm1 = fibM;
        fibM = fibMMm2 + fibMMm1;
    }
    
    // Marks the eliminated range from front
    int offset = -1;
    
    // While there are elements to be inspected
    while (fibM > 1) {
        // Check if fibMMm2 is a valid location
        int i = min(offset + fibMMm2, n-1);
        
        // If x is greater than the value at index fibMMm2,
        // cut the subarray array from offset to i
        if (arr[i] < target) {
            fibM = fibMMm1;
            fibMMm1 = fibMMm2;
            fibMMm2 = fibM - fibMMm1;
            offset = i;
        }
        // If x is less than the value at index fibMMm2,
        // cut the subarray after i+1
        else if (arr[i] > target) {
            fibM = fibMMm2;
            fibMMm1 = fibMMm1 - fibMMm2;
            fibMMm2 = fibM - fibMMm1;
        }
        // element found
        else return i;
    }
    
    // comparing the last element with x
    if(fibMMm1 && arr[offset+1] == target) return offset+1;
    
    return -1;
}
```

**Characteristics**:
- Time Complexity: O(log n)
- Space Complexity: O(1)
- Works on: Sorted arrays

### 5. Ternary Search
Divides array into three parts instead of two.

**Algorithm**:
```cpp
int ternarySearch(const vector<int>& arr, int target) {
    int left = 0;
    int right = arr.size() - 1;
    
    while (left <= right) {
        int third = (right - left) / 3;
        int mid1 = left + third;
        int mid2 = right - third;
        
        if (arr[mid1] == target) return mid1;
        if (arr[mid2] == target) return mid2;
        
        if (target < arr[mid1]) {
            right = mid1 - 1;
        } else if (target > arr[mid2]) {
            left = mid2 + 1;
        } else {
            left = mid1 + 1;
            right = mid2 - 1;
        }
    }
    return -1;
}
```

**Characteristics**:
- Time Complexity: O(log₃ n) ≈ O(log n)
- Space Complexity: O(1)
- Works on: Sorted arrays
- Advantage: Fewer comparisons than binary search in some cases
- Disadvantage: More complex implementation

### 6. Binary Search in Rotated Sorted Array
Search in an array that was sorted and then rotated.

**Algorithm**:
```cpp
int searchRotated(const vector<int>& arr, int target) {
    int left = 0;
    int right = arr.size() - 1;
    
    while (left <= right) {
        int mid = left + (right - left) / 2;
        
        if (arr[mid] == target) return mid;
        
        // Check if left half is sorted
        if (arr[left] <= arr[mid]) {
            // Left half is sorted
            if (target >= arr[left] && target < arr[mid]) {
                right = mid - 1;
            } else {
                left = mid + 1;
            }
        } else {
            // Right half must be sorted
            if (target > arr[mid] && target <= arr[right]) {
                left = mid + 1;
            } else {
                right = mid - 1;
            }
        }
    }
    return -1;
}
```

**Characteristics**:
- Time Complexity: O(log n)
- Space Complexity: O(1)
- Works on: Rotated sorted arrays

## Application-Specific Searching

### 1. String Matching Algorithms

#### Naive String Matching
```cpp
vector<int> naiveSearch(const string& text, const string& pattern) {
    vector<int> matches;
    int n = text.length();
    int m = pattern.length();
    
    for (int i = 0; i <= n - m; i++) {
        int j;
        for (j = 0; j < m; j++) {
            if (text[i + j] != pattern[j]) break;
        }
        if (j == m) {
            matches.push_back(i);
        }
    }
    return matches;
}
```

#### Rabin-Karp Algorithm (Rolling Hash)
```cpp
vector<int> rabinKarp(const string& text, const string& pattern) {
    vector<int> matches;
    int n = text.length();
    int m = pattern.length();
    
    if (n < m) return matches;
    
    const int d = 256; // Alphabet size
    const int q = 101; // A prime number
    
    long long patternHash = 0;
    long long textHash = 0;
    long long h = 1;
    
    // The value of h would be "pow(d, m-1)%q"
    for (int i = 0; i < m-1; i++)
        h = (h * d) % q;
    
    // Calculate hash value of pattern and first window of text
    for (int i = 0; i < m; i++) {
        patternHash = (d * patternHash + pattern[i]) % q;
        textHash = (d * textHash + text[i]) % q;
    }
    
    // Slide the pattern over text one by one
    for (int i = 0; i <= n - m; i++) {
        // Check the hash values of current window of text and pattern
        if (patternHash == textHash) {
            // Check for characters one by one
            int j;
            for (j = 0; j < m; j++) {
                if (text[i + j] != pattern[j])
                    break;
            }
            
            // If hash matches and all characters match
            if (j == m) {
                matches.push_back(i);
            }
        }
        
        // Calculate hash value for next window of text
        if (i < n - m) {
            textHash = (d * (textHash - text[i] * h) + text[i + m]) % q;
            
            // We might get negative value of textHash, converting it to positive
            if (textHash < 0)
                textHash = (textHash + q);
        }
    }
    
    return matches;
}
```

#### Knuth-Morris-Pratt (KMP) Algorithm
```cpp
vector<int> computeLPSArray(const string& pattern) {
    int m = pattern.length();
    vector<int> lps(m, 0);
    
    int len = 0; // Length of previous longest prefix suffix
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

vector<int> kmpSearch(const string& text, const string& pattern) {
    vector<int> matches;
    int n = text.length();
    int m = pattern.length();
    
    if (m == 0) return matches;
    
    vector<int> lps = computeLPSArray(pattern);
    
    int i = 0; // Index for text
    int j = 0; // Index for pattern
    
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

### 2. Nearest Neighbor Search

#### In Sorted Arrays (using binary search variants)
```cpp
int findClosest(const vector<int>& arr, int target) {
    if (arr.empty()) return -1;
    if (target <= arr[0]) return 0;
    if (target >= arr.back()) return arr.size() - 1;
    
    // Binary search for closest element
    int left = 0;
    int right = arr.size() - 1;
    
    while (left <= right) {
        int mid = left + (right - left) / 2;
        
        if (arr[mid] == target) return mid;
        
        if (target < arr[mid]) {
            if (mid > 0 && target > arr[mid-1]) {
                // Found closest pair
                return (target - arr[mid-1] <= arr[mid] - target) ? mid-1 : mid;
            }
            right = mid - 1;
        } else {
            if (mid < arr.size()-1 && target < arr[mid+1]) {
                // Found closest pair
                return (arr[mid+1] - target <= target - arr[mid]) ? mid+1 : mid;
            }
            left = mid + 1;
        }
    }
    
    // Should not reach here if array is not empty
    return 0;
}
```

#### In Metric Spaces (K-D Tree)
```cpp
struct KDTreeNode {
    Point point;
    int id;
    KDTreeNode* left;
    KDTreeNode* right;
    int dimension;
    
    KDTreeNode(const Point& p, int i, int d) 
        : point(p), id(i), left(nullptr), right(nullptr), dimension(d) {}
};

class KDTree {
private:
    KDTreeNode* root;
    int dimensions;
    
    KDTreeNode* buildRecursive(vector<pair<Point, int>>& points, 
                              int depth, int left, int right) {
        if (left > right) return nullptr;
        
        int axis = depth % dimensions;
        int mid = (left + right) / 2;
        
        // Sort by axis
        auto compareByAxis = [axis](const pair<Point, int>& a, 
                                   const pair<Point, int>& b) {
            if (axis == 0) {
                return a.first.x < b.first.x || 
                       (a.first.x == b.first.x && a.first.y < b.first.y);
            } else {
                return a.first.y < b.first.y || 
                       (a.first.y == b.first.y && a.first.x < b.first.x);
            }
        };
        
        sort(points.begin() + left, points.begin() + right + 1, compareByAxis);
        
        KDTreeNode* node = new KDTreeNode(points[mid].first, points[mid].second, axis);
        
        node->left = buildRecursive(points, depth + 1, left, mid - 1);
        node->right = buildRecursive(points, depth + 1, mid + 1, right);
        
        return node;
    }
    
    void nearestNeighborSearch(KDTreeNode* node, const Point& target, 
                              int depth, double& bestDist, Point& bestPoint,
                              int& bestId) {
        if (!node) return;
        
        double dist = distance(node->point, target);
        if (dist < bestDist) {
            bestDist = dist;
            bestPoint = node->point;
            bestId = node->id;
        }
        
        int axis = node->dimension;
        double diff = (axis == 0) ? (target.x - node->point.x) : (target.y - node->point.y);
        
        // Search nearer subtree first
        KDTreeNode* first = (diff < 0) ? node->left : node->right;
        KDTreeNode* second = (diff < 0) ? node->right : node->left;
        
        nearestNeighborSearch(first, target, depth + 1, bestDist, bestPoint, bestId);
        
        // Check if we need to search farther subtree
        double axisDist = abs(diff);
        if (axisDist * axisDist < bestDist) {
            nearestNeighborSearch(second, target, depth + 1, bestDist, bestPoint, bestId);
        }
    }
    
public:
    KDTree(vector<Point>& points, vector<int>& ids) {
        dimensions = 2;
        vector<pair<Point, int>> pointsWithIds;
        for (int i = 0; i < points.size(); i++) {
            pointsWithIds.push_back({points[i], ids[i]});
        }
        root = buildRecursive(pointsWithIds, 0, 0, points.size() - 1);
    }
    
    pair<Point, int> nearestNeighbor(const Point& target) {
        double bestDist = numeric_limits<double>::max();
        Point bestPoint;
        int bestId = -1;
        
        nearestNeighborSearch(root, target, 0, bestDist, bestPoint, bestId);
        return {bestPoint, bestId};
    }
};
```

## Choosing the Right Searching Algorithm

### Decision Factors

| Factor | Best Choice |
|--------|-------------|
| **Small dataset** (n < 50) | Linear Search (simplicity) |
| **Unsorted data, infrequent search** | Linear Search |
| **Sorted data** | Binary Search |
| **Many searches, static data** | Hash Table (O(1) average) |
| **Need ordered operations** | BST or Skip List |
| **String keys with prefix queries** | Trie |
| **Unbounded/infinite arrays** | Exponential Search |
| **Uniformly distributed data** | Interpolation Search |
| **Graph shortest path (unweighted)** | BFS |
| **Graph traversal/memory constrained** | DFS |
| **Approximate nearest neighbor** | LSH, KD-Tree, Ball Tree |
| **String matching (fixed pattern)** | KMP or Rabin-Karp |
| **Multiple pattern matching** | Aho-Corasick Algorithm |
| **Nearest neighbor in high dimensions** | LSH (Locality-Sensitive Hashing) |

### Time Complexity Comparison

| Algorithm | Best Case | Average Case | Worst Case | Space |
|-----------|-----------|--------------|------------|-------|
| Linear Search | O(1) | O(n) | O(n) | O(1) |
| Binary Search | O(1) | O(log n) | O(log n) | O(1) |
| Hash Table | O(1) | O(1) | O(n) | O(n) |
| BST Search | O(1) | O(log n) | O(n) | O(n) |
| Balanced BST | O(log n) | O(log n) | O(log n) | O(n) |
| Trie Search | O(L) | O(L) | O(L) | O(N*L*M) |
| Interpolation Search | O(1) | O(log log n) | O(n) | O(1) |
| Exponential Search | O(1) | O(log n) | O(log n) | O(1) |
| Jump Search | O(1) | O(√n) | O(√n) | O(1) |
| Fibonacci Search | O(1) | O(log n) | O(log n) | O(1) |
| Ternary Search | O(1) | O(log₃ n) | O(log₃ n) | O(1) |
| BFS/DFS | O(V+E) | O(V+E) | O(V+E) | O(V) |

### Space Complexity Comparison

| Algorithm | Auxiliary Space | Notes |
|-----------|-----------------|-------|
| Linear Search | O(1) | No extra space |
| Binary Search | O(1) iterative / O(log n) recursive | Stack space for recursion |
| Hash Table | O(n) | Load factor affects performance |
| BST | O(n) | Plus O(h) for recursion |
| Trie | O(N*L*M) | Can be optimized with compressed tries |
| BFS/DFS | O(V) | Queue/stack storage |

## Implementation Tips and Best Practices

### 1. Handling Edge Cases
```cpp
int safeBinarySearch(const vector<int>& arr, int target) {
    // Handle empty array
    if (arr.empty()) return -1;
    
    // Handle single element
    if (arr.size() == 1) {
        return (arr[0] == target) ? 0 : -1;
    }
    
    // Normal binary search
    int left = 0;
    int right = arr.size() - 1;
    
    while (left <= right) {
        int mid = left + (right - left) / 2;
        
        // Prevent overflow in (left + right) / 2
        // Using left + (right - left) / 2 is safe
        
        if (arr[mid] == target) return mid;
        if (arr[mid] < target) {
            left = mid + 1;
        } else {
            right = mid - 1;
        }
    }
    return -1;
}
```

### 2. Avoiding Integer Overflow
```cpp
// Dangerous: (left + right) / 2 can overflow
int mid = (left + right) / 2;

// Safe alternatives:
int mid = left + (right - left) / 2;
int mid = (left >> 1) + (right >> 1) + ((left & 1) & (right & 1)); // Bitwise
```

### 3. Working with Comparators
```cpp
template<typename T, typename Comparator>
int binarySearch(const vector<T>& arr, const T& target, Comparator comp) {
    int left = 0;
    int right = arr.size() - 1;
    
    while (left <= right) {
        int mid = left + (right - left) / 2;
        
        if (!comp(arr[mid], target) && !comp(target, arr[mid])) {
            // Elements are equivalent
            return mid;
        }
        if (comp(arr[mid], target)) {
            // arr[mid] < target
            left = mid + 1;
        } else {
            // target < arr[mid]
            right = mid - 1;
        }
    }
    return -1;
}
```

### 4. Returning Insertion Position
```cpp
// Returns index of target if found, otherwise index where it should be inserted
int searchInsert(const vector<int>& arr, int target) {
    int left = 0;
    int right = arr.size();
    
    while (left < right) {
        int mid = left + (right - left) / 2;
        
        if (arr[mid] >= target) {
            right = mid;
        } else {
            left = mid + 1;
        }
    }
    return left; // Left is the insertion point
}
```

### 5. Finding First and Last Occurrence
```cpp
// Find first occurrence of target
int firstOccurrence(const vector<int>& arr, int target) {
    int left = 0;
    int right = arr.size() - 1;
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
int lastOccurrence(const vector<int>& arr, int target) {
    int left = 0;
    int right = arr.size() - 1;
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

// Count occurrences
int countOccurrences(const vector<int>& arr, int target) {
    int first = firstOccurrence(arr, target);
    if (first == -1) return 0;
    int last = lastOccurrence(arr, target);
    return last - first + 1;
}
```

### 6. Searching in 2D Matrices
```cpp
// Search in row-wise and column-wise sorted matrix
bool search2DMatrix(const vector<vector<int>>& matrix, int target) {
    if (matrix.empty() || matrix[0].empty()) return false;
    
    int rows = matrix.size();
    int cols = matrix[0].size();
    
    // Start from top-right corner
    int row = 0;
    int col = cols - 1;
    
    while (row < rows && col >= 0) {
        if (matrix[row][col] == target) {
            return true;
        }
        if (matrix[row][col] > target) {
            col--; // Move left
        } else {
            row++; // Move down
        }
    }
    return false;
}
```

## Performance Optimization Techniques

### 1. Cache Optimization
```cpp
// Linear search with cache-friendly access
int cacheFriendlyLinearSearch(const vector<int>& arr, int target) {
    // Access elements sequentially for better cache locality
    for (size_t i = 0; i < arr.size(); i++) {
        if (arr[i] == target) return i;
    }
    return -1;
}

// Binary search already has good locality due to sequential mid calculations
```

### 2. Branch Prediction Optimization
```cpp
// Help compiler predict branches better
int branchFriendlyBinarySearch(const vector<int>& arr, int target) {
    int left = 0;
    int right = arr.size() - 1;
    
    while (left <= right) {
        int mid = left + (right - left) / 2;
        
        if (arr[mid] == target) {
            return mid;
        }
        
        // Likely branch: target is in larger half
        if (arr[mid] < target) {
            left = mid + 1;
        } else {
            right = mid - 1;
        }
    }
    return -1;
}
```

### 3. Using Standard Library
```cpp
// C++ STL provides efficient implementations
#include <algorithm>
#include <unordered_map>

// Binary search in sorted vector
auto it = lower_bound(vec.begin(), vec.end(), target);
if (it != vec.end() && *it == target) {
    // Found at distance(it, vec.begin())
}

// Hash table lookup
unordered_map<int, int> hashTable;
// ... insert elements ...
auto it = hashTable.find(key);
if (it != hashTable.end()) {
    // Found: it->second
}

// Binary search in sorted array (using pointers)
int* arrPtr = arr.data();
int* result = lower_bound(arrPtr, arrPtr + arr.size(), target);
if (result != arrPtr + arr.size() && *result == target) {
    // Found at index(result - arrPtr)
}
```

### 4. Parallel Searching
```cpp
// Parallel linear search (conceptual)
int parallelLinearSearch(const vector<int>& arr, int target) {
    const int numThreads = thread::hardware_concurrency();
    const size_t chunkSize = arr.size() / numThreads;
    atomic<int> result(-1);
    
    vector<thread> threads;
    for (int t = 0; t < numThreads; t++) {
        size_t start = t * chunkSize;
        size_t end = (t == numThreads - 1) ? arr.size() : start + chunkSize;
        
        threads.emplace_back([&, start, end]() {
            for (size_t i = start; i < end; i++) {
                if (arr[i] == target) {
                    result = i;
                    return; // Early termination
                }
            }
        });
    }
    
    for (auto& th : threads) {
        th.join();
    }
    return result;
}
```

## Real-World Applications

### 1. Database Systems
- **Indexing**: B+ trees, Hash indexes for fast record lookup
- **Query Optimization**: Selecting optimal search paths
- **Buffer Pool Management**: Finding pages in memory

### 2. Compilers and Interpreters
- **Symbol Tables**: Hash tables for variable/function lookup
- **Lexical Analysis**: DFA/NFAs for token recognition
- **Syntax Analysis**: Parse tree traversal

### 3. Networking and Web Services
- **Routing Tables**: Trie-based lookup for IP forwarding
- **DNS Caching**: Hash tables for domain-to-IP resolution
- **Load Balancing**: Consistent hashing for server selection
- **Web Search Engines**: Inverted indexing and ranking algorithms

### 4. Operating Systems
- **Process Scheduling**: Priority queues for process selection
- **File Systems**: B-trees for directory indexing
- **Memory Management**: Page table lookups
- **Virtual Memory**: TLB (Translation Lookaside Buffer) for address translation

### 5. Artificial Intelligence
- **Game Playing**: Minimax with alpha-beta pruning (game tree search)
- **Pathfinding**: A* algorithm (heuristic search)
- **Expert Systems**: Rule-based reasoning (fact matching)
- **Machine Learning**: Nearest neighbor search for classification/clustering

### 6. Bioinformatics
- **DNA Sequence Matching**: Knuth-Morris-Pratt, suffix trees
- **Protein Structure Search**: Geometric hashing
- **Genome Indexing**: Burrows-Wheeler Transform with FM-index
- **Sequence Alignment**: Dynamic programming with heuristic pruning

### 7. Computer Graphics
- **Ray Tracing**: Spatial partitioning (BVH, kd-trees, octrees)
- **Texture Lookup**: Mipmapping and texture atlases
- **Collision Detection**: Bounding volume hierarchies
- **Font Rendering**: Trie-based glyph lookup

### 8. Security and Cryptography
- **Intrusion Detection**: Pattern matching for malware signatures
- **Password Cracking**: Rainbow tables (hash chains)
- **Digital Signatures**: Merkle tree traversal
- **Zero-Knowledge Proofs**: Cryptographic accumulator searches

## Summary

Searching algorithms form the backbone of efficient data retrieval in computer science. Understanding when and how to apply each technique is crucial for optimal performance.

### Key Takeaways:
1. **Know your data**: Sorted/unsorted, static/dynamic, size, distribution
2. **Understand requirements**: Exact match, nearest neighbor, prefix search, etc.
3. **Consider trade-offs**: Time vs. space, preprocessing vs. query time
4. **Watch for edge cases**: Empty data, duplicates, boundary values
5. **Use standard libraries** when possible - they're well-optimized
6. **Profile and measure** - theoretical complexity theory doesn't always match practice
7. **Consider cache effects** - memory access patterns matter
8. **Think about scalability** - how does performance change with data size?

### Quick Reference Guide:
- **Need speed & can preprocess?** → Hash Table
- **Have sorted data?** → Binary Search (or variants)
- **Working with strings & prefixes?** → Trie
- **Need ordering operations?** → Balanced BST
- **Searching in graphs?** → BFS/DFS (based on requirements)
- **Small dataset or simplicity needed?** → Linear Search
- **Uniformly distributed numerical data?** → Interpolation Search
- **Unbounded search space?** → Exponential Search

Mastering searching algorithms enables you to build efficient systems that can quickly find the information they need, which is essential in today's data-driven world.