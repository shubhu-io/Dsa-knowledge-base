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
 * - If there is no cycle, the fast pointer will reach the end (null)
 * - Time Complexity: O(n)
 * - Space Complexity: O(1)
 *
 * Example:
 * Input: head = [3,2,0,-4], pos = 1 (tail connects to node index 1)
 * Output: true
 */

/**
 * Definition for singly-linked list.
 * function ListNode(val) {
 *     this.val = val;
 *     this.next = null;
 * }
 */

/**
 * Determines if a linked list has a cycle.
 * @param {ListNode|null} head - The head of the linked list
 * @return {boolean} - true if there is a cycle, false otherwise
 */
function hasCycle(head) {
    // Handle empty list or single node without cycle
    if (head === null || head.next === null) {
        return false;
    }

    // Initialize slow and fast pointers
    let slow = head;
    let fast = head.next;

    // Traverse the list
    while (fast !== null && fast.next !== null) {
        // If pointers meet, there is a cycle
        if (slow === fast) {
            return true;
        }
        // Move slow pointer one step
        slow = slow.next;
        // Move fast pointer two steps
        fast = fast.next.next;
    }

    // If we reach here, fast pointer hit the end (no cycle)
    return false;
}

// Helper function to create a linked list from an array
function createList(values) {
    if (values.length === 0) return null;

    let head = new ListNode(values[0]);
    let current = head;

    for (let i = 1; i < values.length; i++) {
        current.next = new ListNode(values[i]);
        current = current.next;
    }

    return head;
}

// Helper function to create a cycle in the list (for testing)
function createCycle(head, pos) {
    if (head === null || pos < 0) return;

    // Find the node at position 'pos'
    let cycleNode = head;
    let currentPos = 0;
    while (currentPos < pos && cycleNode !== null) {
        cycleNode = cycleNode.next;
        currentPos++;
    }

    if (cycleNode === null) return; // Position out of bounds

    // Find the last node
    let lastNode = head;
    while (lastNode.next !== null) {
        lastNode = lastNode.next;
    }

    // Create the cycle
    lastNode.next = cycleNode;
}

// Helper function to print the list (safe version that detects cycles)
function printListSafe(head, maxNodes) {
    let current = head;
    let count = 0;
    let values = [];

    while (current !== null && count < maxNodes) {
        values.push(current.val);
        current = current.next;
        count++;
    }

    let output = "[" + values.join(", ") + "]";
    if (count >= maxNodes) {
        output += ", ... (truncated due to possible cycle)";
    }
    console.log(output);
}

// Example usage
if (require.main === module) {
    // Define ListNode class for testing
    class ListNode {
        constructor(val) {
            this.val = val;
            this.next = null;
        }
    }

    // Example 1: List with cycle [3,2,0,-4], pos = 1
    const values1 = [3, 2, 0, -4];
    let head1 = createList(values1);
    createCycle(head1, 1); // Create cycle at position 1

    console.log("List 1 (with cycle):");
    printListSafe(head1, 10); // Print extra to show cycle detection
    console.log("Has cycle:", hasCycle(head1));

    // Example 2: List without cycle [1,2,3,4]
    const values2 = [1, 2, 3, 4];
    let head2 = createList(values2);
    // No cycle created

    console.log("List 2 (without cycle):");
    printListSafe(head2, 10);
    console.log("Has cycle:", hasCycle(head2));

    // Example 3: Single node with cycle
    const values3 = [1];
    let head3 = createList(values3);
    createCycle(head3, 0); // Cycle to itself

    console.log("List 3 (single node with cycle):");
    printListSafe(head3, 10);
    console.log("Has cycle:", hasCycle(head3));

    // Example 4: Single node without cycle
    const values4 = [1];
    let head4 = createList(values4);
    // No cycle

    console.log("List 4 (single node without cycle):");
    printListSafe(head4, 10);
    console.log("Has cycle:", hasCycle(head4));
}