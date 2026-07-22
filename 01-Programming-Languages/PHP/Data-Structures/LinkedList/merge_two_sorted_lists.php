<?php

/*
Problem: Merge Two Sorted Lists
Description: Merge two sorted linked lists into one sorted linked list.

Approach:
- Use a dummy head node for easy result building
- Compare heads of both lists, append the smaller one
- Advance pointer in the list whose node was taken
- Append remaining nodes of the non-empty list

Time Complexity: O(n + m)
Space Complexity: O(1)

Example:
Input:  list1 = 1 -> 2 -> 4, list2 = 1 -> 3 -> 4
Output: 1 -> 1 -> 2 -> 3 -> 4 -> 4
*/

class ListNode {
    public $val;
    public $next;

    public function __construct($val = 0, $next = null) {
        $this->val = $val;
        $this->next = $next;
    }
}

function mergeTwoLists(?ListNode $l1, ?ListNode $l2): ?ListNode {
    $dummy = new ListNode();
    $tail = $dummy;
    while ($l1 !== null && $l2 !== null) {
        if ($l1->val <= $l2->val) {
            $tail->next = $l1;
            $l1 = $l1->next;
        } else {
            $tail->next = $l2;
            $l2 = $l2->next;
        }
        $tail = $tail->next;
    }
    $tail->next = $l1 ?? $l2;
    return $dummy->next;
}

function printList(?ListNode $head): void {
    $vals = [];
    while ($head !== null) {
        $vals[] = $head->val;
        $head = $head->next;
    }
    echo implode(" -> ", $vals) . "\n";
}

$l1 = new ListNode(1, new ListNode(2, new ListNode(4)));
$l2 = new ListNode(1, new ListNode(3, new ListNode(4)));
echo "Merged: ";
printList(mergeTwoLists($l1, $l2));
