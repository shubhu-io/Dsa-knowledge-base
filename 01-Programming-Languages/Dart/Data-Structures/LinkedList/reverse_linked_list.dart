/*
Problem: Reverse Linked List
Description: Reverse a singly linked list and return the new head.

Approach:
- Use iterative three-pointer technique (prev, current, next)
- Reverse each node's next pointer to point to previous node

Time Complexity: O(n)
Space Complexity: O(1)

Example:
Input: 1 -> 2 -> 3 -> 4 -> 5
Output: 5 -> 4 -> 3 -> 2 -> 1
*/

class ListNode {
  int val;
  ListNode? next;
  ListNode(this.val);
}

ListNode? reverseList(ListNode? head) {
  ListNode? prev = null;
  ListNode? curr = head;
  while (curr != null) {
    ListNode? next = curr.next;
    curr.next = prev;
    prev = curr;
    curr = next;
  }
  return prev;
}

void printList(ListNode? head) {
  ListNode? current = head;
  while (current != null) {
    print(current.val);
    if (current.next != null) print(' -> ');
    current = current.next;
  }
  print('');
}

void main() {
  ListNode head = ListNode(1);
  head.next = ListNode(2);
  head.next!.next = ListNode(3);
  head.next!.next!.next = ListNode(4);
  head.next!.next!.next!.next = ListNode(5);
  print('Original:');
  print('Reversed:');
  ListNode? reversed = reverseList(head);
  printList(reversed);
}
