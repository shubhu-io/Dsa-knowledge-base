/**
 * string_algorithms.cpp
 *
 * Common string algorithms implemented in C++ using std::string
 * and STL algorithms.
 *
 * Time complexities noted per function.
 */

#include <iostream>
#include <string>
#include <algorithm>
#include <cctype>
#include <unordered_map>
#include <sstream>

using namespace std;

/* -----------------------------------------------------------
 * Reverse a string (creates a new string).
 * Time:  O(n)
 * Space: O(n)
 * ----------------------------------------------------------- */
string reverse_string(const string &s) {
    string result(s.rbegin(), s.rend());
    return result;
}

/* -----------------------------------------------------------
 * In-place reverse.
 * Time:  O(n)
 * Space: O(1)
 * ----------------------------------------------------------- */
void reverse_in_place(string &s) {
    reverse(s.begin(), s.end());
}

/* -----------------------------------------------------------
 * Check whether a string is a palindrome.
 * Ignores case and non-alphanumeric characters.
 * Time:  O(n)
 * Space: O(1)
 * ----------------------------------------------------------- */
bool is_palindrome(const string &s) {
    int left = 0, right = (int)s.size() - 1;
    while (left < right) {
        while (left < right && !isalnum(s[left])) left++;
        while (left < right && !isalnum(s[right])) right--;
        if (tolower(s[left]) != tolower(s[right]))
            return false;
        left++;
        right--;
    }
    return true;
}

/* -----------------------------------------------------------
 * Count the number of vowels.
 * Time:  O(n)
 * Space: O(1)
 * ----------------------------------------------------------- */
int count_vowels(const string &s) {
    int count = 0;
    for (char c : s)
        if (string("aeiouAEIOU").find(c) != string::npos)
            count++;
    return count;
}

/* -----------------------------------------------------------
 * Longest common substring (dynamic programming).
 * Time:  O(m * n)
 * Space: O(m * n)
 * ----------------------------------------------------------- */
string longest_common_substring(const string &s1, const string &s2) {
    int m = s1.size(), n = s2.size();
    vector<vector<int>> dp(m + 1, vector<int>(n + 1, 0));
    int max_len = 0, end_idx = 0;

    for (int i = 1; i <= m; i++) {
        for (int j = 1; j <= n; j++) {
            if (s1[i - 1] == s2[j - 1]) {
                dp[i][j] = dp[i - 1][j - 1] + 1;
                if (dp[i][j] > max_len) {
                    max_len = dp[i][j];
                    end_idx = i;
                }
            }
        }
    }
    return s1.substr(end_idx - max_len, max_len);
}

/* -----------------------------------------------------------
 * Run-length encoding compression.
 * "aaabbbcc" -> "a3b3c2", "abc" -> "abc" (no change).
 * Time:  O(n)
 * Space: O(n)
 * ----------------------------------------------------------- */
string compress_string(const string &s) {
    if (s.empty()) return "";

    ostringstream oss;
    int i = 0, n = s.size();

    while (i < n) {
        char current = s[i];
        int count = 0;
        while (i < n && s[i] == current) {
            count++;
            i++;
        }
        oss << current;
        if (count > 1)
            oss << count;
    }
    return oss.str();
}

/* -----------------------------------------------------------
 * First non-repeating character.
 * Time:  O(n)
 * Space: O(1) — alphabet size
 * ----------------------------------------------------------- */
int first_non_repeating(const string &s) {
    unordered_map<char, int> freq;
    for (char c : s)
        freq[c]++;
    for (int i = 0; i < (int)s.size(); i++)
        if (freq[s[i]] == 1)
            return i;
    return -1;
}

/* ============================================================
 * Demo
 * ============================================================ */
int main() {
    cout << "=== Reverse String ===" << endl;
    string s1 = "hello";
    cout << "Before: \"" << s1 << "\"" << endl;
    cout << "After:  \"" << reverse_string(s1) << "\"" << endl;
    reverse_in_place(s1);
    cout << "In-place: \"" << s1 << "\"" << endl;

    cout << "\n=== Palindrome Check ===" << endl;
    cout << "\"racecar\" -> " << boolalpha << is_palindrome("racecar") << endl;
    cout << "\"hello\"   -> " << is_palindrome("hello") << endl;
    cout << "\"A man, a plan, a canal: Panama\" -> "
         << is_palindrome("A man, a plan, a canal: Panama") << endl;

    cout << "\n=== Count Vowels ===" << endl;
    cout << "\"programming\" -> " << count_vowels("programming") << endl;
    cout << "\"AEIOU\"       -> " << count_vowels("AEIOU") << endl;

    cout << "\n=== Longest Common Substring ===" << endl;
    cout << "Between \"abcdef\" and \"zbcdf\"  -> \""
         << longest_common_substring("abcdef", "zbcdf") << "\"" << endl;
    cout << "Between \"GeeksforGeeks\" and \"GeeksQuiz\" -> \""
         << longest_common_substring("GeeksforGeeks", "GeeksQuiz") << "\"" << endl;

    cout << "\n=== String Compression ===" << endl;
    cout << "\"aaabbbcc\"  -> \"" << compress_string("aaabbbcc") << "\"" << endl;
    cout << "\"abc\"       -> \"" << compress_string("abc") << "\"" << endl;
    cout << "\"aabbbaa\"   -> \"" << compress_string("aabbbaa") << "\"" << endl;

    cout << "\n=== First Non-Repeating Character ===" << endl;
    string s2 = "leetcode";
    int idx = first_non_repeating(s2);
    cout << "\"leetcode\"  -> index " << idx << " ('" << (idx >= 0 ? s2[idx] : '?') << "')" << endl;

    return 0;
}
