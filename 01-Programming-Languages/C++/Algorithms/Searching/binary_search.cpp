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

#include <iostream>
#include <vector>
using namespace std;

int binary_search(const vector<int>& arr, int target)
{
    int left = 0, right = arr.size() - 1;
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
    vector<int> arr = {1, 3, 5, 7, 9, 11, 13};
    int target = 7;
    int result = binary_search(arr, target);
    cout << "Index of " << target << ": " << result << endl;
    return 0;
}
