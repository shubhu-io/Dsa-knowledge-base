/*
Problem: Merge Intervals
Description: Merge all overlapping intervals in an array of intervals.

Approach:
- Sort intervals by start time
- Iterate and merge overlapping intervals
- If current interval overlaps with last merged, extend end
- Otherwise add new interval

Time Complexity: O(n log n) due to sorting
Space Complexity: O(n) for result

Example:
Input: [[1,3],[2,6],[8,10],[15,18]]
Output: [[1,6],[8,10],[15,18]]
*/

func mergeIntervals(_ intervals: [[Int]]) -> [[Int]] {
    guard intervals.count > 1 else { return intervals }
    let sorted = intervals.sorted { $0[0] < $1[0] }
    var merged = [[Int]]()
    merged.append(sorted[0])
    for i in 1..<sorted.count {
        let current = sorted[i]
        let last = merged.count - 1
        if current[0] <= merged[last][1] {
            merged[last][1] = max(merged[last][1], current[1])
        } else {
            merged.append(current)
        }
    }
    return merged
}

let intervals = [[1,3],[2,6],[8,10],[15,18]]
print("Merged intervals: \(mergeIntervals(intervals))")
