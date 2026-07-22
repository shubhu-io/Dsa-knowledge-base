/*
Problem: Fibonacci Number
Calculate the nth Fibonacci number using dynamic programming.

Approach:
- Use bottom-up DP with tabulation
- Store only the last two values to optimize space
- F(0) = 0, F(1) = 1, F(n) = F(n-1) + F(n-2)

Time Complexity: O(n)
Space Complexity: O(1)

Example:
Input: n = 10
Output: 55
*/

fn fibonacci(n: u32) -> u64 {
    if n <= 1 {
        return n as u64;
    }
    let (mut a, mut b) = (0, 1);
    for _ in 2..=n {
        let temp = a + b;
        a = b;
        b = temp;
    }
    b
}

fn main() {
    let n = 10;
    println!("Input: n = {}\nOutput: {}", n, fibonacci(n));
}
