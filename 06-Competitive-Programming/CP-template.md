# Competitive Programming Template

## Standard C++ Template for Competitive Programming

This template includes commonly used headers, macros, and utility functions for competitive programming contests.

```cpp
#include <bits/stdc++.h>
using namespace std;

// ============= TYPE DEFINITIONS =============
using ll = long long;
using ull = unsigned long long;
using ld = long double;
using pii = pair<int, int>;
using pll = pair<long long, long long>;
using vi = vector<int>;
using vll = vector<long long>;
using vvi = vector<vector<int>>;
using vvll = vector<vector<long long>>;
using vpii = vector<pair<int, int>>;
using vpll = vector<pair<long long, long long>>;
using si = set<int>;
using sll = set<long long>;
using mii = map<int, int>;
using mll = map<long long, long long>;
using umsi = unordered_map<string, int>;
using umii = unordered_map<int, int>;
using usi = unordered_set<int>;
using usll = unordered_set<long long>;

// ============= CONSTANTS =============
const int INF = 1e9;
const ll LINF = 1e18;
const int MOD = 1e9 + 7;
const int MOD2 = 998244353;
const ld EPS = 1e-9;
const ld PI = acos(-1);

// ============= MACROS =============
#define pb push_back
#define eb emplace_back
#define mp make_pair
#define fi first
#define se second
#define sz(x) (int)(x).size()
#define all(x) (x).begin(), (x).end()
#define rall(x) (x).rbegin(), (x).rend()
#define rep(i, a, b) for(int i = a; i < (b); ++i)
#define per(i, a, b) for(int i = b-1; i >= (a); --i)
#define repd(i, a, b) for(int i = a; i <= (b); ++i)
#define perd(i, a, b) for(int i = b; i >= (a); --i)
#define trav(a, x) for(auto& a : x)
#define deb(x) cout << #x << " = " << x << endl
#define deb2(x, y) cout << #x << " = " << x << ", " << #y << " = " << y << endl
#define debv(v) for(auto x : v) cout << x << " "; cout << endl
#define debm(m) for(auto row : m){for(auto x : row) cout << x << " "; cout << endl;}
#define fastio ios_base ios::sync_with_stdio(false); cin.tie(nullptr); cout.tie(nullptr);

// ============= UTILITY FUNCTIONS =============
template<typename T> bool ckmin(T& a, const T& b) { return b < a ? a = b, 1 : 0; }
template<typename T> bool ckmax(T& a, const T& b) { return a < b ? a = b, 1 : 0; }
template<typename T> T gcd(T a, T b) { return b ? gcd(b, a % b) : a; }
template<typename T> T lcm(T a, T b) { return a / gcd(a, b) * b; }
template<typename T> T mod_exp(T base, T exp, T mod) {
    T result = 1;
    base %= mod;
    while (exp > 0) {
        if (exp & 1) result = (result * base) % mod;
        base = (base * base) % mod;
        exp >>= 1;
    }
    return result;
}
template<typename T> T mod_inv(T a, T mod) { 
    return mod_exp(a, mod - 2, mod); // when mod is prime
}
int lb(const auto& v, const auto& x) { return lower_bound(all(v), x) - v.begin(); }
int ub(const auto& v, const auto& x) { return upper_bound(all(v), x) - v.begin(); }
string to_binary(long long x, int bits = 64) {
    string s(bits, '0');
    for (int i = bits - 1; i >= 0; i--) {
        if (x & (1LL << i)) s[bits - 1 - i] = '1';
    }
    return s;
}

// ============= DATA STRUCTURES =============
// Disjoint Set Union (Union-Find)
struct DSU {
    vector<int> parent, rank, size;
    int components;
    
    DSU(int n) {
        parent.resize(n);
        rank.assign(n, 0);
        size.assign(n, 1);
        components = n;
        iota(parent.begin(), parent.end(), 0);
    }
    
    int find(int x) {
        if (x != parent[x]) parent[x] = find(parent[x]);
        return parent[x];
    }
    
    bool unite(int x, int y) {
        x = find(x);
        y = find(y);
        if (x == y) return false;
        
        if (rank[x] < rank[y]) swap(x, y);
        parent[y] = x;
        if (rank[x] == rank[y]) rank[x]++;
        size[x] += size[y];
        components--;
        return true;
    }
    
    bool same_set(int x, int y) { return find(x) == find(y); }
    int get_size(int x) { return size[find(x)]; }
    int get_components() { return components; }
};

// Fenwick Tree (Binary Indexed Tree)
struct FenwickTree {
    int n;
    vector<long long> bit;
    
    FenwickTree(int n) {
        this->n = n;
        bit.assign(n + 1, 0);
    }
    
    void add(int idx, long long delta) {
        for (++idx; idx <= n; idx += idx & -idx)
            bit[idx] += delta;
    }
    
    long long sum(int idx) {
        long long ret = 0;
        for (++idx; idx > 0; idx -= idx & -idx)
            ret += bit[idx];
        return ret;
    }
    
    long long range_sum(int l, int r) {
        return sum(r) - sum(l - 1);
    }
};

// Segment Tree (for range sum queries and point updates)
struct SegmentTree {
    int n;
    vector<long long> tree;
    
    SegmentTree(int n) {
        this->n = n;
        tree.assign(4 * n, 0);
    }
    
    void build(vector<long long>& a, int v, int tl, int tr) {
        if (tl == tr) {
            tree[v] = a[tl];
        } else {
            int tm = (tl + tr) / 2;
            build(a, v*2+1, tl, tm);
            build(a, v*2+2, tm+1, tr);
            tree[v] = tree[v*2+1] + tree[v*2+2];
        }
    }
    
    SegmentTree(vector<long long>& a) : SegmentTree((int)a.size()) {
        build(a, 0, 0, n - 1);
    }
    
    long long query(int v, int tl, int tr, int l, int r) {
        if (l > r) return 0;
        if (l == tl && r == tr) return tree[v];
        int tm = (tl + tr) / 2;
        return query(v*2+1, tl, tm, l, min(r, tm))
             + query(v*2+2, tm+1, tr, max(l, tm+1), r);
    }
    
    long long query(int l, int r) {
        return query(0, 0, n-1, l, r);
    }
    
    void update(int v, int tl, int tr, int pos, long long new_val) {
        if (tl == tr) {
            tree[v] = new_val;
        } else {
            int tm = (tl + tr) / 2;
            if (pos <= tm)
                update(v*2+1, tl, tm, pos, new_val);
            else
                update(v*2+2, tm+1, tr, pos, new_val);
            tree[v] = tree[v*2+1] + tree[v*2+2];
        }
    }
    
    void update(int pos, long long new_val) {
        update(0, 0, n-1, pos, new_val);
    }
};

// ============= MAIN SOLUTION TEMPLATE =============
void solve() {
    // Your solution goes here
}

int main() {
    fastio;
    
    int tc = 1;
    // Uncomment if multiple test cases
    // cin >> tc;
    
    for (int t = 1; t <= tc; t++) {
        // cout << "Case #" << t << ": ";
        solve();
        // if (t < tc) cout << '\n';
    }
    
    return 0;
}
```

## Java Template

```java
import java.io.*;
import java.util.*;
import java.math.*;
import java.text.*;

public class Main {
    // Fast I/O
    static class FastScanner {
        BufferedReader br;
        StringTokenizer st;
        
        public FastTokenizer(String s) {
            try {
                br = new BufferedReader(new FileReader(s));
            } catch (FileNotFoundException e) {
                throw new RuntimeException(e);
            }
        }
        
        public FastScanner() {
            br = new BufferedReader(new InputStreamReader(System.in));
        }
        
        String next() {
            while (st == null || !st.hasMoreTokens()) {
                try {
                    st = new StringTokenizer(br.readLine());
                } catch (IOException e) {
                    throw new RuntimeException(e);
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
                throw new RuntimeException(e);
            }
            return str;
        }
        
        int[] readArray(int n) {
            int[] arr = new int[n];
            for (int i = 0; i < n; i++) {
                arr[i] = nextInt();
            }
            return arr;
        }
        
        long[] readLongArray(int n) {
            long[] arr = new long[n];
            for (int i = 0; i < n; i++) {
                arr[i] = nextLong();
            }
            return arr;
        }
    }
    
    // Utility methods
    static long gcd(long a, long b) {
        return b == 0 ? a : gcd(b, a % b);
    }
    
    static long lcm(long a, long b) {
        return a / gcd(a, b) * b;
    }
    
    static long modPow(long base, long exp, long mod) {
        long result = 1;
        base %= mod;
        while (exp > 0) {
            if ((exp & 1) == 1) result = (result * base) % mod;
            base = (base * base) % mod;
            exp >>= 1;
        }
        return result;
    }
    
    static long modInverse(long a, long mod) {
        return modPow(a, mod - 2, mod); // when mod is prime
    }
    
    // DSU (Disjoint Set Union)
    static class DSU {
        int[] parent, rank, size;
        int components;
        
        DSU(int n) {
            parent = new int[n];
            rank = new int[n];
            size = new int[n];
            components = n;
            for (int i = 0; i < n; i++) {
                parent[i] = i;
                size[i] = 1;
            }
        }
        
        int find(int x) {
            if (x != parent[x]) parent[x] = find(parent[x]);
            return parent[x];
        }
        
        boolean union(int x, int y) {
            x = find(x);
            y = find(y);
            if (x == y) return false;
            
            if (rank[x] < rank[y]) {
                int temp = x;
                x = y;
                y = temp;
            }
            parent[y] = x;
            if (rank[x] == rank[y]) rank[x]++;
            size[x] += size[y];
            components--;
            return true;
        }
        
        boolean same(int x, int y) {
            return find(x) == find(y);
        }
        
        int getSize(int x) {
            return size[find(x)];
        }
        
        int getComponents() {
            return components;
        }
    }
    
    // Main solution method
    public void solve() {
        // Your solution goes here
    }
    
    public static void main(String[] args) {
        FastScanner fs = new FastScanner();
        int tc = 1;
        // Uncomment if multiple test cases
        // tc = fs.nextInt();
        for (int t = 1; t <= tc; t++) {
            new Main().solve();
        }
    }
}
```

## Python Template

```python
import sys
import math
import bisect
import heapq
from collections import defaultdict, Counter, deque
from typing import List, Tuple, Set, Dict, Optional

# Fast I/O
def input():
    return sys.stdin.readline().rstrip('\r\n')

def map_ints():
    return map(int, input().split())

def list_ints():
    return list(map(int, input().split()))

def map_floats():
    return map(float, input().split())

def list_floats():
    return list(map(float, input().split()))

def map_strings():
    return input().split()

def list_strings():
    return list(input().split())

# Constants
INF = 10**18
MOD = 10**9 + 7
MOD2 = 998244353
EPS = 1e-9
PI = math.pi

# Utility Functions
def gcd(a: int, b: int) -> int:
    while b:
        a, b = b, a % b
    return a

def lcm(a: int, b: int) -> int:
    return a // gcd(a, b) * b

def mod_pow(base: int, exp: int, mod: int) -> int:
    result = 1
    base %= mod
    while exp > 0:
        if exp & 1:
            result = (result * base) % mod
        base = (base * base) % mod
        exp >>= 1
    return result

def mod_inv(a: int, mod: int) -> int:
    return mod_pow(a, mod - 2, mod)  # when mod is prime

# Disjoint Set Union (Union-Find)
class DSU:
    def __init__(self, n: int):
        self.parent = list(range(n))
        self.rank = [0] * n
        self.size = [1] * n
        self.components = n
    
    def find(self, x: int) -> int:
        if self.parent[x] != x:
            self.parent[x] = self.find(self.parent[x])
        return self.parent[x]
    
    def union(self, x: int, y: int) -> bool:
        x, y = self.find(x), self.find(y)
        if x == y:
            return False
        
        if self.rank[x] < self.rank[y]:
            x, y = y, x
        self.parent[y] = x
        if self.rank[x] == self.rank[y]:
            self.rank[x] += 1
        self.size[x] += self.size[y]
        self.components -= 1
        return True
    
    def same(self, x: int, y: int) -> bool:
        return self.find(x) == self.find(y)
    
    def get_size(self, x: int) -> int:
        return self.size[self.find(x)]
    
    def get_components(self) -> int:
        return self.components

# Fenwick Tree (Binary Indexed Tree)
class FenwickTree:
    def __init__(self, n: int):
        self.n = n
        self.bit = [0] * (n + 1)
    
    def add(self, idx: int, delta: int):
        idx += 1
        while idx <= self.n:
            self.bit[idx] += delta
            idx += idx & -idx
    
    def sum(self, idx: int) -> int:
        idx += 1
        res = 0
        while idx > 0:
            res += self.bit[idx]
            idx -= idx & -idx
        return res
    
    def range_sum(self, l: int, r: int) -> int:
        return self.sum(r) - self.sum(l - 1)

# Main solution function
def solve():
    # Your solution goes here
    pass

# Main execution
if __name__ == "__main__":
    t = 1
    # Uncomment if multiple test cases
    # t = int(input())
    for _ in range(t):
        solve()
```

## Common Competitive Programming Patterns

### 1. Reading Input Efficiently
```cpp
// C++
int n, m;
cin >> n >> m;
vector<int> a(n);
for (int i = 0; i < n; i++) cin >> a[i];

// Python
n, m = map(int, input().split())
a = list(map(int, input().split()))

// Java
int n = fs.nextInt();
int m = fs.nextInt();
int[] a = fs.readIntArray(n);
```

### 2. Multiple Test Cases
```cpp
// C++
int t;
cin >> t;
while (t--) {
    solve();
}

// Python
t = int(input())
for _ in range(t):
    solve()

// Java
int t = fs.nextInt();
while (t-- > 0) {
    new Main().solve();
}
```

### 3. Precomputation (Factorials, Primes, etc.)
```cpp
// Factorial precomputation
const int MAXN = 1e6;
vector<long long> fact(MAXN + 1), inv_fact(MAXN + 1);

void precompute_factorials() {
    fact[0] = 1;
    for (int i = 1; i <= MAXN; i++) {
        fact[i] = fact[i-1] * i % MOD;
    }
    inv_fact[MAXN] = mod_exp(fact[MAXN], MOD-2, MOD);
    for (int i = MAXN; i > 0; i--) {
        inv_fact[i-1] = inv_fact[i] * i % MOD;
    }
}

long long nCr(int n, int r) {
    if (r < 0 || r > n) return 0;
    return fact[n] * inv_fact[r] % MOD * inv_fact[n-r] % MOD;
}
```

### 4. Binary Search Template
```cpp
// C++ - Lower bound (first >= x)
int lower_bound(vector<int>& arr, int x) {
    int l = 0, r = arr.size();
    while (l < r) {
        int m = l + (r - l) / 2;
        if (arr[m] < x) l = m + 1;
        else r = m;
    }
    return l;
}

// C++ - Upper bound (first > x)
int upper_bound(vector<int>& arr, int x) {
    int l = 0, r = arr.size();
    while (l < r) {
        int m = l + (r - l) / 2;
        if (arr[m] <= x) l = m + 1;
        else r = m;
    }
    return l;
}
```

### 5. Depth-First Search (DFS)
```cpp
// C++
vector<vector<int>> adj;
vector<bool> visited;

void dfs(int v) {
    visited[v] = true;
    // Process node v
    for (int to : adj[v]) {
        if (!visited[to]) {
            dfs(to);
        }
    }
}

// Iterative DFS to avoid stack overflow
void dfs_iterative(int start) {
    stack<int> st;
    st.push(start);
    vector<bool> visited(adj.size(), false);
    
    while (!st.empty()) {
        int v = st.top();
        st.pop();
        if (visited[v]) continue;
        visited[v] = true;
        // Process node v
        
        for (int to : adj[v]) {
            if (!visited[to]) {
                st.push(to);
            }
        }
    }
}
```

### 6. Breadth-First Search (BFS)
```cpp
// C++
vector<int> bfs(int start) {
    int n = adj.size();
    vector<int> dist(n, -1);
    queue<int> q;
    
    dist[start] = 0;
    q.push(start);
    
    while (!q.empty()) {
        int v = q.front();
        q.pop();
        
        for (int to : adj[v]) {
            if (dist[to] == -1) {
                dist[to] = dist[v] + 1;
                q.push(to);
            }
        }
    }
    return dist;
}
```

### 7. Dynamic Programming Patterns
```cpp
// 1D DP (Fibonacci-style)
vector<int> dp(n+1);
dp[0] = a;
dp[1] = b;
for (int i = 2; i <= n; i++) {
    dp[i] = f(dp[i-1], dp[i-2]);
}

// 2D DP (Grid)
vector<vector<int>> dp(m, vector<int>(n));
for (int i = 0; i < m; i++) {
    for (int j = 0; j < n; j++) {
        if (i == 0 && j == 0) {
            dp[i][j] = base;
        } else if (i == 0) {
            dp[i][j] = dp[i][j-1] + cost;
        } else if (j == 0) {
            dp[i][j] = dp[i-1][j] + cost;
        } else {
            dp[i][j] = min(dp[i-1][j], dp[i][j-1]) + cost;
        }
    }
}
```

## Tips for Competitive Programming

### 1. I/O Optimization
```cpp
// Always use this at the start of main()
ios::sync_with_stdio(false);
cin.tie(nullptr);

// For even faster I/O (when not mixing cin/cout with scanf/printf)
#define FASTIO ios::sync_with_stdio(0); cin.tie(0); cout.tie(0);
```

### 2. Common Tricks
- Use `'\n'` instead of `endl` for faster output (unless you need flushing)
- Precompute values that are used repeatedly
- Use appropriate data structures (unordered_map for O(1) average access)
- Break early when possible in loops
- Use bit manipulation for efficiency
- Remember to clear global variables between test cases

### 3. Debugging
```cpp
#ifdef LOCAL
#define debug(...) cerr << "[" << #__VA_ARGS__ ": " << (__VA_ARGS__) << "]\n"
#else
#define debug(...) 42
#endif

// Usage:
debug("x = ", x, ", y = ", y);
```

### 4. Common Pitfalls to Watch For
- Integer overflow (use long long when needed)
- Off-by-one errors in loops and arrays
- Forgetting to clear data structures between test cases
- Not handling empty input cases
- Using inefficient algorithms when better ones exist

## Frequently Used STL Algorithms

### Sorting
```cpp
sort(v.begin(), v.end());                    // ascending
sort(v.rbegin(), v.rend());                  // descending
sort(v.begin(), v.end(), greater<>());       // descending
stable_sort(v.begin(), v.end());             // stable sort
partial_sort(v.begin(), v.begin()+k, v.end()); // first k elements sorted
```

### Searching
```cpp
auto it = lower_bound(v.begin(), v.end(), x); // first >= x
auto it = upper_bound(v.begin(), v.end(), x); // first > x
bool found = binary_search(v.begin(), v.end(), x); // exists
```

### Manipulation
```cpp
reverse(v.begin(), v.end());                 // reverse
random_shuffle(v.begin(), v.end());          // shuffle (C++11: shuffle)
unique(v.begin(), v.end());                  // remove consecutive duplicates
v.erase(unique(v.begin(), v.end()), v.end()); // erase duplicates
rotate(v.begin(), v.begin()+k, v.end());     // rotate left by k
```

### Accumulation
```cpp
int sum = accumulate(v.begin(), v.end(), 0);
int product = accumulate(v.begin(), v.end(), 1, multiplies<int>());
int count = count(v.begin(), v.end(), x);
int count_if = count_if(v.begin(), v.end(), [](int x){ return x > 0; });
```

## Mathematical Formulas

### Combinatorics
- nPm = n! / (n-m)!
- nCm = n! / (m! * (n-m)!)
- Stars and bars: C(n+k-1, k-1) ways to put n identical items into k distinct boxes
- Catalan numbers: C(2n, n) / (n+1)

### Geometry
- Distance between points: sqrt((x2-x1)² + (y2-y1)²)
- Cross product: (x1,y2) × (x2,y2) = x1*y2 - y1*x2
- Dot product: (x1,y1) · (x2,y2) = x1*x2 + y1*y2
- Area of triangle: |cross(b-a, c-a)| / 2

### Number Theory
- Euler's totient: φ(n) = n × ∏(1-1/p) for all prime factors p of n
- Number of divisors: if n = p1^a1 × p2^a2 × ... × pk^ak, then d(n) = (a1+1)(a2+1)...(ak+1)
- Sum of divisors: σ(n) = ∏(p^(a+1)-1)/(p-1) for all prime factors p^a of n

## Remember
1. Always test with sample inputs
2. Consider edge cases (empty input, single element, large values)
3. Verify complexity matches constraints
4. Clean up code before submitting (remove debug prints)
5. Stay calm and think before coding!

Good luck in your competitions! 🚀