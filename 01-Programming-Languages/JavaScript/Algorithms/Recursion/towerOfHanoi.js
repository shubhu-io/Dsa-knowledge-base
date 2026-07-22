/*
Problem: Tower of Hanoi
Description: Move n disks from source peg to destination peg using an auxiliary peg.
Larger disks cannot be placed on smaller disks.

Approach:
- Recursively move n-1 disks from source to auxiliary
- Move the nth disk from source to destination
- Recursively move n-1 disks from auxiliary to destination

Time Complexity: O(2^n)
Space Complexity: O(n)

Example:
Input: n = 3, source = 'A', destination = 'C', auxiliary = 'B'
Output: Sequence of moves
*/

function towerOfHanoi(n, source, destination, auxiliary) {
  if (n === 1) {
    console.log(`Move disk 1 from ${source} to ${destination}`);
    return;
  }
  towerOfHanoi(n - 1, source, auxiliary, destination);
  console.log(`Move disk ${n} from ${source} to ${destination}`);
  towerOfHanoi(n - 1, auxiliary, destination, source);
}

console.log('Tower of Hanoi for 3 disks:');
towerOfHanoi(3, 'A', 'C', 'B');
