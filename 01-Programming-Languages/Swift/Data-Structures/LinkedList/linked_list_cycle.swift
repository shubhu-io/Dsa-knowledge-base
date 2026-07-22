/*
Problem: Linked List Cycle Detection
Description: Detect if a linked list has a cycle using Floyd's
           Tortoise and Hare algorithm.

Approach:
- Use two pointers (slow moves 1 step, fast moves 2 steps)
- If they meet, a cycle exists
- If fast reaches nil, no cycle

Time Complexity: O(n)
Space Complexity: O(1)

Example:
Input: 3 -> 2 -> 0 -> -4 -> (back to index 1)
Output: true
*/

class ListNode {
    var val: Int
    var next: ListNode?
    init(_ val: Int) { self.val = val; self.next = nil }
}

func hasCycle(_ head: ListNode?) -> Bool {
    var slow = head, fast = head
    while fast != nil && fast?.next != nil {
        slow = slow?.next
        fast = fast?.next?.next
        if slow === fast { return true }
    }
    return false
}

let node1 = ListNode(3)
let node2 = ListNode(2)
let node3 = ListNode(0)
let node4 = ListNode(-4)
node1.next = node2
node2.next = node3
node3.next = node4
node4.next = node2
print("Has cycle: \(hasCycle(node1))")

let list2 = ListNode(1)
list2.next = ListNode(2)
print("Has cycle (no cycle): \(hasCycle(list2))")
