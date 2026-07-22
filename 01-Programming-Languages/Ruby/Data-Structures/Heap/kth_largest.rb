=begin
Problem: Find Kth Largest Element
Description: Find the kth largest element in an array using a min-heap.

Approach:
- Maintain a min-heap of size k
- After processing all elements, the root is the kth largest

Time Complexity: O(n log k)
Space Complexity: O(k)

Example:
Input:  nums = [3, 2, 1, 5, 6, 4], k = 2
Output: 5
=end

def find_kth_largest(nums, k)
  heap = []
  nums.each do |num|
    heap.push(num)
    heap.sort!
    heap.shift if heap.length > k
  end
  heap.first
end

nums = [3, 2, 1, 5, 6, 4]
k = 2
puts "#{k}th largest: #{find_kth_largest(nums, k)}"

nums = [3, 2, 3, 1, 2, 4, 5, 5, 6]
k = 4
puts "#{k}th largest: #{find_kth_largest(nums, k)}"
