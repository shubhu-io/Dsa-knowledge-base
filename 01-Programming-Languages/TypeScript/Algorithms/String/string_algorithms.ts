// String algorithms in TypeScript with proper typing.
// This file demonstrates common string manipulation algorithms using TypeScript's
// type system for better code safety and documentation.

// Check if a string reads the same forwards and backwards
// Time complexity: O(n), Space complexity: O(n) for the cleaned string
function isPalindrome(s: string): boolean {
    // Convert to lowercase and keep only alphanumeric characters
    const cleaned = s
        .toLowerCase()
        .replace(/[^a-z0-9]/g, '');
    
    // Compare with reversed string
    const reversed = cleaned.split('').reverse().join('');
    return cleaned === reversed;
}

// Check if two strings are anagrams of each other
// Time complexity: O(n), Space complexity: O(1) for fixed character set
function isAnagram(s1: string, s2: string): boolean {
    // Convert to lowercase and remove spaces
    const normalize = (s: string): string =>
        s.toLowerCase().replace(/\s/g, '');
    
    const normalized1 = normalize(s1);
    const normalized2 = normalize(s2);
    
    if (normalized1.length !== normalized2.length) {
        return false;
    }
    
    // Count character frequencies
    const freq: Record<string, number> = {};
    
    for (const char of normalized1) {
        freq[char] = (freq[char] || 0) + 1;
    }
    
    for (const char of normalized2) {
        freq[char] = (freq[char] || 0) - 1;
        if (freq[char] < 0) {
            return false;
        }
    }
    
    return true;
}

// Reverse a string
// Time complexity: O(n), Space complexity: O(n)
function reverseString(s: string): string {
    return s.split('').reverse().join('');
}

// Find the longest common substring between two strings
// Time complexity: O(m*n), Space complexity: O(m*n)
function longestCommonSubstring(s1: string, s2: string): string {
    if (s1.length === 0 || s2.length === 0) {
        return '';
    }
    
    // Create DP table
    const dp: number[][] = Array(s1.length + 1)
        .fill(null)
        .map(() => Array(s2.length + 1).fill(0));
    
    let maxLen = 0;
    let endPos = 0;
    
    // Fill DP table
    for (let i = 1; i <= s1.length; i++) {
        for (let j = 1; j <= s2.length; j++) {
            if (s1[i - 1] === s2[j - 1]) {
                dp[i][j] = dp[i - 1][j - 1] + 1;
                if (dp[i][j] > maxLen) {
                    maxLen = dp[i][j];
                    endPos = i;
                }
            }
        }
    }
    
    return s1.substring(endPos - maxLen, endPos);
}

// Find the longest common prefix among an array of strings
// Time complexity: O(S) where S is the sum of all characters, Space complexity: O(1)
function longestCommonPrefix(strs: string[]): string {
    if (strs.length === 0) {
        return '';
    }
    
    let prefix = strs[0];
    
    for (let i = 1; i < strs.length; i++) {
        // Reduce prefix until it matches the start of strs[i]
        while (!strs[i].startsWith(prefix)) {
            prefix = prefix.slice(0, -1);
            if (prefix === '') {
                return '';
            }
        }
    }
    
    return prefix;
}

// Count the number of vowels in a string
// Time complexity: O(n), Space complexity: O(1)
function countVowels(s: string): number {
    const vowels = new Set(['a', 'e', 'i', 'o', 'u']);
    return s
        .toLowerCase()
        .split('')
        .filter(char => vowels.has(char))
        .length;
}

// Count the number of words in a string
// Time complexity: O(n), Space complexity: O(1)
function countWords(s: string): number {
    return s.split(/\s+/).filter(word => word.length > 0).length;
}

// Convert a string to camelCase
// Time complexity: O(n), Space complexity: O(n)
function toCamelCase(s: string): string {
    const words = s
        .split(/[^a-zA-Z0-9]+/)
        .filter(word => word.length > 0);
    
    if (words.length === 0) {
        return '';
    }
    
    return words
        .map((word, index) => {
            const lower = word.toLowerCase();
            if (index === 0) {
                return lower;
            }
            return lower.charAt(0).toUpperCase() + lower.slice(1);
        })
        .join('');
}

// Convert a string to snake_case
// Time complexity: O(n), Space complexity: O(n)
function toSnakeCase(s: string): string {
    return s
        .replace(/([A-Z])/g, '_$1')
        .toLowerCase()
        .replace(/^_/, '')
        .replace(/_+/g, '_');
}

// Check if one string is a rotation of another
// Time complexity: O(n), Space complexity: O(n)
function stringRotation(s1: string, s2: string): boolean {
    if (s1.length !== s2.length) {
        return false;
    }
    // Concatenate s1 with itself and check if s2 is a substring
    const combined = s1 + s1;
    return combined.includes(s2);
}

// Apply run-length encoding to a string
// Time complexity: O(n), Space complexity: O(n)
function runLengthEncoding(s: string): string {
    if (s.length === 0) {
        return '';
    }
    
    let result = '';
    let count = 1;
    
    for (let i = 1; i <= s.length; i++) {
        if (i < s.length && s[i] === s[i - 1]) {
            count++;
        } else {
            result += s[i - 1];
            if (count > 1) {
                result += count.toString();
            }
            count = 1;
        }
    }
    
    return result;
}

// Decode a run-length encoded string
// Time complexity: O(n), Space complexity: O(n)
function runLengthDecoding(s: string): string {
    let result = '';
    let i = 0;
    
    while (i < s.length) {
        const char = s[i];
        i++;
        
        // Read the count
        let count = 0;
        while (i < s.length && s[i] >= '0' && s[i] <= '9') {
            count = count * 10 + parseInt(s[i]);
            i++;
        }
        
        // Append character count times
        if (count === 0) {
            count = 1;
        }
        result += char.repeat(count);
    }
    
    return result;
}

// Find all permutations of a string (for demonstration)
// Time complexity: O(n!), Space complexity: O(n!)
function permutations(s: string): string[] {
    const result: string[] = [];
    
    function permute(chars: string[], start: number): void {
        if (start >= chars.length) {
            result.push(chars.join(''));
            return;
        }
        
        for (let i = start; i < chars.length; i++) {
            [chars[start], chars[i]] = [chars[i], chars[start]];
            permute(chars, start + 1);
            [chars[start], chars[i]] = [chars[i], chars[start]]; // Backtrack
        }
    }
    
    permute(s.split(''), 0);
    return result;
}

// Check if two strings are one edit distance apart
// Time complexity: O(n), Space complexity: O(1)
function oneEditDistance(s1: string, s2: string): boolean {
    const len1 = s1.length;
    const len2 = s2.length;
    
    if (Math.abs(len1 - len2) > 1) {
        return false;
    }
    
    const [shorter, longer] = len1 <= len2 ? [s1, s2] : [s2, s1];
    
    let foundDifference = false;
    let i = 0;
    let j = 0;
    
    while (i < shorter.length && j < longer.length) {
        if (shorter[i] !== longer[j]) {
            if (foundDifference) {
                return false;
            }
            foundDifference = true;
            
            if (shorter.length === longer.length) {
                i++;
            }
        } else {
            i++;
        }
        j++;
    }
    
    return true;
}

// Find the first non-repeating character in a string
// Time complexity: O(n), Space complexity: O(1) for fixed character set
function firstNonRepeating(s: string): string | null {
    const freq: Record<string, number> = {};
    
    // Count frequencies
    for (const char of s) {
        freq[char] = (freq[char] || 0) + 1;
    }
    
    // Find first character with count 1
    for (const char of s) {
        if (freq[char] === 1) {
            return char;
        }
    }
    
    return null;
}

// Check if a string is a valid palindrome after removing non-alphanumeric characters
// Time complexity: O(n), Space complexity: O(n)
function isValidPalindrome(s: string): boolean {
    const cleaned = s.replace(/[^a-zA-Z0-9]/g, '').toLowerCase();
    return cleaned === cleaned.split('').reverse().join('');
}

// Find the longest palindromic substring
// Time complexity: O(n^2), Space complexity: O(1)
function longestPalindromicSubstring(s: string): string {
    if (s.length === 0) return '';
    
    let start = 0;
    let maxLength = 1;
    
    function expandAroundCenter(left: number, right: number): void {
        while (left >= 0 && right < s.length && s[left] === s[right]) {
            if (right - left + 1 > maxLength) {
                start = left;
                maxLength = right - left + 1;
            }
            left--;
            right++;
        }
    }
    
    for (let i = 0; i < s.length; i++) {
        expandAroundCenter(i, i);     // Odd length
        expandAroundCenter(i, i + 1); // Even length
    }
    
    return s.substring(start, start + maxLength);
}

// Main function to demonstrate all algorithms
function main(): void {
    console.log('=== String Algorithms in TypeScript ===');
    console.log();
    
    // Palindrome check
    const palindromeTests = ['racecar', 'A man a plan a canal Panama', 'hello'];
    for (const test of palindromeTests) {
        console.log(`isPalindrome("${test}") = ${isPalindrome(test)}`);
    }
    console.log();
    
    // Anagram check
    console.log(`isAnagram("listen", "silent") = ${isAnagram('listen', 'silent')}`);
    console.log(`isAnagram("hello", "world") = ${isAnagram('hello', 'world')}`);
    console.log();
    
    // String reversal
    console.log(`reverseString("hello") = "${reverseString('hello')}"`);
    console.log(`reverseString("racecar") = "${reverseString('racecar')}"`);
    console.log();
    
    // Longest common substring
    console.log(
        `longestCommonSubstring("abcdef", "bcdefg") = "${longestCommonSubstring('abcdef', 'bcdefg')}"`
    );
    console.log();
    
    // Longest common prefix
    console.log(
        `longestCommonPrefix(["flower", "flow", "flight"]) = "${longestCommonPrefix([
            'flower',
            'flow',
            'flight',
        ])}"`
    );
    console.log();
    
    // Count vowels and words
    console.log(`countVowels("Hello World") = ${countVowels('Hello World')}`);
    console.log(`countWords("This is a test") = ${countWords('This is a test')}`);
    console.log();
    
    // Case conversion
    console.log(`toCamelCase("hello world") = "${toCamelCase('hello world')}"`);
    console.log(`toSnakeCase("helloWorld") = "${toSnakeCase('helloWorld')}"`);
    console.log();
    
    // String rotation
    console.log(
        `stringRotation("waterbottle", "erbottlewat") = ${stringRotation('waterbottle', 'erbottlewat')}`
    );
    console.log();
    
    // Run-length encoding
    const encoded = runLengthEncoding('aaabbbccc');
    console.log(`runLengthEncoding("aaabbbccc") = "${encoded}"`);
    console.log(`runLengthDecoding("${encoded}") = "${runLengthDecoding(encoded)}"`);
    console.log();
    
    // Permutations (show first few)
    const perms = permutations('abc');
    console.log(`permutations("abc") = [${perms.slice(0, 3).map(p => `"${p}"`).join(', ')}...]`);
    console.log();
    
    // First non-repeating character
    console.log(`firstNonRepeating("aab") = ${firstNonRepeating('aab')}`);
    console.log(`firstNonRepeating("abc") = ${firstNonRepeating('abc')}`);
    console.log();
    
    // One edit distance
    console.log(`oneEditDistance("cat", "cat") = ${oneEditDistance('cat', 'cat')}`);
    console.log(`oneEditDistance("cat", "cats") = ${oneEditDistance('cat', 'cats')}`);
    console.log();
    
    // Longest palindromic substring
    console.log(
        `longestPalindromicSubstring("babad") = "${longestPalindromicSubstring('babad')}"`
    );
}

// Run the demonstration
main();