// Problem: Reverse Linked List
// Description: Reverse a singly linked list iteratively.
//
// Approach:
// - Use three pointers: prev, current, next
// - Reverse links as we traverse the list
//
// Time Complexity: O(n)
// Space Complexity: O(1)
//
// Example:
// Input: 1 -> 2 -> 3 -> 4 -> 5
// Output: 5 -> 4 -> 3 -> 2 -> 1

object ReverseLinkedList {
  class ListNode(var val: Int = 0, var next: ListNode = null)

  def reverse(head: ListNode): ListNode = {
    var prev: ListNode = null
    var current = head
    while (current != null) {
      val nextNode = current.next
      current.next = prev
      prev = current
      current = nextNode
    }
    prev
  }

  def toVector(head: ListNode): Vector[Int] = {
    val buf = scala.collection.mutable.ArrayBuffer[Int]()
    var curr = head
    while (curr != null) { buf += curr.val; curr = curr.next }
    buf.toVector
  }

  def main(args: Array[String]): Unit = {
    val n5 = new ListNode(5)
    val n4 = new ListNode(4, n5)
    val n3 = new ListNode(3, n4)
    val n2 = new ListNode(2, n3)
    val n1 = new ListNode(1, n2)
    println(s"Original: ${toVector(n1).mkString(" -> ")}")
    val reversed = reverse(n1)
    println(s"Reversed: ${toVector(reversed).mkString(" -> ")}")
  }
}
