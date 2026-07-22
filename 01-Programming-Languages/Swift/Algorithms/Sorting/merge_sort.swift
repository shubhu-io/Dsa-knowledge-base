/*
Problem: Merge Sort
Description: Sort an array of integers using the merge sort algorithm.
           Divide and conquer approach - split array, sort halves, merge.

Approach:
- Recursively divide array into two halves
- Sort each half recursively
- Merge the two sorted halves using two-pointer technique

Time Complexity: O(n log n)
Space Complexity: O(n) for auxiliary arrays during merge

Example:
Input: [38, 27, 43, 3, 9, 82, 10]
Output: [3, 9, 10, 27, 38, 43, 82]
*/

func mergeSort(_ arr: inout [Int], _ left: Int, _ right: Int) {
    guard left < right else { return }
    let mid = left + (right - left) / 2
    mergeSort(&arr, left, mid)
    mergeSort(&arr, mid + 1, right)
    merge(&arr, left, mid, right)
}

func merge(_ arr: inout [Int], _ left: Int, _ mid: Int, _ right: Int) {
    let leftArr = Array(arr[left...mid])
    let rightArr = Array(arr[mid + 1...right])
    var i = 0, j = 0, k = left
    while i < leftArr.count && j < rightArr.count {
        if leftArr[i] <= rightArr[j] {
            arr[k] = leftArr[i]
            i += 1
        } else {
            arr[k] = rightArr[j]
            j += 1
        }
        k += 1
    }
    while i < leftArr.count { arr[k] = leftArr[i]; i += 1; k += 1 }
    while j < rightArr.count { arr[k] = rightArr[j]; j += 1; k += 1 }
}

var numbers = [38, 27, 43, 3, 9, 82, 10]
mergeSort(&numbers, 0, numbers.count - 1)
print("Merge Sort: \(numbers)")
