/*
Problem: Two Sum
Description: Given an array of integers and target, return indices of two numbers
that add up to target.

Approach:
- Use a hash map to store complement values

Time Complexity: O(n)
Space Complexity: O(n)

Example:
Input: nums = [2, 7, 11, 15], target = 9
Output: [0, 1]
*/

function twoSum(nums: number[], target: number): number[] {
  const map = new Map<number, number>();
  for (let i = 0; i < nums.length; i++) {
    const complement = target - nums[i];
    if (map.has(complement)) return [map.get(complement)!, i];
    map.set(nums[i], i);
  }
  return [];
}

console.log('twoSum([2,7,11,15], 9):', twoSum([2, 7, 11, 15], 9));
console.log('twoSum([3,2,4], 6):', twoSum([3, 2, 4], 6));
