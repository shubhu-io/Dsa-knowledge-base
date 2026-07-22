# Problem: Fibonacci Sequence
# Description: Compute the nth Fibonacci number using dynamic programming.
#
# Approach:
# - Use bottom-up DP with memoization
# - Build from base cases F(0)=0, F(1)=1 upward
#
# Time Complexity: O(n)
# Space Complexity: O(1)
#
# Example:
# Input: n = 10
# Output: 55

fibonacci <- function(n) {
  if (n <= 1) return(n)
  a <- 0
  b <- 1
  for (i in 2:n) {
    temp <- a + b
    a <- b
    b <- temp
  }
  b
}

n <- 10
cat("Fibonacci(", n, ") =", fibonacci(n), "\n")
for (i in 0:10) {
  cat("F(", i, ") =", fibonacci(i), "\n")
}
