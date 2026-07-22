# Tree Traversal Notes

## Depth-First Search (DFS)

### Preorder (Root, Left, Right)
- Visit root, then left subtree, then right subtree.
- Useful for creating a copy of the tree or getting prefix expression.

### Inorder (Left, Root, Right)
- Visit left subtree, then root, then right subtree.
- For BST, yields nodes in non-decreasing order.

### Postorder (Left, Right, Root)
- Visit left subtree, then right subtree, then root.
- Useful for deleting the tree or evaluating postfix expressions.

## Breadth-First Search (BFS) / Level Order
- Visit nodes level by level from left to right.
- Typically implemented using a queue.

## Recursive vs Iterative
- Recursive solutions are concise but may cause stack overflow on deep trees.
- Iterative solutions using explicit stacks (DFS) or queues (BFS) avoid recursion limits.

## Example Code Snippets (Python)

```python
# Preorder traversal (recursive)
def preorder(root):
    return [root.val] + preorder(root.left) + preorder(root.right) if root else []

# Inorder traversal (iterative using stack)
def inorder(root):
    stack, result = [], []
    curr = root
    while curr or stack:
        while curr:
            stack.append(curr)
            curr = curr.left
        curr = stack.pop()
        result.append(curr.val)
        curr = curr.right
    return result
```

## Applications
- Expression trees
- File system traversal
- AI decision trees
- Network routing algorithms