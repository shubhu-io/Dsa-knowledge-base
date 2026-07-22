/*
Problem: Binary Tree Traversals
Description: Inorder, preorder, and postorder traversals of a binary tree.

Approach:
- Inorder: left, root, right
- Preorder: root, left, right
- Postorder: left, right, root

Time Complexity: O(n)
Space Complexity: O(n)

Example:
Input: root=1, left=2, right=3, left.left=4, left.right=5
Output:
  Inorder: [4, 2, 5, 1, 3]
  Preorder: [1, 2, 4, 5, 3]
  Postorder: [4, 5, 2, 3, 1]
*/

class TreeNode {
  constructor(
    public val: number,
    public left: TreeNode | null = null,
    public right: TreeNode | null = null
  ) {}
}

function inorder(root: TreeNode | null, result: number[] = []): number[] {
  if (!root) return result;
  inorder(root.left, result);
  result.push(root.val);
  inorder(root.right, result);
  return result;
}

function preorder(root: TreeNode | null, result: number[] = []): number[] {
  if (!root) return result;
  result.push(root.val);
  preorder(root.left, result);
  preorder(root.right, result);
  return result;
}

function postorder(root: TreeNode | null, result: number[] = []): number[] {
  if (!root) return result;
  postorder(root.left, result);
  postorder(root.right, result);
  result.push(root.val);
  return result;
}

const root = new TreeNode(1,
  new TreeNode(2, new TreeNode(4), new TreeNode(5)),
  new TreeNode(3)
);

console.log('Inorder:', inorder(root));
console.log('Preorder:', preorder(root));
console.log('Postorder:', postorder(root));
