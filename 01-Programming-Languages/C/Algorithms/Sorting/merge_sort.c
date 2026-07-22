/**
 * Problem: Merge Sort
 * Given an array of integers, sort the array in ascending order using the merge sort algorithm.
 * Merge sort is a divide-and-conquer algorithm that divides the array into two halves,
 * recursively sorts them, and then merges the two sorted halves.
 *
 * Approach:
 * - Divide the array into two halves
 * - Recursively sort each half
 * - Merge the two sorted halves into a single sorted array
 * - The merge process compares elements from each half and combines them in sorted order
 *
 * Time Complexity: O(n log n) - divides array log n times, each level does O(n) work
 * Space Complexity: O(n) - temporary array needed for merging
 *
 * Example:
 * Input: [38, 27, 43, 3, 9, 82, 10]
 * Output: [3, 9, 10, 27, 38, 43, 82]
 */

#include <stdio.h>
#include <stdlib.h>

/**
 * Merges two sorted subarrays into a single sorted array
 *
 * @param arr Array containing the subarrays to merge
 * @param left Starting index of the left subarray
 * @param mid Ending index of the left subarray (mid+1 is start of right subarray)
 * @param right Ending index of the right subarray
 */
void merge(int arr[], int left, int mid, int right) {
    // Calculate sizes of the two subarrays
    int n1 = mid - left + 1;
    int n2 = right - mid;

    // Create temporary arrays
    int* leftArr = (int*)malloc(n1 * sizeof(int));
    int* rightArr = (int*)malloc(n2 * sizeof(int));

    // Check if memory allocation failed
    if (leftArr == NULL || rightArr == NULL) {
        free(leftArr);
        free(rightArr);
        return;
    }

    // Copy data to temporary arrays
    for (int i = 0; i < n1; i++) {
        leftArr[i] = arr[left + i];
    }
    for (int j = 0; j < n2; j++) {
        rightArr[j] = arr[mid + 1 + j];
    }

    // Merge the temporary arrays back into arr[left..right]
    int i = 0;   // Index for leftArr
    int j = 0;   // Index for rightArr
    int k = left; // Index for arr

    while (i < n1 && j < n2) {
        if (leftArr[i] <= rightArr[j]) {
            arr[k] = leftArr[i];
            i++;
        } else {
            arr[k] = rightArr[j];
            j++;
        }
        k++;
    }

    // Copy remaining elements of leftArr, if any
    while (i < n1) {
        arr[k] = leftArr[i];
        i++;
        k++;
    }

    // Copy remaining elements of rightArr, if any
    while (j < n2) {
        arr[k] = rightArr[j];
        j++;
        k++;
    }

    // Free allocated memory
    free(leftArr);
    free(rightArr);
}

/**
 * Main merge sort function that recursively sorts the array
 *
 * @param arr Array to be sorted
 * @param left Starting index
 * @param right Ending index
 */
void mergeSort(int arr[], int left, int right) {
    if (left < right) {
        // Find the middle point
        int mid = left + (right - left) / 2;

        // Sort first and second halves
        mergeSort(arr, left, mid);
        mergeSort(arr, mid + 1, right);

        // Merge the sorted halves
        merge(arr, left, mid, right);
    }
}

// Helper function to print an array
void printArray(int* arr, int size) {
    printf("[");
    for (int i = 0; i < size; i++) {
        printf("%d", arr[i]);
        if (i < size - 1) {
            printf(", ");
        }
    }
    printf("]\n");
}

// Example usage
int main() {
    // Example input
    int arr[] = {38, 27, 43, 3, 9, 82, 10};
    int arrSize = sizeof(arr) / sizeof(arr[0]);

    printf("Original array: ");
    printArray(arr, arrSize);

    // Sort the array using merge sort
    mergeSort(arr, 0, arrSize - 1);

    printf("Sorted array:   ");
    printArray(arr, arrSize);

    // Additional test cases
    printf("\nTest 1:\n");
    int test1[] = {5, 2, 4, 6, 1, 3};
    int test1Size = sizeof(test1) / sizeof(test1[0]);
    printf("Original: ");
    printArray(test1, test1Size);
    mergeSort(test1, 0, test1Size - 1);
    printf("Sorted:   ");
    printArray(test1, test1Size);

    printf("\nTest 2 (single element):\n");
    int test2[] = {1};
    int test2Size = sizeof(test2) / sizeof(test2[0]);
    printf("Original: ");
    printArray(test2, test2Size);
    mergeSort(test2, 0, test2Size - 1);
    printf("Sorted:   ");
    printArray(test2, test2Size);

    printf("\nTest 3 (empty array):\n");
    int test3[] = {};
    int test3Size = sizeof(test3) / sizeof(test3[0]);
    printf("Original: ");
    printArray(test3, test3Size);
    mergeSort(test3, 0, (test3Size > 0) ? test3Size - 1 : 0); // Handle empty array safely
    printf("Sorted:   ");
    printArray(test3, test3Size);

    return 0;
}