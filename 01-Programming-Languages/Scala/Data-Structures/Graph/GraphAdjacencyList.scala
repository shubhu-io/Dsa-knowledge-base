// Problem: Graph as Adjacency List
// Description: Build and traverse a graph using adjacency list representation.
//
// Approach:
// - Store neighbors for each vertex in an array of lists
// - Provide addEdge and display methods
//
// Time Complexity: O(V + E) for traversal
// Space Complexity: O(V + E)
//
// Example:
// Input: addEdge(1,2), addEdge(1,3), addEdge(2,4)
// Output: Graph with 4 vertices

object GraphAdjacencyList {
  class Graph(vertices: Int) {
    val adj: Array[scala.collection.mutable.ListBuffer[Int]] =
      Array.fill(vertices)(scala.collection.mutable.ListBuffer[Int]())

    def addEdge(u: Int, v: Int): Unit = {
      adj(u) += v
      adj(v) += u
    }

    def display(): Unit = {
      for (i <- 0 until vertices) {
        println(s"$i -> ${adj(i).mkString(", ")}")
      }
    }
  }

  def main(args: Array[String]): Unit = {
    val g = new Graph(5)
    g.addEdge(0, 1)
    g.addEdge(0, 2)
    g.addEdge(1, 3)
    g.addEdge(2, 4)
    g.addEdge(3, 4)
    println("Adjacency List:")
    g.display()
  }
}
