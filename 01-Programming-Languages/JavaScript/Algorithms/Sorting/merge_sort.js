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

/**
 * Merges two sorted subarrays into a single sorted array
 *
 * @param {number[]} arr - Array containing the subarrays to merge
 * @param {number} left - Starting index of the left subarray
 * @param {number} mid - Ending index of the left subarray (mid+1 is start of right subarray)
 * @param {number} right - Ending index of the right subarray
 */
function merge(arr, left, mid, right) {
    // Calculate sizes of the two subarrays
    const n1 = mid - left + 1;
    const n2 = right - mid;

    // Create temporary arrays
    const leftArr = new Array(n1);
    const rightArr = new Array(n2);

    // Copy data to temporary arrays
    for (let i = 0; i < n1; i++) {
        leftArr[i] = arr[left + i];
    }
    for (let j = 0; j < n2; j++) {
        rightArr[j] = arr[mid + 1 + j];
    }

    // Merge the temporary arrays back into arr[left..right]
    let i = 0;   // Index for leftArr
    let j = 0;   // Index for rightArr
    let k = left; // Index for arr

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
 * @param {number[]} arr - Array to be sorted
 * @param {number} left - Starting index
 * @param {number} right - Ending index
 */
function mergeSort(arr, left, right) {
    if (left < right) {
        // Find the middle point
        const mid = Math.floor(left + (right - left) / 2);

        // Sort first and second halves
        mergeSort(arr, left, mid);
        mergeSort(arr, mid + 1, right);

        // Merge the sorted halves
        merge(arr, left, mid, right);
    }
}

// Helper function to print an array
function printArray(arr) {
    console.log(`[${arr.join(', ')}]`);
}

// Example usage
if (require.main === module) {
    // Example input
    const arr = [38, 27, 43, 3, 9, 82, 10];

    console.log("Original array:");
    printArray(arr);

    // Sort the array using merge sort
    mergeSort(arr, 0, arr.length - 1);

    console.log("Sorted array:");
    printArray(arr);

    // Additional test cases
    console.log("\nTest 1:");
    const test1 = [5, 2, 4, 6, 1, 3];
    console.log("Original:");
    printArray(test1);
    mergeSort(test1, 0, test1.length - 1);
    console.log("Sorted:");
    printArray(test1);

    console.log("\nTest 2 (single element):");
    const test2 = [1];
    console.log("Original:");
    printArray(test2);
    mergeSort(test2, 0, test2.length - 1);
    console.log("Sorted:");
    printArray(test2);

    console.log("\nTest 3 (empty array):");
    const test3 = [];
    console.log("Original:");
    printArray(test3);
    mergeSort(test3, 0, 0); // Safe to call with empty array
    console.log("Sorted:");
    printArray(test3);
}