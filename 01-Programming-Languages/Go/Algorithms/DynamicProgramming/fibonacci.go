/*
Problem: Fibonacci Number
Calculate the nth Fibonacci number using dynamic programming.

Approach:
- Use bottom-up DP with tabulation
- Store only the last two values to optimize space
- F(0) = 0, F(1) = 1, F(n) = F(n-1) + F(n-2)

Time Complexity: O(n)
Space Complexity: O(1)

Example:
Input: n = 10
Output: 55
*/

package main

import "fmt"

func fibonacci(n int) int {
	if n <= 1 {
		return n
	}
	a, b := 0, 1
	for i := 2; i <= n; i++ {
		a, b = b, a+b
	}
	return b
}

func main() {
	n := 10
	result := fibonacci(n)
	fmt.Printf("Input: n = %d\nOutput: %d\n", n, result)
}
