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

/**
 * Determines if a string is a palindrome, considering only alphanumeric characters and ignoring cases.
 *
 * @param {string} s - Input string
 * @return {boolean} - true if s is a palindrome, false otherwise
 */
var isPalindrome = function(s) {
    // Handle empty string
    if (s === null || s.length === 0) {
        return true;
    }

    // Initialize two pointers
    let left = 0;
    let right = s.length - 1;

    // Move pointers toward each other until they meet
    while (left < right) {
        // Skip non-alphanumeric characters from the left
        while (left < right && !isAlphanumeric(s.charCodeAt(left))) {
            left++;
        }

        // Skip non-alphanumeric characters from the right
        while (left < right && !isAlphanumeric(s.charCodeAt(right))) {
            right--;
        }

        // If pointers have crossed, we're done
        if (left >= right) {
            break;
        }

        // Compare characters (case-insensitive)
        if (toLowerCase(s.charCodeAt(left)) !== toLowerCase(s.charCodeAt(right))) {
            return false;
        }

        // Move pointers inward
        left++;
        right--;
    }

    return true;
};

/**
 * Helper function to check if a character code represents an alphanumeric character
 * @param {numberic character
 * @param {number} charCode - Character code to check
 * @return {boolean} - true if alphanumeric, false otherwise
 */
function isAlphanumeric(charCode) {
    // Check if it's a letter (A-Z, a-z) or digit (0-9)
    return (charCode >= 48 && charCode <= 57) || // 0-9
           (charCode >= 65 && charCode <= 90) || // A-Z
           (charCode >= 97 && charCode <= 122);  // a-z
}

/**
 * Helper function to convert a character code to lowercase
 * @param {number} charCode - Character code to convert
 * @return {number} - Lowercase character code
 */
function toLowerCase(charCode) {
    // If it's uppercase letter, convert to lowercase
    if (charCode >= 65 && charCode <= 90) {
        return charCode + 32;
    }
    return charCode;
}

// Helper function to print test results
function printTestResult(input, expected, result) {
    console.log(`Input: "${input}"`);
    console.log(`Expected: ${expected ? "true" : "false"}`);
    console.log(`Got:      ${result ? "true" : "false"}`);
    console.log(`${result === expected ? "✓ PASS" : "✗ FAIL"}\n`);
}

// Example usage
if (require.main === module) {
    // Example 1
    const s1 = "A man, a plan, a canal: Panama";
    const result1 = isPalindrome(s1);
    printTestResult(s1, true, result1);

    // Example 2
    const s2 = "race a car";
    const result2 = isPalindrome(s2);
    printTestResult(s2, false, result2);

    // Additional test cases
    const s3 = "";
    const result3 = isPalindrome(s3);
    printTestResult(s3, true, result3);

    const s4 = "a";
    const result4 = isPalindrome(s4);
    printTestResult(s4, true, result4);

    const s5 = "ab";
    const result5 = isPalindrome(s5);
    printTestResult(s5, false, result5);

    const s6 = "aA";
    const result6 = isPalindrome(s6);
    printTestResult(s6, true, result6);

    const s7 = "0P";
    const result7 = isPalindrome(s7);
    printTestResult(s7, false, result7);

    const s8 = "A man, a plan, a canal – Panama";  // Note: different dash character
    const result8 = isPalindrome(s8);
    printTestResult(s8, true, result8);
}