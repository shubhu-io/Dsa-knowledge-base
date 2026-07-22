<?php

/*
Problem: Maximum Depth of Binary Tree
Description: Find the maximum depth (height) of a binary tree.

Approach:
- Recursively compute depth of left and right subtrees
- Return 1 + max(leftDepth, rightDepth)
- Base case: null node returns 0

Time Complexity: O(n)
Space Complexity: O(n) (recursion stack worst-case)

Example:
Input:  Tree: 3 -> (9, 20 -> (15, 7))
Output: 3
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

function maxDepth(?TreeNode $root): int {
    if ($root === null) return 0;
    return 1 + max(maxDepth($root->left), maxDepth($root->right));
}

$root = new TreeNode(3,
    new TreeNode(9),
    new TreeNode(20, new TreeNode(15), new TreeNode(7))
);

echo "Max depth: " . maxDepth($root) . "\n";
