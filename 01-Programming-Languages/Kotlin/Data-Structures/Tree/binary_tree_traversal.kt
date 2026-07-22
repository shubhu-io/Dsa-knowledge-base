/*
 * Problem: Perform inorder, preorder, and postorder traversal of a binary tree.
 * Approach: Recursive traversal.
 * Time Complexity: O(n)
 * Space Complexity: O(n) (recursion stack)
 * Example: Tree: 1 -> left: 2, right: 3 -> Inorder: [2,1,3], Preorder: [1,2,3], Postorder: [2,3,1]
 */

class TreeNode(var `val`: Int) {
    var left: TreeNode? = null
    var right: TreeNode? = null
}

fun inorder(root: TreeNode?): List<Int> {
    val result = mutableListOf<Int>()
    fun helper(node: TreeNode?) {
        if (node == null) return
        helper(node.left)
        result.add(node.`val`)
        helper(node.right)
    }
    helper(root)
    return result
}

fun preorder(root: TreeNode?): List<Int> {
    val result = mutableListOf<Int>()
    fun helper(node: TreeNode?) {
        if (node == null) return
        result.add(node.`val`)
        helper(node.left)
        helper(node.right)
    }
    helper(root)
    return result
}

fun postorder(root: TreeNode?): List<Int> {
    val result = mutableListOf<Int>()
    fun helper(node: TreeNode?) {
        if (node == null) return
        helper(node.left)
        helper(node.right)
        result.add(node.`val`)
    }
    helper(root)
    return result
}

fun main() {
    val root = TreeNode(1)
    root.left = TreeNode(2)
    root.right = TreeNode(3)
    println("Inorder: ${inorder(root)}")
    println("Preorder: ${preorder(root)}")
    println("Postorder: ${postorder(root)}")
}
