/*
Problem: Hash Map Implementation
Implement a simple hash map with put, get, and delete operations using separate chaining.

Approach:
- Use a vector of buckets, each bucket is a linked list of key-value pairs
- Compute bucket index using hash function (modulo)
- Handle collisions with separate chaining

Time Complexity: O(1) average, O(n) worst case
Space Complexity: O(n)

Example:
Input: put("key1", "value1"), get("key1"), delete("key1"), get("key1")
Output: Some("value1"), None
*/

struct Entry {
    key: String,
    value: String,
    next: Option<Box<Entry>>,
}

struct HashMap {
    buckets: Vec<Option<Box<Entry>>>,
    size: usize,
}

impl HashMap {
    fn new(size: usize) -> Self {
        let mut buckets = Vec::with_capacity(size);
        for _ in 0..size {
            buckets.push(None);
        }
        HashMap { buckets, size }
    }

    fn hash(&self, key: &str) -> usize {
        let mut h: usize = 0;
        for ch in key.chars() {
            h = h.wrapping_mul(31).wrapping_add(ch as usize);
        }
        h % self.size
    }

    fn put(&mut self, key: &str, value: &str) {
        let idx = self.hash(key);
        let mut curr = self.buckets[idx].as_mut();
        while let Some(entry) = curr {
            if entry.key == key {
                entry.value = value.to_string();
                return;
            }
            curr = entry.next.as_mut();
        }
        self.buckets[idx] = Some(Box::new(Entry {
            key: key.to_string(),
            value: value.to_string(),
            next: self.buckets[idx].take(),
        }));
    }

    fn get(&self, key: &str) -> Option<&str> {
        let idx = self.hash(key);
        let mut curr = self.buckets[idx].as_ref();
        while let Some(entry) = curr {
            if entry.key == key {
                return Some(&entry.value);
            }
            curr = entry.next.as_ref();
        }
        None
    }

    fn delete(&mut self, key: &str) {
        let idx = self.hash(key);
        let mut curr = &mut self.buckets[idx];
        loop {
            match curr {
                None => return,
                Some(entry) if entry.key == key => {
                    *curr = entry.next.take();
                    return;
                }
                Some(entry) => {
                    curr = &mut entry.next;
                }
            }
        }
    }
}

fn main() {
    let mut hm = HashMap::new(16);
    hm.put("key1", "value1");
    println!("Get key1: {:?}", hm.get("key1"));
    hm.delete("key1");
    println!("Get key1 after delete: {:?}", hm.get("key1"));
}
