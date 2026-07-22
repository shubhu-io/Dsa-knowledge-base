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

use std::collections::VecDeque;

fn bfs(graph: &[Vec<usize>], start: usize) -> Vec<usize> {
    let mut visited = vec![false; graph.len()];
    let mut queue = VecDeque::new();
    let mut result = Vec::new();
    visited[start] = true;
    queue.push_back(start);
    while let Some(node) = queue.pop_front() {
        result.push(node);
        for &neighbor in &graph[node] {
            if !visited[neighbor] {
                visited[neighbor] = true;
                queue.push_back(neighbor);
            }
        }
    }
    result
}

fn main() {
    let graph = vec![
        vec![1, 2],
        vec![0, 3],
        vec![0, 4],
        vec![1],
        vec![2],
    ];
    let result = bfs(&graph, 0);
    println!("Output: {:?}", result);
}
