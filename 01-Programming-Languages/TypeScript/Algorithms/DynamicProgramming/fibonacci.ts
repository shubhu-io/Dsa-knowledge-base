/*
Problem: Fibonacci Number
Description: Compute the nth Fibonacci number using dynamic programming.

Approach:
- Use bottom-up DP with O(n) iteration storing only last two values

Time Complexity: O(n)
Space Complexity: O(1)

Example:
Input: n = 10
Output: 55
*/

function fibonacci(n: number): number {
  if (n <= 1) return n;
  let prev = 0, curr = 1;
  for (let i = 2; i <= n; i++) {
    const next = prev + curr;
    prev = curr;
    curr = next;
  }
  return curr;
}

console.log('fibonacci(10):', fibonacci(10));
console.log('fibonacci(0):', fibonacci(0));
console.log('fibonacci(1):', fibonacci(1));
console.log('fibonacci(20):', fibonacci(20));
