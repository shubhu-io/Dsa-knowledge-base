# Problem: Kth Largest Element
# Description: Find the kth largest element in an unsorted array.
#
# Approach:
# - Use a min-heap to track the k largest elements seen
# - Return the root of the heap
#
# Time Complexity: O(n log k)
# Space Complexity: O(k)
#
# Example:
# Input: nums = c(3, 2, 1, 5, 6, 4), k = 2
# Output: 5

find_kth_largest <- function(nums, k) {
  heap <- nums[1:k]
  heap <- sort(heap)
  for (i in (k + 1):length(nums)) {
    if (nums[i] > heap[1]) {
      heap[1] <- nums[i]
      heap <- sort(heap)
    }
  }
  heap[1]
}

nums <- c(3, 2, 1, 5, 6, 4)
k <- 2
cat("Array:", nums, "\n")
cat("k =", k, "->", find_kth_largest(nums, k), "\n")

nums2 <- c(3, 2, 3, 1, 2, 4, 5, 5, 6)
k2 <- 4
cat("Array:", nums2, "\n")
cat("k =", k2, "->", find_kth_largest(nums2, k2), "\n")
