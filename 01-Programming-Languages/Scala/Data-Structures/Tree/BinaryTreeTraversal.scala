// Problem: Binary Tree Traversals
// Description: Perform inorder, preorder, and postorder traversals.
//
// Approach:
// - Inorder: left, root, right
// - Preorder: root, left, right
// - Postorder: left, right, root
//
// Time Complexity: O(n)
// Space Complexity: O(h) where h is tree height
//
// Example:
// Input: Tree: 1 -> (2, 3)
// Output: Inorder: 2 1 3, Preorder: 1 2 3, Postorder: 2 3 1

object BinaryTreeTraversal {
  class TreeNode(var val: Int = 0, var left: TreeNode = null, var right: TreeNode = null)

  def inorder(root: TreeNode): Vector[Int] = {
    if (root == null) return Vector()
    inorder(root.left) ++ Vector(root.val) ++ inorder(root.right)
  }

  def preorder(root: TreeNode): Vector[Int] = {
    if (root == null) return Vector()
    Vector(root.val) ++ preorder(root.left) ++ preorder(root.right)
  }

  def postorder(root: TreeNode): Vector[Int] = {
    if (root == null) return Vector()
    postorder(root.left) ++ postorder(root.right) ++ Vector(root.val)
  }

  def main(args: Array[String]): Unit = {
    val root = new TreeNode(1,
      new TreeNode(2, new TreeNode(4), new TreeNode(5)),
      new TreeNode(3, new TreeNode(6), new TreeNode(7))
    )
    println(s"Inorder: ${inorder(root).mkString(" ")}")
    println(s"Preorder: ${preorder(root).mkString(" ")}")
    println(s"Postorder: ${postorder(root).mkString(" ")}")
  }
}
