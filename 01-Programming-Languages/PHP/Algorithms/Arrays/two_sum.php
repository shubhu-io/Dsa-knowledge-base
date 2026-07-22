<?php
function twoSum(array $nums, int $target): ?array {
    $numMap = [];

    foreach ($nums as $i => $num) {
        $complement = $target - $num;
        if (array_key_exists($complement, $numMap)) {
            return [$numMap[$complement], $i];
        }
        $numMap[$num] = $i;
    }

    return null;
}

$nums = [2, 7, 11, 15];
$target = 9;
$result = twoSum($nums, $target);

if ($result) {
    echo "Indices: [" . implode(", ", $result) . "]\n";
} else {
    echo "No solution found\n";
}
?>