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

bool isPalindrome(String s) {
  String cleaned = s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  int left = 0, right = cleaned.length - 1;
  while (left < right) {
    if (cleaned[left] != cleaned[right]) return false;
    left++;
    right--;
  }
  return true;
}

void main() {
  print("Palindrome 'A man, a plan, a canal: Panama': ${isPalindrome("A man, a plan, a canal: Panama")}");
  print("Palindrome 'race a car': ${isPalindrome("race a car")}");
}
