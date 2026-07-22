/*
Problem: BFS Traversal
Description: Perform breadth-first search on a graph represented as
           an adjacency list. Print nodes in BFS order.

Approach:
- Use a queue (array) to track nodes to visit
- Use a visited set to avoid cycles
- Process level by level

Time Complexity: O(V + E)
Space Complexity: O(V)

Example:
Input: graph = [0: [1,2], 1: [0,3,4], 2: [0,5], 3: [1], 4: [1], 5: [2]], start = 0
Output: 0 1 2 3 4 5
*/

func bfs(graph: [Int: [Int]], start: Int) {
    var visited = Set<Int>()
    var queue = [start]
    visited.insert(start)
    print("BFS starting from \(start):", terminator: " ")
    while !queue.isEmpty {
        let node = queue.removeFirst()
        print(node, terminator: " ")
        for neighbor in graph[node] ?? [] where !visited.contains(neighbor) {
            visited.insert(neighbor)
            queue.append(neighbor)
        }
    }
    print()
}

let graph: [Int: [Int]] = [
    0: [1, 2],
    1: [0, 3, 4],
    2: [0, 5],
    3: [1],
    4: [1],
    5: [2]
]
bfs(graph: graph, start: 0)
