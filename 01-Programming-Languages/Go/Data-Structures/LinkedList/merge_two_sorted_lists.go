/*
Problem: Merge Two Sorted Lists
Merge two sorted linked lists into one sorted list.

Approach:
- Use a dummy head node
- Compare heads of both lists, attach the smaller one
- Move pointer forward in the list that was used
- When one list is exhausted, attach the remainder of the other

Time Complexity: O(n + m)
Space Complexity: O(1)

Example:
Input: list1 = 1 -> 2 -> 4, list2 = 1 -> 3 -> 4
Output: 1 -> 1 -> 2 -> 3 -> 4 -> 4
*/

package main

import "fmt"

type ListNode struct {
	Val  int
	Next *ListNode
}

func mergeTwoLists(list1, list2 *ListNode) *ListNode {
	dummy := &ListNode{}
	current := dummy
	for list1 != nil && list2 != nil {
		if list1.Val <= list2.Val {
			current.Next = list1
			list1 = list1.Next
		} else {
			current.Next = list2
			list2 = list2.Next
		}
		current = current.Next
	}
	if list1 != nil {
		current.Next = list1
	} else {
		current.Next = list2
	}
	return dummy.Next
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
	list1 := &ListNode{1, &ListNode{2, &ListNode{4, nil}}}
	list2 := &ListNode{1, &ListNode{3, &ListNode{4, nil}}}
	fmt.Print("Input: list1 = ")
	printList(list1)
	fmt.Print("       list2 = ")
	printList(list2)
	result := mergeTwoLists(list1, list2)
	fmt.Print("Output: ")
	printList(result)
}
