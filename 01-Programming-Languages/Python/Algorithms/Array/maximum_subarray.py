"""
Problem: Maximum Subarray
Given an integer array nums, find the contiguous subarray (containing at least one number)
which has the largest sum and return its sum.
A subarray is a contiguous part of an array.

Approach (Kadane's Algorithm):
- Initialize two variables: max_so_far and max_ending_here
- Iterate through the array:
  - For each element, update max_ending_here to be the maximum of:
    * The current element alone
    * The current element plus max_ending_here (extending the previous subarray)
  - Update max_so_far to be the maximum of max_so_far and max_ending_here
- Return max_so_far
- Time: O(n), Space: O(1)

Example:
Input: nums = [-2,1,-3,4,-1,2,1,-5,4]
Output: 6
Explanation: [4,-1,2,1] has the largest sum = 6.
"""

class Solution:
    def maxSubArray(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        # Handle edge case of empty array
        if not nums:
            return 0

        # Initialize both to the first element
        max_so_far = nums[0]
        max_ending_here = nums[0]

        # Iterate through the array starting from the second element
        for i in range(1, len(nums)):
            # Either start a new subarray at current element,
            # or extend the previous subarray
            max_ending_here = max(nums[i], max_ending_here + nums[i])

            # Update the maximum found so far
            max_so_far = max(max_so_far, max_ending_here)

        return max_so_far

# Example usage
if __name__ == "__main__":
    solution = Solution()

    # Test cases
    test_cases = [
        ([-2, 1, -3, 4, -1, 2, 1, -5, 4], 6),
        ([1], 1),
        ([5, 4, -1, 7, 8], 23),
        ([-1, -2, -3, -4], -1),
        ([0, -3, 1, 1], 2)
    ]

    print("Testing Maximum Subarray (Kadane's Algorithm):")
    print("-" * 50)
    for nums, expected in test_cases:
        result = solution.maxSubArray(nums)
        status = "✓" if result == expected else "✗"
        print(f"{status} Input: {nums}")
        print(f"  Expected: {expected}, Got: {result}")
        print()