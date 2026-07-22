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

#include <iostream>
#include <vector>

/**
 * Merges two sorted subarrays into a single sorted array
 *
 * @param arr Reference to the vector containing the subarrays to merge
 * @param left Starting index of the left subarray
 * @param mid Ending index of the left subarray (mid+1 is start of right subarray)
 * @param right Ending index of the right subarray
 */
void merge(std::vector<int>& arr, int left, int mid, int right) {
    // Calculate sizes of the two subarrays
    int n1 = mid - left + 1;
    int n2 = right - mid;

    // Create temporary vectors
    std::vector<int> leftArr(n1);
    std::vector<int> rightArr(n2);

    // Copy data to temporary vectors
    for (int i = 0; i < n1; i++) {
        leftArr[i] = arr[left + i];
    }
    for (int j = 0; j < n2; j++) {
        rightArr[j] = arr[mid + 1 + j];
    }

    // Merge the temporary vectors back into arr[left..right]
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
}

/**
 * Main merge sort function that recursively sorts the array
 *
 * @param arr Reference to the vector to be sorted
 * @param left Starting index
 * @param right Ending index
 */
void mergeSort(std::vector<int>& arr, int left, int right) {
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

// Helper function to print a vector
void printVector(const std::vector<int>& vec) {
    std::cout << "[";
    for (size_t i = 0; i < vec.size(); i++) {
        std::cout << vec[i];
        if (i < vec.size() - 1) {
            std::cout << ", ";
        }
    }
    std::cout << "]" << std::endl;
}

// Example usage
int main() {
    // Example input
    std::vector<int> arr = {38, 27, 43, 3, 9, 82, 10};

    std::cout << "Original array: ";
    printVector(arr);

    // Sort the array using merge sort
    mergeSort(arr, 0, arr.size() - 1);

    std::cout << "Sorted array:   ";
    printVector(arr);

    // Additional test cases
    std::vector<int> test1 = {5, 2, 4, 6, 1, 3};
    std::cout << "\nTest 1:\n";
    std::cout << "Original: ";
    printVector(test1);
    mergeSort(test1, 0, test1.size() - 1);
    std::cout << "Sorted:   ";
    printVector(test1);

    std::vector<int> test2 = {1};
    std::cout << "\nTest 2 (single element):\n";
    std::cout << "Original: ";
    printVector(test2);
    mergeSort(test2, 0, test2.size() - 1);
    std::cout << "Sorted:   ";
    printVector(test2);

    std::vector<int> test3 = {};
    std::cout << "\nTest 3 (empty array):\n";
    std::cout << "Original: ";
    printVector(test3);
    mergeSort(test3, 0, test3.size() - 1); // Safe to call with empty vector
    std::cout << "Sorted:   ";
    printVector(test3);

    return 0;
}