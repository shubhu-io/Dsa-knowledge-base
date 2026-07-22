/*
Problem: Reverse Linked List
Description: Reverse a singly linked list iteratively.

Approach:
- Use three pointers (prev, curr, next) to reverse links in one pass

Time Complexity: O(n)
Space Complexity: O(1)

Example:
Input: 1 -> 2 -> 3 -> 4 -> 5
Output: 5 -> 4 -> 3 -> 2 -> 1
*/

class ListNode {
  constructor(public val: number, public next: ListNode | null = null) {}
}

function reverseList(head: ListNode | null): ListNode | null {
  let prev: ListNode | null = null, curr = head;
  while (curr) {
    const next = curr.next;
    curr.next = prev;
    prev = curr;
    curr = next;
  }
  return prev;
}

function printList(head: ListNode | null): string {
  const vals: number[] = [];
  while (head) { vals.push(head.val); head = head.next; }
  return vals.join(' -> ');
}

const list = new ListNode(1, new ListNode(2, new ListNode(3, new ListNode(4, new ListNode(5)))));
console.log('Original:', printList(list));
console.log('Reversed:', printList(reverseList(list)));
