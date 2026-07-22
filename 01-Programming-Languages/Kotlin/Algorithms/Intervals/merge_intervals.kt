/*
 * Problem: Merge overlapping intervals.
 * Approach: Sort by start time, then merge overlapping intervals.
 * Time Complexity: O(n log n)
 * Space Complexity: O(n)
 * Example: Input: [[1,3],[2,6],[8,10],[15,18]] -> Output: [[1,6],[8,10],[15,18]]
 */

fun merge(intervals: Array<IntArray>): Array<IntArray> {
    if (intervals.isEmpty()) return emptyArray()
    intervals.sortBy { it[0] }
    val merged = mutableListOf<IntArray>()
    var current = intervals[0]
    for (i in 1 until intervals.size) {
        if (intervals[i][0] <= current[1]) {
            current[1] = maxOf(current[1], intervals[i][1])
        } else {
            merged.add(current)
            current = intervals[i]
        }
    }
    merged.add(current)
    return merged.toTypedArray()
}

fun main() {
    val intervals = arrayOf(intArrayOf(1, 3), intArrayOf(2, 6), intArrayOf(8, 10), intArrayOf(15, 18))
    val result = merge(intervals)
    for (interval in result) {
        println(interval.joinToString(" "))
    }
}
