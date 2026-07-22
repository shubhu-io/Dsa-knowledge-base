<?php
class TreeNode {
    public $value;
    public $left;
    public $right;

    public function __construct($value) {
        $this->value = $value;
        $this->left = null;
        $this->right = null;
    }
}

class BinaryTree {
    private $root;

    public function __construct() {
        $this->root = null;
    }

    public function insert($value) {
        $newNode = new TreeNode($value);

        if ($this->root === null) {
            $this->root = $newNode;
            return;
        }

        $current = $this->root;
        while (true) {
            if ($value < $current->value) {
                if ($current->left === null) {
                    $current->left = $newNode;
                    return;
                }
                $current = $current->left;
            } elseif ($value > $current->value) {
                if ($current->right === null) {
                    $current->right = $newNode;
                    return;
                }
                $current = $current->right;
            } else {
                return; // Duplicate
            }
        }
    }

    public function inorder($node = null) {
        if ($node === null) {
            $node = $this->root;
        }
        if ($node !== null) {
            $this->inorder($node->left);
            echo $node->value . " ";
            $this->inorder($node->right);
        }
    }

    public function search($value) {
        $current = $this->root;
        while ($current !== null) {
            if ($value === $current->value) {
                return true;
            }
            $current = $value < $current->value ? $current->left : $current->right;
        }
        return false;
    }
}

$tree = new BinaryTree();
foreach ([50, 30, 70, 20, 40, 60, 80] as $v) {
    $tree->insert($v);
}

echo "Inorder: ";
$tree->inorder();
echo "\n";

echo "Search 40: " . ($tree->search(40) ? "true" : "false") . "\n";
echo "Search 90: " . ($tree->search(90) ? "true" : "false") . "\n";
?>