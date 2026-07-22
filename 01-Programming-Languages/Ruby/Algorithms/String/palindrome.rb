=begin
Problem: Valid Palindrome
Description: Check if a string reads the same forwards and backwards.

Approach:
- Use two pointers, one from start and one from end
- Compare characters while moving inward

Time Complexity: O(n)
Space Complexity: O(1)

Example:
Input:  "racecar"
Output: true

Input:  "hello"
Output: false
=end

def palindrome?(s)
  left = 0
  right = s.length - 1
  while left < right
    return false if s[left] != s[right]
    left += 1
    right -= 1
  end
  true
end

%w[racecar hello madam ruby].each do |s|
  puts "\"#{s}\" -> #{palindrome?(s)}"
end
