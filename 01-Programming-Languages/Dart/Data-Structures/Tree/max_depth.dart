/*
Problem: Maximum Depth of Binary Tree
Description: Find the maximum depth (height) of a binary tree.

Approach:
- Recursively compute max depth of left and right subtrees
- Return 1 + max(leftDepth, rightDepth)
- Base case: null node has depth 0

Time Complexity: O(n)
Space Complexity: O(h) where h is height of tree

Example:
Input: Tree: 3 -> 9, 20 -> 15, 7
Output: 3
*/

class TreeNode {
  int val;
  TreeNode? left;
  TreeNode? right;
  TreeNode(this.val);
}

int maxDepth(TreeNode? root) {
  if (root == null) return 0;
  return 1 + (maxDepth(root.left) > maxDepth(root.right) ? maxDepth(root.left) : maxDepth(root.right));
}

void main() {
  TreeNode root = TreeNode(3);
  root.left = TreeNode(9);
  root.right = TreeNode(20);
  root.right!.left = TreeNode(15);
  root.right!.right = TreeNode(7);
  print('Max depth: ${maxDepth(root)}');
}
