<?php

/*
Problem: Linked List Cycle Detection
Description: Determine if a linked list has a cycle using Floyd's Tortoise and Hare.

Approach:
- Use two pointers: slow moves one step, fast moves two steps
- If they meet, a cycle exists; if fast reaches null, no cycle

Time Complexity: O(n)
Space Complexity: O(1)

Example:
Input:  3 -> 2 -> 0 -> -4 (cycle back to index 1)
Output: true

Input:  1 -> 2 (no cycle)
Output: false
*/

class ListNode {
    public $val;
    public $next;

    public function __construct($val = 0, $next = null) {
        $this->val = $val;
        $this->next = $next;
    }
}

function hasCycle(?ListNode $head): bool {
    $slow = $head;
    $fast = $head;
    while ($fast !== null && $fast->next !== null) {
        $slow = $slow->next;
        $fast = $fast->next->next;
        if ($slow === $fast) return true;
    }
    return false;
}

// No cycle
$head = new ListNode(1, new ListNode(2));
echo "Has cycle (no cycle): " . (hasCycle($head) ? "true" : "false") . "\n";

// With cycle
$node1 = new ListNode(3);
$node2 = new ListNode(2);
$node3 = new ListNode(0);
$node4 = new ListNode(-4);
$node1->next = $node2;
$node2->next = $node3;
$node3->next = $node4;
$node4->next = $node2;
echo "Has cycle (cycle): " . (hasCycle($node1) ? "true" : "false") . "\n";
