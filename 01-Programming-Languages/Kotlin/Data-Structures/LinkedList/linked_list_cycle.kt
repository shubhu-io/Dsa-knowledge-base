/*
 * Problem: Detect if a linked list has a cycle.
 * Approach: Floyd's cycle detection (tortoise and hare).
 * Time Complexity: O(n)
 * Space Complexity: O(1)
 * Example: Input: 1 -> 2 -> 3 -> 4 -> 2 (cycle) -> Output: true
 */

class ListNode(var `val`: Int) {
    var next: ListNode? = null
}

fun hasCycle(head: ListNode?): Boolean {
    var slow = head
    var fast = head
    while (fast != null && fast.next != null) {
        slow = slow!!.next
        fast = fast.next!!.next
        if (slow == fast) return true
    }
    return false
}

fun main() {
    val head = ListNode(1)
    head.next = ListNode(2)
    head.next!!.next = ListNode(3)
    head.next!!.next!!.next = ListNode(4)
    head.next!!.next!!.next!!.next = head.next
    println(hasCycle(head))
}
