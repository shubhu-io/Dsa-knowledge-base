class TreeNode {
    value: number;
    left: TreeNode | null;
    right: TreeNode | null;

    constructor(value: number) {
        this.value = value;
        this.left = null;
        this.right = null;
    }
}

class BinaryTree {
    root: TreeNode | null;

    constructor() {
        this.root = null;
    }

    insert(value: number): void {
        const newNode = new TreeNode(value);

        if (!this.root) {
            this.root = newNode;
            return;
        }

        let current = this.root;
        while (true) {
            if (value < current.value) {
                if (!current.left) {
                    current.left = newNode;
                    return;
                }
                current = current.left;
            } else if (value > current.value) {
                if (!current.right) {
                    current.right = newNode;
                    return;
                }
                current = current.right;
            } else {
                return; // Duplicate
            }
        }
    }

    inorder(node: TreeNode | null = this.root): void {
        if (node) {
            this.inorder(node.left);
            process.stdout.write(`${node.value} `);
            this.inorder(node.right);
        }
    }

    search(value: number): boolean {
        let current = this.root;
        while (current) {
            if (value === current.value) return true;
            current = value < current.value ? current.left : current.right;
        }
        return false;
    }
}

const tree = new BinaryTree();
[50, 30, 70, 20, 40, 60, 80].forEach(v => tree.insert(v));

process.stdout.write("Inorder: ");
tree.inorder();
console.log();

console.log("Search 40:", tree.search(40));
console.log("Search 90:", tree.search(90));