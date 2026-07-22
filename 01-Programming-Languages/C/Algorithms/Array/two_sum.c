/*
Problem: Two Sum
Given an array of integers and a target, return indices of two numbers that add up to target.

Approach:
- Brute force check all pairs

Time Complexity: O(n^2)
Space Complexity: O(1)

Example:
Input: nums = [2, 7, 11, 15], target = 9
Output: [0, 1]
*/

#include <stdio.h>

void two_sum(int nums[], int n, int target, int *idx1, int *idx2)
{
    for (int i = 0; i < n; i++)
        for (int j = i + 1; j < n; j++)
            if (nums[i] + nums[j] == target)
            {
                *idx1 = i;
                *idx2 = j;
                return;
            }
    *idx1 = -1;
    *idx2 = -1;
}

int main()
{
    int nums[] = {2, 7, 11, 15};
    int n = sizeof(nums) / sizeof(nums[0]);
    int target = 9;
    int i1, i2;
    two_sum(nums, n, target, &i1, &i2);
    printf("Indices: [%d, %d]\n", i1, i2);
    return 0;
}
