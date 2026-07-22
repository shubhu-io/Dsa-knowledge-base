/*
Problem: Linked List Cycle
Detect if a linked list has a cycle.

Approach:
- Use Floyd's cycle detection (two pointers: slow and fast)
- Slow moves one step, fast moves two steps
- If they meet, a cycle exists

Time Complexity: O(n)
Space Complexity: O(1)

Example:
Input: 3 -> 2 -> 0 -> -4 (cycle at node 2)
Output: true (cycle detected)
*/

use std::cell::RefCell;
use std::rc::Rc;

type Node = Option<Rc<RefCell<ListNode>>>;

struct ListNode {
    val: i32,
    next: Node,
}

impl ListNode {
    fn new(val: i32) -> Self {
        ListNode { val, next: None }
    }
}

fn has_cycle(head: Node) -> bool {
    let mut slow = head.clone();
    let mut fast = head.clone();
    while fast.is_some() && fast.as_ref().unwrap().borrow().next.is_some() {
        slow = slow.unwrap().borrow().next.clone();
        fast = fast.unwrap().borrow().next.as_ref().unwrap().borrow().next.clone();
        if let (Some(a), Some(b)) = (&slow, &fast) {
            if Rc::ptr_eq(a, b) {
                return true;
            }
        }
    }
    false
}

fn main() {
    let n3 = Rc::new(RefCell::new(ListNode::new(-4)));
    let n2 = Rc::new(RefCell::new(ListNode { val: 0, next: Some(n3.clone()) }));
    let n1 = Rc::new(RefCell::new(ListNode { val: 2, next: Some(n2.clone()) }));
    let n0 = Rc::new(RefCell::new(ListNode { val: 3, next: Some(n1.clone()) }));
    n3.borrow_mut().next = Some(n1.clone());
    println!("Output: {}", has_cycle(Some(n0)));
}
