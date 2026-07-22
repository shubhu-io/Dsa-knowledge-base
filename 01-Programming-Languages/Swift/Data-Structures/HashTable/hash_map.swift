/*
Problem: Hash Map Implementation
Description: Implement a hash map with chaining for collision resolution.
           Supports put, get, remove, containsKey, size.

Approach:
- Use array of buckets, each bucket is an array of key-value pairs
- Hash function uses modulo of array size
- Chaining handles collisions

Time Complexity: O(1) average, O(n) worst case
Space Complexity: O(n)

Example:
Input: put("apple", 5), put("banana", 3), get("apple")
Output: 5
*/

class HashEntry {
    var key: String
    var value: Int
    init(key: String, value: Int) { self.key = key; self.value = value }
}

class HashMap {
    private var buckets: [[HashEntry]]
    private let capacity: Int

    init(capacity: Int = 16) {
        self.capacity = capacity
        buckets = Array(repeating: [], count: capacity)
    }

    private func hash(_ key: String) -> Int { abs(key.hashValue) % capacity }

    func put(_ key: String, _ value: Int) {
        let index = hash(key)
        if let entry = buckets[index].first(where: { $0.key == key }) {
            entry.value = value
        } else {
            buckets[index].append(HashEntry(key: key, value: value))
        }
    }

    func get(_ key: String) -> Int? {
        return buckets[hash(key)].first(where: { $0.key == key })?.value
    }

    func remove(_ key: String) {
        let index = hash(key)
        buckets[index].removeAll(where: { $0.key == key })
    }

    func containsKey(_ key: String) -> Bool {
        return buckets[hash(key)].contains(where: { $0.key == key })
    }

    var size: Int { buckets.reduce(0) { $0 + $1.count } }
}

let map = HashMap()
map.put("apple", 5)
map.put("banana", 3)
print("apple: \(map.get("apple")!)")
print("banana: \(map.get("banana")!)")
print("contains 'apple': \(map.containsKey("apple"))")
map.remove("apple")
print("contains 'apple' after remove: \(map.containsKey("apple"))")
print("Size: \(map.size)")
