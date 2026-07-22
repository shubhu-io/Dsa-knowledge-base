/*
 * Problem: Merge two sorted linked lists into one sorted list.
 * Approach: Iterative — compare nodes and link the smaller one.
 * Time Complexity: O(n + m)
 * Space Complexity: O(1)
 * Example: Input: 1 -> 3 -> 5, 2 -> 4 -> 6 -> Output: 1 -> 2 -> 3 -> 4 -> 5 -> 6 -> null
 */

class ListNode(var `val`: Int) {
    var next: ListNode? = null
}

fun mergeTwoLists(l1: ListNode?, l2: ListNode?): ListNode? {
    val dummy = ListNode(0)
    var tail: ListNode? = dummy
    var a = l1; var b = l2
    while (a != null && b != null) {
        if (a.`val` <= b.`val`) {
            tail!!.next = a; a = a.next
        } else {
            tail!!.next = b; b = b.next
        }
        tail = tail!!.next
    }
    tail!!.next = a ?: b
    return dummy.next
}

fun main() {
    val l1 = ListNode(1); l1.next = ListNode(3); l1.next!!.next = ListNode(5)
    val l2 = ListNode(2); l2.next = ListNode(4); l2.next!!.next = ListNode(6)
    var merged = mergeTwoLists(l1, l2)
    while (merged != null) {
        print("${merged.`val`} ")
        merged = merged.next
    }
}
