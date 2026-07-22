/*
Problem: Two Sum
Given an array of integers nums and an integer target,
return indices of the two numbers such that they add up to target.
You may assume that each input would have exactly one solution,
and you may not use the same element twice.

Approach:
- Use a hash map (unordered_map) to store value -> index.
- Iterate through the array; for each element nums[i],
  compute complement = target - nums[i].
  If complement exists in the map, we found the pair.
  Otherwise, insert nums[i] with its index into the map.
- This yields O(n) time and O(n) space.

Example:
nums = [2,7,11,15], target = 9 -> output [0,1]
*/

#include <iostream>
#include <vector>
#include <unordered_map>

std::vector<int> twoSum(const std::vector<int>& nums, int target) {
    std::unordered_map<int, int> value_to_index;
    for (int i = 0; i < nums.size(); ++i) {
        int complement = target - nums[i];
        auto it = value_to_index.find(complement);
        if (it != value_to_index.end()) {
            return {it->second, i};
        }
        value_to_index[nums[i]] = i;
    }
    return {}; // Should not happen per problem guarantee
}

int main() {
    std::vector<int> nums = {2, 7, 11, 15};
    int target = 9;
    std::vector<int> result = twoSum(nums, target);
    std::cout << "Indices: [" << result[0] << ", " << result[1] << "]\n";
    return 0;
}