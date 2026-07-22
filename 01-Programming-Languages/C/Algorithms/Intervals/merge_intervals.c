/*
Problem: Merge Intervals
Given an array of intervals [start, end], merge all overlapping intervals.

Approach:
- Sort by start, then merge overlapping intervals

Time Complexity: O(n log n)
Space Complexity: O(n)

Example:
Input: [[1,3],[2,6],[8,10],[15,18]]
Output: [[1,6],[8,10],[15,18]]
*/

#include <stdio.h>
#include <stdlib.h>

typedef struct
{
    int start;
    int end;
} Interval;

int cmp(const void *a, const void *b)
{
    return ((Interval *)a)->start - ((Interval *)b)->start;
}

Interval *merge_intervals(Interval intervals[], int n, int *m)
{
    qsort(intervals, n, sizeof(Interval), cmp);
    Interval *res = (Interval *)malloc(n * sizeof(Interval));
    int k = 0;
    res[k++] = intervals[0];
    for (int i = 1; i < n; i++)
    {
        if (intervals[i].start <= res[k - 1].end)
        {
            if (intervals[i].end > res[k - 1].end)
                res[k - 1].end = intervals[i].end;
        }
        else
            res[k++] = intervals[i];
    }
    *m = k;
    return res;
}

int main()
{
    Interval intervals[] = {{1, 3}, {2, 6}, {8, 10}, {15, 18}};
    int n = sizeof(intervals) / sizeof(intervals[0]);
    int m;
    Interval *merged = merge_intervals(intervals, n, &m);
    printf("Merged intervals: ");
    for (int i = 0; i < m; i++)
        printf("[%d,%d] ", merged[i].start, merged[i].end);
    printf("\n");
    free(merged);
    return 0;
}
