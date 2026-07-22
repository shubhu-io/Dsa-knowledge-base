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

#include <iostream>
using namespace std;

struct Node
{
    int data;
    Node *left, *right;
    Node(int val) : data(val), left(nullptr), right(nullptr) {}
};

void inorder(Node *r)
{
    if (!r) return;
    inorder(r->left);
    cout << r->data << " ";
    inorder(r->right);
}

void preorder(Node *r)
{
    if (!r) return;
    cout << r->data << " ";
    preorder(r->left);
    preorder(r->right);
}

void postorder(Node *r)
{
    if (!r) return;
    postorder(r->left);
    postorder(r->right);
    cout << r->data << " ";
}

int main()
{
    Node *root = new Node(1);
    root->left = new Node(2);
    root->right = new Node(3);
    cout << "Inorder: "; inorder(root); cout << endl;
    cout << "Preorder: "; preorder(root); cout << endl;
    cout << "Postorder: "; postorder(root); cout << endl;
    return 0;
}
