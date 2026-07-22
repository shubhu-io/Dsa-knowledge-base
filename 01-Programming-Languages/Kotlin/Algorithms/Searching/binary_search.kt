/*
 * Problem: Find the index of a target value in a sorted array.
 * Approach: Binary search — repeatedly divide the search space in half.
 * Time Complexity: O(log n)
 * Space Complexity: O(1)
 * Example: Input: arr = [1, 3, 5, 7, 9], target = 5 -> Output: 2
 */

fun binarySearch(arr: IntArray, target: Int): Int {
    var left = 0; var right = arr.size - 1
    while (left <= right) {
        val mid = left + (right - left) / 2
        when {
            arr[mid] == target -> return mid
            arr[mid] < target -> left = mid + 1
            else -> right = mid - 1
        }
    }
    return -1
}

fun main() {
    val arr = intArrayOf(1, 3, 5, 7, 9)
    println(binarySearch(arr, 5))
}
