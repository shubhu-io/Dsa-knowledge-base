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

#include <iostream>
#include <algorithm>
using namespace std;

struct Node
{
    int data;
    Node *left, *right;
    Node(int val) : data(val), left(nullptr), right(nullptr) {}
};

int max_depth(Node *r)
{
    if (!r) return 0;
    return 1 + max(max_depth(r->left), max_depth(r->right));
}

int main()
{
    Node *root = new Node(3);
    root->left = new Node(9);
    root->right = new Node(20);
    root->right->left = new Node(15);
    root->right->right = new Node(7);
    cout << "Max depth: " << max_depth(root) << endl;
    return 0;
}
