/*
Problem: Palindrome Check
Check if a given string is a palindrome (reads the same forwards and backwards).

Approach:
- Use two pointers: left and right
- Compare characters at both ends moving inward
- Ignore non-alphanumeric characters and case

Time Complexity: O(n)
Space Complexity: O(1)

Example:
Input: s = "A man, a plan, a canal: Panama"
Output: true
*/

fn is_palindrome(s: &str) -> bool {
    let chars: Vec<char> = s.chars().filter(|c| c.is_alphanumeric()).collect();
    let mut left = 0;
    let mut right = chars.len() as i32 - 1;
    while left < right {
        if chars[left as usize].to_ascii_lowercase() != chars[right as usize].to_ascii_lowercase() {
            return false;
        }
        left += 1;
        right -= 1;
    }
    true
}

fn main() {
    let s = "A man, a plan, a canal: Panama";
    println!("Input: s = \"{}\"\nOutput: {}", s, is_palindrome(s));
}
