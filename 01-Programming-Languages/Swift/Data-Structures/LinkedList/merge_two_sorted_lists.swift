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
    var val: Int
    var next: ListNode?
    init(_ val: Int) { self.val = val; self.next = nil }
}

func mergeTwoLists(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
    let dummy = ListNode(0)
    var tail: ListNode? = dummy
    var p1 = l1, p2 = l2
    while p1 != nil && p2 != nil {
        if p1!.val <= p2!.val {
            tail?.next = p1
            p1 = p1?.next
        } else {
            tail?.next = p2
            p2 = p2?.next
        }
        tail = tail?.next
    }
    tail?.next = p1 ?? p2
    return dummy.next
}

func printList(_ head: ListNode?) {
    var current = head
    while current != nil {
        print(current!.val, terminator: current?.next != nil ? " -> " : "")
        current = current?.next
    }
    print()
}

let l1 = ListNode(1); l1.next = ListNode(2); l1.next?.next = ListNode(4)
let l2 = ListNode(1); l2.next = ListNode(3); l2.next?.next = ListNode(4)
let merged = mergeTwoLists(l1, l2)
print("Merged list:", terminator: " ")
printList(merged)
