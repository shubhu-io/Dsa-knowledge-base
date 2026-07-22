/*
 * Problem: Implement a HashMap with chaining.
 * Approach: Array of buckets, each bucket is a linked list of entries.
 * Time Complexity: O(1) average, O(n) worst for get/put
 * Space Complexity: O(n)
 * Example: put("apple", 5), get("apple") -> 5
 */

import java.util.*;

public class HashMapImpl<K, V> {
    private static class Entry<K, V> {
        K key;
        V value;
        Entry<K, V> next;
        Entry(K key, V value) { this.key = key; this.value = value; }
    }

    private Entry<K, V>[] buckets;
    private static final int CAPACITY = 16;

    @SuppressWarnings("unchecked")
    public HashMapImpl() {
        buckets = new Entry[CAPACITY];
    }

    private int hash(K key) {
        return Math.abs(key.hashCode()) % CAPACITY;
    }

    public void put(K key, V value) {
        int index = hash(key);
        Entry<K, V> head = buckets[index];
        while (head != null) {
            if (head.key.equals(key)) {
                head.value = value;
                return;
            }
            head = head.next;
        }
        Entry<K, V> newEntry = new Entry<>(key, value);
        newEntry.next = buckets[index];
        buckets[index] = newEntry;
    }

    public V get(K key) {
        int index = hash(key);
        Entry<K, V> head = buckets[index];
        while (head != null) {
            if (head.key.equals(key)) return head.value;
            head = head.next;
        }
        return null;
    }

    public static void main(String[] args) {
        HashMapImpl<String, Integer> map = new HashMapImpl<>();
        map.put("apple", 5);
        map.put("banana", 3);
        System.out.println(map.get("apple"));
        System.out.println(map.get("banana"));
    }
}
