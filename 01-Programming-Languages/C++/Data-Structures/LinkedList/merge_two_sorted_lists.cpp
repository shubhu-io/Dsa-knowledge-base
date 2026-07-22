/*
Problem: Merge Two Sorted Lists
Merge two sorted linked lists into one sorted list.

Approach:
- Iterative two-pointer merge

Time Complexity: O(n + m)
Space Complexity: O(1)

Example:
Input: 1 -> 3 -> 5, 2 -> 4 -> 6
Output: 1 -> 2 -> 3 -> 4 -> 5 -> 6
*/

#include <iostream>
using namespace std;

struct Node
{
    int data;
    Node *next;
    Node(int val) : data(val), next(nullptr) {}
};

Node *merge_two_lists(Node *l1, Node *l2)
{
    Node dummy(0);
    Node *tail = &dummy;
    while (l1 && l2)
    {
        if (l1->data <= l2->data)
        {
            tail->next = l1;
            l1 = l1->next;
        }
        else
        {
            tail->next = l2;
            l2 = l2->next;
        }
        tail = tail->next;
    }
    tail->next = l1 ? l1 : l2;
    return dummy.next;
}

void print_list(Node *head)
{
    while (head)
    {
        cout << head->data << " -> ";
        head = head->next;
    }
    cout << "NULL" << endl;
}

int main()
{
    Node *l1 = new Node(1);
    l1->next = new Node(3);
    l1->next->next = new Node(5);
    Node *l2 = new Node(2);
    l2->next = new Node(4);
    l2->next->next = new Node(6);
    Node *merged = merge_two_lists(l1, l2);
    print_list(merged);
    return 0;
}
