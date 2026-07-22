# Graph Algorithms

## Overview

Graph algorithms traverse or analyze graph data structures consisting of vertices (nodes) and edges (connections).

## Common Graph Algorithms

| Algorithm | Time | Space | Use Case |
|-----------|------|-------|----------|
| BFS | O(V + E) | O(V) | Shortest path (unweighted) |
| DFS | O(V + E) | O(V) | Cycle detection, topological sort |
| Dijkstra | O((V + E) log V) | O(V) | Shortest path (weighted) |
| Bellman-Ford | O(V × E) | O(V) | Shortest path (negative weights) |
| Floyd-Warshall | O(V³) | O(V²) | All-pairs shortest path |
| Kruskal | O(E log E) | O(V) | Minimum spanning tree |
| Prim | O((V + E) log V) | O(V) | Minimum spanning tree |

## Files

| File | Description |
|------|-------------|
| `graph-algorithms-overview.md` | Detailed overview |
| `graph-algorithms-tutorial.md` | Step-by-step tutorial |
| `graph-algorithms-cheatsheet.md` | Quick reference |
| `graph-algorithms-problems.md` | Practice problems |

## Graph Representations

- **Adjacency Matrix**: O(V²) space, O(1) edge lookup
- **Adjacency List**: O(V + E) space, O(degree) edge lookup