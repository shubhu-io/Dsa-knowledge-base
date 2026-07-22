/*
Problem: Binary Tree Traversals
Perform inorder, preorder, and postorder traversals of a binary tree.

Approach:
- Inorder: left, root, right
- Preorder: root, left, right
- Postorder: left, right, root

Time Complexity: O(n)
Space Complexity: O(n)

Example:
Input: tree = [1, 2, 3, 4, 5]
Output:
  Inorder: [4, 2, 5, 1, 3]
  Preorder: [1, 2, 4, 5, 3]
  Postorder: [4, 5, 2, 3, 1]
*/

use std::cell::RefCell;
use std::rc::Rc;

type Node = Option<Rc<RefCell<TreeNode>>>;

struct TreeNode {
    val: i32,
    left: Node,
    right: Node,
}

impl TreeNode {
    fn new(val: i32) -> Self {
        TreeNode { val, left: None, right: None }
    }
}

fn inorder(root: &Node) -> Vec<i32> {
    let mut result = Vec::new();
    if let Some(node) = root {
        result.extend(inorder(&node.borrow().left));
        result.push(node.borrow().val);
        result.extend(inorder(&node.borrow().right));
    }
    result
}

fn preorder(root: &Node) -> Vec<i32> {
    let mut result = Vec::new();
    if let Some(node) = root {
        result.push(node.borrow().val);
        result.extend(preorder(&node.borrow().left));
        result.extend(preorder(&node.borrow().right));
    }
    result
}

fn postorder(root: &Node) -> Vec<i32> {
    let mut result = Vec::new();
    if let Some(node) = root {
        result.extend(postorder(&node.borrow().left));
        result.extend(postorder(&node.borrow().right));
        result.push(node.borrow().val);
    }
    result
}

fn main() {
    let n4 = Rc::new(RefCell::new(TreeNode::new(4)));
    let n5 = Rc::new(RefCell::new(TreeNode::new(5)));
    let n2 = Rc::new(RefCell::new(TreeNode { val: 2, left: Some(n4), right: Some(n5) }));
    let n3 = Rc::new(RefCell::new(TreeNode::new(3)));
    let n1 = Rc::new(RefCell::new(TreeNode { val: 1, left: Some(n2), right: Some(n3) }));
    println!("Inorder: {:?}", inorder(&Some(n1.clone())));
    println!("Preorder: {:?}", preorder(&Some(n1.clone())));
    println!("Postorder: {:?}", postorder(&Some(n1)));
}
