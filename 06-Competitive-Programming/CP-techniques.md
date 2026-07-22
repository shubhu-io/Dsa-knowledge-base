# Competitive Programming Techniques

## Essential Algorithms and Techniques for Competitive Programming

This document covers essential algorithms, data structures, and techniques that are frequently used in competitive programming contests.

---

## Table of Contents
1. [Mathematical Techniques](#mathematical-techniques)
2. [Bit Manipulation](#bit-manipulation)
3. [String Algorithms](#string-algorithms)
4. [Graph Algorithms](#graph-algorithms)
5. [Data Structures](#data-structures)
6. [Dynamic Programming Techniques](#dynamic-programming-techniques)
7. [Greedy Algorithms](#greedy-algorithms)
8. [Divide and Conquer](#divide-and-conquer)
9. [Advanced Techniques](#advanced-techniques)

---

## Mathematical Techniques

### Modular Arithmetic
```cpp
// Modular exponentiation (binary exponentiation)
long long mod_exp(long long base, long long exp, long long mod) {
    long long result = 1;
    base %= mod;
    while (exp > 0) {
        if (exp & 1) result = (result * base) % mod;
        base = (base * base) % mod;
        exp >>= 1;
    }
    return result;
}

// Modular inverse (when mod is prime)
long long mod_inverse(long long a, long long mod) {
    return mod_exp(a, mod - 2, mod); // Fermat's little theorem
}

// Chinese Remainder Theorem (for coprime moduli)
long long chinese_remainder(vector<int> mods, vector<int> rems) {
    long long prod = 1;
    for (int m : mods) prod *= m;
    
    long long result = 0;
    for (int i = 0; i < mods.size(); i++) {
        long long p = prod / mods[i];
        long long inv = mod_inverse(p, mods[i]);
        result = (result + rems[i] * inv * p) % prod;
    }
    return (result + prod) % prod;
}
```

### Number Theory
```cpp
// Sieve of Eratosthenes (prime generation)
vector<bool> sieve(int n) {
    vector<bool> is_prime(n + 1, true);
    is_prime[0] = is_prime[1] = false;
    for (int i = 2; i * i <= n; i++) {
        if (is_prime[i]) {
            for (int j = i * i; j <= n; j += i) {
                is_prime[j] = false;
            }
        }
    }
    return is_prime;
}

// Prime factorization
vector<pair<int, int>> factorize(int n) {
    vector<pair<int, int>> factors;
    for (int i = 2; i * i <= n; i++) {
        if (n % i == 0) {
            int count = 0;
            while (n % i == 0) {
                n /= i;
                count++;
            }
            factors.push_back({i, count});
        }
    }
    if (n > 1) factors.push_back({n, 1});
    return factors;
}

// Euler's Totient Function
int phi(int n) {
    int result = n;
    for (int i = 2; i * i <= n; i++) {
        if (n % i == 0) {
            while (n % i == 0) n /= i;
            result -= result / i;
        }
    }
    if (n > 1) result -= result / n;
    return result;
}
```

### Combinatorics
```cpp
// Precompute factorials and inverse factorials for nCr
const int MAXN = 1000000;
const long long MOD = 1000000007;
long long fact[MAXN + 1], inv_fact[MAXN + 1];

void precompute_factorials() {
    fact[0] = 1;
    for (int i = 1; i <= MAXN; i++) {
        fact[i] = fact[i - 1] * i % MOD;
    }
    inv_fact[MAXN] = mod_exp(fact[MAXN], MOD - 2, MOD);
    for (int i = MAXN; i > 0; i--) {
        inv_fact[i - 1] = inv_fact[i] * i % MOD;
    }
}

// nCr % MOD
long long nCr(int n, int r) {
    if (r < 0 || r > n) return 0;
    return fact[n] * inv_fact[r] % MOD * inv_fact[n - r] % MOD;
}
```

---

## Bit Manipulation

### Basic Operations
```cpp
// Check if k-th bit is set
bool is_set(int n, int k) {
    return (n >> k) & 1;
}

// Set k-th bit
int set_bit(int n, int k) {
    return n | (1 << k);
}

// Clear k-th bit
int clear_bit(int n, int k) {
    return n & ~(1 << k);
}

// Toggle k-th bit
int toggle_bit(int n, int k) {
    return n ^ (1 << k);
}

// Count set bits (builtin)
int popcount(int n) {
    return __builtin_popcount(n);
}

// Count trailing zeros
int ctz(int n) {
    return n ? __builtin_ctz(n) : 32;
}

// Count leading zeros
int clz(int n) {
    return n ? __builtin_clz(n) : 32;
}
```

### Bitmask DP Techniques
```cpp
// Iterate through all subsets of a mask
for (int submask = mask; submask > 0; submask = (submask - 1) & mask) {
    // submask is a subset of mask
}

// Iterate through all supersets of a mask (within LIMIT)
for (int supermask = mask; supermask < LIMIT; supermask = (supermask + 1) | mask) {
    // supermask is a superset of mask
}

// Find lowest set bit
int lowest_bit(int n) {
    return n & -n;
}

// Turn off lowest set bit
int remove_lowest_bit(int n) {
    return n & (n - 1);
}
```

---

## String Algorithms

### String Hashing (Rabin-Karp)
```cpp
const long long BASE1 = 91138233;
const long long BASE2 = 97266353;
const long long MOD1 = 972663749;
const long long MOD2 = 1000000009;

vector<long long> pow1, pow2;
vector<long long> pref1, pref2;

void precompute_powers(int n) {
    pow1.assign(n + 1, 1);
    pow2.assign(n + 1, 1);
    for (int i = 1; i <= n; i++) {
        pow1[i] = pow1[i - 1] * BASE1 % MOD1;
        pow2[i] = pow2[i - 1] * BASE2 % MOD2;
    }
}

void build_hash(const string& s) {
    int n = s.size();
    pref1.assign(n + 1, 0);
    pref2.assign(n + 1, 0);
    for (int i = 0; i < n; i++) {
        pref1[i + 1] = (pref1[i] * BASE1 + s[i]) % MOD1;
        pref2[i + 1] = (pref2[i] * BASE2 + s[i]) % MOD2;
    }
}

pair<long long, long long> get_hash(int l, int r) { // [l, r) 0-indexed
    long long hash1 = (pref1[r] - pref1[l] * pow1[r - l] % MOD1 + MOD1) % MOD1;
    long long hash2 = (pref2[r] - pref2[l] * pow2[r - l] % MOD2 + MOD2) % MOD2;
    return {hash1, hash2};
}
```

### Z-Algorithm (Pattern Matching)
```cpp
vector<int> z_function(const string& s) {
    int n = s.size();
    vector<int> z(n);
    int l = 0, r = 0;
    for (int i = 1; i < n; i++) {
        if (i <= r) 
            z[i] = min(r - i + 1, z[i - l]);
        while (i + z[i] < n && s[z[i]] == s[i + z[i]])
            z[i]++;
        if (i + z[i] - 1 > r) {
            l = i;
            r = i + z[i] - 1;
        }
    }
    return z;
}

// Pattern matching: find all occurrences of pattern in text
vector<int> find_occurrences(const string& pattern, const string& text) {
    string combined = pattern + "#" + text;
    vector<int> z = z_function(combined);
    vector<int> occurrences;
    int pattern_size = pattern.size();
    
    for (int i = pattern_size + 1; i < combined.size(); i++) {
        if (z[i] == pattern_size) {
            occurrences.push_back(i - pattern_size - 1);
        }
    }
    return occurrences;
}
```

### KMP Algorithm (Knuth-Morris-Pratt)
```cpp
vector<int> prefix_function(const string& s) {
    int n = s.size();
    vector<int> pi(n);
    for (int i = 1; i < n; i++) {
        int j = pi[i - 1];
        while (j > 0 && s[i] != s[j])
            j = pi[j - 1];
        if (s[i] == s[j])
            j++;
        pi[i] = j;
    }
    return pi;
}

// Pattern matching using KMP
vector<int> kmp_search(const string& pattern, const string& text) {
    string combined = pattern + "#" + text;
    vector<int> pi = prefix_function(combined);
    vector<int> occurrences;
    int pattern_size = pattern.size();
    
    for (int i = pattern_size + 1; i < combined.size(); i++) {
        if (pi[i] == pattern_size) {
            occurrences.push_back(i - 2 * pattern_size);
        }
    }
    return occurrences;
}
```

### Manacher's Algorithm (Longest Palindromic Substring)
```cpp
string manacher(const string& s) {
    string t = "#";
    for (char c : s) {
        t += c;
        t += '#';
    }
    
    int n = t.size();
    vector<int> p(n);
    int l = 0, r = -1;
    
    for (int i = 0; i < n; i++) {
        int k = (i > r) ? 1 : min(p[l + r - i], r - i + 1);
        while (0 <= i - k && i + k < n && t[i - k] == t[i + k]) {
            k++;
        }
        p[i] = k--;
        if (i + k > r) {
            l = i - k;
            r = i + k;
        }
    }
    
    int max_len = 0, center = 0;
    for (int i = 0; i < n; i++) {
        if (p[i] > max_len) {
            max_len = p[i];
            center = i;
        }
    }
    
    int start = (center - max_len + 1) / 2;
    return s.substr(start, max_len - 1);
}
```

### Suffix Array (O(n log n))
```cpp
vector<int> build_suffix_array(const string& s) {
    string s2 = s + char(0); // Add sentinel
    int n = s2.size();
    vector<int> p(n), c(n), cnt(max(256, n)), pn(n), cn(n);
    
    // k = 0: sort by first character
    for (int i = 0; i < n; i++) cnt[s2[i]]++;
    for (int i = 1; i < 256; i++) cnt[i] += cnt[i - 1];
    for (int i = 0; i < n; i++) p[--cnt[s2[i]]] = i;
    
    c[p[0]] = 0;
    int classes = 1;
    for (int i = 1; i < n; i++) {
        if (s2[p[i]] != s2[p[i - 1]]) classes++;
        c[p[i]] = classes - 1;
    }
    
    // Doubling
    for (int h = 0; (1 << h) < n; h++) {
        // Shift
        for (int i = 0; i < n; i++) {
            pn[i] = p[i] - (1 << h);
            if (pn[i] < 0) pn[i] += n;
        }
        
        // Count sort by second half
        fill(cnt.begin(), cnt.end(), 0);
        for (int i = 0; i < n; i++) cnt[c[pn[i]]]++;
        for (int i = 1; i < classes; i++) cnt[i] += cnt[i - 1];
        for (int i = n - 1; i >= 0; i--) p[--cnt[c[pn[i]]]] = pn[i];
        
        // Re-classify
        cn[p[0]] = 0;
        classes = 1;
        for (int i = 1; i < n; i++) {
            pair<int, int> cur = {c[p[i]], c[(p[i] + (1 << h)) % n]};
            pair<int, int> prev = {c[p[i - 1]], c[(p[i - 1] + (1 << h)) % n]};
            if (cur != prev) classes++;
            cn[p[i]] = classes - 1;
        }
        swap(c, cn);
    }
    
    // Remove sentinel position
    vector<int> result;
    for (int i = 0; i < n; i++) {
        if (p[i] > 0) result.push_back(p[i]);
    }
    return result;
}
```

---

## Graph Algorithms

### Depth-First Search (DFS)
```cpp
vector<vector<int>> adj; // adjacency list
vector<bool> visited;

void dfs(int v) {
    visited[v] = true;
    // Process vertex v
    for (int to : adj[v]) {
        if (!visited[to]) {
            dfs(to);
        }
    }
}

// Iterative DFS (to avoid stack overflow)
void dfs_iterative(int start) {
    stack<int> st;
    st.push(start);
    vector<bool> visited(adj.size(), false);
    
    while (!st.empty()) {
        int v = st.top();
        st.pop();
        if (visited[v]) continue;
        visited[v] = true;
        // Process vertex v
        
        for (int to : adj[v]) {
            if (!visited[to]) {
                st.push(to);
            }
        }
    }
}
```

### Breadth-First Search (BFS)
```cpp
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

### Dijkstra's Algorithm (Shortest Path with Non-negative Weights)
```cpp
typedef pair<long long, int> pli; // (distance, vertex)

vector<long long> dijkstra(int start) {
    int n = adj.size();
    vector<long long> dist(n, LLONG_MAX);
    priority_queue<pli, vector<pli>, greater<pli>> pq;
    
    dist[start] = 0;
    pq.push({0, start});
    
    while (!pq.empty()) {
        long long d = pq.top().first;
        int v = pq.top().second;
        pq.pop();
        
        if (d != dist[v]) continue;
        
        for (auto edge : adj[v]) {
            int to = edge.first;
            long long weight = edge.second;
            
            if (dist[v] + weight < dist[to]) {
                dist[to] = dist[v] + weight;
                pq.push({dist[to], to});
            }
        }
    }
    return dist;
}
```

### Bellman-Ford Algorithm (Shortest Path with Negative Weights)
```cpp
struct Edge {
    int u, v;
    long long w;
};

vector<long long> bellman_ford(int n, vector<Edge>& edges, int start) {
    vector<long long> dist(n, LLONG_MAX);
    dist[start] = 0;
    
    // Relax edges n-1 times
    for (int i = 0; i < n - 1; i++) {
        for (Edge e : edges) {
            if (dist[e.u] != LLONG_MAX && dist[e.u] + e.w < dist[e.v]) {
                dist[e.v] = dist[e.u] + e.w;
            }
        }
    }
    
    // Check for negative cycles
    for (Edge e : edges) {
        if (dist[e.u] != LLONG_MAX && dist[e.u] + e.w < dist[e.v]) {
            // Negative cycle detected
            return vector<long long>(n, LLONG_MIN); // Indicates negative cycle
        }
    }
    
    return dist;
}
```

### Floyd-Warshall Algorithm (All-Pairs Shortest Path)
```cpp
vector<vector<long long>> floyd_warshall(vector<vector<long long>>& dist) {
    int n = dist.size();
    
    for (int k = 0; k < n; k++) {
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                if (dist[i][k] != LLONG_MAX && dist[k][j] != LLONG_MAX) {
                    dist[i][j] = min(dist[i][j], dist[i][k] + dist[k][j]);
                }
            }
        }
    }
    return dist;
}
```

### Topological Sort (Kahn's Algorithm)
```cpp
vector<int> topological_sort() {
    int n = adj.size();
    vector<int> indegree(n, 0);
    vector<int> result;
    
    // Calculate indegrees
    for (int u = 0; u < n; u++) {
        for (int v : adj[u]) {
            indegree[v]++;
        }
    }
    
    // Queue for nodes with zero indegree
    queue<int> q;
    for (int i = 0; i < n; i++) {
        if (indegree[i] == 0) {
            q.push(i);
        }
    }
    
    // Process nodes
    while (!q.empty()) {
        int u = q.front();
        q.pop();
        result.push_back(u);
        
        for (int v : adj[u]) {
            indegree[v]--;
            if (indegree[v] == 0) {
                q.push(v);
            }
        }
    }
    
    // Check if topological sort is possible (no cycles)
    if (result.size() != n) {
        return {}; // Cycle detected
    }
    return result;
}
```

### Disjoint Set Union (DSU / Union-Find)
```cpp
struct DSU {
    vector<int> parent, rank, size;
    int components;
    
    DSU(int n) {
        parent.resize(n);
        rank.assign(n, 0);
        size.assign(n, 1);
        components = n;
        for (int i = 0; i < n; i++) {
            parent[i] = i;
        }
    }
    
    int find(int x) {
        if (x != parent[x]) {
            parent[x] = find(parent[x]);
        }
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
    
    bool same_set(int x, int y) {
        return find(x) == find(y);
    }
    
    int get_size(int x) {
        return size[find(x)];
    }
    
    int get_components() {
        return components;
    }
};
```

### Minimum Spanning Tree (Kruskal's Algorithm)
```cpp
struct Edge {
    int u, v;
    long long w;
    bool operator<(const Edge& other) const {
        return w < other.w;
    }
};

long long kruskal(vector<Edge>& edges, int n) {
    sort(edges.begin(), edges.end());
    DSU dsu(n);
    long long mst_weight = 0;
    
    for (Edge e : edges) {
        if (dsu.unite(e.u, e.v)) {
            mst_weight += e.w;
        }
    }
    return mst_weight;
}
```

### Minimum Spanning Tree (Prim's Algorithm)
```cpp
long long prim(vector<vector<pair<int, long long>>>& adj) {
    int n = adj.size();
    vector<bool> used(n, false);
    vector<long long> min_edge(n, LLONG_MAX);
    priority_queue<pair<long long, int>, vector<pair<long long, int>>, greater<pair<long long, int>>> pq;
    
    min_edge[0] = 0;
    pq.push({0, 0});
    long long mst_weight = 0;
    
    while (!pq.empty()) {
        int v = pq.top().second;
        long long w = pq.top().first;
        pq.pop();
        
        if (used[v]) continue;
        used[v] = true;
        mst_weight += w;
        
        for (auto edge : adj[v]) {
            int to = edge.first;
            long long weight = edge.second;
            if (!used[to] && weight < min_edge[to]) {
                min_edge[to] = weight;
                pq.push({weight, to});
            }
        }
    }
    return mst_weight;
}
```

---

## Data Structures

### Stack
```cpp
// Standard library stack
stack<int> st;
st.push(value);
st.pop();
int top = st.top();
bool empty = st.empty();
// O(1) for all operations
```

### Queue
```cpp
// Standard library queue
queue<int> q;
q.push(value);
q.pop();
int front = q.front();
bool empty = q.empty();
// O(1) for all operations
```

### Priority Queue
```cpp
// Max heap (default)
priority_queue<int> max_heap;
max_heap.push(value);
max_heap.pop();
int top = max_heap.top();
// O(log n) for push/pop, O(1) for top

// Min heap
priority_queue<int, vector<int>, greater<int>> min_heap;
min_heap.push(value);
min_heap.pop();
int top = min_heap.top();
```

### Double-Ended Queue (Deque)
```cpp
// Standard library deque
deque<int> dq;
dq.push_back(value);
dq.push_front(value);
dq.pop_back();
dq.pop_front();
int front = dq.front();
int back = dq.back();
// O(1) for all operations
```

### Set / Multiset (Balanced BST)
```cpp
// Set (unique elements, sorted)
set<int> s;
s.insert(value);
s.erase(value);
bool exists = s.count(value) > 0;
auto it = s.lower_bound(value); // first element >= value
auto it2 = s.upper_bound(value); // first element > value
// O(log n) for operations

// Multiset (allows duplicates)
multiset<int> ms;
ms.insert(value);
ms.erase(ms.find(value)); // remove one occurrence
ms.erase(value); // remove all occurrences
size_t count = ms.count(value);
// O(log n) for operations
```

### Map / Multimap (Key-Value Store)
```cpp
// Map (unique keys, sorted)
map<int, int> m;
m[key] = value;
m.insert({key, value});
auto it = m.find(key);
if (it != m.end()) {
    // found
}
int count = m.count(key); // 0 or 1
// O(log n) for operations

// Multimap (allows duplicate keys)
multimap<int, int> mm;
mm.insert({key, value});
auto range = mm.equal_range(key); // returns pair of iterators
// O(log n) for operations
```

### Unordered Set / Map (Hash Table)
```cpp
// Unordered set (average O(1), worst O(n))
unordered_set<int> us;
us.insert(value);
us.erase(value);
bool exists = us.count(value) > 0;
// Average O(1) for operations

// Unordered map
unordered_map<int, int> um;
um[key] = value;
auto it = um.find(key);
if (it != um.end()) {
    // found
}
// Average O(1) for operations
```

### Binary Indexed Tree (Fenwick Tree)
```cpp
// 1-indexed Fenwick Tree for prefix sums
struct FenwickTree {
    int n;
    vector<long long> bit;
    
    FenwickTree(int n) {
        this->n = n;
        bit.assign(n + 1, 0);
    }
    
    FenwickTree(vector<long long> a) // builds from array
        : FenwickTree((int)a.size()) {
        for (size_t i = 0; i < a.size(); i++)
            add(i, a[i]);
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
```

### Segment Tree
```cpp
// Segment Tree for range sum queries and point updates
struct SegmentTree {
    int n;
    vector<long long> tree;
    
    SegmentTree(int n) {
        this->n = n;
        tree.assign(4 * n, 0);
    }
    
    SegmentTree(vector<long long>& a) 
        : SegmentTree((int)a.size()) {
        build(a, 0, 0, n - 1);
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
    
    long long query(int v, int tl, int tr, int l, int r) {
        if (l > r) 
            return 0;
        if (l == tl && r == tr)
            return tree[v];
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
```

### Trie (Prefix Tree)
```cpp
struct TrieNode {
    bool is_end;
    unordered_map<char, TrieNode*> children;
    
    TrieNode() : is_end(false) {}
};

class Trie {
private:
    TrieNode* root;
public:
    Trie() {
        root = new TrieNode();
    }
    
    void insert(string word) {
        TrieNode* curr = root;
        for (char c : word) {
            if (curr->children.find(c) == curr->children.end()) {
                curr->children[c] = new TrieNode();
            }
            curr = curr->children[c];
        }
        curr->is_end = true;
    }
    
    bool search(string word) {
        TrieNode* curr = root;
        for (char c : word) {
            if (curr->children.find(c) == curr->children.end()) {
                return false;
            }
            curr = curr->children[c];
        }
        return curr->is_end;
    }
    
    bool startsWith(string prefix) {
        TrieNode* curr = root;
        for (char c : prefix) {
            if (curr->children.find(c) == curr->children.end()) {
                return false;
            }
            curr = curr->children[c];
        }
        return true;
    }
};
```

---

## Dynamic Programming Techniques

### Knapsack Optimization Techniques

#### 0/1 Knapsack (Space Optimized)
```cpp
int knapsack_01(vector<int>& weights, vector<int>& values, int capacity) {
    vector<int> dp(capacity + 1, 0);
    for (int i = 0; i < weights.size(); i++) {
        for (int w = capacity; w >= weights[i]; w--) {
            dp[w] = max(dp[w], dp[w - weights[i]] + values[i]);
        }
    }
    return dp[capacity];
}
```

#### Unbounded Knapsack
```cpp
int knapsack_unbounded(vector<int>& weights, vector<int>& values, int capacity) {
    vector<int> dp(capacity + 1, 0);
    for (int w = 0; w <= capacity; w++) {
        for (int i = 0; i < weights.size(); i++) {
            if (weights[i] <= w) {
                dp[w] = max(dp[w], dp[w - weights[i]] + values[i]);
            }
        }
    }
    return dp[capacity];
}
```

#### Complete Knapsack (Multiple instances with limits)
```cpp
int knapsack_bounded(vector<int>& weights, vector<int>& values, vector<int>& counts, int capacity) {
    vector<int> dp(capacity + 1, 0);
    for (int i = 0; i < weights.size(); i++) {
        int w = weights[i], v = values[i], c = counts[i];
        // Binary optimization: split into powers of 2
        int k = 1;
        while (c > 0) {
            int take = min(k, c);
            int weight = take * w;
            int value = take * v;
            for (int cap = capacity; cap >= weight; cap--) {
                dp[cap] = max(dp[cap], dp[cap - weight] + value);
            }
            c -= take;
            k *= 2;
        }
    }
    return dp[capacity];
}
```

### DP on Trees
```cpp
// Tree DP: Maximum sum of non-adjacent nodes (House Robber III on tree)
struct TreeNode {
    int val;
    TreeNode* left;
    TreeNode* right;
    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
};

pair<int, int> dfs(TreeNode* node) {
    if (!node) return {0, 0};
    
    auto left = dfs(node->left);
    auto right = dfs(node->right);
    
    // include current node: we can't include children
    int include = node->val + left.second + right.second;
    
    // exclude current node: we can choose max of include/exclude for children
    int exclude = max(left.first, left.second) + max(right.first, right.second);
    
    return {include, exclude};
}

int rob(TreeNode* root) {
    auto result = dfs(root);
    return max(result.first, result.second);
}
```

### DP with Bitmask (TSP - Traveling Salesperson Problem)
```cpp
int tsp(vector<vector<int>>& dist) {
    int n = dist.size();
    int full_mask = (1 << n) - 1;
    vector<vector<int>> dp(1 << n, vector<int>(n, INT_MAX));
    
    // Base case: starting at city 0
    dp[1][0] = 0;
    
    for (int mask = 1; mask < (1 << n); mask++) {
        for (int u = 0; u < n; u++) {
            if (!(mask & (1 << u))) continue; // u not in mask
            if (dp[mask][u] == INT_MAX) continue;
            
            for (int v = 0; v < n; v++) {
                if (mask & (1 << v)) continue; // v already visited
                int new_mask = mask | (1 << v);
                dp[new_mask][v] = min(dp[new_mask][v], dp[mask][u] + dist[u][v]);
            }
        }
    }
    
    // Return to start
    int ans = INT_MAX;
    for (int i = 1; i < n; i++) {
        ans = min(ans, dp[full_mask][i] + dist[i][0]);
    }
    return ans;
}
```

### Divide and Conquer Optimization (for DP)
Applicable when: dp[i][j] = min_{k<j} (dp[i-1][k] + C[k][j]) and opt[i][j-1] <= opt[i][j]

```cpp
// Divide and Conquer Optimization
void compute(int i, int l, int r, int optl, int optr, vector<vector<long long>>& dp, 
             function<long long(int, int)> cost) {
    if (l > r) return;
    int mid = (l + r) >> 1;
    pair<long long, int> best = {LLONG_MAX, -1};
    
    for (int k = optl; k <= min(mid, optr); k++) {
        long long cur = dp[i-1][k] + cost(k, mid);
        if (cur < best.first) {
            best = {cur, k};
        }
    }
    
    dp[i][mid] = best.first;
    int opt = best.second;
    
    compute(i, l, mid-1, optl, opt, dp, cost);
    compute(i, mid+1, r, opt, optr, dp, cost);
}

// Usage for DP optimization:
// compute(i, 0, n-1, 0, n-1, dp, cost_function);
```

### Convex Hull Trick
Useful for DP of form: dp[i] = min_{j<i} (m[j] * x[i] + c[j]) + C[i]

```cpp
struct Line {
    long long m, b;
    long double intersectionX(const Line& other) const {
        return (long double)(other.b - b) / (m - other.m);
    }
};

struct ConvexHullTrick {
    deque<Line> hull;
    
    bool bad(Line l1, Line l2, Line l3) {
        // (b3 - b1)*(m1 - m2) < (b2 - b1)*(m1 - m3)
        return (long double)(l3.b - l1.b) * (l1.m - l2.m) < 
               (long double)(l2.b - l1.b) * (l1.m - l3.m);
    }
    
    void add_line(long long m, long long b) {
        Line l = {m, b};
        while (hull.size() >= 2()end-2, l-- || m;
        while (!hull.empty() && bad(hull[hull.size()-2], hull[hull.size()-1], l)) {
            hull.pop_back();
        }
        hull.push_back(l);
    }
    
    long long query(long long x) {
        while (hull.size() >= 2 && 
               hull[0].m * x + hull[0].b >= hull[1].m * x + hull[1].b) {
            hull.pop_front();
        }
        return hull[0].m * x + hull[0].b;
    }
};
```

---

## Greedy Algorithms

### Activity Selection Problem
```cpp
struct Activity {
    int start, finish;
};

int activity_selection(vector<Activity>& activities) {
    sort(activities.begin(), activities.end(), 
         [](const Activity& a, const Activity& b) {
             return a.finish < b.finish;
         });
    
    int count = 0;
    int last_end = 0;
    
    for (const Activity& act : activities) {
        if (act.start >= last_end) {
            count++;
            last_end = act.finish;
        }
    }
    return count;
}
```

### Huffman Coding
```cpp
struct HuffmanNode {
    char ch;
    int freq;
    HuffmanNode* left;
    HuffmanNode* right;
    
    HuffmanNode(char c, int f) : ch(c), freq(f), left(nullptr), right(nullptr) {}
    HuffmanNode(int f) : ch('\0'), freq(f), left(nullptr), right(nullptr) {}
    
    bool operator<(const HuffmanNode& other) const {
        return freq > other.freq; // min-heap
    }
};

string build_huffman_tree(string text) {
    // Count frequencies
    unordered_map<char, int> freq;
    for (char c : text) freq[c]++;
    
    // Build priority queue
    priority_queue<HuffmanNode*> pq;
    for (auto p : freq) {
        pq.push(new HuffmanNode(p.first, p.second));
    }
    
    // Build tree
    while (pq.size() > 1) {
        HuffmanNode* left = pq.top(); pq.pop();
        HuffmanNode* right = pq.top(); pq.pop();
        HuffmanNode* merged = new HuffmanNode(left->freq + right->freq);
        merged->left = left;
        merged->right = right;
        pq.push(merged);
    }
    
    // Generate codes
    unordered_map<char, string> codes;
    function<void(HuffmanNode*, string)> generate_codes = [&](HuffmanNode* node, string code) {
        if (!node) return;
        if (!node->left && !node->right) { // leaf node
            codes[node->ch] = code;
            return;
        }
        generate_codes(node->left, code + "0");
        generate_codes(node->right, code + "1");
    };
    
    HuffmanNode* root = pq.top();
    generate_codes(root, "");
    
    // Encode text
    string encoded = "";
    for (char c : text) {
        encoded += codes[c];
    }
    return encoded;
}
```

### Fractional Knapsack
```cpp
struct Item {
    int value, weight;
    double ratio;
    
    Item(int v, int w) : value(v), weight(w), ratio((double)v/w) {}
};

double fractional_knapsack(vector<Item>& items, int capacity) {
    sort(items.begin(), items.end(), 
         [](const Item& a, const Item& b) {
             return a.ratio > b.ratio;
         });
    
    double total_value = 0;
    int current_weight = 0;
    
    for (Item item : items) {
        if (current_weight + item.weight <= capacity) {
            total_value += item.value;
            current_weight += item.weight;
        } else {
            int remaining = capacity - current_weight;
            total_value += item.ratio * remaining;
            break;
        }
    }
    return total_value;
}
```

---

## Divide and Conquer

### Merge Sort (Counting Inversions)
```cpp
long long merge_count(vector<int>& arr, int left, int mid, int right) {
    int n1 = mid - left + 1;
    int n2 = right - mid;
    vector<int> left_arr(n1), right_arr(n2);
    
    for (int i = 0; i < n1; i++) left_arr[i] = arr[left + i];
    for (int i = 0; i < n2; i++) right_arr[i] = arr[mid + 1 + i];
    
    int i = 0, j = 0, k = left;
    long long inversions = 0;
    
    while (i < n1 && j < n2) {
        if (left_arr[i] <= right_arr[j]) {
            arr[k++] = left_arr[i++];
        } else {
            arr[k++] = right_arr[j++];
            inversions += (n1 - i); // All remaining elements in left_arr are inversions
        }
    }
    
    while (i < n1) arr[k++] = left_arr[i++];
    while (j < n2) arr[k++] = right_arr[j++];
    
    return inversions;
}

long long merge_sort_count(vector<int>& arr, int left, int right) {
    if (left >= right) return 0;
    int mid = left + (right - left) / 2;
    long long inversions = 0;
    inversions += merge_sort_count(arr, left, mid);
    inversions += merge_sort_count(arr, mid + 1, right);
    inversions += merge_count(arr, left, mid, right);
    return inversions;
}

long long count_inversions(vector<int> arr) {
    return merge_sort_count(arr, 0, arr.size() - 1);
}
```

### Quick Select (Finding K-th Smallest Element)
```cpp
int partition(vector<int>& arr, int low, int high) {
    int pivot = arr[high];
    int i = low - 1;
    
    for (int j = low; j < high; j++) {
        if (arr[j] <= pivot) {
            i++;
            swap(arr[i], arr[j]);
        }
    }
    swap(arr[i + 1], arr[high]);
    return i + 1;
}

int quick_select(vector<int>& arr, int low, int high, int k) {
    if (low <= high) {
        int pi = partition(arr, low, high);
        
        if (pi == k) 
            return arr[pi];
        if (pi > k) 
            return quick_select(arr, low, pi - 1, k);
        return quick_select(arr, pi + 1, high, k);
    }
    return -1; // k is out of bounds
}

// Wrapper function
int kth_smallest(vector<int> arr, int k) {
    return quick_select(arr, 0, arr.size() - 1, k - 1);
}
```

### Binary Search Applications
```cpp
// Standard binary search
int binary_search(vector<int>& arr, int target) {
    int left = 0, right = arr.size() - 1;
    while (left <= right) {
        int mid = left + (right - left) / 2;
        if (arr[mid] == target) return mid;
        if (arr[mid] < target) left = mid + 1;
        else right = mid - 1;
    }
    return -1;
}

// Lower bound (first element >= target)
int lower_bound(vector<int>& arr, int target) {
    int left = 0, right = arr.size();
    while (left < right) {
        int mid = left + (right - left) / 2;
        if (arr[mid] < target) {
            left = mid + 1;
        } else {
            right = mid;
        }
    }
    return left;
}

// Upper bound (first element > target)
int upper_bound(vector<int>& arr, int target) {
    int left = 0, right = arr.size();
    while (left < right) {
        int mid = left + (right - left) / 2;
        if (arr[mid] <= target) {
            left = mid + 1;
        } else {
            right = mid;
        }
    }
    return left;
}

// Find first occurrence
int first_occurrence(vector<int>& arr, int target) {
    int idx = lower_bound(arr, target);
    if (idx < arr.size() && arr[idx] == target) return idx;
    return -1;
}

// Find last occurrence
int last_occurrence(vector<int>& arr, int target) {
    int idx = upper_bound(arr, target) - 1;
    if (idx >= 0 && arr[idx] == target) return idx;
    return -1;
}

// Count occurrences
int count_occurrences(vector<int>& arr, int target) {
    int first = lower_bound(arr, target);
    int last = upper_bound(arr, target);
    return last - first;
}
```

---

## Advanced Techniques

### Mo's Algorithm (Query Optimization on Arrays)
```cpp
// Mo's algorithm for answering range queries efficiently
struct Query {
    int l, r, idx;
    int block_size;
    
    bool operator<(const Query& other) const {
        if (l / block_size != other.l / block_size) 
            return l / block_size < other.l / block_size;
        return (l / block_size % 2 == 0) ? (r < other.r) : (r > other.r);
    }
};

vector<int> mo_algorithm(vector<int>& arr, vector<Query>& queries) {
    int n = arr.size();
    int q = queries.size();
    int block_size = sqrt(n);
    
    // Set block size for comparison
    for (Query& q : queries) {
        q.block_size = block_size;
    }
    
    sort(queries.begin(), queries.end());
    
    vector<int> answers(q);
    vector<int> freq(1000001, 0); // assuming values are in range [0, 1000000]
    int current_l = 0, current_r = -1;
    int current_answer = 0;
    
    auto add = [&](int position) {
        int val = arr[position];
        freq[val]++;
        if (freq[val] == 1) current_answer++; // new distinct element
    };
    
    auto remove = [&](int position) {
        int val = arr[position];
        freq[val]--;
        if (freq[val] == 0) current_answer--; // one less distinct element
    };
    
    for (const Query& q : queries) {
        while (current_l > q.l) add(--current_l);
        while (current_r < q.r) add(++current_r);
        while (current_l < q.l) remove(current_l++);
        while (current_r > q.r) remove(current_r--);
        
        answers[q.idx] = current_answer;
    }
    
    return answers;
}
```

### Square Root Decomposition
```cpp
// Square root decomposition for range sum queries and point updates
struct SqrtDecomposition {
    int n;
    int block_size;
    vector<int> arr;
    vector<int> block_sums;
    
    SqrtDecomposition(vector<int>& input) {
        n = input.size();
        block_size = sqrt(n) + 1;
        arr = input;
        block_sums.assign((n + block_size - 1) / block_size, 0);
        
        for (int i = 0; i < n; i++) {
            block_sums[i / block_size] += arr[i];
        }
    }
    
    void update(int idx, int val) {
        int block_idx = idx / block_size;
        block_sums[block_idx] += val - arr[idx];
        arr[idx] = val;
    }
    
    int query(int l, int r) {
        int sum = 0;
        int start_block = l / block_size;
        int end_block = r / block_size;
        
        if (start_block == end_block) {
            for (int i = l; i <= r; i++) {
                sum += arr[i];
            }
        } else {
            // Process partial first block
            for (int i = l; i < (start_block + 1) * block_size; i++) {
                sum += arr[i];
            }
            
            // Process full blocks
            for (int b = start_block + 1; b < end_block; b++) {
                sum += block_sums[b];
            }
            
            // Process partial last block
            for (int i = end_block * block_size; i <= r; i++) {
                sum += arr[i];
            }
        }
        return sum;
    }
};
```

### Binary Lifting (for LCA and Ancestor Queries)
```cpp
// Binary Lifting for Lowest Common Ancestor
struct BinaryLifting {
    int n, LOG;
    vector<vector<int>> up;
    vector<int> depth;
    vector<vector<int>> adj;
    
    BinaryLifting(int n) : n(n) {
        LOG = ceil(log2(n)) + 1;
        up.assign(n, vector<int>(LOG, -1));
        depth.assign(n, 0);
        adj.assign(n, vector<int>());
    }
    
    void add_edge(int u, int v) {
        adj[u].push_back(v);
        adj[v].push_back(u);
    }
    
    void dfs(int v, int p) {
        up[v][0] = p;
        for (int i = 1; i < LOG; i++) {
            if (up[v][i-1] != -1) {
                up[v][i] = up[up[v][i-1]][i-1];
            } else {
                up[v][i] = -1;
            }
        }
        
        for (int to : adj[v]) {
            if (to == p) continue;
            depth[to] = depth[v] + 1;
            dfs(to, v);
        }
    }
    
    void preprocess(int root = 0) {
        dfs(root, -1);
    }
    
    int lca(int u, int v) {
        if (depth[u] < depth[v]) swap(u, v);
        
        // Lift u up to depth of v
        int diff = depth[u] - depth[v];
        for (int i = 0; i < LOG; i++) {
            if (diff & (1 << i)) {
                u = up[u][i];
            }
        }
        
        if (u == v) return u;
        
        // Lift both up until their parents meet
        for (int i = LOG - 1; i >= 0; i--) {
            if (up[u][i] != up[v][i]) {
                u = up[u][i];
                v = up[v][i];
            }
        }
        
        return up[u][0];
    }
    
    int kth_ancestor(int v, int k) {
        for (int i = 0; i < LOG; i++) {
            if (k & (1 << i)) {
                v = up[v][i];
                if (v == -1) break;
            }
        }
        return v;
    }
};
```

### Persistent Data Structures (Persistent Segment Tree)
```cpp
// Persistent Segment Tree for k-th order statistics
struct PersistentSegTree {
    struct Node {
        int left, right;
        int sum;
        Node() : left(-1), right(-1), sum(0) {}
    };
    
    vector<Node> tree;
    vector<int> roots;
    int n;
    
    PersistentSegTree(int size) : n(size) {
        tree.push_back(Node()); // null node
        roots.push_back(0); // empty tree
    }
    
    int build(int l, int r) {
        int idx = tree.size();
        tree.push_back(Node());
        if (l != r) {
            int mid = (l + r) / 2;
            tree[idx].left = build(l, mid);
            tree[idx].right = build(mid + 1, r);
        }
        return idx;
    }
    
    int update(int prev_root, int pos, int value, int l, int r) {
        int idx = tree.size();
        tree.push_back(tree[prev_root]); // copy previous node
        tree[idx].sum += value;
        
        if (l != r) {
            int mid = (l + r) / 2;
            if (pos <= mid) {
                tree[idx].left = update(tree[prev_root].left, pos, value, l, mid);
            } else {
                tree[idx].right = update(tree[prev_root].right, pos, value, mid + 1, r);
            }
        }
        return idx;
    }
    
    int query(int left_root, int right_root, int k, int l, int r) {
        if (l == r) return l;
        
        int left_sum = tree[tree[right_root].left].sum - tree[tree[left_root].left].sum;
        int mid = (l + r) / 2;
        
        if (k <= left_sum) {
            return query(tree[left_root].left, tree[right_root].left, k, l, mid);
        } else {
            return query(tree[left_root].right, tree[right_root].right, k - left_sum, mid + 1, r);
        }
    }
};
```

---

## String Algorithms (Advanced)

### Suffix Automaton
```cpp
struct SuffixAutomaton {
    struct State {
        int len, link;
        map<char, int> next;
        State(int l = 0, int lnk = -1) : len(l), link(lnk) {}
    };
    
    vector<State> st;
    int size, last;
    
    SuffixAutomaton(string s) {
        st.reserve(2 * s.length());
        st.push_back(State()); // initial state
        size = 1;
        last = 0;
        
        for (char c : s) {
            extend(c);
        }
    }
    
    void extend(char c) {
        int cur = size++;
        st.push_back(State(st[last].len + 1));
        int p = last;
        while (p != -1 && !st[p].next.count(c)) {
            st[p].next[c] = cur;
            p = st[p].link;
        }
        if (p == -1) {
            st[cur].link = 0;
        } else {
            int q = st[p].next[c];
            if (st[p].len + 1 == st[q].len) {
                st[cur].link = q;
            } else {
                int clone = size++;
                st.push_back(State(st[p].len + 1, st[q].link));
                st[clone].next = st[q].next;
                while (p != -1 && st[p].next[c] == q) {
                    st[p].next[c] = clone;
                    p = st[p].link;
                }
                st[q].link = st[cur].link = clone;
            }
        }
        last = cur;
    }
    
    // Check if string t is a substring of s
    bool contains(string t) {
        int v = 0;
        for (char c : t) {
            if (!st[v].next.count(c)) return false;
            v = st[v].next[c];
        }
        return true;
    }
    
    // Number of different substrings
    long long count_substrings() {
        long long result = 0;
        for (int i = 1; i < size; i++) {
            result += st[i].len - st[st[i].link].len;
        }
        return result;
    }
};
```

### Aho-Corasick Algorithm (Multiple Pattern Matching)
```cpp
struct AhoCorasick {
    struct Node {
        map<char, int> next;
        int link = -1;
        int output = -1; // index of pattern that ends here, -1 if none
        vector<int> outputs; // all patterns ending here (including via suffix links)
    };
    
    vector<Node> trie;
    
    AhoCorasick(vector<string>& patterns) {
        trie.push_back(Node()); // root
        
        // Build trie
        for (int i = 0; i < patterns.size(); i++) {
            int v = 0;
            for (char c : patterns[i]) {
                if (!trie[v].next.count(c)) {
                    trie[v].next[c] = trie.size();
                    trie.push_back(Node());
                }
                v = trie[v].next[c];
            }
            trie[v].output = i;
            trie[v].outputs.push_back(i);
        }
        
        // Build failure links using BFS
        queue<int> q;
        for (auto p : trie[0].next) {
            trie[p.second].link = 0;
            q.push(p.second);
        }
        
        while (!q.empty()) {
            int v = q.front(); q.pop();
            
            // Merge outputs from failure link
            if (trie[v].link != -1 && trie[trie[v].link].output != -1) {
                trie[v].outputs.insert(
                    trie[v].outputs.end(),
                    trie[trie[v].link].outputs.begin(),
                    trie[trie[v].link].outputs.end()
                );
            }
            
            for (auto p : trie[v].next) {
                char c = p.first;
                int to = p.second;
                
                if (v == 0) {
                    trie[to].link = 0;
                } else {
                    int link = trie[v].link;
                    while (link != -1 && !trie[link].next.count(c)) {
                        link = trie[link].link;
                    }
                    trie[to].link = (link == -1) ? 0 : trie[link].next[c];
                }
                q.push(to);
            }
        }
    }
    
    // Find all occurrences of patterns in text
    vector<pair<int, int>> search(string text) {
        vector<pair<int, int>> result; // (position, pattern_index)
        int v = 0;
        
        for (int i = 0; i < text.length(); i++) {
            char c = text[i];
            while (v != -1 && !trie[v].next.count(c)) {
                v = trie[v].link;
            }
            if (v == -1) {
                v = 0;
                continue;
            }
            v = trie[v].next[c];
            
            for (int pattern_idx : trie[v].outputs) {
                result.push_back({i, pattern_idx});
            }
        }
        return result;
    }
};
```

---

## Geometry

### Basic Geometry Operations
```cpp
struct Point {
    long long x, y;
    Point() : x(0), y(0) {}
    Point(long long x, long long y) : x(x), y(y) {}
    
    Point operator+(const Point& other) const {
        return Point(x + other.x, y + other.y);
    }
    
    Point operator-(const Point& other) const {
        return Point(x - other.x, y - other.y);
    }
    
    Point operator*(long long scalar) const {
        return Point(x * scalar, y * scalar);
    }
    
    bool operator==(const Point& other) const {
        return x == other.x && y == other.y;
    }
    
    bool operator<(const Point& other) const {
        if (x != other.x) return x < other.x;
        return y < other.y;
    }
};

long long dot(const Point& a, const Point& b) {
    return a.x * b.x + a.y * b.y;
}

long long cross(const Point& a, const Point& b) {
    return a.x * b.y - a.y * b.x;
}

long long cross(const Point& a, const Point& b, const Point& c) {
    return cross(b - a, c - a);
}

long long dist2(const Point& a, const Point& b) {
    return (a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y);
}

double dist(const Point& a, const Point& b) {
    return sqrt(dist2(a, b));
}

// Check if point c is on segment ab
bool on_segment(const Point& a, const Point& b, const Point& c) {
    return cross(a, b, c) == 0 && 
           min(a.x, b.x) <= c.x && c.x <= max(a.x, b.x) &&
           min(a.y, b.y) <= c.y && c.y <= max(a.y, b.y);
}

// Check if segments ab and cd intersect
bool segments_intersect(const Point& a, const Point& b, const Point& c, const Point& d) {
    long long c1 = cross(a, b, c);
    long long c2 = cross(a, b, d);
    long long c3 = cross(c, d, a);
    long long c4 = cross(c, d, b);
    
    if (((c1 > 0 && c2 < 0) || (c1 < 0 && c2 > 0)) &&
        ((c3 > 0 && c4 < 0) || (c3 < 0 && c4 > 0))) {
        return true;
    }
    
    // Check for collinear cases
    if (c1 == 0 && on_segment(a, b, c)) return true;
    if (c2 == 0 && on_segment(a, b, d)) return true;
    if (c3 == 0 && on_segment(c, d, a)) return true;
    if (c4 == 0 && on_segment(c, d, b)) return true;
    
    return false;
}

// Compute area of polygon (shoelace formula)
double polygon_area(vector<Point>& points) {
    double area = 0;
    int n = points.size();
    for (int i = 0; i < n; i++) {
        int j = (i + 1) % n;
        area += (points[i].x * points[j].y - points[j].x * points[i].y);
    }
    return fabs(area) / 2.0;
}

// Check if point is inside polygon (ray casting)
bool point_in_polygon(vector<Point>& polygon, Point point) {
    int n = polygon.size();
    bool inside = false;
    for (int i = 0, j = n - 1; i < n; j = i++) {
        if (((polygon[i].y > point.y) != (polygon[j].y > point.y)) &&
            (point.x < (polygon[j].x - polygon[i].x) * (point.y - polygon[i].y) / 
             (double)(polygon[j].y - polygon[i].y) + polygon[i].x)) {
            inside = !inside;
        }
    }
    return inside;
}
```

### Convex Hull (Monotone Chain)
```cpp
vector<Point> convex_hull(vector<Point> points) {
    if (points.size() <= 1) return points;
    
    sort(points.begin(), points.end());
    vector<Point> hull;
    
    // Build lower hull
    for (int i = 0; i < points.size(); i++) {
        while (hull.size() >= 2 && 
               cross(hawww
[Request interrupted by user]