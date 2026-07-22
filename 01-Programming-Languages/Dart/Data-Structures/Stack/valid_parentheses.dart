/*
Problem: Valid Parentheses
Description: Check if a string containing '(', ')', '{', '}', '[', ']'
           has valid bracket matching and ordering.

Approach:
- Use a stack (List) to track opening brackets
- When encountering a closing bracket, check if it matches the top

Time Complexity: O(n)
Space Complexity: O(n)

Example:
Input: "({[]})"
Output: true
Input: "([)]"
Output: false
*/

bool isValid(String s) {
  List<String> stack = [];
  Map<String, String> pairs = {')': '(', '}': '{', ']': '['};
  for (int i = 0; i < s.length; i++) {
    String ch = s[i];
    if (ch == '(' || ch == '{' || ch == '[') {
      stack.add(ch);
    } else {
      if (stack.isEmpty || stack.removeLast() != pairs[ch]) return false;
    }
  }
  return stack.isEmpty;
}

void main() {
  print("Valid '({[]})': ${isValid("({[]})")}");
  print("Valid '([)]': ${isValid("([)]")}");
}
