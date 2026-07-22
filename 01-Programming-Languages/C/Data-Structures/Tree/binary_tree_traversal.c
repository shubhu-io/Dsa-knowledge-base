/*
Problem: Binary Tree Traversals (Inorder, Preorder, Postorder)
Perform inorder, preorder, and postorder traversal of a binary tree.

Approach:
- Recursive depth-first traversal

Time Complexity: O(n)
Space Complexity: O(n)

Example:
Input: Tree: 1 -> (2, 3)
Output: Inorder: 2 1 3, Preorder: 1 2 3, Postorder: 2 3 1
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

void inorder(Node *r)
{
    if (!r) return;
    inorder(r->left);
    printf("%d ", r->data);
    inorder(r->right);
}

void preorder(Node *r)
{
    if (!r) return;
    printf("%d ", r->data);
    preorder(r->left);
    preorder(r->right);
}

void postorder(Node *r)
{
    if (!r) return;
    postorder(r->left);
    postorder(r->right);
    printf("%d ", r->data);
}

int main()
{
    Node *root = new_node(1);
    root->left = new_node(2);
    root->right = new_node(3);
    printf("Inorder: "); inorder(root); printf("\n");
    printf("Preorder: "); preorder(root); printf("\n");
    printf("Postorder: "); postorder(root); printf("\n");
    return 0;
}
