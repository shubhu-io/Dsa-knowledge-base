<?php
function mergeSort(array &$arr): void {
    $len = count($arr);
    if ($len <= 1) {
        return;
    }

    $mid = intdiv($len, 2);
    $left = array_slice($arr, 0, $mid);
    $right = array_slice($arr, $mid);

    mergeSort($left);
    mergeSort($right);

    $arr = merge($left, $right);
}

function merge(array $left, array $right): array {
    $result = [];
    $i = $j = 0;

    while ($i < count($left) && $j < count($right)) {
        if ($left[$i] <= $right[$j]) {
            $result[] = $left[$i];
            $i++;
        } else {
            $result[] = $right[$j];
            $j++;
        }
    }

    return array_merge($result, array_slice($left, $i), array_slice($right, $j));
}

$arr = [38, 27, 43, 3, 9, 82, 10];
echo "Original: " . implode(", ", $arr) . "\n";
mergeSort($arr);
echo "Sorted: " . implode(", ", $arr) . "\n";
?>