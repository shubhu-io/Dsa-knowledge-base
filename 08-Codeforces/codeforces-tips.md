# Codeforces Tips & Strategies

## Contest Preparation

### Before Contest
- [ ] Check contest time (account for timezone)
- [ ] Review recent contest problems for style
- [ ] Practice similar-rated problems
- [ ] Prepare code templates
- [ ] Test your development environment
- [ ] Get water and snacks ready

### Code Templates to Prepare

```cpp
// Fast I/O
ios_base::sync_with_stdio(false);
cin.tie(NULL);

// Common includes
#include <bits/stdc++.h>
using namespace std;

// DSU
int parent[200001], rnk[200001];
void make_set(int v) { parent[v] = v; rnk[v] = 0; }
int find_set(int v) { return v == parent[v] ? v : parent[v] = find_set(parent[v]); }
void union_sets(int a, int b) {
    a = find_set(a); b = find_set(b);
    if (a != b) {
        if (rnk[a] < rnk[b]) swap(a, b);
        parent[b] = a;
        if (rnk[a] == rnk[b]) rnk[a]++;
    }
}

// Segment Tree
int tree[4*MAXN], arr[MAXN];
void build(int node, int start, int end) {
    if (start == end) { tree[node] = arr[start]; return; }
    int mid = (start + end) / 2;
    build(2*node, start, mid);
    build(2*node+1, mid+1, end);
    tree[node] = tree[2*node] + tree[2*node+1];
}
```

## During Contest Strategy

### Problem Selection Order
1. **Scan all problems** (5 minutes)
2. **Identify easiest** (usually A/B in Div. 2/3)
3. **Solve in confidence order**, not problem order
4. **Skip if stuck** after 15-20 minutes
5. **Return to skipped problems** with fresh perspective

### Time Management
```
Problem A (800-1000): 5-10 minutes
Problem B (1000-1200): 10-15 minutes
Problem C (1200-1400): 15-25 minutes
Problem D (1400-1600): 20-35 minutes
Problem E (1600+): 30-50 minutes
```

### Submission Strategy
- **Test with examples** before submitting
- **Don't guess** without testing edge cases
- **Use hacks wisely** in Div. 1/2
- **Minimize wrong submissions** (penalty!)

## Practice Strategies

### The 80-20 Rule
- 80% of your rating improvement comes from 20% of problem types
- Focus on your weakest areas first
- Master common patterns before exotic ones

### Rating-Based Practice
```
Current: 1100 | Target: 1400
Strategy:
- Solve 30-50 problems at 1100-1200 (build confidence)
- Solve 30-50 problems at 1200-1400 (push limits)
- Occasionally try 1400-1600 (exposure to next level)
```

### Upsolving After Contest
1. **Read editorial** for unsolved problems
2. **Implement the solution** yourself
3. **If stuck**, look at 1-2 accepted solutions
4. **Understand the approach**, not just the code
5. **Add to practice list** if pattern is new

### Virtual Contests
- Take 2-3 virtual contests per week
- Simulate real conditions (no pausing)
- Review all problems afterward
- Track solve rate and time

## Common Patterns to Master

### Pattern 1: Prefix Sums
**Use when**: Range queries, subarray sums
```cpp
prefix[0] = 0;
for (int i = 1; i <= n; i++)
    prefix[i] = prefix[i-1] + arr[i-1];
// Range sum [l, r] = prefix[r+1] - prefix[l]
```

### Pattern 2: Two Pointers
**Use when**: Sorted arrays, pair finding
```cpp
int l = 0, r = n - 1;
while (l < r) {
    if (arr[l] + arr[r] == target) { /* found */ l++; r--; }
    else if (arr[l] + arr[r] < target) l++;
    else r--;
}
```

### Pattern 3: Binary Search on Answer
**Use when**: Find minimum/maximum valid value
```cpp
int lo = min_val, hi = max_val;
while (lo < hi) {
    int mid = lo + (hi - lo) / 2;
    if (isValid(mid)) hi = mid;
    else lo = mid + 1;
}
```

### Pattern 4: BFS for Shortest Path
**Use when**: Unweighted graph, minimum moves
```cpp
queue<int> q;
q.push(start);
dist[start] = 0;
while (!q.empty()) {
    int v = q.front(); q.pop();
    for (int u : adj[v]) {
        if (dist[u] == -1) {
            dist[u] = dist[v] + 1;
            q.push(u);
        }
    }
}
```

## Interview Relevance

### How Codeforces Helps
- **Problem-solving under pressure**: Simulates interview time pressure
- **Pattern recognition**: Identify common algorithmic patterns
- **Optimization thinking**: Learn to find efficient solutions
- **Debugging skills**: Find and fix bugs quickly

### Codeforces to Interview Mapping

| CF Rating | Interview Equivalent |
|-----------|---------------------|
| 800-1200 | Easy LeetCode problems |
| 1200-1600 | Medium LeetCode problems |
| 1600-2000 | Hard LeetCode problems |
| 2000+ | Very Hard/Contest problems |

## Debugging Tips

### Common Bugs
1. **Off-by-one errors**: Check loop boundaries
2. **Integer overflow**: Use long long for multiplications
3. **Index out of bounds**: Verify array sizes
4. **Infinite loops**: Ensure termination condition
5. **Wrong data type**: int vs long long vs double

### Debugging Process
1. **Read error message** carefully
2. **Check input constraints** - did you handle edge cases?
3. **Trace with small example**
4. **Add debug prints** (remove before submit!)
5. **Use debugger** if available

## Mental Health & Consistency

### Avoiding Burnout
- Take breaks between contests
- Don't compare yourself to others
- Celebrate small improvements
- Remember: it's a marathon, not a sprint

### Staying Consistent
- Solve at least 1 problem daily
- Participate in every contest
- Review and learn from mistakes
- Set realistic goals

### After Bad Performance
- It's normal - everyone has bad days
- Analyze what went wrong
- Don't skip next contest out of fear
- Focus on learning, not rating
