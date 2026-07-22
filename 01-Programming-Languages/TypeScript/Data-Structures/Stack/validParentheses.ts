/*
Problem: Valid Parentheses
Description: Check if a string of brackets has valid matching and ordering.

Approach:
- Use a stack; push opening brackets, pop and match for closing

Time Complexity: O(n)
Space Complexity: O(n)

Example:
Input: "()[]{}"
Output: true
Input: "(]"
Output: false
*/

function isValid(s: string): boolean {
  const stack: string[] = [];
  const map: { [key: string]: string } = { ')': '(', ']': '[', '}': '{' };
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
