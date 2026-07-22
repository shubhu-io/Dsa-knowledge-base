# Problem: Binary Tree Traversals
# Description: Perform inorder, preorder, and postorder traversals.
#
# Approach:
# - Inorder: left, root, right
# - Preorder: root, left, right
# - Postorder: left, right, root
#
# Time Complexity: O(n)
# Space Complexity: O(h) where h is tree height
#
# Example:
# Input: Tree: 1 -> (2, 3)
# Output: Inorder: 2 1 3, Preorder: 1 2 3, Postorder: 2 3 1

TreeNode <- function(val = 0, left = NULL, right = NULL) {
  list(val = val, left = left, right = right)
}

inorder <- function(root) {
  if (is.null(root)) return(c())
  c(inorder(root$left), root$val, inorder(root$right))
}

preorder <- function(root) {
  if (is.null(root)) return(c())
  c(root$val, preorder(root$left), preorder(root$right))
}

postorder <- function(root) {
  if (is.null(root)) return(c())
  c(postorder(root$left), postorder(root$right), root$val)
}

root <- TreeNode(1,
  TreeNode(2, TreeNode(4), TreeNode(5)),
  TreeNode(3, TreeNode(6), TreeNode(7))
)

cat("Inorder:", inorder(root), "\n")
cat("Preorder:", preorder(root), "\n")
cat("Postorder:", postorder(root), "\n")
