# Searching Algorithms Overview

## Introduction
Searching is the process of finding a specific element within a collection of data.

## Linear Search
- Time: O(n)
- Space: O(1)
- Works on: Unsorted data
- Method: Check each element sequentially

## Binary Search
- Time: O(log n)
- Space: O(1) iterative
- Works on: Sorted data
- Method: Divide search interval in half repeatedly

## Hash Table Lookup
- Time: O(1) average
- Space: O(n)
- Works on: Key-value pairs
- Method: Hash key to index

## Binary Search Tree Search
- Time: O(h) where h is height
- Space: O(h) for recursion
- Works on: BST
- Method: Compare with root, go left/right

## Breadth-First Search (BFS)
- Time: O(V + E)
- Space: O(V)
- Works on: Graphs
- Method: Explore neighbors level by level

## Depth-First Search (DFS)
- Time: O(V + E)
- Space: O(V)
- Works on: Graphs
- Method: Explore as far as possible along each branch

## When to Use Which
- Unsorted array, single search: Linear Search
- Sorted array: Binary Search
- Many lookups: Hash Table
- Need ordering: BST
- Graph traversal: BFS or DFS
- String prefix: Trie

## Key Points
- Always consider preprocessing cost
- Consider space vs time tradeoffs
- Test edge cases (empty, single element)
- Watch for off-by-one errors
