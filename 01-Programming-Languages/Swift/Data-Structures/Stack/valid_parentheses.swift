/*
Problem: Valid Parentheses
Description: Check if a string containing '(', ')', '{', '}', '[', ']'
           has valid bracket matching and ordering.

Approach:
- Use a stack (array) to track opening brackets
- When encountering a closing bracket, check if it matches the top

Time Complexity: O(n)
Space Complexity: O(n)

Example:
Input: "({[]})"
Output: true
Input: "([)]"
Output: false
*/

func isValid(_ s: String) -> Bool {
    var stack = [Character]()
    let pairs: [Character: Character] = [")": "(", "}": "{", "]": "["]
    for ch in s {
        if ch == "(" || ch == "{" || ch == "[" {
            stack.append(ch)
        } else {
            guard let last = stack.popLast(), last == pairs[ch] else { return false }
        }
    }
    return stack.isEmpty
}

print("Valid '({[]})': \(isValid("({[]})"))")
print("Valid '([)]': \(isValid("([)]"))")
