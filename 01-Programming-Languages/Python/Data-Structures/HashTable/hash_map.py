"""
Hash Map Implementation in Python

Demonstrates hash table implementation with separate chaining for collision handling.
Python's built-in dict is a hash map — this shows how it works internally.
"""

from typing import Any, Optional, List, Tuple


class HashNode:
    """A node in the hash map's chain."""

    def __init__(self, key: Any, value: Any):
        self.key = key
        self.value = value
        self.next: Optional['HashNode'] = None


class HashMap:
    """
    Hash map with separate chaining for collision resolution.

    Time Complexity:
        - Average: O(1) for get, put, delete
        - Worst: O(n) when all keys hash to same bucket
    Space Complexity: O(n)
    """

    def __init__(self, initial_capacity: int = 16, load_factor: float = 0.75):
        self._capacity = initial_capacity
        self._load_factor = load_factor
        self._size = 0
        self._buckets: List[Optional[HashNode]] = [None] * self._capacity

    def _hash(self, key: Any) -> int:
        """Compute bucket index for a key."""
        return hash(key) % self._capacity

    def _resize(self) -> None:
        """Double the capacity and rehash all entries."""
        old_buckets = self._buckets
        self._capacity *= 2
        self._buckets = [None] * self._capacity
        self._size = 0

        for bucket in old_buckets:
            current = bucket
            while current:
                self.put(current.key, current.value)
                current = current.next

    def put(self, key: Any, value: Any) -> None:
        """Insert or update a key-value pair."""
        index = self._hash(key)
        current = self._buckets[index]

        # Update existing key
        while current:
            if current.key == key:
                current.value = value
                return
            current = current.next

        # Insert new key at head of chain
        new_node = HashNode(key, value)
        new_node.next = self._buckets[index]
        self._buckets[index] = new_node
        self._size += 1

        # Resize if load factor exceeded
        if self._size / self._capacity > self._load_factor:
            self._resize()

    def get(self, key: Any) -> Optional[Any]:
        """Retrieve value by key. Returns None if key not found."""
        index = self._hash(key)
        current = self._buckets[index]

        while current:
            if current.key == key:
                return current.value
            current = current.next

        return None

    def delete(self, key: Any) -> bool:
        """Remove a key-value pair. Returns True if key was found."""
        index = self._hash(key)
        current = self._buckets[index]
        prev = None

        while current:
            if current.key == key:
                if prev:
                    prev.next = current.next
                else:
                    self._buckets[index] = current.next
                self._size -= 1
                return True
            prev = current
            current = current.next

        return False

    def contains(self, key: Any) -> bool:
        """Check if a key exists."""
        return self.get(key) is not None

    def keys(self) -> List[Any]:
        """Return all keys."""
        result = []
        for bucket in self._buckets:
            current = bucket
            while current:
                result.append(current.key)
                current = current.next
        return result

    def values(self) -> List[Any]:
        """Return all values."""
        result = []
        for bucket in self._buckets:
            current = bucket
            while current:
                result.append(current.value)
                current = current.next
        return result

    def items(self) -> List[Tuple[Any, Any]]:
        """Return all key-value pairs."""
        result = []
        for bucket in self._buckets:
            current = bucket
            while current:
                result.append((current.key, current.value))
                current = current.next
        return result

    @property
    def size(self) -> int:
        return self._size

    def __len__(self) -> int:
        return self._size

    def __contains__(self, key: Any) -> bool:
        return self.contains(key)

    def __getitem__(self, key: Any) -> Any:
        value = self.get(key)
        if value is None and not self.contains(key):
            raise KeyError(key)
        return value

    def __setitem__(self, key: Any, value: Any) -> None:
        self.put(key, value)

    def __delitem__(self, key: Any) -> None:
        if not self.delete(key):
            raise KeyError(key)

    def __repr__(self) -> str:
        pairs = [f"{k!r}: {v!r}" for k, v in self.items()]
        return "{" + ", ".join(pairs) + "}"


# ============================================================
# Two-Sum using HashMap
# ============================================================

def two_sum(nums: List[int], target: int) -> List[int]:
    """
    Find two numbers that add up to target.
    Returns their indices.

    Time: O(n)  |  Space: O(n)
    """
    seen = {}
    for i, num in enumerate(nums):
        complement = target - num
        if complement in seen:
            return [seen[complement], i]
        seen[num] = i
    return []


# ============================================================
# Group Anagrams using HashMap
# ============================================================

from typing import Dict

def group_anagrams(strs: List[str]) -> List[List[str]]:
    """
    Group strings that are anagrams of each other.

    Time: O(n * k log k)  |  Space: O(n * k)
    where n = number of strings, k = max string length
    """
    groups: Dict[str, List[str]] = {}
    for s in strs:
        key = "".join(sorted(s))
        if key not in groups:
            groups[key] = []
        groups[key].append(s)
    return list(groups.values())


# ============================================================
# LRU Cache using HashMap + Doubly Linked List
# ============================================================

class LRUCache:
    """
    Least Recently Used (LRU) Cache.

    Time Complexity:
        - get: O(1)
        - put: O(1)
    Space Complexity: O(capacity)
    """

    class Node:
        def __init__(self, key: int = 0, value: int = 0):
            self.key = key
            self.value = value
            self.prev: Optional['LRUCache.Node'] = None
            self.next: Optional['LRUCache.Node'] = None

    def __init__(self, capacity: int):
        self.capacity = capacity
        self.cache: Dict[int, 'LRUCache.Node'] = {}
        self.head = self.Node()  # dummy head
        self.tail = self.Node()  # dummy tail
        self.head.next = self.tail
        self.tail.prev = self.head

    def _remove(self, node: 'LRUCache.Node') -> None:
        """Remove node from doubly linked list."""
        node.prev.next = node.next
        node.next.prev = node.prev

    def _add_to_front(self, node: 'LRUCache.Node') -> None:
        """Add node right after head (most recently used position)."""
        node.next = self.head.next
        node.prev = self.head
        self.head.next.prev = node
        self.head.next = node

    def get(self, key: int) -> int:
        if key in self.cache:
            node = self.cache[key]
            self._remove(node)
            self._add_to_front(node)
            return node.value
        return -1

    def put(self, key: int, value: int) -> None:
        if key in self.cache:
            self._remove(self.cache[key])

        node = self.Node(key, value)
        self.cache[key] = node
        self._add_to_front(node)

        if len(self.cache) > self.capacity:
            lru = self.tail.prev
            self._remove(lru)
            del self.cache[lru.key]


# ============================================================
# Demo
# ============================================================

if __name__ == "__main__":
    # HashMap demo
    print("=== HashMap ===")
    hm = HashMap()
    hm["name"] = "Alice"
    hm["age"] = 30
    hm["city"] = "NYC"
    hm.put("language", "Python")

    print(f"Size: {hm.size}")
    print(f"Keys: {hm.keys()}")
    print(f"Values: {hm.values()}")
    print(f"Get 'name': {hm.get('name')}")
    print(f"'name' in map: {'name' in hm}")
    hm.delete("city")
    print(f"After delete 'city': {hm.keys()}")

    # Two-Sum demo
    print("\n=== Two Sum ===")
    nums = [2, 7, 11, 15]
    target = 9
    result = two_sum(nums, target)
    print(f"two_sum({nums}, {target}) = {result}")

    # Group Anagrams demo
    print("\n=== Group Anagrams ===")
    words = ["eat", "tea", "tan", "ate", "nat", "bat"]
    groups = group_anagrams(words)
    print(f"Input: {words}")
    print(f"Groups: {groups}")

    # LRU Cache demo
    print("\n=== LRU Cache ===")
    cache = LRUCache(2)
    cache.put(1, 1)
    cache.put(2, 2)
    print(f"get(1) = {cache.get(1)}")   # returns 1
    cache.put(3, 3)                      # evicts key 2
    print(f"get(2) = {cache.get(2)}")   # returns -1 (not found)
    cache.put(4, 4)                      # evicts key 1
    print(f"get(1) = {cache.get(1)}")   # returns -1 (not found)
    print(f"get(3) = {cache.get(3)}")   # returns 3
    print(f"get(4) = {cache.get(4)}")   # returns 4
