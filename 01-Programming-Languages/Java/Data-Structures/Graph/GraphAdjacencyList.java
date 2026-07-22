/*
 * Problem: Represent a graph using an adjacency list and perform basic operations.
 * Approach: Use a HashMap mapping vertices to lists of neighbors.
 * Time Complexity: O(V + E) for traversal
 * Space Complexity: O(V + E)
 * Example: addEdge(0,1), addEdge(0,2), getNeighbors(0) -> [1, 2]
 */

import java.util.*;

public class GraphAdjacencyList {
    private Map<Integer, List<Integer>> adj = new HashMap<>();

    public void addVertex(int v) {
        adj.putIfAbsent(v, new ArrayList<>());
    }

    public void addEdge(int u, int v) {
        adj.putIfAbsent(u, new ArrayList<>());
        adj.putIfAbsent(v, new ArrayList<>());
        adj.get(u).add(v);
        adj.get(v).add(u);
    }

    public List<Integer> getNeighbors(int v) {
        return adj.getOrDefault(v, Collections.emptyList());
    }

    public void printGraph() {
        for (var entry : adj.entrySet()) {
            System.out.println(entry.getKey() + " -> " + entry.getValue());
        }
    }

    public static void main(String[] args) {
        GraphAdjacencyList g = new GraphAdjacencyList();
        g.addEdge(0, 1);
        g.addEdge(0, 2);
        g.addEdge(1, 2);
        g.addEdge(1, 3);
        g.printGraph();
    }
}
