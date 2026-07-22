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

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

typedef struct AdjNode
{
    int v;
    struct AdjNode *next;
} AdjNode;

typedef struct Graph
{
    int num_vertices;
    AdjNode **adj_lists;
} Graph;

AdjNode *new_adj_node(int v)
{
    AdjNode *n = (AdjNode *)malloc(sizeof(AdjNode));
    n->v = v;
    n->next = NULL;
    return n;
}

Graph *create_graph(int vertices)
{
    Graph *g = (Graph *)malloc(sizeof(Graph));
    g->num_vertices = vertices;
    g->adj_lists = (AdjNode **)calloc(vertices, sizeof(AdjNode *));
    return g;
}

void add_edge(Graph *g, int src, int dest)
{
    AdjNode *n = new_adj_node(dest);
    n->next = g->adj_lists[src];
    g->adj_lists[src] = n;
    n = new_adj_node(src);
    n->next = g->adj_lists[dest];
    g->adj_lists[dest] = n;
}

void dfs_util(Graph *g, int v, bool visited[])
{
    visited[v] = true;
    printf("%d ", v);
    AdjNode *cur = g->adj_lists[v];
    while (cur)
    {
        if (!visited[cur->v]) dfs_util(g, cur->v, visited);
        cur = cur->next;
    }
}

void dfs(Graph *g, int start)
{
    bool *visited = (bool *)calloc(g->num_vertices, sizeof(bool));
    dfs_util(g, start, visited);
    printf("\n");
    free(visited);
}

int main()
{
    Graph *g = create_graph(4);
    add_edge(g, 0, 1);
    add_edge(g, 0, 2);
    add_edge(g, 1, 2);
    add_edge(g, 2, 3);
    printf("DFS from 0: ");
    dfs(g, 0);
    return 0;
}
