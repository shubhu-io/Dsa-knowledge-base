/**
 * Problem: Binary Search
 * Given an array of integers nums which is sorted in ascending order,
 * and an integer target, write a function to search target in nums.
 * If target exists, then return its index. Otherwise, return -1.
 * You must write an algorithm with O(log n) runtime complexity.
 *
 * Approach:
 * - Use two pointers: left and right
 * - While left <= right:
 *   - Calculate mid = left + Math.floor((right - left) / 2)
 *   - If nums[mid] === target, return mid
 *   - If nums[mid] < target, search right half (left = mid + 1)
 *   - If nums[mid] > target, search left half (right = mid - 1)
 * - If not found, return -1
 * - Time: O(log n), Space: O(1)
 *
 * Example:
 * nums = [-1,0,3,5,9,12], target = 9 -> 4
 */

/**
 * Performs binary search on a sorted array.
 * @param {number[]} nums - Sorted array of integers
 * @param {number} target - Integer to search for
 * @return {number} - Index of target if found, otherwise -1
 */
function search(nums, target) {
    let left = 0;
    let right = nums.length - 1;

    while (left <= right) {
        // Prevents potential overflow (though less relevant in JS)
        const mid = Math.floor(left + (right - left) / 2);

        if (nums[mid] === target) {
            return mid;
        } else if (nums[mid] < target) {
            left = mid + 1;
        } else {
            right = mid - 1;
        }
    }

    return -1;  // Target not found
}

// Example usage
const nums = [-1, 0, 3, 5, 9, 12];
const target = 9;
const result = search(nums, target);
console.log(`Index of ${target}: ${result}`);

// Test case 2: target not present
const target2 = 2;
const result2 = search(nums, target2);
console.log(`Index of ${target2}: ${result2}`);