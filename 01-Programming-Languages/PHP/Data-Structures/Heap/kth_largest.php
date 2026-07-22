<?php

/*
Problem: Find Kth Largest Element
Description: Find the kth largest element in an array using a min-heap.

Approach:
- Use SplMinHeap to maintain the k largest elements seen so far
- For each element, push it; if heap size > k, pop the smallest
- The root of the heap is the kth largest

Time Complexity: O(n log k)
Space Complexity: O(k)

Example:
Input:  nums = [3, 2, 1, 5, 6, 4], k = 2
Output: 5
*/

function findKthLargest(array $nums, int $k): int {
    $heap = new SplMinHeap();
    foreach ($nums as $num) {
        $heap->insert($num);
        if ($heap->count() > $k) {
            $heap->extract();
        }
    }
    return $heap->top();
}

$nums = [3, 2, 1, 5, 6, 4];
$k = 2;
echo "{$k}th largest: " . findKthLargest($nums, $k) . "\n";

$nums = [3, 2, 3, 1, 2, 4, 5, 5, 6];
$k = 4;
echo "{$k}th largest: " . findKthLargest($nums, $k) . "\n";
