/*
Problem: Graph as Adjacency List
Implement a graph using adjacency list and perform DFS traversal.

Approach:
- Array of linked lists to represent edges

Time Complexity: O(V + E)
Space Complexity: O(V + E)

Example:
Input: 4 vertices, edges: (0,1),(0,2),(1,2),(2,3)
Output: DFS: 0 1 2 3
*/

#include <iostream>
#include <vector>
#include <list>
using namespace std;

class Graph
{
    int V;
    vector<list<int>> adj;

    void dfs_util(int v, vector<bool>& visited)
    {
        visited[v] = true;
        cout << v << " ";
        for (int u : adj[v])
            if (!visited[u]) dfs_util(u, visited);
    }

public:
    Graph(int vertices) : V(vertices), adj(vertices) {}

    void add_edge(int src, int dest)
    {
        adj[src].push_back(dest);
        adj[dest].push_back(src);
    }

    void dfs(int start)
    {
        vector<bool> visited(V, false);
        dfs_util(start, visited);
        cout << endl;
    }
};

int main()
{
    Graph g(4);
    g.add_edge(0, 1);
    g.add_edge(0, 2);
    g.add_edge(1, 2);
    g.add_edge(2, 3);
    cout << "DFS from 0: ";
    g.dfs(0);
    return 0;
}
