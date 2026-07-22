# Hash Table Cheat Sheet

## Core Concepts

### What is a Hash Table?
A data structure that implements an associative array, mapping keys to values using a hash function to compute array indices.

### Key Properties
- **Average Case**: O(1) for insert, delete, search
- **Worst Case**: O(n) for all operations (when all keys collide)
- **Space Complexity**: O(n)
- **Not ordered**: Does not maintain any specific order of elements

### Hash Function Requirements
1. **Deterministic**: Same key always produces same hash
2. **Uniform Distribution**: Keys spread evenly across array
3. **Efficient**: Fast to compute
4. **Minimizes Collisions**: Different keys rarely hash to same value

## Common Operations

### Basic Operations
| Operation | Average Time | Worst Time | Description |
|-----------|--------------|------------|-------------|
| Insert | O(1) | O(n) | Add key-value pair |
| Search | O(1) | O(n) | Find value by key |
| Delete | O(1) | O(n) | Remove key-value pair |
| Get Size | O(1) | O(1) | Return number of elements |

### Hash Table Variants
1. **Separate Chaining**: Each bucket contains a linked list of entries
2. **Open Addressing**: Find alternative slot when collision occurs
   - Linear Probing: Check consecutive slots
   - Quadratic Probing: Check slots at i² intervals
   - Double Hashing: Use second hash function for step size

## Implementation Details

### Load Factor
- **Formula**: α = n / m (number of elements / number of buckets)
- **Ideal Range**: 0.6 - 0.75
- **Resizing Trigger**: When α > threshold (typically 0.75)
- **Resizing Strategy**: Usually double size and rehash all elements

### Common Hash Functions
#### For Strings
```python
def djb2(s):
    hash = 5381
    for c in s:
        hash = ((hash << 5) + hash) + ord(c)  # hash * 33 + c
    return hash

def sdbm(s):
    hash = 0
    for c in s:
        hash = ord(c) + (hash << 6) + (hash << 16) - hash
    return hash
```

#### For Integers
```python
def hash_int(x):
    x = ((x >> 16) ^ x) * 0x45d9f3b
    x = ((x >> 16) ^ x) * 0x45d9f3b
    x = (x >> 16) ^ x
    return x
```

## Collision Resolution Strategies

### Separate Chaining
```
Bucket[i]: [ (k1,v1) → (k2,v2) → (k3,v3) → NULL ]
```
**Pros**:
- Simple to implement
- Performance degrades gracefully
- No upper limit on elements (memory permitting)

**Cons**:
- Extra memory for pointers
- Potential for long chains
- Poor cache locality (pointer chasing)

### Open Addressing
**Linear Probing**: index = (hash(key) + i) % capacity
**Quadratic Probing**: index = (hash(key) + c1*i + c2*i²) % capacity
**Double Hashing**: index = (hash1(key) + i * hash2(key)) % capacity

**Pros**:
- Better cache locality (contiguous memory)
- No extra memory for pointers

**Cons**:
- Clustering problems (especially linear probing)
- Need to handle deletion carefully (tombstones)
- Performance degrades significantly at high load factors

## When to Use Hash Tables

### ✅ Use When
- Need fast lookups by key (average O(1))
- Frequent insertions and deletions
- Order doesn't matter
- Implementing caches, databases, symbol tables
- Frequency counting/categorization tasks

### ❌ Avoid When
- Need ordered iteration (use BST instead)
- Memory is extremely constrained
- Need guaranteed worst-case performance
- Very small datasets (linear search might be faster)
- Poor hash function causing many collisions

## Common Patterns in Problems

### 1. Frequency Counting
```python
# Count occurrences
freq = {}
for item in collection:
    freq[item] = freq.get(item, 0) + 1
```

### 2. Two-Pass Approach
```python
# First pass: build map
map = {}
for item in collection:
    # process and store in map
    
# Second pass: use map
for item in collection:
    # lookup in map
```

### 3. Prefix Sum + Hash Map
```python
# For subarray sum problems
prefix_sum = 0
sum_map = {0: 1}  # sum -> frequency
count = 0

for num in array:
    prefix_sum += num
    if (prefix_sum - target) in sum_map:
        count += sum_map[prefix_sum - target]
    sum_map[prefix_sum] = sum_map.get(prefix_sum, 0) + 1
```

### 4. Sliding Window + Hash Map
```python
# For substring problems
char_index = {}
left = 0
max_len = 0

for right in range(len(s)):
    char = s[right]
    if char in char_index and char_index[char] >= left:
        left = char_index[char] + 1
    char_index[char] = right
    max_len = max(max_len, right - left + 1)
```

## Implementation Tips

### 1. Choosing Initial Size
- Estimate expected number of elements
- Set initial capacity = expected_size / 0.75
- Powers of 2 often work well with bitwise operations

### 2. Handling Collisions
- Separate chaining is simpler and more robust
- Open addressing better for cache performance when load factor low
- Consider application-specific needs

### 3. Deletion Handling
- **Chaining**: Simple removal from linked list
- **Open Addressing**: 
  - Tombstones (mark as deleted, reuse later)
  - Rehashing after deletion
  - Periodic cleanup to remove tombstone buildup

### 4. Resizing Strategy
- Double size when exceeding load factor threshold
- Consider shrinking when load factor very low (< 0.25)
- Rehashing is expensive - amortize cost over many operations
- Gradual resizing techniques for real-time systems

### 5. Key Immutability
- Keys should not change while in hash table
- If using mutable objects as keys, ensure they don't change hash value
- Best practice: use immutable types as keys (strings, numbers, tuples)

## Language-Specific Implementations

### Python
- Built-in `dict`: Highly optimized hash table
- Keys must be hashable (immutable)
- Uses variant of djb2 hash function
- Combines chaining and open addressing strategies

### Java
- `HashMap<K,V>`: Standard hash table implementation
- `Hashtable<K,V>`: Synchronized version (legacy)
- `LinkedHashMap<K,V>`: Maintains insertion order
- Uses power-of-two capacities with bitwise AND for index
- Converts long chains to red-black trees when threshold exceeded

### C++
- `std::unordered_map<Key,Value>`: Hash table (C++11)
- `std::unordered_map<Key,Value,Hash,Pred>`: Customizable hash and predicate
- Typically implements separate chaining
- Rehashes when load factor > 1.0 (default)

### JavaScript
- Objects (`{}`) and `Map` objects use hash table principles
- Engines (V8, SpiderMonkey) use hidden classes and transitions for optimization
- `Map` preserves insertion order, objects do not (though modern engines often do)

## Time Complexity Summary

| Operation | Average Case | Worst Case | Notes |
|-----------|--------------|------------|-------|
| Search | O(1) | O(n) | All keys hash to same bucket |
| Insert | O(1)* | O(n)* | *Amortized with resizing |
| Delete | O(1) | O(n) |  |
| Space | O(n) | O(n) | Proportional to elements + table |

*With good hash function and proper resizing strategy

## Space Complexity Details
- **Storage for elements**: O(n)
- **Storage for table**: O(m) where m = number of buckets
- **Typical**: m ≈ n / load_factor, so O(n) overall
- **Overhead**: Pointers for chaining, empty buckets for probing

## Real-World Applications

### 1. Database Systems
- Indexing (primary keys, secondary indexes)
- Join operations (hash joins)
- Caching frequently accessed data
- Metadata storage

### 2. Caching Systems
- CPU caches (hardware implementation)
- Web caches (memcached, Redis)
- DNS caching
- Compiler symbol tables

### 3. Programming Languages
- Built-in dictionaries/objects
- Symbol tables in compilers/interpreters
- Attribute/object property storage
- Module/namespace resolution

### 4. Networking
- IP routing tables
- Flow tables in switches/routers
- Connection tracking (NAT, firewalls)
- Load balancer session persistence

### 5. Security & Cryptography
- Hash tables in hash-based data structures
- Rainbow tables (password cracking)
- Intrusion detection systems
- Cryptographic hash functions (related concept)

### 6. Bioinformatics
- Gene sequence indexing
- Protein database lookup
- Genome alignment tools
- Genetic variant databases

## Interview Tips

### What Interviewers Look For
1. **Understanding of fundamentals**: How hash tables work, hash functions, collisions
2. **Implementation knowledge**: Ability to implement basic hash table operations
3. **Problem-solving skills**: Applying hash tables to solve common algorithmic problems
4. **Trade-off awareness**: Knowing when to use hash tables vs. alternatives
5. **Optimization thinking**: Considering load factors, hash functions, resizing strategies

### Common Interview Questions
1. Implement a hash table with separate chaining
2. Design an LRU cache
3. Find the first non-repeating character in a string
4. Group anagrams together
5. Find two numbers that add up to a target
6. Find the length of longest substring without repeating characters
7. Subarray sum equals K
8. Longest consecutive sequence
9. Design a hash map without using built-in libraries
10. LFU cache implementation

### Follow-up Questions to Expect
- What happens when hash function is poor?
- How would you handle hash collision attacks?
- What's the difference between size and capacity?
- When would you choose a tree over a hash table?
- How does Java's HashMap handle collisions?
- What is amortized time complexity?

### Best Practices for Interview Answers
1. **Clarify requirements**: Ask about constraints, expected input size, operation distribution
2. **Discuss trade-offs**: Mention time/space complexity, when approach might not work
3. **Consider edge cases**: Empty input, single element, duplicates, invalid inputs
4. **Talk through your thinking**: Explain why you chose hash table, what hash function you'd use
5. **Mention alternatives**: Discuss when BST, sorting, or other approaches might be better
6. **Consider real-world constraints**: Memory limitations, hash function quality, concurrent access

## Quick Reference Formulas

### Load Factor
```
α = n / m
```
where n = number of elements, m = number of buckets

### Expected Chain Length (Separate Chaining)
```
E[length] = α
```

### Probability of Empty Bucket
```
P(empty) = (1 - 1/m)^n ≈ e^(-α)
```

### Expected Probes (Successful Search, Linear Probing)
```
E[probes] = ½ × (1 + 1/(1-α))
```

### Expected Probes (Unsuccessful Search, Linear Probing)
```
E[probes] = ½ × (1 + 1/(1-α)²)
```

### Double Hashing Formula
```
h(k,i) = (h1(k) + i × h2(k)) mod m
```
where h1 and h2 are different hash functions

## When to Consider Alternatives

### Use Binary Search Tree When
- Need ordered traversal (in-order, pre-order, post-order)
- Require O(log n) worst-case guarantees
- Doing many range queries
- Memory is very tight (less overhead than hash table for small n)

### Use Sorting + Binary Search When
- Data is static (no insertions/deletions after initial load)
- Can afford O(n log n) preprocessing time
- Memory is extremely limited
- Simplicity is preferred over constant-factor performance

### Use Bit Arrays/Bloom Filters When
- Only need set membership testing
- Can tolerate false positives
- Memory is extremely constrained
- Doing approximate membership queries

### Use Tries When
- Keys are strings with common prefixes
- Need prefix-based lookups
- Doing autocomplete or spell-checking
- Want lexicographical ordering

## Remember
Hash tables excel at average-case performance but have variability in worst-case behavior. Understanding when this trade-off is acceptable—and how to mitigate worst-case scenarios through good hash function design and proper resizing strategies—is key to using them effectively in practice.