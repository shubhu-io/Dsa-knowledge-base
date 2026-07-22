# Amortized Analysis

Understanding average performance over a sequence of operations.

## What is Amortized Analysis?

Amortized analysis finds the **average cost per operation** over a worst-case sequence of operations. Unlike average-case analysis (which assumes random input), amortized analysis guarantees the average for ANY sequence.

```
Regular Analysis:  "What's the worst case for ONE operation?"
Amortized Analysis: "What's the average cost per operation over MANY operations?"
```

### Key Difference from Average Case

| Analysis Type | Input Assumption | Guarantee |
|--------------|-----------------|-----------|
| Worst case | Any input | Upper bound per operation |
| Average case | Random input | Expected cost per operation |
| Amortized | Any sequence | Average cost per operation |

---

## Why Amortized Analysis?

Some operations are occasionally expensive but usually cheap. Amortized analysis captures this:

```
Dynamic Array Insertion:
  Most inserts:    O(1) — just add to end
  Sometimes:       O(n) — need to resize

  Without amortized: "O(n) worst case" (misleading)
  With amortized:    "O(1) amortized" (accurate)
```

---

## Three Methods of Amortized Analysis

### Method 1: Aggregate Analysis

Count the total cost over n operations and divide by n.

**Example: Dynamic Array (Python list)**

```python
class DynamicArray:
    def __init__(self):
        self.capacity = 1
        self.size = 0
        self.data = [None] * self.capacity

    def append(self, item):
        if self.size == self.capacity:
            self._resize()           # O(n) occasionally
        self.data[self.size] = item  # O(1)
        self.size += 1

    def _resize(self):
        new_data = [None] * (self.capacity * 2)
        for i in range(self.size):
            new_data[i] = self.data[i]  # O(n) — copy all elements
        self.data = new_data
        self.capacity *= 2
```

**Aggregate Analysis:**
```
Inserting n elements:
  - Elements 1, 2, 4, 8, ..., n: these trigger resize
  - Cost of each resize: 1, 2, 4, 8, ..., n
  - Total resize cost: 1 + 2 + 4 + 8 + ... + n = 2n
  - Total insert cost: n (one per element)
  - Grand total: n + 2n = 3n

Amortized cost per operation: 3n / n = O(1)
```

### Method 2: Accounting Method

Assign different "charges" to operations. Some operations are overcharged to pay for future expensive ones.

```
Assign amortized cost:
  - Regular insert: charge 3 (1 for current, 2 saved for future resize)
  - Resize: paid for by saved charges (costs n, but we saved n/2 charges)

For n insertions:
  Total charged: 3n
  Total actual cost: n + 2n = 3n
  Balance is always >= 0  ✓
```

**Bank Account Analogy:**
```
Each insert deposits $3:
  $1 pays for the insert itself
  $2 goes into savings

When resize happens:
  Cost = n, but we have n/2 elements × $2 saved = $n in savings
  Savings exactly covers the resize!

Minimum balance is always $0 or positive → guaranteed O(1) amortized
```

### Method 3: Potential Method

Define a potential function Phi that represents stored energy.

```
Amortized cost = Actual cost + Change in potential

For dynamic array:
  Phi(D) = 2 * size - capacity

  Regular insert:
    Actual cost: 1
    Phi(before): 2k - c   (k elements, capacity c)
    Phi(after): 2(k+1) - c = 2k + 2 - c
    Amortized: 1 + (2k+2-c) - (2k-c) = 3

  Resize insert:
    Actual cost: n + 1  (n copies + 1 insert)
    Phi(before): 2n - n = n  (n elements, capacity n)
    Phi(after): 2(n+1) - 2n = 2
    Amortized: (n+1) + 2 - n = 3

Both cases: O(1) amortized ✓
```

---

## Classic Amortized Analysis Examples

### Example 1: Stack with Multipop

```python
class Stack:
    def __init__(self):
        self.data = []

    def push(self, item):
        self.data.append(item)        # O(1) amortized

    def pop(self):
        return self.data.pop()        # O(1) amortized

    def multipop(self, k):
        count = 0
        while self.data and count < k:
            self.data.pop()           # O(1) each
            count += 1
        return count
```

**Analysis:**
```
Sequence of n operations (push, pop, multipop):
  - Each element pushed at most once
  - Each element popped at most once
  - Total pops across all multipops <= n

Total operations: <= 2n
Amortized cost per operation: O(1)
```

### Example 2: Binary Counter

```python
class BinaryCounter:
    def __init__(self, bits):
        self.bits = [0] * bits
        self.flips = 0

    def increment(self):
        i = 0
        while i < len(self.bits) and self.bits[i] == 1:
            self.bits[i] = 0         # Flip 1 to 0
            i += 1
            self.flips += 1
        if i < len(self.bits):
            self.bits[i] = 1         # Flip 0 to 1
            self.flips += 1
```

**Aggregate Analysis:**
```
Incrementing n times:
  - Bit 0 flips every time: n flips
  - Bit 1 flips every 2 times: n/2 flips
  - Bit 2 flips every 4 times: n/4 flips
  - Bit k flips every 2^k times: n/2^k flips
  - Total: n + n/2 + n/4 + ... + 1 = 2n

Amortized cost per increment: 2n/n = O(1)
```

```
Binary counting with flip counts:

  0000 (0)  -> 0001 (1)  : 1 flip
  0001 (1)  -> 0010 (2)  : 2 flips
  0010 (2)  -> 0011 (3)  : 1 flip
  0011 (3)  -> 0100 (4)  : 3 flips
  0100 (4)  -> 0101 (5)  : 1 flip
  0101 (5)  -> 0110 (6)  : 2 flips
  0110 (6)  -> 0111 (7)  : 1 flip
  0111 (7)  -> 1000 (8)  : 4 flips
  
  Average: 16 flips / 8 operations = 2 flips per operation
```

### Example 3: Union-Find (with path compression + union by rank)

```python
class UnionFind:
    def __init__(self, n):
        self.parent = list(range(n))
        self.rank = [0] * n

    def find(self, x):
        if self.parent[x] != x:
            self.parent[x] = self.find(self.parent[x])  # Path compression
        return self.parent[x]

    def union(self, x, y):
        px, py = self.find(x), self.find(y)
        if px == py:
            return False
        if self.rank[px] < self.rank[py]:
            px, py = py, px
        self.parent[py] = px
        if self.rank[px] == self.rank[py]:
            self.rank[px] += 1
        return True
```

**Analysis:**
```
Without optimization: O(log n) per operation
With path compression + union by rank: O(α(n)) amortized

α(n) = inverse Ackermann function:
  α(1) = 0
  α(2) = 1
  α(16) = 2
  α(65536) = 3
  α(2^(2^(65536))) = 4

In practice: α(n) <= 4 for any practical input size
Effectively O(1) amortized!
```

---

## Amortized Analysis in Practice

### When to Use Amortized Analysis

| Scenario | Example | Amortized Complexity |
|----------|---------|---------------------|
| Dynamic resizing | Python list, Java ArrayList | O(1) append |
| Stack multipop | Batch processing | O(1) per element |
| Binary counter | Increment operations | O(1) per increment |
| Union-Find | Dynamic connectivity | O(α(n)) per operation |
| Splay trees | Any sequence of accesses | O(log n) per access |
| Hash table resizing | Open addressing | O(1) per operation |

### When NOT to Use Amortized Analysis

- Real-time systems (can't tolerate occasional O(n) operations)
- When you need per-operation worst-case guarantees
- When input distribution is known and different from worst case

---

## Common Amortized Complexities

| Data Structure | Operation | Worst Case | Amortized |
|---------------|-----------|-----------|-----------|
| Dynamic Array | append | O(n) | O(1) |
| Dynamic Array | pop (end) | O(1) | O(1) |
| Stack | push | O(1) | O(1) |
| Stack | pop | O(1) | O(1) |
| Queue (circular) | enqueue | O(n)* | O(1) |
| Queue (linked) | enqueue | O(1) | O(1) |
| Hash Table | insert | O(n) | O(1) |
| Hash Table | search | O(n) | O(1) |
| Union-Find | find | O(log n) | O(α(n)) |
| Union-Find | union | O(log n) | O(α(n)) |
| Splay Tree | access | O(n) | O(log n) |
| Binary Counter | increment | O(log n) | O(1) |

*For non-circular array-based queue without resizing

---

## Interview Tips

1. **When interviewer asks about a data structure with occasional expensive ops**: Think amortized analysis
2. **Python list append is O(1) amortized**: Interviewers may test this
3. **Explain the resize logic**: Show the aggregate analysis
4. **Know Union-Find amortized complexity**: O(α(n)) is nearly constant

## Resources

- "Introduction to Algorithms" (CLRS) Chapter 17: Amortized Analysis
- "Algorithm Design" by Kleinberg & Tardos, Chapter 4
- MIT 6.006 Lecture on Amortized Analysis
