# Arrays

## Overview
Arrays are fundamental data structures that store elements of the same type in contiguous memory locations.

## Key Characteristics
- Fixed size (static arrays) or resizable (dynamic arrays)
- Contiguous memory allocation
- Homogeneous elements
- Random access O(1)
- Insertion/deletion O(n) for beginning/middle

## Common Operations
- Access: O(1)
- Search: O(n) unsorted, O(log n) sorted
- Insertion: O(n) average
- Deletion: O(n) average

## When to Use
- Fast lookup by index is needed
- Memory efficiency is important
- Dataset size is known or bounded
- Cache performance matters

## When to Avoid
- Frequent insertions/deletions at beginning/middle
- Unknown or rapidly changing size
- Need for heterogeneous elements
- Memory fragmentation concerns

## Examples in Different Languages
See language-specific files for detailed implementations.
