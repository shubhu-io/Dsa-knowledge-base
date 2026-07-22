/**
 * Problem: Binary Tree Inorder Traversal
 * Given the root of a binary tree, return the inorder traversal of its nodes' values.
 * Inorder traversal visits nodes in the order: left subtree, root, right subtree.
 *
 * Approach:
 * - Recursively traverse the left subtree
 * - Visit the root node
 * - Recursively traverse the right subtree
 * - Alternatively, use an iterative approach with a stack to avoid recursion stack overflow
 *
 * Time Complexity: O(n) - visits each node exactly once
 * Space Complexity: O(h) - where h is the height of the tree (recursion stack or explicit stack)
 *                  O(n) in worst case (skewed tree), O(log n) in best case (balanced tree)
 *
 * Example:
 * Input: root = [1,null,2,3]
 *        1
 *         \
 *          2
 *         /
 *        3
 * Output: [1,3,2]
 */

/**
 * Definition for a binary tree node.
 * function TreeNode(val, left, right) {
 *     this.val = (val===undefined ? 0 : val)
 *     this.left = (left===undefined ? null : left)
 *     this.right = (right===undefined ? null : right)
 * }
 */

/**
 * @param {TreeNode|null} root
 * @return {number[]}
 */
var inorderTraversal = function(root) {
    const result = [];
    inorderHelper(root, result);
    return result;
};

/**
 * Helper function to perform inorder traversal recursively
 * @param {TreeNode|null} node
 * @param {number[]} result
 */
function inorderHelper(node, result) {
    if (node === null) {
        return;
    }

    // Traverse left subtree
    inorderHelper(node.left, result);

    // Visit current node
    result.push(node.val);

    // Traverse right subtree
    inorderHelper(node.right, result);
}

/**
 * Alternative iterative solution using a stack
 * This avoids potential stack overflow issues with deep recursion
 * @param {TreeNode|null} root
 * @return {number[]}
 */
var inorderTraversalIterative = function(root) {
    const result = [];
    const stack = [];
    let current = root;

    // Continue until we've processed all nodes
    while (current !== null || stack.length > 0) {
        // Reach the leftmost node of the current node
        while (current !== null) {
            stack.push(current);
            current = current.left;
        }

        // Current must be null at this point
        current = stack.pop();

        // Add the current node's value to the result
        result.push(current.val);

        // We've visited the node and its left subtree.
        // Now, it's right subtree's turn.
        current = current.right;
    }

    return result;
};

// Helper function to create a new tree node
function TreeNode(val, left, right) {
    this.val = (val === undefined ? 0 : val);
    this.left = (left === undefined ? null : left);
    this.right = (right === undefined ? null : right);
}

// Helper function to print an array
function printArray(arr) {
    console.log(`[${arr.join(', ')}]`);
}

// Example usage
if (require.main === module) {
    // Example 1: [1,null,2,3]
    //     1
    //      \
    //       2
    //      /
    //     3
    const root1 = new TreeNode(1);
    root1.right = new TreeNode(2);
    root1.right.left = new TreeNode(3);

    const result1 = inorderTraversal(root1);
    const result1Iter = inorderTraversalIterative(root1);

    console.log("Example 1 - Tree: [1,null,2,3]");
    console.log("Inorder traversal (recursive):");
    printArray(result1);
    console.log("Inorder traversal (iterative):");
    printArray(result1Iter);
    console.log("Expected: [1,3,2]\n");

    // Example 2: Empty tree
    const root2 = null;
    const result2 = inorderTraversal(root2);
    const result2Iter = inorderTraversalIterative(root2);

    console.log("Example 2 - Empty tree");
    console.log("Inorder traversal (recursive):");
    printArray(result2);
    console.log("Inorder traversal (iterative):");
    printArray(result2Iter);
    console.log("Expected: []\n");

    // Example 3: Single node
    const root3 = new TreeNode(1);
    const result3 = inorderTraversal(root3);
    const result3Iter = inorderTraversalIterative(root3);

    console.log("Example 3 - Single node [1]");
    console.log("Inorder traversal (recursive):");
    printArray(result3);
    console.log("Inorder traversal (iterative):");
    printArray(result3Iter);
    console.log("Expected: [1]\n");

    // Example 4: Full binary tree [1,2,3,4,5,6,7]
    //         1
    //       /   \
    //      2     3
    //     / \   / \
    //    4   5 6   7
    const root4 = new TreeNode(1);
    root4.left = new TreeNode(2);
    root4.right = new TreeNode(3);
    root4.left.left = new TreeNode(4);
    root4.left.right = new TreeNode(5);
    root4.right.left = new TreeNode(6);
    root4.right.right = new TreeNode(7);

    const result4 = inorderTraversal(root4);
    const result4Iter = inorderTraversalIterative(root4);

    console.log("Example 4 - Full binary tree [1,2,3,4,5,6,7]");
    console.log("Inorder traversal (recursive):");
    printArray(result4);
    console.log("Inorder traversal (iterative):");
    printArray(result4Iter);
    console.log("Expected: [4,2,5,1,6,3,7]\n");
}