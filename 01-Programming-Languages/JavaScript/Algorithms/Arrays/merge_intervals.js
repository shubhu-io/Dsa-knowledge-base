/*
Problem: Merge Intervals
Given an array of intervals where intervals[i] = [start_i, end_i],
merge all overlapping intervals, and return an array of the
non-overlapping intervals that cover all the intervals in the input.

Approach:
- Sort intervals by start time.
- Iterate through sorted intervals, maintaining a current interval [cur_start, cur_end].
- For each interval:
   * If its start <= cur_end, there is overlap; update cur_end = max(cur_end, interval.end).
   * Else, push current interval to result and start a new current interval.
- After loop, push the last interval.
Time Complexity: O(n log n) due to sorting.
Space Complexity: O(1) extra (excluding output).

Example:
Input: [[1,3],[2,6],[8,10],[15,18]]
Output: [[1,6],[8,10],[15,18]]
*/

/**
 * Merges overlapping intervals.
 * @param {number[][]} intervals - Array of intervals [start, end]
 * @return {number[][]} - Array of merged intervals
 */
function merge(intervals) {
    if (intervals.length === 0) return [];

    // Sort intervals by start time
    intervals.sort((a, b) => a[0] - b[0]);

    const merged = [];
    let currentStart = intervals[0][0];
    let currentEnd = intervals[0][1];

    // Iterate through sorted intervals
    for (let i = 1; i < intervals.length; i++) {
        const start = intervals[i][0];
        const end = intervals[i][1];

        // If current interval overlaps with the next one
        if (start <= currentEnd) {
            // Merge by extending the end if needed
            if (end > currentEnd) {
                currentEnd = end;
            }
        } else {
            // No overlap, add the current interval to result
            merged.push([currentStart, currentEnd]);

            // Start a new current interval
            currentStart = start;
            currentEnd = end;
        }
    }

    // Add the last interval
    merged.push([currentStart, currentEnd]);
    return merged;
}

// Helper function to print intervals
function printIntervals(intervals) {
    const str = intervals.map(interval => `[${interval[0]},${interval[1]}]`).join(',');
    console.log(`[${str}]`);
}

// Example usage
if (require.main === module) {
    // Example input: [[1,3],[2,6],[8,10],[15,18]]
    const intervals = [[1, 3], [2, 6], [8, 10], [15, 18]];

    console.log("Input intervals:");
    printIntervals(intervals);

    const result = merge(intervals);

    console.log("Merged intervals:");
    printIntervals(result);
}