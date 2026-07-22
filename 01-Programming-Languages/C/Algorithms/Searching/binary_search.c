/*
Problem: Binary Search
Given a sorted array of integers, find the index of a target value using binary search.

Approach:
- Divide and conquer, compare target with middle element

Time Complexity: O(log n)
Space Complexity: O(1)

Example:
Input: arr = [1, 3, 5, 7, 9, 11, 13], target = 7
Output: 3
*/

#include <stdio.h>

int binary_search(int arr[], int n, int target)
{
    int left = 0, right = n - 1;
    while (left <= right)
    {
        int mid = left + (right - left) / 2;
        if (arr[mid] == target) return mid;
        if (arr[mid] < target) left = mid + 1;
        else right = mid - 1;
    }
    return -1;
}

int main()
{
    int arr[] = {1, 3, 5, 7, 9, 11, 13};
    int n = sizeof(arr) / sizeof(arr[0]);
    int target = 7;
    int result = binary_search(arr, n, target);
    printf("Index of %d: %d\n", target, result);
    return 0;
}
