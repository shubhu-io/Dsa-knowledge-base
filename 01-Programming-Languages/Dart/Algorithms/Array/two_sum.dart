/*
Problem: Two Sum
Description: Find two numbers in an array that add up to a target sum.
           Return their indices.

Approach:
- Use a hash map to store complements
- For each element, check if complement (target - element) exists in map

Time Complexity: O(n)
Space Complexity: O(n)

Example:
Input: nums = [2, 7, 11, 15], target = 9
Output: [0, 1]
*/

List<int> twoSum(List<int> nums, int target) {
  Map<int, int> map = {};
  for (int i = 0; i < nums.length; i++) {
    int complement = target - nums[i];
    if (map.containsKey(complement)) {
      return [map[complement]!, i];
    }
    map[nums[i]] = i;
  }
  return [];
}

void main() {
  List<int> result = twoSum([2, 7, 11, 15], 9);
  print('Two Sum indices: $result');
}
