<?php

/*
Problem: Valid Parentheses
Description: Determine if a string of brackets is valid (every opening bracket has a matching closing bracket in correct order).

Approach:
- Use a stack to track opening brackets
- For each closing bracket, check it matches the top of the stack
- At the end, stack must be empty

Time Complexity: O(n)
Space Complexity: O(n)

Example:
Input:  "()[]{}"
Output: true

Input:  "(]"
Output: false
*/

function isValid(string $s): bool {
    $stack = [];
    $map = [')' => '(', ']' => '[', '}' => '{'];
    for ($i = 0; $i < strlen($s); $i++) {
        $ch = $s[$i];
        if (isset($map[$ch])) {
            $top = array_pop($stack) ?? '#';
            if ($top !== $map[$ch]) return false;
        } else {
            $stack[] = $ch;
        }
    }
    return empty($stack);
}

$tests = ["()[]{}", "(]", "([)]", "{[]}"];
foreach ($tests as $s) {
    $res = isValid($s) ? "true" : "false";
    echo "\"$s\" -> $res\n";
}
