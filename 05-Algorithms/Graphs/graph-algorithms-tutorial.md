# Graph Algorithms Tutorial

## Introduction
Graphs are fundamental data structures in computer science used to model pairwise relationships between objects. A graph consists of vertices (or nodes) connected by edges. Graph algorithms are essential for solving problems in networking, social networks, recommendation systems, routing, and many other domains.

## Graph Basics

### Graph Representation
There are two primary ways to represent graphs in computer memory:

#### 1. Adjacency Matrix
- A 2D boolean array where `matrix[i][j] = true` if there's an edge from vertex i to vertex j
- Space complexity: O(V²)
- Edge lookup: O(1)
- Iterating over neighbors: O(V)
- Good for dense graphs

#### 2. Adjacency List
- An array/list of lists where `adj[i]` contains all vertices adjacent to vertex i
- Space complexity: O(V + E)
- Edge lookup: O(degree(v)) or O(log degree(v)) if sorted
- Iterating over neighbors: O(degree(v))
- Good for sparse graphs

### Graph Types
- **Undirected Graph**: Edges have no direction
- **Directed Graph (Digraph)**: Edges have direction (from source to destination)
- **Weighted Graph**: Edges have associated weights/costs
- **Unweighted Graph**: All edges have equal weight (typically 1)
- **Simple Graph**: No self-loops or multiple edges between same vertices
- **Cyclic/Acyclic**: Contains cycles or doesn't contain cycles
- **Connected/Disconnected**: All vertices reachable from any vertex or not
- **Tree**: Connected acyclic graph
- **DAG (Directed Acyclic Graph)**: Directed graph with no cycles

## Graph Traversal Algorithms

### 1. Breadth-First Search (BFS)
Explores vertices level by level, starting from a source vertex. Uses a queue.

**Applications**:
- Shortest path in unweighted graphs
- Connected components
- Bipartite checking
- Level order traversal of trees
- Social network friend suggestions (degrees of separation)

**Algorithm**:
```python
def bfs(graph, start):
    visited = set()
    queue = deque([start])
    visited.add(start)
    
    while queue:
        vertex = queue.popleft()
        # Process vertex here
        print(vertex, end=" ")
        
        for neighbor in graph[vertex]:
            if neighbor not in visited:
                visited.add(neighbor)
                queue.append(neighbor)
```

**Time Complexity**: O(V + E)
**Space Complexity**: O(V)

### 2. Depth-First Search (DFS)
Explores as far as possible along each branch before backtracking. Uses a stack (or recursion).

**Applications**:
- Path finding
- Cycle detection
- Topological sorting
- Connected components
- Strongly connected components
- Maze solving

**Recursive Implementation**:
```python
def dfs_recursive(graph, vertex, visited=None):
    if visited is None:
        visited = set()
    
    visited.add(vertex)
    # Process vertex here
    print(vertex, end=" ")
    
    for neighbor in graph[vertex]:
        if neighbor not in visited:
            dfs_recursive(graph, neighbor, visited)
    
    return visited
```

**Iterative Implementation**:
```python
def dfs_iterative(graph, start):
    visited = set()
    stack = [start]
    
    while stack:
        vertex = stack.pop()
        if vertex not in visited:
            visited.add(vertex)
            # Process vertex here
            print(vertex, end=" ")
            
            # Add neighbors in reverse order to maintain same order as recursive
            for neighbor in reversed(graph[vertex]):
                if neighbor not in visited:
                    stack.append(neighbor)
    
    return visited
```

**Time Complexity**: O(V + E)
**Space Complexity**: O(V)

## Shortest Path Algorithms

### 1. Dijkstra's Algorithm
Finds shortest paths from a single source to all other vertices in a weighted graph with non-negative weights.

**Applications**:
- Network routing protocols
- GPS navigation
- Network optimization

**Algorithm** (using priority queue):
```python
import heapq

def dijkstra(graph, start):
    distances = {vertex: float('infinity') for vertex in graph}
    distances[start] = 0
    priority_queue = [(0, start)]  # (distance, vertex)
    visited = set()
    
    while priority_queue:
        current_distance, current_vertex = heapq.heappop(priority_queue)
        
        if current_vertex in visited:
            continue
            
        visited.add(current_vertex)
        
        for neighbor, weight in graph[current_vertex].items():
            distance = current_distance + weight
            
            if distance < distances[neighbor]:
                distances[neighbor] = distance
                heapq.heappush(priority_queue, (distance, neighbor))
    
    return distances
```

**Time Complexity**: O((V + E) log V) with binary heap
**Space Complexity**: O(V)

### 2. Bellman-Ford Algorithm
Finds shortest paths from a single source to all other vertices, works with negative weights (but not negative cycles).

**Applications**:
- Networks with negative edge weights
- Detecting negative cycles
- Currency arbitrage

**Algorithm**:
```python
def bellman_ford(graph, start):
    distances = {vertex: float('infinity') for vertex in graph}
    distances[start] = 0
    
    # Relax edges V-1 times
    for _ in range(len(graph) - 1):
        for u in graph:
            for v, weight in graph[u].items():
                if distances[u] + weight < distances[v]:
                    distances[v] = distances[u] + weight
    
    # Check for negative weight cycles
    for u in graph:
        for v, weight in graph[u].items():
            if distances[u] + weight < distances[v]:
                raise ValueError("Graph contains negative weight cycle")
    
    return distances
```

**Time Complexity**: O(V * E)
**Space Complexity**: O(V)

### 3. Floyd-Warshall Algorithm
Finds shortest paths between all pairs of vertices. Works with negative weights (but not negative cycles).

**Applications**:
- Finding shortest paths between all pairs
- Transitive closure
- Network analysis

**Algorithm**:
```python
def floyd_warshall(graph):
    vertices = list(graph.keys())
    n = len(vertices)
    # Map vertex to index for matrix access
    vertex_index = {vertex: i for i, vertex in enumerate(vertices)}
    
    # Initialize distance matrix
    dist = [[float('infinity')] * n for _ in range(n)]
    for i in range(n):
        dist[i][i] = 0
    
    # Fill initial distances
    for u in graph:
        for v, weight in graph[u].items():
            dist[vertex_index[u]][vertex_index[v]] = weight
    
    # Floyd-Warshall algorithm
    for k in range(n):
        for i in range(n):
            for j in range(n):
                if dist[i][k] + dist[k][j] < dist[i][j]:
                    dist[i][j] = dist[i][k] + dist[k][j]
    
    # Convert back to vertex-based dictionary if needed
    result = {}
    for i in range(n):
        result[vertices[i]] = {}
        for j in range(n):
            if dist[i][j] != float('infinity'):
                result[vertices[i]][vertices[j]] = dist[i][j]
    
    return result
```

**Time Complexity**: O(V³)
**Space Complexity**: O(V²)

## Minimum Spanning Tree Algorithms

### 1. Kruskal's Algorithm
Finds a minimum spanning tree by sorting edges and adding them if they don't form a cycle.

**Applications**:
- Network design
- Clustering
- Approximation algorithms for NP-hard problems

**Algorithm** (using Union-Find):
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
            return False
        if self.rank[px] < self.rank[py]:
            self.parent[px] = py
        elif self.rank[px] > self.rank[py]:
            self.parent[py] = px
        else:
            self.parent[py] = px
            self.rank[px] += 1
        return True

def kruskal(graph):
    # Convert adjacency list to edge list
    edges = []
    vertices = list(graph.keys())
    vertex_index = {vertex: i for i, vertex in enumerate(vertices)}
    
    for u in graph:
        for v, weight in graph[u].items():
            if u < v:  # Avoid duplicate edges in undirected graph
                edges.append((weight, u, v))
    
    # Sort edges by weight
    edges.sort()
    
    uf = UnionFind(len(vertices))
    mst = []
    mst_weight = 0
    
    for weight, u, v in edges:
        if uf.union(vertex_index[u], vertex_index[v]):
            mst.append((u, v, weight))
            mst_weight += weight
    
    return mst, mst_weight
```

**Time Complexity**: O(E log E) or O(E log V) (dominated by sorting)
**Space Complexity**: O(V + E)

### 2. Prim's Algorithm
Finds a minimum spanning tree by growing the tree from an arbitrary starting vertex.

**Applications**:
- Similar to Kruskal's but often better for dense graphs
- Network design
- Clustering

**Algorithm** (using priority queue):
```python
import heapq

def prim(graph, start):
    mst = []
    visited = set()
    min_heap = [(0, start, None)]  # (weight, vertex, parent)
    mst_weight = 0
    
    while min_heap:
        weight, vertex, parent = heapq.heappop(min_heap)
        
        if vertex in visited:
            continue
            
        visited.add(vertex)
        if parent is not None:
            mst.append((parent, vertex, weight))
            mst_weight += weight
        
        for neighbor, edge_weight in graph[vertex].items():
            if neighbor not in visited:
                heapq.heappush(min_heap, (edge_weight, vertex, neighbor))
    
    return mst, mst_weight
```

**Time Complexity**: O(E log V) with binary heap
**Space Complexity**: O(V + E)

## Advanced Graph Algorithms

### 1. Topological Sorting
Linear ordering of vertices in a DAG such that for every directed edge u → v, u comes before v.

**Applications**:
- Task scheduling
- Course prerequisites
- Build systems (like Make)
- Dependency resolution

**Algorithm** (Kahn's algorithm using BFS):
```python
from collections import deque

def topological_sort(graph):
    # Calculate in-degree of each vertex
    in_degree = {u: 0 for u in graph}
    for u in graph:
        for v in graph[u]:
            in_degree[v] += 1
    
    # Enqueue all vertices with in-degree 0
    queue = deque([u for u in graph if in_degree[u] == 0])
    top_order = []
    
    while queue:
        u = queue.popleft()
        top_order.append(u)
        
        # Remove edge u-v and update in-degrees
        for v in graph[u]:
            indgree[v] -= 1
            if in_degree[v] == 0:
                queue.append(v)
    
    # Check for cycle
    if len(top_order) != len(graph):
        raise ValueError("Graph has at least one cycle")
    
    return top_order
```

**Time Complexity**: O(V + E)
**Space Complexity**: O(V)

### 2. Kosaraju's Algorithm
Finds strongly connected components (SCCs) in a directed graph.

**Applications**:
- Identifying strongly connected subgraphs
- Making graphs acyclic (condensation)
- Social network analysis
- Program analysis

**Algorithm**:
```python
def kosaraju(graph):
    # Step 1: Fill vertices in order of finish time
    visited = set()
    stack = []
    
    def dfs_first_pass(v):
        visited.add(v)
        for neighbor in graph.get(v, []):
            if neighbor not in visited:
                dfs_first_pass(neighbor)
        stack.append(v)
    
    for v in graph:
        if v not in visited:
            dfs_first_pass(v)
    
    # Step 2: Transpose the graph
    transpose = {v: [] for v in graph}
    for v in graph:
        for neighbor in graph[v]:
            if neighbor not in transpose:
                transpose[neighbor] = []
            transpose[neighbor].append(v)
    
    # Step 3: Process vertices in reverse order of finish time
    visited = set()
    sccs = []
    
    def dfs_second_pass(v, component):
        visited.add(v)
        component.append(v)
        for neighbor in transpose.get(v, []):
            if not visited:
                dfs_second_pass(neighbor, component)
    
    while stack:
        v = stack.pop()
        if v not in visited:
            component = []
            dfs_second_pass(v, component)
            sccs.append(component)
    
    return sccs
```

**Time Complexity**: O(V + E)
**Space Complexity**: O(V + E)

### 3. Cycle Detection
Detecting cycles in graphs.

**Undirected Graph Cycle Detection** (using DFS):
```python
def has_cycle_undirected(graph):
    visited = set()
    
    def dfs(node, parent):
        visited.add(node)
        for neighbor in graph.get(node, []):
            if neighbor not in visited:
                if dfs(neighbor, node):
                    return True
            elif neighbor != parent:
                return True
        return False
    
    for vertex in graph:
        if vertex not in visited:
            if dfs(vertex, None):
                return True
    return False
```

**Directed Graph Cycle Detection** (using DFS with recursion stack):
```python
def has_cycle_directed(graph):
    visited = set()
    rec_stack = set()
    
    def dfs(node):
        visited.add(node)
        rec_stack.add(node)
        
        for neighbor in graph.get(node, []):
            if neighbor not in visited:
                if dfs(neighbor):
                    return True
            elif neighbor in rec_stack:
                return True
        
        rem_stack.remove(node)
        return False
    
    for vertex in graph:
        if vertex not in visited:
            if dfs(vertex):
                return True
    return False
```

**Time Complexity**: O(V + E) for both
**Space Complexity**: O(V)

## Special Graph Algorithms

### 1. Bipartite Graph Checking
A graph is bipartite if its vertices can be divided into two disjoint sets such that no two graph vertices within the same set are adjacent.

**Algorithm** (using BFS/DFS with coloring):
```python
def is_bipartite(graph):
    color = {}
    
    for start in graph:
        if start not in color:
            queue = deque([start])
            color[start] = 0  # Start with color 0
            
            while queue:
                vertex = queue.popleft()
                for neighbor in graph.get(vertex, []):
                    if neighbor not in color:
                        color[neighbor] = 1 - color[vertex]
                        queue.append(neighbor)
                    elif color[neighbor] == color[vertex]:
                        return False
    return True
```

**Time Complexity**: O(V + E)
**Space Complexity**: O(V)

### 2. Bridges and Articulation Points
- **Bridge**: An edge whose removal increases the number of connected components
- **Articulation Point**: A vertex whose removal increases the number of connected components

**Algorithm** (Tarjan's algorithm for both):
```python
def find_bridges_and_articulation_points(graph):
    time = 0
    visited = set()
    discovery_time = {}
    low_value = {}
    parent = {}
    bridges = []
    articulation_points = set()
    
    def dfs(u):
        nonlocal time
        visited.add(u)
        discovery_time[u] = low_value[u] = time
        time += 1
        children = 0
        
        for v in graph.get(u, []):
            if v not in visited:
                parent[v] = u
                children += 1
                dfs(v)
                
                # Update low value
                low_value[u] = min(low_value[u], low_value[v])
                
                # Check for bridge
                if low_value[v] > discovery_time[u]:
                    bridges.append((u, v))
                
                # Check for articulation point (non-root)
                if parent.get(u) is not None and low_value[v] >= discovery_time[u]:
                    articulation_points.add(u)
            elif v != parent.get(u):  # Back edge
                low_value[u] = min(low_value[u], discovery_time[v])
        
        # Check for articulation point (root)
        if parent.get(u) is None and children > 1:
            articulation_points.add(u)
    
    for vertex in graph:
        if vertex not in visited:
            parent[vertex] = None
            dfs(vertex)
    
    return bridges, list(articulation_points)
```

**Time Complexity**: O(V + E)
**Space Complexity**: O(V)

## Graph Problem-Solving Patterns

### 1. **Connected Components**
Find all connected components in an undirected graph.
- Use DFS/BFS from each unvisited node
- Time: O(V + E)

### 2. **Path Finding**
Find if a path exists between two nodes or find the actual path.
- BFS for shortest path in unweighted graphs
- DFS for path existence (may not be shortest)
- Dijkstra/Bellman-Ford for weighted graphs

### 3. **Cycle Detection**
Determine if a graph contains cycles.
- DFS with parent tracking (undirected)
- DFS with recursion stack (directed)
- Union-Find for undirected graphs

### 4. **Topological Sorting**
Order vertices in a DAG respecting edge directions.
- Kahn's algorithm (BFS-based)
- DFS-based (post-order traversal)

### 5. **Shortest Path**
Find minimum distance path between vertices.
- BFS for unweighted graphs
- Dijkstra for non-negative weights
- Bellman-Ford for negative weights (no negative cycles)
- Floyd-Warshall for all-pairs shortest paths

### 6. **Minimum Spanning Tree**
Find minimum weight subset of edges that connects all vertices.
- Kruskal's algorithm (Union-Find)
- Prim's algorithm (Priority Queue)

### 7. **Strongly Connected Components**
Find maximal subgraphs where every vertex is reachable from every other.
- Kosaraju's algorithm (two DFS passes)
- Tarjan's algorithm (single DFS pass)

### 8. **Bipartite Checking**
Determine if graph can be colored with two colors.
- BFS/DFS with coloring approach

## When to Use Which Algorithm

### For Traversal/Search:
- **BFS**: When you need shortest path in unweighted graph or level-by-level processing
- **DFS**: When you need to explore deeply, detect cycles, or topological sort

### For Shortest Path:
- **Unweighted Graph**: BFS
- **Non-negative Weights**: Dijkstra's algorithm
- **Negative Weights (No Negative Cycles)**: Bellman-Ford
- **All-Pairs Shortest Path**: Floyd-Warshall
- **DAG**: Topological sort + relaxation (O(V+E))

### For Minimum Spanning Tree:
- **Sparse Graph**: Kruskal's algorithm (better with Union-Find)
- **Dense Graph**: Prim's algorithm (better with adjacency matrix)

### For Special Properties:
- **Cycle Detection**: DFS-based approaches
- **Topological Sort**: Kahn's algorithm or DFS-based
- **Strongly Connected Components**: Kosaraju's or Tarjan's algorithm
- **Bipartite Check**: BFS/DFS coloring
- **Bridges/Articulation Points**: Tarjan's algorithm

## Complexity Reference

| Algorithm | Time Complexity | Space Complexity | Best For |
|-----------|----------------|------------------|----------|
| BFS/DFS | O(V + E) | O(V) | Basic traversal, connectivity |
| Dijkstra | O((V+E) log V) | O(V) | Single-source shortest path (non-negative) |
| Bellman-Ford | O(V*E) | O(V) | Single-source shortest path (with negative weights) |
| Floyd-Warshall | O(V³) | O(V²) | All-pairs shortest paths |
| Kruskal | O(E log E) | O(V) | MST (sparse graphs) |
| Prim | O(E log V) | O(V) | MST (dense graphs) |
| Topological Sort | O(V+E) | O(V) | DAG ordering |
| Kosaraju | O(V+E) | O(V+E) | Strongly connected components |
| Bipartite Check | O(V+E) | O(V) | 2-colorability check |

## Implementation Tips

### 1. **Choose Right Representation**
- Use adjacency matrix for dense graphs (when E ≈ V²)
- Use adjacency list for sparse graphs (when E << V²)
- Consider edge list for algorithms like Kruskal's

### 2. **Handle Edge Cases**
- Empty graph (V=0)
- Single vertex (V=1)
- Disconnected graphs
- Self-loops
- Multiple edges between vertices

### 3. **Be Careful with Indices**
- 0-indexed vs 1-indexed vertices
- Consistent indexing throughout implementation
- Check bounds when using arrays

### 4. **Weighted vs Unweighted**
- Don't forget to handle weights when present
- For unweighted graphs, you can often use BFS instead of Dijkstra

### 5. **Directed vs Undirected**
- Remember to add edges in both directions for undirected graphs
- Directed algorithms often have different variants

### 6. **Visited Tracking**
- Reset visited sets between multiple traversals
- Use appropriate data structures (set, boolean array)
- Consider using timestamps for reuse without clearing

### 7. **Recursion Depth**
- DFS implementations using recursion may hit recursion limits
- Consider iterative versions for large graphs
- Increase recursion limit if necessary (with caution)

### 8. **Early Termination**
- Many algorithms can stop early when solution is found
- BFS can stop when target is reached
- Dijkstra can stop when target is extracted from queue

## Real-World Applications

### 1. **Networking**
- Routing protocols (OSPF, BGP use Dijkstra variants)
- Network topology discovery
- Load balancing
- Network reliability analysis

### 2. **Social Networks**
- Friend recommendation (shortest path)
- Community detection (connected components)
- Influence maximization
- Information spread modeling

### 3. **Mapping and Navigation**
- GPS navigation (shortest path with constraints)
- Traffic flow analysis
- Location-based services
- Geofencing

### 4. **Computer Science**
- Compiler design (dependency graphs, call graphs)
- Operating systems (resource allocation graphs)
- Database systems (query optimization, dependency tracking)
- Web crawling (web graph traversal)
- Recommendation systems (collaborative filtering graphs)

### 5. **Biology and Chemistry**
- Protein-protein interaction networks
- Metabolic pathway analysis
- Molecular structure comparison
- Epidemiological modeling (disease spread)

### 6. **Operations Research**
- Supply chain optimization
- Project scheduling (PERT/CPM)
- Resource allocation
- Facility location problems

## Problem-Solving Strategy for Graph Problems

### Step 1: **Understand the Problem**
- Is the graph directed or undirected?
- Is it weighted or unweighted?
- What are we trying to find? (path, cycle, connectivity, etc.)
- What are the constraints on size and time?

### Step 2: **Choose Representation**
- Adjacency list for most cases (space-efficient)
- Adjacency matrix if dense and need fast edge lookup
- Edge list for algorithms that process edges (like Kruskal's)

### 3. **Select Appropriate Algorithm**
- Match problem characteristics to algorithm strengths
- Consider time/space complexity trade-offs
- Think about whether you need exact or approximate solutions

### 4. **Implement Carefully**
- Handle edge cases explicitly
- Use appropriate data structures for efficiency
- Test with small examples first
- Verify correctness with known cases

### 5. **Optimize if Necessary**
- Profile to find bottlenecks
- Consider alternative algorithms or data structures
- Look for problem-specific properties to exploit
- Consider approximation algorithms for NP-hard problems

## Remember

1. **Graphs model relationships**: Think in terms of vertices and edges representing entities and their connections
2. **Choice matters**: The right algorithm can make the difference between feasible and infeasible solutions
3. **Representation impacts performance**: Select based on graph density and required operations
4. **Edge cases are critical**: Empty graphs, single nodes, disconnected components often hide bugs
5. **Practice pattern recognition**: Many graph problems reduce to standard algorithms with slight modifications

With practice, you'll develop intuition for recognizing graph problems, selecting appropriate algorithms, and implementing them efficiently. The patterns covered here form the foundation for solving virtually any graph-related problem in computer science.