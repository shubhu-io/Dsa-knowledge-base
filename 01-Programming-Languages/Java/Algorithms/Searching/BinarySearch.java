/*
 * Problem: Find the index of a target value in a sorted array.
 * Approach: Binary search — repeatedly divide the search space in half.
 * Time Complexity: O(log n)
 * Space Complexity: O(1)
 * Example: Input: arr = [1, 3, 5, 7, 9], target = 5 -> Output: 2
 */

public class BinarySearch {
    public static int binarySearch(int[] arr, int target) {
        int left = 0, right = arr.length - 1;
        while (left <= right) {
            int mid = left + (right - left) / 2;
            if (arr[mid] == target) return mid;
            if (arr[mid] < target) left = mid + 1;
            else right = mid - 1;
        }
        return -1;
    }

    public static void main(String[] args) {
        int[] arr = {1, 3, 5, 7, 9};
        int target = 5;
        System.out.println(binarySearch(arr, target));
    }
}
