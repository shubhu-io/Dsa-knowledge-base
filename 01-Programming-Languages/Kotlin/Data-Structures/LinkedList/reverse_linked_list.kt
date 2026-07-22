/*
 * Problem: Reverse a singly linked list.
 * Approach: Iterative — reverse pointers using prev, current, next.
 * Time Complexity: O(n)
 * Space Complexity: O(1)
 * Example: Input: 1 -> 2 -> 3 -> 4 -> 5 -> null -> Output: 5 -> 4 -> 3 -> 2 -> 1 -> null
 */

class ListNode(var `val`: Int) {
    var next: ListNode? = null
}

fun reverseList(head: ListNode?): ListNode? {
    var prev: ListNode? = null
    var curr = head
    while (curr != null) {
        val next = curr.next
        curr.next = prev
        prev = curr
        curr = next
    }
    return prev
}

fun main() {
    val head = ListNode(1)
    head.next = ListNode(2)
    head.next!!.next = ListNode(3)
    head.next!!.next!!.next = ListNode(4)
    head.next!!.next!!.next!!.next = ListNode(5)
    var reversed = reverseList(head)
    while (reversed != null) {
        print("${reversed.`val`} ")
        reversed = reversed.next
    }
}
