"""
Problem: Valid Palindrome
Given a string s, determine if it is a palindrome, considering only alphanumeric characters and ignoring cases.

Approach:
- Use two pointers: one starting from the beginning, one from the end
- Move both pointers toward the center, skipping non-alphanumeric characters
- Compare the characters at both pointers (case-insensitive)
- If any pair doesn't match, return false
- If all pairs match, return true

Time Complexity: O(n) - each character is visited at most once
Space Complexity: O(1) - only uses two pointers and a few variables

Example:
Input: s = "A man, a plan, a canal: Panama"
Output: true
Explanation: "amanaplanacanalpanama" is a palindrome.

Input: s = "race a car"
Output: false
Explanation: "raceacar" is not a palindrome.
"""

class Solution:
    def isPalindrome(self, s: str) -> bool:
        """
        Determines if a string is a palindrome, considering only alphanumeric characters and ignoring cases.

        Args:
            s: Input string

        Returns:
            True if s is a palindrome, False otherwise
        """
        # Handle empty string
        if not s:
            return True

        # Initialize two pointers
        left = 0
        right = len(s) - 1

        # Move pointers toward each other until they meet
        while left < right:
            # Skip non-alphanumeric characters from the left
            while left < right and not s[left].isalnum():
                left += 1

            # Skip non-alphanumeric characters from the right
            while left < right and not s[right].isalnum():
                right -= 1

            # If pointers have crossed, we're done
            if left >= right:
                break

            # Compare characters (case-insensitive)
            if s[left].lower() != s[right].lower():
                return False

            # Move pointers inward
            left += 1
            right -= 1

        return True

# Helper function to print test results
def print_test_result(input_str: str, expected: bool, result: bool) -> None:
    """Prints the test result in a readable format"""
    print(f"Input: \"{input_str}\"")
    print(f"Expected: {expected}")
    print(f"Got:      {result}")
    print(f"{'✓ PASS' if result == expected else '✗ FAIL'}\n")

# Example usage
if __name__ == "__main__":
    solution = Solution()

    # Example 1
    s1 = "A man, a plan, a canal: Panama"
    result1 = solution.isPalindrome(s1)
    print_test_result(s1, True, result1)

    # Example 2
    s2 = "race a car"
    result2 = solution.isPalindrome(s2)
    print_test_result(s2, False, result2)

    # Additional test cases
    s3 = ""
    result3 = solution.isPalindrome(s3)
    print_test_result(s3, True, result3)

    s4 = "a"
    result4 = solution.isPalindrome(s4)
    print_test_result(s4, True, result4)

    s5 = "ab"
    result5 = solution.isPalindrome(s5)
    print_test_result(s5, False, result5)

    s6 = "aA"
    result6 = solution.isPalindrome(s6)
    print_test_result(s6, True, result6)

    s7 = "0P"
    result7 = solution.isPalindrome(s7)
    print_test_result(s7, False, result7)

    s8 = "A man, a plan, a canal – Panama"  # Note: different dash character
    result8 = solution.isPalindrome(s8)
    print_test_result(s8, True, result8)