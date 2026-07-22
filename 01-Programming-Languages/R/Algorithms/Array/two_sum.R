# Problem: Two Sum
# Description: Find two indices in an array whose values sum to a target.
#
# Approach:
# - Use a hash map to store seen values and their indices
# - For each element, check if complement (target - element) exists
#
# Time Complexity: O(n)
# Space Complexity: O(n)
#
# Example:
# Input: nums = c(2, 7, 11, 15), target = 9
# Output: c(1, 2)

two_sum <- function(nums, target) {
  seen <- list()
  for (i in seq_along(nums)) {
    complement <- target - nums[i]
    if (!is.null(seen[[as.character(complement)]])) {
      return(c(seen[[as.character(complement)]], i))
    }
    seen[[as.character(nums[i])]] <- i
  }
  NULL
}

nums <- c(2, 7, 11, 15)
target <- 9
result <- two_sum(nums, target)
cat("nums:", nums, "\n")
cat("target:", target, "-> indices:", result[1], result[2], "\n")
