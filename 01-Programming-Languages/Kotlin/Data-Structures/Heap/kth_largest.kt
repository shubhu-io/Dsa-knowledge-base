/*
 * Problem: Find the kth largest element in an array.
 * Approach: Use a min-heap of size k (PriorityQueue).
 * Time Complexity: O(n log k)
 * Space Complexity: O(k)
 * Example: Input: nums = [3,2,1,5,6,4], k = 2 -> Output: 5
 */

import java.util.*

fun findKthLargest(nums: IntArray, k: Int): Int {
    val minHeap = PriorityQueue<Int>()
    for (num in nums) {
        minHeap.offer(num)
        if (minHeap.size > k) minHeap.poll()
    }
    return minHeap.peek()
}

fun main() {
    val nums = intArrayOf(3, 2, 1, 5, 6, 4)
    println(findKthLargest(nums, 2))
}
