# Data Structures

This section covers fundamental data structures used in computer science and programming interviews.

## Data Structures Covered

| Structure | Description | Use Cases |
|-----------|-------------|-----------|
| **Arrays** | Contiguous memory storage | Random access, caching |
| **Linked Lists** | Sequential access, dynamic size | Insertions/deletions |
| **Stacks** | LIFO (Last In First Out) | Undo, recursion, parsing |
| **Queues** | FIFO (First In First Out) | Scheduling, BFS |
| **Hash Tables** | Key-value lookup | Fast search, caching |
| **Trees** | Hierarchical structure | Searching, sorting |
| **Graphs** | Network of vertices and edges | Relationships, paths |

## Subfolders

### Arrays
- Tutorial, cheatsheet, problems, overview
- Two pointers, sliding window patterns

### Linked Lists
- Singly and doubly linked lists
- Fast/slow pointer technique

### Stacks
- Push/pop/peek operations
- Valid parentheses, next greater element

### Queues
- Circular queue, deque
- BFS applications

### Hash Tables
- Collision handling
- Two sum pattern

### Trees
- Binary trees, BST, AVL
- Traversals (inorder, preorder, postfix)

## Complexity Summary

| Structure | Access | Search | Insert | Delete | Space |
|-----------|--------|--------|--------|--------|-------|
| Array | O(1) | O(n) | O(n) | O(n) | O(n) |
| Linked List | O(n) | O(n) | O(1) | O(1) | O(n) |
| Stack | O(n) | O(n) | O(1) | O(1) | O(n) |
| Queue | O(n) | O(n) | O(1) | O(1) | O(n) |
| Hash Table | O(1)* | O(1)* | O(1)* | O(1)* | O(n) |
| BST | O(log n) | O(log n) | O(log n) | O(log n) | O(n) |