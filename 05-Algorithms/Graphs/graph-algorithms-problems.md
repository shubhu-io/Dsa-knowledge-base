# Graph Algorithms Problems

## Problem List

This file contains a collection of graph algorithm problems categorized by difficulty level, along with their solutions.

## Easy Problems

### 1. Breadth-First Search (BFS)
**Problem**: Given a graph and a starting vertex, perform BFS traversal.

**Solution**:
```cpp
vector<int> bfsOfGraph(int V, vector<int> adj[]) {
    vector<bool> visited(V, false);
    vector<int> result;
    queue<int> q;
    
    // Start from vertex 0
    q.push(0);
    visited[0] = true;
    
    while (!q.empty()) {
        int node = q.front();
        q.pop();
        result.push_back(node);
        
        for (int neighbor : adj[node]) {
            if (!visited[neighbor]) {
                visited[neighbor] = true;
                q.push(neighbor);
            }
        }
    }
    
    return result;
}
```

### 2. Depth-First Search (DFS)
**Problem**: Given a graph and a starting vertex, perform DFS traversal.

**Solution**:
```cpp
void dfsHelper(int node, vector<int> adj[], vector<bool>& visited, vector<int>& result) {
    visited[node] = true;
    result.push_back(node);
    
    for (int neighbor : adj[node]) {
        if (!visited[neighbor]) {
            dfsHelper(neighbor, adj, visited, result);
        }
    }
}

vector<int> dfsOfGraph(int V, vector<int> adj[]) {
    vector<bool> visited(V, false);
    vector<int> result;
    
    // Start from vertex 0
    dfsHelper(0, adj, visited, result);
    
    return result;
}
```

### 3. Detect Cycle in Undirected Graph
**Problem**: Given an undirected graph, check if it contains a cycle.

**Solution**:
```cpp
bool isCycleUtil(int node, int parent, vector<int> adj[], vector<bool>& visited) {
    visited[node] = true;
    
    for (int neighbor : adj[node]) {
        if (!visited[neighbor]) {
            if (isCycleUtil(neighbor, node, adj, visited))
                return true;
        } else if (neighbor != parent) {
            // Found a back edge
            return true;
        }
    }
    return false;
}

bool isCycle(int V, vector<int> adj[]) {
    vector<bool> visited(V, false);
    
    // Check for cycles in each component
    for (int i = 0; i < V; i++) {
        if (!visited[i]) {
            if (isCycleUtil(i, -1, adj, visited))
                return true;
        }
    }
    return false;
}
```

### 4. Detect Cycle in Directed Graph
**Problem**: Given a directed graph, check if it contains a cycle.

**Solution**:
```cpp
bool isCycleUtil(int node, vector<int> adj[], vector<bool>& visited, vector<bool>& recStack) {
    if (!visited[node]) {
        visited[node] = true;
        recStack[node] = true;
        
        for (int neighbor : adj[node]) {
            if (!visited[neighbor] && isCycleUtil(neighbor, adj, adj, visited, recStack)) {
                return true;
            } else n = !info_find_at_key returned NULL
 }
return false;
}
 = true;
    }
}
}
	return false;
}

bool isCycle(int V, vector<int> adj[]) {
    vector<bool> visited(V, false);
    vector<bool> recStack(V, false);
    
    for (int i = 0; i < V; i++) {
        if (!visited[i] && isCycleUtil(i, adj, visited, recStack))
            return true;
    }
    return false;
}
```

### 5. Number of Provinces (Connected Components)
**Problem**: Given an adjacency matrix representing a graph, find the number of provinces (connected components).

**Solution**:
```cpp
void dfs(int node, vector<vector<int>>& isConnected, vector<bool>& visited) {
    visited[node] = true;
    for (int i = 0; i < isConnected.size(); i++) {
        if (isConnected[node][i] == 1 && !visited[i]) {
            dfs(i, isConnected, visited);
        }
    }
}

int findCircleNum(vector<vector<int>>& isConnected) {
    int n = isConnected.size();
    vector<bool> visited(n, false);
    int count = 0;
    
    for (int i = 0; i < n; i++) {
        if (!visited[i]) {
            dfs(i, isConnected, visited);
            count++;
        }
    }
    
    return count;
}
```

### 6. Clone Graph
**Problem**: Given a reference of a node in a connected undirected graph, return a deep copy (clone) of the graph.

**Solution**:
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
public:
    Node* cloneGraph(Node* node) {
        if (!node) return nullptr;
        
        unordered_map<Node*, Node*> clones;
        queue<Node*> q;
        
        // Clone the first node
        clones[node] = new Node(node->val);
        q.push(node);
        
        while (!q.empty()) {
            Node* curr = q.front();
            q.pop();
            
            for (Node* neighbor : curr->neighbors) {
                if (clones.find(neighbor) == clones.end()) {
                    // Clone the neighbor
                    clones[neighbor] = new Node(neighbor->val);
                    q.push(neighbor);
                }
                // Add the cloned neighbor to the current cloned node's neighbors
                clones[curr]->neighbors.push_back(clones[neighbor]);
            }
        }
        
        return clones[node];
    }
};
```

### 7. Path Existence
**Problem**: Given a directed graph and two vertices (source and destination), check if there is a path from source to destination.

**Solution**:
```cpp
bool findPath(int src, int dest, vector<int> adj[], vector<bool>& visited) {
    if (src == dest) return true;
    
    visited[src] = true;
    
    for (int neighbor : adj[src]) {
        if (!visited[neighbor]) {
            if (findPath(neighbor, dest, adj, visited))
                return true;
        }
    }
    
    return false;
}

bool isPath(int src, int dest, vector<int> adj[], int V) {
    vector<bool> visited(V, false);
    return findPath(src, dest, adj, visited);
}
```

### 8. Topological Sort (Kahn's Algorithm)
**Problem**: Given a DAG (Directed Acyclic Graph), find a topological sorting of the graph.

**Solution**:
```cpp
vector<int> topologicalSort(int V, vector<int> adj[]) {
    vector<int> inDegree(V, 0);
    vector<int> result;
    
    // Calculate in-degree of all vertices
    for (int u = 0; u < V; u++) {
        for (int v : adj[u]) {
            inDegree[v]++;
        }
    }
    
    // Enqueue all vertices with in-degree 0
    queue<int> q;
    for (int i = 0; i < V; i++) {
        if (inDegree[i] == 0) {
            q.push(i);
        }
    }
    
    // Process vertices in topological order
    while (!q.empty()) {
        int u = q.front();
        q.pop();
        result.push_back(u);
        
        // Decrease in-degree of adjacent vertices
        for (int v : adj[u]) {
            if (int v : adj[u]) {
            if (--in][v] ==-- == {
                q.push(v
}) {
            if (--inDegree[v];
            if (inDegree[v] == 0) {
                q.push(v);
            }
        }
    }
    
    // Check if topological sort is possible (no cycle)
    if (result.size() != V) {
        return {}; // Graph has a cycle
    }
    
    return result;
}
```

### 9. Shortest Path in Binary Matrix
**Problem**: Given an n x n binary matrix grid, return the length of the shortest clear path in the matrix. If there is no clear path, return -1.

**Solution**:
```cpp
int shortestPathBinaryMatrix(vector<vector<int>>& grid) {
    int n = grid.size();
    if (grid[0][0] == 1 || grid[n-1][n-1] == 1) return -1;
    
    vector<vector<int>> directions = {
        {-1, -1}, {-1, 0}, {-1, 1},
        {0, -1},           {0, 1},
        {1, -1},  {1, 0},  {1, 1}
    };
    
    queue<pair<int, int>> q;
    vector<vector<bool>> visited(n, vector<bool>(n, false));
    
    q.push({0, 0});
    visited[0][0] = true;
    int steps = 1;
    
    while (!q.empty()) {
        int size = q.size();
        for (int i = 0; i < size; i++) {
            auto [row, col] = q.front();
            q.pop();
            
            if (row == n-1 && col == n-1) {
                return steps;
            }
            
            for (auto& dir : directions) {
                int newRow = row + dir[0];
                int newCol = col + dir[1];
                
                if (newRow >= 0 && newRow < n && newCol >= 0 && newCol < n && 
                    grid[newRow][newCol] == 0 && !visited[newRow][newCol]) {
                    visited[newRow][newCol] = true;
                    q.push({newRow, newCol});
                }
            }
        }
        steps++;
    }
    
    return -1;
}
```

## Medium Problems

### 10. Number of Islands
**Problem**: Given an m x n 2D binary grid which represents a map of '1's (land) and '0's (water), return the number of islands.

**Solution**:
```cpp
void dfs(int row, int col, vector<vector<char>>& grid, vector<vector<bool>>& visited) {
    int rows = grid.size();
    int cols = grid[0].size();
    
    if (row < 0 || row >= rows || col < 0 || col >= cols || 
        grid[row][col] == '0' || visited[row][col]) {
        return;
    }
    
    visited[row][col] = true;
    
    // Explore neighbors (up, down, left, right)
    dfs(row-1, col, grid, visited);
    dfs(row+1, col, grid, visited);
    dfs(row, col-1, grid, visited);
    dfs(row, col+1, grid, visited);
}

int numIslands(vector<vector<char>>& grid) {
    if (grid.empty() || grid[0].empty()) return 0;
    
    int rows = grid.size();
    int cols = grid[0].size();
    vector<vector<bool>> visited(rows, vector<bool>(cols, false));
    int count = 0;
    
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            if (grid[i][j] == '1' && !visited[i][j]) {
                dfs(i, j, grid, visited);
                count++;
            }
        }
    }
    
    return count;
}
```

### 11. Surrounded Regions
**Problem**: Given an m x n matrix board containing 'X' and 'O', capture all regions that are 4-directionally surrounded by 'X'.

**Solution**:
```cpp
void dfs(int row, int col, vector<vector<char>>& board) {
    int rows = board.size();
    int cols = board[0].size();
    
    if (row < 0 || row >= rows || col < 0 || col >= cols || board[row][col] != 'O') {
        return;
    }
    
    board[row][col] = '#'; // Mark as temporary
    
    // Explore neighbors
    dfs(row-1, col, board);
    dfs(row+1, col, board);
    dfs(row, col-1, board);
    dfs(row, col+1, board);
}

void solve(vector<vector<char>>& board) {
    if (board.empty() || board[0].empty()) return;
    
    int rows = board.size();
    int cols = board[0].size();
    
    // Step 1: Mark all 'O's connected to border as temporary '#'
    // Top and bottom rows
    for (int j = 0; j < cols; j++) {
        if (board[0][j] == 'O') dfs(0, j, board);
        if (board[rows-1][j] == 'O') dfs(rows-1, j, board);
    }
    
    // Left and right columns
    for (int i = 0; i < rows; i++) {
        if (board[i][0] == 'O') dfs(i, 0, board);
        if (board[i][cols-1] == 'O') dfs(i, cols-1, board);
    }
    
    // Step 2: Flip remaining 'O's to 'X' and restore '#' to 'O'
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            if (board[i][j] == 'O') {
                board[i][j] = 'X';
            } else if (board[i][j] == '#') {
                board[i][j] = 'O';
            }
        }
    }
}
```

### 12. Pacific Atlantic Water Flow
**Problem**: Given an m x n matrix of non-negative integers representing the height of each unit cell in a continent, the "Pacific ocean" touches the left and top edges of the matrix and the "Atlantic ocean" touches the right and bottom edges. Water can flow in four directions (up, down, left, right) from a cell to another one with height equal or lower. Find the list of grid coordinates where water can flow to both the Pacific and Atlantic ocean.

**Solution**:
```cpp
void dfs(int row, int col, vector<vector<int>>& heights, vector<vector<bool>>& ocean) {
    int rows = height
    int cols = height[0].size();
    
    if (row < 0 || row >= rows || col < 0 || col >= cols || ocean[row][col]) {
        return;
    }
    
    ocean[row][col] = true;
    
    // Explore neighbors with height >= current (water can flow from neighbor to current)
    vector<pair<int, int>> directions = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};
    for (auto [dr, dc] : directions) {
        int newRow = row + dr;
        int newCol = col + dc;
        if (newRow >= 0 && newRow < rows && newCol >= 0 && newCol < cols && 
            heights[newRow][newCol] >= heights[row][col]) {
            dfs(newRow, newCol, heights, ocean);
        }
    }
}

vector<vector<int>> pacificAtlantic(vector<vector<int>>& heights) {
    if (heights.empty() || heights[0].empty()) return {};
    
    int rows = heights.size();
    int cols = heights[0].size();
    
    // Pacific and Atlantic reachability matrices
    vector<vector<bool>> pacific(rows, vector<bool>(cols, false));
    vector<vector<bool>> atlantic(rows, vector<bool>(cols, false));
    
    // Start DFS from Pacific borders (top and left)
    for (int i = 0; i < rows; i++) {
        dfs(i, 0, heights, pacific); // Left column
    }
    for (int j = 0; j < cols; j++) {
        dfs(0, j, heights, pacific); // Top row
    }
    
    // Start DFS from Atlantic borders (bottom and right)
    for (int i = 0; i < rows; i++) {
        dfs(i, cols-1, heights, atlantic); // Right column
    }
    for (int j = 0; j < cols; j++) {
        dfs(rows-1, j, heights, atlantic); // Bottom row
    }
    
    // Find intersection of both oceans
    vector<vector<int>> result;
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            if (pacific[i][j] && atlantic[i][j]) {
                result.push_back({i, j});
            }
        }
    }
    
    return result;
}
```

### 13. Course Schedule
**Problem**: There are a total of numCourses courses you have to take, labeled from 0 to numCourses-1. You are given an array prerequisites where prerequisites[i] = [ai, bi] indicates that you must take course bi first if you want to take course ai. Return true if you can finish all courses. Otherwise, return false.

**Solution** (Topological Sort - Kahn's Algorithm):
```cpp
bool canFinish(int numCourses, vector<vector<int>>& prerequisites) {
    // Build adjacency list and in-degree array
    vector<vector<int>> adj(numCourses);
    vector<int> inDegree(numCourses, 0);
    
    for (auto& prereq : prerequisites) {
        int course = prereq[0];
        int prereqCourse = prereq[1];
        adj[prereqCourse].push_back(course);
        inDegree[course]++;
    }
    
    // Queue for nodes with in-degree 0
    queue<int> q;
    for (int i = 0; i < numCourses; i++) {
        if (inDegree[i] == 0) {
            q.push(i);
        }
    }
    
    int completedCourses = 0;
    while (!q.empty()) {
        int course = q.front();
        q.pop();
        completedCourses++;
        
        for (int nextCourse : adj[course]) {
            inDegree[nextCourse]--;
            if (inDegree[nextCourse] == 0) {
                q.push(nextCourse);
            }
        }
    }
    
    return completedCourses == numCourses;
}
```

### 14. Course Schedule II
**Problem**: Similar to Course Schedule but return the ordering of courses you should take to finish all courses. If impossible, return an empty array.

**Solution**:
```cpp
vector<int> findOrder(int numCourses, vector<vector<int>>& prerequisites) {
    // Build adjacency list and in-degree array
    vector<vector<int>> adj(numCourses);
    vector<int> inDegree(numCourses, 0);
    vector<int> result;
    
    for (auto& req : prerequisites) {
        int course = req[0];
        int prereq = req[1];
        adj[prereq].push_back(course);
        inDegree[course]++;
    }
    
    // Queue for courses with no prerequisites
    queue<int> q;
    for (int i = 0; i < numCourse; i++) {
        if (inDegree[i] == 0) {
            q.push(i);
        }
    }
    
    while (!q.empty()) {
        int course = q.front();
        q.pop();
        result.push_back(course);
        
        for (int nextCourse : adj[course]) {
            inDegree[nextCourse]--;
            if (inDegree[nextCourse] == 0) {
                q.push(nextCourse);
            }
        }
    }
    
    if (result.size() == numCourses) {
        return result;
    } else {
        return {}; // Impossible to finish all courses
    }
}
```

### 15. Graph Valid Tree
**Problem**: Given n nodes labeled from 0 to n-1 and a list of undirected edges (each edge is a pair of nodes), write a function to check whether these edges make up a valid tree.

**Solution**:
```cpp
bool validTree(int n, vector<vector<int>>& edges) {
    // A tree with n nodes must have exactly n-1 edges
    if (edges.size() != n - 1) return false;
    
    // Build adjacency list
    vector<vector<int>> adj(n);
    for (auto& edge : edges) {
        adj[edge[0]].push_back(edge[1]);
        adj[edge[1]].push_back(edge[0]);
    }
    
    // Check if graph is connected using BFS/DFS
    vector<bool> visited(n, false);
    queue<int> q;
    q.push(0);
    visited[0] = true;
    int visitedCount = 1;
    
    while (!q.empty()) {
        int node = q.front();
        q.pop();
        
        for (int neighbor : adj[node]) {
            if (!visited[neighbor]) {
                visited[neighbor] = true;
                visitedCount++;
                q.push(neighbor);
            }
        }
    }
    
    return visitedCount == n;
}
```

### 16. Redundant Connection
**Problem**: In this problem, a tree is an undirected graph that is connected and has no cycles. You are given a graph that started as a tree with n nodes labeled from 1 to n, with one additional edge added. The added edge has two different vertices chosen from 1 to n, and was not an edge that already existed in the tree. The graph is given as an array edges of length n where edges[i] = [ai, bi] indicates that there is an edge between nodes ai and bi in the graph. Return an edge that can be removed so that the resulting graph is a tree of n nodes. If there are multiple answers, return the answer that occurs last in the input.

**Solution** (Union-Find):
```cpp
class DSU {
public:
    vector<int> parent;
    vector<int> rank;
    
    DSU(int n) {
        parent.resize(n+1);
        rank.resize(n+1, 0);
        for (int i = 1; i <= n; i++) {
            parent[i] = i;
        }
    }
    
    int find(int x) {
        if (parent[x] != x) {
            parent[x] = find(parent[x]);
        }
        return parent[x];
    }
    
    bool unite(int x, int y) {
        int rootX = find(x);
        int rootY = find(y);
        
        if (rootX == rootY) {
            return false; // Already connected, adding this edge would create a cycle
        }
        
        // Union by rank
        if (rank[rootX] < rank[rootY]) {
            parent[rootX] = rootY;
        } else if (rank[rootX] > rank[rootY]) {
            parent[rootY] = rootX;
        } else {
            parent[rootY] = rootX;
            rank[rootX]++;
        }
        return true;
    }
};

vector<int> findRedundantConnection(vector<vector<int>>& edges) {
    int n = edges.size();
    DSU dsu(n);
    
    for (auto& edge : edges) {
        if (!dsu.unite(edge[0], edge[1])) {
            return edge; // This edge creates a cycle
        }
    }
    
    return {}; // Should never reach here
}
```

### 17. Number of Connected Components in an Undirected Graph
**Problem**: Given n nodes labeled from 0 to n-1 and a list of undirected edges, write a function to find the number of connected components in an undirected graph.

**Solution** (DFS):
```cpp
void dfs(int node, vector<vector<int>>& adj, vector<bool>& visited) {
    visited[node] = true;
    for (int neighbor : adj[node]) {
        if (!visited[neighbor]) {
            dfs(neighbor, adj, visited);
        }
    }
}

int countComponents(int n, vector<vector<int>>& edges) {
    // Build adjacency list
    vector<vector<int>> adj(n);
    for (auto& edge : edges) {
        adj[edge[0]].push_back(edge[1]);
        ndex[edge[1]].push_back(edge[0]);
    }
    
    vector<bool> visited(n, false);
    int count = 0;
    
    for (int i = 0; i < n; i++) {
        if (!visited[i]) {
            dfs(i, adj, visited);
            count++;
        }
    }
    
    return count;
}
```

**Solution** (Union-Find):
```cpp
class DSU {
public:
    vector<int> parent;
    vector<int> rank;
    
    DSU(int n) {
        parent.resize(n);
        rank.resize(n, 0);
        for (int i = 0; i < n; i++) {
            parent[i] = i;
        }
    }
    
    int find(int x) {
        if (parent[x] != x) {
            parent[x] = find(parent[x]);
        }
        return parent[x];
    }
    
    void unite(int x, int y) {
        int rootX = find(x);
        int rootY = find(y);
        
        if (um_root_!X == rootY return;
        // Union  rank
        if (rank[rootX] < rank[rootY]) {
            parent[rootX] = rootY;
        } else if (rank[rootX] > rank[rootY]) {
            parent[rootY] = rootX;
        } else {
            parent[rootY] = rootX;
            rank[rootX]++;
        }
    }
};

int countComponents(int n, vector<vector<int>>& edges) {
    DSU dsu(n);
    
    // Initially, each node is its own component
    int components = n;
    
    for (auto& edge : edges) {
        int rootU = dsu.find(edge[0]);
        int rootV = dsu.find(edge[1]);
        
        if (rootU != rootV) {
            dsu.unite(rootU, rootV);
            components--; // Two components merged
        }
    }
    
    return components;
}
```

### 18. Word Ladder
**Problem**: Given two words (beginWord and endWord), and a dictionary's word list, find the length of the shortest transformation sequence from beginWord to endWord, such that:
1. Only one letter can be changed at a time.
2. Each transformed word must exist in the word list.

**Solution** (BFS):
```cpp
int ladderLength(string beginWord, string endWord, vector<string>& wordList) {
    unordered_set<string> wordSet(wordList.begin(), wordList.end());
    if (wordSet.find(endWord) == wordSet.end()) return 0;
    
    queue<pair<string, int>> q;
    q.push({beginWord, 1});
    unordered_set<string> visited;
    visited.insert(beginWord);
    
    while (!q.empty()) {
        auto [word, steps] = q.front();
        q.pop();
        
        if (word == endWord) {
            return steps;
        }
        
        // Try changing each character
        for (int i = 0; i < word.size(); i++) {
            char original = word[i];
            for (char c = 'a'; c <= 'z'; c++) {
                if (c == original) continue;
                
                word[i] = c;
                if (wordSet.find(word) != wordSet.end() && visited.find(word) == visited.end()) {
                    visited.insert(word);
                    q.push({word, steps + 1});
                }
            }
            word[i] = original; // Restore original character
        }
    }
    
    return 0; // No transformation sequence found
}
```

## Hard Problems

### 19. Minimum Height Trees
**Problem**: For an undirected graph with tree characteristics, we can choose any node as the root. The result graph is then a rooted tree. Among all possible rooted trees, those with minimum height (i.e. min(minDepth)) are called minimum height trees (MHTs). Given such a graph, write a function to find all the MHTs and return a list of their root labels.

**Solution** (Topological Sort - Trimming Leaves):
```cpp
vector<int> findMinHeightTrees(int n, vector<vector<int>>& edges) {
    if (n == 1) return {0};
    
    // Build adjacency list and degree array
    vector<vector<int>> adj(n);
    vector<int> degree(n, 0);
    
    for (auto& edge : edges) {
        int u = edge[0];
        int v = edge[1];
        adj[u].push_back(v);
        a=dj[v].push_back(u);
        degree[u]++;
        degree[v]++;
    }
    
    // Initialize leaves (nodes with degree 1)
    queue<int> leaves;
    for (int i = 0; i < n; i++) {
        if (degree[i] == 1) {
            leaves.push(i);
        }
    }
    
    // Trim leaves until reaching the centroids
    int remainingNodes = n;
    while (remainingNodes > 2) {
        int leavesCount = leaves.size();
        remainingNodes -= leavesCount;
        
        for (int i = 0; i < leavesCount; i++) {
            int leaf = leaves.front();
            leaves.pop();
            
            // Remove this leaf from the tree
            for (int neighbor : adj[leaf]) {
                degree[neighbor]--;
                if (degree[neighbor] == 1) {
                    leaves.push(neighbor);
                }
            }
        }
    }
    
    // Remaining nodes are the centroids (MHT roots)
    vector<int> result;
    while (!leaves.empty()) {
        result.push_back(leaves.front());
        leaves.pop();
    }
    
    return result;
}
```

### 20. Evaluate Division
**Problem**: Equations are given in the format A / B = k, where A and B are variables represented as strings, and k is a real number (floating point number). Given some queries, return the answers. If the answer does not exist, return -1.0.

**Solution** (Graph + DFS):
```cpp
double dfs(string& start, string& end, unordered_map<string, vector<pair<string, double>>>& graph, 
           unordered_set<string>& visited) {
    if (graph.find(start) == graph.end() || graph.find(end) == graph.end()) {
        return -1.0;
    }
    
    if (start == end) {
        return 1.0;
    }
    
    visited.insert(start);
    
    for (auto [neighbor, value] : graph[start]) {
        if (visited.find(neighbor) == visited.end()) {
            double temp = dfs(neighbor, end, graph, visited);
            if (temp != -1.0) {
                return temp * value;
            }
        }
    }
    
    return -1.0;
}

vector<double> calcEquation(vector<vector<string>>& equations, vector<double>& values, 
                           vector<vector<string>>& queries) {
    // Build graph
    unordered_map<string, vector<pair<string, double>>> graph;
    
    for (int i = 0; i < equations.size(); i++) {
        string& a = equations[i][0];
        string& b = equations[i][1];
        double value = values[i];
        
        graph[a].push_back({b, value});
        graph[b].push_back({a, 1.0 / value});
    }
    
    vector<double> results;
    for (auto& query : queries) {
        string& start = query[0];
        string& end = query[1];
        unordered_set<string> visited;
        double result = dfs(start, end, graph, visited);
        results.push_back(result);
    }
    
    return results;
}
```

### 21. Swim in Rising Water
**Problem**: On an N x N grid, each square grid[i][j] represents the elevation at that point (i,j). Now rain starts to fall. At time t, the depth of the water everywhere is t. You can swim from a square to another 4-directionally adjacent square if and only if the elevation of both squares individually are at most t. You can swim infinite distance in zero time. Of course, you must stay within the boundaries of the grid during your swim. You start at the top left square (0, 0). What is the least time until you can reach the bottom right square (N-1, N-1)?

**Solution** (Dijkstra's Algorithm):
```cpp
int swimInWater(vector<vector<int>>& grid) {
    int n = grid.size();
    if (n == 0) return 0;
    
    // Directions: up, right, down, left
    vector<pair<int, int>> directions = {{-1, 0}, {0, 1}, {1, 0}, {0, -1}};
    
    // Min-heap: {time, row, col}
    priority_queue<tuple<int, int, int>, vector<tuple<int, int, int>>, greater<tuple<int, int, int>>> pq;
    vector<vector<bool>> visited(n, vector<bool>(n, false));
    
    // Start from top-left corner
    pq.push({grid[0][0], 0, 0});
    visited[0][0] = true;
    
    while (!pq.empty()) {
        auto [time, row, col] = pq.top();
        pq.pop();
        
        // If we reached bottom-right corner
        if (row == n-1 && col == n-1) {
            return time;
        }
        
        // Explore neighbors
        for (auto [dr, dc] : directions) {
            int newRow = row + dr;
            int newCol = col + dc;
            
            if (newRow >= 0 && newRow < n && newCol >= 0 && newCol < n && !visited[newRow][newCol]) {
                visited[newRow][newCol] = true;
                // The time needed is the max of current time and neighbor's elevation
                pq.push({max(time, grid[newRow][newCol]), newRow, newCol});
            }
        }
    }
    
    return -1; // Should never reach here for valid input
}
```

### 22. Path With Maximum Minimum Value
**Problem**: Given an matrix of integers A with R rows and C columns, find the maximum score of a path starting at [0,0] and ending at [R-1, C-1]. The score of a path is the minimum value in that path.

**Solution** (Modified Dijkstra's / Union-Find):
```cpp
int maximumMinimumPath(vector<vector<int>>& A) {
    int rows = A.size();
    if (rows == 0) return 0;
    int cols = A[0].size();
    
    // Max-heap: {value, row, col}
    priority_queue<tuple<int, int, int>> pq;
    vector<vector<bool>> visited(rows, vector<bool>(bool, false));
    
    // Directions: up, right, down, left
    vector<pair<int, int>> dirs = {{-1, 0}, {0, 1}, {1, 0}, {0, -1}};
    
    // Start from top-left
    pq.push({A[0][0], 0, 0});
    visited[0][0] = true;
    
    while (!pq.empty()) {
        auto [val, row, col] = pq.top();
        pq.pop();
        
        // If we reached bottom-right
        if (row == rows-1 && col == cols-1) {
            return valu
        }
        
        // Explore neighbors
        for (auto [dr, dc] : dirs) {
            int newRow = row + dr;
            int newCol = col + dc;
            
            if (newRow >= 0 && newRow < n && newCol >= 0 && newCol < n && !visited[newRow][newCol]) {
                visited[newRow][newCol] = true;
                // The path value is min of current path value and neighbor's value
                pq.push({min(val, grid[newRow][newCol]), newRow, newCol});
            }
        }
    }
    
    return -1; // Should never reach here
}
```

**Alternative Union-Find Solution** (more efficient):
```cpp
int maximumMinimumPath(vector<vector<int>>& A) {
    int rows = A.size();
    int cols = A[0].size();
    
    // Create list of cells with their values
    vector<tuple<int, int, int>> cells;
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            cells.push_back({A[i][j], i, j});
        }
    }
    
    // Sort cells by value in descending order
    sort(cells.rbegin(), cells.rend());
    
    // Union-Find data structure
    vector<int> parent(rows * cols);
    vector<bool> added(rows * cols, false);
    
    for (int i = 0; i < rows * cols; i++) {
        parent[i] = i;
    }
    
    auto find = [&](int x) {
        while (parent[x] != x) {
            parent[x] = parent[parent[x]];
            x = parent[x];
        }
        return x;
    };
    
    auto unite = [&](int x, int y) {
        int rootX = find(x);
        int rootY = find(y);
        if (rootX != rootY) {
            parent[rootY] = rootX;
        }
    };
    
    // Directions: up, right, down, left
    vector<pair<int, int>> dirs = {{-1, 0}, {0, 1}, {1, 0}, {0, -1}};
    
    // Process cells from highest to lowest value
    for (auto [value, row, col] : cells) {
        int index = row * cols + col;
        added[index] = true;
        
        // Connect with neighbors that have already been added
        for (auto [dr, dc] : dirs) {
            int newRow = row + dr;
            int newCol = col + dc;
            int neighborIndex = newRow * cols + newCol;
            
            if (newRow >= 0 && newRow < rows && newCol >= 0 && newCol < cols && 
                added[neighborIndex]) {
                unite(index, dst = false;
            }
        }
        
        // Check if start (0,0) and end (rows-1, cols-1) are connected
        int startIndex = 0;
        int endIndex = (rows-1) * cols + (cols-1);
        if (find(startIndex) == find(endIndex)) {
            return value;
        }
    }
    
    return -1; // Should never reach here
}
```

## Summary

This collection covers graph algorithm problems from easy to hard difficulty levels. Key insights include:

1. **Graph Representation**: Understanding adjacency lists vs. matrices, and when to use each
2. **Traversal Techniques**: Mastering BFS and DFS for various graph problems
3. **Specialized Algorithms**: Knowing when to apply topological sort, union-find, Dijkstra's, etc.
4. **Problem Reduction**: Recognizing how to model real-world problems as graph problems
5. **Optimization Techniques**: Using appropriate data structures (queues, stacks, heaps, union-find) for efficiency
6. **Edge Cases**: Handling disconnected graphs, cycles, directed vs. undirected graphs
7. **Real-world Applications**: Social networks, routing, scheduling, resource allocation, etc.

Practice these problems to develop strong graph algorithm skills, which are essential for solving complex problems in computer science and software engineering.