/*
Problem: Maximum Depth of Binary Tree
Description: Find maximum depth (height) of a binary tree.

Approach:
- Recursively compute max depth of left and right subtrees, add 1

Time Complexity: O(n)
Space Complexity: O(n)

Example:
Input: root=3, left=9, right=20, right.left=15, right.right=7
Output: 3
*/

class TreeNode {
  constructor(
    public val: number,
    public left: TreeNode | null = null,
    public right: TreeNode | null = null
  ) {}
}

function maxDepth(root: TreeNode | null): number {
  if (!root) return 0;
  return 1 + Math.max(maxDepth(root.left), maxDepth(root.right));
}

const root = new TreeNode(3,
  new TreeNode(9),
  new TreeNode(20, new TreeNode(15), new TreeNode(7))
);

console.log('Max depth:', maxDepth(root));
