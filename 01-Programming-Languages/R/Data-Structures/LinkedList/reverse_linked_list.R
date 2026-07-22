# Problem: Reverse Linked List
# Description: Reverse a singly linked list iteratively.
#
# Approach:
# - Use three pointers: prev, current, next
# - Reverse links as we traverse the list
#
# Time Complexity: O(n)
# Space Complexity: O(1)
#
# Example:
# Input: 1 -> 2 -> 3 -> 4 -> 5
# Output: 5 -> 4 -> 3 -> 2 -> 1

ListNode <- function(val = 0, next_node = NULL) {
  list(val = val, next = next_node)
}

reverse_linked_list <- function(head) {
  prev <- NULL
  current <- head
  while (!is.null(current)) {
    next_node <- current$next
    current$next <- prev
    prev <- current
    current <- next_node
  }
  prev
}

list_to_vector <- function(head) {
  result <- c()
  while (!is.null(head)) {
    result <- c(result, head$val)
    head <- head$next
  }
  result
}

n5 <- ListNode(5, NULL)
n4 <- ListNode(4, n5)
n3 <- ListNode(3, n4)
n2 <- ListNode(2, n3)
n1 <- ListNode(1, n2)

cat("Original:", list_to_vector(n1), "\n")
reversed <- reverse_linked_list(n1)
cat("Reversed:", list_to_vector(reversed), "\n")
