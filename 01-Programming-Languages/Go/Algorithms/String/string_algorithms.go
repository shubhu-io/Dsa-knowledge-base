// Package main demonstrates string algorithms in Go.
// This file implements common string manipulation algorithms using Go's
// strings package and rune slices for proper Unicode handling.
package main

import (
	"fmt"
	"strings"
	"unicode"
)

// IsPalindrome checks if a string reads the same forwards and backwards.
// Time complexity: O(n), Space complexity: O(n) for the cleaned string.
func IsPalindrome(s string) bool {
	// Convert to lowercase and remove non-alphanumeric characters
	cleaned := strings.Map(func(r rune) rune {
		if unicode.IsLetter(r) || unicode.IsDigit(r) {
			return unicode.ToLower(r)
		}
		return -1 // Remove character
	}, s)

	// Compare with reversed string
	runes := []rune(cleaned)
	for i, j := 0, len(runes)-1; i < j; i, j = i+1, j-1 {
		if runes[i] != runes[j] {
			return false
		}
	}
	return true
}

// IsAnagram checks if two strings are anagrams of each other.
// Time complexity: O(n), Space complexity: O(1) for fixed character set.
func IsAnagram(s1, s2 string) bool {
	// Convert to lowercase and remove spaces
	s1 = strings.ToLower(strings.ReplaceAll(s1, " ", ""))
	s2 = strings.ToLower(strings.ReplaceAll(s2, " ", ""))

	if len(s1) != len(s2) {
		return false
	}

	// Count character frequencies
	freq := make(map[rune]int)
	for _, r := range s1 {
		freq[r]++
	}
	for _, r := range s2 {
		freq[r]--
		if freq[r] < 0 {
			return false
		}
	}
	return true
}

// ReverseString reverses a string handling Unicode properly.
// Time complexity: O(n), Space complexity: O(n).
func ReverseString(s string) string {
	runes := []rune(s)
	for i, j := 0, len(runes)-1; i < j; i, j = i+1, j-1 {
		runes[i], runes[j] = runes[j], runes[i]
	}
	return string(runes)
}

// LongestCommonSubstring finds the longest common substring between two strings.
// Time complexity: O(m*n), Space complexity: O(m*n).
func LongestCommonSubstring(s1, s2 string) string {
	if len(s1) == 0 || len(s2) == 0 {
		return ""
	}

	// Create DP table
	dp := make([][]int, len(s1)+1)
	for i := range dp {
		dp[i] = make([]int, len(s2)+1)
	}

	maxLen := 0
	endPos := 0

	// Fill DP table
	for i := 1; i <= len(s1); i++ {
		for j := 1; j <= len(s2); j++ {
			if s1[i-1] == s2[j-1] {
				dp[i][j] = dp[i-1][j-1] + 1
				if dp[i][j] > maxLen {
					maxLen = dp[i][j]
					endPos = i
				}
			}
		}
	}

	return s1[endPos-maxLen : endPos]
}

// LongestCommonPrefix finds the longest common prefix among an array of strings.
// Time complexity: O(S) where S is the sum of all characters, Space complexity: O(1).
func LongestCommonPrefix(strs []string) string {
	if len(strs) == 0 {
		return ""
	}

	// Use first string as reference
	prefix := strs[0]

	for i := 1; i < len(strs); i++ {
		// Reduce prefix until it matches the start of strs[i]
		for !strings.HasPrefix(strs[i], prefix) {
			prefix = prefix[:len(prefix)-1]
			if prefix == "" {
				return ""
			}
		}
	}

	return prefix
}

// CountVowels counts the number of vowels in a string.
// Time complexity: O(n), Space complexity: O(1).
func CountVowels(s string) int {
	count := 0
	for _, r := range strings.ToLower(s) {
		switch r {
		case 'a', 'e', 'i', 'o', 'u':
			count++
		}
	}
	return count
}

// CountWords counts the number of words in a string.
// Time complexity: O(n), Space complexity: O(1).
func CountWords(s string) int {
	return len(strings.Fields(s))
}

// ToCamelCase converts a string to camelCase.
// Time complexity: O(n), Space complexity: O(n).
func ToCamelCase(s string) string {
	words := strings.FieldsFunc(s, func(r rune) bool {
		return !unicode.IsLetter(r) && !unicode.IsDigit(r)
	})

	if len(words) == 0 {
		return ""
	}

	var result strings.Builder
	result.WriteString(strings.ToLower(words[0]))

	for _, word := range words[1:] {
		if len(word) > 0 {
			runes := []rune(word)
			runes[0] = unicode.ToUpper(runes[0])
			result.WriteString(string(runes))
		}
	}

	return result.String()
}

// ToSnakeCase converts a string to snake_case.
// Time complexity: O(n), Space complexity: O(n).
func ToSnakeCase(s string) string {
	var result strings.Builder
	for i, r := range s {
		if unicode.IsUpper(r) {
			if i > 0 {
				result.WriteRune('_')
			}
			result.WriteRune(unicode.ToLower(r))
		} else {
			result.WriteRune(r)
		}
	}
	return result.String()
}

// Contains checks if a string contains a substring (reinventing for demonstration).
// Time complexity: O(n*m), Space complexity: O(1).
func Contains(s, substr string) bool {
	return strings.Contains(s, substr)
}

// StringRotation checks if one string is a rotation of another.
// Time complexity: O(n), Space complexity: O(n).
func StringRotation(s1, s2 string) bool {
	if len(s1) != len(s2) {
		return false
	}
	// Concatenate s1 with itself and check if s2 is a substring
	combined := s1 + s1
	return strings.Contains(combined, s2)
}

// RunLengthEncoding compresses a string using run-length encoding.
// Time complexity: O(n), Space complexity: O(n).
func RunLengthEncoding(s string) string {
	if len(s) == 0 {
		return ""
	}

	var result strings.Builder
	count := 1

	for i := 1; i <= len(s); i++ {
		if i < len(s) && s[i] == s[i-1] {
			count++
		} else {
			result.WriteByte(s[i-1])
			if count > 1 {
				result.WriteString(fmt.Sprintf("%d", count))
			}
			count = 1
		}
	}

	return result.String()
}

// RunLengthDecoding decodes a run-length encoded string.
// Time complexity: O(n), Space complexity: O(n).
func RunLengthDecoding(s string) string {
	var result strings.Builder
	i := 0

	for i < len(s) {
		char := s[i]
		i++

		// Read the count
		count := 0
		for i < len(s) && s[i] >= '0' && s[i] <= '9' {
			count = count*10 + int(s[i]-'0')
			i++
		}

		// Append character count times
		if count == 0 {
			count = 1
		}
		for j := 0; j < count; j++ {
			result.WriteByte(char)
		}
	}

	return result.String()
}

func main() {
	fmt.Println("=== String Algorithms in Go ===")
	fmt.Println()

	// Palindrome check
	palindromeTests := []string{"racecar", "A man a plan a canal Panama", "hello"}
	for _, test := range palindromeTests {
		fmt.Printf("IsPalindrome(%q): %v\n", test, IsPalindrome(test))
	}
	fmt.Println()

	// Anagram check
	fmt.Printf("IsAnagram(%q, %q): %v\n", "listen", "silent", IsAnagram("listen", "silent"))
	fmt.Printf("IsAnagram(%q, %q): %v\n", "hello", "world", IsAnagram("hello", "world"))
	fmt.Println()

	// String reversal
	fmt.Printf("ReverseString(%q): %v\n", "hello", ReverseString("hello"))
	fmt.Printf("ReverseString(%q): %v\n", "racecar", ReverseString("racecar"))
	fmt.Println()

	// Longest common substring
	fmt.Printf("LongestCommonSubstring(%q, %q): %v\n", "abcdef", "bcdefg", LongestCommonSubstring("abcdef", "bcdefg"))
	fmt.Println()

	// Longest common prefix
	fmt.Printf("LongestCommonPrefix(%v): %v\n",
		[]string{"flower", "flow", "flight"},
		LongestCommonPrefix([]string{"flower", "flow", "flight"}))
	fmt.Println()

	// Count vowels and words
	fmt.Printf("CountVowels(%q): %v\n", "Hello World", CountVowels("Hello World"))
	fmt.Printf("CountWords(%q): %v\n", "This is a test", CountWords("This is a test"))
	fmt.Println()

	// Case conversion
	fmt.Printf("ToCamelCase(%q): %v\n", "hello world", ToCamelCase("hello world"))
	fmt.Printf("ToSnakeCase(%q): %v\n", "helloWorld", ToSnakeCase("helloWorld"))
	fmt.Println()

	// String rotation
	fmt.Printf("StringRotation(%q, %q): %v\n", "waterbottle", "erbottlewat", StringRotation("waterbottle", "erbottlewat"))
	fmt.Println()

	// Run-length encoding
	encoded := RunLengthEncoding("aaabbbccc")
	fmt.Printf("RunLengthEncoding(%q): %v\n", "aaabbbccc", encoded)
	fmt.Printf("RunLengthDecoding(%q): %v\n", encoded, RunLengthDecoding(encoded))
}