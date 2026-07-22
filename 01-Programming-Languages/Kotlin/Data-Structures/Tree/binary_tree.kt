class TreeNode(val value: Int) {
    var left: TreeNode? = null
    var right: TreeNode? = null
}

class BinaryTree {
    var root: TreeNode? = null

    fun insert(value: Int) {
        val newNode = TreeNode(value)
        if (root == null) {
            root = newNode
            return
        }

        var current = root!!
        while (true) {
            if (value < current.value) {
                if (current.left == null) {
                    current.left = newNode
                    return
                }
                current = current.left!!
            } else if (value > current.value) {
                if (current.right == null) {
                    current.right = newNode
                    return
                }
                current = current.right!!
            } else {
                return // Duplicate
            }
        }
    }

    fun inorder(node: TreeNode? = root) {
        if (node != null) {
            inorder(node.left)
            print("${node.value} ")
            inorder(node.right)
        }
    }

    fun search(value: Int): Boolean {
        var current = root
        while (current != null) {
            when {
                value == current.value -> return true
                value < current.value -> current = current.left
                else -> current = current.right
            }
        }
        return false
    }
}

fun main() {
    val tree = BinaryTree()
    listOf(50, 30, 70, 20, 40, 60, 80).forEach { tree.insert(it) }

    print("Inorder: ")
    tree.inorder()
    println()

    println("Search 40: ${tree.search(40)}")
    println("Search 90: ${tree.search(90)}")
}