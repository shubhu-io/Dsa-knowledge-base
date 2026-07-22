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

#include <iostream>
#include <vector>
#include <algorithm>

std::vector<std::vector<int>> merge(std::vector<std::vector<int>>& intervals) {
    if (intervals.empty()) return {};

    // Sort by start time
    std::sort(intervals.begin(), intervals.end(),
              [](const std::vector<int>& a, const std::vector<int>& b) {
                  return a[0] < b[0];
              });

    std::vector<std::vector<int>> merged;
    int cur_start = intervals[0][0];
    int cur_end   = intervals[0][1];

    for (size_t i = 1; i < intervals.size(); ++i) {
        int start = intervals[i][0];
        int end   = intervals[i][1];
        if (start <= cur_end) { // Overlapping
            if (end > cur_end) cur_end = end;
        } else {
            merged.push_back({cur_start, cur_end});
            cur_start = start;
            cur_end   = end;
        }
    }
    merged.push_back({cur_start, cur_end});
    return merged;
}

int main() {
    std::vector<std::vector<int>> intervals = {{1,3},{2,6},{8,10},{15,18}};
    auto result = merge(intervals);
    std::cout << "Merged intervals:\n";
    for (const auto& iv : result) {
        std::cout << "[" << iv[0] << "," << iv[1] << "] ";
    }
    std::cout << "\n";
    return 0;
}