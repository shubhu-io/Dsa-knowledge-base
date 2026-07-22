/*
Problem: Kth Largest Element in an Array
Description: Find the kth largest element in an unsorted array.

Approach:
- Use a min heap of size k
- Maintain k largest elements seen so far in the heap
- Top of heap is the kth largest

Time Complexity: O(n log k)
Space Complexity: O(k)

Example:
Input: nums = [3,2,1,5,6,4], k = 2
Output: 5
*/

func findKthLargest(_ nums: [Int], _ k: Int) -> Int {
    var heap = [Int]()
    for num in nums {
        heap.append(num)
        heap.sort()
        if heap.count > k { heap.removeFirst() }
    }
    return heap.first!
}

let nums = [3, 2, 1, 5, 6, 4]
print("2nd largest: \(findKthLargest(nums, 2))")

let nums2 = [3, 2, 3, 1, 2, 4, 5, 5, 6]
print("4th largest: \(findKthLargest(nums2, 4))")
