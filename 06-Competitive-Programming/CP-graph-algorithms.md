# Competitive Programming Graph Algorithms

## Essential Graph Algorithms for Competitive Programming

This document covers fundamental and advanced graph algorithms that are frequently used in competitive programming problems.

---

## Table of Contents
1. [Graph Representation](#graph-representation)
2. [Basic Traversals](#basic-traversals)
3. [Shortest Path Algorithms](#shortest-path-algorithms)
4. [Minimum Spanning Tree Algorithms](#minimum-spanning-tree-algorithms)
5. [Graph Connectivity](#graph-connectivity)
6. [Topological Sorting](#topological-sorting)
7. [Cycle Detection](#cycle-detection)
8. [Advanced Graph Algorithms](#advanced-graph-algorithms)
9. [Specialized Graph Problems](#specialized-graph-problems)

---

## Graph Representation

### Adjacency List
**Most common representation** for sparse graphs
**Space Complexity**: O(V + E)
**Time Complexity**: 
- Iterate neighbors: O(degree(v))
- Check if edge exists: O(degree(v)) or O(log degree(v)) if sorted
- Add edge: O(1)
- Remove edge: O(degree(v))

```cpp
// Unweighted graph
vector<vector<int>> adj;
adj.resize(n);
adj[u].push_back(v); // Add edge u->v
adj[v].push_back(u); // Add edge v->u (undirected)

// Weighted graph
vector<vector<pair<int, int>>> adj; // (neighbor, weight)
adj.resize(n);
adj[u].push_back({v, w});
adj[v].push_back({u, w}); // Undirected

// For directed graph, only add one direction
```

### Adjacency Matrix
**Suitable for dense graphs** or when we need fast edge lookup
**Space Complexity**: O(V²)
**Time Complexity**:
- Check if edge exists: O(1)
- Iterate neighbors: O(V)
- Add/remove edge: O(1)

```cpp
// Unweighted
vector<vector<bool>> adj(n, vector<bool>(n, false));
adj[u][v] = true;
adj[v][u] = true; // Undirected

// Weighted (use INF for no edge)
vector<vector<int>> adj(n, vector<int>(n, INF));
adj[u][v] = w;
adj[v][u] = w; // Undirected
```

### Edge List
**Simple representation** as list of edges
**Useful for**: Algorithms that process all edges (Kruskal, Bellman-Ford)
**Space Complexity**: O(E)

```cpp
struct Edge {
    int u, v;
    long long w; // Weight (can be omitted for unweighted)
    Edge(int _u, int _v, long long _w) : u(_u), v(_v), w(_w) {}
};

vector<Edge> edges;
edges.push_back(Edge(u, v, w));
```

### Compressed Storage (for competitive programming)
**Common optimization**: Single allocation for edges
```cpp
// For static graphs where we know number of edges in advance
vector<int> head, to, nxt, w;
int ecnt = 0;

void init(int n) {
    head.assign(n + 1, -1);
    to.clear();
    nxt.clear();
    w.clear();
    ecnt = 0;
}

void add_edge(int u, int v, int weight = 0) {
    to.push_back(v);
    nxt.push_back(head[u]);
    if (weight != 0) {
        w.push_back(weight);
    }
    head[u] = ecnt++;
}

// For undirected graph, add both directions
void add_undirected_edge(int u, int v, int weight = 0) {
    add_edge(u, v, weight);
    add_edge(v, u, weight);
}
```

## Basic Traversals

### Depth-First Search (DFS)
**Purpose**: Traverse or search graph in depth-first manner
**Applications**: 
- Connected components
- Path finding
- Cycle detection
- Topological sorting
- Strongly connected components
- Many tree algorithms

**Recursive Implementation**:
```cpp
vector<bool> visited;

void dfs(int v, const vector<vector<int>>& adj) {
    visited[v] = true;
    // Process vertex v (pre-order)
    
    for (int to : adj[v]) {
        if (!visited[to]) {
            dfs(to, adj);
        }
    }
    
    // Process vertex v (post-order)
}
```

**Iterative Implementation** (avoids stack overflow):
```cpp
void dfs_iterative(int start, const vector<vector<int>>& adj) {
    vector<bool> visited(adj.size(), false);
    stack<int> st;
    
    st.push(start);
    visited[start] = true;
    
    while (!st.empty()) {
        int v = st.top();
        st.pop();
        
        // Process vertex v
        
        // Push neighbors in reverse order to maintain same order as recursive
        for (auto it = adj[v].rbegin(); it != adj[v].rend(); ++it) {
            int to = *it;
            if (!visited[to]) {
                visited[to] = true;
                st.push(to);
            }
        }
    }
}
```

**DFS with Timing** (for entry/exit times):
```cpp
int timer = 0;
vector<int> tin, tout;

void dfs_timer(int v, int p, const vector<vector<int>>& adj) {
    tin[v] = timer++;
    for (int to : adj[v]) {
        if (to != p) {
            dfs_timer(to, v, adj);
        }
    }
    tout[v] = timer++;
}
```

### Breadth-First Search (BFS)
**Purpose**: Traverse or search graph in breadth-first manner
**Applications**: 
- Shortest path in unweighted graph
- Level-order traversal
- Finding shortest augmenting paths (in flow algorithms)
- Connected components
- Bipartite checking

**Standard Implementation**:
```cpp
vector<int> bfs(int start, const vector<vector<int>>& adj) {
    int n = adj.size();
    vector<int> dist(n, -1);
    queue<int> q;
    
    dist[start] = 0;
    q.push(start);
    
    while (!q.empty()) {
        int v = q.front();
        q.pop();
        
        for (int to : adj[v]) {
            if (dist[to] == -1) {
                dist[to] = dist[v] + 1;
                q.push(to);
            }
        }
    }
    return dist;
}
```

**BFS with Path Reconstruction**:
```cpp
pair<vector<int>, vector<int>> bfs_with_path(int start, const vector<vector<int>>& adj) {
    int n = adj.size();
    vector<int> dist(n, -1);
    vector<int> parent(n, -1);
    queue<int> q;
    
    dist[start] = 0;
    q.push(start);
    
    while (!q.empty()) {
        int v = q.front();
        q.pop();
        
        for (int to : adj[v]) {
            if (dist[to] == -1) {
                dist[to] = dist[v] + 1;
                parent[to] = v;
                q.push(to);
            }
        }
    }
    return {dist, parent};
}

// To reconstruct path from start to v:
vector<int> get_path(int v, const vector<int>& parent) {
    vector<int> path;
    while (v != -1) {
        path.push_back(v);
        v = parent[v];
    }
    reverse(path.begin(), path.end());
    return path;
}
```

### Iterative Deepening DFS (IDDFS)
**Purpose**: Combines benefits of DFS and BFS
**Use when**: 
- Search space is large/depth is unknown
- Want BFS-like optimality but with DFS-like memory usage
**Time Complexity**: O(b^d) where b is branching factor, d is depth
**Space Complexity**: O(d)

```cpp
bool iddfs(const vector<vector<int>>& adj, int start, int target, int max_depth) {
    for (int depth = 0; depth <= max_depth; depth++) {
        vector<bool> visited(adj.size(), false);
        if (dfs_limited(start, target, depth, 0, adj, visited)) {
            return true;
        }
    }
    return false;
}

bool dfs_limited(int v, int target, int depth_limit, int depth, 
                const vector<vector<int>>& adj, vector<bool>& visited) {
    if (v == target) return true;
    if (depth >= depth_limit) return false;
    
    visited[v] = true;
    for (int to : adj[v]) {
        if (!visited[to] && dfs_limited(to, target, depth_limit, depth+1, adj, visited)) {
            return true;
        }
    }
    return false;
}
```

## Shortest Path Algorithms

### Dijkstra's Algorithm
**Purpose**: Find shortest paths from single source in graph with non-negative edge weights
**Time Complexity**: 
- O(V²) with array
- O((V+E) log V) with binary heap
- O(E + V log V) with Fibonacci heap
**Space Complexity**: O(V)

**Standard Implementation** (with priority queue):
```cpp
typedef pair<long long, int> pli; // (distance, vertex)

vector<long long> dijkstra(int start, const vector<vector<pair<int, int>>>& adj) {
    int n = adj.size();
    vector<long long> dist(n, LLONG_MAX);
    priority_queue<pli, vector<pli>, greater<pli>> pq;
    
    dist[start] = 0;
    pq.push({0, start});
    
    while (!pq.empty()) {
        long long d = pq.top().first;
        int v = pq.top().second;
        pq.pop();
        
        if (d != dist[v]) continue; // Outdated entry
        
        for (auto edge : adj[v]) {
            int to = edge.first;
            long long weight = edge.second;
            
            if (dist[v] + weight < dist[to]) {
                dist[to] = dist[v] + weight;
                pq.push({dist[to], to});
            }
        }
    }
    return dist;
}
```

**Dijkstra with Path Reconstruction**:
```cpp
pair<vector<long long>, vector<int>> dijkstra_with_path(int start, 
                                                      const vector<vector<pair<int, int>>>& adj) {
    int n = adj.size();
    vector<long long> dist(n, LLONG_MAX);
    vector<int> parent(n, -1);
    priority_queue<pli, vector<pli>, greater<pli>> pq;
    
    dist[start] = 0;
    pq.push({0, start});
    
    while (!pq.empty()) {
        long long d = pq.top().first;
        int v = pq.top().second;
        pq.pop();
        
        if (d != dist[v]) continue;
        
        for (auto edge : adj[v]) {
            int to = edge.first;
            long long weight = edge.second;
            
            if (dist[v] + weight < dist[to]) {
                dist[to] = dist[v] + weight;
                parent[to] = v;
                pq.push({dist[to], to});
            }
        }
    }
    return {dist, parent};
}
```

### 0-1 BFS
**Purpose**: Special case of Dijkstra for edges with weights 0 or 1 only
**Time Complexity**: O(V + E)
**Uses deque** instead of priority queue

```cpp
vector<int> zero_one_bfs(int start, const vector<vector<pair<int, int>>>& adj) {
    int n = adj.size();
    vector<int> dist(n, INT_MAX);
    deque<int> dq;
    
    dist[start] = 0;
    dq.push_front(start);
    
    while (!dq.empty()) {
        int v = dq.front();
        dq.pop_front();
        
        for (auto edge : adj[v]) {
            int to = edge.first;
            int weight = edge.second; // 0 or 1
            
            if (dist[v] + weight < dist[to]) {
                dist[to] = dist[v] + weight;
                if (weight == 0) {
                    dq.push_front(to);
                } else {
                    dq.push_back(to);
                }
            }
        }
    }
    return dist;
}
```

### Dial's Algorithm (Bucket-based Dijkstra)
**Purpose**: Efficient for small integer weights
**Time Complexity**: O(V + C*E) where C is maximum edge weight
**Better than standard Dijkstra** when C is small

```cpp
vector<long long> dials_algorithm(int start, 
                                  const vector<vector<pair<int, int>>>& adj, 
                                  int max_weight) {
    int n = adj.size();
    vector<long long> dist(n, LLONG_MAX);
    vector<list<int>> buckets(n * max_weight + 1); // Enough buckets
    
    dist[start] = 0;
    buckets[0].push_back(start);
    
    int idx = 0;
    while (idx < buckets.size()) {
        // Find next non-empty bucket
        while (idx < buckets.size() && buckets[idx].empty()) {
            idx++;
        }
        if (idx >= buckets.size()) break;
        
        int v = buckets[idx].front();
        buckets[idx].pop_front();
        
        // Skip if we found a better path already
        if (dist[v] < idx) continue;
        
        for (auto edge : adj[v]) {
            int to = edge.first;
            long long weight = edge.second;
            
            if (dist[v] + weight < dist[to]) {
                dist[to] = dist[v] + weight;
                buckets[dist[to]].push_back(to);
            }
        }
    }
    return dist;
}
```

### Bellman-Ford Algorithm
**Purpose**: Find shortest paths from single source, handles negative weights
**Time Complexity**: O(VE)
**Space Complexity**: O(V)
**Detects negative cycles**

**Standard Implementation**:
```cpp
vector<long long> bellman_ford(int start, int n, const vector<Edge>& edges) {
    vector<long long> dist(n, LLONG_MAX);
    dist[start] = 0;
    
    // Relax edges V-1 times
    for (int i = 0; i < n - 1; i++) {
        bool updated = false;
        for (const Edge& e : edges) {
            if (dist[e.u] != LLONG_MAX && dist[e.u] + e.w < dist[e.v]) {
                dist[e.v] = dist[e.u] + e.w;
                updated = true;
            }
        }
        if (!updated) break; // Early termination
    }
    
    // Check for negative cycles
    for (const Edge& e : edges) {
        if (dist[e.u] != LLONG_MAX && dist[e.u] + e.w < dist[e.v]) {
            // Negative cycle detected
            return vector<long long>(n, LLONG_MIN); // Special value indicating negative cycle
        }
    }
    
    return dist;
}
```

**Shortest Path Faster Algorithm (SPFA)**:
**Average case**: Often faster than Bellman-Ford
**Worst case**: Still O(VE)
**Uses queue** to optimize relaxation

```cpp
vector<long long> spfa(int start, int n, const vector<Edge>& edges) {
    vector<long long> dist(n, LLONG_MAX);
    vector<bool> in_queue(n, false);
    vector<int> count(n, 0); // Count relaxations to detect negative cycles
    queue<int> q;
    
    dist[start] = 0;
    q.push(start);
    in_queue[start] = true;
    
    while (!q.empty()) {
        int v = q.front();
        q.pop();
        in_queue[v] = false;
        
        for (const Edge& e : edges) {
            if (e.u == v && dist[v] != LLONG_MAX && dist[v] + e.w < dist[e.v]) {
                dist[e.v] = dist[v] + e.w;
                if (!in_queue[e.v]) {
                    q.push(e.v);
                    in_queue[e.v] = true;
                    count[e.v]++;
                    if (count[e.v] >= n) { // Negative cycle detected
                        return vector<long long>(n, LLONG_MIN);
                    }
                }
            }
        }
    }
    return dist;
}
```

### Floyd-Warshall Algorithm
**Purpose**: Find shortest paths between all pairs of vertices
**Time Complexity**: O(V³)
**Space Complexity**: O(V²)
**Works with**: Negative weights (but no negative cycles)
**Also computes**: Transitive closure (if we use boolean operations)

**Standard Implementation**:
```cpp
vector<vector<long long>> floyd_warshall(vector<vector<long long>> dist) {
    int n = dist.size();
    
    for (int k = 0; k < n; k++) {
        for (int i = 0; i < n; i++) {
            if (dist[i][k] == LLONG_MAX) continue;
            for (int j = 0; j < n; j++) {
                if (dist[k][j] == LLONG_MAX) continue;
                if (dist[i][k] + dist[k][j] < dist[i][j]) {
                    dist[i][j] = dist[i][k] + dist[k][j];
                }
            }
        }
    }
    return dist;
}
```

**With Path Reconstruction**:
```cpp
pair<vector<vector<long long>>, vector<vector<int>>> floyd_warshall_with_path(vector<vector<long long>> dist) {
    int n = dist.size();
    vector<vector<int>> next(n, vector<int>(n, -1));
    
    // Initialize next matrix
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            if (i != j && dist[i][j] != LLONG_MAX) {
                next[i][j] = j;
            }
        }
    }
    
    // Floyd-Warshall
    for (int k = 0; k < n; k++) {
        for (int i = 0; i < n; i++) {
            if (dist[i][k] == LLONG_MAX) continue;
            for (int j = 0; j < n; j++) {
                if (dist[k][j] == LLONG_MAX) continue;
                if (dist[i][k] + dist[k][j] < dist[i][j]) {
                    dist[i][j] = dist[i][k] + dist[k][j];
                    next[i][j] = next[i][k];
                }
            }
        }
    }
    
    return {dist, next};
}

// To reconstruct path from u to v:
vector<int> reconstruct_path(int u, int v, const vector<vector<int>>& next) {
    if (next[u][v] == -1) return {}; // No path
    
    vector<int> path = {u};
    while (u != v) {
        u = next[u][v];
        path.push_back(u);
    }
    return path;
}
```

### Johnson's Algorithm
**Purpose**: Find shortest paths between all pairs in sparse graphs
**Better than Floyd-Warshall** for sparse graphs
**Time Complexity**: O(V² log V + VE)
**Combines**: Bellman-Ford (to reweight) + Dijkstra (from each vertex)

```cpp
vector<vector<long long>> johnsons_algorithm(int n, const vector<Edge>& edges) {
    // Step 1: Add new vertex s connected to all vertices with weight 0
    vector<Edge> edges2 = edges;
    for (int i = 0; i < n; i++) {
        edges2.push_back(Edge(n, i, 0));
    }
    
    // Step 2: Bellman-Ford from s to get h(v)
    vector<long long> h = bellman_ford(n, n+1, edges2);
    if (h[0] == LLONG_MIN) { // Negative cycle detected
        return vector<vector<long long>>(); // Indicate error
    }
    
    // Step 3: Reweight edges: w'(u,v) = w(u,v) + h(u) - h(v)
    vector<vector<pair<int, int>>> adj(n);
    for (const Edge& e : edges) {
        long long new_w = e.w + h[e.u] - h[e.v];
        adj[e.u].push_back({e.v, (int)new_w}); // Assuming weights fit in int after reweighting
    }
    
    // Step 4: Run Dijkstra from each vertex
    vector<vector<long long>> result(n, vector<long long>(n, LLONG_MAX));
    for (int i = 0; i < n; i++) {
        auto dist = dijkstra(i, adj);
        for (int j = 0; j < n; j++) {
            if (dist[j] != LLONG_MAX) {
                result[i][j] = dist[j] - h[i] + h[j]; // Convert back to original weights
            }
        }
    }
    
    return result;
}
```

## Minimum Spanning Tree Algorithms

### Kruskal's Algorithm
**Purpose**: Find MST by sorting edges and adding them if they don't form cycle
**Time Complexity**: O(E log E) = O(E log V)
**Space Complexity**: O(V + E)
**Best for**: Sparse graphs

```cpp
struct DSU {
    vector<int> parent, rank;
    int components;
    
    DSU(int n) {
        parent.resize(n);
        rank.assign(n, 0);
        components = n;
        iota(parent.begin(), parent.end(), 0);
    }
    
    int find(int x) {
        if (x != parent[x]) parent[x] = find(parent[x]);
        return parent[x];
    }
    
    bool unite(int x, int y) {
        x = find(x);
        y = find(y);
        if (x == y) return false;
        
        if (rank[x] < rank[y]) swap(x, y);
        parent[y] = x;
        if (rank[x] == rank[y]) rank[x]++;
        components--;
        return true;
    }
};

long long kruskal(int n, vector<Edge>& edges) {
    sort(edges.begin(), edges.end(), [](const Edge& a, const Edge& b) {
        return a.w < b.w;
    });
    
    DSU dsu(n);
    long long mst_weight = 0;
    
    for (const Edge& e : edges) {
        if (dsu.unite(e.u, e.v)) {
            mst_weight += e.w;
        }
    }
    return mst_weight;
}
```

### Prim's Algorithm
**Purpose**: Find MST by growing tree from arbitrary starting vertex
**Time Complexity**: 
- O(V²) with array
- O(E log V) with binary heap
- O(E + V log V) with Fibonacci heap
**Space Complexity**: O(V + E)
**Best for**: Dense graphs

**Standard Implementation** (with priority queue):
```cpp
long long prim(int n, const vector<vector<pair<int, int>>>& adj) {
    vector<bool> used(n, false);
    vector<long long> min_edge(n, LLONG_MAX);
    priority_queue<pair<long long, int>, vector<pair<long long, int>>, 
                   greater<pair<long long, int>>> pq;
    
    min_edge[0] = 0;
    pq.push({0, 0});
    long long mst_weight = 0;
    
    while (!pq.empty()) {
        long long weight = pq.top().first;
        int v = pq.top().second;
        pq.pop();
        
        if (used[v]) continue;
        used[v] = true;
        mst_weight += weight;
        
        for (auto edge : adj[v]) {
            int to = edge.first;
            long long weight = edge.second;
            
            if (!used[to] && weight < min_edge[to]) {
                min_edge[to] = weight;
                pq.push({weight, to});
            }
        }
    }
    return mst_weight;
}
```

**Prim's Algorithm for Dense Graphs** (O(V²)):
```cpp
long long prim_dense(int n, const vector<vector<long long>>& adj_matrix) {
    vector<bool> used(n, false);
    vector<long long> min_edge(n, LLONG_MAX);
    long long mst_weight = 0;
    
    min_edge[0] = 0;
    
    for (int i = 0; i < n; i++) {
        // Find vertex with minimum min_edge that's not used
        int v = -1;
        for (int j = 0; j < n; j++) {
            if (!used[j] && (v == -1 || min_edge[j] < min_edge[v])) {
                v = j;
            }
        }
        
        if (v == -1) break; // No more vertices (shouldn't happen in connected graph)
        
        used[v] = true;
        mst_weight += min_edge[v];
        
        // Update min_edge for adjacent vertices
        for (int to = 0; to < n; to++) {
            if (!used[to] && adj_matrix[v][to] < min_edge[to]) {
                min_edge[to] = adj_matrix[v][to];
            }
        }
    }
    return mst_weight;
}
```

### Boruvka's Algorithm
**Purpose**: Another MST algorithm that works in phases
**Time Complexity**: O(E log V)
**Interesting property**: Each phase reduces number of components by at least half
**Can be parallelized** naturally

```cpp
long long boruvka(int n, vector<Edge>& edges) {
    DSU dsu(n);
    long long mst_weight = 0;
    vector<int> cheapest(n, -1); // Best edge index for each component
    
    while (dsu.components > 1) {
        // Reset cheapest array
        fill(cheapest.begin(), cheapest.end(), -1);
        
        // Find cheapest edge from each component
        for (int i = 0; i < edges.size(); i++) {
            int u = dsu.find(edges[i].u);
            int v = dsu.find(edges[i].v);
            
            if (u != v) {
                if (cheapest[u] == -1 || edges[i].w < edges[cheapest[u]].w) {
                    cheapest[u] = i;
                }
                if (cheapest[v] == -1 || edges[i].w < edges[cheapest[v]].w) {
                    cheapest[v] = i;
                }
            }
        }
        
        // Add cheapest edges to MST
        for (int i = 0; i < n; i++) {
            if (cheapest[i] != -1) {
                int u = edges[cheapest[i]].u;
                int v = edges[cheapest[i]].v;
                long long w = edges[cheapest[i]].w;
                
                if (dsu.unite(u, v)) {
                    mst_weight += w;
                }
            }
        }
    }
    return mst_weight;
}
```

## Graph Connectivity

### Connected Components (Undirected Graph)
**Purpose**: Find all connected components in an undirected graph
**Methods**: 
- DFS/BFS: O(V + E)
- Union-Find: O(E α(V)) where α is inverse Ackermann

**DFS Implementation**:
```cpp
vector<vector<int>> get_connected_components(const vector<vector<int>>& adj) {
    int n = adj.size();
    vector<bool> visited(n, false);
    vector<vector<int>> components;
    
    for (int i = 0; i < n; i++) {
        if (!visited[i]) {
            vector<int> component;
            stack<int> st;
            st.push(i);
            visited[i] = true;
            
            while (!st.empty()) {
                int v = st.top();
                st.pop();
                component.push_back(v);
                
                for (int to : adj[v]) {
                    if (!visited[to]) {
                        visited[to] = true;
                        st.push(to);
                    }
                }
            }
            components.push_back(component);
        }
    }
    return components;
}
```

**Union-Find Implementation**:
```cpp
vector<vector<int>> get_connected_components_uf(const vector<vector<int>>& adj) {
    int n = adj.size();
    DSU dsu(n);
    
    // Union all edges
    for (int u = 0; u < n; u++) {
        for (int v : adj[u]) {
            if (u < v) { // Avoid double counting undirected edges
                dsu.unite(u, v);
            }
        }
    }
    
    // Group by root
    vector<vector<int>> components(n);
    for (int i = 0; i < n; i++) {
        components[dsu.find(i)].push_back(i);
    }
    
    // Remove empty components
    vector<vector<int>> result;
    for (auto& comp : components) {
        if (!comp.empty()) {
            result.push_back(comp);
        }
    }
    return result;
}
```

### Strongly Connected Components (SCC) (Directed Graph)
**Purpose**: Find all strongly connected components in a directed graph
**A directed graph** is strongly connected if there's a path from each vertex to every other vertex
**Algorithms**:
- **Kosaraju's Algorithm**: Two DFS passes, O(V + E)
- **Tarjan's Algorithm**: Single DFS pass, O(V + E)
- **Gabow's Algorithm**: Variation of Tarjan's

**Kosaraju's Algorithm**:
```cpp
vector<vector<int>> kosaraju_scc(int n, const vector<vector<int>>& adj) {
    vector<bool> visited(n, false);
    vector<int> order;
    vector<vector<int>> adj_rev(n);
    
    // Build reverse graph
    for (int u = 0; u < n; u++) {
        for (int v : adj[u]) {
            adj_rev[v].push_back(u);
        }
    }
    
    // First DFS: fill order by finishing time
    function<void(int)> dfs1 = [&](int v) {
        visited[v] = true;
        for (int to : adj[v]) {
            if (!visited[to]) {
                dfs1(to);
            }
        }
        order.push_back(v);
    };
    
    for (int i = 0; i < n; i++) {
        if (!visited[i]) {
            dfs1(i);
        }
    }
    
    // Second DFS: process in reverse order
    fill(visited.begin(), visited.end(), false);
    vector<vector<int>> components;
    
    function<void(int, vector<int>&)> dfs2 = [&](int v, vector<int>& component) {
        visited[v] = true;
        component.push_back(v);
        for (int to : adj_rev[v]) {
            if (!visited[to]) {
                dfs2(to, component);
            }
        }
    };
    
    for (int i = n - 1; i >= 0; i--) {
        int v = order[i];
        if (!visited[v]) {
            vector<int> component;
            dfs2(v, component);
            components.push_back(component);
        }
    }
    return components;
}
```

**Tarjan's Algorithm**:
```cpp
vector<vector<int>> tarjan_scc(int n, const vector<vector<int>>& adj) {
    vector<int> disc(n, -1), low(n, -1);
    vector<bool> in_stack(n, false);
    stack<int> st;
    int time = 0;
    vector<vector<int>> components;
    
    function<void(int)> dfs = [&](int v) {
        disc[v] = low[v] = time++;
        st.push(v);
        in_stack[v] = true;
        
        for (int to : adj[v]) {
            if (disc[to] == -1) { // Not visited
                dfs(to);
                low[v] = min(low[v], low[to]);
            } else if (in_stack[to]) { // Back edge to node in current SCC
                low[v] = min(low[v], disc[to]);
            }
        }
        
        // If v is head of SCC, pop stack and generate SCC
        if (low[v] == disc[v]) {
            vector<int> component;
            while (true) {
                int u = st.top();
                st.pop();
                in_stack[u] = false;
                component.push_back(u);
                if (u == v) break;
            }
            components.push_back(component);
        }
    };
    
    for (int i = 0; i < n; i++) {
        if (disc[i] == -1) {
            dfs(i);
        }
    }
    return components;
}
```

### Bridges and Articulation Points
**Bridge**: Edge whose removal increases number of connected components
**Articulation Point**: Vertex whose removal increases number of connected components

**Tarjan's Algorithm for Bridges**:
```cpp
vector<pair<int, int>> find_bridges(int n, const vector<vector<int>>& adj) {
    vector<int> disc(n, -1), low(n, -1);
    vector<bool> visited(n, false);
    int time = 0;
    vector<pair<int, int>> bridges;
    
    function<void(int, int)> dfs = [&](int v, int parent) {
        visited[v] = true;
        disc[v] = low[v] = time++;
        
        for (int to : adj[v]) {
            if (to == parent) continue; // Skip the edge we came from
            
            if (!visited[to]) {
                dfs(to, v);
                low[v] = min(low[v], low[to]);
                
                // If the lowest vertex reachable from subtree under 'to' 
                // is below 'v' in DFS tree, then (v,to) is a bridge
                if (low[to] > disc[v]) {
                    bridges.push_back({min(v, to), max(v, to)});
                }
            } else {
                // Back edge
                low[v] = min(low[v], disc[to]);
            }
        }
    };
    
    for (int i = 0; i < n; i++) {
        if (!visited[i]) {
            dfs(i, -1);
        }
    }
    return bridges;
}
```

**Tarjan's Algorithm for Articulation Points**:
```cpp
vector<int> find_articulation_points(int n, const vector<vector<int>>& adj) {
    vector<int> disc(n, -1), low(n, -1);
    vector<bool> visited(n, false), is_articulation(n, false);
    int time = 0;
    
    function<void(int, int)> dfs = [&](int v, int parent) {
        visited[v] = true;
        disc[v] = low[v] = time++;
        int children = 0;
        
        for (int to : adj[v]) {
            if (to == parent) continue;
            
            if (!visited[to]) {
                children++;
                dfs(to, v);
                low[v] = min(low[v], low[to]);
                
                // Check if v is articulation point
                if (parent != -1 && low[to] >= disc[v]) {
                    is_articulation[v] = true;
                }
            } else {
                low[v] = min(low[v], disc[to]);
            }
        }
        
        // Root of DFS tree is articulation point if it has more than one child
        if (parent == -1 && children > 1) {
            is_articulation[v] = true;
        }
    };
    
    for (int i = 0; i < n; i++) {
        if (!visited[i]) {
            dfs(i, -1);
        }
    }
    
    vector<int> result;
    for (int i = 0; i < n; i++) {
        if (is_articulation[i]) {
            result.push_back(i);
        }
    }
    return result;
}
```

## Topological Sorting

**Purpose**: Linear ordering of vertices such that for every directed edge u → v, u comes before v in the ordering
**Only possible for**: Directed Acyclic Graphs (DAGs)
**Applications**: 
- Task scheduling
- Instruction scheduling
- Formula evaluation
- Dependency resolution

**Kahn's Algorithm** (BFS-based):
```cpp
vector<int> topological_sort_kahn(int n, const vector<vector<int>>& adj) {
    vector<int> in_degree(n, 0);
    vector<int> result;
    
    // Calculate in-degrees
    for (int u = 0; u < n; u++) {
        for (int v : adj[u]) {
            in_degree[v]++;
        }
    }
    
    // Queue for vertices with zero in-degree
    queue<int> q;
    for (int i = 0; i < n; i++) {
        if (in_degree[i] == 0) {
            q.push(i);
        }
    }
    
    while (!q.empty()) {
        int u = q.front();
        q.pop();
        result.push_back(u);
        
        for (int v : adj[u]) {
            in_degree[v]--;
            if (in_degree[v] == 0) {
                q.push(v);
            }
        }
    }
    
    // If result doesn't contain all vertices, graph has a cycle
    if (result.size() != n) {
        return {}; // Empty vector indicates cycle
    }
    return result;
}
```

**DFS-based Algorithm**:
```cpp
vector<int> topological_sort_dfs(int n, const vector<vector<int>>& adj) {
    vector<bool> visited(n, false);
    vector<int> result;
    
    function<void(int)> dfs = [&](int v) {
        visited[v] = true;
        for (int to : adj[v]) {
            if (!visited[to]) {
                dfs(to);
            }
        }
        result.push_back(v); // Post-order
    };
    
    for (int i = 0; i < n; i++) {
        if (!visited[i]) {
            dfs(i);
        }
    }
    
    reverse(result.begin(), result.end()); // Reverse to get topological order
    return result;
}
```

## Cycle Detection

### In Undirected Graphs
**Using DFS**: O(V + E)
**Property**: A graph has a cycle iff we encounter an edge to an already visited node that is not the parent

```cpp
bool has_cycle_undirected(int n, const vector<vector<int>>& adj) {
    vector<bool> visited(n, false);
    
    function<bool(int, int)> dfs = [&](int v, int parent) {
        visited[v] = true;
        for (int to : adj[v]) {
            if (to == parent) continue;
            
            if (visited[to]) {
                return true; // Found a back edge
            }
            
            if (dfs(to, v)) {
                return true;
            }
        }
        return false;
    };
    
    for (int i = 0; i < n; i++) {
        if (!visited[i] && dfs(i, -1)) {
            return true;
        }
    }
    return false;
}
```

**Using Union-Find**: O(E α(V))
```cpp
bool has_cycle_undirected_uf(int n, const vector<Edge>& edges) {
    DSU dsu(n);
    
    for (const Edge& e : edges) {
        if (!dsu.unite(e.u, e.v)) {
            // If unite fails, u and v are already in same set => cycle
            return true;
        }
    }
    return false;
}
```

### In Directed Graphs
**Using DFS with coloring**: O(V + E)
**Colors**: 
- 0 = White (unvisited)
- 1 = Gray (visiting, in recursion stack)
- 2 = Black (visited, finished)

```cpp
bool has_cycle_directed(int n, const vector<vector<int>>& adj) {
    vector<int> color(n, 0); // 0=white, 1=gray, 2=black
    
    function<bool(int)> dfs = [&](int v) {
        color[v] = 1; // Gray
        
        for (int to : adj[v]) {
            if (color[to] == 0) { // White
                if (dfs(to)) {
                    return true;
                }
            } else if (color[to] == 1) { // Gray -> back edge
                return true;
            }
            // Black edges are fine in DAG
        }
        
        color[v] = 2; // Black
        return false;
    };
    
    for (int i = 0; i < n; i++) {
        if (color[i] == 0 && dfs(i)) {
            return true;
        }
    }
    return false;
}
```

## Advanced Graph Algorithms

### Maximum Flow Algorithms
**Purpose**: Find maximum flow from source to sink in flow network

#### Ford-Fulkerson Method
**Purpose**: Find maximum flow by repeatedly finding augmenting paths
**Time Complexity**: O(E × max_flow) in worst case
**Depends on**: How we find augmenting paths

```cpp
struct Edge {
    int to, rev;
    long long cap;
    Edge(int _to, int _rev, long long _cap) : to(_to), rev(_rev), cap(_cap) {}
};

class Dinic {
private:
    int n;
    vector<vector<Edge>> graph;
    vector<int> level, ptr;
    
public:
    Dinic(int n) : n(n) {
        graph.resize(n);
        level.resize(n);
        ptr.resize(n);
    }
    
    void add_edge(int u, int v, long long cap) {
        graph[u].push_back(Edge(v, (int)graph[v].size(), cap));
        graph[v].push_back(Edge(u, (int)graph[u].size() - 1, 0));
    }
    
    bool bfs(int s, int t) {
        fill(level.begin(), level.end(), -1);
        queue<int> q;
        level[s] = 0;
        q.push(s);
        
        while (!q.empty()) {
            int v = q.front();
            q.pop();
            
            for (Edge& e : graph[v]) {
                if (e.cap > 0 && level[e.to] < 0) {
                    level[e.to] = level[v] + 1;
                    q.push(e.to);
                }
            }
        }
        return level[t] != -1;
    }
    
    long long dfs(int v, int t, long long flow) {
        if (v == t) return flow;
        
        for (int& i = ptr[v]; i < (int)graph[v].size(); i++) {
            Edge& e = graph[v][i];
            if (e.cap > 0 && level[e.to] == level[v] + 1) {
                long long pushed = dfs(e.to, t, min(flow, e.cap));
                if (pushed > 0) {
                    e.cap -= pushed;
                    graph[e.to][e.rev].cap += pushed;
                    return pushed;
                }
            }
        }
        return 0;
    }
    
    long long max_flow(int s, int t) {
        long long flow = 0;
        while (bfs(s, t)) {
            fill(ptr.begin(), ptr.end(), 0);
            while (long long pushed = dfs(s, t, LLONG_MAX)) {
                flow += pushed;
            }
        }
        return flow;
    }
};
```

#### Edmonds-Karp Algorithm
**Purpose**: Ford-Fulkerson with BFS for finding augmenting paths
**Time Complexity**: O(VE²)
**Guaranteed polynomial time**

```cpp
long long edmonds_karp(int n, int s, int t, vector<Edge>& edges) {
    // Build residual graph
    vector<vector<pair<int, long long>>> adj(n); // (to, capacity)
    vector<vector<int>> rev(n); // Index of reverse edge
    
    for (const Edge& e : edges) {
        adj[e.u].push_back({e.v, e.w});
        adj[e.v].push_back({e.u, 0}); // Reverse edge with 0 capacity
        rev[e.u].push_back((int)adj[e.v].size() - 1);
        rev[e.v].push_back((int)adj[e.u].size() - 1);
    }
    
    long long max_flow = 0;
    
    while (true) {
        // BFS to find augmenting path
        vector<pair<int, int>> parent(n, {-1, -1}); // (parent, edge_index)
        queue<int> q;
        q.push(s);
        parent[s] = {s, -1};
        
        while (!q.empty() && parent[t].first == -1) {
            int u = q.front();
            q.pop();
            
            for (int i = 0; i < adj[u].size(); i++) {
                int v = adj[u][i].first;
                long long cap = adj[u][i].second;
                
                if (cap > 0 && parent[v].first == -1) {
                    parent[v] = {u, i};
                    q.push(v);
                }
            }
        }
        
        if (parent[t].first == -1) break; // No augmenting path
        
        // Find bottleneck capacity
        long long bottleneck = LLONG_MAX;
        for (int v = t; v != s; v = parent[v].first) {
            int u = parent[v].first;
            int idx = parent[v].second;
            bottleneck = min(bottleneck, adj[u][idx].second);
        }
        
        // Update residual capacities
        for (int v = t; v != s; v = parent[v].first) {
            int u = parent[v].first;
            int idx = parent[v].second;
            adj[u][idx].second -= bottleneck;
            adj[v][rev[u][idx]].second += bottleneck;
        }
        
        max_flow += bottleneck;
    }
    
    return max_flow;
}
```

### Minimum Cut Algorithms
**Purpose**: Find minimum capacity cut that separates source from sink
**By Max-Flow Min-Cut Theorem**: Value of maximum flow = capacity of minimum cut

**To find actual min-cut after computing max-flow**:
1. Run BFS/DFS in residual graph from source following edges with positive capacity
2. Vertices reachable from source are in S-set
3. Vertices not reachable are in T-set
4. Edges from S-set to T-set in original graph form the min-cut

### Maximum Matching Algorithms
**Purpose**: Find largest set of edges without common vertices

#### Hopcroft-Karp Algorithm (for bipartite graphs)
**Purpose**: Find maximum matching in bipartite graph
**Time Complexity**: O(E√V)
**Much better than** O(VE) for naive augmenting path approach

```cpp
class HopcroftKarp {
private:
    int n_left, n_right;
    vector<vector<int>> adj;
    vector<int> pair_left, pair_right, dist;
    
public:
    HopcroftKarp(int n_left, int n_right) : n_left(n_left), n_right(n_right) {
        adj.resize(n_left);
        pair_left.assign(n_left, -1);
        pair_right.assign(n_right, -1);
        dist.resize(n_left);
    }
    
    void add_edge(int u, int v) {
        adj[u].push_back(v);
    }
    
    bool bfs() {
        queue<int> q;
        for (int u = 0; u < n_left; u++) {
            if (pair_left[u] == -1) {
                dist[u] = 0;
                q.push(u);
            } else {
                dist[u] = -1;
            }
        }
        
        bool found_augmenting = false;
        while (!q.empty()) {
            int u = q.front();
            q.pop();
            
            for (int v : adj[u]) {
                if (pair_right[v] != -1 && dist[pair_right[v]] == -1) {
                    dist[pair_right[v]] = dist[u] + 1;
                    q.push(pair_right[v]);
                } else if (pair_right[v] == -1) {
                    found_augmenting = true; // We can potentially augment
                }
            }
        }
        return found_augmenting;
    }
    
    bool dfs(int u) {
        for (int v : adj[u]) {
            if (pair_right[v] == -1 || 
                (dist[pair_right[v]] == dist[u] + 1 && dfs(pair_right[v]))) {
                pair_left[u] = v;
                pair_right[v] = u;
                return true;
            }
        }
        dist[u] = -1;
        return false;
    }
    
    int max_matching() {
        int matching = 0;
        while (bfs()) {
            for (int u = 0; u < n_left; u++) {
                if (pair_left[u] == -1 && dfs(u)) {
                    matching++;
                }
            }
        }
        return matching;
    }
    
    vector<pair<int, int>> get_matching() {
        vector<pair<int, int>> result;
        for (int u = 0; u < n_left; u++) {
            if (pair_left[u] != -1) {
                result.push_back({u, pair_left[u]});
            }
        }
        return result;
    }
};
```

#### Hungarian Algorithm (Kuhn-Munkres)
**Purpose**: Find maximum weight matching in bipartite graph
**Also solves**: Assignment problem
**Time Complexity**: O(V³)

```cpp
long long hungarian(const vector<vector<long long>>& cost) {
    // Assumes cost matrix is square (n x n)
    int n = cost.size();
    vector<long long> u(n+1), v(n+1);
    vector<int> p(n+1), way(n+1);
    
    for (int i = 1; i <= n; i++) {
        p[0] = i;
        int j0 = 0;
        vector<long long> minv(n+1, LLONG_MAX);
        vector<bool> used(n+1, false);
        
        do {
            used[j0] = true;
            int i0 = p[j0];
            long long delta = LLONG_MAX;
            int j1 = 0;
            
            for (int j = 1; j <= n; j++) {
                if (!used[j]) {
                    long long cur = cost[i0-1][j-1] - u[i0] - v[j];
                    if (cur < minv[j]) {
                        minv[j] = cur;
                        way[j] = j0;
                    }
                    if (minv[j] < delta) {
                        delta = minv[j];
                        j1 = j;
                    }
                }
            }
            
            for (int j = 0; j <= n; j++) {
                if (used[j]) {
                    u[p[j]] += delta;
                    v[j] -= delta;
                } else {
                    minv[j] -= delta;
                }
            }
            j0 = j1;
        } while (p[j0] != 0);
        
        // Augmenting
        do {
            int j1 = way[j0];
            p[j0] = p[j1];
            j0 = j1;
        } while (j0);
    }
    
    // Answer is -v[0] (or sum of matched costs)
    long long cost = -v[0];
    return cost;
}
```

### Eulerian Path/Cycle Algorithms
**Eulerian Cycle**: Cycle that uses every edge exactly once
**Eulerian Path**: Path that uses every edge exactly once (may start and end at different vertices)

**Conditions for Undirected Graph**:
- Eulerian Cycle**: All vertices have even degree
- **Eulerian Path**: Exactly 0 or 2 vertices have odd degree

**Conditions for Directed Graph**:
- **Eulerian Cycle**: 
  - Every vertex has equal in-degree and out-degree
  - All vertices with nonzero degree belong to single strongly connected component
- **Eulerian Path**:
  - At most one vertex has out-degree = in-degree + 1 (start)
  - At most one vertex has in-degree = out-degree + 1 (end)
  - All other vertices have equal in-degree and out-degree
  - All vertices with nonzero degree belong to single connected component in underlying undirected graph

**Hierholzer's Algorithm**: O(E) to find Eulerian path/cycle
```cpp
vector<int> find_eulerian_path(int n, const vector<vector<int>>& adj) {
    // First check if Eulerian path/cycle exists
    vector<int> degree(n, 0);
    for (int u = 0; u < n; u++) {
        for (int v : adj[u]) {
            degree[u]++;
        }
    }
    
    int odd_count = 0;
    int start = 0;
    for (int i = 0; i < n; i++) {
        if (degree[i] % 2 == 1) {
            odd_count++;
            start = i;
        }
    }
    
    if (odd_count != 0 && odd_count != 2) {
        return {}; // No Eulerian path/cycle
    }
    
    // If no odd degree vertices, start anywhere with edges
    if (odd_count == 0) {
        for (int i = 0; i < n; i++) {
            if (!adj[i].empty()) {
                start = i;
                break;
            }
        }
        if (start == 0 && adj[0].empty()) {
            return {}; // No edges
        }
    }
    
    // Make a copy of adjacency list since we'll modify it
    vector<map<int, int>> adj_count(n);
    for (int u = 0; u < n; u++) {
        for (int v : adj[u]) {
            adj_count[u][v]++;
        }
    }
    
    vector<int> path;
    stack<int> st;
    st.push(start);
    
    while (!st.empty()) {
        int v = st.top();
        if (!adj_count[v].empty()) {
            // Get next edge
            auto it = adj_count[v].begin();
            int to = it->first;
            
            // Remove edge
            if (--it->second == 0) {
                adj_count[v].erase(it);
            }
            
            // Remove reverse edge
            if (--adj_count[to][v] == 0) {
                adj_count[to].erase(v);
            }
            
            st.push(to);
        } else {
            // No more edges from v, add to path
            path.push_back(v);
            st.pop();
        }
    }
    
    reverse(path.begin(), path.end());
    return path;
}
```

## Specialized Graph Problems

### Minimum Spanning Tree with Constraints
**Variations**:
- **Degree-constrained MST**: Each vertex has degree limit
- **MST with forbidden edges**: Certain edges cannot be used
- **MST with required edges**: Certain edges must be used
- **Second-best MST**: Find MST with second minimum weight

### Traveling Salesperson Problem (TSP)
**NP-hard**, but solvable for small n with DP
**DP State**: dp[mask][v] = minimum cost to visit cities in mask ending at v
**Time Complexity**: O(n² × 2ⁿ)
**Space Complexity**: O(n × 2ⁿ)

```cpp
long long tsp(int n, const vector<vector<long long>>& dist) {
    // Assumes complete graph or INF for missing edges
    int full_mask = (1 << n) - 1;
    vector<vector<long long>> dp(1 << n, vector<long long>(n, LLONG_MAX));
    
    // Base case: starting at city 0
    dp[1][0] = 0;
    
    for (int mask = 1; mask < (1 << n); mask++) {
        for (int u = 0; u < n; u++) {
            if (!(mask & (1 << u))) continue; // u not in mask
            if (dp[mask][u] == LLONG_MAX) continue;
            
            for (int v = 0; v < n; v++) {
                if (mask & (1 << v)) continue; // v already visited
                int new_mask = mask | (1 << v);
                dp[new_mask][v] = min(dp[new_mask][v], dp[mask][u] + dist[u][v]);
            }
        }
    }
    
    // Return to start
    long long ans = LLONG_MAX;
    for (int i = 1; i < n; i++) {
        if (dp[full_mask][i] != LLONG_MAX) {
            ans = min(ans, dp[full_mask][i] + dist[i][0]);
        }
    }
    return ans;
}
```

### Hamiltonian Path/Cycle
**NP-complete**, but solvable for small n with DP or backtracking
**DP approach similar to TSP** but without returning to start
**Backtracking with pruning** often works for n ≤ 50

### Graph Coloring
**NP-hard**, but useful heuristics exist
**Greedy coloring**: O(V + E) but not optimal
**Backtracking with pruning**: Can work for small graphs
**DSATUR heuristic**: Choose vertex with highest saturation degree

### Maximum Independent Set / Maximum Clique
**NP-complete**, but:
- **Perfect graphs**: Polynomial time algorithms exist
- **Bipartite graphs**: MIS = minimum vertex cover (by König's theorem)
- **Trees**: Can be solved with DP
- **Small graphs**: Bron–Kerbosch algorithm for maximal cliques

### Steiner Tree Problems
**NP-hard**, but:
- **Minimum Steiner Tree**: Given subset of terminals, find minimum tree spanning them
- **Approximation algorithms** exist
- **Dynamic programming on subsets** for small number of terminals

### Graph Isomorphism
**Not known to be NP-complete or in P**
**Practical algorithms** work well for most graphs
**VF2 algorithm**: Commonly used for graph isomorphism testing

### Planar Graph Testing
**Kuratowski's theorem**: Graph is planar iff it doesn't contain K₅ or K₃,₃ as a minor
**Linear time algorithms** exist
**Applications**: Circuit design, geographic information systems

### Topological Sorting with Constraints
**Lexicographically smallest topological sort**: Use min-heap instead of queue in Kahn's algorithm
**Longest path in DAG**: Can be found with DP after topological sort
**Counting number of topological sorts**: #P-complete, but DP works for small n or special cases

## Graph Algorithms Cheat Sheet

### When to Use What
**Shortest Path**:
- **Unweighted**: BFS
- **Non-negative weights**: Dijkstra
- **Negative weights (no negative cycles)**: Bellman-Ford or SPFA
- **All pairs**: Floyd-Warshall (dense) or Johnson's (sparse)
- **Many queries**: Preprocess with Johnson's or Floyd-Warshall
- **Single source, many targets**: Dijkstra

**Minimum Spanning Tree**:
- **Sparse graph**: Kruskal
- **Dense graph**: Prim
- **Need to update edges**: Consider dynamic MST algorithms (advanced)

**Connectivity**:
- **Static undirected**: DFS/BFS or Union-Find
- **Static directed**: Kosaraju's or Tarjan's for SCC
- **Dynamic undirected**: Union-Find (if only additions) or more complex structures
- **Dynamic directed**: Very complex, usually avoid if possible

**Topological Sort**: 
- **Only for DAGs**: Use Kahn's or DFS-based
- **Need lexicographically smallest**: Use min-heap in Kahn's
- **Need to detect cycle**: Check if sort includes all vertices

**Flow Problems**:
- **Unit capacities or small flows**: Edmonds-Karp
- **General case**: Dinic's (usually fastest in practice)
- **Many queries**: Preprocess with Gomory-Hu tree (advanced)
- **Vertex capacities**: Split each vertex into in/out with edge capacity

**Matching Problems**:
- **Bipartite, unweighted**: Hopcroft-Karp
- **Bipartite, weighted**: Hungarian algorithm
- **General graph**: Much more complex, often exponential
- **Maximum independent set in bipartite**: Equivalent to minimum vertex cover

### Common Patterns and Tricks
1. **Graph Transformation**:
   - Convert edge weights to vertex weights (split edges)
   - Convert vertex weights to edge weights (split vertices)
   - Line graph: Transform edge problems to vertex problems
   - Complement graph: Sometimes easier to work with

2. **Layered Graphs**:
   - Create multiple copies of graph for different states
   - Used in problems with limited resources, time-dependent constraints
   - Example: Shortest path with at most k edges

3. **State Space Search**:
   - Treat each state as a node in implicit graph
   - Edges represent state transitions
   - Apply BFS/DFS/Dijkstra/etc. on this state graph
   - Common in puzzles, games, DP problems

4. **Meet-in-the-Middle**:
   - Split problem into two halves
   - Solve each half separately
   - Combine results
   - Useful for TSP, Hamiltonian path when n is moderate (≤ 40)

5. **Primal-Dual Methods**:
   - Simultaneously construct primal and dual solutions
   - Used in approximation algorithms for NP-hard problems
   - Examples: Set cover, vertex cover

6. **Randomized Algorithms**:
   - Color coding for path/finding problems
   - Randomized incremental construction
   - Often simpler to implement and analyze

### Implementation Tips
1. **Representation Choice**:
   - **Sparse graphs (E = O(V))**: Adjacency list
   - **Dense graphs (E = Ω(V²))**: Adjacency matrix
   - **Need fast edge lookup**: Consider unordered_set or sorted vectors + binary search
   - **Multiple algorithms on same graph**: May benefit from multiple representations

2. **Edge Cases**:
   - Empty graph
   - Single vertex
   - Disconnected graph
   - Graph with self-loops
   - Graph with multiple edges
   - Directed vs undirected

3. **Optimization Techniques**:
   - **Adjacency list optimization**: Use vector instead of list for better cache performance
   - **Edge iteration optimization**: Reserve space in vectors if size known
   - **Early termination**: Many algorithms can stop early under certain conditions
   - **Bidirectional search**: For shortest path, search from both ends
   - **Goal-directed search**: Use heuristics like A* (when applicable)

4. **Common Mistakes**:
   - Forgetting to reset data structures between test cases
   - Not handling disconnected graphs properly
   - Confusing directed vs undirected graph assumptions
   - Off-by-one errors in indexing
   - Integer overflow in path algorithms
   - Not checking for negative cycles when required
   - Using wrong algorithm for graph type (e.g., Dijkstra with negative weights)

### Practice Problems by Category
**Basic Traversals**:
- Number of connected components
- Bipartite graph checking
- Find cycles
- Path existence

**Shortest Path**:
- Dijkstra's algorithm applications
- Bellman-Ford for negative weights
- Floyd-Warshall for all-pairs
- 0-1 BFS for special weights
- Dijkstra with path reconstruction

**Minimum Spanning Tree**:
- Kruskal's algorithm
- Prim's algorithm
- Second best MST
- MST with constraints

**Connectivity**:
- Strongly connected components
- Bridges and articulation points
- Biconnected components
- Dynamic connectivity (offline)

**Topological Sort**:
- Course scheduling
- Recipe preparation
- Dependency resolution
- Longest path in DAG

**Flow Problems**:
- Maximum flow (Dinic's or Edmonds-Karp)
- Minimum cut
- Maximum bipartite matching (Hopcroft-Karp)
- Assignment problem (Hungarian)

**Specialized Problems**:
- Traveling Salesperson (DP)
- Eulerian path/cycle
- Graph coloring (greedy or backtracking)
- Maximum independent set in trees
- Vertex cover in bipartite graphs

### Final Advice
1. **Master the basics**: Be extremely comfortable with BFS, DFS, Dijkstra, and Union-Find
2. **Understand the theory**: Know why algorithms work, not just how to implement them
3. **Recognize patterns**: Learn to map problems to known graph algorithms
4. **Practice implementation**: The best way to learn is by implementing and debugging
5. **Learn from mistakes**: When your solution fails, understand why and how to fix it
6. **Consider constraints**: Always check if your chosen algorithm fits the problem limits
7. **Think about alternatives**: Sometimes a simpler approach works better than a complex algorithm
8. **Stay updated**: New techniques and optimizations are constantly developed

Remember that graph algorithms are not just about memorizing implementations—they're about understanding how to model problems as graphs and then applying the right techniques to solve them. The ability to recognize when a problem can be solved with graph algorithms is often more valuable than knowing the exact implementation details.

Good luck with your graph algorithm adventures! 🚀