/*
Problem: Binary Tree Traversals
Perform inorder, preorder, and postorder traversals of a binary tree.

Approach:
- Inorder: left, root, right
- Preorder: root, left, right
- Postorder: left, right, root

Time Complexity: O(n)
Space Complexity: O(n)

Example:
Input: tree = [1, 2, 3, 4, 5]
Output:
  Inorder: [4, 2, 5, 1, 3]
  Preorder: [1, 2, 4, 5, 3]
  Postorder: [4, 5, 2, 3, 1]
*/

package main

import "fmt"

type TreeNode struct {
	Val   int
	Left  *TreeNode
	Right *TreeNode
}

func inorder(root *TreeNode) []int {
	var result []int
	var dfs func(*TreeNode)
	dfs = func(node *TreeNode) {
		if node == nil {
			return
		}
		dfs(node.Left)
		result = append(result, node.Val)
		dfs(node.Right)
	}
	dfs(root)
	return result
}

func preorder(root *TreeNode) []int {
	var result []int
	var dfs func(*TreeNode)
	dfs = func(node *TreeNode) {
		if node == nil {
			return
		}
		result = append(result, node.Val)
		dfs(node.Left)
		dfs(node.Right)
	}
	dfs(root)
	return result
}

func postorder(root *TreeNode) []int {
	var result []int
	var dfs func(*TreeNode)
	dfs = func(node *TreeNode) {
		if node == nil {
			return
		}
		dfs(node.Left)
		dfs(node.Right)
		result = append(result, node.Val)
	}
	dfs(root)
	return result
}

func main() {
	root := &TreeNode{1,
		&TreeNode{2, &TreeNode{4, nil, nil}, &TreeNode{5, nil, nil}},
		&TreeNode{3, nil, nil},
	}
	fmt.Println("Inorder:", inorder(root))
	fmt.Println("Preorder:", preorder(root))
	fmt.Println("Postorder:", postorder(root))
}
