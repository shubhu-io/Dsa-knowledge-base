# Problem: Merge Two Sorted Lists
# Description: Merge two sorted linked lists into one sorted list.
#
# Approach:
# - Use a dummy head node
# - Compare nodes from both lists and attach the smaller one
#
# Time Complexity: O(n + m)
# Space Complexity: O(1)
#
# Example:
# Input: 1 -> 2 -> 4, 1 -> 3 -> 4
# Output: 1 -> 1 -> 2 -> 3 -> 4 -> 4

ListNode <- function(val = 0, next_node = NULL) {
  list(val = val, next = next_node)
}

merge_two_lists <- function(l1, l2) {
  dummy <- ListNode(0, NULL)
  current <- dummy
  while (!is.null(l1) && !is.null(l2)) {
    if (l1$val <= l2$val) {
      current$next <- l1
      l1 <- l1$next
    } else {
      current$next <- l2
      l2 <- l2$next
    }
    current <- current$next
  }
  if (!is.null(l1)) current$next <- l1
  if (!is.null(l2)) current$next <- l2
  dummy$next
}

list_to_vector <- function(head) {
  result <- c()
  while (!is.null(head)) {
    result <- c(result, head$val)
    head <- head$next
  }
  result
}

l1 <- ListNode(1, ListNode(2, ListNode(4, NULL)))
l2 <- ListNode(1, ListNode(3, ListNode(4, NULL)))
merged <- merge_two_lists(l1, l2)
cat("Merged:", list_to_vector(merged), "\n")
