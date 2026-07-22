<?php

/*
Problem: Hash Map Implementation
Description: Implement a simple hash map with put, get, and remove operations using separate chaining.

Approach:
- Use an array of buckets; each bucket is a linked list of key-value pairs
- Compute hash using crc32 modulo bucket count
- Handle collisions via chaining

Time Complexity: O(1) average, O(n) worst
Space Complexity: O(n)

Example:
Input:  put("name", "Alice"), get("name"), remove("name"), get("name")
Output: "Alice", null
*/

class HashMap {
    private int $capacity;
    private array $buckets;

    public function __construct(int $capacity = 16) {
        $this->capacity = $capacity;
        $this->buckets = array_fill(0, $capacity, []);
    }

    private function hash($key): int {
        return crc32((string)$key) % $this->capacity;
    }

    public function put($key, $value): void {
        $idx = $this->hash($key);
        foreach ($this->buckets[$idx] as &$pair) {
            if ($pair[0] === $key) {
                $pair[1] = $value;
                return;
            }
        }
        $this->buckets[$idx][] = [$key, $value];
    }

    public function get($key) {
        $idx = $this->hash($key);
        foreach ($this->buckets[$idx] as $pair) {
            if ($pair[0] === $key) return $pair[1];
        }
        return null;
    }

    public function remove($key): void {
        $idx = $this->hash($key);
        foreach ($this->buckets[$idx] as $i => $pair) {
            if ($pair[0] === $key) {
                array_splice($this->buckets[$idx], $i, 1);
                return;
            }
        }
    }
}

$map = new HashMap();
$map->put("name", "Alice");
$map->put("age", 25);
echo "Get name: " . $map->get("name") . "\n";
echo "Get age: " . $map->get("age") . "\n";
$map->remove("name");
echo "Get name after remove: " . var_export($map->get("name"), true) . "\n";
