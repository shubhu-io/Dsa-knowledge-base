/*
 * Problem: Compute the nth Fibonacci number.
 * Approach: Dynamic programming with memoization (top-down).
 * Time Complexity: O(n)
 * Space Complexity: O(n)
 * Example: Input: n = 6 -> Output: 8
 */

public class Fibonacci {
    public static int fib(int n) {
        if (n <= 1) return n;
        int[] dp = new int[n + 1];
        dp[0] = 0;
        dp[1] = 1;
        for (int i = 2; i <= n; i++) {
            dp[i] = dp[i - 1] + dp[i - 2];
        }
        return dp[n];
    }

    public static void main(String[] args) {
        int n = 6;
        System.out.println(fib(n));
    }
}
