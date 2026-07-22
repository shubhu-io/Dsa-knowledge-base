<?php

/*
Problem: Fibonacci Number
Description: Compute the nth Fibonacci number using dynamic programming (bottom-up).

Approach:
- Use iterative DP with constant space
- Base cases: fib(0) = 0, fib(1) = 1
- Build up to n by tracking only the last two values

Time Complexity: O(n)
Space Complexity: O(1)

Example:
Input:  n = 10
Output: 55
*/

function fib(int $n): int {
    if ($n <= 1) return $n;
    $prev2 = 0;
    $prev1 = 1;
    for ($i = 2; $i <= $n; $i++) {
        $curr = $prev1 + $prev2;
        $prev2 = $prev1;
        $prev1 = $curr;
    }
    return $prev1;
}

for ($i = 0; $i <= 10; $i++) {
    echo "fib($i) = " . fib($i) . "\n";
}
