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

package main

import "fmt"

func towerOfHanoi(n int, source, destination, auxiliary string) {
	if n == 1 {
		fmt.Printf("Move disk 1 from %s to %s\n", source, destination)
		return
	}
	towerOfHanoi(n-1, source, auxiliary, destination)
	fmt.Printf("Move disk %d from %s to %s\n", n, source, destination)
	towerOfHanoi(n-1, auxiliary, destination, source)
}

func main() {
	n := 3
	fmt.Printf("Input: n = %d, source = A, destination = C, auxiliary = B\nOutput:\n", n)
	towerOfHanoi(n, "A", "C", "B")
}
