# Problem: Palindrome Check
# Description: Check if a given string is a palindrome.
#
# Approach:
# - Use two pointers: one from start, one from end
# - Compare characters moving inward
#
# Time Complexity: O(n)
# Space Complexity: O(1)
#
# Example:
# Input: "racecar"
# Output: TRUE
# Input: "hello"
# Output: FALSE

is_palindrome <- function(s) {
  left <- 1
  right <- nchar(s)
  while (left < right) {
    if (substr(s, left, left) != substr(s, right, right)) {
      return(FALSE)
    }
    left <- left + 1
    right <- right - 1
  }
  TRUE
}

test_cases <- c("racecar", "hello", "madam", "a", "")
for (s in test_cases) {
  result <- is_palindrome(s)
  cat(sprintf('"%s" -> %s\n', s, ifelse(result, "TRUE", "FALSE")))
}
