<?php

/*
Problem: Valid Palindrome
Description: Check if a string reads the same forwards and backwards.

Approach:
- Use two pointers, one from start and one from end
- Compare characters while moving inward
- If all match, it's a palindrome

Time Complexity: O(n)
Space Complexity: O(1)

Example:
Input:  "racecar"
Output: true

Input:  "hello"
Output: false
*/

function isPalindrome(string $s): bool {
    $left = 0;
    $right = strlen($s) - 1;
    while ($left < $right) {
        if ($s[$left] !== $s[$right]) return false;
        $left++;
        $right--;
    }
    return true;
}

$tests = ["racecar", "hello", "madam", "php"];
foreach ($tests as $s) {
    $res = isPalindrome($s) ? "true" : "false";
    echo "\"$s\" -> $res\n";
}
