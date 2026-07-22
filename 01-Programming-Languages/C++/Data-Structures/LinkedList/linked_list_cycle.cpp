/*
Problem: Linked List Cycle
Detect if a linked list has a cycle using Floyd's cycle detection.

Approach:
- Two pointers (slow and fast)

Time Complexity: O(n)
Space Complexity: O(1)

Example:
Input: 1 -> 2 -> 3 -> 4 -> 2 (cycle)
Output: Cycle detected
*/

#include <iostream>
using namespace std;

struct Node
{
    int data;
    Node *next;
    Node(int val) : data(val), next(nullptr) {}
};

bool has_cycle(Node *head)
{
    Node *slow = head, *fast = head;
    while (fast && fast->next)
    {
        slow = slow->next;
        fast = fast->next->next;
        if (slow == fast) return true;
    }
    return false;
}

int main()
{
    Node *head = new Node(1);
    head->next = new Node(2);
    head->next->next = new Node(3);
    head->next->next->next = new Node(4);
    head->next->next->next->next = head->next; // create cycle
    cout << (has_cycle(head) ? "Cycle detected" : "No cycle") << endl;
    return 0;
}
