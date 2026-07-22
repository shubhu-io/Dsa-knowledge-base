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

#include <stdio.h>
#include <stdlib.h>

// Definition for a binary tree node.
struct TreeNode {
    int val;
    struct TreeNode *left;
    struct TreeNode *right;
};

/**
 * Helper function to perform inorder traversal recursively
 *
 * @param root Current node in the traversal
 * @param result Array to store the traversal result
 * @param returnSize Pointer to store the size of the result array
 */
void inorderTraversalHelper(struct TreeNode* root, int* result, int* returnSize) {
    if (root == NULL) {
        return;
    }

    // Traverse left subtree
    inorderTraversalHelper(root->left, result, returnSize);

    // Visit current node
    result[(*returnSize)++] = root->val;

    // Traverse right subtree
    inorderTraversalHelper(root->right, result, returnSize);
}

/**
 * Returns the inorder traversal of a binary tree's nodes' values.
 *
 * @param root The root of the binary tree
 * @param returnSize Pointer to store the size of the returned array
 * @return An array containing the inorder traversal of the tree (caller must free)
 */
int* inorderTraversal(struct TreeNode* root, int* returnSize) {
    // Initialize return size
    *returnSize = 0;

    // Handle empty tree
    if (root == NULL) {
        return NULL;
    }

    // Allocate memory for the result (maximum size is number of nodes)
    // We'll use a conservative estimate of 100 nodes for simplicity
    // In a real application, we might first count nodes or use dynamic allocation
    int* result = (int*)malloc(100 * sizeof(int));
    if (result == NULL) {
        *returnSize = 0;
        return NULL;
    }

    // Perform the traversal
    inorderTraversalHelper(root, result, returnSize);

    // Resize the array to the actual size needed
    int* finalResult = (int*)realloc(result, (*returnSize) * sizeof(int));
    if (finalResult != NULL || *returnSize == 0) {
        return finalResult;
    }

    // If realloc failed but we had data, return the original
    return result;
}

/**
 * Helper function to create a new tree node
 */
struct TreeNode* createTreeNode(int val) {
    struct TreeNode* node = (struct TreeNode*)malloc(sizeof(struct TreeNode));
    if (node == NULL) {
        return NULL;
    }
    node->val = val;
    node->left = NULL;
    node->right = NULL;
    return node;
}

/**
 * Helper function to free the entire tree
 */
void freeTree(struct TreeNode* root) {
    if (root == NULL) {
        return;
    }
    freeTree(root->left);
    freeTree(root->right);
    free(root);
}

// Helper function to print an array
void printArray(int* arr, int size) {
    printf("[");
    for (int i = 0; i < size; i++) {
        printf("%d", arr[i]);
        if (i < size - 1) {
            printf(", ");
        }
    }
    printf("]\n");
}

// Example usage
int main() {
    // Example 1: [1,null,2,3]
    //     1
    //      \
    //       2
    //      /
    //     3
    struct TreeNode* root1 = createTreeNode(1);
    root1->right = createTreeNode(2);
    root1->right->left = createTreeNode(3);

    int returnSize;
    int* result1 = inorderTraversal(root1, &returnSize);

    printf("Example 1 - Tree: [1,null,2,3]\n");
    printf("Inorder traversal: ");
    printArray(result1, returnSize);
    printf("Expected: [1,3,2]\n\n");

    // Free memory
    free(result1);
    freeTree(root1);

    // Example 2: Empty tree
    struct TreeNode* root2 = NULL;
    int* result2 = inorderTraversal(root2, &returnSize);

    printf("Example 2 - Empty tree\n");
    printf("Inorder traversal: ");
    printArray(result2, returnSize);
    printf("Expected: []\n\n");

    // Free memory (result2 will be NULL for empty tree)
    free(result2);

    // Example 3: Single node
    struct TreeNode* root3 = createTreeNode(1);
    int* result3 = inorderTraversal(root3, &returnSize);

    printf("Example 3 - Single node [1]\n");
    printf("Inorder traversal: ");
    printArray(result3, returnSize);
    printf("Expected: [1]\n\n");

    // Free memory
    free(result3);
    freeTree(root3);

    // Example 4: Full binary tree [1,2,3,4,5,6,7]
    //         1
    //       /   \
    //      2     3
    //     / \   / \
    //    4   5 6   7
    struct TreeNode* root4 = createTreeNode(1);
    root4->left = createTreeNode(2);
    root4->right = createTreeNode(3);
    root4->left->left = createTreeNode(4);
    root4->left->right = createTreeNode(5);
    root4->right->left = createTreeNode(6);
    root4->right->right = createTreeNode(7);

    int* result4 = inorderTraversal(root4, &returnSize);

    printf("Example 4 - Full binary tree [1,2,3,4,5,6,7]\n");
    printf("Inorder traversal: ");
    printArray(result4, returnSize);
    printf("Expected: [4,2,5,1,6,3,7]\n\n");

    // Free memory
    free(result4);
    freeTree(root4);

    return 0;
}