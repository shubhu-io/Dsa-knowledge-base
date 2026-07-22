/*
Problem: Merge Intervals
Merge all overlapping intervals in a list.

Approach:
- Sort intervals by start time
- Iterate through sorted intervals
- If current interval overlaps with last merged, merge them
- Otherwise, add as a new interval

Time Complexity: O(n log n)
Space Complexity: O(n)

Example:
Input: intervals = [[1,3],[2,6],[8,10],[15,18]]
Output: [[1,6],[8,10],[15,18]]
*/

fn merge(intervals: &[(i32, i32)]) -> Vec<(i32, i32)> {
    let mut intervals = intervals.to_vec();
    intervals.sort_by_key(|k| k.0);
    let mut result: Vec<(i32, i32)> = Vec::new();
    for interval in intervals {
        if let Some(last) = result.last_mut() {
            if interval.0 <= last.1 {
                if interval.1 > last.1 {
                    last.1 = interval.1;
                }
                continue;
            }
        }
        result.push(interval);
    }
    result
}

fn main() {
    let intervals = [(1, 3), (2, 6), (8, 10), (15, 18)];
    println!("Input: intervals = {:?}", intervals);
    println!("Output: {:?}", merge(&intervals));
}
