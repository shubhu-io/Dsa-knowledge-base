<?php

/*
Problem: Merge Intervals
Description: Merge all overlapping intervals in a collection.

Approach:
- Sort intervals by start value
- Iterate and merge overlapping intervals (current.start <= previous.end)
- If overlapping, extend previous.end if needed; else add to result

Time Complexity: O(n log n)
Space Complexity: O(n)

Example:
Input:  [[1,3],[2,6],[8,10],[15,18]]
Output: [[1,6],[8,10],[15,18]]
*/

function mergeIntervals(array $intervals): array {
    if (empty($intervals)) return [];
    usort($intervals, fn($a, $b) => $a[0] <=> $b[0]);
    $merged = [$intervals[0]];
    for ($i = 1; $i < count($intervals); $i++) {
        $last = &$merged[count($merged) - 1];
        if ($intervals[$i][0] <= $last[1]) {
            $last[1] = max($last[1], $intervals[$i][1]);
        } else {
            $merged[] = $intervals[$i];
        }
    }
    return $merged;
}

$intervals = [[1,3],[2,6],[8,10],[15,18]];
$result = mergeIntervals($intervals);
echo "Merged: " . json_encode($result) . "\n";
