package algorithms.string

/**
 * String Algorithms in Kotlin
 * 
 * Demonstrates common string algorithms using Kotlin's stdlib.
 * Each algorithm includes time and space complexity analysis.
 */

// ============================================================
// 1. KMP (Knuth-Morris-Pratt) Pattern Matching
// ============================================================

/**
 * Computes the KMP failure function (partial match table).
 * Time: O(m) where m is pattern length
 * Space: O(m)
 */
fun computeLPS(pattern: String): IntArray {
    val lps = IntArray(pattern.length)
    var length = 0
    var i = 1

    while (i < pattern.length) {
        if (pattern[i] == pattern[length]) {
            length++
            lps[i] = length
            i++
        } else {
            if (length != 0) {
                length = lps[length - 1]
            } else {
                lps[i] = 0
                i++
            }
        }
    }
    return lps
}

/**
 * KMP pattern matching algorithm.
 * Time: O(n + m) where n is text length, m is pattern length
 * Space: O(m) for the LPS array
 */
fun kmpSearch(text: String, pattern: String): List<Int> {
    if (pattern.isEmpty()) return listOf(0)

    val lps = computeLPS(pattern)
    val result = mutableListOf<Int>()
    var i = 0 // index for text
    var j = 0 // index for pattern

    while (i < text.length) {
        if (text[i] == pattern[j]) {
            i++
            j++
        }

        if (j == pattern.length) {
            result.add(i - j)
            j = lps[j - 1]
        } else if (i < text.length && text[i] != pattern[j]) {
            if (j != 0) {
                j = lps[j - 1]
            } else {
                i++
            }
        }
    }
    return result
}

// ============================================================
// 2. Rabin-Karp Algorithm
// ============================================================

/**
 * Rabin-Karp pattern matching using rolling hash.
 * Time: O(n + m) average, O(n * m) worst case
 * Space: O(1)
 */
fun rabinKarp(text: String, pattern: String): List<Int> {
    val result = mutableListOf<Int>()
    if (pattern.length > text.length) return result

    val base = 256
    val modulus = 1_000_000_007L
    val m = pattern.length

    // Compute base^(m-1) % modulus for rolling hash
    var h = 1L
    for (i in 0 until m - 1) {
        h = (h * base) % modulus
    }

    // Compute hash of pattern and first window of text
    var patternHash = 0L
    var textHash = 0L
    for (i in 0 until m) {
        patternHash = (base * patternHash + pattern[i].code) % modulus
        textHash = (base * textHash + text[i].code) % modulus
    }

    // Slide the pattern over text
    for (i in 0..text.length - m) {
        if (patternHash == textHash) {
            // Verify character by character (handle hash collisions)
            var match = true
            for (j in 0 until m) {
                if (text[i + j] != pattern[j]) {
                    match = false
                    break
                }
            }
            if (match) result.add(i)
        }

        // Calculate hash for next window
        if (i < text.length - m) {
            textHash = (base * (textHash - text[i].code * h) + text[i + m].code) % modulus
            if (textHash < 0) textHash += modulus
        }
    }
    return result
}

// ============================================================
// 3. Levenshtein Distance (Edit Distance)
// ============================================================

/**
 * Computes the minimum edit distance between two strings.
 * Time: O(m * n)
 * Space: O(m * n), can be optimized to O(min(m, n))
 */
fun levenshteinDistance(s1: String, s2: String): Int {
    val m = s1.length
    val n = s2.length
    val dp = Array(m + 1) { IntArray(n + 1) }

    // Base cases
    for (i in 0..m) dp[i][0] = i
    for (j in 0..n) dp[0][j] = j

    // Fill the DP table
    for (i in 1..m) {
        for (j in 1..n) {
            val cost = if (s1[i - 1] == s2[j - 1]) 0 else 1
            dp[i][j] = minOf(
                dp[i - 1][j] + 1,      // deletion
                dp[i][j - 1] + 1,      // insertion
                dp[i - 1][j - 1] + cost // substitution
            )
        }
    }
    return dp[m][n]
}

// ============================================================
// 4. Longest Common Subsequence
// ============================================================

/**
 * Finds the length of the longest common subsequence.
 * Time: O(m * n)
 * Space: O(m * n)
 */
fun longestCommonSubsequence(s1: String, s2: String): Int {
    val m = s1.length
    val n = s2.length
    val dp = Array(m + 1) { IntArray(n + 1) }

    for (i in 1..m) {
        for (j in 1..n) {
            if (s1[i - 1] == s2[j - 1]) {
                dp[i][j] = dp[i - 1][j - 1] + 1
            } else {
                dp[i][j] = maxOf(dp[i - 1][j], dp[i][j - 1])
            }
        }
    }
    return dp[m][n]
}

// ============================================================
// 5. Longest Palindromic Substring
// ============================================================

/**
 * Manacher's algorithm approach (simplified).
 * Time: O(n^2) with this expansion approach, O(n) with full Manacher's
 * Space: O(1)
 */
fun longestPalindromicSubstring(s: String): String {
    if (s.length < 2) return s

    var start = 0
    var maxLen = 1

    fun expandAroundCenter(left: Int, right: Int) {
        var l = left
        var r = right
        while (l >= 0 && r < s.length && s[l] == s[r]) {
            if (r - l + 1 > maxLen) {
                start = l
                maxLen = r - l + 1
            }
            l--
            r++
        }
    }

    for (i in s.indices) {
        expandAroundCenter(i, i)     // Odd length palindromes
        expandAroundCenter(i, i + 1) // Even length palindromes
    }

    return s.substring(start, start + maxLen)
}

// ============================================================
// 6. String Permutations (Backtracking)
// ============================================================

/**
 * Generates all unique permutations of a string.
 * Time: O(n * n!)
 * Space: O(n) for recursion stack
 */
fun permutations(s: String): List<String> {
    val result = mutableListOf<String>()
    val chars = s.toCharArray()

    fun swap(i: Int, j: Int) {
        val temp = chars[i]
        chars[i] = chars[j]
        chars[j] = temp
    }

    fun permute(left: Int) {
        if (left == chars.size - 1) {
            result.add(String(chars))
            return
        }
        for (i in left until chars.size) {
            swap(left, i)
            permute(left + 1)
            swap(left, i) // backtrack
        }
    }

    permute(0)
    return result.distinct() // Handle duplicates
}

// ============================================================
// 7. Anagram Grouping
// ============================================================

/**
 * Groups strings that are anagrams of each other.
 * Time: O(n * k log k) where n = number of strings, k = max string length
 * Space: O(n * k)
 */
fun groupAnagrams(strings: List<String>): List<List<String>> {
    return strings
        .groupBy { it.toCharArray().sorted().toString() }
        .values.toList()
}

// ============================================================
// 8. Boyer-Moore Majority Element
// ============================================================

/**
 * Finds majority element in a string (appears more than n/2 times).
 * Time: O(n)
 * Space: O(1)
 */
fun majorityElement(s: String): Char? {
    var candidate = s[0]
    var count = 1

    for (i in 1 until s.length) {
        if (count == 0) {
            candidate = s[i]
            count = 1
        } else if (s[i] == candidate) {
            count++
        } else {
            count--
        }
    }

    // Verify
    count = s.count { it == candidate }
    return if (count > s.length / 2) candidate else null
}

// ============================================================
// 9. Longest Substring Without Repeating Characters
// ============================================================

/**
 * Sliding window approach.
 * Time: O(n)
 * Space: O(min(n, m)) where m is the character set size
 */
fun longestUniqueSubstring(s: String): Int {
    val charIndex = mutableMapOf<Char, Int>()
    var maxLen = 0
    var start = 0

    for (end in s.indices) {
        if (s[end] in charIndex) {
            start = maxOf(start, charIndex[s[end]]!! + 1)
        }
        charIndex[s[end]] = end
        maxLen = maxOf(maxLen, end - start + 1)
    }
    return maxLen
}

// ============================================================
// 10. Z-Algorithm
// ============================================================

/**
 * Computes the Z-array where Z[i] is the length of the longest
 * substring starting at i that is also a prefix of the string.
 * Time: O(n)
 * Space: O(n)
 */
fun zAlgorithm(s: String): IntArray {
    val n = s.length
    val z = IntArray(n)
    var left = 0
    var right = 0

    for (i in 1 until n) {
        if (i <= right) {
            z[i] = minOf(right - i + 1, z[i - left])
        }
        while (i + z[i] < n && s[z[i]] == s[i + z[i]]) {
            z[i]++
        }
        if (i + z[i] - 1 > right) {
            left = i
            right = i + z[i] - 1
        }
    }
    return z
}

// ============================================================
// Demo / Main
// ============================================================

fun main() {
    println("=== Kotlin String Algorithms Demo ===\n")

    // KMP
    val text = "ABABDABACDABABCABAB"
    val pattern = "ABABCABAB"
    println("KMP Search '$pattern' in '$text':")
    println("  Found at indices: ${kmpSearch(text, pattern)}")

    // Rabin-Karp
    println("\nRabin-Karp Search:")
    println("  Found at indices: ${rabinKarp(text, pattern)}")

    // Levenshtein Distance
    println("\nLevenshtein Distance:")
    println("  'kitten' -> 'sitting': ${levenshteinDistance("kitten", "sitting")}")
    println("  'saturday' -> 'sunday': ${levenshteinDistance("saturday", "sunday")}")

    // Longest Common Subsequence
    println("\nLongest Common Subsequence:")
    println("  'ABCDGH' vs 'AEDFHR': ${longestCommonSubsequence("ABCDGH", "AEDFHR")}")
    println("  'AGGTAB' vs 'GXTXAYB': ${longestCommonSubsequence("AGGTAB", "GXTXAYB")}")

    // Longest Palindromic Substring
    println("\nLongest Palindromic Substring:")
    println("  'babad' -> '${longestPalindromicSubstring("babad")}'")
    println("  'cbbd' -> '${longestPalindromicSubstring("cbbd")}'")

    // Permutations
    println("\nPermutations of 'ABC':")
    println("  ${permutations("ABC")}")

    // Group Anagrams
    println("\nGroup Anagrams:")
    val anagramGroups = groupAnagrams(listOf("eat", "tea", "tan", "ate", "nat", "bat"))
    anagramGroups.forEach { println("  $it") }

    // Majority Element
    println("\nMajority Element:")
    println("  'aabbb': ${majorityElement("aabbb")}")
    println("  'abc': ${majorityElement("abc")}")

    // Longest Unique Substring
    println("\nLongest Substring Without Repeating Characters:")
    println("  'abcabcbb': ${longestUniqueSubstring("abcabcbb")}")
    println("  'bbbbb': ${longestUniqueSubstring("bbbbb")}")
    println("  'pwwkew': ${longestUniqueSubstring("pwwkew")}")

    // Z-Algorithm
    println("\nZ-Algorithm for 'aabxaabxcaabxaabx':")
    val z = zAlgorithm("aabxaabxcaabxaabx")
    println("  Z-array: ${z.toList()}")
}
