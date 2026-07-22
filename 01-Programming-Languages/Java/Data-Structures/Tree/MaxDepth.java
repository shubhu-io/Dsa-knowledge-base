/*
 * Problem: Find the maximum depth of a binary tree.
 * Approach: Recursively compute max depth of left and right subtrees.
 * Time Complexity: O(n)
 * Space Complexity: O(n) (recursion stack)
 * Example: Tree: 3 -> left: 9, right: 20 -> 20 -> left: 15, right: 7 -> Output: 3
 */

public class MaxDepth {
    static class TreeNode {
        int val;
        TreeNode left, right;
        TreeNode(int val) { this.val = val; }
    }

    public static int maxDepth(TreeNode root) {
        if (root == null) return 0;
        return 1 + Math.max(maxDepth(root.left), maxDepth(root.right));
    }

    public static void main(String[] args) {
        TreeNode root = new TreeNode(3);
        root.left = new TreeNode(9);
        root.right = new TreeNode(20);
        root.right.left = new TreeNode(15);
        root.right.right = new TreeNode(7);
        System.out.println(maxDepth(root));
    }
}
