/*
Problem: Hash Map (Separate Chaining)
Implement a simple hash map with integer keys and values using separate chaining.

Approach:
- Array of linked lists, hash function using modulo

Time Complexity: O(1) average per operation
Space Complexity: O(n)

Example:
insert(1, 10), insert(2, 20), get(1) -> 10
*/

#include <iostream>
#include <vector>
#include <list>
#include <optional>
using namespace std;

class HashMap
{
    static const int TABLE_SIZE = 10;
    vector<list<pair<int, int>>> buckets;

    int hash(int key) const
    {
        return abs(key) % TABLE_SIZE;
    }

public:
    HashMap() : buckets(TABLE_SIZE) {}

    void put(int key, int value)
    {
        int idx = hash(key);
        for (auto& [k, v] : buckets[idx])
        {
            if (k == key) { v = value; return; }
        }
        buckets[idx].push_back({key, value});
    }

    optional<int> get(int key) const
    {
        int idx = hash(key);
        for (const auto& [k, v] : buckets[idx])
            if (k == key) return v;
        return nullopt;
    }
};

int main()
{
    HashMap map;
    map.put(1, 10);
    map.put(2, 20);
    auto val = map.get(1);
    cout << "Key 1 -> " << (val ? to_string(*val) : "not found") << endl;
    val = map.get(3);
    cout << "Key 3 -> " << (val ? to_string(*val) : "not found") << endl;
    return 0;
}
