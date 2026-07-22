/*
Problem: Linked List Cycle
Detect if a linked list has a cycle.

Approach:
- Use Floyd's cycle detection (two pointers: slow and fast)
- Slow moves one step, fast moves two steps
- If they meet, a cycle exists

Time Complexity: O(n)
Space Complexity: O(1)

Example:
Input: 3 -> 2 -> 0 -> -4 (cycle at node 2)
Output: true (cycle detected)
*/

package main

import "fmt"

type ListNode struct {
	Val  int
	Next *ListNode
}

func hasCycle(head *ListNode) bool {
	slow, fast := head, head
	for fast != nil && fast.Next != nil {
		slow = slow.Next
		fast = fast.Next.Next
		if slow == fast {
			return true
		}
	}
	return false
}

func main() {
	head := &ListNode{3, &ListNode{2, &ListNode{0, &ListNode{-4, nil}}}}
	head.Next.Next.Next.Next = head.Next // create cycle
	result := hasCycle(head)
	fmt.Println("Output:", result)
}
