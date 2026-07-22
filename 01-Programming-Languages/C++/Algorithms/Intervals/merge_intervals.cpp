/*
Problem: Merge Intervals
Given an array of intervals [start, end], merge all overlapping intervals.

Approach:
- Sort by start, then merge overlapping intervals

Time Complexity: O(n log n)
Space Complexity: O(n)

Example:
Input: [[1,3],[2,6],[8,10],[15,18]]
Output: [[1,6],[8,10],[15,18]]
*/

#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

vector<pair<int, int>> merge_intervals(vector<pair<int, int>> intervals)
{
    if (intervals.empty()) return {};
    sort(intervals.begin(), intervals.end());
    vector<pair<int, int>> res;
    res.push_back(intervals[0]);
    for (size_t i = 1; i < intervals.size(); i++)
    {
        if (intervals[i].first <= res.back().second)
            res.back().second = max(res.back().second, intervals[i].second);
        else
            res.push_back(intervals[i]);
    }
    return res;
}

int main()
{
    vector<pair<int, int>> intervals = {{1, 3}, {2, 6}, {8, 10}, {15, 18}};
    auto merged = merge_intervals(intervals);
    cout << "Merged intervals: ";
    for (auto [s, e] : merged)
        cout << "[" << s << "," << e << "] ";
    cout << endl;
    return 0;
}
