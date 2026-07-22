# Problem: Linked List Cycle Detection
# Description: Detect if a linked list has a cycle using Floyd's algorithm.
#
# Approach:
# - Use two pointers: slow (moves 1 step) and fast (moves 2 steps)
# - If they meet, a cycle exists
#
# Time Complexity: O(n)
# Space Complexity: O(1)
#
# Example:
# Input: 1 -> 2 -> 3 -> 4 -> 2 (cycle back to node 2)
# Output: TRUE

ListNode <- function(val = 0, next_node = NULL) {
  list(val = val, next = next_node)
}

has_cycle <- function(head) {
  if (is.null(head) || is.null(head$next)) return(FALSE)
  slow <- head
  fast <- head$next
  while (!is.null(slow) && !is.null(fast) && !is.null(fast$next)) {
    if (slow == fast) return(TRUE)
    slow <- slow$next
    fast <- fast$next$next
  }
  FALSE
}

# Create a linked list with a cycle: 1 -> 2 -> 3 -> 4 -> 2
n4 <- ListNode(4, NULL)
n3 <- ListNode(3, n4)
n2 <- ListNode(2, n3)
n1 <- ListNode(1, n2)
n4$next <- n2  # create cycle

cat("Has cycle:", has_cycle(n1), "\n")

# List without cycle
n5 <- ListNode(5, NULL)
n4b <- ListNode(4, n5)
n3b <- ListNode(3, n4b)
n2b <- ListNode(2, n3b)
n1b <- ListNode(1, n2b)

cat("Has cycle (no cycle):", has_cycle(n1b), "\n")
