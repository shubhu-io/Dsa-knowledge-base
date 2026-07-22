/*
Problem: Linked List Cycle
Description: Detect if a linked list has a cycle using Floyd's cycle detection algorithm.

Approach:
- Use slow and fast pointers; if they meet, a cycle exists

Time Complexity: O(n)
Space Complexity: O(1)

Example:
Input: 3 -> 2 -> 0 -> -4 (cycle at node with value 2)
Output: true
*/

class ListNode {
  constructor(val, next = null) {
    this.val = val;
    this.next = next;
  }
}

function hasCycle(head) {
  let slow = head, fast = head;
  while (fast && fast.next) {
    slow = slow.next;
    fast = fast.next.next;
    if (slow === fast) return true;
  }
  return false;
}

const node1 = new ListNode(3);
const node2 = new ListNode(2);
const node3 = new ListNode(0);
const node4 = new ListNode(-4);
node1.next = node2;
node2.next = node3;
node3.next = node4;
node4.next = node2;

const noCycle = new ListNode(1, new ListNode(2));

console.log('Has cycle (with cycle):', hasCycle(node1));
console.log('Has cycle (no cycle):', hasCycle(noCycle));
