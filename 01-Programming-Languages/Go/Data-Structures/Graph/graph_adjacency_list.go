/*
Problem: Graph Adjacency List
Represent a graph using an adjacency list and implement add/remove edge and display operations.

Approach:
- Use a map where each key (vertex) maps to a slice of neighbors
- Provide functions to add/remove edges and display the graph

Time Complexity: O(1) add edge, O(V+E) display
Space Complexity: O(V+E)

Example:
Input: addEdge(0,1), addEdge(0,2), addEdge(1,2), addEdge(2,3)
Output: 0: [1 2], 1: [0 2], 2: [0 1 3], 3: [2]
*/

package main

import "fmt"

type Graph struct {
	vertices map[int][]int
}

func NewGraph() *Graph {
	return &Graph{vertices: make(map[int][]int)}
}

func (g *Graph) AddEdge(u, v int) {
	g.vertices[u] = append(g.vertices[u], v)
	g.vertices[v] = append(g.vertices[v], u)
}

func (g *Graph) RemoveEdge(u, v int) {
	g.removeFromSlice(u, v)
	g.removeFromSlice(v, u)
}

func (g *Graph) removeFromSlice(vertex, target int) {
	neighbors := g.vertices[vertex]
	for i, n := range neighbors {
		if n == target {
			g.vertices[vertex] = append(neighbors[:i], neighbors[i+1:]...)
			return
		}
	}
}

func (g *Graph) Display() {
	for v, neighbors := range g.vertices {
		fmt.Printf("%d: %v\n", v, neighbors)
	}
}

func main() {
	g := NewGraph()
	g.AddEdge(0, 1)
	g.AddEdge(0, 2)
	g.AddEdge(1, 2)
	g.AddEdge(2, 3)
	fmt.Println("Graph adjacency list:")
	g.Display()
}
