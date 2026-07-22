/*
 * Problem: Check if a string is a palindrome.
 * Approach: Two pointers moving inward from both ends.
 * Time Complexity: O(n)
 * Space Complexity: O(1)
 * Example: Input: "racecar" -> Output: true
 */

public class Palindrome {
    public static boolean isPalindrome(String s) {
        int left = 0, right = s.length() - 1;
        while (left < right) {
            if (s.charAt(left) != s.charAt(right)) return false;
            left++;
            right--;
        }
        return true;
    }

    public static void main(String[] args) {
        String s = "racecar";
        System.out.println(isPalindrome(s));
    }
}
