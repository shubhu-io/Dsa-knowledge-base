# Problem: Valid Parentheses
# Description: Check if a string of brackets is properly closed and nested.
#
# Approach:
# - Use a stack to track opening brackets
# - Match closing brackets with the top of the stack
#
# Time Complexity: O(n)
# Space Complexity: O(n)
#
# Example:
# Input: "()[]{}"
# Output: TRUE
# Input: "(]"
# Output: FALSE

is_valid <- function(s) {
  stack <- c()
  pairs <- c("(" = ")", "{" = "}", "[" = "]")
  for (i in 1:nchar(s)) {
    ch <- substr(s, i, i)
    if (ch %in% names(pairs)) {
      stack <- c(stack, ch)
    } else {
      if (length(stack) == 0) return(FALSE)
      top <- stack[length(stack)]
      stack <- stack[-length(stack)]
      if (pairs[top] != ch) return(FALSE)
    }
  }
  length(stack) == 0
}

test_cases <- c("()[]{}", "(]", "([)]", "{[]}", "")
for (s in test_cases) {
  cat(sprintf('"%s" -> %s\n', s, ifelse(is_valid(s), "TRUE", "FALSE")))
}
