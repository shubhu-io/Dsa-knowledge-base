/*
Problem: Hash Map Implementation
Description: Implement a hash map with chaining for collision resolution.
           Supports put, get, remove, containsKey, size.

Approach:
- Use array of buckets, each bucket is a list of key-value pairs
- Hash function uses modulo of array size
- Chaining handles collisions

Time Complexity: O(1) average, O(n) worst case
Space Complexity: O(n)

Example:
Input: put("apple", 5), put("banana", 3), get("apple")
Output: 5
*/

class HashEntry {
  String key;
  int value;
  HashEntry(this.key, this.value);
}

class HashMap {
  List<List<HashEntry>> _buckets;
  int _capacity;

  HashMap({int capacity = 16}) : _capacity = capacity, _buckets = List.generate(16, (_) => []);

  int _hash(String key) => key.hashCode.abs() % _capacity;

  void put(String key, int value) {
    int index = _hash(key);
    for (var entry in _buckets[index]) {
      if (entry.key == key) {
        entry.value = value;
        return;
      }
    }
    _buckets[index].add(HashEntry(key, value));
  }

  int? get(String key) {
    for (var entry in _buckets[_hash(key)]) {
      if (entry.key == key) return entry.value;
    }
    return null;
  }

  void remove(String key) {
    _buckets[_hash(key)].removeWhere((e) => e.key == key);
  }

  bool containsKey(String key) {
    return _buckets[_hash(key)].any((e) => e.key == key);
  }

  int get size => _buckets.fold(0, (sum, list) => sum + list.length);
}

void main() {
  HashMap map = HashMap();
  map.put("apple", 5);
  map.put("banana", 3);
  print('apple: ${map.get("apple")}');
  print('banana: ${map.get("banana")}');
  print("contains 'apple': ${map.containsKey("apple")}");
  map.remove("apple");
  print("contains 'apple' after remove: ${map.containsKey("apple")}");
  print('Size: ${map.size}');
}
