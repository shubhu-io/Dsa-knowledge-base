// Problem: Merge Two Sorted Lists
// Description: Merge two sorted linked lists into one sorted list.
//
// Approach:
// - Use a dummy head node
// - Compare nodes from both lists and attach the smaller one
//
// Time Complexity: O(n + m)
// Space Complexity: O(1)
//
// Example:
// Input: 1 -> 2 -> 4, 1 -> 3 -> 4
// Output: 1 -> 1 -> 2 -> 3 -> 4 -> 4

object MergeTwoSortedLists {
  class ListNode(var val: Int = 0, var next: ListNode = null)

  def mergeTwoLists(l1: ListNode, l2: ListNode): ListNode = {
    val dummy = new ListNode(0)
    var current = dummy
    var p1 = l1; var p2 = l2
    while (p1 != null && p2 != null) {
      if (p1.val <= p2.val) {
        current.next = p1; p1 = p1.next
      } else {
        current.next = p2; p2 = p2.next
      }
      current = current.next
    }
    if (p1 != null) current.next = p1
    if (p2 != null) current.next = p2
    dummy.next
  }

  def toVector(head: ListNode): Vector[Int] = {
    val buf = scala.collection.mutable.ArrayBuffer[Int]()
    var curr = head
    while (curr != null) { buf += curr.val; curr = curr.next }
    buf.toVector
  }

  def main(args: Array[String]): Unit = {
    val l1 = new ListNode(1, new ListNode(2, new ListNode(4)))
    val l2 = new ListNode(1, new ListNode(3, new ListNode(4)))
    val merged = mergeTwoLists(l1, l2)
    println(s"Merged: ${toVector(merged).mkString(" -> ")}")
  }
}
