/*
 * Problem: Find the maximum depth of a binary tree.
 * Approach: Recursively compute max depth of left and right subtrees.
 * Time Complexity: O(n)
 * Space Complexity: O(n) (recursion stack)
 * Example: Tree: 3 -> left: 9, right: 20 -> 20 -> left: 15, right: 7 -> Output: 3
 */

class TreeNode(var `val`: Int) {
    var left: TreeNode? = null
    var right: TreeNode? = null
}

fun maxDepth(root: TreeNode?): Int {
    if (root == null) return 0
    return 1 + maxOf(maxDepth(root.left), maxDepth(root.right))
}

fun main() {
    val root = TreeNode(3)
    root.left = TreeNode(9)
    root.right = TreeNode(20)
    root.right!!.left = TreeNode(15)
    root.right!!.right = TreeNode(7)
    println(maxDepth(root))
}
