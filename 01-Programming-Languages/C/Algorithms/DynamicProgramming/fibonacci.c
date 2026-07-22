/*
Problem: Fibonacci (Dynamic Programming)
Compute the nth Fibonacci number using dynamic programming.

Approach:
- Bottom-up DP with memoization

Time Complexity: O(n)
Space Complexity: O(1)

Example:
Input: n = 10
Output: 55
*/

#include <stdio.h>

int fibonacci(int n)
{
    if (n <= 1) return n;
    int a = 0, b = 1, c;
    for (int i = 2; i <= n; i++)
    {
        c = a + b;
        a = b;
        b = c;
    }
    return b;
}

int main()
{
    int n = 10;
    printf("Fibonacci(%d) = %d\n", n, fibonacci(n));
    return 0;
}
