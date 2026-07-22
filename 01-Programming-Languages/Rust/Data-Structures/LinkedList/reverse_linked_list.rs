/*
Problem: Reverse Linked List
Reverse a singly linked list.

Approach:
- Use three pointers: prev, curr, next
- Iteratively reverse the next pointer of each node
- Return the new head (prev)

Time Complexity: O(n)
Space Complexity: O(1)

Example:
Input: 1 -> 2 -> 3 -> 4 -> 5
Output: 5 -> 4 -> 3 -> 2 -> 1
*/

struct ListNode {
    val: i32,
    next: Option<Box<ListNode>>,
}

impl ListNode {
    fn new(val: i32) -> Self {
        ListNode { val, next: None }
    }
}

fn reverse_list(head: Option<Box<ListNode>>) -> Option<Box<ListNode>> {
    let mut prev: Option<Box<ListNode>> = None;
    let mut curr = head;
    while let Some(mut node) = curr {
        let next = node.next.take();
        node.next = prev;
        prev = Some(node);
        curr = next;
    }
    prev
}

fn to_vec(head: Option<Box<ListNode>>) -> Vec<i32> {
    let mut result = Vec::new();
    let mut curr = head;
    while let Some(node) = curr {
        result.push(node.val);
        curr = node.next;
    }
    result
}

fn main() {
    let mut head = Some(Box::new(ListNode::new(1)));
    let mut curr = head.as_mut().unwrap();
    for val in [2, 3, 4, 5] {
        curr.next = Some(Box::new(ListNode::new(val)));
        curr = curr.next.as_mut().unwrap();
    }
    println!("Input: {:?}", to_vec(head.clone()));
    let reversed = reverse_list(head);
    println!("Output: {:?}", to_vec(reversed));
}
