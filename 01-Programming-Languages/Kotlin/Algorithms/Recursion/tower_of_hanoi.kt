/*
 * Problem: Solve Tower of Hanoi for n disks.
 * Approach: Recursively move n-1 disks to auxiliary, largest to target, then n-1 to target.
 * Time Complexity: O(2^n)
 * Space Complexity: O(n) (recursion stack)
 * Example: Input: n = 3 -> Output: moves to transfer 3 disks from A to C
 */

fun solve(n: Int, from: Char, to: Char, aux: Char) {
    if (n == 1) {
        println("Move disk 1 from $from to $to")
        return
    }
    solve(n - 1, from, aux, to)
    println("Move disk $n from $from to $to")
    solve(n - 1, aux, to, from)
}

fun main() {
    solve(3, 'A', 'C', 'B')
}
