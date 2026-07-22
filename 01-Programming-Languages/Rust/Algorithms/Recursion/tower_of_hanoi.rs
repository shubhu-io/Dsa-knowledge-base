/*
Problem: Tower of Hanoi
Move n disks from source peg to destination peg using an auxiliary peg.
Only one disk can be moved at a time, and a larger disk cannot be placed on a smaller one.

Approach:
- Move n-1 disks from source to auxiliary
- Move the largest disk from source to destination
- Move n-1 disks from auxiliary to destination

Time Complexity: O(2^n)
Space Complexity: O(n)

Example:
Input: n = 3, source = "A", destination = "C", auxiliary = "B"
Output:
Move disk 1 from A to C
Move disk 2 from A to B
Move disk 1 from C to B
Move disk 3 from A to C
Move disk 1 from B to A
Move disk 2 from B to C
Move disk 1 from A to C
*/

fn tower_of_hanoi(n: u32, source: &str, destination: &str, auxiliary: &str) {
    if n == 1 {
        println!("Move disk 1 from {} to {}", source, destination);
        return;
    }
    tower_of_hanoi(n - 1, source, auxiliary, destination);
    println!("Move disk {} from {} to {}", n, source, destination);
    tower_of_hanoi(n - 1, auxiliary, destination, source);
}

fn main() {
    println!("Input: n = 3, source = A, destination = C, auxiliary = B\nOutput:");
    tower_of_hanoi(3, "A", "C", "B");
}
