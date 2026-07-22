/*
Problem: Binary Tree Traversals
Description: Perform inorder, preorder, and postorder traversals
           of a binary tree.

Approach:
- Inorder: left, root, right
- Preorder: root, left, right
- Postorder: left, right, root
- All implemented recursively

Time Complexity: O(n)
Space Complexity: O(h) where h is height of tree (recursion stack)

Example:
Input: Tree: 1, 2, 3, 4, 5 (in level order)
Output: Inorder: [4,2,5,1,3], Preorder: [1,2,4,5,3], Postorder: [4,5,2,3,1]
*/

class TreeNode {
  int val;
  TreeNode? left;
  TreeNode? right;
  TreeNode(this.val);
}

List<int> inorder(TreeNode? root) {
  if (root == null) return [];
  return [...inorder(root.left), root.val, ...inorder(root.right)];
}

List<int> preorder(TreeNode? root) {
  if (root == null) return [];
  return [root.val, ...preorder(root.left), ...preorder(root.right)];
}

List<int> postorder(TreeNode? root) {
  if (root == null) return [];
  return [...postorder(root.left), ...postorder(root.right), root.val];
}

void main() {
  TreeNode root = TreeNode(1);
  root.left = TreeNode(2);
  root.right = TreeNode(3);
  root.left!.left = TreeNode(4);
  root.left!.right = TreeNode(5);
  print('Inorder: ${inorder(root)}');
  print('Preorder: ${preorder(root)}');
  print('Postorder: ${postorder(root)}');
}
