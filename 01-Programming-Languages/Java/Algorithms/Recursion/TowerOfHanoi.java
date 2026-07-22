/*
 * Problem: Solve Tower of Hanoi for n disks.
 * Approach: Recursively move n-1 disks to auxiliary, largest to target, then n-1 to target.
 * Time Complexity: O(2^n)
 * Space Complexity: O(n) (recursion stack)
 * Example: Input: n = 3 -> Output: moves to transfer 3 disks from A to C
 */

public class TowerOfHanoi {
    public static void solve(int n, char from, char to, char aux) {
        if (n == 1) {
            System.out.println("Move disk 1 from " + from + " to " + to);
            return;
        }
        solve(n - 1, from, aux, to);
        System.out.println("Move disk " + n + " from " + from + " to " + to);
        solve(n - 1, aux, to, from);
    }

    public static void main(String[] args) {
        int n = 3;
        solve(n, 'A', 'C', 'B');
    }
}
