/*
Problem: Graph Adjacency List
Description: Implement a graph using an adjacency list with
           addVertex, addEdge, removeEdge, display, and DFS.

Approach:
- Store graph as map mapping vertex to list of neighbors
- Supports undirected graph operations
- DFS uses recursion with visited set

Time Complexity: O(V + E) for traversal
Space Complexity: O(V + E)

Example:
Input: add edges 0-1, 0-2, 1-2, 1-3
Output: DFS from 0: 0, 1, 2, 3
*/

class Graph {
  Map<int, List<int>> _adjList = {};

  void addVertex(int v) {
    _adjList.putIfAbsent(v, () => []);
  }

  void addEdge(int u, int v) {
    addVertex(u);
    addVertex(v);
    _adjList[u]!.add(v);
    _adjList[v]!.add(u);
  }

  void removeEdge(int u, int v) {
    _adjList[u]?.remove(v);
    _adjList[v]?.remove(u);
  }

  void display() {
    var sortedKeys = _adjList.keys.toList()..sort();
    for (int key in sortedKeys) {
      var neighbors = List<int>.from(_adjList[key]!)..sort();
      print('$key: $neighbors');
    }
  }

  List<int> dfs(int start) {
    Set<int> visited = {};
    List<int> result = [];
    _dfsHelper(start, visited, result);
    return result;
  }

  void _dfsHelper(int v, Set<int> visited, List<int> result) {
    visited.add(v);
    result.add(v);
    for (int neighbor in (_adjList[v] ?? [])) {
      if (!visited.contains(neighbor)) {
        _dfsHelper(neighbor, visited, result);
      }
    }
  }
}

void main() {
  Graph g = Graph();
  g.addEdge(0, 1);
  g.addEdge(0, 2);
  g.addEdge(1, 2);
  g.addEdge(1, 3);
  print('Graph adjacency list:');
  g.display();
  print('DFS from 0: ${g.dfs(0)}');
}
