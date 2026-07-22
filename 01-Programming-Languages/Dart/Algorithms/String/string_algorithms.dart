/// String Algorithms in Dart
///
/// Demonstrates common string algorithms using Dart's String class.
/// Each algorithm includes time and space complexity analysis.

// ============================================================
// 1. KMP (Knuth-Morris-Pratt) Pattern Matching
// ============================================================

/// Computes the KMP failure function (partial match table).
/// Time: O(m) where m is pattern length
/// Space: O(m)
List<int> computeLPS(String pattern) {
  var lps = List.filled(pattern.length, 0);
  var length = 0;
  var i = 1;

  while (i < pattern.length) {
    if (pattern[i] == pattern[length]) {
      length++;
      lps[i] = length;
      i++;
    } else {
      if (length != 0) {
        length = lps[length - 1];
      } else {
        lps[i] = 0;
        i++;
      }
    }
  }
  return lps;
}

/// KMP pattern matching algorithm.
/// Time: O(n + m) where n is text length, m is pattern length
/// Space: O(m) for the LPS array
List<int> kmpSearch(String text, String pattern) {
  if (pattern.isEmpty) return [0];

  var lps = computeLPS(pattern);
  var result = <int>[];
  var i = 0;
  var j = 0;

  while (i < text.length) {
    if (text[i] == pattern[j]) {
      i++;
      j++;
    }

    if (j == pattern.length) {
      result.add(i - j);
      j = lps[j - 1];
    } else if (i < text.length && text[i] != pattern[j]) {
      if (j != 0) {
        j = lps[j - 1];
      } else {
        i++;
      }
    }
  }
  return result;
}

// ============================================================
// 2. Rabin-Karp Algorithm
// ============================================================

/// Rabin-Karp pattern matching using rolling hash.
/// Time: O(n + m) average, O(n * m) worst case
/// Space: O(1)
List<int> rabinKarp(String text, String pattern) {
  var result = <int>[];
  if (pattern.length > text.length) return result;

  var base = 256;
  var modulus = 1000000007;
  var m = pattern.length;

  // Compute base^(m-1) % modulus
  var h = 1;
  for (var i = 0; i < m - 1; i++) {
    h = (h * base) % modulus;
  }

  // Compute hash of pattern and first window
  var patternHash = 0;
  var textHash = 0;
  for (var i = 0; i < m; i++) {
    patternHash = (base * patternHash + pattern.codeUnitAt(i)) % modulus;
    textHash = (base * textHash + text.codeUnitAt(i)) % modulus;
  }

  // Slide pattern over text
  for (var i = 0; i <= text.length - m; i++) {
    if (patternHash == textHash) {
      var match = true;
      for (var j = 0; j < m; j++) {
        if (text[i + j] != pattern[j]) {
          match = false;
          break;
        }
      }
      if (match) result.add(i);
    }

    if (i < text.length - m) {
      textHash = (base * (textHash - text.codeUnitAt(i) * h) +
              text.codeUnitAt(i + m)) %
          modulus;
      if (textHash < 0) textHash += modulus;
    }
  }
  return result;
}

// ============================================================
// 3. Levenshtein Distance (Edit Distance)
// ============================================================

/// Computes the minimum edit distance between two strings.
/// Time: O(m * n)
/// Space: O(m * n)
int levenshteinDistance(String s1, String s2) {
  var m = s1.length;
  var n = s2.length;
  var dp = List.generate(m + 1, (i) => List.filled(n + 1, 0));

  for (var i = 0; i <= m; i++) dp[i][0] = i;
  for (var j = 0; j <= n; j++) dp[0][j] = j;

  for (var i = 1; i <= m; i++) {
    for (var j = 1; j <= n; j++) {
      var cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
      dp[i][j] = [
        dp[i - 1][j] + 1,      // deletion
        dp[i][j - 1] + 1,      // insertion
        dp[i - 1][j - 1] + cost // substitution
      ].reduce((a, b) => a < b ? a : b);
    }
  }
  return dp[m][n];
}

// ============================================================
// 4. Longest Common Subsequence
// ============================================================

/// Finds the length of the longest common subsequence.
/// Time: O(m * n)
/// Space: O(m * n)
int longestCommonSubsequence(String s1, String s2) {
  var m = s1.length;
  var n = s2.length;
  var dp = List.generate(m + 1, (i) => List.filled(n + 1, 0));

  for (var i = 1; i <= m; i++) {
    for (var j = 1; j <= n; j++) {
      if (s1[i - 1] == s2[j - 1]) {
        dp[i][j] = dp[i - 1][j - 1] + 1;
      } else {
        dp[i][j] = dp[i - 1][j] > dp[i][j - 1] ? dp[i - 1][j] : dp[i][j - 1];
      }
    }
  }
  return dp[m][n];
}

// ============================================================
// 5. Longest Palindromic Substring
// ============================================================

/// Finds the longest palindromic substring using expand-around-center.
/// Time: O(n^2)
/// Space: O(1)
String longestPalindromicSubstring(String s) {
  if (s.length < 2) return s;

  var start = 0;
  var maxLen = 1;

  void expandAroundCenter(int left, int right) {
    var l = left;
    var r = right;
    while (l >= 0 && r < s.length && s[l] == s[r]) {
      if (r - l + 1 > maxLen) {
        start = l;
        maxLen = r - l + 1;
      }
      l--;
      r++;
    }
  }

  for (var i = 0; i < s.length; i++) {
    expandAroundCenter(i, i);       // Odd length
    expandAroundCenter(i, i + 1);   // Even length
  }

  return s.substring(start, start + maxLen);
}

// ============================================================
// 6. String Permutations (Backtracking)
// ============================================================

/// Generates all unique permutations of a string.
/// Time: O(n * n!)
/// Space: O(n) for recursion stack
List<String> permutations(String s) {
  var result = <String>[];
  var chars = s.split('');

  void permute(int left) {
    if (left == chars.length - 1) {
      result.add(chars.join());
      return;
    }
    var used = <String>{};
    for (var i = left; i < chars.length; i++) {
      if (!used.contains(chars[i])) {
        used.add(chars[i]);
        // Swap
        var temp = chars[left];
        chars[left] = chars[i];
        chars[i] = temp;

        permute(left + 1);

        // Backtrack
        chars[i] = chars[left];
        chars[left] = temp;
      }
    }
  }

  permute(0);
  return result;
}

// ============================================================
// 7. Anagram Grouping
// ============================================================

/// Groups strings that are anagrams of each other.
/// Time: O(n * k log k) where n = number of strings, k = max string length
/// Space: O(n * k)
List<List<String>> groupAnagrams(List<String> strings) {
  var map = <String, List<String>>{};
  for (var s in strings) {
    var key = (s.split('')..sort()).join();
    map.putIfAbsent(key, () => []).add(s);
  }
  return map.values.toList();
}

// ============================================================
// 8. Boyer-Moore Majority Element
// ============================================================

/// Finds the majority element (appears more than n/2 times).
/// Time: O(n)
/// Space: O(1)
String? majorityElement(String s) {
  if (s.isEmpty) return null;

  var candidate = s[0];
  var count = 1;

  for (var i = 1; i < s.length; i++) {
    if (count == 0) {
      candidate = s[i];
      count = 1;
    } else if (s[i] == candidate) {
      count++;
    } else {
      count--;
    }
  }

  // Verify
  count = s.split('').where((c) => c == candidate).length;
  return count > s.length / 2 ? candidate : null;
}

// ============================================================
// 9. Longest Substring Without Repeating Characters
// ============================================================

/// Sliding window approach.
/// Time: O(n)
/// Space: O(min(n, m)) where m is character set size
int longestUniqueSubstring(String s) {
  var charIndex = <String, int>{};
  var maxLen = 0;
  var start = 0;

  for (var end = 0; end < s.length; end++) {
    if (charIndex.containsKey(s[end])) {
      start = start > (charIndex[s[end]]! + 1) ? start : charIndex[s[end]]! + 1;
    }
    charIndex[s[end]] = end;
    maxLen = maxLen > (end - start + 1) ? maxLen : end - start + 1;
  }
  return maxLen;
}

// ============================================================
// 10. Z-Algorithm
// ============================================================

/// Computes the Z-array where Z[i] is the length of the longest
/// substring starting at i that is also a prefix.
/// Time: O(n)
/// Space: O(n)
List<int> zAlgorithm(String s) {
  var n = s.length;
  var z = List.filled(n, 0);
  var left = 0;
  var right = 0;

  for (var i = 1; i < n; i++) {
    if (i <= right) {
      z[i] = (right - i + 1) < z[i - left] ? (right - i + 1) : z[i - left];
    }
    while (i + z[i] < n && s[z[i]] == s[i + z[i]]) {
      z[i]++;
    }
    if (i + z[i] - 1 > right) {
      left = i;
      right = i + z[i] - 1;
    }
  }
  return z;
}

// ============================================================
// Demo / Main
// ============================================================

void main() {
  print('=== Dart String Algorithms Demo ===\n');

  // KMP
  var text = 'ABABDABACDABABCABAB';
  var pattern = 'ABABCABAB';
  print("KMP Search '$pattern' in '$text':");
  print('  Found at indices: ${kmpSearch(text, pattern)}');

  // Rabin-Karp
  print('\nRabin-Karp Search:');
  print('  Found at indices: ${rabinKarp(text, pattern)}');

  // Levenshtein Distance
  print('\nLevenshtein Distance:');
  print("  'kitten' -> 'sitting': ${levenshteinDistance('kitten', 'sitting')}");
  print("  'saturday' -> 'sunday': ${levenshteinDistance('saturday', 'sunday')}");

  // Longest Common Subsequence
  print('\nLongest Common Subsequence:');
  print("  'ABCDGH' vs 'AEDFHR': ${longestCommonSubsequence('ABCDGH', 'AEDFHR')}");
  print("  'AGGTAB' vs 'GXTXAYB': ${longestCommonSubsequence('AGGTAB', 'GXTXAYB')}");

  // Longest Palindromic Substring
  print('\nLongest Palindromic Substring:');
  print("  'babad' -> '${longestPalindromicSubstring('babad')}'");
  print("  'cbbd' -> '${longestPalindromicSubstring('cbbd')}'");

  // Permutations
  print('\nPermutations of \'ABC\':');
  print('  ${permutations('ABC')}');

  // Group Anagrams
  print('\nGroup Anagrams:');
  var anagramGroups = groupAnagrams(['eat', 'tea', 'tan', 'ate', 'nat', 'bat']);
  for (var group in anagramGroups) {
    print('  $group');
  }

  // Majority Element
  print('\nMajority Element:');
  print("  'aabbb': ${majorityElement('aabbb')}");
  print("  'abc': ${majorityElement('abc')}");

  // Longest Unique Substring
  print('\nLongest Substring Without Repeating Characters:');
  print("  'abcabcbb': ${longestUniqueSubstring('abcabcbb')}");
  print("  'bbbbb': ${longestUniqueSubstring('bbbbb')}");
  print("  'pwwkew': ${longestUniqueSubstring('pwwkew')}");

  // Z-Algorithm
  print('\nZ-Algorithm for \'aabxaabxcaabxaabx\':');
  print('  Z-array: ${zAlgorithm('aabxaabxcaabxaabx')}');
}
