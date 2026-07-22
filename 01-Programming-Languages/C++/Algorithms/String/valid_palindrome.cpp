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

#include <iostream>
#include <string>
#include <cctype>

/**
 * Determines if a string is a palindrome, considering only alphanumeric characters and ignoring cases.
 *
 * @param s Input string
 * @return true if s is a palindrome, false otherwise
 */
bool isPalindrome(const std::string& s) {
    // Handle empty string
    if (s.empty()) {
        return true;
    }

    // Initialize two pointers
    size_t left = 0;
    size_t right = s.length() - 1;

    // Move pointers toward each other until they meet
    while (left < right) {
        // Skip non-alphanumeric characters from the left
        while (left < right && !std::isalnum(static_cast<unsigned char>(s[left]))) {
            left++;
        }

        // Skip non-alphanumeric characters from the right
        while (left < right && !std::isalnum(static_cast<unsigned char>(s[right]))) {
            right--;
        }

        // If pointers have crossed, we're done
        if (left >= right) {
            break;
        }

        // Compare characters (case-insensitive)
        if (std::tolower(static_cast<unsigned char>(s[left])) !=
            std::tolower(static_cast<unsigned char>(s[right]))) {
            return false;
        }

        // Move pointers inward
        left++;
        right--;
    }

    return true;
}

// Helper function to print test results
void printTestResult(const std::string& input, bool expected, bool result) {
    std::cout << "Input: \"" << input << "\"" << std::endl;
    std::cout << "Expected: " << (expected ? "true" : "false") << std::endl;
    std::cout << "Got:      " << (result ? "true" : "false") << std::endl;
    std::cout << (result == expected ? "✓ PASS" : "✗ FAIL") << std::endl << std::endl;
}

// Example usage
int main() {
    // Example 1
    std::string s1 = "A man, a plan, a canal: Panama";
    bool result1 = isPalindrome(s1);
    printTestResult(s1, true, result1);

    // Example 2
    std::string s2 = "race a car";
    bool result2 = isPalindrome(s2);
    printTestResult(s2, false, result2);

    // Additional test cases
    std::string s3 = "";
    bool result3 = isPalindrome(s3);
    printTestResult(s3, true, result3);

    std::string s4 = "a";
    bool result4 = isPalindrome(s4);
    printTestResult(s4, true, result4);
```

It looks like there was a typo in the test case for s4. Let me fix that and complete the file<tool_call>
<function=Write>
<parameter=content>
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

#include <iostream>
#include <string>
#include <cctype>

/**
 * Determines if a string is a palindrome, considering only alphanumeric characters and ignoring cases.
 *
 * @param s Input string
 * @return true if s is a palindrome, false otherwise
 */
bool isPalindrome(const std::string& s) {
    // Handle empty string
    if (s.empty()) {
        return true;
    }

    // Initialize two pointers
    size_t left = 0;
    size_t right = s.length() - 1;

    // Move pointers toward each other until they meet
    while (left < right) {
        // Skip non-alphanumeric characters from the left
        while (left < right && !std::isalnum(static_cast<unsigned char>(s[left]))) {
            left++;
        }

        // Skip non-alphanumeric characters from the right
        while (left < right && !std::isalnum(static_cast<unsigned char>(s[right]))) {
            right--;
        }

        // If pointers have crossed, we're done
        if (left >= right) {
            break;
        }

        // Compare characters (case-insensitive)
        if (std::tolower(static_cast<unsigned char>(s[left])) !=
            std::tolower(static_cast<unsigned char>(s[right]))) {
            return false;
        }

        // Move pointers inward
        left++;
        right--;
    }

    return true;
}

// Helper function to print test results
void printTestResult(const std::string& input, bool expected, bool result) {
    std::cout << "Input: \"" << input << "\"" << std::endl;
    std::cout << "Expected: " << (expected ? "true" : "false") << std::endl;
    std::cout << "Got:      " << (result ? "true" : "false") << std::endl;
    std::cout << (result == expected ? "✓ PASS" : "✗ FAIL") << std::endl << std::endl;
}

// Example usage
int main() {
    // Example 1
    std::string s1 = "A man, a plan, a canal: Panama";
    bool result1 = isPalindrome(s1);
    printTestResult(s1, true, result1);

    // Example 2
    std::string s2 = "race a car";
    bool result2 = isPalindrome(s2);
    printTestResult(s2, false, result2);

    // Additional test cases
    std::string s3 = "";
    bool result3 = isPalindrome(s3);
    printTestResult(s3, true, result3);

    std::string s4 = "a";
    bool result4 = isPalindrome(s4);
    printTestResult(s4, true, result4);

    std::string s5 = "ab";
    bool result5 = isPalindrome(s5);
    printTestResult(s5, false, result5);

    std::string s6 = "aA";
    bool result6 = isPalindrome(s6);
    printTestResult(s6, true, result6);

    std::string s7 = "0P";
    bool result7 = isPalindrome(s7);
    printTestResult(s7, false, result7);

    std::string s8 = "A man, a plan, a canal – Panama";  // Note: different dash character
    bool result8 = isPalindrome(s8);
    printTestResult(s8, true, result8);

    return 0;
}