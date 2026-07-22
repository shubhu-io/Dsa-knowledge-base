/*
Problem: BFS on Graph (Adjacency Matrix)
Traverse a graph using Breadth-First Search starting from a given source vertex.

Approach:
- Use a queue, mark visited nodes, process level by level

Time Complexity: O(V^2)
Space Complexity: O(V)

Example:
Input: 5 vertices, edges: (0,1),(0,2),(1,3),(1,4), start = 0
Output: 0 1 2 3 4
*/

#include <iostream>
#include <queue>
#include <vector>
using namespace std;

void bfs(const vector<vector<int>>& graph, int start)
{
    int n = graph.size();
    vector<bool> visited(n, false);
    queue<int> q;
    visited[start] = true;
    q.push(start);
    while (!q.empty())
    {
        int u = q.front(); q.pop();
        cout << u << " ";
        for (int v = 0; v < n; v++)
            if (graph[u][v] && !visited[v])
            {
                visited[v] = true;
                q.push(v);
            }
    }
    cout << endl;
}

int main()
{
    vector<vector<int>> graph = {
        {0, 1, 1, 0, 0},
        {1, 0, 0, 1, 1},
        {1, 0, 0, 0, 0},
        {0, 1, 0, 0, 0},
        {0, 1, 0, 0, 0}
    };
    cout << "BFS from vertex 0: ";
    bfs(graph, 0);
    return 0;
}
