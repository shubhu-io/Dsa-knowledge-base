/*
Problem: Palindrome Check
Description: Check if a given string is a palindrome (reads the same forwards and backwards).
Ignore case and non-alphanumeric characters.

Approach:
- Use two pointers from start and end, skip non-alphanumeric chars

Time Complexity: O(n)
Space Complexity: O(1)

Example:
Input: "A man, a plan, a canal: Panama"
Output: true
*/

function isPalindrome(s) {
  let left = 0, right = s.length - 1;
  while (left < right) {
    while (left < right && !isAlphanumeric(s[left])) left++;
    while (left < right && !isAlphanumeric(s[right])) right--;
    if (s[left].toLowerCase() !== s[right].toLowerCase()) return false;
    left++;
    right--;
  }
  return true;
}

function isAlphanumeric(ch) {
  return /[a-zA-Z0-9]/.test(ch);
}

console.log('isPalindrome("A man, a plan, a canal: Panama"):', isPalindrome('A man, a plan, a canal: Panama'));
console.log('isPalindrome("race a car"):', isPalindrome('race a car'));
console.log('isPalindrome("hello"):', isPalindrome('hello'));
