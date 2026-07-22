/*
Problem: Linked List Cycle Detection
Description: Detect if a linked list has a cycle using Floyd's
           Tortoise and Hare algorithm.

Approach:
- Use two pointers (slow moves 1 step, fast moves 2 steps)
- If they meet, a cycle exists
- If fast reaches null, no cycle

Time Complexity: O(n)
Space Complexity: O(1)

Example:
Input: 3 -> 2 -> 0 -> -4 -> (back to index 1)
Output: true
*/

class ListNode {
  int val;
  ListNode? next;
  ListNode(this.val);
}

bool hasCycle(ListNode? head) {
  ListNode? slow = head;
  ListNode? fast = head;
  while (fast != null && fast.next != null) {
    slow = slow!.next;
    fast = fast.next!.next;
    if (identical(slow, fast)) return true;
  }
  return false;
}

void main() {
  ListNode node1 = ListNode(3);
  ListNode node2 = ListNode(2);
  ListNode node3 = ListNode(0);
  ListNode node4 = ListNode(-4);
  node1.next = node2;
  node2.next = node3;
  node3.next = node4;
  node4.next = node2;
  print('Has cycle: ${hasCycle(node1)}');

  ListNode list2 = ListNode(1);
  list2.next = ListNode(2);
  print('Has cycle (no cycle): ${hasCycle(list2)}');
}
