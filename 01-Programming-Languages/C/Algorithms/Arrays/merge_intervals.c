/**
 * Problem: Merge Intervals
 * Given an array of intervals where intervals[i] = [start_i, end_i],
 * merge all overlapping intervals, and return an array of the
 * non-overlapping intervals that cover all the intervals in the input.
 *
 * Approach:
 * - Sort intervals by start time.
 * - Iterate through sorted intervals, maintaining a current interval [cur_start, cur_end].
 * - For each interval:
 *    * If its start <= cur_end, there is overlap; update cur_end = max(cur_end, interval.end).
 *    * Else, push current interval to result and start a new current interval.
 * - After loop, push the last interval.
 * Time Complexity: O(n log n) due to sorting.
 * Space Complexity: O(1) extra (excluding output).
 *
 * Example:
 * Input: [[1,3],[2,6],[8,10],[15,18]]
 * Output: [[1,6],[8,10],[15,18]]
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/**
 * Comparator function for qsort to sort intervals by start time.
 */
int compareIntervals(const void* a, const void* b) {
    int* intervalA = *(int**)a;
    int* intervalB = *(int**)b;
    return intervalA[0] - intervalB[0];
}

/**
 * Merges overlapping intervals.
 *
 * @param intervals Array of intervals (each interval is an array of 2 ints: [start, end])
 * @param intervalsSize Number of intervals
 * @param intervalsColSize Array containing the size of each interval (should be 2 for each)
 * @param returnSize Pointer to store the size of the returned array
 * @param returnColSizes Pointer to store the column sizes of the returned array
 * @return Array of merged intervals
 */
int** merge(int** intervals, int intervalsSize, int* intervalsColSize, int* returnSize, int** returnColSizes) {
    // Handle edge case
    if (intervalsSize == 0) {
        *returnSize = 0;
        return NULL;
    }

    // Sort intervals by start time
    qsort(intervals, intervalsSize, sizeof(int*), compareIntervals);

    // Allocate memory for the result (worst case: no overlaps)
    int** result = (int**)malloc(intervalsSize * sizeof(int*));
    *returnColSizes = (int*)malloc(intervalsSize * sizeof(int));

    int resultIndex = 0;
    int currentStart = intervals[0][0];
    int currentEnd = intervals[0][1];

    // Iterate through sorted intervals
    for (int i = 1; i < intervalsSize; i++) {
        int start = intervals[i][0];
        int end = intervals[i][1];

        // If current interval overlaps with the next one
        if (start <= currentEnd) {
            // Merge by extending the end if needed
            if (end > currentEnd) {
                currentEnd = end;
            }
        } else {
            // No overlap, add the current interval to result
            result[resultIndex] = (int*)malloc(2 * sizeof(int));
            result[resultIndex][0] = currentStart;
            result[resultIndex][1] = currentEnd;
            (*returnColSizes)[resultIndex] = 2;
            resultIndex++;

            // Start a new current interval
            currentStart = start;
            currentEnd = end;
        }
    }

    // Add the last interval
    result[resultIndex] = (int*)malloc(2 * sizeof(int));
    result[resultIndex][0] = currentStart;
    result[resultIndex][1] = currentEnd;
    (*returnColSizes)[resultIndex] = 2;
    resultIndex++;

    *returnSize = resultIndex;

    // Resize result array to actual size (optional but clean)
    int** finalResult = (int**)realloc(result, resultIndex * sizeof(int*));
    *returnColSizes = (int*)realloc(*returnColSizes, resultIndex * sizeof(int));

    return finalResult;
}

// Helper function to print intervals
void printIntervals(int** intervals, int size, int* colSizes) {
    printf("[");
    for (int i = 0; i < size; i++) {
        printf("[%d,%d]", intervals[i][0], intervals[i][1]);
        if (i < size - 1) {
            printf(",");
        }
    }
    printf("]\n");
}

// Helper function to free memory allocated for intervals
void freeIntervals(int** intervals, int size) {
    for (int i = 0; i < size; i++) {
        free(intervals[i]);
    }
    free(intervals);
}

// Example usage
int main() {
    // Example input: [[1,3],[2,6],[8,10],[15,18]]
    int intervalsData[4][2] = {{1, 3}, {2, 6}, {8, 10}, {15, 18}};
    int intervalsSize = 4;

    // Create array of pointers to intervals
    int* intervals[4];
    for (int i = 0; i < 4; i++) {
        intervals[i] = intervalsData[i];
    }

    int intervalsColSize[4] = {2, 2, 2, 2}; // Each interval has 2 elements
    int returnSize;
    int* returnColSizes;

    printf("Input intervals: ");
    printIntervals(intervals, intervalsSize, intervalsColSize);

    int** result = merge(intervals, intervalsSize, intervalsColSize, &returnSize, &returnColSizes);

    printf("Merged intervals: ");
    printIntervals(result, returnSize, returnColSizes);

    // Free memory
    freeIntervals(result, returnSize);
    free(returnColSizes);

    return 0;
}