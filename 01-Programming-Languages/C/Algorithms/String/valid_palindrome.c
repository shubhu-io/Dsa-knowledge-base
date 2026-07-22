/**
 * Problem: Valid Palindrome
 * Given a string s, determine if it is a palindrome, considering only alphanumeric characters and ignoring cases.
 *
 * Approach:
 * - Use two pointers: one starting from the beginning, one from the end
 * - Move both pointers toward the center, skipping non-alphanumeric characters
 * - Compare the characters at both pointers (case-insensitive)
 * - If any pair doesn't match, return false
 * - If all pairs match, return true
 *
 * Time Complexity: O(n) - each character is visited at most once
 * Space Complexity: O(1) - only uses two pointers and a few variables
 *
 * Example:
 * Input: s = "A man, a plan, a canal: Panama"
 * Output: true
 * Explanation: "amanaplanacanalpanama" is a palindrome.
 *
 * Input: s = "race a car"
 * Output: false
 * Explanation: "raceacar" is not a palindrome.
 */

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <stdbool.h>

/**
 * Determines if a string is a palindrome, considering only alphanumeric characters and ignoring cases.
 *
 * @param s Input string
 * @return true if s is a palindrome, false otherwise
 */
bool isPalindrome(char* s) {
    // Handle empty string
    if (s == NULL || *s == '\0') {
        return true;
    }

    // Initialize two pointers
    char* left = s;
    char* right = s + strlen(s) - 1;

    // Move pointers toward each other until they meet
    while (left < right) {
        // Skip non-alphanumeric characters from the left
        while (left < right && !isalnum((unsigned char)*left)) {
            left++;
        }

        // Skip non-alphanumeric characters from the right
        while (left < right && !isalnum((unsigned char)*right)) {
            right--;
        }

        // If pointers have crossed, we're done
        if (left >= right) {
            break;
        }

        // Compare characters (case-insensitive)
        if (tolower((unsigned char)*left) != tolower((unsigned char)*right)) {
            return false;
        }

        // Move pointers inward
        left++;
        right--;
    }

    return true;
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
    // Example 1
    char s1[] = "A man, a plan, a canal: Panama";
    bool result1 = isPalindrome(s1);
    printTestResult(s1, true, result1);

    // Example 2
    char s2[] = "race a car";
    bool result2 = isPalindrome(s2);
    printTestResult(s2, false, result2);

    // Additional test cases
    char s3[] = "";
    bool result3 = isPalindrome(s3);
    printTestResult(s3, true, result3);

    char s4[] = "a";
    bool result4 = isPalindrome(s4);
    printTestResult(s4, true, result4);

    char s5[] = "ab";
    bool result5 = isPalindrome(s5);
    printTestResult(s5, false, result5);

    char s6[] = "aA";
    bool result6 = isPalindrome(s6);
    printTestResult(s6, true, result6);

    char s7[] = "0P";
    bool result7 = isPalindrome(s7);
    printTestResult(s7, false, result7);

    char s8[] = "A man, a plan, a canal – Panama";  // Note: different dash character
    bool result8 = isPalindrome(s8);
    printTestResult(s8, true, result8);

    return 0;
}