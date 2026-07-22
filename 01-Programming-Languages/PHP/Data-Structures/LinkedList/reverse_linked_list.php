<?php

/*
Problem: Reverse Linked List
Description: Reverse a singly linked list in-place.

Approach:
- Use three pointers: prev, curr, next
- Point current node's next to prev, then advance all pointers
- Return prev as the new head

Time Complexity: O(n)
Space Complexity: O(1)

Example:
Input:  1 -> 2 -> 3 -> 4 -> 5
Output: 5 -> 4 -> 3 -> 2 -> 1
*/

class ListNode {
    public $val;
    public $next;

    public function __construct($val = 0, $next = null) {
        $this->val = $val;
        $this->next = $next;
    }
}

function reverseList(?ListNode $head): ?ListNode {
    $prev = null;
    $curr = $head;
    while ($curr !== null) {
        $next = $curr->next;
        $curr->next = $prev;
        $prev = $curr;
        $curr = $next;
    }
    return $prev;
}

function printList(?ListNode $head): void {
    $vals = [];
    while ($head !== null) {
        $vals[] = $head->val;
        $head = $head->next;
    }
    echo implode(" -> ", $vals) . "\n";
}

$head = new ListNode(1, new ListNode(2, new ListNode(3, new ListNode(4, new ListNode(5)))));
echo "Original: ";
printList($head);
$reversed = reverseList($head);
echo "Reversed: ";
printList($reversed);
