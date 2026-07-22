<?php

/*
Problem: Two Sum
Description: Find two indices in an array whose values sum to a target.

Approach:
- Use a hash map to store complement values and their indices
- For each element, check if the complement (target - num) exists in map
- Return both indices if found

Time Complexity: O(n)
Space Complexity: O(n)

Example:
Input:  nums = [2, 7, 11, 15], target = 9
Output: [0, 1]
*/

function twoSum(array $nums, int $target): array {
    $map = [];
    foreach ($nums as $i => $num) {
        $complement = $target - $num;
        if (array_key_exists($complement, $map)) {
            return [$map[$complement], $i];
        }
        $map[$num] = $i;
    }
    return [];
}

$nums = [2, 7, 11, 15];
$target = 9;
$result = twoSum($nums, $target);
echo "Indices: [" . implode(", ", $result) . "]\n";
