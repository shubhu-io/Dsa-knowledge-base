# Hash Table Problems

## Easy Problems

### 1. Two Sum
**Problem**: Given an array of integers `nums` and an integer `target`, return indices of the two numbers such that they add up to `target`.

**Example**:
```
Input: nums = [2,7,11,15], target = 9
Output: [0,1]
Explanation: Because nums[0] + nums[1] == 9, we return [0, 1].
```

**Solution Approach**:
- Use a hash table to store numbers we've seen so far
- For each number, check if `target - num` exists in the hash table
- If yes, return current index and the stored index
- If no, store current number with its index

**Python Solution**:
```python
def two_sum(nums, target):
    num_map = {}  # value -> index
    for i, num in enumerate(nums):
        complement = target - num
        if complement in num_map:
            return [num_map[complement], i]
        num_map[num] = i
    return []
```

**Time Complexity**: O(n)  
**Space Complexity**: O(n)

### 2. Contains Duplicate
**Problem**: Given an integer array `nums`, return `true` if any value appears at least twice in the array, and return `false` if every element is distinct.

**Example**:
```
Input: nums = [1,2,3,1]
Output: true
```

**Solution Approach**:
- Use a hash set to track seen elements
- Iterate through array, if element already in set, return true
- Otherwise add to set and continue

**Python Solution**:
```python
def contains_duplicate(nums):
    seen = set()
    for num in nums:
        if num in seen:
            return True
        seen.add(num)
    return False
```

**Time Complexity**: O(n)  
**Space Complexity**: O(n)

### 3. Valid Anagram
**Problem**: Given two strings `s` and `t`, return `true` if `t` is an anagram of `s`, and `false` otherwise.

**Example**:
```
Input: s = "anagram", t = "nagaram"
Output: true
```

**Solution Approach**:
- Count frequency of each character in both strings
- Compare the frequency counts
- Can use hash table (dictionary) for counting

**Python Solution**:
```python
def is_anagram(s, t):
    if len(s) != len(t):
        return False
    
    count_s = {}
    count_t = {}
    
    for char in s:
        count_s[char] = count_s.get(char, 0) + 1
    
    for char in t:
        count_t[char] = count_t.get(char, 0) + 1
    
    return count_s == count_t
```

**Alternative (single hash table)**:
```python
def is_anagram(s, t):
    if len(s) != len(t):
        return False
    
    count = {}
    for char in s:
        count[char] = count.get(char, 0) + 1
    
    for char in t:
        if char not in count:
            return False
        count[char] -= 1
        if count[char] == 0:
            del count[char]
    
    return len(count) == 0
```

**Time Complexity**: O(n)  
**Space Complexity**: O(1) (since alphabet size is constant)

### 4. First Unique Character in a String
**Problem**: Given a string `s`, find the first non-repeating character in it and return its index. If it does not exist, return -1.

**Example**:
```
Input: s = "leetcode"
Output: 0
```

**Solution Approach**:
- First pass: count frequency of each character
- Second pass: find first character with frequency 1

**Python Solution**:
```python
def first_uniq_char(s):
    # Count frequency
    count = {}
    for char in s:
        count[char] = count.get(char, 0) + 1
    
    # Find first non-repeating
    for i, char in enumerate(s):
        if count[char] == 1:
            return i
    
    return -1
```

**Time Complexity**: O(n)  
**Space Complexity**: O(1) (alphabet size limited)

## Medium Problems

### 1. Longest Substring Without Repeating Characters
**Problem**: Given a string `s`, find the length of the longest substring without repeating characters.

**Example**:
```
Input: s = "abcabcbb"
Output: 3
Explanation: The answer is "abc", with the length of 3.
```

**Solution Approach**:
- Sliding window with hash table
- Use two pointers (left, right) representing current window
- Hash table stores character -> its most recent index
- When duplicate found, move left pointer to max(left, last_index[char] + 1)

**Python Solution**:
```python
def length_of_longest_substring(s):
    char_index = {}  # character -> last index
    left = 0
    max_length = 0
    
    for right in range(len(s)):
        char = s[right]
        
        # If character is in current window, move left pointer
        if char in char_index and char_index[char] >= left:
            left = char_index[char] + 1
        
        # Update character's latest index
        char_index[char] = right
        
        # Update max length
        max_length = max(max_length, right - left + 1)
    
    return max_length
```

**Time Complexity**: O(n)  
**Space Complexity**: O(min(m, n)) where m is charset size

### 2. Subarray Sum Equals K
**Problem**: Given an array of integers `nums` and an integer `k`, return the total number of continuous subarrays whose sum equals to `k`.

**Example**:
```
Input: nums = [1,1,1], k = 2
Output: 2
```

**Solution Approach**:
- Use prefix sum and hash table
- Store frequency of prefix sums encountered
- For current prefix sum `sum_i`, look for `sum_i - k` in hash table

**Python Solution**:
```python
def subarray_sum(nums, k):
    prefix_sum_count = {0: 1}  # prefix_sum -> frequency
    current_sum = 0
    count = 0
    
    for num in nums:
        current_sum += num
        
        # If (current_sum - k) exists in map, add its frequency to count
        if (current_sum - k) in prefix_sum_count:
            count += prefix_sum_count[current_sum - k]
        
        # Update frequency of current prefix sum
        prefix_sum_count[current_sum] = prefix_sum_count.get(current_sum, 0) + 1
    
    return count
```

**Time Complexity**: O(n)  
**Space Complexity**: O(n)

### 3. Group Anagrams
**Problem**: Given an array of strings `strs`, group the anagrams together. You can return the answer in any order.

**Example**:
```
Input: strs = ["eat","tea","tan","ate","nat","bat"]
Output: [["bat"],["nat","tan"],["ate","eat","tea"]]
```

**Solution Approach**:
- Sort each string to get canonical form
- Anagrams will have same sorted representation
- Use hash table mapping sorted string to list of original strings

**Python Solution**:
```python
def group_anagrams(strs):
    anagram_groups = {}
    
    for s in strs:
        # Sort string to get key
        sorted_s = ''.join(sorted(s))
        
        # Add to corresponding group
        if sorted_s not in anagram_groups:
            anagram_groups[sorted_s] = []
        anagram_groups[sorted_s].append(s)
    
    return list(anagram_groups.values())
```

**Alternative (character count)**:
```python
def group_anagrams(strs):
    from collections import defaultdict
    
    def get_char_count(s):
        count = [0] * 26  # assuming lowercase English letters
        for char in s:
            count[ord(char) - ord('a')] += 1
        return tuple(count)
    
    groups = defaultdict(list)
    for s in strs:
        groups[get_char_count(s)].append(s)
    
    return list(groups.values())
```

**Time Complexity**: O(n * k log k) where n = number of strings, k = max length  
**Space Complexity**: O(n * k)

### 4. Longest Consecutive Sequence
**Problem**: Given an unsorted array of integers `nums`, return the length of the longest consecutive elements sequence.

**Example**:
```
Input: nums = [100,4,200,1,3,2]
Output: 4
Explanation: The longest consecutive elements sequence is [1, 2, 3, 4]. Therefore its length is 4.
```

**Solution Approach**:
- Put all numbers in a hash set for O(1) lookups
- For each number, check if it's the start of a sequence (num-1 not in set)
- If so, count upward from there
- Skip numbers that are part of already processed sequences

**Python Solution**:
```python
def longest_consecutive(nums):
    if not nums:
        return 0
    
    num_set = set(nums)
    longest_streak = 0
    
    for num in num_set:
        # Check if it's the start of a sequence
        if num - 1 not in num_set:
            current_num = num
            current_streak = 1
            
            # Count upward
            while current_num + 1 in num_set:
                current_num += 1
                current_streak += 1
            
            longest_streak = max(longest_streak, current_streak)
    
    return longest_streak
```

**Time Complexity**: O(n) - each number visited at most twice  
**Space Complexity**: O(n)

## Hard Problems

### 1. LRU Cache
**Problem**: Design a data structure that follows the constraints of a Least Recently Used (LRU) cache.

Implement the `LRUCache` class:
- `LRUCache(int capacity)` Initialize the LRU cache with positive size `capacity`.
- `int get(int key)` Return the value of the key if the key exists, otherwise return -1.
- `void put(int key, int value)` Update the value of the key if the key exists. Otherwise, add the key-value pair to the cache. If the number of keys exceeds the `capacity` from this operation, evict the least recently used key.

**Example**:
```
Input
["LRUCache", "put", "put", "get", "put", "get", "put", "get", "get", "get"]
[[2],     [1, 1], [2, 2], [1],    [3, 3], [2],    [4, 4], [1],    [3],    [4]]
Output
[null, null, null, 1, null, -1, null, -1, 3, 4]
```

**Solution Approach**:
- Use hash table for O(1) lookup
- Use doubly linked list to maintain order of usage
- Most recently used at head, least recently used at tail
- On get/put: move node to head
- On put when over capacity: remove tail node

**Python Solution**:
```python
class Node:
    def __init__(self, key=0, value=0):
        self.key = key
        self.value = value
        self.prev = None
        self.next = None

class LRUCache:
    def __init__(self, capacity: int):
        self.capacity = capacity
        self.cache = {}  # key -> node
        
        # Dummy head and tail for doubly linked list
        self.head = Node()
        self.tail = Node()
        self.head.next = self.tail
        self.tail.prev = self.head
    
    def _remove(self, node):
        """Remove node from linked list"""
        prev_node = node.prev
        next_node = node.next
        prev_node.next = next_node
        next_node.prev = prev_node
    
    def _add_to_head(self, node):
        """Add node right after head"""
        node.prev = self.head
        node.next = self.head.next
        self.head.next.prev = node
        self.head.next = node
    
    def _move_to_head(self, node):
        """Move existing node to head"""
        self._remove(node)
        self._add_to_head(node)
    
    def _pop_tail(self):
        """Remove and return the tail node (LRU item)"""
        res = self.tail.prev
        self._remove(res)
        return res
    
    def get(self, key: int) -> int:
        node = self.cache.get(key)
        if not node:
            return -1
        # Move accessed node to head (most recently used)
        self._move_to_head(node)
        return node.value
    
    def put(self, key: int, value: int) -> None:
        node = self.cache.get(key)
        if not node:
            # Key doesn't exist, create new node
            new_node = Node(key, value)
            self.cache[key] = new_node
            self._add_to_head(new_node)
            
            # Check capacity
            if len(self.cache) > self.capacity:
                # Remove LRU item
                tail = self._pop_tail()
                del self.cache[tail.key]
        else:
            # Key exists, update value and move to head
            node.value = value
            self._move_to_head(node)
```

**Time Complexity**: O(1) for both get and put  
**Space Complexity**: O(capacity)

### 2. LFU Cache
**Problem**: Design and implement a data structure for a Least Frequently Used (LFU) cache.

Implement the `LFUCache` class:
- `LFUCache(int capacity)` Initializes the object with the `capacity` of the data structure.
- `int get(int key)` Gets the value of the key if the key exists in the cache. Otherwise, returns -1.
- `void put(int key, int value)` Update the value of the key if present, or inserts the key if not already present. When the cache reaches its capacity, it should invalidate the least frequently used item before inserting a new item. For this problem, when there is a tie (i.e., two or more keys with the same frequency), the least recently used key would be invalidated.

**Solution Approach**:
- Need three main components:
  1. key -> (value, frequency) map (for O(1) lookup)
  2. frequency -> keys ordered by recent use (for LFU eviction)
  3. min_freq to track minimum frequency for eviction

**Python Solution**:
```python
from collections import defaultdict, OrderedDict

class LFUCache:
    def __init__(self, capacity: int):
        self.capacity = capacity
        self.min_freq = 0
        self.key_value = {}  # key -> (value, frequency)
        self.freq_keys = defaultdict(OrderedDict)  # frequency -> OrderedDict of keys (LRU order)
    
    def _update(self, key):
        """Helper to increase frequency of key"""
        value, freq = self.key_value[key]
        
        # Remove from current frequency list
        del self.freq_keys[freq][key]
        
        # If no more keys at this frequency and it was min_freq, increment min_freq
        if not self.freq_keys[freq]:
            del self.freq_keys[freq]
            if self.min_freq == freq:
                self.min_freq += 1
        
        # Add to next frequency level
        self.key_value[key] = (value, freq + 1)
        self.freq_keys[freq + 1][key] = None  # Value doesn't matter in OrderedDict for ordering
    
    def get(self, key: int) -> int:
        if key not in self.key_value:
            return -1
        
        self._update(key)
        return self.key_value[key][0]
    
    def put(self, key: int, value: int) -> None:
        if self.capacity == 0:
            return
        
        if key in self.key_value:
            # Key exists, update value and frequency
            self.key_value[key] = (value, self.key_value[key][1])
            self._update(key)
        else:
            # New key
            if len(self.key_value) >= self.capacity:
                # Need to evict LFU item
                # Get LRU item from min_freq list
                evict_key, _ = self.freq_keys[self.min_freq].popitem(last=False)
                del self.key_value[evict_key]
                
                # Clean up empty frequency list
                if not self.freq_keys[self.min_freq]:
                    del self.freq_keys[self.min_freq]
            
            # Insert new key with frequency 1
            self.key_value[key] = (value, 1)
            self.freq_keys[1][key] = None
            self.min_freq = 1
```

**Time Complexity**: O(1) for both get and put (amortized)  
**Space Complexity**: O(capacity)

### 3. Number of Subarrays with Bounded Maximum
**Problem**: Given an array `nums` of positive integers, return the number of (contiguous, non-empty) subarrays where the maximum element in the subarray is in the range `[left, right]` inclusive.

**Example**:
```
Input: nums = [2,1,4,3], left = 2, right = 3
Output: 3
Explanation: There are three subarrays that meet the requirements: [2], [2, 1], [3].
```

**Solution Approach**:
- Use inclusion-exclusion principle
- Count subarrays where max <= right minus subarrays where max < left
- To count subarrays where max <= bound: iterate and count lengths of segments where all elements <= bound

**Python Solution**:
```python
def num_subarray_bounded_max(nums, left, right):
    def count_bound(bound):
        count = 0
        length = 0
        
        for num in nums:
            if num <= bound:
                length += 1
                count += length
            else:
                length = 0
        
        return count
    
    return count_bound(right) - count_bound(left - 1)
```

**Alternative (sliding window)**:
```python
def num_subarray_bounded_max(nums, left, right):
    count = 0
    left_bound = -1  # last position where element > right
    right_bound = -1  # last position where element >= left
    
    for i in range(len(nums)):
        if nums[i] > right:
            left_bound = i
        if nums[i] >= left:
            right_bound = i
        count += right_bound - left_bound
    
    return count
```

**Time Complexity**: O(n)  
**Space Complexity**: O(1)

## Practice Exercises

### Easy
1. Implement a basic hash table with separate chaining
2. Find the most frequent element in an array
3. Check if two strings are isomorphic
4. Find all numbers disappeared in an array
5. Intersection of two arrays

### Medium
1. LRU Cache implementation (as above)
2. LFU Cache implementation (as above)
3. Design a hash map without using built-in hash table libraries
4. Substring with concatenation of all words
5. Minimum window substring

### Hard
1. LFU Cache with O(1) operations (as above)
2. Design a file system
3. All O`one Data Structure
4. LFU Cache variation with additional constraints
5. Design hit counter

## Summary

Hash tables are incredibly versatile data structures that provide average-case O(1) time complexity for insert, delete, and lookup operations. They excel in scenarios requiring:

1. **Fast lookups**: When you need to quickly check if an element exists or retrieve its associated value
2. **Frequency counting**: Counting occurrences of elements in a dataset
3. **Caching**: Implementing LRU/LFU caches for quick access to frequently used data
4. **Grouping/clustering**: Grouping similar items together (like anagrams)
5. **Subarray problems**: Using prefix sum techniques with hash maps

Key implementation considerations:
- **Hash function quality**: A good hash function minimizes collisions
- **Collision resolution**: Separate chaining vs. open addressing trade-offs
- **Load factor**: When to resize and by what factor
- **Memory usage**: Space-time trade-off in hash table design
- **Hash table attacks**: Being aware of potential DoS attacks via hash collisions

Common patterns in hash table problems:
1. **Two-pass approach**: First pass to build frequency map, second pass to use it
2. **Prefix sum + hash map**: For subarray sum problems
3. **Sliding window + hash map**: For substring problems
4. **Frequency-based grouping**: Grouping items by their characteristics
5. **Caching with ordered structures**: Combining hash maps with linked lists for LRU/LFU

Mastering hash tables is crucial for coding interviews and real-world applications, as they form the foundation of many efficient algorithms and data processing techniques.