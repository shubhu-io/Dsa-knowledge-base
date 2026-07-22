/*
Problem: Valid Parentheses
Description: Check if a string containing '(', ')', '{', '}', '[', ']' has valid
matching brackets and correct ordering.

Approach:
- Use a stack; push opening brackets, pop and match for closing brackets

Time Complexity: O(n)
Space Complexity: O(n)

Example:
Input: "()[]{}"
Output: true
Input: "(]"
Output: false
*/

function isValid(s) {
  const stack = [];
  const map = { ')': '(', ']': '[', '}': '{' };
  for (const ch of s) {
    if (ch in map) {
      if (stack.pop() !== map[ch]) return false;
    } else {
      stack.push(ch);
    }
  }
  return stack.length === 0;
}

console.log('isValid("()[]{}"):', isValid('()[]{}'));
console.log('isValid("(]"):', isValid('(]'));
console.log('isValid("({[]})"):', isValid('({[]})'));
