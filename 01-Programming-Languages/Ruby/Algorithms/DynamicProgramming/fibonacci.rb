=begin
Problem: Fibonacci Number
Description: Compute the nth Fibonacci number using dynamic programming (bottom-up).

Approach:
- Use iterative DP with constant space
- Base cases: fib(0) = 0, fib(1) = 1

Time Complexity: O(n)
Space Complexity: O(1)

Example:
Input:  n = 10
Output: 55
=end

def fib(n)
  return n if n <= 1
  prev2 = 0
  prev1 = 1
  (2..n).each do
    curr = prev1 + prev2
    prev2 = prev1
    prev1 = curr
  end
  prev1
end

(0..10).each { |i| puts "fib(#{i}) = #{fib(i)}" }
