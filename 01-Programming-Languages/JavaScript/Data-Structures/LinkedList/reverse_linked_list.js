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

// Definition for singly-linked list.
class ListNode {
    constructor(val = 0, next = null) {
        this.val = val;
        this.next = next;
    }
}

/**
 * Reverses a singly linked list.
 * @param {ListNode|null} head - The head of the linked list
 * @return {ListNode|null} - The new head of the reversed list
 */
function reverseList(head) {
    let prev = null;
    let current = head;
    let next = null;

    while (current !== null) {
        // Store next node
        next = current.next;
        // Reverse current node's pointer
        current.next = prev;
        // Move pointers one position ahead
        prev = current;
        current = next;
    }

    // Prev will be the new head
    return prev;
}

// Helper function to create a linked list from an array
function createLinkedList(arr) {
    if (arr.length === 0) return null;

    let head = new ListNode(arr[0]);
    let current = head;

    for (let i = 1; i < arr.length; i++) {
        current.next = new ListNode(arr[i]);
        current = current.next;
    }

    return head;
}

// Helper function to convert linked list to array (for easy printing)
function linkedListToArray(head) {
    const result = [];
    let current = head;
    while (current !== null) {
        result.push(current.val);
        current = current.next;
    }
    return result;
}

// Helper function to print the linked list
function printList(head) {
    const values = linkedListToArray(head);
    console.log(values.join(" -> ") + " -> NULL");
}

// Example usage
const head = createLinkedList([1, 2, 3, 4, 5]);
console.log("Original list:");
printList(head);

const reversedHead = reverseList(head);
console.log("\nReversed list:");
printList(reversedHead);