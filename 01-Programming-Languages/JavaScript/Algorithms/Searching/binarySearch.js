/*
Problem: Binary Search
Description: Find the index of a target value in a sorted array using binary search.
Repeatedly divide the search interval in half.

Approach:
- Maintain left and right pointers
- Compare middle element with target and narrow search range

Time Complexity: O(log n)
Space Complexity: O(1)

Example:
Input: nums = [1, 3, 5, 7, 9, 11], target = 7
Output: 3
*/

function binarySearch(nums, target) {
  let left = 0, right = nums.length - 1;
  while (left <= right) {
    const mid = Math.floor((left + right) / 2);
    if (nums[mid] === target) return mid;
    if (nums[mid] < target) left = mid + 1;
    else right = mid - 1;
  }
  return -1;
}

const nums = [1, 3, 5, 7, 9, 11];
console.log('Input:', nums, 'target =', 7);
console.log('Output:', binarySearch(nums, 7));
