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

int moveCount = 0;

void towerOfHanoi(int n, String source, String destination, String auxiliary) {
  if (n == 1) {
    moveCount++;
    print('Move disk 1 from $source to $destination');
    return;
  }
  towerOfHanoi(n - 1, source, auxiliary, destination);
  moveCount++;
  print('Move disk $n from $source to $destination');
  towerOfHanoi(n - 1, auxiliary, destination, source);
}

void main() {
  moveCount = 0;
  towerOfHanoi(3, "A", "C", "B");
  print('Total moves: $moveCount');
}
