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

/**
 * Determines if a string of parentheses is valid.
 * @param {string} s - Input string containing only parentheses characters
 * @return {boolean} - true if the string is valid, false otherwise
 */
function isValid(s) {
    // Stack to keep track of opening brackets
    const stack = [];

    // Map of closing brackets to their corresponding opening brackets
    const bracketMap = {
        ')': '(',
        '}': '{',
        ']': '['
    };

    // Iterate through each character in the string
    for (let i = 0; i < s.length; i++) {
        const char = s[i];

        // If it's an opening bracket, push to stack
        if (char === '(' || char === '{' || char === '[') {
            stack.push(char);
        }
        // If it's a closing bracket
        else if (char === ')' || char === '}' || char === ']') {
            // If stack is empty, there's no matching opening bracket
            if (stack.length === 0) {
                return false;
            }
            // Pop the top element and check if it matches
            const top = stack.pop();
            if (bracketMap[char] !== top) {
                return false;
            }
        }
        // Ignore any other characters (though problem states only brackets)
    }

    // If stack is empty, all brackets were matched correctly
    return stack.length === 0;
}

// Example usage
if (require.main === module) {
    // Test cases
    const testCases = [
        { input: "()[]{}", expected: true },
        { input: "([{}])", expected: true },
        { input: "(]", expected: false },
        { input: "([)]", expected: false },
        { input: "{[]}", expected: true },
        { input: "", expected: true },           // Empty string is valid
        { input: "(((", expected: false },
        { input: ")))", expected: false },
        { input: "()", expected: true },
        { input: "()[]{}", expected: true }
    ];

    console.log("Testing Valid Parentheses:");
    console.log("=".repeat(50));

    for (const testCase of testCases) {
        const result = isValid(testCase.input);
        const status = result === testCase.expected ? "✓" : "✗";
        console.log(`${status} Input: "${testCase.input.padEnd(10)}" ` +
                    `Expected: ${String(testCase.expected).padEnd(5)} ` +
                    `Got: ${String(result).padEnd(5)}`);
    }
}