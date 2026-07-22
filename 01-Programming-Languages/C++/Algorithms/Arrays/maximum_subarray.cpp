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

#include <iostream>
#include <vector>
#include <algorithm>
#include <climits>

/**
 * Finds the maximum sum of a contiguous subarray.
 *
 * @param nums Vector of integers
 * @return Maximum sum of a contiguous subarray
 */
int maxSubArray(const std::vector<int>& nums) {
    // Handle edge case of empty vector
    if (nums.empty()) {
        return 0;
    }

    // Initialize both to the first element
    int max_so_far = nums[0];
    int max_ending_here = nums[0];

    // Iterate through the vector starting from the second element
    for (size_t i = 1; i < nums.size(); i++) {
        // Either start a new subarray at current element,
        // or extend the previous subarray
        max_ending_here = std::max(nums[i], max_ending_here + nums[i]);

        // Update the maximum found so far
        max_so_far = std::max(max_so_far, max_ending_here);
    }

    return max_so_far;
}

// Example usage
int main() {
    // Example input: [-2,1,-3,4,-1,2,1,-5,4]
    std::vector<int> nums = {-2, 1, -3, 4, -1, 2, 1, -5, 4};

    int result = maxSubArray(nums);
    std::cout << "Maximum subarray sum: " << result << std::endl;

    // Additional test cases
    std::vector<int> test1 = {1};
    std::vector<int> test2 = {5, 4, -1, 7, 8};
    std::vector<int> test3 = {-1, -2, -3, -4};
    std::vector<int> test4 = {0, -3, 1, 1};

    std::cout << "Test 1 (single element): " << maxSubArray(test1) << std::endl;
    std::cout << "Test 2 (mixed positives/negatives): " << maxSubArray(test2) << std::endl;
    std::cout << "Test 3 (all negatives): " << maxSubArray(test3) << std::endl;
    std::cout << "Test 4 (with zeros): " << maxSubArray(test4) << std::endl;

    return 0;
}