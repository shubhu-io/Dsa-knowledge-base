=begin
Problem: Merge Intervals
Description: Merge all overlapping intervals in a collection.

Approach:
- Sort intervals by start value
- Iterate and merge overlapping intervals

Time Complexity: O(n log n)
Space Complexity: O(n)

Example:
Input:  [[1,3],[2,6],[8,10],[15,18]]
Output: [[1,6],[8,10],[15,18]]
=end

def merge_intervals(intervals)
  return [] if intervals.empty?
  sorted = intervals.sort_by(&:first)
  merged = [sorted[0]]
  sorted[1..].each do |interval|
    if interval[0] <= merged[-1][1]
      merged[-1][1] = [merged[-1][1], interval[1]].max
    else
      merged << interval
    end
  end
  merged
end

intervals = [[1,3],[2,6],[8,10],[15,18]]
result = merge_intervals(intervals)
puts "Merged: #{result.inspect}"
