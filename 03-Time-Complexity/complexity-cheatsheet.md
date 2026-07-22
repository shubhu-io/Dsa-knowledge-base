# Complexity Cheatsheet

Quick reference for time and space complexities of common algorithms and data structures.

## Complexity Growth Rates

```
n:       1    10     100     1,000    10,000    100,000
──────────────────────────────────────────────────────────
O(1)      1      1        1         1         1         1
O(log n)  0      3        7        10        13        17
O(n)      1     10      100     1,000    10,000   100,000
O(n log n) 0    33      664    10,000   133,000  1,660,000
O(n^2)    1    100   10,000 1,000,000       -         -
O(n^3)    1  1,000 1,000,000       -         -         -
O(2^n)    2  1,024        -         -         -         -
O(n!)     1      -        -         -         -         -
```

## Algorithm Complexities

### Sorting
| Algorithm | Time (Best) | Time (Avg) | Time (Worst) | Space | Stable |
|-----------|------------|-----------|-------------|-------|--------|
| Bubble | O(n) | O(n^2) | O(n^2) | O(1) | Yes |
| Selection | O(n^2) | O(n^2) | O(n^2) | O(1) | No |
| Insertion | O(n) | O(n^2) | O(n^2) | O(1) | Yes |
| Merge | O(n log n) | O(n log n) | O(n log n) | O(n) | Yes |
| Quick | O(n log n) | O(n log n) | O(n^2) | O(log n) | No |
| Heap | O(n log n) | O(n log n) | O(n log n) | O(1) | No |
| Tim | O(n) | O(n log n) | O(n log n) | O(n) | Yes |
| Counting | O(n+k) | O(n+k) | O(n+k) | O(k) | Yes |
| Radix | O(dn) | O(dn) | O(dn) | O(n+k) | Yes |

### Searching
| Algorithm | Time | Space | Requirement |
|-----------|------|-------|------------|
| Linear | O(n) | O(1) | None |
| Binary | O(log n) | O(1) | Sorted |
| Ternary | O(log n) | O(1) | Sorted |
| Jump | O(√n) | O(1) | Sorted |
| Interpolation | O(log log n) | O(1) | Sorted + Uniform |

### Graph Algorithms
| Algorithm | Time | Space | Use Case |
|-----------|------|-------|----------|
| BFS | O(V+E) | O(V) | Shortest path (unweighted) |
| DFS | O(V+E) | O(V) | Exploration, cycle detection |
| Dijkstra | O((V+E) log V) | O(V) | Shortest path (non-negative weights) |
| Bellman-Ford | O(VE) | O(V) | Shortest path (negative weights) |
| Floyd-Warshall | O(V^3) | O(V^2) | All pairs shortest path |
| Kruskal's | O(E log E) | O(V) | MST |
| Prim's | O(E log V) | O(V) | MST |
| Topological Sort | O(V+E) | O(V) | Dependency ordering |

### Dynamic Programming
| Problem | Time | Space | Optimized Space |
|---------|------|-------|----------------|
| Fibonacci | O(n) | O(n) | O(1) |
| Climbing Stairs | O(n) | O(n) | O(1) |
| Coin Change | O(n*amount) | O(amount) | O(amount) |
| 0/1 Knapsack | O(n*W) | O(n*W) | O(W) |
| LCS | O(mn) | O(mn) | O(min(m,n)) |
| Edit Distance | O(mn) | O(mn) | O(min(m,n)) |

### Tree Operations
| Operation | Balanced BST | Heap | Array-based Heap |
|-----------|-------------|------|-----------------|
| Search | O(log n) | O(n) | O(n) |
| Insert | O(log n) | O(log n) | O(1)* |
| Delete | O(log n) | O(log n) | O(log n) |
| Find Min | O(log n) | O(1) | O(1) |
| Find Max | O(log n) | O(n) | O(n) |
| Traversal | O(n) | O(n) | O(n) |

*Amortized

## Data Structure Complexities

| Structure | Access | Search | Insert | Delete | Space |
|-----------|--------|--------|--------|--------|-------|
| Array | O(1) | O(n) | O(n) | O(n) | O(n) |
| Dynamic Array | O(1) | O(n) | O(1)* | O(n) | O(n) |
| Linked List | O(n) | O(n) | O(1) | O(1) | O(n) |
| Doubly Linked | O(n) | O(n) | O(1) | O(1) | O(n) |
| Stack | O(n) | O(n) | O(1) | O(1) | O(n) |
| Queue | O(n) | O(n) | O(1) | O(1) | O(n) |
| Hash Table | - | O(1)* | O(1)* | O(1)* | O(n) |
| BST | O(log n) | O(log n) | O(log n) | O(log n) | O(n) |
| AVL Tree | O(log n) | O(log n) | O(log n) | O(log n) | O(n) |
| Red-Black | O(log n) | O(log n) | O(log n) | O(log n) | O(n) |
| B-Tree | O(log n) | O(log n) | O(log n) | O(log n) | O(n) |
| Heap | O(n) | O(n) | O(log n) | O(log n) | O(n) |
| Min-Heap | O(n) | O(n) | O(log n) | O(log n) | O(n) |
| Trie | O(L) | O(L) | O(L) | O(L) | O(ALPHABET * N * L) |
| Union-Find | - | O(α(n)) | O(α(n)) | O(α(n)) | O(n) |

*Amortized; α = inverse Ackermann function (nearly constant)

## Space Complexities

| Structure | Space | Notes |
|-----------|-------|-------|
| Integer | 4-8 bytes | 32 or 64 bit |
| Float | 4-8 bytes | 32 or 64 bit |
| Boolean | 1 byte | |
| Pointer | 4-8 bytes | 32 or 64 bit |
| String | O(L) | L = length |
| Array | O(n) | n elements |
| Matrix (n x n) | O(n^2) | |
| Linked List | O(n) | + pointer overhead |
| Hash Table | O(n) | Load factor overhead |
| Binary Tree | O(n) | |
| Graph (adj list) | O(V+E) | |
| Graph (adj matrix) | O(V^2) | |

## Recurrence Relations Cheat Sheet

| Recurrence | Solution | Example |
|-----------|----------|---------|
| T(n) = T(n-1) + O(1) | O(n) | Linear recursion |
| T(n) = T(n-1) + O(n) | O(n^2) | Selection sort |
| T(n) = 2T(n-1) + O(1) | O(2^n) | Towers of Hanoi |
| T(n) = T(n/2) + O(1) | O(log n) | Binary search |
| T(n) = T(n/2) + O(n) | O(n) | Median finding |
| T(n) = 2T(n/2) + O(1) | O(n) | Tree traversal |
| T(n) = 2T(n/2) + O(n) | O(n log n) | Merge sort |
| T(n) = 2T(n/2) + O(n^2) | O(n^2) | - |
| T(n) = T(n/4) + T(3n/4) + O(n) | O(n) | - |

## Master Theorem

For T(n) = aT(n/b) + O(n^d):

```
Case 1: log_b(a) > d  =>  O(n^log_b(a))
Case 2: log_b(a) = d  =>  O(n^d * log n)
Case 3: log_b(a) < d  =>  O(n^d)
```

## Competitive Programming Guidelines

| n | Allowed Complexity | Common Techniques |
|---|-------------------|-------------------|
| 10 | O(n!) | Brute force, permutations |
| 20 | O(2^n * n) | Bitmask DP |
| 50 | O(n^3) | Floyd-Warshall, 3D DP |
| 500 | O(n^3) | Matrix DP |
| 5,000 | O(n^2) | 2D DP, nested loops |
| 10^5 | O(n log n) | Sorting, segment trees |
| 10^6 | O(n) | Linear scan, two pointers |
| 10^8 | O(n) | Single pass |
| 10^9+ | O(log n) | Binary search, math |

## LeetCode Time Limits (Approximate)

| Complexity | Max n for 1 sec |
|-----------|-----------------|
| O(n) | 10^8 |
| O(n log n) | 10^6 |
| O(n^2) | 10^4 |
| O(n^3) | 500 |
| O(2^n) | 20-25 |
| O(n!) | 10-12 |

## Memory Quick Reference

```
1 KB    = 1,024 bytes
1 MB    = 1,024 KB
1 GB    = 1,024 MB

Typical sizes:
  int array[1000]       =  ~4 KB
  int matrix[1000][1000] = ~4 MB
  char string[1000]     =  ~1 KB
  Python int            =  28 bytes
  Python list[int]      =  8n bytes (pointers) + 28n bytes (int objects)
  Python dict           =  ~50n bytes overhead
```

## Python-Specific Complexities

| Operation | Time | Notes |
|-----------|------|-------|
| `list.append()` | O(1)* | Amortized |
| `list.insert(0, x)` | O(n) | Shifts all elements |
| `list.pop(0)` | O(n) | Shifts all elements |
| `list.pop()` | O(1) | Last element |
| `dict[key]` | O(1)* | Average case |
| `set.add()` | O(1)* | Average case |
| `in` (list) | O(n) | Linear scan |
| `in` (set/dict) | O(1)* | Hash lookup |
| `sorted()` | O(n log n) | Timsort |
| `str.join()` | O(n) | Preferred over += |
| `heapq.heappush` | O(log n) | |
| `collections.deque.append` | O(1) | Both ends |

*Amortized average case

## Quick Tips

1. **Always analyze both time AND space**
2. **Consider best, average, AND worst case**
3. **Constants matter in practice** — O(100n) vs O(n^2): n < 100, linear is faster
4. **Cache locality matters** — Arrays often faster than linked structures
5. **Hash tables have worst case O(n)** — But O(1) with good hash functions
6. **Recursion uses stack space** — Consider converting to iteration
7. **Python is slow** — For competitive programming, prefer C++/Java
8. **Profile before optimizing** — Don't optimize what you haven't measured
