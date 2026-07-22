# Problem: Binary Search
# Description: Find the index of a target value in a sorted array.
#
# Approach:
# - Repeatedly divide the search interval in half
# - Compare target with middle element to narrow the search
#
# Time Complexity: O(log n)
# Space Complexity: O(1)
#
# Example:
# Input: arr = c(1, 3, 5, 7, 9, 11), target = 7
# Output: 4

binary_search <- function(arr, target) {
  left <- 1
  right <- length(arr)
  while (left <= right) {
    mid <- left + (right - left) %/% 2
    if (arr[mid] == target) return(mid)
    if (arr[mid] < target) left <- mid + 1
    else right <- mid - 1
  }
  -1
}

arr <- c(1, 3, 5, 7, 9, 11)
target <- 7
idx <- binary_search(arr, target)
cat("Array:", arr, "\n")
cat("Target:", target, "-> Index:", idx, "\n")
