/*
Problem: Binary Search
Description: Find the index of a target value in a sorted array.
           If not found, return -1.

Approach:
- Use two pointers (left, right) to narrow search range
- Compare middle element with target, discard half each iteration

Time Complexity: O(log n)
Space Complexity: O(1)

Example:
Input: nums = [-1, 0, 3, 5, 9, 12], target = 9
Output: 4
*/

int binarySearch(List<int> arr, int target) {
  int left = 0, right = arr.length - 1;
  while (left <= right) {
    int mid = left + (right - left) ~/ 2;
    if (arr[mid] == target) return mid;
    if (arr[mid] < target) {
      left = mid + 1;
    } else {
      right = mid - 1;
    }
  }
  return -1;
}

void main() {
  List<int> nums = [-1, 0, 3, 5, 9, 12];
  print('Binary Search index of 9: ${binarySearch(nums, 9)}');
  print('Binary Search index of 2: ${binarySearch(nums, 2)}');
}
