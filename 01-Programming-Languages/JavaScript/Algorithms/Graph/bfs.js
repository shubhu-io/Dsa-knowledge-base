/*
Problem: BFS (Breadth-First Search)
Description: Traverse a graph represented as an adjacency list using BFS,
starting from a given source node.

Approach:
- Use a queue to process nodes level by level
- Track visited nodes to avoid cycles

Time Complexity: O(V + E)
Space Complexity: O(V)

Example:
Input: graph = {0:[1,2],1:[0,3,4],2:[0],3:[1],4:[1]}, start = 0
Output: [0, 1, 2, 3, 4]
*/

function bfs(graph, start) {
  const visited = new Set();
  const queue = [start];
  const result = [];
  visited.add(start);
  while (queue.length > 0) {
    const node = queue.shift();
    result.push(node);
    for (const neighbor of graph[node]) {
      if (!visited.has(neighbor)) {
        visited.add(neighbor);
        queue.push(neighbor);
      }
    }
  }
  return result;
}

const graph = { 0: [1, 2], 1: [0, 3, 4], 2: [0], 3: [1], 4: [1] };
console.log('BFS from 0:', bfs(graph, 0));
