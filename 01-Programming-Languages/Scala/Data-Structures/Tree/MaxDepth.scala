// Problem: Maximum Depth of Binary Tree
// Description: Find the maximum depth (height) of a binary tree.
//
// Approach:
// - Recursively compute depth of left and right subtrees
// - Return max of the two plus 1
//
// Time Complexity: O(n)
// Space Complexity: O(h) where h is tree height
//
// Example:
// Input: Tree: 3 -> (9, 20 -> (15, 7))
// Output: 3

object MaxDepth {
  class TreeNode(var val: Int = 0, var left: TreeNode = null, var right: TreeNode = null)

  def maxDepth(root: TreeNode): Int = {
    if (root == null) return 0
    1 + math.max(maxDepth(root.left), maxDepth(root.right))
  }

  def main(args: Array[String]): Unit = {
    val root = new TreeNode(3,
      new TreeNode(9),
      new TreeNode(20, new TreeNode(15), new TreeNode(7))
    )
    println(s"Max depth: ${maxDepth(root)}")

    val root2 = new TreeNode(1, null, new TreeNode(2, null, new TreeNode(3)))
    println(s"Max depth (skewed): ${maxDepth(root2)}")
  }
}
