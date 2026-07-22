# Problem: Tower of Hanoi
# Description: Move n disks from source to destination using an auxiliary peg.
#
# Approach:
# - Move n-1 disks from source to auxiliary
# - Move nth disk from source to destination
# - Move n-1 disks from auxiliary to destination
#
# Time Complexity: O(2^n)
# Space Complexity: O(n) (recursion stack)
#
# Example:
# Input: n = 3, source = "A", destination = "C", auxiliary = "B"
# Output: Moves to transfer all disks

tower_of_hanoi <- function(n, source, destination, auxiliary) {
  if (n == 1) {
    cat("Move disk 1 from", source, "to", destination, "\n")
    return()
  }
  tower_of_hanoi(n - 1, source, auxiliary, destination)
  cat("Move disk", n, "from", source, "to", destination, "\n")
  tower_of_hanoi(n - 1, auxiliary, destination, source)
}

cat("Tower of Hanoi - 3 disks:\n")
tower_of_hanoi(3, "A", "C", "B")
