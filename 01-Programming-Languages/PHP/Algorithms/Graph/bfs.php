<?php

/*
Problem: Breadth-First Search (BFS)
Description: Traverse a graph level by level using a queue.

Approach:
- Use a queue to process nodes FIFO
- Track visited nodes to avoid cycles
- Process all neighbors before moving to next level

Time Complexity: O(V + E)
Space Complexity: O(V)

Example:
Input:  adjacency list: 0->[1,2], 1->[0,3,4], 2->[0], 3->[1], 4->[1], start = 0
Output: 0 1 2 3 4
*/

function bfs(array $graph, int $start): array {
    $visited = array_fill(0, count($graph), false);
    $queue = [$start];
    $visited[$start] = true;
    $result = [];
    while (!empty($queue)) {
        $node = array_shift($queue);
        $result[] = $node;
        foreach ($graph[$node] as $neighbor) {
            if (!$visited[$neighbor]) {
                $visited[$neighbor] = true;
                $queue[] = $neighbor;
            }
        }
    }
    return $result;
}

$graph = [
    [1, 2],
    [0, 3, 4],
    [0],
    [1],
    [1],
];

echo "BFS starting from 0: " . implode(" ", bfs($graph, 0)) . "\n";
