/*
 * Problem: Traverse a graph using Breadth-First Search (BFS).
 * Approach: Use a queue to explore neighbors level by level.
 * Time Complexity: O(V + E)
 * Space Complexity: O(V)
 * Example: Graph: 0-1, 0-2, 1-3, 1-4, 2-5, 2-6 -> BFS from 0: [0, 1, 2, 3, 4, 5, 6]
 */

import java.util.*

fun bfs(graph: Map<Int, List<Int>>, start: Int): List<Int> {
    val result = mutableListOf<Int>()
    val queue: Queue<Int> = LinkedList()
    val visited = mutableSetOf<Int>()
    queue.offer(start)
    visited.add(start)
    while (queue.isNotEmpty()) {
        val node = queue.poll()
        result.add(node)
        for (neighbor in graph[node].orEmpty()) {
            if (neighbor !in visited) {
                visited.add(neighbor)
                queue.offer(neighbor)
            }
        }
    }
    return result
}

fun main() {
    val graph = mapOf(
        0 to listOf(1, 2),
        1 to listOf(3, 4),
        2 to listOf(5, 6)
    )
    println(bfs(graph, 0))
}
