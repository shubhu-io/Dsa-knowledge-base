/*
Problem: Kth Largest Element in an Array
Find the kth largest element in an unsorted array.

Approach:
- Use a min-heap of size k
- For each element, push it; if heap size > k, pop the smallest
- The heap root is the kth largest element

Time Complexity: O(n log k)
Space Complexity: O(k)

Example:
Input: nums = [3,2,1,5,6,4], k = 2
Output: 5
*/

package main

import (
	"container/heap"
	"fmt"
)

type IntHeap []int

func (h IntHeap) Len() int           { return len(h) }
func (h IntHeap) Less(i, j int) bool { return h[i] < h[j] }
func (h IntHeap) Swap(i, j int)      { h[i], h[j] = h[j], h[i] }

func (h *IntHeap) Push(x interface{}) {
	*h = append(*h, x.(int))
}

func (h *IntHeap) Pop() interface{} {
	old := *h
	n := len(old)
	x := old[n-1]
	*h = old[:n-1]
	return x
}

func findKthLargest(nums []int, k int) int {
	h := &IntHeap{}
	heap.Init(h)
	for _, num := range nums {
		heap.Push(h, num)
		if h.Len() > k {
			heap.Pop(h)
		}
	}
	return (*h)[0]
}

func main() {
	nums := []int{3, 2, 1, 5, 6, 4}
	k := 2
	result := findKthLargest(nums, k)
	fmt.Printf("Input: nums = %v, k = %d\nOutput: %d\n", nums, k, result)
}
