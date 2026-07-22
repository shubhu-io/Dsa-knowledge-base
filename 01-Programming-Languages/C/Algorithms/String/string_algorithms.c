/**
 * string_algorithms.c
 *
 * Common string algorithms implemented in C.
 * C strings are null-terminated character arrays — no built-in
 * string class. All algorithms work directly with char pointers.
 *
 * Time complexities noted per function.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdbool.h>

/* -----------------------------------------------------------
 * Reverse a string in-place using two pointers.
 * Time:  O(n)
 * Space: O(1)
 * ----------------------------------------------------------- */
void reverse_string(char *str) {
    if (!str) return;
    int left = 0;
    int right = (int)strlen(str) - 1;
    while (left < right) {
        char tmp = str[left];
        str[left] = str[right];
        str[right] = tmp;
        left++;
        right--;
    }
}

/* -----------------------------------------------------------
 * Check whether a string is a palindrome.
 * Ignores case and non-alphanumeric characters.
 * Time:  O(n)
 * Space: O(1)
 * ----------------------------------------------------------- */
bool is_palindrome(const char *str) {
    if (!str) return false;
    int left = 0;
    int right = (int)strlen(str) - 1;
    while (left < right) {
        while (left < right && !isalnum((unsigned char)str[left])) left++;
        while (left < right && !isalnum((unsigned char)str[right])) right--;
        if (tolower((unsigned char)str[left]) != tolower((unsigned char)str[right]))
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
int count_vowels(const char *str) {
    if (!str) return 0;
    int count = 0;
    for (int i = 0; str[i] != '\0'; i++) {
        char c = tolower((unsigned char)str[i]);
        if (c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u')
            count++;
    }
    return count;
}

/* -----------------------------------------------------------
 * Find the longest common substring between two strings.
 * Returns a pointer to static buffer (next call overwrites).
 * Time:  O(m * n)
 * Space: O(m * n) for DP table
 * ----------------------------------------------------------- */
static char lcs_result[1024];

const char *longest_common_substring(const char *s1, const char *s2) {
    if (!s1 || !s2 || !*s1 || !*s2) {
        lcs_result[0] = '\0';
        return lcs_result;
    }

    int m = (int)strlen(s1);
    int n = (int)strlen(s2);

    /* dp[i][j] = length of longest common substring ending at s1[i-1], s2[j-1] */
    int *dp = (int *)calloc((m + 1) * (n + 1), sizeof(int));
    if (!dp) { lcs_result[0] = '\0'; return lcs_result; }

    int max_len = 0;
    int end_idx = 0;

    for (int i = 1; i <= m; i++) {
        for (int j = 1; j <= n; j++) {
            if (s1[i - 1] == s2[j - 1]) {
                dp[i * (n + 1) + j] = dp[(i - 1) * (n + 1) + (j - 1)] + 1;
                if (dp[i * (n + 1) + j] > max_len) {
                    max_len = dp[i * (n + 1) + j];
                    end_idx = i;
                }
            }
        }
    }

    int copy_len = max_len < 1023 ? max_len : 1023;
    memcpy(lcs_result, s1 + end_idx - max_len, copy_len);
    lcs_result[copy_len] = '\0';
    free(dp);
    return lcs_result;
}

/* -----------------------------------------------------------
 * Run-length encoding string compression.
 * "aaabbbcc" -> "a3b3c2", "abc" -> "abc" (no change).
 * Caller must free the returned string.
 * Time:  O(n)
 * Space: O(n)
 * ----------------------------------------------------------- */
char *compress_string(const char *str) {
    if (!str || !*str) {
        char *empty = (char *)malloc(1);
        empty[0] = '\0';
        return empty;
    }

    int len = (int)strlen(str);
    char *compressed = (char *)malloc(2 * len + 1);
    if (!compressed) return NULL;

    int idx = 0;
    int i = 0;

    while (i < len) {
        char current = str[i];
        int count = 0;
        while (i < len && str[i] == current) {
            count++;
            i++;
        }
        compressed[idx++] = current;
        if (count > 1) {
            idx += sprintf(compressed + idx, "%d", count);
        }
    }
    compressed[idx] = '\0';
    return compressed;
}

/* -----------------------------------------------------------
 * Demo / driver
 * ----------------------------------------------------------- */
int main(void) {
    printf("=== Reverse String ===\n");
    char s1[] = "hello";
    printf("Before: \"%s\"\n", s1);
    reverse_string(s1);
    printf("After:  \"%s\"\n\n", s1);

    printf("=== Palindrome Check ===\n");
    printf("\"racecar\" -> %s\n", is_palindrome("racecar") ? "true" : "false");
    printf("\"hello\"   -> %s\n", is_palindrome("hello")   ? "true" : "false");
    printf("\"A man, a plan, a canal: Panama\" -> %s\n\n",
           is_palindrome("A man, a plan, a canal: Panama") ? "true" : "false");

    printf("=== Count Vowels ===\n");
    printf("\"programming\" -> %d\n", count_vowels("programming"));
    printf("\"AEIOU\"       -> %d\n\n", count_vowels("AEIOU"));

    printf("=== Longest Common Substring ===\n");
    printf("Between \"abcdef\" and \"zbcdf\"  -> \"%s\"\n",
           longest_common_substring("abcdef", "zbcdf"));
    printf("Between \"GeeksforGeeks\" and \"GeeksQuiz\" -> \"%s\"\n\n",
           longest_common_substring("GeeksforGeeks", "GeeksQuiz"));

    printf("=== String Compression ===\n");
    char *c1 = compress_string("aaabbbcc");
    printf("\"aaabbbcc\"  -> \"%s\"\n", c1);
    free(c1);
    char *c2 = compress_string("abc");
    printf("\"abc\"       -> \"%s\"\n", c2);
    free(c2);
    char *c3 = compress_string("aabbbaa");
    printf("\"aabbbaa\"   -> \"%s\"\n", c3);
    free(c3);

    return 0;
}
