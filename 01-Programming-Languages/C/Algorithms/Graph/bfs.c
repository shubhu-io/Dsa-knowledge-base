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

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define MAX 5

void bfs(int graph[MAX][MAX], int start, int n)
{
    bool *visited = (bool *)calloc(n, sizeof(bool));
    int *queue = (int *)malloc(n * sizeof(int));
    int front = 0, rear = 0;
    visited[start] = true;
    queue[rear++] = start;
    while (front < rear)
    {
        int u = queue[front++];
        printf("%d ", u);
        for (int v = 0; v < n; v++)
            if (graph[u][v] && !visited[v])
            {
                visited[v] = true;
                queue[rear++] = v;
            }
    }
    printf("\n");
    free(visited);
    free(queue);
}

int main()
{
    int graph[MAX][MAX] = {
        {0, 1, 1, 0, 0},
        {1, 0, 0, 1, 1},
        {1, 0, 0, 0, 0},
        {0, 1, 0, 0, 0},
        {0, 1, 0, 0, 0}
    };
    printf("BFS from vertex 0: ");
    bfs(graph, 0, MAX);
    return 0;
}
