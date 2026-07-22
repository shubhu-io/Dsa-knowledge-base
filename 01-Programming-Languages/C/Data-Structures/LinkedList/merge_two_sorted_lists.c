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

#include <stdio.h>
#include <stdlib.h>

typedef struct Node
{
    int data;
    struct Node *next;
} Node;

Node *new_node(int data)
{
    Node *node = (Node *)malloc(sizeof(Node));
    node->data = data;
    node->next = NULL;
    return node;
}

Node *merge_two_lists(Node *l1, Node *l2)
{
    Node dummy;
    Node *tail = &dummy;
    dummy.next = NULL;
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
        printf("%d -> ", head->data);
        head = head->next;
    }
    printf("NULL\n");
}

int main()
{
    Node *l1 = new_node(1);
    l1->next = new_node(3);
    l1->next->next = new_node(5);
    Node *l2 = new_node(2);
    l2->next = new_node(4);
    l2->next->next = new_node(6);
    Node *merged = merge_two_lists(l1, l2);
    print_list(merged);
    return 0;
}
