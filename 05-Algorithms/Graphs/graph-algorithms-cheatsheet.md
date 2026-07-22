# Graph Algorithms Cheat Sheet

## Fundamental Concepts

### Definition
A graph G = (V, E) consists of a set of vertices V and a set of edges E connecting pairs of vertices.

### Graph Types
- **Undirected**: Edges have no direction
- **Directed (Digraph)**: Edges have direction
- **Weighted**: Edges have associated weights/costs
- **Unweighted**: All edges have equal weight (typically 1)
- **Cyclic**: Contains at least one cycle
- **Acyclic**: No cycles (DAG = Directed Acyclic Graph)
- **Connected**: Path exists between every pair of vertices
- **Disconnected**: At least two vertices with no path between them
- **Tree**: Connected acyclic undirected graph
- **Forest**: Collection of trees

### Graph Representation

#### 1. Adjacency Matrix
- **Structure**: V x V matrix where M[i][j] = 1 if edge (i,j) exists
- **Space**: O(V²)
- **Edge lookup**: O(1)
- **Iterating neighbors**: O(V)
- **Best for**: Dense graphs, frequent edge lookups

#### 2. Adjacency List
- **Structure**: Array of lists, where list[i] contains neighbors of vertex i
- **Space**: O(V + E)
- **Edge lookup**: O(degree(v))
- **Iterating neighbors**: O(degree(v))
- **Best for**: Sparse graphs, iterating neighbors

#### 3. Edge List
- **Structure**: List of all edges (u, v, weight)
- **Space**: O(E)
- **Best for**: Algorithms that process all edges (Kruskal's, Bellman-Ford)

## Essential Graph Algorithms

### 1. Breadth-First Search (BFS)
```cpp
vector<int> bfs(int start, vector<int> adj[], int V) {
    vector<bool> visited(V, false);
    vector<int> result;
    queue<int> q;
    
    visited[start] = true;
    q.push(start);
    
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
- Time: O(V + E)
- Space: O(V)
- Uses: Shortest path in unweighted graphs, level-order traversal, connected components
- Queue-based, explores neighbors level by level

### 2. Depth-First Search (DFS)
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

vector<int> dfs(int start, vector<int> adj[], int V) {
    vector<bool> visited(V, false);
    vector<int> result;
    dfsHelper(start, adj, visited, result);
    return result;
}
```
- Time: O(V + E)
- Space: O(V) (recursion stack)
- Uses: Path finding, cycle detection, topological sort, connected components
- Stack-based (explicit or implicit), explores as deep as possible

### 3. Dijkstra's Algorithm (Shortest Path with Non-negative Weights)
```cpp
vector<int> dijkstra(int start, vector<vector<pair<int, int>>> adj, int V) {
    vector<int> dist(V, INT_MAX);
    vector<bool> visited(V, false);
    priority_queue<pair<int, int>, vector<pair<int, int>>, greater<pair<int, int>>> pq;
    
    dist[start] = 0;
    pq.push({0, start});
    
    while (!pq.empty()) {
        int u = pq.top().second;
        pq.pop();
        
        if (visited[u]) continue;
        visited[u] = true;
        
        for (auto [v, weight] : adj[u]) {
            if (!visited[v] && dist[u] + weight < dist[v]) {
                dist[v] = dist[u] + weight;
                pq.push({dist[v], v});
            }
        }
    }
    
    return dist;
}
```
- Time: O((V + E) log V) with binary heap
- Space: O(V)
- Uses: Shortest path with non-negative weights
- Greedy algorithm using min-heap

### 4. Bellman-Ford Algorithm (Shortest Path with Negative Weights)
```cpp
vector<int> bellmanFord(int start, vector<tuple<int, int, int>> edges, int V, int E) {
    vector<int> dist(V, INT_MAX);
    dist[start] = 0;
    
    // Relax all edges V-1 times
    for (int i = 0; i < V - 1; i++) {
        for (auto [u, v, w] : edges) {
            if (dist[u] != INT_MAX && dist[u] + w < dist[v]) {
                dist[v] = dist[u] + w;
            }
        }
    }
    
    // Check for negative-weight cycles
    for (auto [u, v, w] : edges) {
        if (dist[u] != INT_MAX && dist[u] + w < dist[v]) {
            // Negative weight cycle detected
            return vector<int>(V, -1); // Indicate negative cycle
        }
    }
    
    return dist;
}
```
- Time: O(V * E)
- Space: O(V)
- Uses: Shortest path with negative weights, detecting negative cycles
- Dynamic programming approach

### 5. Floyd-Warshall Algorithm (All-Pairs Shortest Path)
```cpp
vector<vector<int>> floydWarshall(vector<vector<int>> graph, int V) {
    vector<vector<int>> dist = graph;
    
    // Initialize diagonal to 0
    for (int i = 0; i < V; i++) {
        dist[i][i] = 0;
    }
    
    // Consider each vertex as intermediate
    for (int k = 0; k < V; k++) {
        for (int i = 0; i < V; i++) {
            for (int j = 0; j < V; j++) {
                if (dist[i][k] != INT_MAX && dist[k][j] != INT_MAX && 
                    dist[i][k] + dist[k][j] < dist[i][j]) {
                    dist[i][j] = dist[i][k] + dist[k][j];
                }
            }
        }
    }
    
    return dist;
}
```
- Time: O(V³)
- Space: O(V²)
- Uses: All-pairs shortest path, transitive closure
- Dynamic programming with three nested loops

### 6. Topological Sort (Kahn's Algorithm)
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
            if (--inDegree[v] == 0) {
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
- Time: O(V + E)
- Space: O(V)
- Uses: Task scheduling, dependency resolution
- Only works on DAGs (Directed Acyclic Graphs)

### 7. Topological Sort (DFS-based)
```cpp
void dfsTopo(int node, vector<int> adj[], vector<bool>& visited, 
             vector<bool>& recStack, stack<int>& st) {
    visited[node] = true;
    recStack[node] = true;
    
    for (int neighbor : adj[node]) {
        if (!visited[neighbor]) {
            dfsTopo(neighbor, adj, visited, recStack, st);
        } else if (recStack[neighbor]) {
            // Cycle detected
            throw runtime_error("Graph contains a cycle");
        }
    }
    
    recStack[node] = false;
    st.push(node);
}

vector<int> topologicalSortDFS(int V, vector<int> adj[]) {
    vector<bool> visited(V, false);
    vector<bool> recStack(V, false);
    stack<int> st;
    
    for (int i = 0; i < V; i++) {
        if (!visited[i]) {
            dfsTopo(i, adj, visited, recStack, st);
        }
    }
    
    vector<int> result;
    while (!st.empty()) {
        result.push_back(st.top());
        st.pop();
    }
    
    return result;
}
```
- Time: O(V + E)
- Space: O(V)
- Uses: Alternative topological sort implementation
- Detects cycles during traversal

### 8. Union-Find (Disjoint Set Union - DSU)
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
            parent[x] = find(parent[x]); // Path compression
        }
        return parent[x];
    }
    
    void unite(int x, int y) {
        int rootX = find(x);
        int rootY = find(y);
        
        if (rootX == rootY) return;
        
        // Union by rank
        if (rank[rootX] < rank[rootY]) {
            parent[rootX] = rootY;
        } else if (rank[rootX] > rank[rootY]) {
            parent[rootY] = rootX;
        } else {
            parent[rootY] = rootX;
            rank[rootX]++;
        }
    }
    
    bool connected(int x, int y) {
        return find(x) == find(y);
    }
};
```
- Time: Nearly O(1) per operation (with path compression and union by rank)
- Space: O(n)
- Uses: Connected components, cycle detection, MST (Kruskal's), dynamic connectivity
- Essentially O(1) amortized time per operation

### 9. Kruskal's Algorithm (Minimum Spanning Tree)
```cpp
struct Edge {
    int u, v, weight;
    bool operator<(const Edge& other) const {
        return weight < other.weight;
    }
};

vector<Edge> kruskalMST(vector<Edge> edges, int V) {
    // Sort edges by weight
    sort(edges.begin(), edges.end());
    
    DSU dsu(V);
    vector<Edge> mst;
    
    for (Edge edge : edges) {
        // If adding this edge doesn't create a cycle
        if (dsu.connected(edge.u, edge.v)) {
            continue;
        }
        
        // Add edge to MST
        mst.push_back(edge);
        dsu.unite(edge.u, edge.v);
        
        // MST has V-1 edges, we can stop early
        if (mst.size() == V - 1) break;
    }
    
    return mst;
}
```
- Time: O(E log E) = O(E log V)
- Space: O(V)
- Uses: Finding minimum spanning tree
- Greedy algorithm using union-find

### 10. Prim's Algorithm (Minimum Spanning Tree)
```cpp
vector<int> primMST(vector<vector<pair<int, int>>> adj, int V) {
    vector<int> key(V, INT_MAX); // Minimum weight to connect to MST
    vector<bool> inMST(V, false); // Whether vertex is in MST
    vector<int> parent(V, -1); // Parent of each vertex in MST
    
    // Start from vertex 0
    key[0] = 0;
    priority_queue<pair<int, int>, vector<pair<int, int>>, greater<pair<int, int>>> pq;
    pq.push({0, 0}); // {key, vertex}
    
    while (!pq.empty()) {
        int u = pq.top().second;
        pq.pop();
        
        if (inMST[u]) continue;
        inMST[u] = true;
        
        // Update key values of adjacent vertices
        for (auto [v, weight] : adj[u]) {
            if (!inMST[v] && weight < key[v]) {
                key[v] = weight;
                parent[v] = u;
                pq.push({weight, v});
            }
        }
    }
    
    // Return parent array representing MST
    return parent;
}
```
- Time: O(E log V) with binary heap
- Space: O(V)
- Uses: Finding minimum spanning tree
- Greedy algorithm using min-heap

### 11. Kosaraju's Algorithm (Strongly Connected Components)
```cpp
void fillOrder(int node, vector<int> adj[], vector<bool>& visited, stack<int>& st) {
    visited[node] = true;
    
    for (int neighbor : adj[node]) {
        if (!visited[neighbor]) {
            fillOrder(neighbor, adj, visited, st);
        }
    }
    
    st.push(node);
}

void dfsReverse(int node, vector<int> adjRev[], vector<bool>& visited, 
                vector<int>& component) {
    visited[node] = true;
    component.push_back(node);
    
    for (int neighbor : adjRev[node]) {
        if (!visited[neighbor]) {
            dfsReverse(neighbor, adjRev, visited, component);
        }
    }
}

vector<vector<int>> kosarajuSCC(int V, vector<int> adj[]) {
    // Step 1: Fill vertices in stack according to finish time
    stack<int> st;
    vector<bool> visited(V, false);
    
    for (int i = 0; i < V; i++) {
        if (!visited[i]) {
            fillOrder(i, adj, visited, st);
        }
    }
    
    // Step 2: Create reversed graph
    vector<int> adjRev[V];
    for (int u = 0; u < V; u++) {
        for (int v : adj[u]) {
            adjRev[v].push_back(u);
        }
    }
    
    // Step 3: Process vertices in order defined by stack
    visited.assign(V, false);
    vector<vector<int>> sccs;
    
    while (!st.empty()) {
        int node = st.top();
        st.pop();
        
        if (!visited[node]) {
            vector<int> component;
            dfsReverse(node, adjRev, visited, component);
            sccs.push_back(component);
        }
    }
    
    return sccs;
}
```
- Time: O(V + E)
- Space: O(V)
- Uses: Finding strongly connected components in directed graphs
- Two-pass DFS algorithm

### 12. Tarjan's Algorithm (Strongly Connected Components)
```cpp
void tarjanSCC(int node, vector<int> adj[], vector<int>& disc, vector<int>& low,
               vector<bool>& inStack, stack<int>& st, vector<vector<int>>& sccs) {
    static int time = 0;
    
    disc[node] = low[node] = ++time;
    st.push(node);
    inSteak[node] = true;
    
    for (int neighbor : adj[node]) {
        if (disc[neighbor] == -1) {
            // Neighbor not visited
            tarjanSCC(neighbor, adj, disc, low, inStack, st, sccs);
            low[node] = min(low[node], low[neighbor]);
        } else if (inStack[neighbor]) {
            // Neighbor in stack, update low value
            low[node] = min(low[node], disc[neighbor]);
        }
    }
    
    // If node is head of SCC, pop stack and generate SCC
    if (low[node] == disc[node]) {
        vector<int> component;
        while (true) {
            int top = st.top();
            st.pop();
            inStack[top] = false;
            component.push_back(top);
            if (top == node) break;
        }
        sccs.push_back(component);
    }
}

vector<vector<int>> tarjanSCC(int V, vector<int> adj[]) {
    vector<int> disc(V, -1);
    vector<int> low(V, -1);
    vector<bool> inStack(V, false);
    stack<int> st;
    vector<vector<int>> sccs;
    
    for (int i = 0; i < V; i++) {
        if (disc[i] == -1) {
            tarjanSCC(i, adj, disc, low, inStack, st, sccs);
        }
    }
    
    return sccs;
}
```
- Time: O(V + E)
- Space: O(V)
- Uses: Finding strongly connected components (single-pass)
- More efficient than Kosaraju's in practice

## Specialized Graph Algorithms

### 1. Minimum Height Trees
```cpp
vector<int> findMinHeightTrees(int n, vector<vector<int>>& edges) {
    if (n <= 2) {
        vector<int> result;
        for (int i = 0; i < n; i++) result.push_back(i);
        return result;
    }
    
    // Build adjacency list and degree array
    vector<vector<int>> adj(n);
    vector<int> degree(n, 0);
    
    for (auto& edge : edges) {
        int u = edge[0];
        int v = edge[1];
        adj[u].push_back(v);
        adj[v].push_back(u);
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
- Time: O(V + E)
- Space: O(V)
- Uses: Finding tree roots that minimize height
- Topological sort approach (trimming leaves)

### 2. Eventual Safe States
```cpp
vector<int> eventualSafeNodes(vector<vector<int>>& graph) {
    int n = graph.size();
    vector<int> color(n, 0); // 0=unvisited, 1=visiting, 2=visited/safe
    vector<int> result;
    
    function<bool(int)> dfs = [&](int node) {
        if (color[node] != 0) {
            return color[node] == 2; // 2=safe, 1=unsafe (cycle)
        }
        
        color[node] = 1; // Mark as visiting
        for (int neighbor : graph[node]) {
            if (!dfs(neighbor)) {
                return false; // Found unsafe node
            }
        }
        
        color[node] = 2; // Mark as safe
        return true;
    };
    
    for (int i = 0; i < n; i++) {
        if (dfs(i)) {
            result.push_back(i);
        }
    }
    
    return result;
}
```
- Time: O(V + E)
- Space: O(V)
- Uses: Finding nodes that eventually lead to terminal states
- Cycle detection with state tracking

## Graph Algorithm Complexity Reference

### Traversal Algorithms
| Algorithm | Time Complexity | Space Complexity | Notes |
|-----------|-----------------|------------------|-------|
| BFS | O(V + E) | O(V) | Queue-based |
| DFS | O(V + E) | O(V) | Stack-based (recursion/explicit) |
| Bidirectional BFS | O(V + E) | O(V) | Two frontiers meet in middle |
| 0-1 BFS | O(V + E) | O(V) | Edge weights are 0 or 1 |

### Shortest Path Algorithms
| Algorithm | Time Complexity | Space Complexity | Notes |
|-----------|-----------------|------------------|-------|
| Dijkstra (binary heap) | O((V + E) log V) | O(V) | Non-negative weights |
| Dijkstra (Fibonacci heap) | O(E + V log V) | O(V) | Theoretical improvement |
| Bellman-Ford | O(V * E) | O(V) | Handles negative weights |
| Floyd-Warshall | O(V³) | O(V²) | All-pairs shortest path |
| Johnson's | O(V² log V + V*E) | O(V²) | Sparse graphs, reweighing |

### Minimum Spanning Tree Algorithms
| Algorithm | Time Complexity | Space Complexity | Notes |
|-----------|-----------------|------------------|-------|
| Kruskal's | O(E log E) | O(V) | Union-find, sparse graphs |
| Prim's (binary heap) | O(E log V) | O(V) | Dense graphs |
| Prim's (Fibonacci heap) | O(E + V log V) | O(V) | Theoretical improvement |
| Prim's (adjacency matrix) | O(V²) | O(V) | Dense graphs |

### Connectivity Algorithms
| Algorithm | Time Complexity | Space Complexity | Notes |
|-----------|-----------------|------------------|-------|
| Connected Components (DFS/BFS) | O(V + E) | O(V) | Undirected graphs |
| Strongly Connected Components (Kosaraju) | O(V + E) | O(V) | Directed graphs |
| Strongly Connected Components (Tarjan) | O(V + E) | O(V) | Directed graphs, single pass |
| Bridge Finding (Tarjan) | O(V + E) | O(V) | Critical edges |
| Articulation Points (Tarjan) | O(V + E) | O(V) | Critical vertices |

### Topological Sorting
| Algorithm | Time Complexity | Space Complexity | Notes |
|-----------|-----------------|------------------|-------|
| Kahn's Algorithm | O(V + E) | O(v) | BFS-based, detects cycles |
| DFS-based | O(V + E) | O(V) | Recursion stack |

### Union-Find (DSU)
| Operation | Time Complexity | Space Complexity | Notes |
|-----------|-----------------|------------------|-------|
| Find (with path compression) | O(α(n)) | O(n) | α = inverse Ackermann (<5) |
| Union (with rank) | O(α(n)) | O(n) | Nearly constant time |
| Connected | O(α(n)) | O(n) | Check if in same set |

## Graph Representation Trade-offs

| Representation | Space | Edge Lookup | Iterate Neighbors | Best For |
|----------------|-------|-------------|-------------------|----------|
| Adjacency Matrix | O(V²) | O(1) | O(V) | Dense graphs, frequent lookups |
| Adjacency List | O(V + E) | O(degree) | O(degree) | Sparse graphs, neighbor iteration |
| Edge List | O(E) | O(E) | O(E) | Algorithms processing all edges |

## When to Use Which Algorithm

### Shortest Path
- **Non-negative weights, single source**: Dijkstra's
- **Negative weights, single source**: Bellman-Ford
- **Non-negative weights, all-pairs**: Floyd-Warshall (dense) or Johnson's (sparse)
- **Unweighted graph**: BFS

### Minimum Spanning Tree
- **Sparse graph**: Kruskal's (better with union-find)
- **Dense graph**: Prim's (especially with adjacency matrix)
- **Need edges sorted**: Kruskal's
- **Need incremental MST**: Prim's

### Cycle Detection
- **Undirected graph**: DFS (check for back edges to parent) or Union-Find
- **Directed graph**: DFS with recursion stack or topological sort
- **Online queries**: Union-Find

### Connectivity
- **Connected components (undirected)**: DFS/BFS or Union-Find
- **Strongly connected components (directed)**: Kosaraju's or Tarjan's
- **Dynamic connectivity**: Union-Find
- **2-edge-connected/2-vertex-connected**: Tarjan's extensions

### Topological Sorting
- **Task scheduling with dependencies**: Kahn's or DFS-based
- **Need to detect cycles**: Both detect cycles
- **Prefer BFS approach**: Kahn's
- **Prefer DFS approach**: DFS-based

### Specialized Problems
- **Minimum height trees**: Leaf trimming (topological sort variant)
- **Eventual safe states**: DFS with state tracking
- **Word ladder**: BFS on implicit graph
- **Network reliability**: Min-cut (Ford-Fulkerson/Edmonds-Karp)
- **Maximum flow**: Ford-Fulkerson, Edmonds-Karp, Dinic's
- **Minimum cut**: Stoer-Wagner (undirected), min-cut/max-flow theorems

## Implementation Tips and Best Practices

### 1. Handling Disconnected Graphs
```cpp
// Always check all vertices for traversal algorithms
vector<int> bfsFull(vector<int> adj[], int V) {
    vector<bool> visited(V, false);
    vector<int> result;
    
    for (int i = 0; i < V; i++) {
        if (!visited[i]) {
            // BFS for this component
            queue<int> q;
            visited[i] = true;
            q.push(i);
            
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
        }
    }
    
    return result;
}
```

### 2. Edge Cases to Consider
- **Empty graph**: V = 0
- **Single vertex**: V = 1, E = 0
- **No edges**: E = 0
- **Complete graph**: E = V*(V-1)/2 (undirected) or V*(V-1) (directed)
- **Self-loops**: Edge from vertex to itself
- **Multiple edges**: More than one edge between same pair
- **Disconnected graph**: Multiple components

### 3. Integer Overflow Prevention
```cpp
// In Dijkstra's, avoid dist[u] + weight overflow
if (dist[u] != INT_MAX && dist[u] + weight < dist[v]) {
    // Safe addition
}

// Use long long for large weights
using WeightType = long long;
```

### 4. Graph Construction Helpers
```cpp
// Convert edge list to adjacency list
vector<vector<int>> buildAdjList(int V, vector<pair<int, int>>& edges) {
    vector<vector<int>> adj(V);
    for (auto [u, v] : edges) {
        adj[u].push_back(v);
        adj[v].push_back(u); // For undirected graphs
    }
    return adj;
}

// Convert adjacency matrix to adjacency list
vector<vector<int>> buildAdjListFromMatrix(vector<vector<int>>& matrix) {
    int V = matrix.size();
    vector<vector<int>> adj(V);
    
    for (int i = 0; i < V; i++) {
        for (int j = 0; j < V; j++) {
            if (matrix[i][j]) {
                adj[i].push_back(j);
            }
        }
    }
    
    return adj;
}
```

### 5. Memory Optimization
```cpp
// Use vectors instead of lists for better cache locality
vector<vector<int>> adj; // Better than list<int>*

// Reserve space when size is known
adj.resize(V);
for (auto& list : adj) {
    list.reserve(expectedDegree);
}

// Use static arrays for small fixed-size graphs
// int adj[MAX_V][MAX_V]; // For V <= known constant
```

### 6. Custom Comparators for Priority Queues
```cpp
// Min-heap for Dijkstra's
auto cmp = [](const pair<int, int>& a, const pair<int, int>& b) {
    return a.first > b.first;
};
priority_queue<pair<int, int>, vector<pair<int, int>>, decltype(cmp)> pq(cmp);

// Max-heap for Prim's variant
priority_queue<pair<int, int>> pq; // Default is max-heap for first element
```

## Real-World Applications

### 1. Computer Networks
- **Routing algorithms**: Dijkstra's (OSPF), Bellman-Ford (RIP)
- **Network reliability**: Min-cut/max-flow
- **Network discovery**: BFS/DFS for topology discovery
- **Load balancing**: Graph partitioning

### 2. Social Networks
- **Friend recommendations**: Mutual friends (triangles in graph)
- **Influence analysis**: PageRank, HITS algorithms
- **Community detection**: Clustering algorithms
- **Information spread**: Modeling diffusion processes

### 3. Web and Internet
- **Web crawling**: BFS for systematic exploration
- **Page ranking**: PageRank algorithm (eigenvector centrality)
- **Social media feeds**: Graph-based relevance scoring
- **Link analysis**: HITS (hubs and authorities)

### 4. Transportation and Logistics
- **Shortest path**: GPS navigation (Dijkstra's, A*)
- **Minimum spanning tree**: Network design (cable, fiber optics)
- **Vehicle routing**: Traveling salesman problem variants
- **Flight scheduling**: Interval scheduling on resource graphs

### 5. Computer Science and Programming
- **Compilers**: Dependency graphs, data flow analysis
- **Operating systems**: Deadlock detection (resource allocation graphs)
- **Database systems**: Query optimization (join graphs)
- **Software engineering**: Call graphs, module dependency graphs

### 6. Scientific Applications
- **Bioinformatics**: Protein-protein interaction networks
- **Chemistry**: Molecular structure analysis
- **Physics**: Feynman diagrams, lattice models
- **Ecology**: Food webs, predator-prey models

### 7. Game Development
- **Pathfinding**: A*, Dijkstra's on navigation meshes
- **AI decision making: influence maps, territory control
- **Networked games**: State synchronization, interest management
- **Procedural generation**: Dungeon generation via cellular automata on graphs

### 8. Recommender Systems
- **Collaborative filtering**: User-item bipartite graphs
- **Content-based filtering**: Feature similarity graphs
- **Hybrid approaches**: Combined graph models
- **Cold start problem**: Graph-based transfer learning

## Summary

Mastering graph algorithms requires understanding both the theoretical foundations and practical implementation considerations. Key principles:

1. **Choose the right representation**: Adjacency list for sparse graphs, matrix for dense graphs
2. **Match algorithm to problem characteristics**: Weighted/unweighted, directed/undirected, cyclic/acyclic
3. **Consider time and space trade-offs**: Especially important for large-scale graphs
4. **Handle edge cases**: Empty graphs, self-loops, multiple edges, disconnected components
5. **Use appropriate data structures**: Queues for BFS, stacks for DFS, heaps for Dijkstra's/Priority-based algorithms
6. **Leverage specialized algorithms**: Union-Find for connectivity, topological sort for DAGs, etc.
7. **Think about real-world constraints**: Memory limitations, disk-based graphs, streaming graphs
8. **Stay current**: New algorithms and optimizations continue to emerge for massive graphs (social web, knowledge graphs)

Whether you're analyzing social networks, designing routing protocols, or optimizing database queries, graph algorithms provide powerful tools for modeling and solving complex relational problems.