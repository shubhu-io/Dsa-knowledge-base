class TreeNode(val value: Int) {
  var left: Option[TreeNode] = None
  var right: Option[TreeNode] = None
}

class BinaryTree {
  private var root: Option[TreeNode] = None

  def insert(value: Int): Unit = {
    val newNode = new TreeNode(value)
    root match {
      case None => root = Some(newNode)
      case Some(r) =>
        var current = r
        var done = false
        while (!done) {
          if (value < current.value) {
            current.left match {
              case None =>
                current.left = Some(newNode)
                done = true
              case Some(left) => current = left
            }
          } else if (value > current.value) {
            current.right match {
              case None =>
                current.right = Some(newNode)
                done = true
              case Some(right) => current = right
            }
          } else {
            done = true // Duplicate
          }
        }
    }
  }

  def inorder(node: Option[TreeNode] = root): Unit = {
    node match {
      case None =>
      case Some(n) =>
        inorder(n.left)
        print(s"${n.value} ")
        inorder(n.right)
    }
  }

  def search(value: Int): Boolean = {
    var current = root
    while (current.isDefined) {
      val n = current.get
      if (value == n.value) return true
      current = if (value < n.value) n.left else n.right
    }
    false
  }
}

object BinaryTreeApp extends App {
  val tree = new BinaryTree()
  List(50, 30, 70, 20, 40, 60, 80).foreach(tree.insert)

  print("Inorder: ")
  tree.inorder()
  println()

  println(s"Search 40: ${tree.search(40)}")
  println(s"Search 90: ${tree.search(90)}")
}