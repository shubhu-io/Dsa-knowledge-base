/*
Problem: Two Sum
Description: Given an array of integers nums and an integer target, return indices
of the two numbers that add up to target. Each input has exactly one solution.

Approach:
- Use a hash map to store complement values as we iterate

Time Complexity: O(n)
Space Complexity: O(n)

Example:
Input: nums = [2, 7, 11, 15], target = 9
Output: [0, 1]
*/

function twoSum(nums, target) {
  const map = new Map();
  for (let i = 0; i < nums.length; i++) {
    const complement = target - nums[i];
    if (map.has(complement)) return [map.get(complement), i];
    map.set(nums[i], i);
  }
  return [];
}

console.log('twoSum([2,7,11,15], 9):', twoSum([2, 7, 11, 15], 9));
console.log('twoSum([3,2,4], 6):', twoSum([3, 2, 4], 6));
