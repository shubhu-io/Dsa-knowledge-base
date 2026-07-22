# Codeforces Problem Tags

## Overview

Codeforces organizes problems by tags representing the algorithmic techniques required. Understanding these tags is crucial for targeted practice and improving specific skills.

## Problem Difficulty Rating

| Rating | Difficulty | Recommended For |
|--------|------------|-----------------|
| 800 | Very Easy | Absolute beginners |
| 900 | Easy | Newbies starting out |
| 1000 | Easy+ | Newbies |
| 1100 | Medium- | Pupils |
| 1200 | Medium | Pupils |
| 1300 | Medium+ | Specialists |
| 1400 | Hard- | Specialists |
| 1500 | Hard | Experts |
| 1600 | Very Hard | Experts |
| 1700-1900 | Expert | CM level |
| 2000-2400 | Master | Master level |
| 2500+ | Grandmaster | GM level |

## Core Tags (Must Know)

### Implementation
**Rating: 800-1000**
- Basic problem solving with code
- Input/output handling
- Simple logic and conditions
- Loop and array manipulation

**Key Skills**:
- Reading input efficiently
- Following problem instructions exactly
- Testing with given examples

---

### Math
**Rating: 800-1900+**
- Number theory
- Combinatorics
- Probability
- Linear algebra
- Geometry

**Common Topics**:
- GCD, LCM, modular arithmetic
- Prime numbers, sieve of Eratosthenes
- Combinations, permutations
- Matrix exponentiation
- Convex hull, polygon area

---

### Greedy Algorithms
**Rating: 900-1800+**
- Make locally optimal choices
- Prove correctness or use intuition
- Often combined with sorting

**Common Patterns**:
- Activity selection
- Huffman coding
- Kruskal's MST
- Interval scheduling

---

### Dynamic Programming
**Rating: 1100-2400+**
- Optimization problems
- Overlapping subproblems
- Optimal substructure

**Difficulty Progression**:
- 1100-1300: Basic 1D DP
- 1300-1600: 2D DP, knapsack variants
- 1600-1900: DP on trees, bitmask DP
- 1900-2400: Advanced DP optimizations

---

### Data Structures
**Rating: 1000-2500+**
- Arrays, stacks, queues
- Trees, heaps
- Union-Find
- Segment trees, BIT
- Sparse tables

**Difficulty Progression**:
- 1000-1200: Arrays, stacks, queues
- 1200-1500: Sets, maps, heaps
- 1500-1800: Segment trees, BIT
- 1800+: Advanced structures

---

### Graphs
**Rating: 1100-2500+**
- Traversal (BFS, DFS)
- Shortest paths
- Trees and spanning forests
- Network flow
- Matching

**Common Algorithms**:
- BFS/DFS traversal
- Dijkstra, Bellman-Ford, Floyd
- Topological sort
- Tarjan's SCC
- Min-cost max-flow

---

### Strings
**Rating: 1000-2200+**
- String manipulation
- Pattern matching
- String hashing
- Trie
- Suffix arrays

**Difficulty Progression**:
- 1000-1200: Basic string ops
- 1200-1500: KMP, Z-algorithm
- 1500-1800: String hashing, Trie
- 1800+: Suffix automaton, palindromes

---

### Binary Search
**Rating: 1000-1800+**
- Search on answer
- Binary search on sorted data
- Ternary search

**Common Applications**:
- Find minimum/maximum value
- Check feasibility
- Optimize function

## Advanced Tags

### Bitmasks
**Rating: 1300-2200+**
- Bit manipulation
- Subset enumeration
- DP with bitmasks
- Speed tricks

**Common Patterns**:
- Iterate all subsets: `for(int mask = 0; mask < (1<<n); mask++)`
- Check bit: `(mask >> i) & 1`
- Set bit: `mask | (1 << i)`
- Clear bit: `mask & ~(1 << i)`

---

### Divide and Conquer
**Rating: 1400-2100+**
- Split problem into subproblems
- Solve recursively
- Combine results

**Applications**:
- Merge sort, quicksort
- Closest pair of points
- Counting inversions
- CDQ divide and conquer

---

### Constructive Algorithms
**Rating: 1000-2000+**
- Build a valid solution
- Often requires insight
- Output any valid answer

**Common Types**:
- Array construction
- Game theory constructions
- Graph constructions

---

### Combinatorics
**Rating: 1200-2200+**
- Counting techniques
- Inclusion-exclusion
- Catalan numbers
- Burnside's lemma

---

### Number Theory
**Rating: 1300-2400+**
- Prime numbers
- Modular arithmetic
- Euler's totient
- Chinese Remainder Theorem
- Matrix exponentiation

---

### Geometry
**Rating: 1600-2500+**
- Point, line, vector operations
- Convex hull
- Polygon operations
- Rotating calipers
- Half-plane intersection

## Tag-Based Practice Strategy

### By Target Rating

**Target: Pupil (1200)**
Focus on:
- Implementation (800-1000)
- Math basics (800-1100)
- Brute force (800-1000)
- Simple greedy (900-1100)

**Target: Specialist (1400)**
Add:
- Binary search (1000-1200)
- Basic DP (1100-1300)
- Simple graphs (1100-1300)
- String basics (1000-1200)

**Target: Expert (1600)**
Add:
- Advanced DP (1300-1600)
- Graph algorithms (1300-1600)
- Data structures (1300-1600)
- Bitmasks (1300-1500)

**Target: CM (1900)**
Add:
- Advanced data structures (1600-1900)
- Heavy DP (1600-1900)
- Advanced graphs (1600-1900)
- String algorithms (1500-1900)

### Practice Method

1. **Filter by tag and rating** on the problemset page
2. **Solve 10-20 problems** at your target rating
3. **Move to next rating level** once comfortable
4. **Mix tags** to avoid pattern fatigue
5. **Revisit weak tags** periodically

## Common Tag Combinations

| Problem Type | Tags Often Combined |
|--------------|---------------------|
| Graph + DP | DP on trees, DAG shortest paths |
| Math + Combinatorics | Counting problems, probability |
| Greedy + Sorting | Interval problems, optimization |
| Binary Search + DP | Optimization problems |
| String + DP | Edit distance, LCS |
| Bitmask + DP | State compression DP |
| Graph + Binary Search | Binary search on answer in graphs |

## Tips for Tag Mastery

1. **Don't skip any core tag**: All are essential
2. **Master basics first**: Implementation, Math, Greedy
3. **Learn templates**: Have code templates for each structure
4. **Practice under pressure**: Virtual contests
5. **Read editorials**: Learn from problems you couldn't solve
6. **Track weak areas**: Note which tags you struggle with
7. **Revisit periodically**: Spaced repetition works
