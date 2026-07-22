/*
Problem: Graph Adjacency List
Description: Implement a graph using an adjacency list with
           addVertex, addEdge, removeEdge, display, and DFS.

Approach:
- Store graph as dictionary mapping vertex to list of neighbors
- Supports undirected graph operations
- DFS uses recursion with visited set

Time Complexity: O(V + E) for traversal
Space Complexity: O(V + E)

Example:
Input: add edges 0-1, 0-2, 1-2, 1-3
Output: DFS from 0: 0, 1, 2, 3
*/

class Graph {
    private var adjList = [Int: [Int]]()

    func addVertex(_ v: Int) {
        if adjList[v] == nil { adjList[v] = [] }
    }

    func addEdge(_ u: Int, _ v: Int) {
        addVertex(u); addVertex(v)
        adjList[u]?.append(v)
        adjList[v]?.append(u)
    }

    func removeEdge(_ u: Int, _ v: Int) {
        adjList[u]?.removeAll { $0 == v }
        adjList[v]?.removeAll { $0 == u }
    }

    func display() {
        for (vertex, neighbors) in adjList.sorted(by: { $0.key < $1.key }) {
            print("\(vertex): \(neighbors.sorted())")
        }
    }

    func dfs(from start: Int) -> [Int] {
        var visited = Set<Int>()
        var result = [Int]()
        dfsHelper(start, &visited, &result)
        return result
    }

    private func dfsHelper(_ v: Int, _ visited: inout Set<Int>, _ result: inout [Int]) {
        visited.insert(v)
        result.append(v)
        for neighbor in adjList[v] ?? [] where !visited.contains(neighbor) {
            dfsHelper(neighbor, &visited, &result)
        }
    }
}

let g = Graph()
g.addEdge(0, 1)
g.addEdge(0, 2)
g.addEdge(1, 2)
g.addEdge(1, 3)
print("Graph adjacency list:")
g.display()
print("DFS from 0: \(g.dfs(from: 0))")
