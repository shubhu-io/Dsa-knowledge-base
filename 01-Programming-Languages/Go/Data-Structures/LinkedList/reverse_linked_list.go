/*
Problem: Reverse Linked List
Reverse a singly linked list.

Approach:
- Use three pointers: prev, curr, next
- Iteratively reverse the next pointer of each node
- Return the new head (prev)

Time Complexity: O(n)
Space Complexity: O(1)

Example:
Input: 1 -> 2 -> 3 -> 4 -> 5
Output: 5 -> 4 -> 3 -> 2 -> 1
*/

package main

import "fmt"

type ListNode struct {
	Val  int
	Next *ListNode
}

func reverseList(head *ListNode) *ListNode {
	var prev *ListNode
	curr := head
	for curr != nil {
		next := curr.Next
		curr.Next = prev
		prev = curr
		curr = next
	}
	return prev
}

func printList(head *ListNode) {
	for head != nil {
		fmt.Printf("%d", head.Val)
		if head.Next != nil {
			fmt.Print(" -> ")
		}
		head = head.Next
	}
	fmt.Println()
}

func main() {
	head := &ListNode{1, &ListNode{2, &ListNode{3, &ListNode{4, &ListNode{5, nil}}}}}
	fmt.Print("Input: ")
	printList(head)
	result := reverseList(head)
	fmt.Print("Output: ")
	printList(result)
}
