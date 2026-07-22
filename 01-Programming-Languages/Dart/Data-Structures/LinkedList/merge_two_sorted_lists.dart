/*
Problem: Merge Two Sorted Lists
Description: Merge two sorted linked lists into one sorted linked list.

Approach:
- Use a dummy head node for result
- Compare heads of both lists, append smaller node to result
- Append remaining nodes when one list is exhausted

Time Complexity: O(n + m)
Space Complexity: O(1)

Example:
Input: list1 = 1 -> 2 -> 4, list2 = 1 -> 3 -> 4
Output: 1 -> 1 -> 2 -> 3 -> 4 -> 4
*/

class ListNode {
  int val;
  ListNode? next;
  ListNode(this.val);
}

ListNode? mergeTwoLists(ListNode? l1, ListNode? l2) {
  ListNode dummy = ListNode(0);
  ListNode? tail = dummy;
  ListNode? p1 = l1;
  ListNode? p2 = l2;
  while (p1 != null && p2 != null) {
    if (p1.val <= p2.val) {
      tail!.next = p1;
      p1 = p1.next;
    } else {
      tail!.next = p2;
      p2 = p2.next;
    }
    tail = tail.next;
  }
  tail!.next = p1 ?? p2;
  return dummy.next;
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
  ListNode l1 = ListNode(1);
  l1.next = ListNode(2);
  l1.next!.next = ListNode(4);
  ListNode l2 = ListNode(1);
  l2.next = ListNode(3);
  l2.next!.next = ListNode(4);
  ListNode? merged = mergeTwoLists(l1, l2);
  print('Merged list:');
  printList(merged);
}
