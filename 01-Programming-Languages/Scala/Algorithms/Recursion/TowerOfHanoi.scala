// Problem: Tower of Hanoi
// Description: Move n disks from source to destination using an auxiliary peg.
//
// Approach:
// - Move n-1 disks from source to auxiliary
// - Move nth disk from source to destination
// - Move n-1 disks from auxiliary to destination
//
// Time Complexity: O(2^n)
// Space Complexity: O(n) (recursion stack)
//
// Example:
// Input: n = 3, source = "A", destination = "C", auxiliary = "B"
// Output: Moves to transfer all disks

object TowerOfHanoi {
  def solve(n: Int, source: String, destination: String, auxiliary: String): Unit = {
    if (n == 1) {
      println(s"Move disk 1 from $source to $destination")
    } else {
      solve(n - 1, source, auxiliary, destination)
      println(s"Move disk $n from $source to $destination")
      solve(n - 1, auxiliary, destination, source)
    }
  }

  def main(args: Array[String]): Unit = {
    println("Tower of Hanoi - 3 disks:")
    solve(3, "A", "C", "B")
  }
}
