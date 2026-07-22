/*
Problem: Merge Intervals
Merge all overlapping intervals in a list.

Approach:
- Sort intervals by start time
- Iterate through sorted intervals
- If current interval overlaps with last merged, merge them
- Otherwise, add as a new interval

Time Complexity: O(n log n)
Space Complexity: O(n)

Example:
Input: intervals = [[1,3],[2,6],[8,10],[15,18]]
Output: [[1,6],[8,10],[15,18]]
*/

package main

import (
	"fmt"
	"sort"
)

func merge(intervals [][]int) [][]int {
	if len(intervals) == 0 {
		return [][]int{}
	}
	sort.Slice(intervals, func(i, j int) bool {
		return intervals[i][0] < intervals[j][0]
	})
	result := [][]int{intervals[0]}
	for _, interval := range intervals[1:] {
		last := result[len(result)-1]
		if interval[0] <= last[1] {
			if interval[1] > last[1] {
				last[1] = interval[1]
			}
		} else {
			result = append(result, interval)
		}
	}
	return result
}

func main() {
	intervals := [][]int{{1, 3}, {2, 6}, {8, 10}, {15, 18}}
	result := merge(intervals)
	fmt.Printf("Input: intervals = %v\nOutput: %v\n", intervals, result)
}
