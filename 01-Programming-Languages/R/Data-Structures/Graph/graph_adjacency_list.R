# Problem: Graph as Adjacency List
# Description: Build and traverse a graph using adjacency list representation.
#
# Approach:
# - Store neighbors for each vertex in a list
# - Provide add_edge and display methods
#
# Time Complexity: O(V + E) for traversal
# Space Complexity: O(V + E)
#
# Example:
# Input: add_edge(1,2), add_edge(1,3), add_edge(2,4)
# Output: Graph with 4 vertices

Graph <- function(vertices) {
  list(vertices = vertices, adj = vector("list", vertices))
}

add_edge <- function(graph, u, v) {
  graph$adj[[u]] <- c(graph$adj[[u]], v)
  graph$adj[[v]] <- c(graph$adj[[v]], u)
  graph
}

display_graph <- function(graph) {
  for (i in 1:graph$vertices) {
    cat(i, "->", graph$adj[[i]], "\n")
  }
}

g <- Graph(5)
g <- add_edge(g, 1, 2)
g <- add_edge(g, 1, 3)
g <- add_edge(g, 2, 4)
g <- add_edge(g, 3, 5)
g <- add_edge(g, 4, 5)

cat("Adjacency List:\n")
display_graph(g)
