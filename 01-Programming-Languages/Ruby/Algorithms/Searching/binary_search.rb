=begin
Problem: Binary Search
Description: Find the index of a target value in a sorted array using binary search.

Approach:
- Compare target with middle element; if equal return index
- If target < middle, search left half; else search right half

Time Complexity: O(log n)
Space Complexity: O(1)

Example:
Input:  nums = [1, 3, 5, 7, 9, 11], target = 7
Output: 3
=end

def binary_search(nums, target)
  left = 0
  right = nums.length - 1
  while left <= right
    mid = left + (right - left) / 2
    return mid if nums[mid] == target
    if nums[mid] < target
      left = mid + 1
    else
      right = mid - 1
    end
  end
  -1
end

nums = [1, 3, 5, 7, 9, 11]
target = 7
puts "Index of #{target}: #{binary_search(nums, target)}"
target = 4
puts "Index of #{target}: #{binary_search(nums, target)}"
