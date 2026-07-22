/*
Problem: Merge Sort
Implement merge sort algorithm to sort an array of integers in ascending order.

Approach:
- Divide the array into two halves recursively
- Merge the sorted halves back together
- Base case: array of length 0 or 1 is already sorted

Time Complexity: O(n log n)
Space Complexity: O(n)

Example:
Input: [38, 27, 43, 3, 9, 82, 10]
Output: [3, 9, 10, 27, 38, 43, 82]
*/

package main

import "fmt"

func mergeSort(arr []int) []int {
	if len(arr) <= 1 {
		return arr
	}
	mid := len(arr) / 2
	left := mergeSort(arr[:mid])
	right := mergeSort(arr[mid:])
	return merge(left, right)
}

func merge(left, right []int) []int {
	result := make([]int, 0, len(left)+len(right))
	i, j := 0, 0
	for i < len(left) && j < len(right) {
		if left[i] <= right[j] {
			result = append(result, left[i])
			i++
		} else {
			result = append(result, right[j])
			j++
		}
	}
	result = append(result, left[i:]...)
	result = append(result, right[j:]...)
	return result
}

func main() {
	arr := []int{38, 27, 43, 3, 9, 82, 10}
	fmt.Println("Input:", arr)
	sorted := mergeSort(arr)
	fmt.Println("Output:", sorted)
}
