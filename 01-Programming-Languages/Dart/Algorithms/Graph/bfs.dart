/*
Problem: BFS Traversal
Description: Perform breadth-first search on a graph represented as
           an adjacency list. Print nodes in BFS order.

Approach:
- Use a queue (List) to track nodes to visit
- Use a visited set to avoid cycles
- Process level by level

Time Complexity: O(V + E)
Space Complexity: O(V)

Example:
Input: graph = {0: [1,2], 1: [0,3,4], 2: [0,5], 3: [1], 4: [1], 5: [2]}, start = 0
Output: 0 1 2 3 4 5
*/

void bfs(Map<int, List<int>> graph, int start) {
  Set<int> visited = {};
  List<int> queue = [start];
  visited.add(start);
  print('BFS starting from $start:');
  while (queue.isNotEmpty) {
    int node = queue.removeAt(0);
    print(node);
    for (int neighbor in (graph[node] ?? [])) {
      if (!visited.contains(neighbor)) {
        visited.add(neighbor);
        queue.add(neighbor);
      }
    }
  }
}

void main() {
  Map<int, List<int>> graph = {
    0: [1, 2],
    1: [0, 3, 4],
    2: [0, 5],
    3: [1],
    4: [1],
    5: [2],
  };
  bfs(graph, 0);
}
