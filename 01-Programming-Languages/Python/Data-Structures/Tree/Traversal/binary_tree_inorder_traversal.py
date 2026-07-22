"""
Problem: Binary Tree Inorder Traversal
Given the root of a binary tree, return the inorder traversal of its nodes' values.
Inorder traversal visits nodes in the order: left subtree, root, right subtree.

Approach:
- Recursively traverse the left subtree
- Visit the root node
- Recursively traverse the right subtree
- Alternatively, use an iterative approach with a stack to avoid recursion stack overflow

Time Complexity: O(n) - visits each node exactly once
Space Complexity: O(h) - where h is the height of the tree (recursion stack or explicit stack)
                  O(n) in worst case (skewed tree), O(log n) in best case (balanced tree)

Example:
Input: root = [1,null,2,3]
       1
        \
         2
        /
       3
Output: [1,3,2]
"""

# Definition for a binary tree node.
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

class Solution:
    def inorderTraversal(self, root: TreeNode) -> list[int]:
        """
        Returns the inorder traversal of a binary tree's nodes' values.

        Args:
            root: The root of the binary tree

        Returns:
            A list containing the inorder traversal of the tree
        """
        result = []
        self._inorder_helper(root, result)
        return result

    def _inorder_helper(self, node: TreeNode, result: list[int]) -> None:
        """
        Helper function to perform inorder traversal recursively

        Args:
            node: Current node in the traversal
            result: List to store the traversal result
        """
        if node is None:
            return

        # Traverse left subtree
        self._inorder_helper(node.left, result)

        # Visit current node
        result.append(node.val)

        # Traverse right subtree
        self._inorder_helper(node.right, result)

    def inorderTraversalIterative(self, root: TreeNode) -> list[int]:
        """
        Alternative iterative solution using a stack
        This avoids potential stack overflow issues with deep recursion

        Args:
            root: The root of the binary tree

        Returns:
            A list containing the inorder traversal of the tree
        """
        result = []
        stack = []
        current = root

        # Continue until we've processed all nodes
        while current is not None or stack:
            # Reach the leftmost node of the current node
            while current is not None:
                stack.append(current)
                current = current.left

            # Current must be None at this point
            current = stack.pop()

            # Add the current node's value to the result
            result.append(current.val)

            # We've visited the node and its left subtree.
            # Now, it's right subtree's turn.
            current = current.right

        return result

# Helper functions for testing
def create_tree_node(val):
    """Creates a new tree node with the given value"""
    return TreeNode(val)

def print_array(arr):
    """Prints the array in a readable format"""
    print(f"[{', '.join(map(str, str(x) for x in lst))}]")  # Fixed to use correct variable

def print_array_fixed(arr):
    """Prints the array in a readable format"""
    print(f"[{', '.join(map(str, arr))}]")

def free_tree(root):
    """Recursively deletes the tree to free memory"""
    if root is None:
        return
    free_tree(root.left)
    free_tree(root.right)
    # In Python, we don't need to explicitly delete objects as garbage collection handles it
    # But we help by removing references
    root.left = None
    root.right = None

# Example usage
if __name__ == "__main__":
    solution = Solution()

    # Example 1: [1,null,2,3]
    #     1
    #      \
    #       2
    #      /
    #     3
    root1 = TreeNode(1)
    root1.right = TreeNode(2)
    root1.right.left = TreeNode(3)

    result1 = solution.inorderTraversal(root1)
    result1_iter = solution.inorderTraversalIterative(root1)

    print("Example 1 - Tree: [1,null,2,3]")
    print("Inorder traversal (recursive):")
    print_array_fixed(result1)
    print("Inorder traversal (iterative):")
    print_array_fixed(result1_iter)
    print("Expected: [1,3,2]\n")

    # Clean up references to help garbage collection
    root1 = None

    # Example 2: Empty tree
    root2 = None
    result2 = solution.inorderTraversal(root2)
    result2_iter = solution.inorderTraversalIterative(root2)

    print("Example 2 - Empty tree")
    print("Inorder traversal (recursive):")
    print_array_fixed(result2)
    print("Inorder traversal (iterative):")
    print_array_fixed(result2_iter)
    print("Expected: []\n")

    # Example 3: Single node
    root3 = TreeNode(1)
    result3 = solution.inorderTraversal(root3)
    result3_iter = solution.inorderTraversalIterative(root3)

    print("Example 3 - Single node [1]")
    print("Inorder traversal (recursive):")
    print_array_fixed(result3)
    print("Inorder traversal (iterative):")
    print_array_fixed(result3_iter)
    print("Expected: [1]\n")

    # Clean up references
    root3 = None

    # Example 4: Full binary tree [1,2,3,4,5,6,7]
    #         1
    #       /   \
    #      2     3
    #     / \   / \
    #    4   5 6   7
    root4 = TreeNode(1)
    root4.left = TreeNode(2)
    root4.right = TreeNode(3)
    root4.left.left = TreeNode(4)
    root4.left.right = TreeNode(5)
    root4.right.left = TreeNode(6)
    root4.right.right = TreeNode(7)

    result4 = solution.inorderTraversal(root4)
    result4_iter = solution.inorderTraversalIterative(root4)

    print("Example 4 - Full binary tree [1,2,3,4,5,6,7]")
    print("Inorder traversal (recursive):")
    print_array_fixed(result4)
    print("Inorder traversal (iterative):")
    print_array_fixed(result4_iter)
    print("Expected: [4,2,5,1,6,3,7]\n")

    # Clean up references
    root4 = None