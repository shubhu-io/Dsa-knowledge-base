<?php

/*
Problem: Merge Sort
Description: Sort an array using the divide-and-conquer merge sort algorithm.
             Recursively split the array into halves, sort each half, then merge.

Approach:
- Divide array into two halves recursively until single elements
- Merge sorted halves by comparing elements sequentially
- Time: O(n log n), Space: O(n)

Time Complexity: O(n log n)
Space Complexity: O(n)

Example:
Input:  [38, 27, 43, 3, 9, 82, 10]
Output: [3, 9, 10, 27, 38, 43, 82]
*/

function mergeSort(array &$arr, int $left, int $right): void {
    if ($left < $right) {
        $mid = intdiv($left + $right, 2);
        mergeSort($arr, $left, $mid);
        mergeSort($arr, $mid + 1, $right);
        merge($arr, $left, $mid, $right);
    }
}

function merge(array &$arr, int $left, int $mid, int $right): void {
    $n1 = $mid - $left + 1;
    $n2 = $right - $mid;
    $L = array_slice($arr, $left, $n1);
    $R = array_slice($arr, $mid + 1, $n2);
    $i = $j = 0;
    $k = $left;
    while ($i < $n1 && $j < $n2) {
        if ($L[$i] <= $R[$j]) {
            $arr[$k++] = $L[$i++];
        } else {
            $arr[$k++] = $R[$j++];
        }
    }
    while ($i < $n1) $arr[$k++] = $L[$i++];
    while ($j < $n2) $arr[$k++] = $R[$j++];
}

$arr = [38, 27, 43, 3, 9, 82, 10];
echo "Original: " . implode(", ", $arr) . "\n";
mergeSort($arr, 0, count($arr) - 1);
echo "Sorted:   " . implode(", ", $arr) . "\n";
