/*
Problem: Two Sum
Given an array of integers nums and an integer target,
return indices of the two numbers such that they add up to target.
You may assume that each input would have exactly one solution,
and you may not use the same element twice.

Approach:
- Use a Map to store value -> index.
- Iterate over nums with index i.
    let complement = target - nums[i];
    if map.has(complement) return [map.get(complement), i];
    else map.set(nums[i], i);
- Time: O(n), Space: O(n).

Example:
nums = [2,7,11,15], target = 9 => [0,1]
*/

function twoSum(nums, target) {
    const map = new Map();
    for (let i = 0; i < nums.length; i++) {
        const complement = target - nums[i];
        if (map.has(complement)) {
            return [map.get(complement), i];
        }
        map.set(nums[i], i);
    }
    return []; // Should not happen
}

// Example usage
const nums = [2, 7, 11, 15];
const target = 9;
const result = twoSum(nums, target);
console.log(`Indices: [${result[0]}, ${result[1]}]`);