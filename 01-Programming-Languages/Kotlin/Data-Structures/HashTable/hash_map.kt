/*
 * Problem: Implement a HashMap with chaining.
 * Approach: Array of buckets, each bucket is a linked list of entries.
 * Time Complexity: O(1) average, O(n) worst for get/put
 * Space Complexity: O(n)
 * Example: put("apple", 5), get("apple") -> 5
 */

class HashMapImpl<K, V> {
    private data class Entry<K, V>(val key: K, var value: V, var next: Entry<K, V>? = null)

    private val buckets = arrayOfNulls<Entry<K, V>>(CAPACITY)

    companion object {
        private const val CAPACITY = 16
    }

    private fun hash(key: K) = Math.abs(key.hashCode()) % CAPACITY

    fun put(key: K, value: V) {
        val index = hash(key)
        var head = buckets[index]
        while (head != null) {
            if (head.key == key) { head.value = value; return }
            head = head.next
        }
        buckets[index] = Entry(key, value, buckets[index])
    }

    fun get(key: K): V? {
        val index = hash(key)
        var head = buckets[index]
        while (head != null) {
            if (head.key == key) return head.value
            head = head.next
        }
        return null
    }
}

fun main() {
    val map = HashMapImpl<String, Int>()
    map.put("apple", 5); map.put("banana", 3)
    println(map.get("apple"))
    println(map.get("banana"))
}
