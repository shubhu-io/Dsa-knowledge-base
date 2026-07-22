/*
 * Problem: Represent a graph using an adjacency list and perform basic operations.
 * Approach: Use a HashMap mapping vertices to lists of neighbors.
 * Time Complexity: O(V + E) for traversal
 * Space Complexity: O(V + E)
 * Example: addEdge(0,1), addEdge(0,2), getNeighbors(0) -> [1, 2]
 */

class GraphAdjacencyList {
    private val adj = mutableMapOf<Int, MutableList<Int>>()

    fun addVertex(v: Int) { adj.putIfAbsent(v, mutableListOf()) }

    fun addEdge(u: Int, v: Int) {
        adj.putIfAbsent(u, mutableListOf())
        adj.putIfAbsent(v, mutableListOf())
        adj[u]!!.add(v)
        adj[v]!!.add(u)
    }

    fun getNeighbors(v: Int) = adj[v] ?: emptyList()

    fun printGraph() {
        for ((key, value) in adj) {
            println("$key -> $value")
        }
    }
}

fun main() {
    val g = GraphAdjacencyList()
    g.addEdge(0, 1); g.addEdge(0, 2)
    g.addEdge(1, 2); g.addEdge(1, 3)
    g.printGraph()
}
