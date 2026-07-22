/*
 * Problem: Reverse a singly linked list.
 * Approach: Iterative — reverse pointers using prev, current, next.
 * Time Complexity: O(n)
 * Space Complexity: O(1)
 * Example: Input: 1 -> 2 -> 3 -> 4 -> 5 -> null -> Output: 5 -> 4 -> 3 -> 2 -> 1 -> null
 */

public class ReverseLinkedList {
    static class ListNode {
        int val;
        ListNode next;
        ListNode(int val) { this.val = val; }
    }

    public static ListNode reverseList(ListNode head) {
        ListNode prev = null;
        ListNode curr = head;
        while (curr != null) {
            ListNode next = curr.next;
            curr.next = prev;
            prev = curr;
            curr = next;
        }
        return prev;
    }

    public static void main(String[] args) {
        ListNode head = new ListNode(1);
        head.next = new ListNode(2);
        head.next.next = new ListNode(3);
        head.next.next.next = new ListNode(4);
        head.next.next.next.next = new ListNode(5);
        ListNode reversed = reverseList(head);
        while (reversed != null) {
            System.out.print(reversed.val + " ");
            reversed = reversed.next;
        }
    }
}
