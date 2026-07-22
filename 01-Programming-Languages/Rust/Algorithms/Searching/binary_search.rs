/*
Problem: Binary Search
Find the index of a target value in a sorted array using binary search.

Approach:
- Compare target with middle element
- If equal, return middle index
- If target < middle, search left half
- If target > middle, search right half
- Repeat until found or subarray is empty

Time Complexity: O(log n)
Space Complexity: O(1)

Example:
Input: arr = [1, 3, 5, 7, 9, 11, 13], target = 7
Output: 3
*/

fn binary_search(arr: &[i32], target: i32) -> Option<usize> {
    let mut left = 0;
    let mut right = arr.len() as i32 - 1;
    while left <= right {
        let mid = left + (right - left) / 2;
        if arr[mid as usize] == target {
            return Some(mid as usize);
        } else if arr[mid as usize] < target {
            left = mid + 1;
        } else {
            right = mid - 1;
        }
    }
    None
}

fn main() {
    let arr = vec![1, 3, 5, 7, 9, 11, 13];
    let target = 7;
    match binary_search(&arr, target) {
        Some(i) => println!("Input: arr = {:?}, target = {}\nOutput: {}", arr, target, i),
        None => println!("Not found"),
    }
}
