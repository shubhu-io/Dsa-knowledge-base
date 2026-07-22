# Problem: Breadth-First Search (BFS)
# Description: Traverse a graph level by level starting from a source node.
#
# Approach:
# - Use a queue to explore neighbors of current node
# - Track visited nodes to avoid cycles
#
# Time Complexity: O(V + E)
# Space Complexity: O(V)
#
# Example:
# Input: graph with 6 nodes, start = 1
# Output: 1 2 3 4 5 6

bfs <- function(graph, start) {
  visited <- rep(FALSE, length(graph))
  queue <- c(start)
  visited[start] <- TRUE
  result <- c()
  while (length(queue) > 0) {
    node <- queue[1]
    queue <- queue[-1]
    result <- c(result, node)
    for (neighbor in graph[[node]]) {
      if (!visited[neighbor]) {
        visited[neighbor] <- TRUE
        queue <- c(queue, neighbor)
      }
    }
  }
  result
}

graph <- list(
  `1` = c(2, 3),
  `2` = c(1, 4, 5),
  `3` = c(1, 6),
  `4` = c(2),
  `5` = c(2),
  `6` = c(3)
)
cat("BFS from node 1:", bfs(graph, 1), "\n")
