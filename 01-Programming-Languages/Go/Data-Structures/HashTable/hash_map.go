/*
Problem: Hash Map Implementation
Implement a simple hash map with put, get, and delete operations using separate chaining.

Approach:
- Use an array of buckets, each bucket is a linked list of key-value pairs
- Compute bucket index using hash function (modulo)
- Handle collisions with separate chaining

Time Complexity: O(1) average, O(n) worst case
Space Complexity: O(n)

Example:
Input: put("key1", "value1"), get("key1"), delete("key1"), get("key1")
Output: "value1", ""
*/

package main

import "fmt"

type entry struct {
	key   string
	value string
	next  *entry
}

type HashMap struct {
	buckets []*entry
	size    int
}

func NewHashMap(capacity int) *HashMap {
	return &HashMap{buckets: make([]*entry, capacity), size: capacity}
}

func (m *HashMap) hash(key string) int {
	h := 0
	for _, ch := range key {
		h = h*31 + int(ch)
	}
	if h < 0 {
		h = -h
	}
	return h % m.size
}

func (m *HashMap) Put(key, value string) {
	idx := m.hash(key)
	e := m.buckets[idx]
	for e != nil {
		if e.key == key {
			e.value = value
			return
		}
		e = e.next
	}
	m.buckets[idx] = &entry{key: key, value: value, next: m.buckets[idx]}
}

func (m *HashMap) Get(key string) string {
	idx := m.hash(key)
	e := m.buckets[idx]
	for e != nil {
		if e.key == key {
			return e.value
		}
		e = e.next
	}
	return ""
}

func (m *HashMap) Delete(key string) {
	idx := m.hash(key)
	e := m.buckets[idx]
	var prev *entry
	for e != nil {
		if e.key == key {
			if prev == nil {
				m.buckets[idx] = e.next
			} else {
				prev.next = e.next
			}
			return
		}
		prev = e
		e = e.next
	}
}

func main() {
	hm := NewHashMap(16)
	hm.Put("key1", "value1")
	fmt.Println("Get key1:", hm.Get("key1"))
	hm.Delete("key1")
	fmt.Println("Get key1 after delete:", hm.Get("key1"))
}
