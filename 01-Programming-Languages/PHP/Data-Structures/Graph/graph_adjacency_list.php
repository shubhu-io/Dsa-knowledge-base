<?php

/*
Problem: Graph Adjacency List
Description: Implement a graph with addEdge, printGraph, and BFS traversal using an adjacency list.

Approach:
- Use an associative array mapping vertices to lists of neighbors
- addEdge adds connection in both directions (undirected)
- printGraph displays all connections

Time Complexity: O(V + E) for traversal
Space Complexity: O(V + E)

Example:
Input:  vertices: [0,1,2,3], edges: [0-1, 0-2, 1-2, 2-3]
Output: adjacency list representation
*/

class Graph {
    private array $adjList;

    public function __construct() {
        $this->adjList = [];
    }

    public function addVertex($v): void {
        if (!isset($this->adjList[$v])) {
            $this->adjList[$v] = [];
        }
    }

    public function addEdge($v1, $v2): void {
        $this->addVertex($v1);
        $this->addVertex($v2);
        $this->adjList[$v1][] = $v2;
        $this->adjList[$v2][] = $v1;
    }

    public function printGraph(): void {
        foreach ($this->adjList as $v => $neighbors) {
            echo "$v -> " . implode(", ", $neighbors) . "\n";
        }
    }

    public function bfs($start): array {
        $visited = [];
        $queue = [$start];
        $visited[$start] = true;
        $result = [];
        while (!empty($queue)) {
            $node = array_shift($queue);
            $result[] = $node;
            foreach ($this->adjList[$node] as $neighbor) {
                if (!isset($visited[$neighbor])) {
                    $visited[$neighbor] = true;
                    $queue[] = $neighbor;
                }
            }
        }
        return $result;
    }
}

$g = new Graph();
$g->addEdge(0, 1);
$g->addEdge(0, 2);
$g->addEdge(1, 2);
$g->addEdge(2, 3);

echo "Adjacency List:\n";
$g->printGraph();

echo "BFS from 0: " . implode(" ", $g->bfs(0)) . "\n";
