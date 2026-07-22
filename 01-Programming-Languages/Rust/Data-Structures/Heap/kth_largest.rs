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

use std::collections::BinaryHeap;
use std::cmp::Reverse;

fn find_kth_largest(nums: &[i32], k: usize) -> i32 {
    let mut heap = BinaryHeap::with_capacity(k);
    for &num in nums {
        heap.push(Reverse(num));
        if heap.len() > k {
            heap.pop();
        }
    }
    heap.peek().unwrap().0
}

fn main() {
    let nums = vec![3, 2, 1, 5, 6, 4];
    let k = 2;
    println!("Input: nums = {:?}, k = {}\nOutput: {}", nums, k, find_kth_largest(&nums, k));
}
