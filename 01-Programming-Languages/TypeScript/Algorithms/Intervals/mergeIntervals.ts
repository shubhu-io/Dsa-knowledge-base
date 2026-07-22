/*
Problem: Merge Intervals
Description: Given an array of intervals [start, end], merge all overlapping intervals.

Approach:
- Sort by start time, then iterate merging overlapping intervals

Time Complexity: O(n log n)
Space Complexity: O(n)

Example:
Input: [[1,3],[2,6],[8,10],[15,18]]
Output: [[1,6],[8,10],[15,18]]
*/

function mergeIntervals(intervals: number[][]): number[][] {
  if (intervals.length <= 1) return intervals;
  intervals.sort((a, b) => a[0] - b[0]);
  const merged: number[][] = [intervals[0]];
  for (let i = 1; i < intervals.length; i++) {
    const last = merged[merged.length - 1];
    if (intervals[i][0] <= last[1]) {
      last[1] = Math.max(last[1], intervals[i][1]);
    } else {
      merged.push(intervals[i]);
    }
  }
  return merged;
}

const intervals = [[1,3],[2,6],[8,10],[15,18]];
console.log('Input:', intervals);
console.log('Output:', mergeIntervals(intervals));
