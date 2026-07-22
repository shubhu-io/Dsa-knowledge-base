/*
 * Problem: Compute the nth Fibonacci number.
 * Approach: Dynamic programming with tabulation (bottom-up).
 * Time Complexity: O(n)
 * Space Complexity: O(n)
 * Example: Input: n = 6 -> Output: 8
 */

fun fib(n: Int): Int {
    if (n <= 1) return n
    val dp = IntArray(n + 1)
    dp[0] = 0; dp[1] = 1
    for (i in 2..n) dp[i] = dp[i - 1] + dp[i - 2]
    return dp[n]
}

fun main() {
    println(fib(6))
}
