# String Algorithms in PHP

## Overview

PHP provides extensive built-in string functions that make many string algorithms trivial to implement. However, understanding the underlying algorithms helps with optimization and interviews. This file covers both idiomatic PHP approaches and manual implementations.

## Algorithms

### Character Frequency Count

```php
// Time: O(n), Space: O(k) where k = unique characters
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

// PHP-idiomatic: count_chars() is C-level optimized
function charFrequencyIdiomatic(string $str): array {
    $counts = count_chars(strtolower($str), 1);
    $result = [];
    foreach ($counts as $char => $count) {
        $result[chr($char)] = $count;
    }
    arsort($result);
    return $result;
}
```

### Palindrome Check

```php
// Time: O(n), Space: O(n)
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

// Idiomatic: strrev() is C-level optimized
function isPalindromeIdiomatic(string $str): bool {
    $clean = preg_replace('/[^a-zA-Z0-9]/', '', strtolower($str));
    return $clean === strrev($clean);
}
```

### Run-Length Encoding

```php
// Time: O(n), Space: O(n)
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
```

### Longest Palindromic Substring

```php
// Time: O(n^2), Space: O(1)
function longestPalindrome(string $str): string {
    $len = mb_strlen($str);
    if ($len < 2) return $str;

    $start = 0;
    $maxLen = 1;

    function expandAroundCenter(string $s, int $left, int $right): array {
        while ($left >= 0 && $right < mb_strlen($s) &&
               mb_substr($s, $left, 1) === mb_substr($s, $right, 1)) {
            $left--;
            $right++;
        }
        return [$left + 1, $right - $left - 1];
    }

    for ($i = 0; $i < $len; $i++) {
        [$l1, $len1] = expandAroundCenter($str, $i, $i);
        [$l2, $len2] = expandAroundCenter($str, $i, $i + 1);
        if ($len1 > $maxLen) { $start = $l1; $maxLen = $len1; }
        if ($len2 > $maxLen) { $start = $l2; $maxLen = $len2; }
    }

    return mb_substr($str, $start, $maxLen);
}
```

### Longest Common Prefix

```php
// Time: O(n * m), Space: O(m)
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
```

### Anagram Check

```php
// Time: O(n log n), Space: O(n)
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

// Idiomatic: count_chars() compares character histograms
function isAnagramIdiomatic(string $str1, string $str2): bool {
    $clean1 = preg_replace('/[^a-zA-Z]/', '', strtolower($str1));
    $clean2 = preg_replace('/[^a-zA-Z]/', '', strtolower($str2));
    return count_chars($clean1, 0) === count_chars($clean2, 0);
}
```

### String Matching

```php
// Time: O(n + m) using PHP's optimized strpos
function findOccurrences(string $haystack, string $needle): array {
    $positions = [];
    $offset = 0;
    while (($pos = strpos($haystack, $needle, $offset)) !== false) {
        $positions[] = $pos;
        $offset = $pos + 1;
    }
    return $positions;
}
```

## PHP String Function Reference

| Function | Purpose | Complexity |
|----------|---------|------------|
| `strlen()` | Byte length | O(1) |
| `mb_strlen()` | Multibyte character length | O(n) |
| `strpos()` | Find first occurrence | O(n*m) |
| `substr()` | Extract substring | O(n) |
| `str_replace()` | Replace occurrences | O(n*m) |
| `preg_replace()` | Regex replace | O(n) |
| `strtolower()` | Case conversion | O(n) |
| `str_split()` | String to array | O(n) |
| `implode()` | Array to string | O(n) |
| `explode()` | String to array | O(n) |
| `count_chars()` | Character frequency | O(n) |

## See Also

- [[PHP/Algorithms/String/string_algorithms|String Algorithms (code)]]
- [[PHP/Basics/syntax|PHP Syntax]]
- [[PHP/OOP/oop|PHP OOP]]
