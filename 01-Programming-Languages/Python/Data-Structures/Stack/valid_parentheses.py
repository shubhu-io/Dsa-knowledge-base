"""
Problem: Valid Parentheses
Given a string s containing just the characters '(', ')', '{', '}', '[' and ']',
determine if the input string is valid.
An input string is valid if:
1. Open brackets must be closed by the same type of brackets.
2. Open brackets must be closed in the correct order.
3. Every close bracket has a corresponding open bracket of the same type.

Approach:
- Use a stack to keep track of opening brackets
- Iterate through the string:
  - If it's an opening bracket, push it onto the stack
  - If it's a closing bracket:
    - If stack is empty, return False (no matching opening bracket)
    - Pop from stack and check if it matches the closing bracket
- After iteration, return True if stack is empty (all brackets matched)
- Time: O(n), Space: O(n)

Example:
Input: s = "()[]{}"
Output: true

Input: s = "(]"
Output: false
"""

class Solution:
    def isValid(self, s: str) -> bool:
        """
        Determines if a string of parentheses is valid.

        Args:
            s: String containing only parentheses characters

        Returns:
            True if the string is valid, False otherwise
        """
        # Stack to keep track of opening brackets
        stack = []

        # Mapping of closing brackets to their corresponding opening brackets
        bracket_map = {
            ')': '(',
            '}': '{',
            ']': '['
        }

        # Iterate through each character in the string
        for char in s:
            # If it's an opening bracket, push to stack
            if char in '({[':
                stack.append(char)
            # If it's a closing bracket
            elif char in ')}]':
                # If stack is empty, there's no matching opening bracket
                if not stack:
                    return False
                # Pop the top element and check if it matches
                top_element = stack.pop()
                if bracket_map[char] != top_element:
                    return False
            # Ignore any other characters (though problem states only brackets)

        # If stack is empty, all brackets were matched correctly
        return len(stack) == 0

# Example usage
if __name__ == "__main__":
    solution = Solution()

    # Test cases
    test_cases = [
        ("()[]{}", True),
        ("([{}])", True),
        ("(]", False),
        ("([)]", False),
        ("{[]}", True),
        ("", True),           # Empty string is valid
        ("(((", False),
        (")))", False),
        ("()", True),
        ("()[]{}", True)
    ]

    print("Testing Valid Parentheses:")
    print("=" * 50)
    for s, expected in test_cases:
        result = solution.isValid(s)
        status = "✓" if result == expected else "✗"
        print(f"{status} Input: {s!r:<12} Expected: {str(expected):<5} Got: {str(result):<5}")