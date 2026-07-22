/*
Problem: Graph Adjacency List
Description: Implement a graph using an adjacency list with addVertex, addEdge,
removeEdge, removeVertex, and display methods.

Approach:
- Use a Map of vertices to arrays of neighbors

Time Complexity: O(1) add, O(V+E) display
Space Complexity: O(V+E)

Example:
Input: addVertex(0), addVertex(1), addEdge(0,1), display()
Output: 0 -> [1], 1 -> [0]
*/

class Graph {
  constructor() {
    this.adjList = new Map();
  }

  addVertex(vertex) {
    if (!this.adjList.has(vertex)) {
      this.adjList.set(vertex, []);
    }
  }

  addEdge(v1, v2) {
    this.adjList.get(v1).push(v2);
    this.adjList.get(v2).push(v1);
  }

  removeEdge(v1, v2) {
    this.adjList.set(v1, this.adjList.get(v1).filter(v => v !== v2));
    this.adjList.set(v2, this.adjList.get(v2).filter(v => v !== v1));
  }

  removeVertex(vertex) {
    for (const neighbor of this.adjList.get(vertex)) {
      this.removeEdge(vertex, neighbor);
    }
    this.adjList.delete(vertex);
  }

  display() {
    for (const [vertex, neighbors] of this.adjList) {
      console.log(`${vertex} -> [${neighbors.join(', ')}]`);
    }
  }
}

const graph = new Graph();
graph.addVertex(0);
graph.addVertex(1);
graph.addVertex(2);
graph.addEdge(0, 1);
graph.addEdge(0, 2);
graph.addEdge(1, 2);
console.log('Graph adjacency list:');
graph.display();
