# Problem: Maximum Depth of Binary Tree
# Description: Find the maximum depth (height) of a binary tree.
#
# Approach:
# - Recursively compute depth of left and right subtrees
# - Return max of the two plus 1
#
# Time Complexity: O(n)
# Space Complexity: O(h) where h is tree height
#
# Example:
# Input: Tree: 3 -> (9, 20 -> (15, 7))
# Output: 3

TreeNode <- function(val = 0, left = NULL, right = NULL) {
  list(val = val, left = left, right = right)
}

max_depth <- function(root) {
  if (is.null(root)) return(0)
  1 + max(max_depth(root$left), max_depth(root$right))
}

root <- TreeNode(3,
  TreeNode(9),
  TreeNode(20, TreeNode(15), TreeNode(7))
)

cat("Max depth:", max_depth(root), "\n")

root2 <- TreeNode(1, NULL, TreeNode(2, NULL, TreeNode(3)))
cat("Max depth (skewed):", max_depth(root2), "\n")
