/**
 * Problem: Valid Parentheses
 * Given a string s containing just the characters '(', ')', '{', '}', '[' and ']',
 * determine if the input string is valid.
 * An input string is valid if:
 * 1. Open brackets must be closed by the same type of brackets.
 * 2. Open brackets must be closed in the correct order.
 * 3. Every close bracket has a corresponding open bracket of the same type.
 *
 * Approach:
 * - Use a stack to keep track of opening brackets
 * - Iterate through the string:
 *   - If it's an opening bracket, push it onto the stack
 *   - If it's a closing bracket:
 *     - If stack is empty, return false (no matching opening bracket)
 *     - Pop from stack and check if it matches the closing bracket
 * - After iteration, return true if stack is empty (all brackets matched)
 * - Time: O(n), Space: O(n)
 *
 * Example:
 * Input: s = "()[]{}"
 * Output: true
 *
 * Input: s = "(]"
 * Output: false
 */

#include <iostream>
#include <stack>
#include <string>
#include <unordered_map>

class Solution {
public:
    /**
     * Determines if a string of parentheses is valid.
     * @param s Input string containing only parentheses characters
     * @return true if the string is valid, false otherwise
     */
    bool isValid(std::string s) {
        // Stack to keep track of opening brackets
        std::stack<char> stack;

        // Map of closing brackets to their corresponding opening brackets
        std::unordered_map<char, char> bracketMap = {
            {')', '('},
            {'}', '{'},
            {']', '['}
        };

        // Iterate through each character in the string
        for (char c : s) {
            // If it's an opening bracket, push to stack
            if (c == '(' || c == '{' || c == '[') {
                stack.push(c);
            }
            // If it's a closing bracket
            else if (c == ')' || c == '}' || c == ']') {
                // If stack is empty, there's no matching opening bracket
                if (stack.empty()) {
                    return false;
                }
                // Pop the top element and check if it matches
                char top = stack.top();
                stack.pop();
                if (bracketMap[c] != top) {
                    return false;
                }
            }
            // Ignore any other characters (though problem states only brackets)
        }

        // If stack is empty, all brackets were matched correctly
        return stack.empty();
    }
};

// Example usage
int main() {
    Solution solution;

    // Test cases
    struct TestCase {
        std::string input;
        bool expected;
    };

    TestCase testCases[] = {
        {"()[]{}", true},
        {"([{}])", true},
        {"(]", false},
        {"([)]", false},
        {"{[]}", true},
        {"", true},           // Empty string is valid
        {"(((", false},
        {")))", false},
        {"()", true},
        {"()[]{}", true}
    };

    std::cout << "Testing Valid Parentheses:" << std::endl;
    std::cout << std::string(50, '-') << std::endl;

    for (const auto& test : testCases) {
        bool result = solution.isValid(test.input);
        std::string status = (result == test.expected) ? "✓" : "✗";
        std::cout << status << " Input: \"" << test.input << "\" "
                  << "Expected: " << (test.expected ? "true" : "false") << " "
                  << "Got: " << (result ? "true" : "false") << std::endl;
    }

    return 0;
}