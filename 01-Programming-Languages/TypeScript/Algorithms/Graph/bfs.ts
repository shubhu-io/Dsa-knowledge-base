/*
Problem: BFS (Breadth-First Search)
Description: Traverse a graph from a start node using BFS.

Approach:
- Use a queue to process nodes level by level, track visited set

Time Complexity: O(V + E)
Space Complexity: O(V)

Example:
Input: graph = {0:[1,2],1:[0,3,4],2:[0],3:[1],4:[1]}, start = 0
Output: [0, 1, 2, 3, 4]
*/

type Graph = { [key: number]: number[] };

function bfs(graph: Graph, start: number): number[] {
  const visited = new Set<number>();
  const queue: number[] = [start];
  const result: number[] = [];
  visited.add(start);
  while (queue.length > 0) {
    const node = queue.shift()!;
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

const graph: Graph = { 0: [1, 2], 1: [0, 3, 4], 2: [0], 3: [1], 4: [1] };
console.log('BFS from 0:', bfs(graph, 0));
