# Graph Algorithms Overview

## Introduction
Graphs are fundamental data structures used to model pairwise relationships between objects. Graph algorithms are essential for solving problems in social networks, routing, scheduling, and many other domains.

## Graph Representation

### 1. Adjacency Matrix
- **Space**: O(V²)
- **Edge lookup**: O(1)
- **Iterating neighbors**: O(V)
- **Best for**: Dense graphs

### 2. Adjacency List
- **Space**: O(V + E)
- **Edge lookup**: O(degree)
- **Iterating neighbors**: O(degree)
- **Best for**: Sparse graphs

### 3. Edge List
- **Space**: O(E)
- **Best for**: Algorithms that process all edges

## Graph Traversal Algorithms

### Breadth-First Search (BFS)
- **Time**: O(V + E)
- **Space**: O(V)
- **Method**: Queue-based level-order traversal
- **Applications**: 
  - Shortest path in unweighted graphs
  - Connected components
  - Bipartite checking
  - Level order tree traversal

### Depth-First Search (DFS)
- **Time**: O(V + E)
- **Space**: O(V)
- **Method**: Stack or recursion-based depth-oriented traversal
- **Applications**:
  - Cycle detection
  - Topological sorting
  - Strongly connected components
  - Path finding
  - Maze solving

## Shortest Path Algorithms

### Dijkstra's Algorithm
- **Time**: O(E log V) with binary heap
- **Space**: O(V)
- **Works on**: Graphs with non-negative weights
- **Method**: Greedy with priority queue
- **Applications**: GPS navigation, network routing

### Bellman-Ford Algorithm
- **Time**: O(VE)
- **Space**: O(V)
- **Works on**: Graphs with negative weights (no negative cycles)
- **Method**: Relaxation repeated V-1 times
- **Applications**: Detecting negative cycles, currency arbitrage

### Floyd-Warshall Algorithm
- **Time**: O(V³)
- **Space**: O(V²)
- **Works on**: All-pairs shortest path
- **Method**: Dynamic programming
- **Applications**: Small dense graphs, transitive closure

### Johnson's Algorithm
- **Time**: O(V² log V + VE)
- **Space**: O(V)
- **Works on**: Sparse graphs with negative weights
- **Method**: Combines Bellman-Ford and Dijkstra

## Minimum Spanning Tree (MST) Algorithms

### Kruskal's Algorithm
- **Time**: O(E log E)
- **Space**: O(V + E)
- **Method**: Sort edges, add if no cycle (Union-Find)
- **Applications**: Network design, clustering

### Prim's Algorithm
- **Time**: O(E log V) with binary heap
- **Space**: O(V)
- **Method**: Greedy, grow tree from starting vertex
- **Applications**: Same as Kruskal's

## Topological Sorting
- **For**: Directed Acyclic Graphs (DAGs)
- **Methods**:
  - DFS-based (post-order)
  - Kahn's algorithm (in-degree based)
- **Time**: O(V + E)
- **Applications**: Task scheduling, dependency resolution

## Cycle Detection
- **Undirected Graphs**: DFS with parent tracking
- **Directed Graphs**: DFS with recursion stack or topological sort
- **Union-Find**: For undirected graphs

## Connectivity Algorithms

### Connected Components (Undirected)
- **Method**: DFS/BFS from each unvisited vertex
- **Time**: O(V + E)

### Strongly Connected Components (Directed)
- **Kosaraju's Algorithm**: 
  - Time: O(V + E)
  - Method: Two DFS passes
- **Tarjan's Algorithm**:
  - Time: O(V + E)
  - Method: Single DFS with low-link values

## Advanced Graph Algorithms

### Maximum Flow
- **Ford-Fulkerson**: O(E * max_flow)
- **Edmonds-Karp**: O(VE²)
- **Dinic's**: O(V²E)
- **Applications**: Network reliability, bipartite matching

### Traveling Salesman Problem (TSP)
- **Exact**: Dynamic Programming O(n²2ⁿ)
- **Approximation**: Various heuristics
- **Note**: NP-hard problem

### Graph Coloring
- **Applications**: Scheduling, register allocation, map coloring
- **Note**: NP-hard in general

## Graph Algorithms in Practice

### Library Implementations
- **Boost Graph Library (C++)**: Comprehensive
- **NetworkX (Python)**: Popular for analysis
- **JGraphT (Java)**: Well-designed
- **igraph (C/R/Python)**: Efficient for large graphs

### Real-World Applications
- Social networks: Friend recommendations, community detection
- Web: PageRank, crawlers, dependency resolution
- Transportation: Navigation systems, traffic optimization
- Biology: Protein interaction networks, phylogenetic trees
- Computer science: Compilers (control flow), operating systems (resource allocation)

## Common Patterns and Techniques

### 1. Graph Traversal Variants
- **0-1 BFS**: For edge weights 0 or 1
- **Dijkstra with potentials**: For negative weights without negative cycles
- **Iterative Deepening DFS**: Combines BFS space efficiency with DFS completeness

### 2. Union-Find (Disjoint Set)
- **Operations**: Find, Union (with path compression and union by rank)
- **Time**: Nearly O(1) per operation (amortized)
- **Applications**: Kruskal's algorithm, percolation, connectivity queries

### 3. Topological Sort Applications
- **Course scheduling** (LeetCode 207)
- **Build systems** (make, gradle)
- **Instruction scheduling** in compilers

### 4. Shortest Path Variants
- **K shortest paths**
- **Constrained shortest path**
- **Shortest path with vertex/edge penalties**

## When to Use Which Algorithm

### For Unweighted Graphs
- **Shortest path**: BFS
- **Connectivity**: DFS/BFS
- **Cycle detection**: DFS

### For Weighted Graphs (Non-negative)
- **Single source**: Dijkstra's
- **All pairs**: Floyd-Warshall (dense) or repeated Dijkstra (sparse)
- **With constraints**: Modified Dijkstra or BFS on state space

### For Graphs with Negative Weights
- **No negative cycles**: Bellman-Ford
- **Detect negative cycles**: Bellman-Ford
- **Sparse graphs**: Johnson's algorithm

### For Minimum Spanning Tree
- **Sparse graphs**: Prim's with adjacency list
- **Dense graphs**: Prim's with adjacency matrix or Kruskal's
- **Need edges sorted**: Kruskal's

### For Directed Acyclic Graphs (DAGs)
- **Shortest path**: Topological sort + relaxation
- **Longest path**: Same as shortest path (negate weights)
- **Dependency resolution**: Topological sort

## Implementation Considerations

### 1. Choosing Representation
- **Dense graph** (E ≈ V²): Adjacency matrix
- **Sparse graph** (E ≪ V²): Adjacency list
- **Need fast edge lookup**: Consider hash set of edges

### 2. Handling Large Graphs
- **External memory algorithms**: For graphs that don't fit in RAM
- **Streaming algorithms**: Process edges as they arrive
- **Approximation algorithms**: For NP-hard problems
- **Parallel/distributed**: Pregel, GraphX, Giraph

### 3. Common Pitfalls
- **Not resetting visited arrays** between multiple traversals
- **Stack overflow** with recursive DFS on large graphs
- **Integer overflow** in distance calculations
- **Missing edge cases**: Disconnected graphs, self-loops, multiple edges
- **Incorrect complexity analysis**

## Practice Problems

### Beginner
1. Number of Islands
2. Clone Graph
3. Course Schedule
4. Pacific Atlantic Water Flow
5. Walls and Gates

### Intermediate
1. Surrounded Regions
2. Alien Dictionary
3. Graph Valid Tree
4. Reconstruct Itinerary
5. Maximum Depth of N-ary Tree

### Advanced
1. Critical Connections in Network
2. Swim in Rising Water
3. Path With Maximum Minimum Value
4. Out of Boundary Paths
5. Shortest Path Visiting All Nodes

## Further Reading
- "Introduction to Algorithms" by Cormen et al. (Graph chapters)
- "Algorithm Design" by Kleinberg and Tardos
- NetworkX documentation
- Stanford CS97SI: Competitive Programming
- USACO Guide: Graph Theory
- Competitive Programming 4 by Steven Halim
