# LeetCode Top Interview Questions

## Overview

This document lists the most frequently asked interview questions organized by topic. These problems have appeared repeatedly in interviews at Google, Amazon, Meta, Microsoft, Apple, and other top tech companies.

## Arrays & Hashing (10 Problems)

| # | Problem | Difficulty | Key Concept |
|---|---------|------------|-------------|
| 1 | Two Sum | Easy | HashMap lookup |
| 49 | Group Anagrams | Medium | Sorted key mapping |
| 128 | Longest Consecutive Sequence | Medium | HashSet for O(1) lookup |
| 238 | Product of Array Except Self | Medium | Prefix/suffix products |
| 347 | Top K Frequent Elements | Medium | Bucket sort or heap |
| 560 | Subarray Sum Equals K | Medium | Prefix sum + hashmap |
| 1 | Two Sum | Easy | Hash map complement |
| 217 | Contains Duplicate | Easy | HashSet |
| 242 | Valid Anagram | Easy | Character counting |
| 75 | Sort Colors | Medium | Dutch National Flag |

## Two Pointers (7 Problems)

| # | Problem | Difficulty | Key Concept |
|---|---------|------------|-------------|
| 15 | 3Sum | Medium | Sort + two pointers |
| 11 | Container With Most Water | Medium | Greedy pointer movement |
| 42 | Trapping Rain Water | Hard | Two pointer water calculation |
| 125 | Valid Palindrome | Easy | Skip non-alphanumeric |
| 167 | Two Sum II | Medium | Sorted array two pointers |
| 344 | Reverse String | Easy | In-place swap |
| 977 | Squares of a Sorted Array | Easy | Two pointer from ends |

## Sliding Window (6 Problems)

| # | Problem | Difficulty | Key Concept |
|---|---------|------------|-------------|
| 3 | Longest Substring Without Repeating Characters | Medium | Character frequency map |
| 424 | Longest Repeating Character Replacement | Medium | Window + max frequency |
| 76 | Minimum Window Substring | Hard | Dynamic window shrinking |
| 239 | Sliding Window Maximum | Hard | Monotonic deque |
| 567 | Permutation in String | Medium | Fixed window comparison |
| 209 | Minimum Size Subarray Sum | Medium | Variable window |

## Stack (7 Problems)

| # | Problem | Difficulty | Key Concept |
|---|---------|------------|-------------|
| 20 | Valid Parentheses | Easy | Stack matching |
| 155 | Min Stack | Medium | Auxiliary stack |
| 394 | Decode String | Medium | Nested stack parsing |
| 739 | Daily Temperatures | Medium | Monotonic stack |
| 853 | Car Fleet | Medium | Sort + stack |
| 84 | Largest Rectangle in Histogram | Hard | Monotonic stack |
| 42 | Trapping Rain Water | Hard | Stack or two pointers |

## Binary Search (6 Problems)

| # | Problem | Difficulty | Key Concept |
|---|---------|------------|-------------|
| 704 | Binary Search | Easy | Standard binary search |
| 33 | Search in Rotated Sorted Array | Medium | Modified binary search |
| 153 | Find Minimum in Rotated Sorted Array | Medium | Binary search on rotated |
| 4 | Median of Two Sorted Arrays | Hard | Binary search on partition |
| 981 | Time Based Key-Value Store | Medium | Binary search on timestamps |
| 875 | Koko Eating Bananas | Medium | Binary search on answer |

## Linked List (11 Problems)

| # | Problem | Difficulty | Key Concept |
|---|---------|------------|-------------|
| 160 | Intersection of Two Linked Lists | Easy | Two pointer technique |
| 206 | Reverse Linked List | Easy | Iterative pointer manipulation |
| 21 | Merge Two Sorted Lists | Easy | Dummy head technique |
| 141 | Linked List Cycle | Easy | Floyd's cycle detection |
| 2 | Add Two Numbers | Medium | Carry propagation |
| 19 | Remove Nth Node From End | Medium | Two pointer gap |
| 24 | Swap Nodes in Pairs | Medium | Recursive or iterative |
| 25 | Reverse Nodes in k-Group | Hard | Reverse in chunks |
| 138 | Copy List with Random Pointer | Medium | Interleaving or hashmap |
| 146 | LRU Cache | Medium | Doubly linked list + hashmap |
| 23 | Merge k Sorted Lists | Hard | Divide and conquer or heap |

## Trees (12 Problems)

| # | Problem | Difficulty | Key Concept |
|---|---------|------------|-------------|
| 104 | Maximum Depth of Binary Tree | Easy | Simple DFS/BFS |
| 100 | Same Tree | Easy | Recursive comparison |
| 226 | Invert Binary Tree | Easy | Recursive swap |
| 101 | Symmetric Tree | Easy | Mirror comparison |
| 543 | Diameter of Binary Tree | Easy | DFS height tracking |
| 102 | Binary Tree Level Order Traversal | Medium | BFS level processing |
| 98 | Validate Binary Search Tree | Medium | In-order with bounds |
| 230 | Kth Smallest Element in BST | Medium | In-order traversal |
| 114 | Flatten Binary Tree to Linked List | Medium | Reverse pre-order |
| 236 | Lowest Common Ancestor | Medium | Recursive LCA |
| 297 | Serialize and Deserialize Binary Tree | Hard | BFS or DFS encoding |
| 124 | Binary Tree Maximum Path Sum | Hard | DFS with global max |

## Graphs (10 Problems)

| # | Problem | Difficulty | Key Concept |
|---|---------|------------|-------------|
| 200 | Number of Islands | Medium | DFS/BFS flood fill |
| 133 | Clone Graph | Medium | BFS/DFS + hashmap |
| 207 | Course Schedule | Medium | Topological sort |
| 695 | Max Area of Island | Medium | DFS with area counting |
| 417 | Pacific Atlantic Water Flow | Medium | Multi-source BFS |
| 130 | Surrounded Regions | Medium | Boundary DFS/BFS |
| 743 | Network Delay Time | Medium | Dijkstra's shortest path |
| 210 | Course Schedule II | Medium | Topological order |
| 269 | Alien Dictionary | Hard | Topological sort |
| 787 | Cheapest Flights Within K Stops | Medium | BFS/DFS with pruning |

## Dynamic Programming (12 Problems)

| # | Problem | Difficulty | Key Concept |
|---|---------|------------|-------------|
| 70 | Climbing Stairs | Easy | Fibonacci-like DP |
| 121 | Best Time to Buy and Sell Stock | Easy | Track minimum |
| 53 | Maximum Subarray | Medium | Kadane's algorithm |
| 62 | Unique Paths | Medium | Grid DP |
| 139 | Word Break | Medium | DP + dictionary lookup |
| 300 | Longest Increasing Subsequence | Medium | Patience sorting / DP |
| 152 | Maximum Product Subarray | Medium | Track min and max |
| 322 | Coin Change | Medium | Unbounded knapsack |
| 1143 | Longest Common Subsequence | Medium | 2D DP table |
| 72 | Edit Distance | Medium | 2D DP with operations |
| 198 | House Robber | Medium | Linear DP |
| 312 | Burst Balloons | Hard | Interval DP |

## Backtracking (7 Problems)

| # | Problem | Difficulty | Key Concept |
|---|---------|------------|-------------|
| 78 | Subsets | Medium | Include/exclude pattern |
| 46 | Permutations | Medium | Swap or visited array |
| 39 | Combination Sum | Medium | Backtrack with reuse |
| 22 | Generate Parentheses | Medium | Open/close counters |
| 79 | Word Search | Medium | DFS with backtracking |
| 51 | N-Queens | Hard | Row-by-row placement |
| 17 | Letter Combinations of Phone Number | Medium | Multi-choice backtrack |

## Heap / Priority Queue (7 Problems)

| # | Problem | Difficulty | Key Concept |
|---|---------|------------|-------------|
| 215 | Kth Largest Element | Medium | Quickselect or heap |
| 295 | Find Median from Data Stream | Hard | Two heaps |
| 621 | Task Scheduler | Medium | Greedy + heap |
| 355 | Design Twitter | Medium | Merge k sorted streams |
| 23 | Merge k Sorted Lists | Hard | Min-heap approach |
| 347 | Top K Frequent Elements | Medium | Bucket sort alternative |
| 767 | Reorganize String | Medium | Greedy heap placement |

## Intervals (6 Problems)

| # | Problem | Difficulty | Key Concept |
|---|---------|------------|-------------|
| 57 | Insert Interval | Medium | Merge logic |
| 56 | Merge Intervals | Medium | Sort + merge |
| 435 | Non-overlapping Intervals | Medium | Greedy end time |
| 252 | Meeting Rooms | Easy | Sort and check overlap |
| 253 | Meeting Rooms II | Medium | Min-heap or sweep line |
| 986 | Interval List Intersections | Medium | Two pointer merge |

## Bit Manipulation (7 Problems)

| # | Problem | Difficulty | Key Concept |
|---|---------|------------|-------------|
| 136 | Single Number | Easy | XOR all elements |
| 338 | Counting Bits | Easy | DP with bit tricks |
| 191 | Number of 1 Bits | Easy | Brian Kernighan's |
| 268 | Missing Number | Easy | XOR trick |
| 371 | Sum of Two Integers | Medium | Bit manipulation math |
| 78 | Subsets | Medium | Bit masking |
| 461 | Hamming Distance | Easy | XOR + count bits |

## Solving Strategy for Interviews

### Before the Interview
1. Master these 100+ problems thoroughly
2. Understand the pattern behind each solution
3. Practice explaining your thought process aloud
4. Time yourself (25-35 min per medium, 45+ per hard)

### During the Interview
1. Repeat the problem in your own words
2. Ask clarifying questions about edge cases
3. Start with brute force, then optimize
4. Talk through your approach before coding
5. Test with examples and edge cases

### After Each Problem
1. Note the pattern used
2. Document time/space complexity
3. Write alternative solutions if applicable
4. Add to spaced repetition review system
