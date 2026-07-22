# Problem: Queue Using Stacks
# Description: Implement a FIFO queue using two stacks.
#
# Approach:
# - Use two stacks: one for enqueue, one for dequeue
# - On dequeue, transfer elements from enqueue stack to dequeue stack if empty
#
# Time Complexity: O(1) amortized
# Space Complexity: O(n)
#
# Example:
# Input: enqueue(1), enqueue(2), dequeue(), enqueue(3), dequeue(), dequeue()
# Output: 1, 2, 3

Queue <- function() {
  list(in_stack = c(), out_stack = c())
}

enqueue <- function(q, x) {
  q$in_stack <- c(q$in_stack, x)
  q
}

dequeue <- function(q) {
  if (length(q$out_stack) == 0) {
    while (length(q$in_stack) > 0) {
      q$out_stack <- c(q$out_stack, q$in_stack[length(q$in_stack)])
      q$in_stack <- q$in_stack[-length(q$in_stack)]
    }
  }
  val <- q$out_stack[length(q$out_stack)]
  q$out_stack <- q$out_stack[-length(q$out_stack)]
  list(val = val, queue = q)
}

q <- Queue()
q <- enqueue(q, 1)
q <- enqueue(q, 2)
res <- dequeue(q)
cat("Dequeued:", res$val, "\n")
q <- res$queue
q <- enqueue(q, 3)
res <- dequeue(q)
cat("Dequeued:", res$val, "\n")
res <- dequeue(q)
cat("Dequeued:", res$val, "\n")
