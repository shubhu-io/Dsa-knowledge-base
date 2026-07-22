# Sorting Algorithms Overview

## Introduction
Sorting is the process of arranging elements in a specific order (typically ascending or descending). Efficient sorting is crucial for optimizing the performance of other algorithms that require sorted data.

## Classification of Sorting Algorithms

### By Time Complexity
- **O(n²)**: Simple sorts (Bubble, Selection, Insertion)
- **O(n log n)**: Efficient sorts (Merge, Heap, Quick, Timsort)
- **O(n)**: Non-comparison sorts (Counting, Radix, Bucket) - under specific conditions

### By Space Complexity
- **In-place**: O(1) extra space (Heap, Quick, Insertion, Selection)
- **Not In-place**: O(n) or more extra space (Merge, Radix)

### By Stability
- **Stable**: Maintains relative order of equal elements (Merge, Insertion, Bubble)
- **Unstable**: May change relative order of equal elements (Quick, Heap, Selection)

### By Method
- **Comparison-based**: Compare elements to determine order
- **Non-comparison-based**: Use properties of data (counting, radix, bucket)

## Common Sorting Algorithms

### 1. Bubble Sort
- **Time**: O(n²) worst/average, O(n) best (optimized)
- **Space**: O(1)
- **Stable**: Yes
- **Method**: Repeatedly swap adjacent elements if in wrong order

### 2. Selection Sort
- **Time**: O(n²) all cases
- **Space**: O(1)
- **Stable**: No
- **Method**: Select minimum element and swap with first unsorted element

### 3. Insertion Sort
- **Time**: O(n²) worst/average, O(n) best
- **Space**: O(1)
- **Stable**: Yes
- **Method**: Build sorted array one element at a time by inserting

### 4. Merge Sort
- **Time**: O(n log n) all cases
- **Space**: O(n)
- **Stable**: Yes
- **Method**: Divide array into halves, sort each, then merge

### 5. Quick Sort
- **Time**: O(n log n) average, O(n²) worst
- **Space**: O(log n) average (recursion stack)
- **Stable**: No
- **Method**: Partition array around pivot, recursively sort partitions

### 6. Heap Sort
- **Time**: O(n log n) all cases
- **Space**: O(1)
- **Stable**: No
- **Method**: Build max heap, repeatedly extract maximum

### 7. Counting Sort
- **Time**: O(n + k) where k is range of input
- **Space**: O(k)
- **Stable**: Yes
- **Method**: Count occurrences of each value, then reconstruct

### 8. Radix Sort
- **Time**: O(d(n + k)) where d is number of digits
- **Space**: O(n + k)
- **Stable**: Yes
- **Method**: Sort by individual digits/positions

### 9. Bucket Sort
- **Time**: O(n + k) average, O(n²) worst
- **Space**: O(n)
- **Stable**: Yes
- **Method**: Distribute elements into buckets, sort each bucket

## Choosing a Sorting Algorithm

### For Small Arrays (< 50 elements)
- Insertion Sort (simple, efficient for small data)
- Selection Sort (if memory writes are costly)

### For General Purpose
- Merge Sort (stable, guaranteed O(n log n))
- Quick Sort (fast average case, in-place)
- Timsort (hybrid, used in Python/Java)

### For Specific Data Types
- Counting Sort: Integer data with limited range
- Radix Sort: Integer or string data
- Bucket Sort: Uniformly distributed floating-point numbers

## Stability in Sorting
Stable sorts maintain the relative order of records with equal keys. This is important when:
- Sorting by multiple criteria (sort by secondary key, then primary)
- Sorting objects where only part of the object is the key
- Preserving original order for equal elements

## In-place vs Not In-place
In-place algorithms are preferred when:
- Memory is limited
- Minimizing memory writes is important (for flash memory)
- Cache performance is critical

Not in-place algorithms may be faster due to better cache locality or simpler implementation.

## Adaptive Sorts
Some algorithms perform better when the input is partially sorted:
- Insertion Sort: O(n) for nearly sorted data
- Bubble Sort: O(n) for nearly sorted data (with optimization)
- Timsort: Specifically designed to take advantage of existing order

## Online vs Offline
- **Online**: Can sort as data arrives (Insertion Sort)
- **Offline**: Requires all data before starting (most other sorts)

## External Sorting
For datasets too large to fit in memory:
- External Merge Sort
- Polyphase Merge
- Replacement Selection

## Parallel Sorting
Algorithms designed for multi-core processors:
- Parallel Merge Sort
- Sample Sort
- Bitonic Sort (for sorting networks)

## Sorting in Practice
Most standard libraries use hybrid approaches:
- **Python**: Timsort (merge + insertion)
- **Java**: Dual-pivot Quicksort for primitives, Timsort for objects
- **C++**: Introsort (quick + heap + insertion)
- **C#**: Introsort
- **JavaScript**: Varies by engine (often Timsort or Quicksort)

## When Not to Sort
Sometimes it's better to avoid sorting:
- Use hash tables for O(1) lookups instead of sorting + binary search
- Use counting or radix sort for integer ranges
- Use selection algorithms for finding kth element instead of full sort
- Maintain data in sorted order as it's inserted (using BST or heap)

## Practice Problems
1. Implement Merge Sort
2. Implement Quick Sort with random pivot
3. Count Inversions using Merge Sort
4. Sort Array by Parity
5. Kth Largest Element in Array
6. Sort Colors (Dutch National Flag)
7. Radix Sort
8. Merge k Sorted Lists
9. Sort Linked List
10. Maximum Gap (using bucket sort)

## Further Reading
- "The Art of Computer Programming" by Donald Knuth (Vol 3: Sorting and Searching)
- "Introduction to Algorithms" by Cormen, Leiserson, Rivest, Stein
- Sorting algorithms visualizations: VisuAlgo.net, Sorting.at
- Research papers on adaptive sorting and cache-oblivious algorithms
