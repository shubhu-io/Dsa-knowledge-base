/*
Problem: Tower of Hanoi
Description: Move n disks from source peg to destination peg using auxiliary peg.

Approach:
- Recursively move n-1 disks from source to auxiliary, then nth disk, then n-1 from auxiliary

Time Complexity: O(2^n)
Space Complexity: O(n)

Example:
Input: n = 3, source = 'A', destination = 'C', auxiliary = 'B'
Output: Sequence of moves
*/

function towerOfHanoi(n: number, source: string, destination: string, auxiliary: string): void {
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
