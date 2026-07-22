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

func fibonacci(_ n: Int) -> Int {
    guard n > 1 else { return n }
    var a = 0, b = 1
    for _ in 2...n {
        let temp = a + b
        a = b
        b = temp
    }
    return b
}

for i in 0...10 {
    print("fib(\(i)) = \(fibonacci(i))")
}
