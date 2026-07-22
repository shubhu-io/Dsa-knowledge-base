=begin
Problem: Valid Parentheses
Description: Determine if a string of brackets is valid.

Approach:
- Use a stack to track opening brackets
- For each closing bracket, check it matches the top of the stack

Time Complexity: O(n)
Space Complexity: O(n)

Example:
Input:  "()[]{}"
Output: true
=end

def valid_parentheses?(s)
  stack = []
  pairs = { ')' => '(', ']' => '[', '}' => '{' }
  s.each_char do |ch|
    if pairs.key?(ch)
      return false if stack.pop != pairs[ch]
    else
      stack.push(ch)
    end
  end
  stack.empty?
end

%w[()[]{} (] ([)] {[]}.].each do |s|
  puts "\"#{s}\" -> #{valid_parentheses?(s)}"
end
