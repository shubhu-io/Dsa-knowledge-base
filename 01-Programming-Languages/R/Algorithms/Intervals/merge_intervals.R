# Problem: Merge Intervals
# Description: Merge all overlapping intervals in a list.
#
# Approach:
# - Sort intervals by start time
# - Iterate and merge if current interval overlaps with the last merged
#
# Time Complexity: O(n log n)
# Space Complexity: O(n)
#
# Example:
# Input: list(c(1,3), c(2,6), c(8,10), c(15,18))
# Output: list(c(1,6), c(8,10), c(15,18))

merge_intervals <- function(intervals) {
  if (length(intervals) == 0) return(list())
  sorted <- intervals[order(sapply(intervals, `[`, 1))]
  merged <- list(sorted[[1]])
  for (i in 2:length(sorted)) {
    last <- merged[[length(merged)]]
    curr <- sorted[[i]]
    if (curr[1] <= last[2]) {
      merged[[length(merged)]][2] <- max(last[2], curr[2])
    } else {
      merged <- c(merged, list(curr))
    }
  }
  merged
}

intervals <- list(c(1, 3), c(2, 6), c(8, 10), c(15, 18))
cat("Input intervals:\n")
for (iv in intervals) cat(" [", iv[1], ",", iv[2], "]\n")
result <- merge_intervals(intervals)
cat("Merged intervals:\n")
for (iv in result) cat(" [", iv[1], ",", iv[2], "]\n")
