/*
Problem: Maximum Depth of Binary Tree
Find the maximum depth (height) of a binary tree.

Approach:
- Recursive: max depth = 1 + max(left depth, right depth)

Time Complexity: O(n)
Space Complexity: O(n)

Example:
Input: Tree: 3 -> (9, 20 -> (15, 7))
Output: 3
*/

#include <stdio.h>
#include <stdlib.h>

typedef struct Node
{
    int data;
    struct Node *left;
    struct Node *right;
} Node;

Node *new_node(int data)
{
    Node *n = (Node *)malloc(sizeof(Node));
    n->data = data;
    n->left = n->right = NULL;
    return n;
}

int max_depth(Node *r)
{
    if (!r) return 0;
    int left = max_depth(r->left);
    int right = max_depth(r->right);
    return 1 + (left > right ? left : right);
}

int main()
{
    Node *root = new_node(3);
    root->left = new_node(9);
    root->right = new_node(20);
    root->right->left = new_node(15);
    root->right->right = new_node(7);
    printf("Max depth: %d\n", max_depth(root));
    return 0;
}
