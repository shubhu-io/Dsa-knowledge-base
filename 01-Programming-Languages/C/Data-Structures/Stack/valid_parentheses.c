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
 *   * If it's an opening bracket (', {, [), push it onto the stack
 *   * If it's a closing bracket (', }, ]):
 *     - If the stack is empty, return false (no matching opening bracket)
 *     - Pop from the stack and check if it matches the closing bracket
 * - After iteration, return true if the stack is empty (all brackets matched), false otherwise
 *
 * Time Complexity: O(n) - each character is visited exactly once
 * Space Complexity: O(n) - in the worst case, all characters are opening brackets
 *
 * Example:
 * Input: s = "()[]{}"
 * Output: true
 *
 * Input: s = "(]"
 * Output: false
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

/**
 * Determines if a string of parentheses is valid.
 *
 * @param s Input string containing only parentheses characters
 * @return true if the string is valid, false otherwise
 */
bool isValid(char* s) {
    // Handle empty string
    if (s == NULL || *s == '\0') {
        return true;
    }

    // Create a stack to store opening brackets
    // Maximum size is the length of the string
    int* stack = (int*)malloc(strlen(s) * sizeof(int));
    if (stack == NULL) {
        return false; // Memory allocation failed
    }
    int top = -1; // Stack is empty

    // Iterate through each character in the string
    for (int i = 0; s[i] != '\0'; i++) {
        char ch = s[i];

        // If it's an opening bracket, push onto stack
        if (ch == '(' || ch == '{' || ch == '[') {
            stack[++top] = ch;
        }
        // If it's a closing bracket
        else if (ch == ')' || ch == '}' || ch == ']') {
            // If stack is empty, there's no matching opening bracket
            if (top == -1) {
                free(stack);
                return false;
            }

            // Pop the top element and check if it matches
            char topChar = stack[top--];
            bool isMatch = false;

            if (ch == ')' && topChar == '(') isMatch = true;
            else if (ch == '}' && topChar == '{') isMatch = true;
            else if (ch == ']' && topChar == '[') isMatch = true;

            if (!isMatch) {
                free(stack);
                return false;
            }
        }
        // Ignore any other characters (though problem states only brackets)
    }

    // If stack is empty, all brackets were matched correctly
    bool result = (top == -1);
    free(stack);
    return result;
}

// Helper function to print test results
void printTestResult(const char* input, bool expected, bool result) {
    printf("Input: \"%s\"\n", input);
    printf("Expected: %s\n", expected ? "true" : "false");
    printf("Got:      %s\n", result ? "true" : "false");
    printf("%s\n\n", (result == expected) ? "✓ PASS" : "✗ FAIL");
}

// Example usage
int main() {
    // Test cases
    struct {
        char* input;
        bool expected;
    } testCases[] = {
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

    int numTestCases = sizeof(testCases) / sizeof(testCases[0]);

    printf("Testing Valid Parentheses:\n");
    printf("=========================\n\n");

    for (int i = 0; i < numTestCases; i++) {
        bool result = isValid(testCases[i].input);
        printf("Test %d:\n", i + 1);
        printTestResult(testCases[i].input, testCases[i].expected, result);
    }

    return 0;
}