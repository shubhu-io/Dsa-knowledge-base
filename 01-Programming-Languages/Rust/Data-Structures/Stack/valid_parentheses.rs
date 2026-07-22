/*
Problem: Valid Parentheses
Check if a string containing parentheses is valid (every opening bracket has a matching closing bracket in correct order).

Approach:
- Use a stack to track opening brackets
- For each closing bracket, check if it matches the top of the stack
- Stack should be empty at the end

Time Complexity: O(n)
Space Complexity: O(n)

Example:
Input: s = "()[]{}"
Output: true
*/

fn is_valid(s: &str) -> bool {
    let mut stack: Vec<char> = Vec::new();
    for ch in s.chars() {
        match ch {
            '(' | '{' | '[' => stack.push(ch),
            ')' => if stack.pop() != Some('(') { return false; }
            '}' => if stack.pop() != Some('{') { return false; }
            ']' => if stack.pop() != Some('[') { return false; }
            _ => {}
        }
    }
    stack.is_empty()
}

fn main() {
    let s = "()[]{}";
    println!("Input: s = \"{}\"\nOutput: {}", s, is_valid(s));
}
