class TreeNode {
  int value;
  TreeNode? left;
  TreeNode? right;

  TreeNode(this.value) : left = null, right = null;
}

class BinaryTree {
  TreeNode? root;

  void insert(int value) {
    final newNode = TreeNode(value);
    if (root == null) {
      root = newNode;
      return;
    }

    var current = root!;
    while (true) {
      if (value < current.value) {
        if (current.left == null) {
          current.left = newNode;
          return;
        }
        current = current.left!;
      } else if (value > current.value) {
        if (current.right == null) {
          current.right = newNode;
          return;
        }
        current = current.right!;
      } else {
        return; // Duplicate
      }
    }
  }

  void inorder([TreeNode? node]) {
    final currentNode = node ?? root;
    if (currentNode == null) return;

    inorder(currentNode.left);
    stdout.write('${currentNode.value} ');
    inorder(currentNode.right);
  }

  bool search(int value) {
    var current = root;
    while (current != null) {
      if (value == current.value) return true;
      current = value < current.value ? current.left : current.right;
    }
    return false;
  }
}

void main() {
  final tree = BinaryTree();
  for (final v in [50, 30, 70, 20, 40, 60, 80]) {
    tree.insert(v);
  }

  stdout.write('Inorder: ');
  tree.inorder();
  print();

  print('Search 40: ${tree.search(40)}');
  print('Search 90: ${tree.search(90)}');
}