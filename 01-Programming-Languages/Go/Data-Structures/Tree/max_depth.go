/*
Problem: Maximum Depth of Binary Tree
Find the maximum depth (height) of a binary tree.

Approach:
- Recursively compute the max depth of left and right subtrees
- Return 1 + max(leftDepth, rightDepth)
- Base case: null node has depth 0

Time Complexity: O(n)
Space Complexity: O(n)

Example:
Input: tree = [3, 9, 20, null, null, 15, 7]
Output: 3
*/

package main

import "fmt"

type TreeNode struct {
	Val   int
	Left  *TreeNode
	Right *TreeNode
}

func maxDepth(root *TreeNode) int {
	if root == nil {
		return 0
	}
	left := maxDepth(root.Left)
	right := maxDepth(root.Right)
	if left > right {
		return left + 1
	}
	return right + 1
}

func main() {
	root := &TreeNode{3,
		&TreeNode{9, nil, nil},
		&TreeNode{20, &TreeNode{15, nil, nil}, &TreeNode{7, nil, nil}},
	}
	result := maxDepth(root)
	fmt.Println("Output:", result)
}
