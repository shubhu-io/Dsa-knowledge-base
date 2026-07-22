/*
 * Problem: Check if a string is a palindrome.
 * Approach: Two pointers moving inward from both ends.
 * Time Complexity: O(n)
 * Space Complexity: O(1)
 * Example: Input: "racecar" -> Output: true
 */

fun isPalindrome(s: String): Boolean {
    var left = 0; var right = s.length - 1
    while (left < right) {
        if (s[left] != s[right]) return false
        left++; right--
    }
    return true
}

fun main() {
    println(isPalindrome("racecar"))
}
