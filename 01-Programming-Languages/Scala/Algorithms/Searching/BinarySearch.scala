// Problem: Binary Search
// Description: Find the index of a target value in a sorted array.
//
// Approach:
// - Repeatedly divide the search interval in half
// - Compare target with middle element to narrow the search
//
// Time Complexity: O(log n)
// Space Complexity: O(1)
//
// Example:
// Input: arr = Array(1, 3, 5, 7, 9, 11), target = 7
// Output: 3

object BinarySearch {
  def search(arr: Array[Int], target: Int): Int = {
    var left = 0; var right = arr.length - 1
    while (left <= right) {
      val mid = left + (right - left) / 2
      if (arr(mid) == target) return mid
      if (arr(mid) < target) left = mid + 1
      else right = mid - 1
    }
    -1
  }

  def main(args: Array[String]): Unit = {
    val arr = Array(1, 3, 5, 7, 9, 11)
    val target = 7
    val idx = search(arr, target)
    println(s"Array: ${arr.mkString(", ")}")
    println(s"Target: $target -> Index: $idx")
  }
}
