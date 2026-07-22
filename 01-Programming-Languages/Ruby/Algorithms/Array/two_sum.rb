=begin
Problem: Two Sum
Description: Find two indices in an array whose values sum to a target.

Approach:
- Use a hash map to store complement values and their indices

Time Complexity: O(n)
Space Complexity: O(n)

Example:
Input:  nums = [2, 7, 11, 15], target = 9
Output: [0, 1]
=end

def two_sum(nums, target)
  map = {}
  nums.each_with_index do |num, i|
    complement = target - num
    return [map[complement], i] if map.key?(complement)
    map[num] = i
  end
  []
end

nums = [2, 7, 11, 15]
target = 9
result = two_sum(nums, target)
puts "Indices: #{result.inspect}"
