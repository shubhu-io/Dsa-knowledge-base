# Competitive Programming

## Overview

Competitive Programming (CP) is a mind sport where participants solve algorithmic
and mathematical problems under time constraints. It builds problem-solving skills,
deepens understanding of data structures, and prepares you for technical interviews.

Practicing CP regularly improves your ability to think clearly under pressure,
recognize patterns, and write correct code quickly.

---

## Key Concepts

### What is Competitive Programming?

- Solving well-defined problems with precise input/output specifications
- Writing programs that pass hidden test cases within time and memory limits
- Competing against other programmers in timed contests

### Why Practice CP?

- Sharpens algorithmic thinking
- Teaches you to handle edge cases
- Builds speed and accuracy in coding
- Directly relevant to coding interviews

---

## Platform Comparison

| Platform     | Focus              | Difficulty Range | Contest Frequency |
|-------------|---------------------|------------------|-------------------|
| Codeforces  | Algorithms          | Easy to Expert   | 2-3 per week      |
| CodeChef    | Algorithms          | Beginner to GM   | Monthly + Cook-off|
| LeetCode    | Interview-style     | Easy to Hard     | Weekly/Biweekly   |
| HackerRank  | Language + Algo      | Easy to Hard     | Monthly           |
| AtCoder     | Math-heavy Algo     | Beginner to F    | Weekly            |
| CSES        | Educational         | Fixed set        | No contests       |

---

## Rating Systems

### Codeforces Rating Divisions

| Division | Rating Range   | Color     |
|----------|---------------|-----------|
| Newbie   | 0 - 1199      | Grey      |
| Pupil    | 1200 - 1399   | Green     |
| Specialist| 1400 - 1599  | Blue      |
| Expert   | 1600 - 1899   | Violet    |
| CM       | 1900 - 2099   | Orange    |
| Master   | 2100 - 2299   | Red       |
| IM       | 2300 - 2399   | Red       |
| GM       | 2400 - 2599   | Red       |
| IGM      | 2600 - 2899   | Red       |
| LGM      | 3000+         | Red       |

### LeetCode Rating

- Based on contest rating system
- Ranges from 0 to 3000+
- Top 5% is approximately 1800+

---

## Common CP Techniques

### 1. Greedy Algorithms

Make locally optimal choices at each step hoping for a global optimum.

```python
# Activity Selection Problem
def max_activities(start, finish):
    activities = sorted(zip(start, finish), key=lambda x: x[1])
    count = 1
    last_finish = activities[0][1]
    for i in range(1, len(activities)):
        if activities[i][0] >= last_finish:
            count += 1
            last_finish = activities[i][1]
    return count
```

### 2. Dynamic Programming

Break problems into overlapping subproblems and store results.

```python
# 0/1 Knapsack
def knapsack(W, wt, val, n):
    dp = [[0] * (W + 1) for _ in range(n + 1)]
    for i in range(1, n + 1):
        for w in range(1, W + 1):
            if wt[i-1] <= w:
                dp[i][w] = max(val[i-1] + dp[i-1][w - wt[i-1]],
                               dp[i-1][w])
            else:
                dp[i][w] = dp[i-1][w]
    return dp[n][W]
```

### 3. Binary Search on Answer

When the answer space is monotonic, binary search to find the optimal value.

### 4. Graph Algorithms

BFS, DFS, Dijkstra, Bellman-Ford, Floyd-Warshall, Topological Sort, Union-Find.

### 5. Math and Number Theory

- Modular arithmetic
- Sieve of Eratosthenes
- GCD / Extended Euclidean
- Fast exponentiation

---

## Contest Strategy Tips

1. **Read all problems first** (5 minutes) - identify the easiest problem
2. **Start with the easiest** - secure points early, build momentum
3. **Time management** - spend max 30% of time on any single problem
4. **Debug systematically** - check edge cases, use print statements
5. **Upsolve after the contest** - solve problems you couldn't finish
6. **Keep a template** - pre-written code for common patterns

---

## Rating Progression Advice

- **0-1200**: Learn basic data structures and sorting
- **1200-1600**: Practice DP, greedy, and basic graph theory
- **1600-2000**: Master advanced DP, trees, and number theory
- **2000+**: Focus on advanced topics, optimization, and contest strategy

---

## Common Interview Questions

1. How would you approach a problem you've never seen before?
2. Explain the difference between greedy and DP approaches
3. How do you handle time limit exceeded (TLE) errors?
4. What strategies help when stuck on a problem during a contest?
5. How does competitive programming differ from interview coding?

---

## See Also

- [[Algorithms]]
- [[Problem-Solving]]
- [[Time-Complexity]]

---

> Full content: [06-Competitive-Programming](../06-Competitive-Programming/)
