/*
Problem: Two Sum
Find two numbers in an array that add up to a target sum and return their indices.

Approach:
- Use a hash map to store each number's index
- For each element, check if target - element exists in the map
- If found, return both indices

Time Complexity: O(n)
Space Complexity: O(n)

Example:
Input: nums = [2, 7, 11, 15], target = 9
Output: [0, 1]
*/

package main

import "fmt"

func twoSum(nums []int, target int) []int {
	seen := make(map[int]int)
	for i, num := range nums {
		if j, ok := seen[target-num]; ok {
			return []int{j, i}
		}
		seen[num] = i
	}
	return nil
}

func main() {
	nums := []int{2, 7, 11, 15}
	target := 9
	result := twoSum(nums, target)
	fmt.Printf("Input: nums = %v, target = %d\nOutput: %v\n", nums, target, result)
}
