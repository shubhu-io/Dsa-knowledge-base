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

#include <iostream>
#include <vector>
using namespace std;

pair<int, int> two_sum(const vector<int>& nums, int target)
{
    int n = nums.size();
    for (int i = 0; i < n; i++)
        for (int j = i + 1; j < n; j++)
            if (nums[i] + nums[j] == target)
                return {i, j};
    return {-1, -1};
}

int main()
{
    vector<int> nums = {2, 7, 11, 15};
    int target = 9;
    auto [i1, i2] = two_sum(nums, target);
    cout << "Indices: [" << i1 << ", " << i2 << "]" << endl;
    return 0;
}
