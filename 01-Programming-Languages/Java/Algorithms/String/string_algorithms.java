package stringalgorithms;

/**
 * string_algorithms.java
 *
 * Common string algorithms implemented in Java using String and StringBuilder.
 *
 * Time complexities noted per method.
 */
public class string_algorithms {

    /* -----------------------------------------------------------
     * Reverse a string.
     * Time:  O(n)
     * Space: O(n)
     * ----------------------------------------------------------- */
    public static String reverseString(String s) {
        return new StringBuilder(s).reverse().toString();
    }

    /* -----------------------------------------------------------
     * Check whether a string is a palindrome.
     * Ignores case and non-alphanumeric characters.
     * Time:  O(n)
     * Space: O(1)
     * ----------------------------------------------------------- */
    public static boolean isPalindrome(String s) {
        int left = 0, right = s.length() - 1;
        while (left < right) {
            while (left < right && !Character.isAlphanumeric(s.charAt(left))) left++;
            while (left < right && !Character.isAlphanumeric(s.charAt(right))) right--;
            if (Character.toLowerCase(s.charAt(left)) != Character.toLowerCase(s.charAt(right)))
                return false;
            left++;
            right--;
        }
        return true;
    }

    /* -----------------------------------------------------------
     * Count the number of vowels in a string.
     * Time:  O(n)
     * Space: O(1)
     * ----------------------------------------------------------- */
    public static int countVowels(String s) {
        int count = 0;
        String vowels = "aeiouAEIOU";
        for (int i = 0; i < s.length(); i++) {
            if (vowels.indexOf(s.charAt(i)) >= 0)
                count++;
        }
        return count;
    }

    /* -----------------------------------------------------------
     * Longest common substring (dynamic programming).
     * Time:  O(m * n)
     * Space: O(m * n)
     * ----------------------------------------------------------- */
    public static String longestCommonSubstring(String s1, String s2) {
        int m = s1.length(), n = s2.length();
        int[][] dp = new int[m + 1][n + 1];
        int maxLen = 0, endIdx = 0;

        for (int i = 1; i <= m; i++) {
            for (int j = 1; j <= n; j++) {
                if (s1.charAt(i - 1) == s2.charAt(j - 1)) {
                    dp[i][j] = dp[i - 1][j - 1] + 1;
                    if (dp[i][j] > maxLen) {
                        maxLen = dp[i][j];
                        endIdx = i;
                    }
                }
            }
        }
        return s1.substring(endIdx - maxLen, endIdx);
    }

    /* -----------------------------------------------------------
     * Run-length encoding compression.
     * "aaabbbcc" -> "a3b3c2", "abc" -> "abc"
     * Time:  O(n)
     * Space: O(n)
     * ----------------------------------------------------------- */
    public static String compressString(String s) {
        if (s == null || s.isEmpty()) return "";

        StringBuilder sb = new StringBuilder();
        int i = 0, len = s.length();

        while (i < len) {
            char current = s.charAt(i);
            int count = 0;
            while (i < len && s.charAt(i) == current) {
                count++;
                i++;
            }
            sb.append(current);
            if (count > 1) sb.append(count);
        }
        return sb.toString();
    }

    /* -----------------------------------------------------------
     * First non-repeating character index.
     * Time:  O(n)
     * Space: O(1) — fixed alphabet size
     * ----------------------------------------------------------- */
    public static int firstNonRepeating(String s) {
        int[] freq = new int[256];  /* ASCII frequency array */
        for (int i = 0; i < s.length(); i++)
            freq[s.charAt(i)]++;
        for (int i = 0; i < s.length(); i++)
            if (freq[s.charAt(i)] == 1)
                return i;
        return -1;
    }

    /* ============================================================
     * Demo
     * ============================================================ */
    public static void main(String[] args) {
        System.out.println("=== Reverse String ===");
        System.out.println("\"hello\" -> \"" + reverseString("hello") + "\"");

        System.out.println("\n=== Palindrome Check ===");
        System.out.println("\"racecar\" -> " + isPalindrome("racecar"));
        System.out.println("\"hello\"   -> " + isPalindrome("hello"));
        System.out.println("\"A man, a plan, a canal: Panama\" -> "
                + isPalindrome("A man, a plan, a canal: Panama"));

        System.out.println("\n=== Count Vowels ===");
        System.out.println("\"programming\" -> " + countVowels("programming"));
        System.out.println("\"AEIOU\"       -> " + countVowels("AEIOU"));

        System.out.println("\n=== Longest Common Substring ===");
        System.out.println("Between \"abcdef\" and \"zbcdf\"  -> \""
                + longestCommonSubstring("abcdef", "zbcdf") + "\"");
        System.out.println("Between \"GeeksforGeeks\" and \"GeeksQuiz\" -> \""
                + longestCommonSubstring("GeeksforGeeks", "GeeksQuiz") + "\"");

        System.out.println("\n=== String Compression ===");
        System.out.println("\"aaabbbcc\"  -> \"" + compressString("aaabbbcc") + "\"");
        System.out.println("\"abc\"       -> \"" + compressString("abc") + "\"");
        System.out.println("\"aabbbaa\"   -> \"" + compressString("aabbbaa") + "\"");

        System.out.println("\n=== First Non-Repeating Character ===");
        String s = "leetcode";
        int idx = firstNonRepeating(s);
        char ch = idx >= 0 ? s.charAt(idx) : '?';
        System.out.println("\"leetcode\" -> index " + idx + " ('" + ch + "')");
    }
}
