# Hash Table Tutorial

## Overview
A hash table (also called hash map) is a data structure that implements an associative array abstract data type, a structure that can map keys to values. It uses a hash function to compute an index into an array of buckets or slots, from which the desired value can be found.

## Key Characteristics
- **Key-Value Storage**: Stores data as key-value pairs
- **Average O(1) Operations**: Insert, delete, and search operations
- **Hash Function**: Maps keys to array indices
- **Collision Handling**: Multiple strategies to handle when keys hash to same index
- **Dynamic Resizing**: Automatically grows/shrinks to maintain efficiency

## Hash Table Structure
```
Hash Table Structure:
+------------------+
|  Bucket Array    |
|  [0]  [1]  [2]   |  <-- Index from hash function
|  [3]  [4]  [5]   |
|  [6]  [7]  [8]   |
|  [9] [10] [11]   |
+------------------+
     ||    ||    ||
  [K,V] [K,V]    [K,V]  <-- Each bucket may contain multiple entries (collision resolution)
```

## How Hash Tables Work

### 1. Hash Function
Converts a key into an array index:
```
index = hash(key) % array_size
```

**Good hash function properties:**
- Deterministic: Same key always produces same hash
- Uniform distribution: Keys spread evenly across array
- Efficient: Fast to compute
- Minimizes collisions: Different keys rarely hash to same value

### 2. Collision Resolution
When two keys hash to the same index, we need strategies to handle it:

#### A. Separate Chaining
Each bucket contains a linked list (or other structure) of entries
```
Index 3: [ (key1,value1) → (key2,value2) → (key3,value3) → NULL ]
```

#### B. Open Addressing
Find another open slot in the array when collision occurs:
- **Linear Probing**: Check next sequential slot
- **Quadratic Probing**: Check slots at intervals of 1², 2², 3², ...
- **Double Hashing**: Use second hash function to determine step size

## Time Complexity Analysis

| Operation | Average Case | Worst Case | Notes |
|-----------|--------------|------------|-------|
| Search | O(1) | O(n) | Worst case when all keys collide |
| Insert | O(1)* | O(n)* | *Amortized with resizing |
| Delete | O(1) | O(n) |  |
| Space | O(n) | O(n) | Proportional to number of elements |

*Note: With good hash function and proper resizing, amortized O(1)

### Load Factor
- **Load Factor (α)**: n / m where n = number of elements, m = number of buckets
- **Ideal Range**: 0.6 - 0.75 for good performance
- **Resizing Trigger**: When α exceeds threshold (typically 0.75)
- **Resizing Strategy**: Usually double the array size and rehash all elements

## Real-World Analogy
Think of a hash table like a library's book return system:
- Each book has a unique ID (key)
- The librarian uses a quick system (hash function) to determine which cart (bucket) to place the book in
- Multiple books might go to the same cart (collision), so they're stacked in that cart (chaining)
- To find a book, the librarian computes which cart it should be in, then searches that cart
- If carts get too full, the librarian gets more carts and redistributes books (resizing)

## Visual Explanation

### Separate Chaining Example
```
Keys: "apple"→5, "banana"→3, "cherry"→5, "date"→2
Array Size: 7

Index:  0   1   2       3       4   5           6
       [ ] [ ] [date] [banana] [ ] [apple→cherry] [ ]
                              ↑         ↑
                        Single entry  Chain of 2 entries
```

### Linear Probing Example
Same keys with linear probing:
```
Index:  0   1   2       3       4   5       6
       [ ] [ ] [date] [banana] [ ] [apple] [cherry]
                              ↑         ↑         ↑
                            No collision  Found empty  Found empty slot
                                      slot after     after linear probe
                                      apple          (skipping occupied)
                                      slot
```

## Implementation Examples

### Python (Built-in dict - but showing concepts)
```python
# Python's dict is actually a hash table implementation
# Here's a conceptual implementation to show how it works

class HashTable:
    def __init__(self, capacity=8):
        self.capacity = capacity
        self.size = 0
        self.buckets = [[] for _ in range(capacity)]  # Separate chaining
    
    def _hash(self, key):
        """Simple hash function for demonstration"""
        return hash(key) % self.capacity
    
    def put(self, key, value):
        """Insert key-value pair"""
        index = self._hash(key)
        bucket = self.buckets[index]
        
        # Check if key already exists
        for i, (k, v) in enumerate(bucket):
            if k == key:
                bucket[i] = (key, value)  # Update existing
                return
        
        # Key not found, add new entry
        bucket.append((key, value))
        self.size += 1
        
        # Resize if load factor too high
        if self.size > self.capacity * 0.75:
            self._resize()
    
    def get(self, key):
        """Retrieve value by key"""
        index = self._hash(key)
        bucket = self.buckets[index]
        
        for k, v in bucket:
            if k == key:
                return v
        raise KeyError(key)
    
    def remove(self, key):
        """Remove key-value pair"""
        index = self._hash(key)
        bucket = self.buckets[index]
        
        for i, (k, v) in enumerate(bucket):
            if k == key:
                del bucket[i]
                self.size -= 1
                return v
        raise KeyError(key)
    
    def _resize(self):
        """Double capacity and rehash all elements"""
        old_buckets = self.buckets
        self.capacity *= 2
        self.buckets = [[] for _ in range(self.capacity)]
        self.size = 0  # Will be recalculated during rehash
        
        for bucket in old_buckets:
            for key, value in bucket:
                self.put(key, value)  # Reinsert with new capacity

# Usage
ht = HashTable()
ht.put("apple", 5)
ht.put("banana", 3)
print(ht.get("apple"))  # 5
ht.remove("banana")
```

### Java (Conceptual Implementation)
```java
import java.util.*;

public class HashTable<K, V> {
    private static final double LOAD_FACTOR_THRESHOLD = 0.75;
    private int capacity;
    private int size;
    private LinkedList<Entry<K, V>>[] buckets;
    
    static class Entry<K, V> {
        K key;
        V value;
        
        Entry(K key, V value) {
            this.key = key;
            this.value = value;
        }
    }
    
    @SuppressWarnings("unchecked")
    public HashTable(int initialCapacity) {
        this.capacity = initialCapacity;
        this.size = 0;
        this.buckets = new LinkedList[initialCapacity];
        for (int i = 0; i < initialCapacity; i++) {
            this.buckets[i] = new LinkedList<>();
        }
    }
    
    private int hash(K key) {
        return (key == null) ? 0 : Math.abs(key.hashCode()) % capacity;
    }
    
    public void put(K key, V value) {
        int index = hash(key);
        LinkedList<Entry<K, V>> bucket = buckets[index];
        
        // Check if key exists
        for (Entry<K, V> entry : bucket) {
            if (Objects.equals(entry.key, key)) {
                entry.value = value;  // Update
                return;
            }
        }
        
        // Key not found, add new entry
        bucket.add(new Entry<>(key, value));
        size++;
        
        // Check if resize needed
        if ((double) size / capacity > LOAD_FACTOR_THRESHOLD) {
            resize();
        }
    }
    
    public V get(K key) {
        int index = hash(key);
        LinkedList<Entry<K, V>> bucket = buckets[index];
        
        for (Entry<K, V> entry : bucket) {
            if (Objects.equals(entry.key, key)) {
                return entry.value;
            }
        }
        return null;  // Or throw exception
    }
    
    public V remove(K key) {
        int index = hash(key);
        LinkedList<Entry<K, V>> bucket = buckets[index];
        
        for (Iterator<Entry<K, V>> it = bucket.iterator(); it.hasNext(); ) {
            Entry<K, V> entry = it.next();
            if (Objects.equals(entry.key, key)) {
                it.remove();
                size--;
                return entry.value;
            }
        }
        return null;  // Or throw exception
    }
    
    @SuppressWarnings("unchecked")
    private void resize() {
        LinkedList<Entry<K, V>>[] oldBuckets = buckets;
        capacity *= 2;
        buckets = new LinkedList[capacity];
        size = 0;
        
        for (int i = 0; i < oldBuckets.length; i++) {
            buckets[i] = new LinkedList<>();
        }
        
        for (LinkedList<Entry<K, V>> bucket : oldBuckets) {
            for (Entry<K, V> entry : bucket) {
                put(entry.key, entry.value);  // Rehash and reinsert
            }
        }
    }
}
```

### C++ (Conceptual Implementation)
```cpp
#include <iostream>
#include <vector>
#include <list>
#include <functional>
#include <stdexcept>
#include <string>

template <typename K, typename V>
class HashTable {
private:
    static const double LOAD_FACTOR_THRESHOLD;
    size_t capacity;
    size_t size;
    std::vector<std::list<std::pair<K, V>>> buckets;
    
    size_t hash(const K& key) const {
        return std::hash<K>{}(key) % capacity;
    }
    
    void resize() {
        size_t oldCapacity = capacity;
        capacity *= 2;
        std::vector<std::list<std::pair<K, V>>> newBuckets(capacity);
        size = 0;  // Will be recalculated
        
        for (size_t i = 0; i < oldCapacity; i++) {
            for (const auto& pair : buckets[i]) {
                // Rehash and insert into new table
                size_t newIndex = std::hash<K>{}(pair.first) % capacity;
                newBuckets[newIndex].push_back(pair);
                size++;
            }
        }
        
        buckets.swap(newBuckets);
    }
    
public:
    HashTable(size_t initialCapacity = 8) 
        : capacity(initialCapacity), size(0), buckets(initialCapacity) {}
    
    void put(const K& key, const V& value) {
        size_t index = hash(key);
        auto& bucket = buckets[index];
        
        // Check if key exists
        for (auto& pair : bucket) {
            if (pair.first == key) {
                pair.second = value;  // Update
                return;
            }
        }
        
        // Key not found, add new entry
        bucket.push_back({key, value});
        size++;
        
        // Check if resize needed
        if (static_cast<double>(size) / capacity > LOAD_FACTOR_THRESHOLD) {
            resize();
        }
    }
    
    V get(const K& key) {
        size_t index = hash(key);
        auto& bucket = buckets[index];
        
        for (const auto& pair : bucket) {
            if (pair.first == key) {
                return pair.second;
            }
        }
        throw std::out_of_range("Key not found");
    }
    
    void remove(const K& key) {
        size_t index = hash(key);
        auto& bucket = buckets[index];
        
        for (auto it = bucket.begin(); it != bucket.end(); ++it) {
            if (it->first == key) {
                bucket.erase(it);
                size--;
                return;
            }
        }
        throw std::out_of_range("Key not found");
    }
    
    bool contains(const K& key) const {
        size_t index = hash(key);
        const auto& bucket = buckets[index];
        
        for (const auto& pair : bucket) {
            if (pair.first == key) {
                return true;
            }
        }
        return false;
    }
    
    size_t getSize() const { return size; }
    bool isEmpty() const { return size == 0; }
};

// Initialize static member
template <typename K, typename V>
const double HashTable<K, V>::LOAD_FACTOR_THRESHOLD = 0.75;

// Usage example
/*
int main() {
    HashTable<std::string, int> ht;
    ht.put("apple", 5);
    ht.put("banana", 3);
    std::cout << ht.get("apple") << std::endl;  // 5
    ht.remove("banana");
    return 0;
}
*/
```

### JavaScript (Conceptual Implementation)
```javascript
class HashTable {
    constructor(initialCapacity = 8) {
        this.capacity = initialCapacity;
        this.size = 0;
        this.loadFactorThreshold = 0.75;
        this.buckets = new Array(initialCapacity);
        for (let i = 0; i < initialCapacity; i++) {
            this.buckets[i] = [];
        }
    }
    
    hash(key) {
        // Simple hash function for strings
        let hash = 0;
        for (let i = 0; i < key.length; i++) {
            hash = (hash * 31 + key.charCodeAt(i)) % this.capacity;
        }
        return Math.abs(hash);
    }
    
    put(key, value) {
        const index = this.hash(key);
        const bucket = this.buckets[index];
        
        // Check if key exists
        for (let i = 0; i < bucket.length; i++) {
            if (bucket[i][0] === key) {
                bucket[i][1] = value;  // Update value
                return;
            }
        }
        
        // Key not found, add new entry
        bucket.push([key, value]);
        this.size++;
        
        // Check if resize needed
        if (this.size / this.capacity > this.loadFactorThreshold) {
            this.resize();
        }
    }
    
    get(key) {
        const index = this.hash(key);
        const bucket = this.buckets[index];
        
        for (let i = 0; i < bucket.length; i++) {
            if (bucket[i][0] === key) {
                return bucket[i][1];
            }
        }
        return undefined;  // Or throw error
    }
    
    remove(key) {
        const index = this.hash(key);
        const bucket = this.buckets[index];
        
        for (let i = 0; i < bucket.length; i++) {
            if (bucket[i][0] === key) {
                bucket.splice(i, 1);
                this.size--;
                return;
            }
        }
        // Or throw error if not found
    }
    
    resize() {
        this.capacity *= 2;
        const oldBuckets = this.buckets;
        this.buckets = new Array(this.capacity);
        this.size = 0;
        
        for (let i = 0; i < oldBuckets.length; i++) {
            this.buckets[i] = [];
        }
        
        for (let bucket of oldBuckets) {
            for (let [key, value] of bucket) {
                this.put(key, value);  // Rehash and reinsert
            }
        }
    }
    
    contains(key) {
        return this.get(key) !== undefined;
    }
    
    getSize() {
        return this.size;
    }
    
    isEmpty() {
        return this.size === 0;
    }
}
```