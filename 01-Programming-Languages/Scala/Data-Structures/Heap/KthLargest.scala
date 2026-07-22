// Problem: Kth Largest Element
// Description: Find the kth largest element in an unsorted array.
//
// Approach:
// - Use a min-heap (PriorityQueue) to track the k largest elements seen
// - Return the root of the heap
//
// Time Complexity: O(n log k)
// Space Complexity: O(k)
//
// Example:
// Input: nums = Array(3, 2, 1, 5, 6, 4), k = 2
// Output: 5

object KthLargest {
  def findKthLargest(nums: Array[Int], k: Int): Int = {
    val minHeap = scala.collection.mutable.PriorityQueue[Int]()(Ordering.Int.reverse)
    for (num <- nums) {
      minHeap.enqueue(num)
      if (minHeap.size > k) minHeap.dequeue()
    }
    minHeap.head
  }

  def main(args: Array[String]): Unit = {
    val nums = Array(3, 2, 1, 5, 6, 4)
    val k = 2
    println(s"Array: ${nums.mkString(", ")}")
    println(s"k = $k -> ${findKthLargest(nums, k)}")

    val nums2 = Array(3, 2, 3, 1, 2, 4, 5, 5, 6)
    val k2 = 4
    println(s"Array: ${nums2.mkString(", ")}")
    println(s"k = $k2 -> ${findKthLargest(nums2, k2)}")
  }
}
