/**
 * Problem: Linked List Cycle
 * Given head, the head of a linked list, determine if the linked list has a cycle in it.
 * There is a cycle in a linked list if there is some node in the list that can be reached again
 * by continuously following the next pointer. Internally, pos is used to denote the index of the
 * node that tail's next pointer is connected to. Note that pos is not passed as a parameter.
 *
 * Approach (Floyd's Tortoise and Hare):
 * - Use two pointers: slow and fast
 * - Slow pointer moves one step at a time
 * - Fast pointer moves two steps at a time
 * - If there is a cycle, the fast pointer will eventually meet the slow pointer
 * - If there is no cycle, the fast pointer will reach the end (NULL)
 * - Time Complexity: O(n)
 * - Space Complexity: O(1)
 *
 * Example:
 * Input: head = [3,2,0,-4], pos = 1 (tail connects to node index 1)
 * Output: true
 */

#include <stdio.h>
#include <stdlib.h>

// Definition for singly-linked list.
struct ListNode {
    int val;
    struct ListNode *next;
};

/**
 * Determines if a linked list has a cycle.
 *
 * @param head The head of the linked list
 * @return true if there is a cycle, false otherwise
 */
bool hasCycle(struct ListNode *head) {
    // Handle empty list or single node without cycle
    if (head == NULL || head->next == NULL) {
        return false;
    }

    // Initialize slow and fast pointers
    struct ListNode *slow = head;
    struct ListNode *fast = head->next;

    // Traverse the list
    while (fast != NULL && fast->next != NULL) {
        // If pointers meet, there is a cycle
        if (slow == fast) {
            return true;
        }
        // Move slow pointer one step
        slow = slow->next;
        // Move fast pointer two steps
        fast = fast->next->next;
    }

    // If we reach here, fast pointer hit the end (no cycle)
    return false;
}

// Helper function to create a new list node
struct ListNode* createNode(int val) {
    struct ListNode* newNode = (struct ListNode*)malloc(sizeof(struct ListNode));
    newNode->val = val;
    newNode->next = NULL;
    return newNode;
}

// Helper function to create a linked list from an array
struct ListNode* createList(int* values, int size) {
    if (size == 0) return NULL;

    struct ListNode* head = createNode(values[0]);
    struct ListNode* current = head;

    for (int i = 1; i < size; i++) {
        current->next = createNode(values[i]);
        current = current->next;
    }

    return head;
}

// Helper function to create a cycle in the list (for testing)
void createCycle(struct ListNode* head, int pos) {
    if (head == NULL || pos < 0) return;

    // Find the node at position 'pos'
    struct ListNode* cycleNode = head;
    int currentPos = 0;
    while (currentPos < pos && cycleNode != NULL) {
        cycleNode = cycleNode->next;
        currentPos++;
    }

    if (cycleNode == NULL) return; // Position out of bounds

    // Find the last node
    struct ListNode* lastNode = head;
    while (lastNode->next != NULL) {
        lastNode = lastNode->next;
    }

    // Create the cycle
    lastNode->next = cycleNode;
}

// Helper function to print the list (safe version that detects cycles)
void printListSafe(struct ListNode* head, int maxNodes) {
    struct ListNode* current = head;
    int count = 0;

    printf("[");
    while (current != NULL && count < maxNodes) {
        printf("%d", current->val);
        if (current->next != NULL && count < maxNodes - 1) {
            printf(", ");
        }
        current = current->next;
        count++;
    }
    if (count >= maxNodes) {
        printf(", ... (truncated due to possible cycle)");
    }
    printf("]\n");
}

// Helper function to free the list (be careful with cycles)
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
    // Example 1: List with cycle [3,2,0,-4], pos = 1
    int values1[] = {3, 2, 0, -4};
    int size1 = sizeof(values1) / sizeof(values1[0]);
    struct ListNode* head1 = createList(values1, size1);
    createCycle(head1, 1); // Create cycle at position 1

    printf("List 1 (with cycle): ");
    printListSafe(head1, 10); // Print extra to show cycle detection
    printf("Has cycle: %s\n", hasCycle(head1) ? "true" : "false");

    // Example 2: List without cycle [1,2,3,4]
    int values2[] = {1, 2, 3, 4};
    int size2 = sizeof(values2) / sizeof(values2[0]);
    struct ListNode* head2 = createList(values2, size2);
    // No cycle created

    printf("List 2 (without cycle): ");
    printListSafe(head2, 10);
    printf("Has cycle: %s\n", hasCycle(head2) ? "true" : "false");

    // Example 3: Single node with cycle
    int values3[] = {1};
    int size3 = sizeof(values3) / sizeof(values3[0]);
    struct ListNode* head3 = createList(values3, size3);
    createCycle(head3, 0); // Cycle to itself

    printf("List 3 (single node with cycle): ");
    printListSafe(head3, 10);
    printf("Has cycle: %s\n", hasCycle(head3) ? "true" : "false");

    // Example 4: Single node without cycle
    int values4[] = {1};
    int size4 = sizeof(values4) / sizeof(values4[0]);
    struct ListNode* head4 = createList(values4, size4);
    // No cycle

    printf("List 4 (single node without cycle): ");
    printListSafe(head4, 10);
    printf("Has cycle: %s\n", hasCycle(head4) ? "true" : "false");

    // Free memory (note: this will leak memory in cyclic lists, but that's okay for demo)
    // In real code, you'd need to break cycles before freeing
    freeList(head1);
    freeList(head2);
    freeList(head3);
    freeList(head4);

    return 0;
}