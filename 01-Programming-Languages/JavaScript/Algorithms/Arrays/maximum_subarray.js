/**
 * Problem: Maximum Subarray
 * Given an integer array nums, find the contiguous subarray
 * (containing at least one number) which has the largest sum
 * and return its sum.
 *
 * Approach (Kadane's Algorithm):
 * - Initialize two variables: maxSoFar and maxEndingHere
 * - Iterate through the array:
 *   * For each element, update maxEndingHere to be the maximum of:
 *     * The current element alone (starting new subarray)
 *     * The current element plus maxEndingHere (extending previous subarray)
 *   * Update maxSoFar to be the maximum of maxSoFar and maxEndingHere
 * - Return maxSoFar
 * Time Complexity: O(n)
 * Space Complexity: O(1)
 *
 * Example:
 * Input: nums = [-2,1,-3,4,-1,2,1,-5,4]
 * Output: 6
 * Explanation: [4,-1,2,1] has the largest sum = 6.
 */

/**
 * Finds the maximum sum of a contiguous subarray.
 *
 * @param {number[]} nums - Array of integers
 * @return {number} - Maximum sum of a contiguous subarray
 */
function maxSubArray(nums) {
    // Handle edge case of empty array
    if (nums.length === 0) {
        return 0;
    }

    // Initialize both to the first element
    let maxSoFar = nums[0];
    let maxEndingHere = nums[0];

    // Iterate through the array starting from the second element
    for (let i = 1; i < nums.length; i++) {
        // Either start a new subarray at current element,
        // or extend the previous subarray
        maxEndingHere = Math.max(nums[i], maxEndingHere + nums[i]);

        // Update the maximum found so far
        maxSoFar = Math.max(maxSoFar, maxEndingHere);
    }

    return maxSoFar;
}

// Example usage
if (require.main === module) {
    // Example input: [-2,1,-3,4,-1,2,1,-5,4]
    const nums = [-2, 1, -3, 4, -1, 2, 1, -5, 4];

    const result = maxSubArray(nums);
    console.log(`Maximum subarray sum: ${result}`);

    // Additional test cases
    const test1 = [1];
    const test2 = [5, 4, -1, 7, 8];
    const test3 = [-1, -2, -3, -4];
    const test4 = [0, -3, 1, 1];

    console.log(`Test 1 (single element): ${maxSubArray(test1)}`);
    console.log(`Test 2 (mixed positives/negatives): ${maxSubArray(test2)}`);
    console.log(`Test 3 (all negatives): ${maxSubArray(test3)}`);
    console.log(`Test 4 (with zeros): ${maxSubArray(test4)}`);
}