/*
Problem: Palindrome Check
Check if a given string is a palindrome (reads the same forwards and backwards).

Approach:
- Use two pointers: left and right
- Compare characters at both ends moving inward
- Ignore non-alphanumeric characters and case

Time Complexity: O(n)
Space Complexity: O(1)

Example:
Input: s = "A man, a plan, a canal: Panama"
Output: true
*/

package main

import (
	"fmt"
	"strings"
	"unicode"
)

func isPalindrome(s string) bool {
	left, right := 0, len(s)-1
	for left < right {
		for left < right && !unicode.IsLetterOrDigit(rune(s[left])) {
			left++
		}
		for left < right && !unicode.IsLetterOrDigit(rune(s[right])) {
			right--
		}
		if strings.ToLower(string(s[left])) != strings.ToLower(string(s[right])) {
			return false
		}
		left++
		right--
	}
	return true
}

func main() {
	s := "A man, a plan, a canal: Panama"
	result := isPalindrome(s)
	fmt.Printf("Input: s = \"%s\"\nOutput: %t\n", s, result)
}
