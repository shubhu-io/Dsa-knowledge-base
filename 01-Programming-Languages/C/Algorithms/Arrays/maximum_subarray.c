/**
 * Problem: Maximum Subarray
 * Given an integer array nums, find the contiguous subarray
 * (containing at least one number) which has the largest sum
 * and return its sum.
 *
 * Approach (Kadane's Algorithm):
 * - Initialize two variables: max_so_far and max_ending_here
 * - Iterate through the array:
 *   * For each element, update max_ending_here to be the maximum of:
 *     * The current element alone (starting new subarray)
 *     * The current element plus max_ending_here (extending previous subarray)
 *   * Update max_so_far to be the maximum of max_so_far and max_ending_here
 * - Return max_so_far
 * Time Complexity: O(n)
 * Space Complexity: O(1)
 *
 * Example:
 * Input: nums = [-2,1,-3,4,-1,2,1,-5,4]
 * Output: 6
 * Explanation: [4,-1,2,1] has the largest sum = 6.
 */

#include <stdio.h>
#include <limits.h>

/**
 * Finds the maximum sum of a contiguous subarray.
 *
 * @param nums Array of integers
 * @param numsSize Number of elements in the array
 * @return Maximum sum of a contiguous subarray
 */
int maxSubArray(int* nums, int numsSize) {
    // Handle edge case of empty array
    if (numsSize == 0) {
        return 0;
    }

    // Initialize both to the first element
    int max_so_far = nums[0];
    int max_ending_here = nums[0];

    // Iterate through the array starting from the second element
    for (int i = 1; i < numsSize; i++) {
        // Either start a new subarray at current element,
        // or extend the previous subarray
        int sum_with_previous = max_ending_here + nums[i];
        max_ending_here = (nums[i] > sum_with_previous) ? nums[i] : sum_with_previous;

        // Update the maximum found so far
        if (max_ending_here > max_so_far) {
            max_so_far = max_ending_here;
        }
    }

    return max_so_far;
}

// Helper function to print an array
void printArray(int* arr, int size) {
    printf("[");
    for (int i = 0; i < size; i++) {
        printf("%d", arr[i]);
        if (i < size - 1) {
            printf(",");
        }
    }
    printf("]");
}

// Example usage
int main() {
    // Example input: [-2,1,-3,4,-1,2,1,-5,4]
    int nums[] = {-2, 1, -3, 4, -1, 2, 1, -5, 4};
    int numsSize = sizeof(nums) / sizeof(nums[0]);

    printf("Input array: ");
    printArray(nums, numsSize);
    printf("\n");

    int result = maxSubArray(nums, numsSize);
    printf("Maximum subarray sum: %d\n", result);

    // Additional test cases
    int test1[] = {1};
    int test1Size = sizeof(test1) / sizeof(test1[0]);
    printf("Test 1 (single element): %d\n", maxSubArray(test1, test1Size));

    int test2[] = {5, 4, -1, 7, 8};
    int test2Size = sizeof(test2) / sizeof(test2[0]);
    printf("Test 2 (mixed positives/negatives): %d\n", maxSubArray(test2, test2Size));

    int test3[] = {-1, -2, -3, -4};
    int test3Size = sizeof(test3) / sizeof(test3[0]);
    printf("Test 3 (all negatives): %d\n", maxSubArray(test3, test3Size));

    int test4[] = {0, -3, 1, 1};
    int test4Size = sizeof(test4) / sizeof(test4[0]);
    printf("Test 4 (with zeros): %d\n", maxSubArray(test4, test4Size));

    return 0;
}