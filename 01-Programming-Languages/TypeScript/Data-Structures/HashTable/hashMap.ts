/*
Problem: HashMap Implementation
Description: Simple hash map with put, get, remove, and has using separate chaining.

Approach:
- Array of buckets, each storing [key, value] pairs, hash via modulo

Time Complexity: O(1) average, O(n) worst case
Space Complexity: O(n)

Example:
Input: put("apple", 5), get("apple"), has("banana")
Output: 5, false
*/

class HashMap<K, V> {
  private buckets: Array<Array<[K, V]>>;
  private size: number;

  constructor(size = 16) {
    this.size = size;
    this.buckets = new Array(size).fill(null).map(() => []);
  }

  private _hash(key: K): number {
    let hash = 0;
    const str = String(key);
    for (let i = 0; i < str.length; i++) {
      hash = (hash * 31 + str.charCodeAt(i)) % this.size;
    }
    return hash;
  }

  put(key: K, value: V): void {
    const index = this._hash(key);
    const bucket = this.buckets[index];
    for (const pair of bucket) {
      if (pair[0] === key) {
        pair[1] = value;
        return;
      }
    }
    bucket.push([key, value]);
  }

  get(key: K): V | undefined {
    const index = this._hash(key);
    const bucket = this.buckets[index];
    for (const pair of bucket) {
      if (pair[0] === key) return pair[1];
    }
    return undefined;
  }

  remove(key: K): boolean {
    const index = this._hash(key);
    const bucket = this.buckets[index];
    for (let i = 0; i < bucket.length; i++) {
      if (bucket[i][0] === key) {
        bucket.splice(i, 1);
        return true;
      }
    }
    return false;
  }

  has(key: K): boolean {
    const index = this._hash(key);
    const bucket = this.buckets[index];
    return bucket.some(pair => pair[0] === key);
  }
}

const map = new HashMap<string, number>();
map.put('apple', 5);
map.put('banana', 10);
console.log('get("apple"):', map.get('apple'));
console.log('has("banana"):', map.has('banana'));
console.log('has("grape"):', map.has('grape'));
map.remove('apple');
console.log('get("apple") after remove:', map.get('apple'));
