/*
Problem: Maximum Depth of Binary Tree
Find the maximum depth (height) of a binary tree.

Approach:
- Recursively compute the max depth of left and right subtrees
- Return 1 + max(leftDepth, rightDepth)
- Base case: null node has depth 0

Time Complexity: O(n)
Space Complexity: O(n)

Example:
Input: tree = [3, 9, 20, null, null, 15, 7]
Output: 3
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

fn max_depth(root: &Node) -> i32 {
    match root {
        None => 0,
        Some(node) => {
            let left = max_depth(&node.borrow().left);
            let right = max_depth(&node.borrow().right);
            1 + left.max(right)
        }
    }
}

fn main() {
    let n15 = Rc::new(RefCell::new(TreeNode::new(15)));
    let n7 = Rc::new(RefCell::new(TreeNode::new(7)));
    let n20 = Rc::new(RefCell::new(TreeNode { val: 20, left: Some(n15), right: Some(n7) }));
    let n9 = Rc::new(RefCell::new(TreeNode::new(9)));
    let n3 = Rc::new(RefCell::new(TreeNode { val: 3, left: Some(n9), right: Some(n20) }));
    println!("Output: {}", max_depth(&Some(n3)));
}
