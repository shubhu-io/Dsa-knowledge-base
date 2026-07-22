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

// Definition for singly-linked list.
class ListNode {
    constructor(val = 0, next = null) {
        this.val = val;
        this.next = next;
    }
}

/**
 * Merges two sorted linked lists into one sorted list.
 * @param {ListNode|null} list1 - Head of the first sorted linked list
 * @param {ListNode|null} list2 - Head of the second sorted linked list
 * @return {ListNode|null} - Head of the merged sorted linked list
 */
function mergeTwoLists(list1, list2) {
    // Create a dummy node to serve as the start of the result list
    const dummy = new ListNode();
    let current = dummy;

    // Traverse both lists until one is exhausted
    while (list1 !== null && list2 !== null) {
        if (list1.val < list2.val) {
            current.next = list1;
            list1 = list1.next;
        } else {
            current.next = list2;
            list2 = list2.next;
        }
        current = current.next;
    }

    // Attach the remaining elements
    current.next = (list1 !== null) ? list1 : list2;

    // The next node after dummy is the head of the merged list
    return dummy.next;
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
    let output = "";
    for (let i = 0; i < values.length; i++) {
        output += values[i];
        if (i < values.length - 1) {
            output += " -> ";
        }
    }
    output += " -> NULL";
    console.log(output);
}

// Example usage
if (require.main === module) {
    // Create test lists: [1,2,4] and [1,3,4]
    const list1 = createLinkedList([1, 2, 4]);
    const list2 = createLinkedList([1, 3, 4]);

    console.log("List 1:");
    printList(list1);
    console.log("List 2:");
    printList(list2);

    // Merge the lists
    const merged = mergeTwoLists(list1, list2);

    console.log("\nMerged list:");
    printList(merged);

    // Verify the result
    const result = linkedListToArray(merged);
    const expected = [1, 1, 2, 3, 4, 4];

    console.log(`\nResult: [${result.join(", ")}]`);
    console.log(`Expected: [${expected.join(", ")}]`);

    const correct = JSON.stringify(result) === JSON.stringify(expected);
    console.log(`Correct: ${correct ? "Yes" : "No"}`);
}