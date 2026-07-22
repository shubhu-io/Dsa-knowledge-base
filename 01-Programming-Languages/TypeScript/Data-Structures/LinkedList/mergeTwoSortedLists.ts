/*
Problem: Merge Two Sorted Lists
Description: Merge two sorted singly linked lists into one sorted list.

Approach:
- Use dummy head and iterate, picking smaller node each step

Time Complexity: O(n + m)
Space Complexity: O(1)

Example:
Input: 1 -> 2 -> 4, 1 -> 3 -> 4
Output: 1 -> 1 -> 2 -> 3 -> 4 -> 4
*/

class ListNode {
  constructor(public val: number, public next: ListNode | null = null) {}
}

function mergeTwoLists(l1: ListNode | null, l2: ListNode | null): ListNode | null {
  const dummy = new ListNode(0);
  let curr = dummy;
  while (l1 && l2) {
    if (l1.val <= l2.val) {
      curr.next = l1;
      l1 = l1.next;
    } else {
      curr.next = l2;
      l2 = l2.next;
    }
    curr = curr.next;
  }
  curr.next = l1 || l2;
  return dummy.next;
}

function printList(head: ListNode | null): string {
  const vals: number[] = [];
  while (head) { vals.push(head.val); head = head.next; }
  return vals.join(' -> ');
}

const l1 = new ListNode(1, new ListNode(2, new ListNode(4)));
const l2 = new ListNode(1, new ListNode(3, new ListNode(4)));
console.log('List 1:', printList(l1));
console.log('List 2:', printList(l2));
console.log('Merged:', printList(mergeTwoLists(l1, l2)));
