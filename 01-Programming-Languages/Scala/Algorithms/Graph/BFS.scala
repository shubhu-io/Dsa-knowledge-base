// Problem: Breadth-First Search (BFS)
// Description: Traverse a graph level by level starting from a source node.
//
// Approach:
// - Use a queue to explore neighbors of current node
// - Track visited nodes to avoid cycles
//
// Time Complexity: O(V + E)
// Space Complexity: O(V)
//
// Example:
// Input: graph with 6 nodes, start = 0
// Output: Array(0, 1, 2, 3, 4, 5)

object BFS {
  def traverse(graph: Array[Array[Int]], start: Int): Array[Int] = {
    val visited = Array.fill(graph.length)(false)
    val result = scala.collection.mutable.ArrayBuffer[Int]()
    val queue = scala.collection.mutable.Queue[Int]()
    visited(start) = true
    queue.enqueue(start)
    while (queue.nonEmpty) {
      val node = queue.dequeue()
      result += node
      for (neighbor <- graph(node)) {
        if (!visited(neighbor)) {
          visited(neighbor) = true
          queue.enqueue(neighbor)
        }
      }
    }
    result.toArray
  }

  def main(args: Array[String]): Unit = {
    val graph = Array(
      Array(1, 2),
      Array(0, 3, 4),
      Array(0, 5),
      Array(1),
      Array(1),
      Array(2)
    )
    val result = traverse(graph, 0)
    println(s"BFS from node 0: ${result.mkString(", ")}")
  }
}
