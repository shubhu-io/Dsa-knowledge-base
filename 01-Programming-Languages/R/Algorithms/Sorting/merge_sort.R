# Problem: Merge Sort
# Description: Sort an array using the divide-and-conquer merge sort algorithm.
#
# Approach:
# - Recursively split array into halves until single elements
# - Merge sorted halves back together in sorted order
#
# Time Complexity: O(n log n)
# Space Complexity: O(n)
#
# Example:
# Input: c(38, 27, 43, 3, 9, 82, 10)
# Output: c(3, 9, 10, 27, 38, 43, 82)

merge_sort <- function(arr) {
  n <- length(arr)
  if (n <= 1) return(arr)
  mid <- n %/% 2
  left <- merge_sort(arr[1:mid])
  right <- merge_sort(arr[(mid + 1):n])
  merge(left, right)
}

merge <- function(left, right) {
  result <- c()
  i <- j <- 1
  while (i <= length(left) && j <= length(right)) {
    if (left[i] <= right[j]) {
      result <- c(result, left[i])
      i <- i + 1
    } else {
      result <- c(result, right[j])
      j <- j + 1
    }
  }
  c(result, left[i:length(left)], right[j:length(right)])
}

arr <- c(38, 27, 43, 3, 9, 82, 10)
cat("Original:", arr, "\n")
sorted <- merge_sort(arr)
cat("Sorted:", sorted, "\n")
