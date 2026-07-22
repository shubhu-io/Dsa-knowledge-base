<?php
function binarySearch(array $arr, int $target): int {
    $left = 0;
    $right = count($arr) - 1;

    while ($left <= $right) {
        $mid = intdiv($left + $right, 2);

        if ($arr[$mid] === $target) {
            return $mid;
        } elseif ($arr[$mid] < $target) {
            $left = $mid + 1;
        } else {
            $right = $mid - 1;
        }
    }

    return -1;
}

$arr = [2, 3, 4, 10, 40];
$target = 10;
$result = binarySearch($arr, $target);

if ($result === -1) {
    echo "Element not found\n";
} else {
    echo "Element found at index $result\n";
}
?>