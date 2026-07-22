# Codeforces Complete Guide

## Getting Started

### Account Setup
1. Register at codeforces.com with a username you'll keep long-term
2. Set your timezone for accurate contest scheduling
3. Configure your preferred languages in settings
4. Join groups for your university or region

### Platform Navigation
- **Home**: Latest contests and announcements
- **Contests**: Upcoming and past contest archive
- **Problemset**: All problems with filters
- **Gym**: Virtual contests and practice
- **Rating**: Global ranking list
- **Blog**: Community posts and discussions

## How Contests Work

### Contest Day Checklist
- [ ] Check contest time and timezone
- [ ] Prepare a quiet workspace
- [ ] Have template code ready
- [ ] Test your IDE/online compiler
- [ ] Read all problems before coding

### Contest Strategy

**Phase 1: Read (5-10 minutes)**
- Read all problems quickly
- Identify the easiest and hardest problems
- Note which problems you can solve immediately

**Phase 2: Solve Easy Problems (20-30 minutes)**
- Start with problems you're confident about
- Aim for 0-2 penalty submissions
- Get points on the board early

**Phase 3: Tackle Medium Problems (40-60 minutes)**
- Work on problems matching your rating target
- Don't spend too long on a single problem
- Skip and return if stuck after 15-20 minutes

**Phase 4: Review (10-15 minutes)**
- Check for compile errors
- Verify edge cases
- Submit any remaining solutions

### Penalty Management
- Each wrong submission adds 5 minutes to penalty
- Don't guess without testing
- Be confident before submitting
- Use hack attempts wisely in Div. 1/2

## Practice Strategies

### Rating-Based Progression
```
Target Rating 800-1000: Solve 50+ problems at 800-1000
Target Rating 1000-1200: Solve 50+ problems at 1000-1200
Target Rating 1200-1400: Solve 50+ problems at 1200-1400
Target Rating 1400-1600: Solve 50+ problems at 1400-1600
... and so on
```

### Upsolving
After every contest, solve problems you couldn't complete:
1. Read the editorial first
2. Implement the solution
3. If still stuck, look at accepted solutions
4. Understand the approach, don't copy code

### Virtual Contests
- Take past contests under timed conditions
- Simulate real contest pressure
- Available in the Gym section
- Great for building speed and accuracy

## Problem-Solving Approach

### The Codeforces Way

1. **Read problem statement carefully**
   - What are the constraints?
   - What's the expected complexity?
   - Are there special cases?

2. **Identify the technique**
   - Brute force viable? (n ≤ 20)
   - Greedy approach?
   - Dynamic programming?
   - Graph algorithm?
   - Math/number theory?

3. **Plan your solution**
   - Pseudocode the approach
   - Identify data structures needed
   - Consider edge cases

4. **Implement cleanly**
   - Use descriptive variable names
   - Handle input/output efficiently
   - Write modular code

5. **Test thoroughly**
   - Trace through examples
   - Test edge cases: n=0, n=1, max values
   - Check for overflow issues

## Essential Templates

### Fast I/O (C++)
```cpp
ios_base::sync_with_stdio(false);
cin.tie(NULL);
cout.tie(NULL);
```

### Fast I/O (Python)
```python
import sys
input = sys.stdin.readline
```

### Graph BFS Template
```cpp
vector<int> adj[MAXN];
bool visited[MAXN];
int dist[MAXN];

void bfs(int start) {
    queue<int> q;
    q.push(start);
    visited[start] = true;
    dist[start] = 0;

    while (!q.empty()) {
        int v = q.front();
        q.pop();

        for (int u : adj[v]) {
            if (!visited[u]) {
                visited[u] = true;
                dist[u] = dist[v] + 1;
                q.push(u);
            }
        }
    }
}
```

### DSU Template
```cpp
int parent[MAXN], rank[MAXN];

void make_set(int v) {
    parent[v] = v;
    rank[v] = 0;
}

int find_set(int v) {
    if (v == parent[v])
        return v;
    return parent[v] = find_set(parent[v]);
}

void union_sets(int a, int b) {
    a = find_set(a);
    b = find_set(b);
    if (a != b) {
        if (rank[a] < rank[b])
            swap(a, b);
        parent[b] = a;
        if (rank[a] == rank[b])
            rank[a]++;
    }
}
```

## Time Management

### During Contest
- 800-1000 rated: 5-10 minutes each
- 1000-1400 rated: 10-20 minutes each
- 1400-1800 rated: 20-40 minutes each
- 1800+ rated: 40-80 minutes each

### Practice Sessions
- Set a timer for 2 hours (like a real contest)
- Solve 4-5 problems per session
- Review all problems after the session
- Note patterns and techniques used

## Learning from Editorials

After every contest or practice problem:
1. Read the editorial on Codeforces
2. Understand the intended solution
3. Compare with your approach
4. Note new techniques or data structures
5. Implement the editorial solution if different
