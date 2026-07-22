// String algorithms in Rust using String and &str types.
// This file demonstrates common string manipulation algorithms with Rust's
// ownership system and pattern matching capabilities.

use std::collections::HashMap;

/// Checks if a string reads the same forwards and backwards.
/// Time complexity: O(n), Space complexity: O(n) for the cleaned string.
fn is_palindrome(s: &str) -> bool {
    // Convert to lowercase and keep only alphanumeric characters
    let cleaned: String = s
        .chars()
        .filter(|c| c.is_alphanumeric())
        .map(|c| c.to_lowercase().next().unwrap_or(c))
        .collect();

    let chars: Vec<char> = cleaned.chars().collect();
    let len = chars.len();
    
    // Compare characters from both ends
    for i in 0..len / 2 {
        if chars[i] != chars[len - 1 - i] {
            return false;
        }
    }
    true
}

/// Checks if two strings are anagrams of each other.
/// Time complexity: O(n), Space complexity: O(1) for fixed character set.
fn is_anagram(s1: &str, s2: &str) -> bool {
    // Convert to lowercase and remove spaces
    let s1: String = s1.chars().filter(|c| !c.is_whitespace()).collect();
    let s2: String = s2.chars().filter(|c| !c.is_whitespace()).collect();
    
    let s1 = s1.to_lowercase();
    let s2 = s2.to_lowercase();
    
    if s1.len() != s2.len() {
        return false;
    }
    
    // Count character frequencies
    let mut freq = HashMap::new();
    for c in s1.chars() {
        *freq.entry(c).or_insert(0) += 1;
    }
    for c in s2.chars() {
        *freq.entry(c).or_insert(0) -= 1;
        if freq[&c] < 0 {
            return false;
        }
    }
    true
}

/// Reverses a string handling Unicode properly.
/// Time complexity: O(n), Space complexity: O(n).
fn reverse_string(s: &str) -> String {
    s.chars().rev().collect()
}

/// Finds the longest common substring between two strings.
/// Time complexity: O(m*n), Space complexity: O(m*n).
fn longest_common_substring(s1: &str, s2: &str) -> String {
    let s1_chars: Vec<char> = s1.chars().collect();
    let s2_chars: Vec<char> = s2.chars().collect();
    let len1 = s1_chars.len();
    let len2 = s2_chars.len();
    
    if len1 == 0 || len2 == 0 {
        return String::new();
    }
    
    // Create DP table
    let mut dp = vec![vec![0; len2 + 1]; len1 + 1];
    let mut max_len = 0;
    let mut end_pos = 0;
    
    // Fill DP table
    for i in 1..=len1 {
        for j in 1..=len2 {
            if s1_chars[i - 1] == s2_chars[j - 1] {
                dp[i][j] = dp[i - 1][j - 1] + 1;
                if dp[i][j] > max_len {
                    max_len = dp[i][j];
                    end_pos = i;
                }
            }
        }
    }
    
    s1_chars[end_pos - max_len..end_pos].iter().collect()
}

/// Finds the longest common prefix among an array of strings.
/// Time complexity: O(S) where S is the sum of all characters, Space complexity: O(1).
fn longest_common_prefix(strs: &[&str]) -> String {
    if strs.is_empty() {
        return String::new();
    }
    
    let mut prefix = strs[0].to_string();
    
    for i in 1..strs.len() {
        // Reduce prefix until it matches the start of strs[i]
        while !strs[i].starts_with(&prefix) {
            prefix.pop();
            if prefix.is_empty() {
                return String::new();
            }
        }
    }
    
    prefix
}

/// Counts the number of vowels in a string.
/// Time complexity: O(n), Space complexity: O(1).
fn count_vowels(s: &str) -> usize {
    s.chars()
        .filter(|c| "aeiou".contains(c.to_lowercase().next().unwrap()))
        .count()
}

/// Counts the number of words in a string.
/// Time complexity: O(n), Space complexity: O(1).
fn count_words(s: &str) -> usize {
    s.split_whitespace().count()
}

/// Converts a string to camelCase.
/// Time complexity: O(n), Space complexity: O(n).
fn to_camel_case(s: &str) -> String {
    let words: Vec<&str> = s.split(|c: char| !c.is_alphanumeric() && !c.is_alphabetic())
        .filter(|w| !w.is_empty())
        .collect();
    
    if words.is_empty() {
        return String::new();
    }
    
    let mut result = String::new();
    
    // First word in lowercase
    result.push_str(&words[0].to_lowercase());
    
    // Subsequent words with first letter capitalized
    for word in &words[1..] {
        if let Some(first) = word.chars().next() {
            result.push_str(&first.to_uppercase().to_string());
            result.push_str(&word[1..].to_lowercase());
        }
    }
    
    result
}

/// Converts a string to snake_case.
/// Time complexity: O(n), Space complexity: O(n).
fn to_snake_case(s: &str) -> String {
    let mut result = String::new();
    
    for (i, c) in s.chars().enumerate() {
        if c.is_uppercase() {
            if i > 0 {
                result.push('_');
            }
            result.push_str(&c.to_lowercase().to_string());
        } else {
            result.push(c);
        }
    }
    
    result
}

/// Checks if one string is a rotation of another.
/// Time complexity: O(n), Space complexity: O(n).
fn string_rotation(s1: &str, s2: &str) -> bool {
    if s1.len() != s2.len() {
        return false;
    }
    // Concatenate s1 with itself and check if s2 is a substring
    let combined = format!("{}{}", s1, s1);
    combined.contains(s2)
}

/// Applies run-length encoding to a string.
/// Time complexity: O(n), Space complexity: O(n).
fn run_length_encoding(s: &str) -> String {
    if s.is_empty() {
        return String::new();
    }
    
    let mut result = String::new();
    let chars: Vec<char> = s.chars().collect();
    let mut count = 1;
    
    for i in 1..=chars.len() {
        if i < chars.len() && chars[i] == chars[i - 1] {
            count += 1;
        } else {
            result.push(chars[i - 1]);
            if count > 1 {
                result.push_str(&count.to_string());
            }
            count = 1;
        }
    }
    
    result
}

/// Decodes a run-length encoded string.
/// Time complexity: O(n), Space complexity: O(n).
fn run_length_decoding(s: &str) -> String {
    let mut result = String::new();
    let chars: Vec<char> = s.chars().collect();
    let mut i = 0;
    
    while i < chars.len() {
        let char = chars[i];
        i += 1;
        
        // Read the count
        let mut count = 0;
        while i < chars.len() && chars[i].is_digit(10) {
            count = count * 10 + chars[i].to_digit(10).unwrap() as usize;
            i += 1;
        }
        
        // Append character count times
        if count == 0 {
            count = 1;
        }
        for _ in 0..count {
            result.push(char);
        }
    }
    
    result
}

/// Finds all permutations of a string (for demonstration).
/// Time complexity: O(n!), Space complexity: O(n!).
fn permutations(s: &str) -> Vec<String> {
    let mut chars: Vec<char> = s.chars().collect();
    let mut result = Vec::new();
    permute(&mut chars, 0, &mut result);
    result
}

fn permute(chars: &mut Vec<char>, start: usize, result: &mut Vec<String>) {
    if start >= chars.len() {
        result.push(chars.iter().collect());
        return;
    }
    
    for i in start..chars.len() {
        chars.swap(start, i);
        permute(chars, start + 1, result);
        chars.swap(start, i); // Backtrack
    }
}

/// Checks if a string is an anagram of another using sorting.
/// Time complexity: O(n log n), Space complexity: O(n).
fn is_anagram_sort(s1: &str, s2: &str) -> bool {
    let mut s1: Vec<char> = s1.chars().filter(|c| !c.is_whitespace()).collect();
    let mut s2: Vec<char> = s2.chars().filter(|c| !c.is_whitespace()).collect();
    
    s1.sort();
    s2.sort();
    
    s1 == s2
}

/// Finds the first non-repeating character in a string.
/// Time complexity: O(n), Space complexity: O(1) for fixed character set.
fn first_non_repeating(s: &str) -> Option<char> {
    let mut freq = HashMap::new();
    
    // Count frequencies
    for c in s.chars() {
        *freq.entry(c).or_insert(0) += 1;
    }
    
    // Find first character with count 1
    for c in s.chars() {
        if freq[&c] == 1 {
            return Some(c);
        }
    }
    
    None
}

/// Checks if two strings are one edit distance apart.
/// Time complexity: O(n), Space complexity: O(1).
fn one_edit_distance(s1: &str, s2: &str) -> bool {
    let len1 = s1.len();
    let len2 = s2.len();
    
    if (len1 as i32 - len2 as i32).abs() > 1 {
        return false;
    }
    
    let (shorter, longer) = if len1 <= len2 {
        (s1, s2)
    } else {
        (s2, s1)
    };
    
    let shorter_chars: Vec<char> = shorter.chars().collect();
    let longer_chars: Vec<char> = longer.chars().collect();
    
    let mut found_difference = false;
    let mut i = 0;
    let mut j = 0;
    
    while i < shorter_chars.len() && j < longer_chars.len() {
        if shorter_chars[i] != longer_chars[j] {
            if found_difference {
                return false;
            }
            found_difference = true;
            
            if shorter.len() == longer.len() {
                i += 1;
            }
        } else {
            i += 1;
        }
        j += 1;
    }
    
    true
}

fn main() {
    println!("=== String Algorithms in Rust ===");
    println!();
    
    // Palindrome check
    let palindrome_tests = ["racecar", "A man a plan a canal Panama", "hello"];
    for test in palindrome_tests {
        println!("is_palindrome(\"{}\") = {}", test, is_palindrome(test));
    }
    println!();
    
    // Anagram check
    println!(
        "is_anagram(\"listen\", \"silent\") = {}",
        is_anagram("listen", "silent")
    );
    println!(
        "is_anagram(\"hello\", \"world\") = {}",
        is_anagram("hello", "world")
    );
    println!();
    
    // String reversal
    println!("reverse_string(\"hello\") = \"{}\"", reverse_string("hello"));
    println!(
        "reverse_string(\"racecar\") = \"{}\"",
        reverse_string("racecar")
    );
    println!();
    
    // Longest common substring
    println!(
        "longest_common_substring(\"abcdef\", \"bcdefg\") = \"{}\"",
        longest_common_substring("abcdef", "bcdefg")
    );
    println!();
    
    // Longest common prefix
    let strs = ["flower", "flow", "flight"];
    println!(
        "longest_common_prefix([\"flower\", \"flow\", \"flight\"]) = \"{}\"",
        longest_common_prefix(&strs)
    );
    println!();
    
    // Count vowels and words
    println!(
        "count_vowels(\"Hello World\") = {}",
        count_vowels("Hello World")
    );
    println!(
        "count_words(\"This is a test\") = {}",
        count_words("This is a test")
    );
    println!();
    
    // Case conversion
    println!(
        "to_camel_case(\"hello world\") = \"{}\"",
        to_camel_case("hello world")
    );
    println!(
        "to_snake_case(\"helloWorld\") = \"{}\"",
        to_snake_case("helloWorld")
    );
    println!();
    
    // String rotation
    println!(
        "string_rotation(\"waterbottle\", \"erbottlewat\") = {}",
        string_rotation("waterbottle", "erbottlewat")
    );
    println!();
    
    // Run-length encoding
    let encoded = run_length_encoding("aaabbbccc");
    println!("run_length_encoding(\"aaabbbccc\") = \"{}\"", encoded);
    println!(
        "run_length_decoding(\"{}\") = \"{}\"",
        encoded,
        run_length_decoding(&encoded)
    );
    println!();
    
    // Permutations (show first few)
    let perms = permutations("abc");
    println!("permutations(\"abc\") = {:?}", &perms[..3.min(perms.len())]);
    println!();
    
    // First non-repeating character
    println!(
        "first_non_repeating(\"aab\") = {:?}",
        first_non_repeating("aab")
    );
    println!(
        "first_non_repeating(\"abc\") = {:?}",
        first_non_repeating("abc")
    );
    println!();
    
    // One edit distance
    println!(
        "one_edit_distance(\"cat\", \"cat\") = {}",
        one_edit_distance("cat", "cat")
    );
    println!(
        "one_edit_distance(\"cat\", \"cats\") = {}",
        one_edit_distance("cat", "cats")
    );
}