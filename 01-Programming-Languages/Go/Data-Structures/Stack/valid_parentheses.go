/*
Problem: Valid Parentheses
Check if a string containing parentheses is valid (every opening bracket has a matching closing bracket in correct order).

Approach:
- Use a stack to track opening brackets
- For each closing bracket, check if it matches the top of the stack
- Stack should be empty at the end

Time Complexity: O(n)
Space Complexity: O(n)

Example:
Input: s = "()[]{}"
Output: true
*/

package main

import "fmt"

func isValid(s string) bool {
	pairs := map[rune]rune{')': '(', ']': '[', '}': '{'}
	stack := []rune{}
	for _, ch := range s {
		if open, ok := pairs[ch]; ok {
			if len(stack) == 0 || stack[len(stack)-1] != open {
				return false
			}
			stack = stack[:len(stack)-1]
		} else {
			stack = append(stack, ch)
		}
	}
	return len(stack) == 0
}

func main() {
	s := "()[]{}"
	result := isValid(s)
	fmt.Printf("Input: s = \"%s\"\nOutput: %t\n", s, result)
}
