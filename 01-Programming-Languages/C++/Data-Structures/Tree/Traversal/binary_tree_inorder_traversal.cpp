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

#include <iostream>
#include <vector>
#include <stack>

// Definition for a binary tree node.
struct TreeNode {
    int val;
    TreeNode *left;
    TreeNode *right;
    TreeNode() : val(0), left(nullptr), right(nullptr) {}
    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
    TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
};

class Solution {
public:
    /**
     * Returns the inorder traversal of a binary tree's nodes' values.
     *
     * @param root The root of the binary tree
     * @return A vector containing the inorder traversal of the tree
     */
    std::vector<int> inorderTraversal(TreeNode* root) {
        std::vector<int> result;
        inorderHelper(root, result);
        return result;
    }

private:
    /**
     * Helper function to perform inorder traversal recursively
     *
     * @param node Current node in the traversal
     * @param result Vector to store the traversal result
     */
    void inorderHelper(TreeNode* node, std::vector<int>& result) {
        if (node == nullptr) {
            return;
        }

        // Traverse left subtree
        inorderHelper(node->left, result);

        // Visit current node
        result.push_back(node->val);

        // Traverse right subtree
        inorderHelper(node->right, result);
    }
};

/**
 * Alternative iterative solution using a stack
 * This avoids potential stack overflow issues with deep recursion
 */
class SolutionIterative {
public:
    std::vector<int> inorderTraversal(TreeNode* root) {
        std::vector<int> result;
        std::stack<TreeNode*> stack;
        TreeNode* current = root;

        // Continue until we've processed all nodes
        while (current != nullptr || !stack.empty()) {
            // Reach the leftmost node of the current node
            while (current != nullptr) {
                stack.push(current);
                current = current->left;
            }

            // Current must be null at this point
            current = stack.top();
            stack.pop();

            // Add the current node's value to the result
            result.push_back(current->val);

            // We've visited the node and its left subtree.
            // Now, it's right subtree's turn.
            current = current->right;
        }

        return result;
    }
};

// Helper function to create a new tree node
TreeNode* createTreeNode(int val) {
    return new TreeNode(val);
}

// Helper function to free the entire tree
void freeTree(TreeNode* root) {
    if (root == nullptr) {
        return;
    }
    freeTree(root->left);
    freeTree(root->right);
    delete root;
}

// Helper function to print a vector
void printVector(const std::vector<int>& vec) {
    std::cout << "[";
    for (size_t i = 0; i < vec.size(); i++) {
        std::cout << vec[i];
        if (i < vec.size() - 1) {
            std::cout << ", ";
        }
    }
    std::cout << "]" << std::endl;
}

// Example usage
int main() {
    Solution solution;
    SolutionIterative iterativeSolution;

    // Example 1: [1,null,2,3]
    //     1
    //      \
    //       2
    //      /
    //     3
    TreeNode* root1 = createTreeNode(1);
    root1->right = createTreeNode(2);
    root1->right->left = createTreeNode(3);

    std::vector<int> result1 = solution.inorderTraversal(root1);
    std::vector<int> result1_iter = iterativeSolution.inorderTraversal(root1);

    std::cout << "Example 1 - Tree: [1,null,2,3]" << std::endl;
    std::cout << "Inorder traversal (recursive): ";
    printVector(result1);
    std::cout << "Inorder traversal (iterative): ";
    printVector(result1_iter);
    std::cout << "Expected: [1,3,2]" << std::endl << std::endl;

    // Free memory
    freeTree(root1);

    // Example 2: Empty tree
    TreeNode* root2 = nullptr;
    std::vector<int> result2 = solution.inorderTraversal(root2);
    std::vector<int> result2_iter = iterativeSolution.inorderTraversal(root2);

    std::cout << "Example 2 - Empty tree" << std::endl;
    std::cout << "Inorder traversal (recursive): ";
    printVector(result2);
    std::cout << "Inorder traversal (iterative): ";
    printVector(result2_iter);
    std::cout << "Expected: []" << std::endl << std::endl;

    // Example 3: Single node
    TreeNode* root3 = createTreeNode(1);
    std::vector<int> result3 = solution.inorderTraversal(root3);
    std::vector<int> result3_iter = iterativeSolution.inorderTraversal(root3);

    std::cout << "Example 3 - Single node [1]" << std::endl;
    std::cout << "Inorder traversal (recursive): ";
    printVector(result3);
    std::cout << "Inorder traversal (iterative): ";
    printVector(result3_iter);
    std::cout << "Expected: [1]" << std::endl << std::endl;

    // Free memory
    freeTree(root3);

    // Example 4: Full binary tree [1,2,3,4,5,6,7]
    //         1
    //       /   \
    //      2     3
    //     / \   / \
    //    4   5 6   7
    TreeNode* root4 = createTreeNode(1);
    root4->left = createTreeNode(2);
    root4->right = createTreeNode(3);
    root4->left->left = createTreeNode(4);
    root4->left->right = createTreeNode(5);
    root4->right->left = createTreeNode(6);
    root4->right->right = createTreeNode(7);

    std::vector<int> result4 = solution.inorderTraversal(root4);
    std::vector<int> result4_iter = iterativeSolution.inorderTraversal(root4);

    std::cout << "Example 4 - Full binary tree [1,2,3,4,5,6,7]" << std::endl;
    std::cout << "Inorder traversal (recursive): ";
    printVector(result4);
    std::cout << "Inorder traversal (iterative): ";
    printVector(result4_iter);
    std::cout << "Expected: [4,2,5,1,6,3,7]" << std::endl << std::endl;

    // Free memory
    freeTree(root4);

    return 0;
}