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

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define TABLE_SIZE 10

typedef struct Entry
{
    int key;
    int value;
    struct Entry *next;
} Entry;

typedef struct
{
    Entry *buckets[TABLE_SIZE];
} HashMap;

int hash(int key)
{
    return abs(key) % TABLE_SIZE;
}

HashMap *create_map()
{
    HashMap *map = (HashMap *)calloc(1, sizeof(HashMap));
    return map;
}

void put(HashMap *map, int key, int value)
{
    int idx = hash(key);
    Entry *e = map->buckets[idx];
    while (e)
    {
        if (e->key == key) { e->value = value; return; }
        e = e->next;
    }
    Entry *new = (Entry *)malloc(sizeof(Entry));
    new->key = key;
    new->value = value;
    new->next = map->buckets[idx];
    map->buckets[idx] = new;
}

int get(HashMap *map, int key, bool *found)
{
    int idx = hash(key);
    Entry *e = map->buckets[idx];
    while (e)
    {
        if (e->key == key) { *found = true; return e->value; }
        e = e->next;
    }
    *found = false;
    return 0;
}

int main()
{
    HashMap *map = create_map();
    put(map, 1, 10);
    put(map, 2, 20);
    bool found;
    int val = get(map, 1, &found);
    printf("Key 1 -> %d\n", found ? val : -1);
    val = get(map, 3, &found);
    printf("Key 3 -> %s\n", found ? "found" : "not found");
    return 0;
}
