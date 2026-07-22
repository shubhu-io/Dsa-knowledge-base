use std::cell::RefCell;
use std::rc::Rc;

#[derive(Debug)]
struct TreeNode {
    value: i32,
    left: Option<Rc<RefCell<TreeNode>>>,
    right: Option<Rc<RefCell<TreeNode>>>,
}

impl TreeNode {
    fn new(value: i32) -> Self {
        TreeNode {
            value,
            left: None,
            right: None,
        }
    }

    fn insert(root: Option<Rc<RefCell<TreeNode>>>, value: i32) -> Option<Rc<RefCell<TreeNode>>> {
        match root {
            None => Some(Rc::new(RefCell::new(TreeNode::new(value)))),
            Some(node) => {
                let mut node = node.borrow_mut();
                if value < node.value {
                    node.left = Self::insert(node.left.take(), value);
                } else if value > node.value {
                    node.right = Self::insert(node.right.take(), value);
                }
                Some(Rc::clone(&node))
            }
        }
    }

    fn inorder(root: &Option<Rc<RefCell<TreeNode>>>) {
        if let Some(node) = root {
            let node = node.borrow();
            Self::inorder(&node.left);
            print!("{} ", node.value);
            Self::inorder(&node.right);
        }
    }
}

fn main() {
    let mut root: Option<Rc<RefCell<TreeNode>>> = None;
    let values = vec![50, 30, 70, 20, 40, 60, 80];

    for v in values {
        root = TreeNode::insert(root, v);
    }

    print!("Inorder: ");
    TreeNode::inorder(&root);
    println!();
}