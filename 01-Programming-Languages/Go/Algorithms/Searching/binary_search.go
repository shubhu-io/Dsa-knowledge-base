/*
Problem: Binary Search
Find the index of a target value in a sorted array using binary search.

Approach:
- Compare target with middle element
- If equal, return middle index
- If target < middle, search left half
- If target > middle, search right half
- Repeat until found or subarray is empty

Time Complexity: O(log n)
Space Complexity: O(1)

Example:
Input: arr = [1, 3, 5, 7, 9, 11, 13], target = 7
Output: 3
*/

package main

import "fmt"

func binarySearch(arr []int, target int) int {
	left, right := 0, len(arr)-1
	for left <= right {
		mid := left + (right-left)/2
		if arr[mid] == target {
			return mid
		} else if arr[mid] < target {
			left = mid + 1
		} else {
			right = mid - 1
		}
	}
	return -1
}

func main() {
	arr := []int{1, 3, 5, 7, 9, 11, 13}
	target := 7
	result := binarySearch(arr, target)
	fmt.Printf("Input: arr = %v, target = %d\nOutput: %d\n", arr, target, result)
}
