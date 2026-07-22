/**
 * Problem: Reverse Linked List
 * Given the head of a singly linked list, reverse the list, and return the reversed list.
 *
 * Approach:
 * - Use three pointers: prev, current, and next
 * - Iterate through the list, reversing the links as we go
 * - Time: O(n), Space: O(1)
 *
 * Example:
 * Input: 1 -> 2 -> 3 -> 4 -> 5 -> NULL
 * Output: 5 -> 4 -> 3 -> 2 -> 1 -> NULL
 */

#include <iostream>

// Definition for singly-linked list.
struct ListNode {
    int val;
    ListNode* next;
    ListNode() : val(0), next(nullptr) {}
    ListNode(int x) : val(x), next(nullptr) {}
    ListNode(int x, ListNode* next) : val(x), next(next) {}
};

/**
 * Reverses a singly linked list.
 * @param head The head of the linked list
 * @return The new head of the reversed list
 */
ListNode* reverseList(ListNode* head) {
    ListNode* prev = nullptr;
    ListNode* current = head;
    ListNode* next = nullptr;

    while (current != nullptr) {
        // Store next node
        next = current->next;
        // Reverse current node's pointer
        current->next = prev;
        // Move pointers one position ahead
        prev = current;
        current = next;
    }

    // Prev will be the new head
    return prev;
}

// Helper function to create a new list node
ListNode* createNode(int val) {
    return new ListNode(val);
}

// Helper function to print the linked list
void printList(ListNode* head) {
    ListNode* current = head;
    while (current != nullptr) {
        std::cout << current->val;
        if (current->next != nullptr) {
            std::cout << " -> ";
        }
        current = current->next;
    }
    std::cout << " -> NULL" << std::endl;
}

// Helper function to free the linked list
void freeList(ListNode* head) {
    ListNode* current = head;
    while (current != nullptr) {
        ListNode* temp = current;
        current = current->next;
        delete temp;
    }
}

int main() {
    // Create a sample linked list: 1 -> 2 -> 3 -> 4 -> 5
    ListNode* head = createNode(1);
    head->next = createNode(2);
    head->next->next = createNode(3);
    head->next->next->next = createNode(4);
    head->next->next->next->next = createNode(5);

    std::cout << "Original list: ";
    printList(head);

    // Reverse the list
    ListNode* reversedHead = reverseList(head);

    std::cout << "Reversed list: ";
    printList(reversedHead);

    // Free memory
    freeList(reversedHead);

    return 0;
}