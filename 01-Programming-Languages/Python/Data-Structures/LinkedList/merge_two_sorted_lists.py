'''
Problem: Merge Two Sorted Lists
You are given the heads of two sorted linked lists list1 and list2.
Merge the two lists into one sorted list. The list should be made by
splicing together the nodes of the first two lists.
Return the head of the merged linked list.

Approach:
- Use a dummy node to simplify the merging process
- Compare the values of the nodes from both lists
- Append the smaller node to the result list
- Move the pointer of the list from which the node was taken
- Continue until one list is exhausted
- Append the remaining nodes of the other list
- Time: O(n + m), Space: O(1)

Example:
Input: list1 = [1,2,4], list2 = [1,3,4]
Output: [1,1,2,3,4,4]
'''

# Definition for singly-linked list.
class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next

class Solution:
    def mergeTwoLists(self, list1: ListNode, list2: ListNode) -> ListNode:
        """
        Merges two sorted linked lists into one sorted list.

        Args:
            list1: Head of the first sorted linked list
            list2: Head of the second sorted linked list

        Returns:
            Head of the merged sorted linked list
        """
        # Create a dummy node to serve as the start of the result list
        dummy = ListNode()
        current = dummy

        # Traverse both lists until one is exhausted
        while list1 and list2:
            if list1.val < list2.val:
                current.next = list1
                list1 = list1.next
            else:
                current.next = list2
                list2 = list2.next
            current = current.next

        # Attach the remaining elements
        current.next = list1 if list1 else list2

        # The next node after dummy is the head of the merged list
        return dummy.next

# Helper functions for testing
def create_linked_list(values):
    """Creates a linked list from a list of values."""
    if not values:
        return None

    head = ListNode(values[0])
    current = head

    for value in values[1:]:
        current.next = ListNode(value)
        current = current.next

    return head

def linked_list_to_list(head):
    """Converts a linked list to a Python list."""
    result = []
    current = head
    while current:
        result.append(current.val)
        current = current.next
    return result

def print_linked_list(head):
    """Prints a linked list in a readable format."""
    values = linked_list_to_list(head)
    if not values:
        print("Empty list")
        return

    print(" -> ".join(map(str, values)) + " -> None")

# Example usage
if __name__ == "__main__":
    solution = Solution()

    # Create test lists: [1,2,4] and [1,3,4]
    list1 = create_linked_list([1, 2, 4])
    list2 = create_linked_list([1, 3, 4])

    print("List 1:")
    print_linked_list(list1)
    print("List 2:")
    print_linked_list(list2)

    # Merge the lists
    merged = solution.mergeTwoLists(list1, list2)

    print("\nMerged list:")
    print_linked_list(merged)

    # Verify the result
    result = linked_list_to_list(merged)
    expected = [1, 1, 2, 3, 4, 4]

    print(f"\nResult: {result}")
    print(f"Expected: {expected}")
    print(f"Correct: {result == expected}")