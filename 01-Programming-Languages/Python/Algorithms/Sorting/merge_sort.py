"""
Problem: Merge Sort
Given an array of integers, sort the array in ascending order using the merge sort algorithm.
Merge sort is a divide-and-conquer algorithm that divides the array into two halves,
recursively sorts them, and then merges the two sorted halves.

Approach:
- Divide the array into two halves
- Recursively sort each half
- Merge the two sorted halves into a single sorted array
- The merge process compares elements from each half and combines them in sorted order

Time Complexity: O(n log n) - divides array log n times, each level does O(n) work
Space Complexity: O(n) - temporary array needed for merging

Example:
Input: [38, 27, 43, 3, 9, 82, 10]
Output: [3, 9, 10, 27, 38, 43, 82]
"""

from typing import List

def merge(arr: List[int], left: int, mid: int, right: int) -> None:
    """
    Merges two sorted subarrays into a single sorted array

    Args:
        arr: Array containing the subarrays to merge
        left: Starting index of the left subarray
        mid: Ending index of the left subarray (mid+1 is start of right subarray)
        right: Ending index of the right subarray
    """
    # Calculate sizes of the two subarrays
    n1 = mid - left + 1
    n2 = right - mid

    # Create temporary arrays
    left_arr = [0] * n1
    right_arr = [0] * n2

    # Copy data to temporary arrays
    for i in range(n1):
        left_arr[i] = arr[left + i]
    for j in range(n2):
        right_arr[j] = arr[mid + 1 + j]

    # Merge the temporary arrays back into arr[left..right]
    i = 0   # Index for left_arr
    j = 0   # Index for right_arr
    k = left  # Index for arr

    while i < n1 and j < n2:
        if left_arr[i] <= right_arr[j]:
            arr[k] = left_arr[i]
            i += 1
        else:
            arr[k] = right_arr[j]
            j += 1
        k += 1

    # Copy remaining elements of left_arr, if any
    while i < n1:
        arr[k] = left_arr[i]
        i += 1
        k += 1

    # Copy remaining elements of right_arr, if any
    while j < n2:
        arr[k] = right_arr[j]
        j += 1
        k += 1

def merge_sort(arr: List[int], left: int, right: int) -> None:
    """
    Main merge sort function that recursively sorts the array

    Args:
        arr: Array to be sorted
        left: Starting index
        right: Ending index
    """
    if left < right:
        # Find the middle point
        mid = left + (right - left) // 2

        # Sort first and second halves
        merge_sort(arr, left, mid)
        merge_sort(arr, mid + 1, right)

        # Merge the sorted halves
        merge(arr, left, mid, right)

# Helper function to print an array
def print_array(arr: List[int]) -> None:
    """Prints the array in a readable format"""
    print(f"[{', '.join(map(str, arr))}]")

# Example usage
if __name__ == "__main__":
    # Example input
    arr = [38, 27, 43, 3, 9, 82, 10]

    print("Original array:")
    print_array(arr)

    # Sort the array using merge sort
    merge_sort(arr, 0, len(arr) - 1)

    print("Sorted array:")
    print_array(arr)

    # Additional test cases
    print("\nTest 1:")
    test1 = [5, 2, 4, 6, 1, 3]
    print("Original:")
    print_array(test1)
    merge_sort(test1, 0, len(test1) - 1)
    print("Sorted:")
    print_array(test1)

    print("\nTest 2 (single element):")
    test2 = [1]
    print("Original:")
    print_array(test2)
    merge_sort(test2, 0, len(test2) - 1)
    print("Sorted:")
    print_array(test2)

    print("\nTest 3 (empty array):")
    test3 = []
    print("Original:")
    print_array(test3)
    merge_sort(test3, 0, len(test3) - 1)  # Safe to call with empty array
    print("Sorted:")
    print_array(test3)