"""
Problem: Linked List Cycle
Given head, the head of a linked list, determine if the linked list has a cycle in it.
There is a cycle in a linked list if there is some node in the list that can be reached again
by continuously following the next pointer. Internally, pos is used to denote the index of the
node that tail's next pointer is connected to. Note that pos is not passed as a parameter.

Approach (Floyd's Tortoise and Hare):
- Use two pointers: slow and fast
- Slow pointer moves one step at a time
- Fast pointer moves two steps at a time
- If there is a cycle, the fast pointer will eventually meet the slow pointer
- If there is no cycle, the fast pointer will reach the end (None)
- Time Complexity: O(n)
- Space Complexity: O(1)

Example:
Input: head = [3,2,0,-4], pos = 1 (tail connects to node index 1)
Output: True
"""

# Definition for singly-linked list.
class ListNode:
    def __init__(self, x):
        self.val = x
        self.next = None

class Solution:
    def hasCycle(self, head: ListNode) -> bool:
        """
        Determines if a linked list has a cycle.

        Args:
            head: The head of the linked list

        Returns:
            True if there is a cycle, False otherwise
        """
        # Handle empty list or single node without cycle
        if head is None or head.next is None:
            return False

        # Initialize slow and fast pointers
        slow = head
        fast = head.next

        # Traverse the list
        while fast is not None and fast.next is not None:
            # If pointers meet, there is a cycle
            if slow == fast:
                return True
            # Move slow pointer one step
            slow = slow.next
            # Move fast pointer two steps
            fast = fast.next.next

        # If we reach here, fast pointer hit the end (no cycle)
        return False


# Helper functions for testing
def create_list(values):
    """Creates a linked list from a list of values."""
    if not values:
        return None

    head = ListNode(values[0])
    current = head

    for val in values[1:]:
        current.next = ListNode(val)
        current = current.next

    return head


def create_cycle(head, pos):
    """Creates a cycle in the linked list at the given position."""
    if head is None or pos < 0:
        return

    # Find the node at position 'pos'
    cycle_node = head
    current_pos = 0
    while current_pos < pos and current_node is not None:
        current_node = current_node.next
        current_pos += 1

    if current_node is None:
        return  # Position out of bounds

    # Find the last node
    last_node = head
    while last_node.next is not None:
        last_node = last_node.next

    # Create the cycle
    last_node.next = cycle_node


def print_list_safe(head, max_nodes=10):
    """Prints the linked list safely (detects cycles to avoid infinite printing)."""
    current = head
    values = []
    count = 0

    while current is not None and count < max_nodes:
        values.append(str(current.val))
        current = current.next
        count += 1

    result = "[" + ", ".join(values) + "]"
    if count >= max_nodes:
        result += ", ... (truncated due to possible cycle)"
    print(result)


# Example usage
if __name__ == "__main__":
    solution = Solution()

    # Example 1: List with cycle [3,2,0,-4], pos = 1
    values1 = [3, 2, 0, -4]
    head1 = create_list(values1)
    create_cycle(head1, 1)  # Create cycle at position 1

    print("List 1 (with cycle):")
    print_list_safe(head1)
    print("Has cycle:", solution.hasCycle(head1))

    # Example 2: List without cycle [1,2,3,4]
    values2 = [1, 2, 3, 4]
    head2 = create_list(values2)
    # No cycle created

    print("List 2 (without cycle):")
    print_list_safe(head2)
    print("Has cycle:", solution.hasCycle(head2))

    # Example 3: Single node with cycle
    values3 = [1]
    head3 = create_list(values3)
    create_cycle(head3, 0)  # Cycle to itself

    print("List 3 (single node with cycle):")
    print_list_safe(head3)
    print("Has cycle:", solution.hasCycle(head3))

    # Example 4: Single node without cycle
    values4 = [1]
    head4 = create_list(values4)
    # No cycle

    print("List 4 (single node without cycle):")
    print_list_safe(head4)
    print("Has cycle:", solution.hasCycle(head4))