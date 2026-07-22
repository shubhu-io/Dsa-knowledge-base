<?php

/*
Problem: Tower of Hanoi
Description: Move n disks from source peg to destination peg using an auxiliary peg.
             Only one disk can be moved at a time; larger disks cannot sit on smaller ones.

Approach:
- Move n-1 disks from source to auxiliary using destination as helper
- Move nth disk from source to destination
- Move n-1 disks from auxiliary to destination using source as helper

Time Complexity: O(2^n)
Space Complexity: O(n) (recursion stack)

Example:
Input:  n = 3, source = 'A', dest = 'C', aux = 'B'
Output:
  Move disk 1 from A to C
  Move disk 2 from A to B
  Move disk 1 from C to B
  Move disk 3 from A to C
  Move disk 1 from B to A
  Move disk 2 from B to C
  Move disk 1 from A to C
*/

function towerOfHanoi(int $n, string $source, string $dest, string $aux): void {
    if ($n === 1) {
        echo "Move disk 1 from $source to $dest\n";
        return;
    }
    towerOfHanoi($n - 1, $source, $aux, $dest);
    echo "Move disk $n from $source to $dest\n";
    towerOfHanoi($n - 1, $aux, $dest, $source);
}

towerOfHanoi(3, 'A', 'C', 'B');
