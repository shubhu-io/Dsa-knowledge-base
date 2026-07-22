/*
Problem: Two Sum
Description: Find two numbers in an array that add up to a target sum.
           Return their indices.

Approach:
- Use a hash map to store complements
- For each element, check if complement (target - element) exists in map

Time Complexity: O(n)
Space Complexity: O(n)

Example:
Input: nums = [2, 7, 11, 15], target = 9
Output: [0, 1]
*/

func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
    var map = [Int: Int]()
    for (i, num) in nums.enumerated() {
        if let index = map[target - num] {
            return [index, i]
        }
        map[num] = i
    }
    return []
}

let result = twoSum([2, 7, 11, 15], 9)
print("Two Sum indices: \(result)")
