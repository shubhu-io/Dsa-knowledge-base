/**
 * Problem: Merge Two Sorted Lists
 * You are given the heads of two sorted linked lists list1 and list2.
 * Merge the two lists into one sorted list. The list should be made by
 * splicing together the nodes of the first two lists.
 * Return the head of the merged linked list.
 *
 * Approach:
 * - Use a dummy node to simplify the merging process
 * - Compare the values of the nodes from both lists
 * - Append the smaller node to the result list
 * - Move the pointer of the list from which the node was taken
 * - Continue until one list is exhausted
 * - Append the remaining nodes of the other list
 * - Time Complexity: O(n + m) where n and m are lengths of the two lists
 * - Space Complexity: O(1) - only uses pointers, no additional data structures
 *
 * Example:
 * Input: list1 = [1,2,4], list2 = [1,3,4]
 * Output: [1,1,2,3,4,4]
 */

#include <stdio.h>
#include <stdlib.h>

// Definition for singly-linked list.
struct ListNode {
    int val;
    struct ListNode *next;
};

/**
 * Merges two sorted linked lists into one sorted list.
 *
 * @param list1 Head of the first sorted linked list
 * @param list2 Head of the second sorted linked list
 * @return Head of the merged sorted linked list
 */
struct ListNode* mergeTwoLists(struct ListNode* list1, struct ListNode* list2) {
    // Create a dummy node to serve as the start of the result list
    struct ListNode* dummy = (struct ListNode*)malloc(sizeof(struct ListNode));
    if (dummy == NULL) {
        return NULL; // Memory allocation failed
    }
    struct ListNode* current = dummy;

    // Traverse both lists until one is exhausted
    while (list1 != NULL && list2 != NULL) {
        if (list1->val < list2->val) {
            current->next = list1;
            list1 = list1->next;
        } else {
            current->next = list2;
            list2 = list2->next;
        }
        current = current->next;
    }

    // Attach the remaining elements
    if (list1 != NULL) {
        current->next = list1;
    } else if (list2 != NULL) {
        current->next = list2;
    }

    // The next node after dummy is the head of the merged list
    struct ListNode* result = dummy->next;
    free(dummy); // Free the dummy node
    return result;
}

// Helper function to create a new list node
struct ListNode* createNode(int val) {
    struct ListNode* newNode = (struct ListNode*)malloc(sizeof(struct ListNode));
    if (newNode == NULL) {
        return NULL;
    }
    newNode->val = val;
    newNode->next = NULL;
    return newNode;
}

// Helper function to create a linked list from an array
struct ListNode* createList(int* arr, int size) {
    if (size == 0) return NULL;

    struct ListNode* head = createNode(arr[0]);
    struct ListNode* current = head;

    for (int i = 1; i < size; i++) {
        current->next = createNode(arr[i]);
        current = current->next;
    }

    return head;
}

// Helper function to print the linked list
void printList(struct ListNode* head) {
    printf("[");
    struct ListNode* current = head;
    while (current != NULL) {
        printf("%d", current->val);
        if (current->next != NULL) {
            printf(", ");
        }
        current = current->next;
    }
    printf("]\n");
}

// Helper function to free the linked list
void freeList(struct ListNode* head) {
    struct ListNode* current = head;
    while (current != NULL) {
        struct ListNode* temp = current;
        current = current->next;
        free(temp);
    }
}

// Example usage
int main() {
    // Create test lists: [1,2,4] and [1,3,4]
    int list1_vals[] = {1, 2, 4};
    int list2_vals[] = {1, 3, 4};
    int size1 = sizeof(list1_vals) / sizeof(list1_vals[0]);
    int size2 = sizeof(list2_vals) / sizeof(list2_vals[0]);

    struct ListNode* list1 = createList(list1_vals, size1);
    struct ListNode* list2 = createList(list2_vals, size2);

    printf("List 1: ");
    printList(list1);
    printf("List 2: ");
    printList(list2);

    // Merge the lists
    struct ListNode* merged = mergeTwoLists(list1, list2);

    printf("Merged list: ");
    printList(merged);

    // Verify the result
    int expected[] = {1, 1, 2, 3, 4, 4};
    int expectedSize = sizeof(expected) / sizeof(expected[0]);

    printf("Expected: ");
    for (int i = 0; i < expectedSize; i++) {
        printf("%d ", expected[i]);
    }
    printf("\n");

    // Free memory
    freeList(merged);

    return 0;
}