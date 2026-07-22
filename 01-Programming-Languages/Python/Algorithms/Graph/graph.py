"""
Graph Algorithms in Python

Covers BFS, DFS, shortest path, cycle detection, and topological sort.
"""

from typing import List, Dict, Set, Optional, Tuple
from collections import deque, defaultdict
import heapq


# ============================================================
# Graph Representations
# ============================================================

class Graph:
    """
    Undirected graph using adjacency list.

    Supports both weighted and unweighted edges.
    """

    def __init__(self, directed: bool = False):
        self.directed = directed
        self.adj: Dict[str, List[Tuple[str, int]]] = defaultdict(list)

    def add_edge(self, u: str, v: str, weight: int = 1) -> None:
        self.adj[u].append((v, weight))
        if not self.directed:
            self.adj[v].append((u, weight))

    def get_neighbors(self, node: str) -> List[Tuple[str, int]]:
        return self.adj[node]

    def get_nodes(self) -> Set[str]:
        nodes = set(self.adj.keys())
        for neighbors in self.adj.values():
            for v, _ in neighbors:
                nodes.add(v)
        return nodes


# ============================================================
# 1. BFS (Breadth-First Search)
# ============================================================

def bfs(graph: Graph, start: str) -> List[str]:
    """
    BFS traversal.

    Time: O(V + E)  |  Space: O(V)
    """
    visited = set([start])
    queue = deque([start])
    order = []

    while queue:
        node = queue.popleft()
        order.append(node)

        for neighbor, _ in graph.get_neighbors(node):
            if neighbor not in visited:
                visited.add(neighbor)
                queue.append(neighbor)

    return order


def bfs_shortest_path(graph: Graph, start: str, target: str) -> Optional[List[str]]:
    """
    Find shortest path (unweighted) using BFS.

    Time: O(V + E)  |  Space: O(V)
    """
    if start == target:
        return [start]

    visited = set([start])
    queue = deque([(start, [start])])

    while queue:
        node, path = queue.popleft()

        for neighbor, _ in graph.get_neighbors(node):
            if neighbor == target:
                return path + [neighbor]
            if neighbor not in visited:
                visited.add(neighbor)
                queue.append((neighbor, path + [neighbor]))

    return None


# ============================================================
# 2. DFS (Depth-First Search)
# ============================================================

def dfs_recursive(graph: Graph, start: str) -> List[str]:
    """
    DFS traversal (recursive).

    Time: O(V + E)  |  Space: O(V)
    """
    visited = set()
    order = []

    def helper(node: str) -> None:
        visited.add(node)
        order.append(node)
        for neighbor, _ in graph.get_neighbors(node):
            if neighbor not in visited:
                helper(neighbor)

    helper(start)
    return order


def dfs_iterative(graph: Graph, start: str) -> List[str]:
    """
    DFS traversal (iterative using stack).

    Time: O(V + E)  |  Space: O(V)
    """
    visited = set()
    stack = [start]
    order = []

    while stack:
        node = stack.pop()
        if node not in visited:
            visited.add(node)
            order.append(node)
            for neighbor, _ in reversed(graph.get_neighbors(node)):
                if neighbor not in visited:
                    stack.append(neighbor)

    return order


def dfs_path(graph: Graph, start: str, target: str) -> Optional[List[str]]:
    """Find a path between start and target using DFS."""
    visited = set()

    def helper(node: str, path: List[str]) -> Optional[List[str]]:
        if node == target:
            return path
        visited.add(node)
        for neighbor, _ in graph.get_neighbors(node):
            if neighbor not in visited:
                result = helper(neighbor, path + [neighbor])
                if result:
                    return result
        return None

    return helper(start, [start])


# ============================================================
# 3. Dijkstra's Shortest Path
# ============================================================

def dijkstra(graph: Graph, start: str) -> Dict[str, int]:
    """
    Find shortest distances from start to all nodes.

    Time: O((V + E) log V)  |  Space: O(V)
    """
    distances = {node: float('inf') for node in graph.get_nodes()}
    distances[start] = 0
    min_heap = [(0, start)]
    visited = set()

    while min_heap:
        dist, node = heapq.heappop(min_heap)

        if node in visited:
            continue
        visited.add(node)

        for neighbor, weight in graph.get_neighbors(node):
            if neighbor not in visited:
                new_dist = dist + weight
                if new_dist < distances[neighbor]:
                    distances[neighbor] = new_dist
                    heapq.heappush(min_heap, (new_dist, neighbor))

    return distances


# ============================================================
# 4. Cycle Detection
# ============================================================

def has_cycle_undirected(graph: Graph) -> bool:
    """Detect cycle in undirected graph using DFS."""
    visited = set()

    def dfs(node: str, parent: str) -> bool:
        visited.add(node)
        for neighbor, _ in graph.get_neighbors(node):
            if neighbor not in visited:
                if dfs(neighbor, node):
                    return True
            elif neighbor != parent:
                return True
        return False

    for node in graph.get_nodes():
        if node not in visited:
            if dfs(node, ""):
                return True
    return False


def has_cycle_directed(graph: Graph) -> bool:
    """Detect cycle in directed graph using DFS with colors."""
    WHITE, GRAY, BLACK = 0, 1, 2
    color = {node: WHITE for node in graph.get_nodes()}

    def dfs(node: str) -> bool:
        color[node] = GRAY
        for neighbor, _ in graph.get_neighbors(node):
            if color[neighbor] == GRAY:
                return True
            if color[neighbor] == WHITE and dfs(neighbor):
                return True
        color[node] = BLACK
        return False

    for node in graph.get_nodes():
        if color[node] == WHITE:
            if dfs(node):
                return True
    return False


# ============================================================
# 5. Topological Sort (Kahn's Algorithm)
# ============================================================

def topological_sort(graph: Graph) -> Optional[List[str]]:
    """
    Topological sort using Kahn's algorithm.

    Returns None if graph has a cycle.
    Time: O(V + E)  |  Space: O(V)
    """
    in_degree = {node: 0 for node in graph.get_nodes()}
    for node in graph.get_nodes():
        for neighbor, _ in graph.get_neighbors(node):
            in_degree[neighbor] = in_degree.get(neighbor, 0) + 1

    queue = deque([node for node, deg in in_degree.items() if deg == 0])
    result = []

    while queue:
        node = queue.popleft()
        result.append(node)

        for neighbor, _ in graph.get_neighbors(node):
            in_degree[neighbor] -= 1
            if in_degree[neighbor] == 0:
                queue.append(neighbor)

    if len(result) != len(in_degree):
        return None  # Cycle exists

    return result


# ============================================================
# 6. Connected Components
# ============================================================

def connected_components(graph: Graph) -> List[List[str]]:
    """Find all connected components in an undirected graph."""
    visited = set()
    components = []

    def dfs(node: str, component: List[str]) -> None:
        visited.add(node)
        component.append(node)
        for neighbor, _ in graph.get_neighbors(node):
            if neighbor not in visited:
                dfs(neighbor, component)

    for node in graph.get_nodes():
        if node not in visited:
            component = []
            dfs(node, component)
            components.append(sorted(component))

    return components


# ============================================================
# Demo
# ============================================================

if __name__ == "__main__":
    # Build a sample graph
    g = Graph()
    g.add_edge("A", "B")
    g.add_edge("A", "C")
    g.add_edge("B", "D")
    g.add_edge("B", "E")
    g.add_edge("C", "F")
    g.add_edge("E", "F")

    print("=== BFS ===")
    print(f"From A: {bfs(g, 'A')}")
    print(f"Shortest path A->F: {bfs_shortest_path(g, 'A', 'F')}")

    print("\n=== DFS ===")
    print(f"Recursive from A: {dfs_recursive(g, 'A')}")
    print(f"Iterative from A: {dfs_iterative(g, 'A')}")
    print(f"Path A->F: {dfs_path(g, 'A', 'F')}")

    # Weighted graph for Dijkstra
    print("\n=== Dijkstra ===")
    wg = Graph(directed=True)
    wg.add_edge("A", "B", 4)
    wg.add_edge("A", "C", 2)
    wg.add_edge("B", "C", 1)
    wg.add_edge("B", "D", 5)
    wg.add_edge("C", "D", 8)
    wg.add_edge("C", "E", 10)
    wg.add_edge("D", "E", 2)
    wg.add_edge("E", "A", 7)

    distances = dijkstra(wg, "A")
    print(f"Distances from A: {distances}")

    # Cycle detection
    print("\n=== Cycle Detection ===")
    cycle_graph = Graph()
    cycle_graph.add_edge("A", "B")
    cycle_graph.add_edge("B", "C")
    cycle_graph.add_edge("C", "A")
    print(f"Undirected cycle: {has_cycle_undirected(cycle_graph)}")

    dag = Graph(directed=True)
    dag.add_edge("A", "B")
    dag.add_edge("A", "C")
    dag.add_edge("B", "D")
    dag.add_edge("C", "D")
    print(f"Directed acyclic: {not has_cycle_directed(dag)}")

    # Topological Sort
    print("\n=== Topological Sort ===")
    course_graph = Graph(directed=True)
    course_graph.add_edge("A", "B")
    course_graph.add_edge("A", "C")
    course_graph.add_edge("B", "D")
    course_graph.add_edge("C", "D")
    course_graph.add_edge("D", "E")
    topo = topological_sort(course_graph)
    print(f"Order: {topo}")

    # Connected Components
    print("\n=== Connected Components ===")
    disconnected = Graph()
    disconnected.add_edge("1", "2")
    disconnected.add_edge("3", "4")
    disconnected.add_edge("5", "6")
    components = connected_components(disconnected)
    print(f"Components: {components}")
