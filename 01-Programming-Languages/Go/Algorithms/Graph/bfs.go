/*
Problem: Breadth-First Search (BFS)
Traverse a graph level by level starting from a given source node.

Approach:
- Use a queue to keep track of nodes to visit
- Mark visited nodes to avoid cycles
- Process each node and enqueue its unvisited neighbors

Time Complexity: O(V + E)
Space Complexity: O(V)

Example:
Input: graph = {0:[1,2], 1:[0,3], 2:[0,4], 3:[1], 4:[2]}, start = 0
Output: [0, 1, 2, 3, 4]
*/

package main

import "fmt"

func bfs(graph map[int][]int, start int) []int {
	visited := make(map[int]bool)
	queue := []int{start}
	result := []int{}
	visited[start] = true

	for len(queue) > 0 {
		node := queue[0]
		queue = queue[1:]
		result = append(result, node)
		for _, neighbor := range graph[node] {
			if !visited[neighbor] {
				visited[neighbor] = true
				queue = append(queue, neighbor)
			}
		}
	}
	return result
}

func main() {
	graph := map[int][]int{
		0: {1, 2},
		1: {0, 3},
		2: {0, 4},
		3: {1},
		4: {2},
	}
	start := 0
	result := bfs(graph, start)
	fmt.Printf("Input: graph = %v, start = %d\nOutput: %v\n", graph, start, result)
}
