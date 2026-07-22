// Problem: Merge Intervals
// Description: Merge all overlapping intervals in a list.
//
// Approach:
// - Sort intervals by start time
// - Iterate and merge if current interval overlaps with the last merged
//
// Time Complexity: O(n log n)
// Space Complexity: O(n)
//
// Example:
// Input: Array((1,3), (2,6), (8,10), (15,18))
// Output: Array((1,6), (8,10), (15,18))

object MergeIntervals {
  def merge(intervals: Array[(Int, Int)]): Array[(Int, Int)] = {
    if (intervals.isEmpty) return Array()
    val sorted = intervals.sortBy(_._1)
    val result = scala.collection.mutable.ArrayBuffer[(Int, Int)]()
    result += sorted(0)
    for (curr <- sorted.tail) {
      val last = result.last
      if (curr._1 <= last._2) {
        result(result.length - 1) = (last._1, math.max(last._2, curr._2))
      } else {
        result += curr
      }
    }
    result.toArray
  }

  def main(args: Array[String]): Unit = {
    val intervals = Array((1, 3), (2, 6), (8, 10), (15, 18))
    println("Input intervals: " + intervals.map(t => s"[${t._1},${t._2}]").mkString(", "))
    val merged = merge(intervals)
    println("Merged intervals: " + merged.map(t => s"[${t._1},${t._2}]").mkString(", "))
  }
}
