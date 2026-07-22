/*
 * Problem: Detect if a linked list has a cycle.
 * Approach: Floyd's cycle detection (tortoise and hare).
 * Time Complexity: O(n)
 * Space Complexity: O(1)
 * Example: Input: 1 -> 2 -> 3 -> 4 -> 2 (cycle) -> Output: true
 */

public class LinkedListCycle {
    static class ListNode {
        int val;
        ListNode next;
        ListNode(int val) { this.val = val; }
    }

    public static boolean hasCycle(ListNode head) {
        ListNode slow = head, fast = head;
        while (fast != null && fast.next != null) {
            slow = slow.next;
            fast = fast.next.next;
            if (slow == fast) return true;
        }
        return false;
    }

    public static void main(String[] args) {
        ListNode head = new ListNode(1);
        head.next = new ListNode(2);
        head.next.next = new ListNode(3);
        head.next.next.next = new ListNode(4);
        head.next.next.next.next = head.next;
        System.out.println(hasCycle(head));
    }
}
