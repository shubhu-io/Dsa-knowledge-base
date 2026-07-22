<?php

/*
Problem: Binary Tree Traversals
Description: Perform inorder, preorder, and postorder traversals on a binary tree.

Approach:
- Inorder: left -> root -> right
- Preorder: root -> left -> right
- Postorder: left -> right -> root

Time Complexity: O(n)
Space Complexity: O(n) (recursion stack)

Example:
Input:  Tree: 1 -> (2, 3) where 2 -> (4, 5)
Output:
  Inorder:   4 2 5 1 3
  Preorder:  1 2 4 5 3
  Postorder: 4 5 2 3 1
*/

class TreeNode {
    public $val;
    public $left;
    public $right;

    public function __construct($val = 0, $left = null, $right = null) {
        $this->val = $val;
        $this->left = $left;
        $this->right = $right;
    }
}

function inorder(?TreeNode $root, array &$result): void {
    if ($root === null) return;
    inorder($root->left, $result);
    $result[] = $root->val;
    inorder($root->right, $result);
}

function preorder(?TreeNode $root, array &$result): void {
    if ($root === null) return;
    $result[] = $root->val;
    preorder($root->left, $result);
    preorder($root->right, $result);
}

function postorder(?TreeNode $root, array &$result): void {
    if ($root === null) return;
    postorder($root->left, $result);
    postorder($root->right, $result);
    $result[] = $root->val;
}

$root = new TreeNode(1,
    new TreeNode(2, new TreeNode(4), new TreeNode(5)),
    new TreeNode(3)
);

$in = []; inorder($root, $in);
$pre = []; preorder($root, $pre);
$post = []; postorder($root, $post);

echo "Inorder:   " . implode(" ", $in) . "\n";
echo "Preorder:  " . implode(" ", $pre) . "\n";
echo "Postorder: " . implode(" ", $post) . "\n";
