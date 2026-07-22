/*
Problem: Fibonacci Number
Description: Calculate the nth Fibonacci number using dynamic programming.
           F(0) = 0, F(1) = 1, F(n) = F(n-1) + F(n-2)

Approach:
- Use bottom-up DP with tabulation
- Store only last two values to optimize space

Time Complexity: O(n)
Space Complexity: O(1)

Example:
Input: n = 10
Output: 55
*/

int fibonacci(int n) {
  if (n <= 1) return n;
  int a = 0, b = 1;
  for (int i = 2; i <= n; i++) {
    int temp = a + b;
    a = b;
    b = temp;
  }
  return b;
}

void main() {
  for (int i = 0; i <= 10; i++) {
    print('fib($i) = ${fibonacci(i)}');
  }
}
