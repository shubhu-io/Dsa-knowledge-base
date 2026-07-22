# Competitive Programming Data Structures

## Specialized Data Structures for Competitive Programming

This document covers advanced and specialized data structures that are frequently used in competitive programming to solve complex problems efficiently.

---

## Table of Contents
1. [Advanced Tree Structures](#advanced-tree-structures)
2. [Heap Variants](#heap-variants)
3. [Hash Table Variants](#hash-table-variants)
4. [String-Specific Structures](#string-specific-structures)
5. [Geometry-Specific Structures](#geometry-specific-structures)
6. [Advanced Graph Structures](#advanced-graph-structures)
7. [Functional/Persistent Structures](#functionalpersistent-structures)
8. [Miscellaneous Structures](#miscellaneous-structures)

---

## Advanced Tree Structures

### Segment Tree
**Purpose**: Efficient range queries and point updates on arrays
**Time Complexity**: O(log n) for both query and update
**Space Complexity**: O(4n) or O(2n) for iterative version

**Basic Implementation** (Range Sum Query):
```cpp
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
```

**Lazy Propagation Segment Tree** (For range updates):
```cpp
struct LazySegTree {
    int n;
    vector<long long> tree;
    vector<long long> lazy;
    
    LazySegTree(int n) {
        this->n = n;
        tree.assign(4 * n, 0);
        lazy.assign(4 * n, 0);
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
    
    void push(int v, int tl, int tr) {
        if (lazy[v] != 0) {
            tree[v] += (tr - tl + 1) * lazy[v];
            if (tl != tr) {
                lazy[v*2+1] += lazy[v];
                lazy[v*2+2] += lazy[v];
            }
            lazy[v] = 0;
        }
    }
    
    void update(int v, int tl, int tr, int l, int r, long long addend) {
        push(v, tl, tr);
        if (l > r) return;
        if (l == tl && r == tr) {
            lazy[v] += addend;
            push(v, tl, tr);
        } else {
            int tm = (tl + tr) / 2;
            update(v*2+1, tl, tm, l, min(r, tm), addend);
            update(v*2+2, tm+1, tr, max(l, tm+1), r, addend);
            tree[v] = tree[v*2+1] + tree[v*2+2];
        }
    }
    
    void update(int l, int r, long long addend) {
        update(0, 0, n-1, l, r, addend);
    }
    
    long long query(int v, int tl, int tr, int l, int r) {
        push(v, tl, tr);
        if (l > r) return 0;
        if (l == tl && r == tr) return tree[v];
        int tm = (tl + tr) / 2;
        return query(v*2+1, tl, tm, l, min(r, tm))
             + query(v*2+2, tm+1, tr, max(l, tm+1), r);
    }
    
    long long query(int l, int r) {
        return query(0, 0, n-1, l, r);
    }
};
```

**Iterative Segment Tree** (More cache-friendly):
```cpp
struct IterativeSegTree {
    int n;
    vector<long long> tree;
    
    IterativeSegTree(int n) {
        this->n = n;
        tree.assign(2 * n, 0);
    }
    
    void build(vector<long long>& a) {
        for (int i = 0; i < n; i++) tree[n + i] = a[i];
        for (int i = n - 1; i > 0; i--) tree[i] = tree[2*i] + tree[2*i+1];
    }
    
    void modify(int p, long long value) {
        for (tree[p += n] = value; p > 1; p >>= 1) 
            tree[p>>1] = tree[p] + tree[p^1];
    }
    
    long long query(int l, int r) {  // [l, r)
        long long res = 0;
        for (l += n, r += n; l < r; l >>= 1, r >>= 1) {
            if (l & 1) res += tree[l++];
            if (r & 1) res += tree[--r];
        }
        return res;
    }
};
```

### Binary Indexed Tree (Fenwick Tree)
**Purpose**: Efficient prefix sums and point updates
**Time Complexity**: O(log n) for both query and update
**Space Complexity**: O(n)
**Advantage**: Simpler implementation and better constant factor than segment tree

```cpp
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
```

**Fenwick Tree for Range Queries and Point Updates** (Same as above)
**Fenwick Tree for Point Queries and Range Updates**:
```cpp
struct FenwickTreeRangeUpdate {
    int n;
    vector<long long> bit;
    
    FenwickTreeRangeUpdate(int n) {
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
    
    void range_add(int l, int r, long long delta) {
        add(l, delta);
        add(r + 1, -delta);
    }
    
    long long point_query(int idx) {
        return sum(idx);
    }
};
```

**Fenwick Tree for Range Queries and Range Updates** (Two trees):
```cpp
struct FenwickTreeRangeQueryRangeUpdate {
    int n;
    vector<long long> bit1, bit2;
    
    FenwickTreeRangeQueryRangeUpdate(int n) {
        this->n = n;
        bit1.assign(n + 1, 0);
        bit2.assign(n + 1, 0);
    }
    
    void _add(vector<long long>& bit, int idx, long long delta) {
        for (++idx; idx <= n; idx += idx & -idx)
            bit[idx] += delta;
    }
    
    long long _sum(vector<long long>& bit, int idx) {
        long long ret = 0;
        for (++idx; idx > 0; idx -= idx & -idx)
            ret += bit[idx];
        return ret;
    }
    
    void range_add(int l, int r, long long delta) {
        _add(bit1, l, delta);
        _add(bit1, r + 1, -delta);
        _add(bit2, l, delta * (l - 1));
        _add(bit2, r + 1, -delta * r);
    }
    
    long long prefix_sum(int idx) {
        return _sum(bit1, idx) * idx - _sum(bit2, idx);
    }
    
    long long range_sum(int l, int r) {
        return prefix_sum(r) - prefix_sum(l - 1);
    }
};
```

### Cartesian Tree
**Purpose**: Binary tree derived from sequence where heap property holds on values and inorder traversal gives original sequence
**Applications**: RMQ (Range Minimum Query), Treap construction

**Construction** (O(n) using stack):
```cpp
struct CartesianTreeNode {
    int val, idx;
    CartesianTreeNode *left, *right;
    CartesianTreeNode(int v, int i) : val(v), idx(i), left(nullptr), right(nullptr) {}
};

CartesianTreeNode* build_cartesian_tree(vector<int>& arr) {
    int n = arr.size();
    vector<CartesianTreeNode*> nodes(n);
    stack<CartesianTreeNode*> st;
    
    for (int i = 0; i < n; i++) {
        nodes[i] = new CartesianTreeNode(arr[i], i);
        CartesianTreeNode* last = nullptr;
        
        while (!st.empty() && st.top()->val > arr[i]) {
            last = st.top();
            st.pop();
        }
        
        if (!st.empty()) {
            st.top()->right = nodes[i];
            nodes[i]->left = last;
        } else {
            nodes[i]->left = last;
        }
        
        st.push(nodes[i]);
    }
    
    // Find root (bottom of stack)
    while (st.size() > 1) st.pop();
    return st.empty() ? nullptr : st.top();
}
```

### Range Minimum Query (RMQ)
**Purpose**: Answer minimum value queries on subarrays in O(1) after O(n log n) preprocessing
**Methods**:
1. **Sparse Table**: O(n log n) preprocessing, O(1) query, immutable array
2. **Segment Tree**: O(n) preprocessing, O(log n) query, supports updates
3. **Fenwick Tree Variant**: Specialized for minimum
4. **+1/-1 RMQ**: For arrays where adjacent elements differ by 1 (using +1/-1 technique)

**Sparse Table Implementation**:
```cpp
struct SparseTable {
    int n, LOG;
    vector<vector<int>> st;
    vector<int> log2;
    
    SparseTable(vector<int>& arr) {
        n = arr.size();
        LOG = 0;
        while ((1 << LOG) <= n) LOG++;
        
        st.assign(LOG, vector<int>(n));
        log2.assign(n + 1, 0);
        
        // Precompute logs
        for (int i = 2; i <= n; i++) {
            log2[i] = log2[i/2] + 1;
        }
        
        // Build sparse table
        for (int i = 0; i < n; i++) {
            st[0][i] = arr[i];
        }
        
        for (int k = 1; k < LOG; k++) {
            for (int i = 0; i + (1 << k) <= n; i++) {
                st[k][i] = min(st[k-1][i], st[k-1][i + (1 << (k-1))]);
            }
        }
    }
    
    int query(int l, int r) {  // [l, r] inclusive
        int len = r - l + 1;
        int k = log2[len];
        return min(st[k][l], st[k][r - (1 << k) + 1]);
    }
};
```

### Lowest Common Ancestor (LCA)
**Purpose**: Find lowest common ancestor of two nodes in a tree
**Methods**:
1. **Binary Lifting**: O(n log n) preprocessing, O(log n) query
2. **Euler Tour + RMQ**: O(n) preprocessing, O(1) query
3. **Square Root Decomposition**: O(n) preprocessing, O(√n) query
4. **Jump Pointer Method**: Various trade-offs

**Binary Lifting Implementation**:
```cpp
struct BinaryLifting {
    int n, LOG;
    vector<vector<int>> up;
    vector<int> depth;
    vector<vector<int>> adj;
    
    BinaryLifting(int n) : n(n) {
        LOG = 0;
        while ((1 << LOG) <= n) LOG++;
        
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

### Link-Cut Tree
**Purpose**: Dynamic tree data structure that supports path queries and updates
**Operations**: link, cut, find root, path aggregate, etc.
**Time Complexity**: O(log n) amortized per operation
**Complex implementation** - usually only used when specifically needed

### Treap (Cartesian Tree + Heap)
**Purpose**: Randomized binary search tree with O(log n) expected time for operations
**Properties**: 
- BST property by key
- Heap property by priority (random)
- Expected height O(log n)

```cpp
struct TreapNode {
    int key, priority;
    TreapNode *left, *right;
    int size; // Size of subtree
    
    TreapNode(int k) : key(k), priority(rand()), left(nullptr), right(nullptr), size(1) {}
};

int get_size(TreapNode* node) {
    return node ? node->size : 0;
}

void update_size(TreapNode* node) {
    if (node) {
        node->size = 1 + get_size(node->left) + get_size(node->right);
    }
}

// Split treap into two: <= key and > key
pair<TreapNode*, TreapNode*> split(TreapNode* root, int key) {
    if (!root) return {nullptr, nullptr};
    
    if (root->key <= key) {
        auto [left_sub, right_sub] = split(root->right, key);
        root->right = left_sub;
        update_size(root);
        return {root, right_sub};
    } else {
        auto [left_sub, right_sub] = split(root->left, key);
        root->left = right_sub;
        update_size(root);
        return {left_sub, root};
    }
}

// Merge two treaps where all keys in left <= keys in right
TreapNode* merge(TreapNode* left, TreapNode* right) {
    if (!left) return right;
    if (!right) return left;
    
    if (left->priority > right->priority) {
        left->right = merge(left->right, right);
        update_size(left);
        return left;
    } else {
        right->left = merge(left, right->left);
        update_size(right);
        return right;
    }
}

// Insert key into treap
TreapNode* insert(TreapNode* root, int key) {
    if (!root) return new TreapNode(key);
    
    if (key < root->key) {
        root->left = insert(root->left, key);
        if (root->left->priority > root->priority) {
            // Right rotate
            TreapNode* new_root = root->left;
            root->left = new_root->right;
            new_root->right = root;
            update_size(root);
            update_size(new_root);
            return new_root;
        }
    } else {
        root->right = insert(root->right, key);
        if (root->right->priority > root->priority) {
            // Left rotate
            TreapNode* new_root = root->right;
            root->right = new_root->left;
            new_root->left = root;
            update_size(root);
            update_size(new_root);
            return new_root;
        }
    }
    
    update_size(root);
    return root;
}

// Remove key from treap
TreapNode* erase(TreapNode* root, int key) {
    if (!root) return nullptr;
    
    if (key == root->key) {
        TreapNode* result = merge(root->left, root->right);
        delete root;
        return result;
    } else if (key < root->key) {
        root->left = erase(root->left, key);
        update_size(root);
        return root;
    } else {
        root->right = erase(root->right, key);
        update_size(root);
        return root;
    }
}

// Find key in treap
bool find(TreapNode* root, int key) {
    if (!root) return false;
    if (key == root->key) return true;
    return key < root->key ? find(root->left, key) : find(root->right, key);
}

// Find k-th smallest element (0-indexed)
int kth(TreapNode* root, int k) {
    int left_size = get_size(root->left);
    if (k < left_size) {
        return kth(root->left, k);
    } else if (k == left_size) {
        return root->key;
    } else {
        return kth(root->right, k - left_size - 1);
    }
}
```

### Splay Tree
**Purpose**: Self-adjusting binary search tree with O(log n) amortized time
**Property**: Recently accessed elements are quick to access again
**Operations**: splay, insert, find, delete, etc.

```cpp
struct SplayNode {
    int key;
    SplayNode *left, *right, *parent;
    SplayNode(int k) : key(k), left(nullptr), right(nullptr), parent(nullptr) {}
};

void rotate(SplayNode* x) {
    SplayNode* p = x->parent;
    SplayNode* g = p->parent;
    
    if (p->left == x) {
        // Right rotation
        p->left = x->right;
        if (x->right) x->right->parent = p;
        x->right = p;
    } else {
        // Left rotation
        p->right = x->left;
        if (x->left) x->left->parent = p;
        x->left = p;
    }
    
    x->parent = g;
    p->parent = x;
    
    if (g) {
        if (g->left == p) g->left = x;
        else if (g->right == p) g->right = x;
    }
}

void splay(SplayNode* x, SplayNode* root) {
    while (x->parent != root) {
        SplayNode* p = x->parent;
        SplayNode* g = p->parent;
        
        if (g == root) {
            // Zig (single rotation)
            rotate(x);
        } else if ((g->left == p) == (p->left == x)) {
            // Zig-zig (double rotation in same direction)
            rotate(p);
            rotate(x);
        } else {
            // Zig-zag (double rotation in opposite directions)
            rotate(x);
            rotate(x);
        }
    }
}

// Simple insert (doesn't maintain splay property on insert)
SplayNode* insert(SplayNode* root, int key) {
    if (!root) return new SplayNode(key);
    
    SplayNode* curr = root;
    SplayNode* parent = nullptr;
    
    while (curr) {
        parent = curr;
        if (key < curr->key) {
            curr = curr->left;
        } else if (key > curr->key) {
            curr = curr->right;
        } else {
            // Key already exists, splay to root and return
            splay(curr, root);
            return root;
        }
    }
    
    SplayNode* node = new SplayNode(key);
    node->parent = parent;
    
    if (key < parent->key) {
        parent->left = node;
    } else {
        parent->right = node;
    }
    
    splay(node, node);  // Splay new node to root
    return node;
}
```

### Fenwick Tree of Trees
**Purpose**: 2D data structure for point updates and rectangle queries
**Applications**: Counting points in rectangles, 2D prefix sums with updates

```cpp
struct FenwickTree2D {
    int n, m;
    vector<vector<long long>> bit;
    
    FenwickTree2D(int n, int m) {
        this->n = n;
        this->m = m;
        bit.assign(n + 1, vector<long long>(m + 1, 0));
    }
    
    void add(int x, int y, long long delta) {
        for (int i = x + 1; i <= n; i += i & -i) {
            for (int j = y + 1; j <= m; j += j & -j) {
                bit[i][j] += delta;
            }
        }
    }
    
    long long sum(int x, int y) {
        long long ret = 0;
        for (int i = x + 1; i > 0; i -= i & -i) {
            for (int j = y + 1; j > 0; j -= j & -j) {
                ret += bit[i][j];
            }
        }
        return ret;
    }
    
    long long range_sum(int x1, int y1, int x2, int y2) {
        // [x1, x2] x [y1, y2] inclusive
        return sum(x2, y2) - sum(x1 - 1, y2) - sum(x2, y1 - 1) + sum(x1 - 1, y1 - 1);
    }
};
```

## Heap Variants

### Binary Heap (Standard)
Already covered in basic data structures section.

### Binomial Heap
**Priority queue with faster union** (O(log n) vs O(n) for binary heap)
**Structure**: Collection of binomial trees
**Operations**: 
- Insert: O(1) amortized
- Get-min: O(1)
- Extract-min: O(log n)
- Union: O(log n)
- Decrease-key: O(log n)
- Delete: O(log n)

### Fibonacci Heap
**Theoretically optimal** for some graph algorithms
**Amortized time complexities**:
- Insert: O(1)
- Get-min: O(1)
- Extract-min: O(log n)
- Union: O(1)
- Decrease-key: O(1)  ← Key advantage
- Delete: O(log n)

**Used in**: Dijkstra's algorithm (with many decrease-key operations), Prim's algorithm
**Note**: Large constant factors, usually not worth it in practice unless many decrease-key operations

### Pairing Heap
**Simple to implement**, good practical performance
**Amortized time**: Similar to Fibonacci heap but with lower constants
**Operations**: 
- Insert: O(1)
- Get-min: O(1)
- Extract-min: O(log n) amortized
- Merge: O(1)
- Decrease-key: O(log n) amortized

### Leftist Heap
**Property**: Every node's left subtree has at least as many nodes as its right subtree
**Operations**: 
- Merge: O(log n)
- Insert: O(log n) (via merge with single-node heap)
- Get-min: O(1)
- Extract-min: O(log n)

### Skew Heap
**Self-adjusting variant** of leftist heap
**No explicit structural constraints**
**Amortized time**: O(log n) per operation
**Simpler implementation** than leftist heap

### d-ary Heap
**Generalization** of binary heap where each node has up to d children
**Trade-offs**:
- Larger d: Faster get-min (shallower tree), slower insert/extract-min (more children to check)
- Smaller d: Slower get-min, faster insert/extract-min
- Common choices: d=3, d=4 (ternary, quaternary heaps)
- Cache performance often better for d=4 due to better locality

## Hash Table Variants

### Separate Chaining
**Standard approach**: Array of linked lists (or other secondary structures)
**Handles collisions** by storing multiple elements in same bucket

### Open Addressing
**Stores all elements** in the main array
**Probing sequences** when collision occurs:
- Linear Probing: h(k,i) = (h'(k) + i) mod m
- Quadratic Probing: h(k,i) = (h'(k) + c₁i + c₂i²) mod m
- Double Hashing: h(k,i) = (h₁(k) + i·h₂(k)) mod m

### Robin Hood Hashing
**Variation of open addressing** that minimizes variance in probe lengths
**Elements with longer probe distance** can displace elements with shorter distance
**More consistent performance**, reduced worst-case probing

### Cuckoo Hashing
**Uses two or more hash functions** and tables
**Each element** can be in one of several possible positions
**Insertion**: May kick out existing elements, relocating them to their alternative positions
**Lookup**: Check all possible locations (O(1) with small constant)
**Insertion**: Amortized O(1), but infrequent expensive rehashing possible

### Hopscotch Hashing
**Combines ideas** from chaining and open addressing
**Each bucket** has a "neighborhood" where its items must reside
**Good cache performance**, high load factors possible (up to ~0.9)

### Bloom Filter
**Probabilistic data structure** for testing set membership
**False positives possible**, but false negatives impossible
**Space efficient**: Much smaller than storing actual elements
**Operations**:
- Add: O(k) where k is number of hash functions
- Query: O(k)
- Space: O(n) bits for n elements with controllable false positive rate

```cpp
struct BloomFilter {
    int n; // Expected number of elements
    double fpp; // Desired false positive probability
    int m; // Number of bits in bit array
    int k; // Number of hash functions
    vector<bool> bits;
    
    BloomFilter(int _n, double _fpp = 0.01) : n(_n), fpp(_fpp) {
        // Optimal parameters: m = -(n * ln(fpp)) / (ln(2)^2)
        //                 k = (m/n) * ln(2)
        m = (int)(-n * log(fpp) / (log(2) * log(2)));
        k = (int)(m * log(2) / n);
        if (k < 1) k = 1;
        bits.assign(m, false);
    }
    
    // Simple hash functions (use better ones in practice)
    size_t hash1(const string& key) {
        size_t hash = 0;
        for (char c : key) {
            hash = (hash * 31 + c) % m;
        }
        return hash;
    }
    
    size_t hash2(const string& key) {
        size_t hash = 0;
        for (char c : key) {
            hash = (hash * 17 + c) % m;
        }
        return hash;
    }
    
    void add(const string& key) {
        for (int i = 0; i < k; i++) {
            size_t combined = (hash1(key) + i * hash2(key)) % m;
            bits[combined] = true;
        }
    }
    
    bool contains(const string& key) {
        for (int i = 0; i < k; i++) {
            size_t combined = (hash1(key) + i * hash2(key)) % m;
            if (!bits[combined]) return false;
        }
        return true; // Might be false positive
    }
};
```

## String-Specific Structures

### Trie (Prefix Tree)
Already covered in basic data structures.

### Compressed Trie (Radix Tree, Patricia Trie)
**Space optimization** by compressing chains of single-child nodes
**Each edge** represents a string segment rather than single character
**Reduces space** from O(ALPHABET_SIZE × total_length) to O(number_of_nodes × alphabet_size)

### Suffix Array
**Purpose**: Sorted array of all suffixes of a string
**Applications**: Pattern matching, longest repeated substring, longest common substring
**Construction**:
- O(n² log n): Sort all suffixes naively
- O(n log n): Prefix doubling / Skew algorithm
- O(n): SA-IS, DC3 algorithms (complex)

**Usage**:
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
        if (s2[p[i]] != s2[p[i-1]]) classes++;
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
            pair<int, int> prev = {c[p[i-1]], c[(p[i-1] + (1 << h)) % n]};
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

### Longest Common Extension (LCE) with Suffix Array + LCP Array
**LCP Array**: Longest Common Prefix between adjacent suffixes in suffix array
**RMQ on LCP Array** gives LCE of any two suffixes in O(1) after O(n) preprocessing

```cpp
struct SuffixArrayWithLCP {
    vector<int> sa, lcp, rank;
    SparseTable rmq; // For LCP queries
    string s;
    
    SuffixArrayWithLCP(const string& _s) : s(_s) {
        sa = build_suffix_array(s);
        int n = s.size();
        rank.assign(n, 0);
        for (int i = 0; i < n; i++) {
            rank[sa[i]] = i;
        }
        
        // Kasai algorithm for LCP array
        lcp.assign(n, 0);
        int k = 0;
        for (int i = 0; i < n; i++) {
            if (rank[i] == n - 1) { k = 0; continue; }
            int j = sa[rank[i] + 1];
            while (i + k < n && j + k < n && s[i + k] == s[j + k]) k++;
            lcp[rank[i]] = k;
            if (k) k--;
        }
        
        // Build RMQ structure on LCP array (excluding last element which is undefined)
        vector<int> lcp_for_rmq(lcp.begin(), lcp.end() - 1);
        rmq = SparseTable(lcp_for_rmq);
    }
    
    // Longest Common Extension of suffixes starting at i and j
    int lce(int i, int j) {
        if (i == j) return s.size() - i;
        int ri = rank[i], rj = rank[j];
        if (ri > rj) swap(ri, rj);
        // Query minimum in LCP[ri..rj-1]
        return rmq.query(ri, rj - 1);
    }
    
    // Longest Repeated Substring
    string lrs() {
        int max_len = 0, pos = 0;
        for (int i = 0; i < s.size(); i++) {
            if (lcp[i] > max_len) {
                max_len = lcp[i];
                pos = sa[i];
            }
        }
        return s.substr(pos, max_len);
    }
    
    // Longest Common Substring of two strings
    string lcs(const string& t) {
        // Build combined string with unique separator
        string combined = s + "#" + t;
        SuffixArrayWithLCP sa_lcp(combined);
        
        int max_len = 0, pos = 0;
        int offset = s.size() + 1; // Position of separator
        
        for (int i = 0; i < sa_lcp.sa.size(); i++) {
            int suffix_pos = sa_lcp.sa[i];
            bool from_s = suffix_pos < s.size();
            bool from_t = suffix_pos > s.size();
            
            if (i > 0) {
                int prev_pos = sa_lcp.sa[i-1];
                bool prev_from_s = prev_pos < s.size();
                bool prev_from_t = prev_pos > s.size();
                
                if ((from_s && prev_from_t) || (from_t && prev_from_s)) {
                    if (sa_lcp.lcp[i-1] > max_len) {
                        max_len = sa_lcp.lcp[i-1];
                        pos = min(suffix_pos, prev_pos);
                    }
                }
            }
        }
        
        // Extract from original string s
        if (pos < s.size()) {
            return s.substr(pos, max_len);
        } else {
            // Adjust position for string t
            return t.substr(pos - s.size() - 1, max_len);
        }
    }
};
```

### Suffix Automaton
**Purpose**: Minimal deterministic finite automaton that recognizes all substrings of a string
**Properties**:
- Linear size: O(n) states and transitions
- Can check if string is substring in O(|pattern|)
- Can count number of different substrings
- Can find longest common substring of two strings

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
    
    // Longest common substring of two strings
    string lcs(string t) {
        SuffixAutomaton sam_t(t);
        int v = 0, l = 0, best = 0, bestpos = 0;
        
        for (int i = 0; i < s.size(); i++) {
            char c = s[i];
            if (sam_t.st[v].next.count(c)) {
                v = sam_t.st[v].next[c];
                l++;
                if (l > best) {
                    best = l;
                    bestpos = i;
                }
            } else {
                while (v != -1 && !sam_t.st[v].next.count(c)) {
                    v = sam_t.st[v].link;
                }
                if (v == -1) {
                    v = 0;
                    l = 0;
                    continue;
                }
                v = sam_t.st[v].next[c];
                l = sam_t.st[v].len;
            }
        }
        
        return s.substr(bestpos - best + 1, best);
    }
};
```

### Aho-Corasick Automaton
**Purpose**: Efficient multiple pattern matching
**Finds all occurrences** of any pattern from a set in a text
**Time Complexity**: O(n + m + z) where n = text length, m = total pattern length, z = number of matches
**Already covered in previous document**, but worth mentioning here as a specialized string structure

### Suffix Tree
**Purpose**: Compressed trie of all suffixes of a string
**Linear size**: O(n) nodes
**Many applications** similar to suffix array but with faster certain queries
**More complex to implement** than suffix array
**Ukkonen's algorithm**: Online O(n) construction
**We'll mention it but not implement due to complexity**

## Geometry-Specific Structures

### KD-Tree
**Purpose**: Space-partitioning data structure for organizing points in k-dimensional space
**Applications**: Nearest neighbor search, range search, point location
**Average case**: O(log n) for search, O(n log n) for construction
**Worst case**: O(n) for search (can be mitigated with variations)

```cpp
struct KDTreeNode {
    point pt; // Assuming point is defined elsewhere
    int id;
    KDTreeNode *left, *right;
    int dim; // Dimension used for splitting
    
    KDTreeNode(const point& p, int i, int d) : pt(p), id(i), left(nullptr), right(nullptr), dim(d) {}
};

struct KDTree {
    KDTreeNode* root;
    int k; // Dimensions
    
    KDTree(vector<point>& points, vector<int>& ids, int dimensions) : k(dimensions) {
        root = build(points, ids, 0);
    }
    
    KDTreeNode* build(vector<point>& pts, vector<int>& id_list, int depth) {
        if (pts.empty()) return nullptr;
        
        int axis = depth % k;
        sort(pts.begin(), pts.end(), [axis](const point& a, const point& b) {
            return a.coords[axis] < b.coords[axis];
        });
        
        int median = pts.size() / 2;
        KDTreeNode* node = new KDTreeNode(pts[median], id_list[median], axis);
        
        vector<point> left_pts(pts.begin(), pts.begin() + median);
        vector<point> right_pts(pts.begin() + median + 1, pts.end());
        vector<int> left_ids(id_list.begin(), id_list.begin() + median);
        vector<int> right_ids(id_list.begin() + median + 1, id_list.end());
        
        node->left = build(left_pts, left_ids, depth + 1);
        node->right = build(right_pts, right_ids, depth + 1);
        
        return node;
    }
    
    // Nearest neighbor search
    pair<point, double> nearest_neighbor(const point& target) {
        double best_dist = numeric_limits<double>::max();
        point best_point;
        nn_search(root, target, best_dist, best_point);
        return {best_point, best_dist};
    }
    
    void nn_search(KDTreeNode* node, const point& target, double& best_dist, point& best_point) {
        if (!node) return;
        
        double dist = distance(node->pt, target);
        if (dist < best_dist) {
            best_dist = dist;
            best_point = node->pt;
        }
        
        int axis = node->dim;
        double diff = target.coords[axis] - node->pt.coords[axis];
        
        // Search nearer subtree first
        KDTreeNode* first = diff < 0 ? node->left : node->right;
        KDTreeNode* second = diff < 0 ? node->right : node->left;
        
        nn_search(first, target, best_dist, best_point);
        
        // Check if we need to search farther subtree
        if (diff * diff < best_dist) {
            nn_search(second, target, best_dist, best_point);
        }
    }
};
```

### Quadtree / Octree
**Purpose**: Partition 2D/3D space by recursively subdividing into quadrants/octants
**Applications**: Spatial indexing, collision detection, image processing
**Region Quadtree**: Divides space into four equal quadrants
**Point Quadtree**: Similar to KD-tree but always splits at midpoint
**Polygon Map Quadtree**: Stores lines/points that intersect regions

### BSP Tree (Binary Space Partitioning)
**Purpose**: Recursively subdivides space using hyperplanes
**Applications**: Rendering, collision detection, robotics
**More general** than kd-tree - splitting planes can be arbitrary

### R-Tree
**Purpose**: Balanced tree for spatial access methods (indexing multi-dimensional information)
**Applications**: Geographic databases, spatial indexing
**Groups nearby objects** and represents them with minimum bounding rectangle (MBR)
**Commonly used in**: GIS systems, databases

### Delaunay Triangulation
**Purpose**: Triangulation such that no point is inside the circumcircle of any triangle
**Properties**: Maximizes minimum angle, useful for mesh generation
**Dual graph**: Voronoi diagram
**Algorithms**: 
- Incremental (O(n²) worst case, O(n log n) average)
- Divide and conquer (O(n log n))
- Sweepline (O(n log n))

### Voronoi Diagram
**Purpose**: Partitions plane into regions based on distance to points in subset
**Each region**: Points closer to its defining point than to any other
**Applications**: Nearest neighbor, facility planning, meteorology
**Relationship**: Dual of Delaunay triangulation

## Advanced Graph Structures

### Dynamic Connectivity
**Purpose**: Maintain connectivity information in evolving graph
**Operations**: add_edge, remove_edge, connected(u,v)
**Methods**:
- **Link-Cut Trees**: O(log n) per operation (for forests)
- **Euler Tour Trees**: O(log n) per operation (for forests)
- **Holm, de Lichtenberg, Thorup**: O(log² n) amortized (for general graphs)
- **Simple sqrt decomposition**: O(√n) per operation

### Min-Plus Matrix (Distance Product)
**Purpose**: Efficient computation of shortest paths in graphs with small integer weights
**Based on**: (min,+) matrix multiplication instead of (+,×)
**Applications**: 
- Finding shortest paths with bounded integer weights
- Computing k-th shortest path
- Some string algorithms

### Berkeley DFT (Discrete Fourier Transform) Tree
**Purpose**: Efficient polynomial multiplication and evaluation
**Applications**: 
- Convolution problems
- String matching with wildcards
- Some dynamic programming optimizations
- Competitive programming problems involving polynomials

### Heavy-Light Decomposition (HLD)
**Purpose**: Decompose tree into paths to enable efficient path queries
**Applications**: 
- Path queries (sum, min, max, etc.)
- Path updates
- LCA computation
- Subtree queries
**Time Complexity**: O(log² n) per query/update with segment trees
**Can achieve O(log n)** with more complex structures

```cpp
struct HLD {
    int n;
    vector<vector<int>> adj;
    vector<int> parent, depth, heavy, head, pos;
    int cur_pos;
    
    HLD(int n) : n(n) {
        adj.assign(n, vector<int>());
        parent.assign(n, -1);
        depth.assign(n, 0);
        heavy.assign(n, -1);
        head.assign(n, 0);
        pos.assign(n, 0);
        cur_pos = 0;
    }
    
    void add_edge(int u, int v) {
        adj[u].push_back(v);
        adj[v].push_back(u);
    }
    
    int dfs(int v) {
        int size = 1;
        int max_subtree = 0;
        for (int c : adj[v]) {
            if (c != parent[v]) {
                parent[c] = v;
                depth[c] = depth[v] + 1;
                int c_size = dfs(c);
                size += c_size;
                if (c_size > max_subtree) {
                    max_subtree = c_size;
                    heavy[v] = c;
                }
            }
        }
        return size;
    }
    
    void decompose(int v, int h) {
        head[v] = h;
        pos[v] = cur_pos++;
        if (heavy[v] != -1) {
            decompose(heavy[v], h);
            for (int c : adj[v]) {
                if (c != parent[v] && c != heavy[v]) {
                    decompose(c, c);
                }
            }
        }
    }
    
    void init(int root = 0) {
        dfs(root);
        decompose(root, root);
    }
    
    // Query on path from u to v (assuming we have a segment tree on the linearized tree)
    // This is a template - actual query depends on what segment tree stores
    int query_path(int u, int v, function<int(int, int)> seg_query) {
        int res = 0; // Identity element
        while (head[u] != head[v]) {
            if (depth[head[u]] < depth[head[v]]) swap(u, v);
            // Query from head[u] to u
            res = combine(res, seg_query(pos[head[u]], pos[u]));
            u = parent[head[u]];
        }
        // Now on same head
        if (depth[u] > depth[v]) swap(u, v);
        // Query from u to v
        res = combine(res, seg_query(pos[u], pos[v]));
        return res;
    }
    
    // Update on path from u to v
    void update_path(int u, int v, function<void(int, int)> seg_update) {
        while (head[u] != head[v]) {
            if (depth[head[u]] < depth[head[v]]) swap(u, v);
            // Update from head[u] to u
            seg_update(pos[head[u]], pos[u]);
            u = parent[head[u]];
        }
        // Now on same head
        if (depth[u] > depth[v]) swap(u, v);
        // Update from u to v
        seg_update(pos[u], pos[v]);
    }
    
    // Subtree query
    int query_subtree(int v, function<int(int, int)> seg_query) {
        // Query from pos[v] to pos[v] + size[v] - 1
        // Need subtree sizes calculated
        return seg_query(pos[v], pos[v] + /* size[v] */ - 1); // Placeholder
    }
};
```

### Virtual Tree
**Purpose**: Efficiently process queries on subsets of tree nodes
**Constructs auxiliary tree** containing only relevant nodes and their LCAs
**Reduces problem size** from O(n) to O(k log n) where k is number of query nodes
**Applications**: 
- Multiple LCA queries
- Distance queries on subsets
- Marking/unmarking nodes and querying connectivity
- Problems like "find sum of distances between all pairs of marked nodes"

**Construction Algorithm**:
1. Sort nodes by DFS order
2. Push nodes onto stack, computing LCAs as needed
3. Build tree from stack relationships

## Functional/Persistent Structures

### Persistent Segment Tree
**Purpose**: Maintain versions of segment tree after updates
**Applications**: 
- K-th order statistic in subarray
- Persistent arrays
- Undo functionality
- Some geometric problems
**Time/Space**: O(log n) per update/query, O(n log n) space for m versions

```cpp
struct PersistentSegTree {
    struct Node {
        int left, right;
        long long sum;
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
    
    int update(int prev_root, int pos, long long value, int l, int r) {
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
    
    long long query(int left_root, int right_root, int k, int l, int r) {
        // Returns k-th smallest element in [left_root, right_root) range
        // Assumes tree stores frequencies/counts
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

### Persistent Trie
**Purpose**: Maintain versions of trie after insertions
**Applications**: 
- Maximum XOR subarray problems
- Some string problems with versioning
- Persistent dictionaries

### Partially Persistent vs Fully Persistent
- **Partially Persistent**: Access all versions, but only modify latest version
- **Fully Persistent**: Access all versions, modify any version
- **Confluently Persistent**: Can merge versions

### Persistent Union-Find
**Purpose**: Maintain versions of disjoint-set union structure
**Applications**: 
- Offline dynamic connectivity
- Some graph problems with time dimension
**Techniques**: 
- Partial persistence with node copying
- Union by rank only (no path compression) for persistence
- More complex techniques for full persistence

## Miscellaneous Structures

### Disjoint Set Union on Trees (DSU on Tree)
**Purpose**: Answer subtree queries efficiently
**Also known as**: "Sack" technique (DSU on tree)
**Time Complexity**: O(n log n) for all queries
**Applications**: 
- Queries on subtrees (frequency of values, etc.)
- Problems like "find most frequent color in subtree"
- "Number of distinct values in subtree"

**Basic Idea**:
1. Process light children first and clear their contributions
2. Process heavy child and keep its contribution
3. Process light children again and add their contributions
4. Answer query for current node
5. If not keeping current node's data, clear it

```cpp
struct DSUOnTree {
    int n;
    vector<vector<int>> adj;
    vector<int> sz, big;
    vector<long long> cnt; // Frequency count
    long long max_freq;
    long long sum; // Sum of values with max frequency
    bool keep;
    
    DSUOnTree(int n) : n(n) {
        adj.assign(n, vector<int>());
        sz.assign(n, 0);
        big.assign(n, -1);
    }
    
    void add_edge(int u, int v) {
        adj[u].push_back(v);
        adj[v].push_back(u);
    }
    
    int get_size(int v, int p) {
        sz[v] = 1;
        int max_size = 0;
        for (int u : adj[v]) {
            if (u != p) {
                sz[u] = get_size(u, v);
                sz[v] += sz[u];
                if (sz[u] > max_size) {
                    max_size = sz[u];
                    big[v] = u;
                }
            }
        }
        return sz[v];
    }
    
    void add(int v, int p, int x) {
        // Add contribution of node v
        cnt[/* value of node v */] += x;
        if (cnt[/* value of node v */] > max_freq) {
            max_freq = cnt[/* value of node v */];
            sum = /* value of node v */;
        } else if (cnt[/* value of node v */] == max_freq) {
            sum += /* value of node v */;
        }
        
        for (int u : adj[v]) {
            if (u != p && u != big[v]) {
                add_subtree(u, v, x);
            }
        }
    }
    
    void add_subtree(int v, int p, int x) {
        add(v, p, x);
        for (int u : adj[v]) {
            if (u != p) {
                add_subtree(u, v, x);
            }
        }
    }
    
    void sub(int v, int p, int x) {
        // Subtract contribution of node v
        cnt[/* value of node v */] -= x;
        // Update max_freq and sum if needed...
        // (Implementation depends on what we're tracking)
        
        for (int u : adj[v]) {
            if (u != p) {
                sub(u, v, x);
            }
        }
    }
    
    void dfs(int v, int p, bool keep) {
        for (int u : adj[v]) {
            if (u != p && u != big[v]) {
                dfs(u, v, false);
            }
        }
        
        if (big[v] != -1) {
            dfs(big[v], v, true);
        }
        
        for (int u : adj[v]) {
            if (u != p && u != big[v]) {
                add(u, v, 1); // or whatever value we're tracking
            }
        }
        
        // Now answer queries for node v
        // answer[v] = /* some function of cnt, max_freq, sum */;
        
        if (!keep) {
            // Clean up
            sub(v, p, 1); // or whatever value we're tracking
        }
    }
    
    void solve(int root = 0) {
        get_size(root, -1);
        dfs(root, -1, true);
    }
};
```

### Mo's Algorithm on Trees
**Purpose**: Answer subtree or path queries efficiently
**Extension of**: Mo's algorithm on arrays
**Technique**: 
- Flatten tree using Euler tour
- Convert tree queries to range queries on flattened array
- Handle LCA specially for path queries
**Time Complexity**: O((n + q)√n) for n nodes, q queries

### Square Root Decomposition (Already covered)
**Also known as**: "Sqrt decomposition"
**Break array into blocks** of size ≈ √n
**Operations**: 
- Query: O(√n) (scan partial blocks + full blocks)
- Update: O(1) or O(√n) depending on type
**Variants**: 
- Mo's algorithm (query optimization)
- Sqrt tree (O(log log n) queries)
- Trees on sqrt decomposition

### Sparse Table (Already covered)
**Purpose**: Static range queries (idempotent operations like min, max, gcd)
**Preprocessing**: O(n log n)
**Query**: O(1)
**Limitation**: Only works for immutable arrays and idempotent operations

### Segment Tree Beats
**Purpose**: Complex segment tree that handles range chmin/chmax/add/sum queries
**Applications**: 
- Range minimum/maximum queries with updates
- Some complex DP optimizations
**Time Complexity**: O(log n) amortized per operation
**Much more complex** than standard segment tree

### Link-Cut Tree (Already mentioned)
**Purpose**: Dynamic trees
**Preferred** when we need to change tree structure frequently
**Alternative**: Euler Tour Trees for forests only

### Skip List
**Purpose**: Probabilistic alternative to balanced binary search trees
**Expected time**: O(log n) for search, insert, delete
**Simpler to implement** than red-black or AVL trees
**Good cache performance** in some cases
**Space overhead**: O(n) expected

```cpp
struct SkipListNode {
    int key;
    vector<SkipListNode*> forward;
    SkipListNode(int k, int level) : key(k), forward(level, nullptr) {}
};

class SkipList {
    int max_level;
    double p; // Probability
    int level;
    SkipListNode* header;
    
public:
    SkipList(int max_level = 16, double p = 0.5) : max_level(max_level), p(p) {
        level = 0;
        header = new SkipListNode(INT_MIN, max_level);
    }
    
    int random_level() {
        int lvl = 1;
        while (((double)rand() / RAND_MAX) < p && lvl < max_level) {
            lvl++;
        }
        return lvl;
    }
    
    void insert(int key) {
        vector<SkipListNode*> update(max_level + 1);
        SkipListNode* current = header;
        
        // Find where to insert
        for (int i = level; i >= 0; i--) {
            while (current->forward[i] && current->forward[i]->key < key) {
                current = current->forward[i];
            }
            update[i] = current;
        }
        
        current = current->forward[0];
        
        // If key already exists, update or skip
        if (current && current->key == key) {
            // Handle duplicate key
            return;
        }
        
        // Generate random level for new node
        int rlevel = random_level();
        
        // If random level is greater than current level, update update pointers
        if (rlevel > level) {
            for (int i = level + 1; i <= rlevel; i++) {
                update[i] = header;
            }
            level = rlevel;
        }
        
        // Create new node
        SkipListNode* n = new SkipListNode(key, rlevel);
        
        // Insert node
        for (int i = 0; i < rlevel; i++) {
            n->forward[i] = update[i]->forward[i];
            update[i]->forward[i] = n;
        }
    }
    
    bool remove(int key) {
        vector<SkipListNode*> update(max_level + 1);
        SkipListNode* current = header;
        
        // Find node to delete
        for (int i = level; i >= 0; i--) {
            while (current->forward[i] && current->forward[i]->key < key) {
                current = current->forward[i];
            }
            update[i] = current;
        }
        
        current = current->forward[0];
        
        // If key doesn't exist
        if (!current || current->key != key) {
            return false;
        }
        
        // Remove node from all levels
        for (int i = 0; i < level; i++) {
            if (update[i]->forward[i] != current) {
                break;
            }
            update[i]->forward[i] = current->forward[i];
        }
        
        // Remove levels that have no elements
        while (level > 0 && header->forward[level] == nullptr) {
            level--;
        }
        
        delete current;
        return true;
    }
    
    bool search(int key) {
        SkipListNode* current = header;
        
        for (int i = level; i >= 0; i--) {
            while (current->forward[i] && current->forward[i]->key < key) {
                current = current->forward[i];
            }
        }
        
        current = current->forward[0];
        
        if (current && current->key == key) {
            return true;
        }
        return false;
    }
};
```

## Choosing the Right Data Structure

### Decision Tree
1. **Do I need to maintain order?**
   - Yes → Consider BST variants, heaps, skip lists
   - No → Consider hash tables, bloom filters

2. **What operations do I need?**
   - **Insert/Delete/Lookup**: 
     - Hash table (average O(1))
     - Balanced BST (O(log n))
     - Skip list (expected O(log n))
   - **Prefix sums/range queries**:
     - Fenwick tree (O(log n))
     - Segment tree (O(log n))
     - Sparse table (O(1) for static)
   - **Order statistics (k-th smallest)**:
     - Order statistic tree (BST with size info)
     - Fenwick tree + binary search
     - Segment tree
   - **Geometric queries**:
     - KD-tree, quadtree, etc.
   - **String queries**:
     - Trie, suffix array, suffix automaton
   - **Graph connectivity**:
     - Union-find, dynamic connectivity structures

3. **What are the constraints?**
   - **Small n (< 1000)**: Almost anything works
   - **Medium n (1000-10⁵)**: O(log n) or O(√n) preferred
   - **Large n (10⁵-10⁶)**: O(log n) with good constants, O(n) preprocessing
   - **Very large n (10⁶+)**: O(n) or O(n log n) with very low constants, or mathematical formulas

4. **Do I need persistence?**
   - Yes → Persistent segment tree, persistent trie, etc.
   - No → Standard versions

5. **Do I need to support updates?**
   - Yes → Choose structures that support updates efficiently
   - No → Can use static structures like sparse table

### Common Trade-offs
- **Time vs Space**: Faster queries often use more space
- **Average vs Worst Case**: Hash tables (O(1) avg, O(n) worst) vs BST (O(log n) worst)
- **Simplicity vs Performance**: Skip lists vs red-black trees
- **Online vs Offline**: Can we see all queries in advance?
- **Specific vs General**: Specialized structures often faster but less flexible

### When to Use What
- **Fenwick Tree**: When you need prefix sums and point updates (or vice versa)
- **Segment Tree**: When you need more complex range queries (min/max/sum/etc.) or when you need to update ranges
- **Sparse Table**: When you have static data and need O(1) range queries for idempotent operations (min, max, gcd)
- **Binary Search Tree**: When you need to maintain sorted order and do insert/delete/lookup
- **Hash Table**: When you need fast lookup and don't care about order
- **Trie**: When you're dealing with string prefixes or need to store a dictionary for quick lookup
- **Suffix Array/Automaton**: When you need to process all substrings of a string efficiently
- **Union-Find**: When you need to maintain disjoint sets and do union/find operations
- **Heap/Priority Queue**: When you need to repeatedly access the minimum/maximum element
- **KD-Tree**: When you need to do nearest neighbor searches in k-dimensional space
- **Heavy-Light Decomposition**: When you need to do path queries on trees
- **Mo's Algorithm**: When you need to answer many range queries on an array or tree
- **Bloom Filter**: When you need space-efficient set membership testing and can tolerate false positives
- **Skip List**: When you want a simpler alternative to balanced BSTs
- **Link-Cut Tree**: When you need to maintain a dynamic forest with link/cut operations
- **Persistent Segment Tree**: When you need to query different versions of an array after updates
- **DSU on Tree**: When you need to answer queries on subtrees of a tree

### Implementation Tips
1. **Start Simple**: Begin with the simplest structure that could work
2. **Measure**: If performance is an issue, profile to find bottlenecks
3. **Know Your Constants**: O(log n) with high constant can be slower than O(√n) for practical n
4. **Consider Memory**: Some structures (like sparse table) use significant memory
5. **Test Edge Cases**: Empty structures, single elements, maximum sizes
6. **Use Existing Implementations**: Don't reinvent the wheel unless necessary
7. **Think About Cache**: Access patterns matter for performance
8. **Amortized vs Worst Case**: Understand what the complexity guarantees mean
9. **Parallelism**: Some structures are easier to parallelize than others
10. **Problem-Specific Optimizations**: Sometimes you can exploit problem constraints

### Practice Problems by Structure
**Fenwick Tree**: 
- Count inversions
- Dynamic range sum queries
- Coordinate compression + Fenwick tree

**Segment Tree**:
- Range minimum/maximum query
- Range sum with updates
- Lazy propagation problems (range updates, range queries)

**Sparse Table**:
- Static RMQ problems
- GCD range queries
- Idempotent operations on static arrays

**Binary Search Tree**:
- Order statistic tree
- Treap problems
- Splay tree applications

**Hash Table**:
- Frequency counting
- Two-sum variants
- Caching/memoization

**Trie**:
- Maximum XOR pair
- Dictionary implementation
- Prefix matching problems

**Suffix Array/Automaton**:
- Longest repeated substring
- Longest common substring
- String compression
- Pattern matching with multiple patterns

**Union-Find**:
- Connected components
- Minimum spanning tree (Kruskal)
- Dynamic connectivity offline
- Friend circles

**Heap/Priority Queue**:
- Dijkstra's algorithm
- Event simulation
- K-way merge
- Sliding window maximum/minimum

**KD-Tree**:
- Nearest neighbor search
- K closest points
- Range search in 2D/3D

**HLD**:
- Path queries on trees
- Subtree queries
- Dynamic tree problems

**Mo's Algorithm**:
- Powerful array queries
- Tree queries (Mo's on tree)
- D-query type problems

**Bloom Filter**:
- Spell checking approximations
- Duplicate detection with limited memory
- Network applications

**Skip List**:
- Alternative to BST implementations
- Concurrent programming (some variants)

**Link-Cut Tree**:
- Dynamic tree problems
- Network connectivity with updates
- Some competitive programming problems involving changing trees

**Persistent Segment Tree**:
- K-th number in subarray
- Persistent arrays
- Some geometric problems with time dimension

**DSU on Tree**:
- Subtree queries with aggregation
- Heavy-light decomposition alternative for some problems
- Tree problems requiring subtree information

---

## Conclusion

Choosing the right data structure is often the key to solving competitive programming problems efficiently. While it's important to know how to implement these structures, it's even more important to develop the intuition to recognize which structure is appropriate for a given problem.

Remember these guiding principles:
1. **Start with the problem**: What operations do you need to support efficiently?
2. **Consider constraints**: What are the time and space limits?
3. **Think about access patterns**: How will you be querying and updating the data?
4. **Don't over-engineer**: Sometimes a simple array or hash table is sufficient
5. **Learn from others**: Study how experienced competitors approach similar problems
6. **Practice implementation**: The best way to understand a data structure is to implement it yourself
7. **Watch for special cases**: Many problems have constraints that allow simpler solutions

Mastering these data structures will give you a powerful toolkit for tackling a wide range of competitive programming challenges. As you practice, you'll develop a sense for which tool to reach for when faced with a new problem.

Happy coding, and may your data structures always be balanced and your hash functions collision-free! 🚀