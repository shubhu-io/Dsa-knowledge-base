// Problem: Fibonacci Sequence
// Description: Compute the nth Fibonacci number using dynamic programming.
//
// Approach:
// - Use bottom-up DP with two variables
// - Build from base cases F(0)=0, F(1)=1 upward
//
// Time Complexity: O(n)
// Space Complexity: O(1)
//
// Example:
// Input: n = 10
// Output: 55

object Fibonacci {
  def fib(n: Int): Long = {
    if (n <= 1) return n
    var a = 0L; var b = 1L
    for (_ <- 2 to n) {
      val temp = a + b
      a = b
      b = temp
    }
    b
  }

  def main(args: Array[String]): Unit = {
    val n = 10
    println(s"Fibonacci($n) = ${fib(n)}")
    for (i <- 0 to 10) {
      println(s"F($i) = ${fib(i)}")
    }
  }
}
