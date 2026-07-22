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
 *   - Calculate mid = left + (right - left) / 2
 *   - If nums[mid] == target, return mid
 *   - If nums[mid] < target, search right half (left = mid + 1)
 *   - If nums[mid] > target, search left half (right = mid - 1)
 * - If not found, return -1
 * - Time: O(log n), Space: O(1)
 *
 * Example:
 * nums = [-1,0,3,5,9,12], target = 9 -> 4
 */

#include <stdio.h>

int search(int* nums, int numsSize, int target) {
    int left = 0;
    int right = numsSize - 1;

    while (left <= right) {
        // Prevents potential overflow
        int mid = left + (right - left) / 2;

        if (nums[mid] == target) {
            return mid;
        } else if (nums[mid] < target) {
            left = mid + 1;
        } else {
            right = mid - 1;
        }
    }

    return -1;  // Target not found
}

int main() {
    // Example usage
    int nums[] = {-1, 0, 3, 5, 9, 12};
    int target = 9;
    int numsSize = sizeof(nums) / sizeof(nums[0]);

    int result = search(nums, numsSize, target);
    printf("Index of %d: %d\n", target, result);

    // Test case 2: target not present
    target = 2;
    result = search(nums, numsSize, target);
    printf("Index of %d: %d\n", target, result);

    return 0;
}