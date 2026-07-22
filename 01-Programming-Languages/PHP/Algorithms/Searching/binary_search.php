<?php

/*
Problem: Binary Search
Description: Find the index of a target value in a sorted array using binary search.

Approach:
- Compare target with middle element; if equal return index
- If target < middle, search left half; else search right half
- Repeat until found or subarray is empty

Time Complexity: O(log n)
Space Complexity: O(1)

Example:
Input:  nums = [1, 3, 5, 7, 9, 11], target = 7
Output: 3
*/

function binarySearch(array $nums, int $target): int {
    $left = 0;
    $right = count($nums) - 1;
    while ($left <= $right) {
        $mid = $left + intdiv($right - $left, 2);
        if ($nums[$mid] === $target) return $mid;
        if ($nums[$mid] < $target) $left = $mid + 1;
        else $right = $mid - 1;
    }
    return -1;
}

$nums = [1, 3, 5, 7, 9, 11];
$target = 7;
$result = binarySearch($nums, $target);
echo "Index of $target: $result\n";

$target = 4;
$result = binarySearch($nums, $target);
echo "Index of $target: $result\n";
