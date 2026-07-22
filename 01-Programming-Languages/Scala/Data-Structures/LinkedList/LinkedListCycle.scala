// Problem: Linked List Cycle Detection
// Description: Detect if a linked list has a cycle using Floyd's algorithm.
//
// Approach:
// - Use two pointers: slow (moves 1 step) and fast (moves 2 steps)
// - If they meet, a cycle exists
//
// Time Complexity: O(n)
// Space Complexity: O(1)
//
// Example:
// Input: 1 -> 2 -> 3 -> 4 -> 2 (cycle back to node 2)
// Output: true

object LinkedListCycle {
  class ListNode(var val: Int = 0, var next: ListNode = null)

  def hasCycle(head: ListNode): Boolean = {
    if (head == null || head.next == null) return false
    var slow = head
    var fast = head.next
    while (fast != null && fast.next != null) {
      if (slow == fast) return true
      slow = slow.next
      fast = fast.next.next
    }
    false
  }

  def main(args: Array[String]): Unit = {
    // List with cycle: 1 -> 2 -> 3 -> 4 -> 2
    val n4 = new ListNode(4)
    val n3 = new ListNode(3, n4)
    val n2 = new ListNode(2, n3)
    val n1 = new ListNode(1, n2)
    n4.next = n2
    println(s"Has cycle: ${hasCycle(n1)}")

    // List without cycle
    val n5b = new ListNode(5)
    val n4b = new ListNode(4, n5b)
    val n3b = new ListNode(3, n4b)
    val n2b = new ListNode(2, n3b)
    val n1b = new ListNode(1, n2b)
    println(s"Has cycle (no cycle): ${hasCycle(n1b)}")
  }
}
