/*
Problem: Merge Two Sorted Lists
Merge two sorted linked lists into one sorted list.

Approach:
- Use a dummy head node
- Compare heads of both lists, attach the smaller one
- Move pointer forward in the list that was used
- When one list is exhausted, attach the remainder of the other

Time Complexity: O(n + m)
Space Complexity: O(1)

Example:
Input: list1 = 1 -> 2 -> 4, list2 = 1 -> 3 -> 4
Output: 1 -> 1 -> 2 -> 3 -> 4 -> 4
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

fn merge_two_lists(
    list1: Option<Box<ListNode>>,
    list2: Option<Box<ListNode>>,
) -> Option<Box<ListNode>> {
    let mut dummy = Box::new(ListNode::new(0));
    let mut curr = &mut dummy;
    let mut l1 = list1;
    let mut l2 = list2;
    while l1.is_some() && l2.is_some() {
        if l1.as_ref().unwrap().val <= l2.as_ref().unwrap().val {
            curr.next = l1.take();
            curr = curr.next.as_mut().unwrap();
            l1 = curr.next.take();
        } else {
            curr.next = l2.take();
            curr = curr.next.as_mut().unwrap();
            l2 = curr.next.take();
        }
    }
    curr.next = if l1.is_some() { l1 } else { l2 };
    dummy.next
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
    let mut l1 = Some(Box::new(ListNode::new(1)));
    let mut curr = l1.as_mut().unwrap();
    for v in [2, 4] {
        curr.next = Some(Box::new(ListNode::new(v)));
        curr = curr.next.as_mut().unwrap();
    }
    let mut l2 = Some(Box::new(ListNode::new(1)));
    let mut curr = l2.as_mut().unwrap();
    for v in [3, 4] {
        curr.next = Some(Box::new(ListNode::new(v)));
        curr = curr.next.as_mut().unwrap();
    }
    println!("Input: list1 = {:?}, list2 = {:?}", to_vec(l1.clone()), to_vec(l2.clone()));
    let merged = merge_two_lists(l1, l2);
    println!("Output: {:?}", to_vec(merged));
}
