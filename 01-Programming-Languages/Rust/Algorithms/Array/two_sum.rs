/*
Problem: Two Sum
Find two numbers in an array that add up to a target sum and return their indices.

Approach:
- Use a hash map to store each number's index
- For each element, check if target - element exists in the map
- If found, return both indices

Time Complexity: O(n)
Space Complexity: O(n)

Example:
Input: nums = [2, 7, 11, 15], target = 9
Output: [0, 1]
*/

use std::collections::HashMap;

fn two_sum(nums: &[i32], target: i32) -> Option<Vec<usize>> {
    let mut seen = HashMap::new();
    for (i, &num) in nums.iter().enumerate() {
        let complement = target - num;
        if let Some(&j) = seen.get(&complement) {
            return Some(vec![j, i]);
        }
        seen.insert(num, i);
    }
    None
}

fn main() {
    let nums = vec![2, 7, 11, 15];
    let target = 9;
    if let Some(result) = two_sum(&nums, target) {
        println!("Input: nums = {:?}, target = {}\nOutput: {:?}", nums, target, result);
    }
}
