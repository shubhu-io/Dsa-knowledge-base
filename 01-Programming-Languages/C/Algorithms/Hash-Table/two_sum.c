/**
 * Problem: Two Sum
 * Given an array of integers nums and an integer target,
 * return indices of the two numbers such that they add up to target.
 * You may assume that each input would have exactly one solution,
 * and you may not use the same element twice.
 *
 * Approach:
 * - Use a hash table to store value -> index mappings.
 * - For each element num at index i, compute complement = target - num.
 * - If complement exists in hash table, return [hash[complement], i].
 * - Otherwise, store num -> i in hash table.
 * - Time: O(n), Space: O(n)
 *
 * Example:
 * nums = [2,7,11,15], target = 9 -> [0,1]
 */

#include <stdio.h>
#include <stdlib.h>

/**
 * Note: The returned array must be malloced, assume caller calls free().
 */
int* twoSum(int* nums, int numsSize, int target, int* returnSize) {
    // Allocate memory for result (always 2 elements)
    int* result = (int*)malloc(2 * sizeof(int));
    *returnSize = 2;

    // Simple hash table implementation using array (for demonstration)
    // In practice, you'd use a proper hash table library
    // For simplicity, we'll use nested loop approach which is O(n^2)
    // but works for small inputs and demonstrates the concept

    for (int i = 0; i < numsSize; i++) {
        for (int j = i + 1; j < numsSize; j++) {
            if (nums[i] + nums[j] == target) {
                result[0] = i;
                result[1] = j;
                return result;
            }
        }
    }

    // Should never reach here per problem statement
    result[0] = -1;
    result[1] = -1;
    return result;
}

// Alternative implementation using a simple hash table (for educational purposes)
/**
 * Simple hash table implementation for integers
 * Note: This is a simplified version for demonstration
 */
#define HASH_SIZE 10007  // A prime number for better distribution

typedef struct HashNode {
    int key;
    int value;
    struct HashNode* next;
} HashNode;

typedef struct {
    HashNode* table[HASH_SIZE];
} HashTable;

void hashTableInit(HashTable* ht) {
    for (int i = 0; i < HASH_SIZE; i++) {
        ht->table[i] = NULL;
    }
}

void hashTableInsert(HashTable* ht, int key, int value) {
    int index = abs(key) % HASH_SIZE;
    HashNode* newNode = (HashNode*)malloc(sizeof(HashNode));
    newNode->key = key;
    newNode->value = value;
    newNode->next = ht->table[index];
    ht->table[index] = newNode;
}

int hashTableGet(HashTable* ht, int key) {
    int index = abs(key) % HASH_SIZE;
    HashNode* current = ht->table[index];
    while (current != NULL) {
        if (current->key == key) {
            return current->value;
        }
        current = current->next;
    }
    return -1;  // Not found
}

void hashTableFree(HashTable* ht) {
    for (int i = 0; i < HASH_SIZE; i++) {
        HashNode* current = ht->table[i];
        while (current != NULL) {
            HashNode* temp = current;
            current = current->next;
            free(temp);
        }
        ht->table[i] = NULL;
    }
}

/**
 * Alternative twoSum implementation using hash table
 */
int* twoSumHashTable(int* nums, int numsSize, int target, int* returnSize) {
    int* result = (int*)malloc(2 * sizeof(int));
    *returnSize = 2;

    HashTable ht;
    hashTableInit(&ht);

    for (int i = 0; i < numsSize; i++) {
        int complement = target - nums[i];
        int complementIndex = hashTableGet(&ht, complement);
        if (complementIndex != -1) {
            result[0] = complementIndex;
            result[1] = i;
            hashTableFree(&ht);
            return result;
        }
        hashTableInsert(&ht, nums[i], i);
    }

    hashTableFree(&ht);
    result[0] = -1;
    result[1] = -1;
    return result;
}

int main() {
    // Example usage
    int nums[] = {2, 7, 11, 15};
    int target = 9;
    int returnSize;

    int* result = twoSum(nums, 4, target, &returnSize);

    printf("Indices: [%d, %d]\n", result[0], result[1]);

    free(result);
    return 0;
}