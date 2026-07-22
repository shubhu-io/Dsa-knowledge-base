# Sorting Algorithms

## Overview

Sorting algorithms arrange elements in a specific order (ascending or descending). They are fundamental to computer science and often used as subroutines in other algorithms.

## Common Sorting Algorithms

| Algorithm | Time (Best) | Time (Avg) | Time (Worst) | Space | Stable |
|-----------|-------------|------------|--------------|-------|--------|
| Bubble Sort | O(n) | O(n²) | O(n²) | O(1) | Yes |
| Selection Sort | O(n²) | O(n²) | O(n²) | O(1) | No |
| Insertion Sort | O(n) | O(n²) | O(n²) | O(1) | Yes |
| Merge Sort | O(n log n) | O(n log n) | O(n log n) | O(n) | Yes |
| Quick Sort | O(n log n) | O(n log n) | O(n²) | O(log n) | No |
| Heap Sort | O(n log n) | O(n log n) | O(n log n) | O(1) | No |

## Files

| File | Description |
|------|-------------|
| `sorting-overview.md` | Detailed overview |
| `sorting-tutorial.md` | Step-by-step tutorial |
| `sorting-cheatsheet.md` | Quick reference |
| `sorting-problems.md` | Practice problems |

## When to Use

- **Small datasets**: Insertion Sort
- **Guaranteed O(n log n)**: Merge Sort
- **Memory constrained**: Quick Sort or Heap Sort
- **Nearly sorted data**: Insertion Sort