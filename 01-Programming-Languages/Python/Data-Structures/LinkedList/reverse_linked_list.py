'''
Problem: Reverse Linked List
Given the head of a singly linked list, reverse the list, and return the reversed list.

Approach (Iterative):
- Initialize prev = None, curr = head.
- While curr is not None:
    nxt = curr.next   # store next node
    curr.next = prev  # reverse link
    prev = curr       # move prev forward
    curr = nxt        # move curr forward
- Return prev (new head).

Time: O(n), Space: O(1).

Approach (Recursive):
- Base case: if head is None or head.next is None: return head.
- Recursively reverse the rest: new_head = reverseList(head.next)
- Then head.next.next = head, and head.next = None.
- Return new_head.
Time: O(n), Space: O(n) due to recursion stack.

We'll implement iterative version.
'''

class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next

def reverse_linked_list(head):
    prev = None
    curr = head
    while curr:
        nxt = curr.next
        curr.next = prev
        prev = curr
        curr = nxt
    return prev

# Helper to create linked list from list of values
def create_linked_list(values):
    dummy = ListNode()
    cur = dummy
    for v in values:
        cur.next = ListNode(v)
        cur = cur.next
    return dummy.next

# Helper to convert linked list to list (for easy printing)
def linked_list_to_list(head):
    res = []
    while head:
        res.append(head.val)
        head = head.next
    return res

if __name__ == "__main__":
    vals = [1, 2, 3, 4, 5]
    head = create_linked_list(vals)
    print("Original:", linked_list_to_list(head))
    rev_head = reverse_linked_list(head)
    print("Reversed:", linked_list_to_list(rev_head))