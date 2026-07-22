import Foundation

// ============================================================
// String Algorithms in Swift
// ============================================================

// MARK: - 1. KMP (Knuth-Morris-Pratt) Pattern Matching

/// Computes the KMP failure function (partial match table).
/// - Time: O(m) where m is pattern length
/// - Space: O(m)
func computeLPS(pattern: String) -> [Int] {
    let patternArray = Array(pattern)
    var lps = Array(repeating: 0, count: patternArray.count)
    var length = 0
    var i = 1

    while i < patternArray.count {
        if patternArray[i] == patternArray[length] {
            length += 1
            lps[i] = length
            i += 1
        } else {
            if length != 0 {
                length = lps[length - 1]
            } else {
                lps[i] = 0
                i += 1
            }
        }
    }
    return lps
}

/// KMP pattern matching algorithm.
/// - Time: O(n + m) where n is text length, m is pattern length
/// - Space: O(m) for the LPS array
func kmpSearch(text: String, pattern: String) -> [Int] {
    guard !pattern.isEmpty else { return [0] }

    let textArray = Array(text)
    let patternArray = Array(pattern)
    let lps = computeLPS(pattern: pattern)
    var result: [Int] = []
    var i = 0
    var j = 0

    while i < textArray.count {
        if textArray[i] == patternArray[j] {
            i += 1
            j += 1
        }

        if j == patternArray.count {
            result.append(i - j)
            j = lps[j - 1]
        } else if i < textArray.count && textArray[i] != patternArray[j] {
            if j != 0 {
                j = lps[j - 1]
            } else {
                i += 1
            }
        }
    }
    return result
}

// MARK: - 2. Rabin-Karp Algorithm

/// Rabin-Karp pattern matching using rolling hash.
/// - Time: O(n + m) average, O(n * m) worst case
/// - Space: O(1)
func rabinKarp(text: String, pattern: String) -> [Int] {
    var result: [Int] = []
    guard pattern.count <= text.count else { return result }

    let textArray = Array(text)
    let patternArray = Array(pattern)
    let base = 256
    let modulus = 1_000_000_007
    let m = patternArray.count

    // Compute base^(m-1) % modulus
    var h = 1
    for _ in 0..<(m - 1) {
        h = (h * base) % modulus
    }

    // Compute hash of pattern and first window
    var patternHash = 0
    var textHash = 0
    for i in 0..<m {
        patternHash = (base * patternHash + Int(textArray[i].asciiValue!)) % modulus
        textHash = (base * textHash + Int(textArray[i].asciiValue!)) % modulus
    }

    // Slide pattern over text
    for i in 0...(text.count - m) {
        if patternHash == textHash {
            var match = true
            for j in 0..<m {
                if textArray[i + j] != patternArray[j] {
                    match = false
                    break
                }
            }
            if match { result.append(i) }
        }

        if i < text.count - m {
            textHash = (base * (textHash - Int(textArray[i].asciiValue!) * h) + Int(textArray[i + m].asciiValue!)) % modulus
            if textHash < 0 { textHash += modulus }
        }
    }
    return result
}

// MARK: - 3. Levenshtein Distance (Edit Distance)

/// Computes the minimum edit distance between two strings.
/// - Time: O(m * n)
/// - Space: O(m * n)
func levenshteinDistance(_ s1: String, _ s2: String) -> Int {
    let s1Array = Array(s1)
    let s2Array = Array(s2)
    let m = s1Array.count
    let n = s2Array.count

    var dp = Array(repeating: Array(repeating: 0, count: n + 1), count: m + 1)

    for i in 0...m { dp[i][0] = i }
    for j in 0...n { dp[0][j] = j }

    for i in 1...m {
        for j in 1...n {
            let cost = s1Array[i - 1] == s2Array[j - 1] ? 0 : 1
            dp[i][j] = min(
                dp[i - 1][j] + 1,      // deletion
                dp[i][j - 1] + 1,      // insertion
                dp[i - 1][j - 1] + cost // substitution
            )
        }
    }
    return dp[m][n]
}

// MARK: - 4. Longest Common Subsequence

/// Finds the length of the longest common subsequence.
/// - Time: O(m * n)
/// - Space: O(m * n)
func longestCommonSubsequence(_ s1: String, _ s2: String) -> Int {
    let s1Array = Array(s1)
    let s2Array = Array(s2)
    let m = s1Array.count
    let n = s2Array.count

    var dp = Array(repeating: Array(repeating: 0, count: n + 1), count: m + 1)

    for i in 1...m {
        for j in 1...n {
            if s1Array[i - 1] == s2Array[j - 1] {
                dp[i][j] = dp[i - 1][j - 1] + 1
            } else {
                dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])
            }
        }
    }
    return dp[m][n]
}

// MARK: - 5. Longest Palindromic Substring

/// Finds the longest palindromic substring using expand-around-center.
/// - Time: O(n^2)
/// - Space: O(1)
func longestPalindromicSubstring(_ s: String) -> String {
    guard s.count >= 2 else { return s }
    let chars = Array(s)

    var start = 0
    var maxLen = 1

    func expandAroundCenter(_ left: Int, _ right: Int) {
        var l = left, r = right
        while l >= 0, r < chars.count, chars[l] == chars[r] {
            if r - l + 1 > maxLen {
                start = l
                maxLen = r - l + 1
            }
            l -= 1
            r += 1
        }
    }

    for i in 0..<chars.count {
        expandAroundCenter(i, i)       // Odd length
        expandAroundCenter(i, i + 1)   // Even length
    }

    return String(chars[start..<(start + maxLen)])
}

// MARK: - 6. String Permutations

/// Generates all unique permutations of a string.
/// - Time: O(n * n!)
/// - Space: O(n) for recursion stack
func permutations(_ s: String) -> [String] {
    var result: [String] = []
    var chars = Array(s)

    func permute(_ left: Int) {
        if left == chars.count - 1 {
            result.append(String(chars))
            return
        }
        var used = Set<Character>()
        for i in left..<chars.count {
            if !used.contains(chars[i]) {
                used.insert(chars[i])
                chars.swapAt(left, i)
                permute(left + 1)
                chars.swapAt(left, i)  // backtrack
            }
        }
    }

    permute(0)
    return result
}

// MARK: - 7. Anagram Grouping

/// Groups strings that are anagrams of each other.
/// - Time: O(n * k log k) where n = number of strings, k = max string length
/// - Space: O(n * k)
func groupAnagrams(_ strings: [String]) -> [[String]] {
    var dict = [String: [String]]()
    for s in strings {
        let key = String(s.sorted())
        dict[key, default: []].append(s)
    }
    return Array(dict.values)
}

// MARK: - 8. Boyer-Moore Majority Element

/// Finds the majority element (appears more than n/2 times).
/// - Time: O(n)
/// - Space: O(1)
func majorityElement(_ s: String) -> Character? {
    guard !s.isEmpty else { return nil }
    let chars = Array(s)

    var candidate = chars[0]
    var count = 1

    for i in 1..<chars.count {
        if count == 0 {
            candidate = chars[i]
            count = 1
        } else if chars[i] == candidate {
            count += 1
        } else {
            count -= 1
        }
    }

    // Verify
    count = chars.filter { $0 == candidate }.count
    return count > chars.count / 2 ? candidate : nil
}

// MARK: - 9. Longest Substring Without Repeating Characters

/// Sliding window approach.
/// - Time: O(n)
/// - Space: O(min(n, m)) where m is character set size
func longestUniqueSubstring(_ s: String) -> Int {
    var charIndex = [Character: Int]()
    var maxLen = 0
    var start = 0
    let chars = Array(s)

    for end in 0..<chars.count {
        if let lastIndex = charIndex[chars[end]] {
            start = max(start, lastIndex + 1)
        }
        charIndex[chars[end]] = end
        maxLen = max(maxLen, end - start + 1)
    }
    return maxLen
}

// MARK: - 10. Z-Algorithm

/// Computes the Z-array where Z[i] is the length of the longest
/// substring starting at i that is also a prefix.
/// - Time: O(n)
/// - Space: O(n)
func zAlgorithm(_ s: String) -> [Int] {
    let chars = Array(s)
    let n = chars.count
    var z = Array(repeating: 0, count: n)
    var left = 0, right = 0

    for i in 1..<n {
        if i <= right {
            z[i] = min(right - i + 1, z[i - left])
        }
        while i + z[i] < n, chars[z[i]] == chars[i + z[i]] {
            z[i] += 1
        }
        if i + z[i] - 1 > right {
            left = i
            right = i + z[i] - 1
        }
    }
    return z
}

// MARK: - 11. Manacher's Algorithm

/// Finds the longest palindromic substring in linear time.
/// - Time: O(n)
/// - Space: O(n)
func manachersAlgorithm(_ s: String) -> String {
    guard !s.isEmpty else { return "" }

    // Transform: "abc" -> "^#a#b#c#$"
    let t = "^#" + s.map { "\($0)#" }.joined() + "$"
    let tChars = Array(t)
    var p = Array(repeating: 0, count: tChars.count)
    var center = 0, right = 0

    for i in 1..<(tChars.count - 1) {
        let mirror = 2 * center - i
        if i < right {
            p[i] = min(right - i, p[mirror])
        }

        while tChars[i + p[i] + 1] == tChars[i - p[i] - 1] {
            p[i] += 1
        }

        if i + p[i] > right {
            center = i
            right = i + p[i]
        }
    }

    let maxLen = p.max()!
    let centerIndex = p.firstIndex(of: maxLen)!
    let start = (centerIndex - maxLen) / 2
    return String(s.dropFirst(start).prefix(maxLen))
}

// MARK: - Demo / Main

print("=== Swift String Algorithms Demo ===\n")

// KMP
let text = "ABABDABACDABABCABAB"
let pattern = "ABABCABAB"
print("KMP Search '\(pattern)' in '\(text)':")
print("  Found at indices: \(kmpSearch(text: text, pattern: pattern))")

// Rabin-Karp
print("\nRabin-Karp Search:")
print("  Found at indices: \(rabinKarp(text: text, pattern: pattern))")

// Levenshtein Distance
print("\nLevenshtein Distance:")
print("  'kitten' -> 'sitting': \(levenshteinDistance("kitten", "sitting"))")
print("  'saturday' -> 'sunday': \(levenshteinDistance("saturday", "sunday"))")

// Longest Common Subsequence
print("\nLongest Common Subsequence:")
print("  'ABCDGH' vs 'AEDFHR': \(longestCommonSubsequence("ABCDGH", "AEDFHR"))")
print("  'AGGTAB' vs 'GXTXAYB': \(longestCommonSubsequence("AGGTAB", "GXTXAYB"))")

// Longest Palindromic Substring
print("\nLongest Palindromic Substring:")
print("  'babad' -> '\(longestPalindromicSubstring("babad"))'")
print("  'cbbd' -> '\(longestPalindromicSubstring("cbbd"))'")

// Permutations
print("\nPermutations of 'ABC':")
print("  \(permutations("ABC"))")

// Group Anagrams
print("\nGroup Anagrams:")
let anagramGroups = groupAnagrams(["eat", "tea", "tan", "ate", "nat", "bat"])
for group in anagramGroups {
    print("  \(group)")
}

// Majority Element
print("\nMajority Element:")
print("  'aabbb': \(majorityElement("aabbb")?.description ?? "nil")")
print("  'abc': \(majorityElement("abc")?.description ?? "nil")")

// Longest Unique Substring
print("\nLongest Substring Without Repeating Characters:")
print("  'abcabcbb': \(longestUniqueSubstring("abcabcbb"))")
print("  'bbbbb': \(longestUniqueSubstring("bbbbb"))")
print("  'pwwkew': \(longestUniqueSubstring("pwwkew"))")

// Z-Algorithm
print("\nZ-Algorithm for 'aabxaabxcaabxaabx':")
let zResult = zAlgorithm("aabxaabxcaabxaabx")
print("  Z-array: \(zResult)")

// Manacher's Algorithm
print("\nManacher's Algorithm:")
print("  'babad' -> '\(manachersAlgorithm("babad"))'")
print("  'cbbd' -> '\(manachersAlgorithm("cbbd"))'")
