/*
Problem: Tower of Hanoi
Description: Solve the Tower of Hanoi puzzle. Move n disks from source
           peg to destination peg using an auxiliary peg.

Approach:
- Recursively move n-1 disks from source to auxiliary
- Move the nth disk from source to destination
- Recursively move n-1 disks from auxiliary to destination

Time Complexity: O(2^n)
Space Complexity: O(n) for recursion stack

Example:
Input: n = 3, source = "A", destination = "C", auxiliary = "B"
Output: Move disk 1 from A to C, ...
*/

var moveCount = 0

func towerOfHanoi(n: Int, source: String, destination: String, auxiliary: String) {
    if n == 1 {
        moveCount += 1
        print("Move disk 1 from \(source) to \(destination)")
        return
    }
    towerOfHanoi(n: n - 1, source: source, destination: auxiliary, auxiliary: destination)
    moveCount += 1
    print("Move disk \(n) from \(source) to \(destination)")
    towerOfHanoi(n: n - 1, source: auxiliary, destination: destination, auxiliary: source)
}

moveCount = 0
towerOfHanoi(n: 3, source: "A", destination: "C", auxiliary: "B")
print("Total moves: \(moveCount)")
