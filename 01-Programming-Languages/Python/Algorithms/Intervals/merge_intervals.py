"""
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
"""

from typing import List

class Solution:
    def merge(self, intervals: List[List[int]]) -> List[List[int]]:
        """
        Merges overlapping intervals.

        Args:
            intervals: List of intervals where each interval is [start, end]

        Returns:
            List of merged intervals
        """
        if not intervals:
            return []

        # Sort intervals by start time
        intervals.sort(key=lambda x: x[0])

        merged = []
        current_start = intervals[0][0]
        current_end = intervals[0][1]

        # Iterate through sorted intervals
        for i in range(1, len(intervals)):
            start = intervals[i][0]
            end = intervals[i][1]

            # If current interval overlaps with the next one
            if start <= current_end:
                # Merge by extending the end if needed
                if end > current_end:
                    current_end = end
            else:
                # No overlap, add the current interval to result
                merged.append([current_start, current_end])

                # Start a new current interval
                current_start = start
                current_end = end

        # Add the last interval
        merged.append([current_start, current_end])
        return merged


# Helper function to print intervals
def print_intervals(intervals):
    """Prints intervals in a readable format."""
    formatted = ", ".join([f"[{start},{end}]" for start, end in intervals])
    print(f"[{formatted}]")


# Example usage
if __name__ == "__main__":
    solution = Solution()

    # Example input: [[1,3],[2,6],[8,10],[15,18]]
    intervals = [[1, 3], [2, 6], [8, 10], [15, 18]]

    print("Input intervals:")
    print_intervals(intervals)

    result = solution.merge(intervals)

    print("Merged intervals:")
    print_intervals(result)