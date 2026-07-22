// Problem: Hash Map Implementation
// Description: Implement a simple hash map with separate chaining using lists.
//
// Approach:
// - Use an array of buckets with list chaining
// - Compute index using hash function modulo table size
//
// Time Complexity: O(1) average, O(n) worst case
// Space Complexity: O(n)
//
// Example:
// Input: put("a", 1), put("b", 2), get("a")
// Output: Some(1)

object HashMap {
  class HashTable[K, V](initialSize: Int = 16) {
    private var buckets: Array[List[(K, V)]] = Array.fill(initialSize)(Nil)
    private var count = 0

    private def index(key: K): Int = {
      (key.hashCode & 0x7FFFFFFF) % buckets.length
    }

    def put(key: K, value: V): Unit = {
      val idx = index(key)
      buckets(idx) = buckets(idx).filter(_._1 != key)
      buckets(idx) = (key, value) :: buckets(idx)
      count += 1
    }

    def get(key: K): Option[V] = {
      val idx = index(key)
      buckets(idx).find(_._1 == key).map(_._2)
    }

    def remove(key: K): Unit = {
      val idx = index(key)
      buckets(idx) = buckets(idx).filter(_._1 != key)
    }
  }

  def main(args: Array[String]): Unit = {
    val map = new HashTable[String, Int]()
    map.put("a", 1)
    map.put("b", 2)
    map.put("c", 3)
    println(s"""get("a"): ${map.get("a")}""")
    println(s"""get("b"): ${map.get("b")}""")
    println(s"""get("d"): ${map.get("d")}""")
    map.remove("b")
    println(s"""After remove, get("b"): ${map.get("b")}""")
  }
}
