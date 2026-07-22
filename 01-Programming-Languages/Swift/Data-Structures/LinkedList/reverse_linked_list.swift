/*
Problem: Reverse Linked List
Description: Reverse a singly linked list and return the new head.

Approach:
- Use iterative three-pointer technique (prev, current, next)
- Reverse each node's next pointer to point to previous node

Time Complexity: O(n)
Space Complexity: O(1)

Example:
Input: 1 -> 2 -> 3 -> 4 -> 5
Output: 5 -> 4 -> 3 -> 2 -> 1
*/

class ListNode {
    var val: Int
    var next: ListNode?
    init(_ val: Int) { self.val = val; self.next = nil }
}

func reverseList(_ head: ListNode?) -> ListNode? {
    var prev: ListNode? = nil
    var curr = head
    while curr != nil {
        let next = curr?.next
        curr?.next = prev
        prev = curr
        curr = next
    }
    return prev
}

func printList(_ head: ListNode?) {
    var current = head
    while current != nil {
        print(current!.val, terminator: current?.next != nil ? " -> " : "")
        current = current?.next
    }
    print()
}

let head = ListNode(1)
head.next = ListNode(2)
head.next?.next = ListNode(3)
head.next?.next?.next = ListNode(4)
head.next?.next?.next?.next = ListNode(5)
print("Original:", terminator: " ")
printList(head)
let reversed = reverseList(head)
print("Reversed:", terminator: " ")
printList(reversed)
