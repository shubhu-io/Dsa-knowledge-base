/*
 * Problem: Find the kth largest element in an array.
 * Approach: Use a min-heap of size k (PriorityQueue).
 * Time Complexity: O(n log k)
 * Space Complexity: O(k)
 * Example: Input: nums = [3,2,1,5,6,4], k = 2 -> Output: 5
 */

import java.util.*;

public class KthLargest {
    public static int findKthLargest(int[] nums, int k) {
        PriorityQueue<Integer> minHeap = new PriorityQueue<>();
        for (int num : nums) {
            minHeap.offer(num);
            if (minHeap.size() > k) minHeap.poll();
        }
        return minHeap.peek();
    }

    public static void main(String[] args) {
        int[] nums = {3, 2, 1, 5, 6, 4};
        int k = 2;
        System.out.println(findKthLargest(nums, k));
    }
}
