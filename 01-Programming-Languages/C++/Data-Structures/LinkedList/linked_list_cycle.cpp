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
 * - If there is no cycle, the fast pointer will reach the end (nullptr)
 * - Time Complexity: O(n)
 * - Space Complexity: O(1)
 *
 * Example:
 * Input: head = [3,2,0,-4], pos = 1 (tail connects to node index 1)
 * Output: true
 */

#include <iostream>
#include <vector>

// Definition for singly-linked list.
struct ListNode {
    int val;
    ListNode *next;
    ListNode() : val(0), next(nullptr) {}
    ListNode(int x) : val(x), next(nullptr) {}
    ListNode(int x, ListNode *next) : val(x), next(next) {}
};

/**
 * Determines if a linked list has a cycle.
 *
 * @param head The head of the linked list
 * @return true if there is a cycle, false otherwise
 */
bool hasCycle(ListNode *head) {
    // Handle empty list or single node without cycle
    if (head == nullptr || head->next == nullptr) {
        return false;
    }

    // Initialize slow and fast pointers
    ListNode *slow = head;
    ListNode *fast = head->next;

    // Traverse the list
    while (fast != nullptr && fast->next != nullptr) {
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

// Helper function to create a linked list from a vector
ListNode* createList(const std::vector<int>& values) {
    if (values.empty()) return nullptr;

    ListNode* head = new ListNode(values[0]);
    ListNode* current = head;

    for (size_t i = 1; i < values.size(); i++) {
        current->next = new ListNode(values[i]);
        current = current->next;
    }

    return head;
}

// Helper function to create a cycle in the list (for testing)
void createCycle(ListNode* head, int pos) {
    if (head == nullptr || pos < 0) return;

    // Find the node at position 'pos'
    ListNode* cycleNode = head;
    int currentPos = 0;
    while (currentPos < pos && cycleNode != nullptr) {
        cycleNode = cycleNode->next;
        currentPos++;
    }

    if (cycleNode == nullptr) return; // Position out of bounds

    // Find the last node
    ListNode* lastNode = head;
    while (lastNode->next != nullptr) {
        lastNode = lastNode->next;
    }

    // Create the cycle
    lastNode->next = cycleNode;
}

// Helper function to print the list (safe version that detects cycles)
void printListSafe(ListNode* head, int maxNodes) {
    ListNode* current = head;
    int count = 0;

    std::cout << "[";
    while (current != nullptr && count < maxNodes) {
        std::cout << current->val;
        if (current->next != nullptr && count < maxNodes - 1) {
            std::cout << ", ";
        }
        current = current->next;
        count++;
    }
    if (count >= maxNodes) {
        std::cout << ", ... (truncated due to possible cycle)";
    }
    std::cout << "]\n";
}

// Helper function to delete the list (be careful with cycles)
void deleteList(ListNode* head) {
    ListNode* current = head;
    while (current != nullptr) {
        ListNode* temp = current;
        current = current->next;
        delete temp;
    }
}

// Example usage
int main() {
    // Example 1: List with cycle [3,2,0,-4], pos = 1
    std::vector<int> values1 = {3, 2, 0, -4};
    ListNode* head1 = createList(values1);
    createCycle(head1, 1); // Create cycle at position 1

    std::cout << "List 1 (with cycle): ";
    printListSafe(head1, 10); // Print extra to show cycle detection
    std::cout << "Has cycle: " << (hasCycle(head1) ? "true" : "false") << std::endl;

    // Example 2: List without cycle [1,2,3,4]
    std::vector<int> values2 = {1, 2, 3, 4};
    ListNode* head2 = createList(values2);
    // No cycle created

    std::cout << "List 2 (without cycle): ";
    printListSafe(head2, 10);
    std::cout << "Has cycle: " << (hasCycle(head2) ? "true" : "false") << std::endl;

    // Example 3: Single node with cycle
    std::vector<int> values3 = {1};
    ListNode* head3 = createList(values3);
    createCycle(head3, 0); // Cycle to itself

    std::cout << "List 3 (single node with cycle): ";
    printListSafe(head3, 10);
    std::cout << "Has cycle: " << (hasCycle(head3) ? "true" : "false") << std::endl;

    // Example 4: Single node without cycle
    std::vector<int> values4 = {1};
    ListNode* head4 = createList(values4);
    // No cycle

    std::cout << "List 4 (single node without cycle): ";
    printListSafe(head4, 10);
    std::cout << "Has cycle: " << (hasCycle(head4) ? "true" : "false") << std::endl;

    // Clean up memory (note: this will leak memory in cyclic lists, but that's okay for demo)
    // In real code, you'd need to break cycles before deleting
    deleteList(head1);
    deleteList(head2);
    deleteList(head3);
    deleteList(head4);

    return 0;
}