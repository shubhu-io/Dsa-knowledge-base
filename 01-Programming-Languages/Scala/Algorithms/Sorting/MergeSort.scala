// Problem: Merge Sort
// Description: Sort an array using the divide-and-conquer merge sort algorithm.
//
// Approach:
// - Recursively split array into halves until single elements
// - Merge sorted halves back together in sorted order
//
// Time Complexity: O(n log n)
// Space Complexity: O(n)
//
// Example:
// Input: Array(38, 27, 43, 3, 9, 82, 10)
// Output: Array(3, 9, 10, 27, 38, 43, 82)

object MergeSort {
  def sort(arr: Array[Int]): Array[Int] = {
    if (arr.length <= 1) return arr
    val mid = arr.length / 2
    val left = sort(arr.slice(0, mid))
    val right = sort(arr.slice(mid, arr.length))
    merge(left, right)
  }

  private def merge(left: Array[Int], right: Array[Int]): Array[Int] = {
    val result = scala.collection.mutable.ArrayBuffer[Int]()
    var i = 0; var j = 0
    while (i < left.length && j < right.length) {
      if (left(i) <= right(j)) { result += left(i); i += 1 }
      else { result += right(j); j += 1 }
    }
    result ++= left.drop(i) ++= right.drop(j)
    result.toArray
  }

  def main(args: Array[String]): Unit = {
    val arr = Array(38, 27, 43, 3, 9, 82, 10)
    println(s"Original: ${arr.mkString(", ")}")
    val sorted = sort(arr)
    println(s"Sorted: ${sorted.mkString(", ")}")
  }
}
