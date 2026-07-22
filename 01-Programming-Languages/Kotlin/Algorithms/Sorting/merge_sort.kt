/*
 * Problem: Sort an array of integers using Merge Sort.
 * Approach: Divide and conquer — recursively split array into halves, sort, then merge.
 * Time Complexity: O(n log n)
 * Space Complexity: O(n) auxiliary
 * Example: Input: [38, 27, 43, 3, 9, 82, 10] -> Output: [3, 9, 10, 27, 38, 43, 82]
 */

fun mergeSort(arr: IntArray, left: Int, right: Int) {
    if (left < right) {
        val mid = left + (right - left) / 2
        mergeSort(arr, left, mid)
        mergeSort(arr, mid + 1, right)
        merge(arr, left, mid, right)
    }
}

private fun merge(arr: IntArray, left: Int, mid: Int, right: Int) {
    val n1 = mid - left + 1
    val n2 = right - mid
    val L = arr.copyOfRange(left, left + n1)
    val R = arr.copyOfRange(mid + 1, mid + 1 + n2)
    var i = 0; var j = 0; var k = left
    while (i < n1 && j < n2) {
        arr[k++] = if (L[i] <= R[j]) L[i++] else R[j++]
    }
    while (i < n1) arr[k++] = L[i++]
    while (j < n2) arr[k++] = R[j++]
}

fun main() {
    val arr = intArrayOf(38, 27, 43, 3, 9, 82, 10)
    mergeSort(arr, 0, arr.size - 1)
    println(arr.joinToString(" "))
}
