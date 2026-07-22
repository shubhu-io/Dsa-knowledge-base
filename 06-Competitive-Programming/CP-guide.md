# Competitive Programming Guide

## Introduction
Competitive programming is a mind sport where participants solve algorithmic problems under time constraints. It combines programming skills, mathematical reasoning, and problem-solving abilities to create efficient solutions.

## Why Practice Competitive Programming?
- Improves problem-solving skills
- Enhances coding proficiency and speed
- Prepares for technical interviews
- Develops algorithmic thinking
- Fun and challenging mental exercise
- Recognition through rankings and ratings

## Getting Started

### Choosing a Language
**C++** is most popular due to:
- STL (Standard Template Library) with powerful data structures
- Fast execution speed
- Familiarity in competitive programming community
- Rich set of algorithms in <algorithm> header

**Java** advantages:
- Built-in BigInteger for large numbers
- Strong typing reduces certain bugs
- Excellent IDE support
- Good for beginners

**Python** benefits:
- Concise syntax
- Easy to learn and write
- Good for learning concepts
- Less verbose code
- Drawback: Slower execution (may need PyPy or optimizations)

### Essential Setup
1. **Code Editor**: VS Code, Vim, Emacs, or Sublime Text
2. **Compiler**: GCC/G++ for C++, JDK for Java, Python interpreter
3. **Testing Tools**: Local testing with custom test cases
4. **Debugging**: GDB for C++, IDE debuggers
5. **Version Control**: Git for tracking solutions

## Core Concepts

### Input/Output Handling
Fast I/O is crucial in competitive programming:

**C++ Fast I/O Template:**
```cpp
#include <bits/stdc++.h>
using namespace std;

// Fast I/O
void fast_io() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);
    cout.tie(nullptr);
}

int main() {
    fast_io();
    // Your code here
    return 0;
}
```

**Java Fast I/O:**
```java
import java.io.*;
import java.util.*;

public class Main {
    static class FastReader {
        BufferedReader br;
        StringTokenizer st;
        
        public FastReader() {
            br = new BufferedReader(new InputStreamReader(System.in));
        }
        
        String next() {
            while (st == null || !st.hasMoreElements()) {
                try {
                    st = new StringTokenizer(br.readLine());
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            return st.nextToken();
        }
        
        int nextInt() {
            return Integer.parseInt(next());
        }
        
        long nextLong() {
            return Long.parseLong(next());
        }
        
        double nextDouble() {
            return Double.parseDouble(next());
        }
        
        String nextLine() {
            String str = "";
            try {
                str = br.readLine();
            } catch (IOException e) {
                e.printStackTrace();
            }
            return str;
        }
    }
    
    public static void main(String[] args) {
        FastReader sc = new FastReader();
        // Use sc.next(), sc.nextInt(), etc.
    }
}
```

### Understanding Problem Statements
Key elements to identify:
- **Input Format**: How data is provided
- **Output Format**: Expected result format
- **Constraints**: Limits on input size, time, memory
- **Sample Tests**: Examples to verify understanding
- **Edge Cases**: Boundary conditions mentioned or implied

### Complexity Analysis
Understanding if your solution will pass:
- **Time Limit**: Usually 1-2 seconds
- **Operations per second**: ~10^8 for C++, ~10^7 for Java/Python
- **Calculate**: Estimate operations based on algorithm
- **Example**: O(n^2) with n=10^5 → 10^10 operations → Too slow

## Fundamental Techniques

### 1. Brute Force with Optimization
Sometimes direct iteration with early termination works:
```cpp
// Example: Find pair with sum X in array
for (int i = 0; i < n; i++) {
    for (int j = i+1; j < n; j++) {
        if (arr[i] + arr[j] == X) {
            // Found solution
            return true;
        }
        // Optimization: break if sum too large (if sorted)
        if (arr[i] + arr[j] > X && /* array sorted */) break;
    }
}
```

### 2. Precomputation
Compute values once and reuse:
```cpp
// Precompute factorials
const int MAXN = 100000;
long long fact[MAXN+1];
void precompute() {
    fact[0] = 1;
    for (int i = 1; i <= MAXN; i++) {
        fact[i] = fact[i-1] * i;
    }
}

// Use in O(1) time
long long nCr(int n, int r) {
    return fact[n] / (fact[r] * fact[n-r]);
}
```

### 3. Mathematical Formulas
Replace loops with closed-form expressions:
- Sum of first n numbers: n(n+1)/2
- Sum of squares: n(n+1)(2n+1)/6
- Geometric series: a(1-r^n)/(1-r)
- Modular exponentiation: binary exponentiation

### 4. Sorting as a Tool
Sorting can simplify many problems:
- Remove duplicates: sort + unique
- Count frequencies: sort + linear scan
- Find pairs with conditions: two-pointer technique
- Schedule optimization: sort by deadline/start time

### 5. Greedy Approach
Make locally optimal choices:
- Activity selection: sort by finish time
- Huffman coding: always merge two smallest frequencies
- Fractional knapsack: sort by value/weight ratio
- Key: Prove greedy choice property and optimal substructure

### 6. Dynamic Programming
Break into overlapping subproblems:
- Identify state: What defines subproblem?
- Define transition: How to compute from smaller states?
- Base cases: Simplest subproblems
- Order: Bottom-up or top-down with memoization

### 7. Graph Techniques
Common graph problems in CP:
- **Connectivity**: DFS/BFS, Union-Find (DSU)
- **Shortest Path**: Dijkstra, Bellman-Ford, Floyd-Warshall
- **Cycle Detection**: DFS coloring, topological sort
- **Minimum Spanning Tree**: Kruskal, Prim
- **Topological Sorting**: DAG scheduling
- **Maximum Flow**: Ford-Fulkerson, Dinic's

### 8. Tree Algorithms
Frequent tree problems:
- **Traversals**: Inorder, preorder, postorder, level-order
- **Height/Diameter**: DFS-based calculations
- **LCA**: Binary lifting, Euler tour + RMQ
- **Subtree Queries**: Euler tour + segment tree
- **Tree Isomorphism**: AHU algorithm
- **Centroid Decomposition**: For path queries

### 9. String Algorithms
Essential string techniques:
- **String Matching**: KMP, Rabin-Karp, Z-algorithm
- **Palindromes**: Manacher's algorithm
- **Suffix Arrays**: Construction and applications
- **Tries/Prefix Trees**: For dictionary operations
- **Suffix Automata**: Advanced string processing
- **Regular Expressions**: Thompson's construction

### 10. Number Theory
Frequently used concepts:
- **Modular Arithmetic**: (a+b)%m = ((a%m)+(b%m))%m
- **Modular Inverse**: Fermat's little theorem (for prime modulus)
- **GCD/LCM**: Euclidean algorithm
- **Prime Sieve**: Eratosthenes for prime generation
- **Factorization**: Trial division, Pollard's rho
- **Combinatorics**: nCr modulo prime using factorials
- **Exponentiation**: Binary exponentiation (log n)

## Problem-Solving Framework

### Step 1: Read and Understand
- Read problem statement carefully
- Identify input/output format
- Note constraints (time, memory, input size)
- Look for examples and edge cases
- Determine what is being asked

### Step 2: Analyze and Plan
- Determine problem type (graph, DP, greedy, etc.)
- Consider possible approaches
- Estimate complexity of each approach
- Select most feasible approach
- Plan for edge cases

### Step 3: Design Algorithm
- Define state (for DP) or approach
- Work through examples manually
- Identify patterns or invariants
- Consider data structures needed
- Plan implementation steps

### Step 4: Implement
- Write clean, readable code
- Use appropriate data structures
- Handle input/output efficiently
- Add comments for complex logic
- Test with sample cases

### Step 5: Test and Debug
- Test with sample inputs
- Test with edge cases (min/max values)
- Test with random small cases (brute force compare)
- Check for off-by-one errors
- Verify memory usage
- Optimize if necessary (time/memory)

### Step 6: Submit and Learn
- Submit solution
- If wrong answer: analyze test cases
- If time limit exceeded: optimize algorithm
- If memory exceeded: reduce space complexity
- Learn from mistakes and improve

## Common Problem Types and Solutions

### A. Array Problems
**Techniques**:
- Prefix sums for range queries
- Suffix sums
- Two-pointer technique
- Sliding window
- Binary search on answer
- Divide and conquer (merge sort inversion count)

**Examples**:
- Maximum subarray sum (Kadane's algorithm)
- Product of array except self
- Rotate array
- Merge intervals
- Missing number in array

### B. String Problems
**Techniques**:
- KMP for pattern matching
- Z-algorithm for pattern matching
- Manacher's for palindromes
- Rolling hash (Rabin-Karp)
- Trie for dictionary operations
- Suffix array for substring queries

**Examples**:
- Find all occurrences of pattern
- Longest palindromic substring
- String rotation check
- Anagram detection
- Implement strStr()

### C. Graph Problems
**Techniques**:
- BFS for shortest path in unweighted graph
- Dijkstra for weighted graph (non-negative)
- Bellman-Ford for negative weights
- Floyd-Warshall for all-pairs shortest path
- DFS for cycle detection, topological sort
- Union-Find for dynamic connectivity
- Topological sort for DAGs

**Examples**:
- Number of islands
- Course schedule (topological sort)
- Network delay time
- Path with maximum probability
- Find if path exists in graph

### D. Dynamic Programming
**Patterns**:
- 1D DP: Fibonacci, climbing stairs
- 2D DP: Grid paths, edit distance
- Knapsack: 0/1, unbounded, bounded
- DP on strings: LCS, edit distance
- DP on trees: diameter, independent set
- DP with bitmasking: TSP, assignment problems
- DP + optimization: convex hull trick, divide and conquer DP

**Examples**:
- Longest increasing subsequence
- Minimum path sum in triangle
- Unique paths
- Coin change
- Word break
- Regular expression matching

### E. Mathematical Problems
**Techniques**:
- Modular arithmetic for large numbers
- Chinese Remainder Theorem
- Fermat's Little Theorem
- Lucas Theorem for nCr mod p
- Inclusion-Exclusion Principle
- Probability and expectation
- Generating functions
- Matrix exponentiation for linear recurrences

**Examples**:
- Calculate nCr mod p
- Find last k digits of a^b
- Count trailing zeros in factorial
- Solve linear congruences
- Probability of events
- Expected value calculations

### F. Geometry Problems
**Concepts**:
- Points, lines, vectors
- Dot product and cross product
- Area calculations (shoelace formula)
- Convex hull (Graham scan, monotone chain)
- Line intersection
- Circle intersection
- Point in polygon (ray casting)
- Closest pair of points (divide and conquer)

**Examples**:
- Check if point inside polygon
- Find convex hull of points
- Calculate area of polygon
- Check if lines intersect
- Find minimum enclosing circle
- Closest pair of points

## Advanced Topics

### 1. Mo's Algorithm
For range query problems with updates:
- Process queries in specific order
- Add/remove elements efficiently
- Complexity: O((N+Q)√N)

### 2. Square Root Decomposition
Divide array into √n blocks:
- Range queries and updates
- Balance between preprocessing and query time

### 3. Segment Trees and Binary Indexed Trees
- Range queries and point updates
- Lazy propagation for range updates
- Persistent versions for historical queries

### 4. Heavy-Light Decomposition
For tree path queries:
- Decompose tree into chains
- Convert path queries to range queries
- Combine with segment trees

### 5. Centroid Decomposition
For tree problems:
- Find centroid (balanced node)
- Solve problem for centroid
- Recurse on subtrees
- Useful for path counting problems

### 6. FFT (Fast Fourier Transform)
For polynomial multiplication:
- Multiply polynomials in O(n log n)
- Applications in convolution, string matching
- Number Theoretic Transform (NTT) for modular arithmetic

### 7. Linear Basis
For XOR-related problems:
- Maintain basis of vector space
- Find maximum XOR subset
- Check if subset XOR equals k
- Applications in game theory, graph theory

### 8. Suffix Automaton
Advanced string processing:
- Linear size automaton for all substrings
- Efficient substring queries
- Count distinct substrings
- Longest common substring

### 9. Persistent Data Structures
Maintain versions of data structures:
- Persistent segment trees
- Persistent tries
- Functional approach to data structures
- Used in K-th number queries, historical data

### 10. Randomized Algorithms
Leverage randomness for efficiency:
- Hashing for string comparison
- Randomized incremental construction
- Monte Carlo vs Las Vegas algorithms
- Probabilistic data structures (Bloom filters)
- Randomized primality testing

## Practice Strategies

### Progressive Difficulty
1. **Easy**: Build confidence with basic problems
2. **Medium**: Apply multiple concepts
3. **Hard**: Combine advanced techniques
4. **Very Hard**: Research-level problems

### Topic-Based Practice
- Spend 1-2 weeks on each major topic
- Implement all variations of a concept
- Solve problems from different sources
- Create your own problems
- Teach concepts to others

### Contest Participation
- Start with shorter contests (1-2 hours)
- Participate regularly (weekly)
- Analyze performance after each contest
- Identify weak areas and improve
- Learn from editorials and top solutions

### Problem-Solving Habits
- Always consider brute force first
- Think about invariants and monovariants
- Look for symmetry in problems
- Consider dual problems
- Ask: "What if I knew the answer? How would I verify it?"
- Try small examples to detect patterns

## Resources

### Books
1. "Competitive Programming 4" by Steven Halim & Felix Halim
2. "Programming Challenges" by Steven Skiena & Miguel Revilla
3. "Algorithms Live!" by Mohammad Abdullah Al Mamun
4. "Guide to Competitive Programming" by Antti Laaksonen
5. "CP-Algorithms" (online book)

### Websites
- Codeforces (codeforces.com) - Regular contests, problemset
- AtCoder (atcoder.jp) - Japanese platform, excellent for beginners
- LeetCode (leetcode.com) - Interview preparation focus
- HackerRank (hackerrank.com) - Skill tracks and certifications
- CodeChef (codechef.com) - Indian platform, long challenges
- CS Academy (csacademy.com) - Educational focus
- Kattis (open.kattis.com) - Problem archive

### YouTube Channels
- Errichto - Excellent explanations and live coding
- William Lin - Fast problem solving techniques
- Tushar Roy - Conceptual explanations
- Abdul Bari - Algorithm explanations
- BacktoBackSWE - Interview preparation

### Practice Strategies
- Virtual participation in past contests
- Problem tagging practice (focus on weak areas)
- Upsolving (solving after contest)
- Problem setting (creating your own problems)
- Collaborative solving with friends

## Common Mistakes to Avoid

### 1. Ignoring Constraints
- Not checking if O(n^2) will pass for n=10^5
- Using O(n^2) memory for large n
- Missing modulo requirements
- Not considering integer overflow

### 2. Incorrect I/O Handling
- Forgetting to flush output
- Using slow I/O methods
- Not handling multiple test cases correctly
- Mixing cin/cous with scanf/printf after sync_with_stdio(false)

### 3. Algorithmic Errors
- Off-by-one errors in loops/arrays
- Incorrect base cases in recursion/DP
- Missing edge cases (empty input, single element)
- Wrong termination conditions
- Incorrect state transitions in DP

### 4. Implementation Bugs
- Forgetting to initialize variables
- Using uninitialized memory
- Incorrect array bounds
- Memory leaks (in C++ with manual management)
- Not resetting global variables between test cases

### 5. Conceptual Mistakes
- Applying wrong algorithm to problem type
- Misunderstanding problem statement
- Overlooking key constraint
- Making incorrect assumptions
- Not proving greedy choice property

## Tips for Success

### 1. Master Your Language
- Know your STL/collections library deeply
- Understand performance characteristics
- Know common pitfalls and how to avoid them
- Practice writing code without looking up syntax

### 2. Build Intuition
- Solve problems by hand for small cases
- Look for patterns in solutions
- Understand why algorithms work, not just how
- Connect different problems and techniques
- Explain concepts to others

### 3. Develop Problem-Solving Habits
- Always start with brute force
- Think about invariants and properties
- Consider dual problems or transformations
- Work backwards from solution sometimes
- Ask "what makes this problem hard?"

### 4. Practice Efficiently
- Focus on understanding, not just solving
- Time yourself to build speed
- Review solutions even when correct
- Learn one new concept per week
- Participate in live contests regularly

### 5. Contest Day Preparation
- Get adequate sleep before contest
- Have your template ready
- Know your strengths and weaknesses
- Plan problem order strategy
- Stay calm and focused
- Take short breaks if needed
- Don't get stuck on one problem too long

## Remember
Competitive programming is a journey, not a destination. The skills you develop—problem decomposition, algorithmic thinking, efficient implementation, and persistence—are valuable far beyond the contest platform. Enjoy the process of learning and improving, and celebrate small victories along the way!

"In the middle of difficulty lies opportunity." – Albert Einstein