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

List<List<int>> mergeIntervals(List<List<int>> intervals) {
  if (intervals.length <= 1) return intervals;
  intervals.sort((a, b) => a[0].compareTo(b[0]));
  List<List<int>> merged = [];
  merged.add([intervals[0][0], intervals[0][1]]);
  for (int i = 1; i < intervals.length; i++) {
    if (intervals[i][0] <= merged.last[1]) {
      merged.last[1] = merged.last[1] > intervals[i][1] ? merged.last[1] : intervals[i][1];
    } else {
      merged.add([intervals[i][0], intervals[i][1]]);
    }
  }
  return merged;
}

void main() {
  List<List<int>> intervals = [
    [1, 3],
    [2, 6],
    [8, 10],
    [15, 18]
  ];
  print('Merged intervals: ${mergeIntervals(intervals)}');
}
