public class BinaryTree {
    private TreeNode root;
    
    private static class TreeNode {
        int value;
        TreeNode left, right;
        
        TreeNode(int value) {
            this.value = value;
            this.left = null;
            this.right = null;
        }
    }
    
    public void insert(int value) {
        root = insertRec(root, value);
    }
    
    private TreeNode insertRec(TreeNode root, int value) {
        if (root == null) {
            return new TreeNode(value);
        }
        
        if (value < root.value) {
            root.left = insertRec(root.left, value);
        } else if (value > root.value) {
            root.right = insertRec(root.right, value);
        }
        
        return root;
    }
    
    public void inorder() {
        inorderRec(root);
        System.out.println();
    }
    
    private void inorderRec(TreeNode root) {
        if (root != null) {
            inorderRec(root.left);
            System.out.print(root.value + " ");
            inorderRec(root.right);
        }
    }
    
    public boolean search(int value) {
        return searchRec(root, value);
    }
    
    private boolean searchRec(TreeNode root, int value) {
        if (root == null) return false;
        if (value == root.value) return true;
        return value < root.value ? searchRec(root.left, value) : searchRec(root.right, value);
    }
    
    public static void main(String[] args) {
        BinaryTree tree = new BinaryTree();
        int[] values = {50, 30, 70, 20, 40, 60, 80};
        for (int v : values) {
            tree.insert(v);
        }
        
        System.out.print("Inorder: ");
        tree.inorder();
        
        System.out.println("Search 40: " + tree.search(40));
        System.out.println("Search 90: " + tree.search(90));
    }
}