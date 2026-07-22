# Linked List Tutorial

## Overview
A linked list is a linear data structure where elements are stored in nodes, and each node points to the next node in the sequence. Unlike arrays, linked list elements are not stored in contiguous memory locations.

## Key Characteristics
- Dynamic Size: Can grow and shrink during runtime
- Non-contiguous Memory: Nodes can be scattered in memory
- Pointer-Based: Each node contains data and a reference to the next node
- Sequential Access: Elements must be accessed by traversing from the head
- Efficient Insertions/Deletions: O(1) at known positions

## Types of Linked Lists
1. Singly Linked List: Each node points to the next node only
2. Doubly Linked List: Each node points to both next and previous nodes
3. Circular Linked List: Last node points back to the first node

## Basic Operations
- Traversal: O(n)
- Search: O(n)
- Insertion at Head: O(1)
- Deletion from Head: O(1)
- Insertion/Deletion at Position: O(n) to find + O(1) to operate

## When to Use
Use linked lists when you need frequent insertions/deletions, especially at the beginning or middle, and when the number of elements is unknown or changing frequently.

Avoid linked lists when you need frequent random access by index or when cache performance is critical.

## Implementation Examples
See language-specific files for detailed implementations in C, C++, Java, Python, and JavaScript.

## Time Complexity Comparison
| Operation | Array | Linked List |
|-----------|-------|-------------|
| Access | O(1) | O(n) |
| Search | O(n) | O(n) |
| Insert at Front | O(n) | O(1) |
| Delete from Front | O(n) | O(1) |

## Practice Problems
1. Reverse a Linked List
2. Detect Cycle in Linked List
3. Find Middle of Linked List
4. Merge Two Sorted Lists
5. Remove Nth Node from End

## Further Reading
- "Introduction to Algorithms" by Cormen et al.
- GeeksforGeeks Linked List section
- LeetCode Linked List problems
