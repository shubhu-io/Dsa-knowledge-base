/*
 * Problem: Traverse a graph using Breadth-First Search (BFS).
 * Approach: Use a queue to explore neighbors level by level.
 * Time Complexity: O(V + E)
 * Space Complexity: O(V)
 * Example: Graph: 0-1, 0-2, 1-3, 1-4, 2-5, 2-6 -> BFS from 0: 0 1 2 3 4 5 6
 */

import java.util.*;

public class BFS {
    public static List<Integer> bfs(Map<Integer, List<Integer>> graph, int start) {
        List<Integer> result = new ArrayList<>();
        Queue<Integer> queue = new LinkedList<>();
        Set<Integer> visited = new HashSet<>();
        queue.offer(start);
        visited.add(start);
        while (!queue.isEmpty()) {
            int node = queue.poll();
            result.add(node);
            for (int neighbor : graph.getOrDefault(node, Collections.emptyList())) {
                if (!visited.contains(neighbor)) {
                    visited.add(neighbor);
                    queue.offer(neighbor);
                }
            }
        }
        return result;
    }

    public static void main(String[] args) {
        Map<Integer, List<Integer>> graph = new HashMap<>();
        graph.put(0, Arrays.asList(1, 2));
        graph.put(1, Arrays.asList(3, 4));
        graph.put(2, Arrays.asList(5, 6));
        System.out.println(bfs(graph, 0));
    }
}
