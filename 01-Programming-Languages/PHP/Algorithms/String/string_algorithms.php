<?php
/**
 * String Algorithms in PHP
 *
 * Demonstrates common string algorithms using PHP's built-in functions
 * and manual implementations.
 *
 * Run: php string_algorithms.php
 */

// ============================================================
// 1. Character Frequency Count
// Time: O(n), Space: O(k) where k = unique characters
// ============================================================
function charFrequency(string $str): array {
    $freq = [];
    $chars = mb_str_split(mb_strtolower($str));
    foreach ($chars as $char) {
        if ($char === ' ') continue;
        $freq[$char] = ($freq[$char] ?? 0) + 1;
    }
    arsort($freq);
    return $freq;
}

// PHP-idiomatic version using count_chars (C-level, faster)
function charFrequencyIdiomatic(string $str): array {
    $counts = count_chars(strtolower($str), 1);
    $result = [];
    foreach ($counts as $char => $count) {
        $result[chr($char)] = $count;
    }
    arsort($result);
    return $result;
}

// ============================================================
// 2. Palindrome Check
// Time: O(n), Space: O(n) for the cleaned string
// ============================================================
function isPalindrome(string $str): bool {
    $clean = preg_replace('/[^a-zA-Z0-9]/', '', strtolower($str));
    $len = strlen($clean);
    for ($i = 0; $i < $len / 2; $i++) {
        if ($clean[$i] !== $clean[$len - 1 - $i]) {
            return false;
        }
    }
    return true;
}

// PHP-idiomatic version using strrev
function isPalindromeIdiomatic(string $str): bool {
    $clean = preg_replace('/[^a-zA-Z0-9]/', '', strtolower($str));
    return $clean === strrev($clean);
}

// ============================================================
// 3. Reverse a String
// Time: O(n), Space: O(n)
// ============================================================
function reverseString(string $str): string {
    $reversed = '';
    $len = mb_strlen($str);
    for ($i = $len - 1; $i >= 0; $i--) {
        $reversed .= mb_substr($str, $i, 1);
    }
    return $reversed;
}

// PHP-idiomatic version using strrev
function reverseStringIdiomatic(string $str): string {
    return strrev($str);
}

// ============================================================
// 4. Word Count
// Time: O(n), Space: O(1)
// ============================================================
function wordCount(string $str): int {
    $trimmed = trim($str);
    if ($trimmed === '') return 0;
    return count(preg_split('/\s+/', $trimmed));
}

// ============================================================
// 5. Longest Common Prefix
// Time: O(n * m) where m = min string length
// Space: O(m)
// ============================================================
function longestCommonPrefix(array $strings): string {
    if (empty($strings)) return '';
    $prefix = $strings[0];
    for ($i = 1; $i < count($strings); $i++) {
        while (strpos($strings[$i], $prefix) !== 0) {
            $prefix = substr($prefix, 0, -1);
            if ($prefix === '') return '';
        }
    }
    return $prefix;
}

// ============================================================
// 6. Anagram Check
// Time: O(n log n), Space: O(n)
// ============================================================
function isAnagram(string $str1, string $str2): bool {
    $clean1 = preg_replace('/[^a-zA-Z]/', '', strtolower($str1));
    $clean2 = preg_replace('/[^a-zA-Z]/', '', strtolower($str2));

    if (strlen($clean1) !== strlen($clean2)) return false;

    $chars1 = str_split($clean1);
    $chars2 = str_split($clean2);
    sort($chars1);
    sort($chars2);

    return $chars1 === $chars2;
}

// PHP-idiomatic version using count_chars
function isAnagramIdiomatic(string $str1, string $str2): bool {
    $clean1 = preg_replace('/[^a-zA-Z]/', '', strtolower($str1));
    $clean2 = preg_replace('/[^a-zA-Z]/', '', strtolower($str2));
    return count_chars($clean1, 0) === count_chars($clean2, 0);
}

// ============================================================
// 7. Run-Length Encoding
// Time: O(n), Space: O(n)
// ============================================================
function runLengthEncode(string $str): string {
    if ($str === '') return '';
    $encoded = '';
    $count = 1;
    $len = mb_strlen($str);

    for ($i = 1; $i < $len; $i++) {
        if (mb_substr($str, $i, 1) === mb_substr($str, $i - 1, 1)) {
            $count++;
        } else {
            $encoded .= mb_substr($str, $i - 1, 1) . $count;
            $count = 1;
        }
    }
    $encoded .= mb_substr($str, $len - 1, 1) . $count;
    return $encoded;
}

function runLengthDecode(string $encoded): string {
    $decoded = '';
    preg_match_all('/(.)(\d+)/', $encoded, $matches, PREG_SET_ORDER);
    foreach ($matches as $match) {
        $decoded .= str_repeat($match[1], (int)$match[2]);
    }
    return $decoded;
}

// ============================================================
// 8. Longest Palindromic Substring
// Time: O(n^2), Space: O(1)
// ============================================================
function longestPalindrome(string $str): string {
    $len = mb_strlen($str);
    if ($len < 2) return $str;

    $start = 0;
    $maxLen = 1;

    for ($i = 0; $i < $len; $i++) {
        // Odd-length palindromes
        [$l1, $len1] = expandAroundCenter($str, $i, $i);
        // Even-length palindromes
        [$l2, $len2] = expandAroundCenter($str, $i, $i + 1);

        if ($len1 > $maxLen) { $start = $l1; $maxLen = $len1; }
        if ($len2 > $maxLen) { $start = $l2; $maxLen = $len2; }
    }

    return mb_substr($str, $start, $maxLen);
}

function expandAroundCenter(string $s, int $left, int $right): array {
    $len = mb_strlen($s);
    while ($left >= 0 && $right < $len &&
           mb_substr($s, $left, 1) === mb_substr($s, $right, 1)) {
        $left--;
        $right++;
    }
    return [$left + 1, $right - $left - 1];
}

// ============================================================
// 9. Find All Substring Occurrences
// Time: O(n * m), Space: O(k) where k = number of matches
// ============================================================
function findOccurrences(string $haystack, string $needle): array {
    $positions = [];
    $offset = 0;
    while (($pos = strpos($haystack, $needle, $offset)) !== false) {
        $positions[] = $pos;
        $offset = $pos + 1;
    }
    return $positions;
}

// ============================================================
// 10. All Unique Characters (without extra data structure)
// Time: O(n^2), Space: O(1)
// ============================================================
function hasAllUniqueChars(string $str): bool {
    $len = strlen($str);
    for ($i = 0; $i < $len; $i++) {
        for ($j = $i + 1; $j < $len; $j++) {
            if ($str[$i] === $str[$j]) return false;
        }
    }
    return true;
}

// ============================================================
// Demo
// ============================================================
echo "=== String Algorithms in PHP ===\n\n";

// 1. Character Frequency
$text = "programming is fun";
echo "1. Character Frequency of \"$text\":\n";
$freq = charFrequency($text);
foreach (array_slice($freq, 0, 5, true) as $char => $count) {
    echo "   '$char': $count\n";
}

// 2. Palindrome
echo "\n2. Palindrome Check:\n";
echo "   'racecar': " . (isPalindrome('racecar') ? 'Yes' : 'No') . "\n";
echo "   'hello': " . (isPalindrome('hello') ? 'Yes' : 'No') . "\n";
echo "   'A man a plan a canal Panama': " .
     (isPalindrome('A man a plan a canal Panama') ? 'Yes' : 'No') . "\n";

// 3. Reverse
echo "\n3. Reverse: \"Hello PHP\" -> \"" . reverseString("Hello PHP") . "\"\n";

// 4. Word Count
echo "\n4. Word Count: \"Hello World from PHP\" has " .
     wordCount("Hello World from PHP") . " words\n";

// 5. Anagram Check
echo "\n5. Anagram Check:\n";
echo "   'listen' & 'silent': " . (isAnagram('listen', 'silent') ? 'Yes' : 'No') . "\n";
echo "   'hello' & 'world': " . (isAnagram('hello', 'world') ? 'Yes' : 'No') . "\n";

// 6. Run-Length Encoding
echo "\n6. Run-Length Encoding:\n";
$encoded = runLengthEncode("aaabbccdddde");
echo "   'aaabbccdddde' -> '$encoded'\n";
echo "   Decoded: '" . runLengthDecode($encoded) . "'\n";

// 7. Longest Palindromic Substring
echo "\n7. Longest Palindromic Substring:\n";
echo "   'babad' -> '" . longestPalindrome('babad') . "'\n";
echo "   'cbbd' -> '" . longestPalindrome('cbbd') . "'\n";

// 8. Longest Common Prefix
echo "\n8. Longest Common Prefix:\n";
$words = ["flower", "flow", "flight"];
echo "   " . implode(", ", $words) . " -> '" . longestCommonPrefix($words) . "'\n";

// 9. Find Substring Occurrences
echo "\n9. Find Substring Occurrences:\n";
$haystack = "the cat in the hat sat on the mat";
$needle = "the";
$positions = findOccurrences($haystack, $needle);
echo "   '$needle' in '$haystack': positions " . implode(", ", $positions) . "\n";

// 10. All Unique Characters
echo "\n10. All Unique Characters:\n";
echo "    'abcdef': " . (hasAllUniqueChars('abcdef') ? 'Yes' : 'No') . "\n";
echo "    'hello': " . (hasAllUniqueChars('hello') ? 'Yes' : 'No') . "\n";
