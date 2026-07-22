/*
Problem: Kth Largest Element (Min-Heap)
Find the kth largest element in an array using a min-heap of size k.

Approach:
- Maintain min-heap of size k, insert elements, keep smallest of top k

Time Complexity: O(n log k)
Space Complexity: O(k)

Example:
Input: [3, 2, 1, 5, 6, 4], k = 2
Output: 5
*/

#include <stdio.h>
#include <stdlib.h>

typedef struct
{
    int *data;
    int size;
    int cap;
} MinHeap;

MinHeap *create_heap(int cap)
{
    MinHeap *h = (MinHeap *)malloc(sizeof(MinHeap));
    h->data = (int *)malloc(cap * sizeof(int));
    h->size = 0;
    h->cap = cap;
    return h;
}

void swap(int *a, int *b) { int t = *a; *a = *b; *b = t; }

void heapify(MinHeap *h, int i)
{
    int smallest = i, left = 2 * i + 1, right = 2 * i + 2;
    if (left < h->size && h->data[left] < h->data[smallest]) smallest = left;
    if (right < h->size && h->data[right] < h->data[smallest]) smallest = right;
    if (smallest != i) { swap(&h->data[i], &h->data[smallest]); heapify(h, smallest); }
}

void push(MinHeap *h, int val)
{
    if (h->size < h->cap) { h->data[h->size++] = val; }
    else if (val > h->data[0]) { h->data[0] = val; }
    for (int i = h->size / 2 - 1; i >= 0; i--) heapify(h, i);
    if (h->size == h->cap) heapify(h, 0);
}

int peek(MinHeap *h) { return h->data[0]; }

int find_kth_largest(int arr[], int n, int k)
{
    MinHeap *h = create_heap(k);
    for (int i = 0; i < n; i++) push(h, arr[i]);
    int res = peek(h);
    free(h->data);
    free(h);
    return res;
}

int main()
{
    int arr[] = {3, 2, 1, 5, 6, 4};
    int n = sizeof(arr) / sizeof(arr[0]);
    int k = 2;
    printf("Kth largest (k=%d): %d\n", k, find_kth_largest(arr, n, k));
    return 0;
}
