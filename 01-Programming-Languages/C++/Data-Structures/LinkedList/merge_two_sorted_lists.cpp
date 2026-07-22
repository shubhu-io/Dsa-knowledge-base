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
 * - Time: O(n + m), Space: O(1)
 *
 * Example:
 * Input: list1 = [1,2,4], list2 = [1,3,4]
 * Output: [1,1,2,3,4,4]
 */

#include <iostream>
#include <vector>

// Definition for singly-linked list.
struct ListNode {
    int val;
    ListNode* next;
    ListNode() : val(0), next(nullptr) {}
    ListNode(int x) : val(x), next(nullptr) {}
    ListNode(int x, ListNode* next) : val(x), next(next) {}
};

/**
 * Merges two sorted linked lists into one sorted list.
 * @param list1 Head of the first sorted linked list
 * @param list2 Head of the second sorted linked list
 * @return Head of the merged sorted linked list
 */
ListNode* mergeTwoLists(ListNode* list1, ListNode* list2) {
    // Create a dummy node to serve as the start of the result list
    ListNode* dummy = new ListNode();
    ListNode* current = dummy;

    // Traverse both lists until one is exhausted
    while (list1 != nullptr && list2 != nullptr) {
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
    if (list1 != nullptr) {
        current->next = list1;
    } else if (list2 != nullptr) {
        current->next = list2;
    }

    // The next node after dummy is the head of the merged list
    ListNode* result = dummy->next;
    delete dummy;  // Clean up the dummy node
    return result;
}

// Helper function to create a linked list from a vector
ListNode* createLinkedList(const std::vector<int>& values) {
    if (values.empty()) return nullptr;

    ListNode* head = new ListNode(values[0]);
    ListNode* current = head;

    for (size_t i = 1; i < values.size(); ++i) {
        current->next = new ListNode(values[i]);
        current = current->next;
    }

    return head;
}

// Helper function to convert linked list to vector (for easy printing)
std::vector<int> linkedListToVector(ListNode* head) {
    std::vector<int> result;
    ListNode* current = head;
    while (current != nullptr) {
        result.push_back(current->val);
        current = current->next;
    }
    return result;
}

// Helper function to print the linked list
void printList(ListNode* head) {
    std::vector<int> values = linkedListToVector(head);
    for (size_t i = 0; i < values.size(); ++i) {
        std::cout << values[i];
        if (i < values.size() - 1) {
            std::cout << " -> ";
        }
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
    // Create test lists: [1,2,4] and [1,3,4]
    std::vector<int> list1_vals = {1, 2, 4};
    std::vector<int> list2_vals = {1, 3, 4};

    ListNode* list1 = createLinkedList(list1_vals);
    ListNode* list2 = createLinkedList(list2_vals);

    std::cout << "List 1: ";
    printList(list1);
    std::cout << "List 2: ";
    printList(list2);

    // Merge the lists
    ListNode* merged = mergeTwoLists(list1, list2);

    std::cout << "\nMerged list: ";
    printList(merged);

    // Verify the result
    std::vector<int> result = linkedListToVector(merged);
    std::vector<int> expected = {1, 1, 2, 3, 4, 4};

    std::cout << "\nResult: [";
    for (size_t i = 0; i < result.size(); ++i) {
        std::cout << result[i];
        if (i < result.size() - 1) std::cout << ", ";
    }
    std::cout << "]" << std::endl;

    std::cout << "Expected: [";
    for (size_t i = 0; i < expected.size(); ++i) {
        std::cout << expected[i];
        if (i < expected.size() - 1) std::cout << ", ";
    }
    std::cout << "]" << std::endl;

    bool correct = (result == expected);
    std::cout << "Correct: " << (correct ? "Yes" : "No") << std::endl;

    // Free memory
    freeList(merged);

    return 0;
}