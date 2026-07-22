/*
Problem: Palindrome Check
Description: Check if a given string is a palindrome (reads the same
           forwards and backwards). Ignore non-alphanumeric characters
           and case.

Approach:
- Use two pointers (left, right) moving inward
- Skip non-alphanumeric characters
- Compare characters case-insensitively

Time Complexity: O(n)
Space Complexity: O(1)

Example:
Input: "A man, a plan, a canal: Panama"
Output: true
*/

func isPalindrome(_ s: String) -> Bool {
    let chars = Array(s.lowercased().filter { $0.isLetter || $0.isNumber })
    var left = 0, right = chars.count - 1
    while left < right {
        if chars[left] != chars[right] { return false }
        left += 1
        right -= 1
    }
    return true
}

print("Palindrome 'A man, a plan, a canal: Panama': \(isPalindrome("A man, a plan, a canal: Panama"))")
print("Palindrome 'race a car': \(isPalindrome("race a car"))")
