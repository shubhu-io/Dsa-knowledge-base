# Data Structures

A comprehensive guide to fundamental and advanced data structures used in computer
science and software engineering.

## Overview

Data structures are specialized formats for organizing, processing, retrieving, and
storing data. Choosing the right data structure is critical for writing efficient
algorithms and solving problems effectively.

Understanding data structures is essential for technical interviews, competitive
programming, and building production-quality software.

---

## Key Concepts

### Linear vs Non-Linear Structures

**Linear data structures** store elements in a sequential order. Each element is
connected to its previous and next element. Examples include arrays, linked lists,
stacks, and queues.

**Non-linear data structures** store elements in a hierarchical or networked fashion.
Elements may connect to multiple other elements. Examples include trees, graphs, and
hash tables (which use non-linear internal structures).

### Static vs Dynamic

**Static structures** have a fixed size determined at creation time (e.g., arrays).
**Dynamic structures** can grow and shrink during runtime (e.g., linked lists, hash
tables).

---

## Comparison Table

| Data Structure | Access       | Search       | Insertion     | Deletion      | Use Case                  |
|----------------|--------------|--------------|---------------|---------------|---------------------------|
| Array          | O(1)         | O(n)         | O(n)          | O(n)          | Random access, fixed data |
| Linked List    | O(n)         | O(n)         | O(1)*         | O(1)*         | Frequent insertions       |
| Stack          | O(n)         | O(n)         | O(1)          | O(1)          | Undo, function calls      |
| Queue          | O(n)         | O(n)         | O(1)          | O(1)          | BFS, task scheduling      |
| Hash Table     | N/A          | O(1) avg     | O(1) avg      | O(1) avg      | Fast lookups              |
| Binary Tree    | O(log n) avg | O(log n) avg | O(log n) avg  | O(log n) avg  | Sorted data, searching    |
| Graph          | Varies       | Varies       | Varies        | Varies        | Relationships, networks   |

*\* At head/tail; O(n) for arbitrary position*

---

## When to Use Which Structure

### Use an Array When
- You need constant-time random access by index
- The data size is known in advance
- You need cache-friendly memory layout
- You rarely insert or delete elements

### Use a Linked List When
- You need frequent insertions and deletions at the beginning
- You don't need random access by index
- Memory allocation needs to be dynamic
- You are implementing another structure (stack, queue)

### Use a Stack When
- You need LIFO (Last In, First Out) ordering
- Implementing recursive algorithms iteratively
- Parsing expressions or matching brackets
- Undo/redo functionality

### Use a Queue When
- You need FIFO (First In, First Out) ordering
- Implementing BFS traversal
- Task scheduling or buffering
- Producer-consumer patterns

### Use a Hash Table When
- You need O(1) average-case lookups
- Counting frequencies or occurrences
- Caching computed results
- Detecting duplicates

### Use a Tree When
- Data needs to remain sorted
- You need efficient range queries
- Implementing a priority queue
- Representing hierarchical data

### Use a Graph When
- Modeling relationships between entities
- Finding shortest paths
- Detecting cycles or dependencies
- Network analysis

---

## Code Example: Linked List in Python

```python
"""
Singly Linked List Implementation
Supports insertion, deletion, searching, and traversal.
Time complexities noted for each operation.
"""

class Node:
    """A single node in a linked list."""

    def __init__(self, data):
        self.data = data
        self.next = None


class LinkedList:
    """Singly linked list with common operations."""

    def __init__(self):
        self.head = None
        self.size = 0

    def is_empty(self):
        """Check if the list is empty. O(1)"""
        return self.head is None

    def insert_front(self, data):
        """Insert at the beginning. O(1)"""
        new_node = Node(data)
        new_node.next = self.head
        self.head = new_node
        self.size += 1

    def insert_end(self, data):
        """Insert at the end. O(n)"""
        new_node = Node(data)
        if self.is_empty():
            self.head = new_node
        else:
            current = self.head
            while current.next:
                current = current.next
            current.next = new_node
        self.size += 1

    def delete(self, data):
        """Delete first occurrence of data. O(n)"""
        if self.is_empty():
            return False

        if self.head.data == data:
            self.head = self.head.next
            self.size -= 1
            return True

        current = self.head
        while current.next:
            if current.next.data == data:
                current.next = current.next.next
                self.size -= 1
                return True
            current = current.next
        return False

    def search(self, data):
        """Search for data. O(n)"""
        current = self.head
        index = 0
        while current:
            if current.data == data:
                return index
            current = current.next
            index += 1
        return -1

    def to_list(self):
        """Convert to Python list. O(n)"""
        result = []
        current = self.head
        while current:
            result.append(current.data)
            current = current.next
        return result

    def __len__(self):
        return self.size

    def __repr__(self):
        return " -> ".join(str(x) for x in self.to_list())


def main():
    ll = LinkedList()

    # Insert elements
    for value in [10, 20, 30, 40, 50]:
        ll.insert_end(value)
    print(f"List: {ll}")            # 10 -> 20 -> 30 -> 40 -> 50

    ll.insert_front(5)
    print(f"After insert_front(5): {ll}")  # 5 -> 10 -> 20 -> 30 -> 40 -> 50

    ll.delete(30)
    print(f"After delete(30): {ll}")       # 5 -> 10 -> 20 -> 40 -> 50

    index = ll.search(40)
    print(f"Search(40) found at index: {index}")  # 3
    print(f"Length: {len(ll)}")                    # 5


if __name__ == "__main__":
    main()
```

---

## Common Interview Questions

1. **How do you reverse a linked list?**
   Use three pointers (prev, current, next) iteratively or recursion. O(n) time, O(1) space.

2. **Detect a cycle in a linked list.**
   Use Floyd's Tortoise and Hare with slow and fast pointers. O(n) time, O(1) space.

3. **Find the middle element of a linked list.**
   Slow moves one step, fast moves two. When fast reaches end, slow is at middle.

4. **Merge two sorted linked lists.**
   Compare heads, attach smaller node to result, advance that pointer. Repeat until exhausted.

5. **Difference between an array and a linked list?**
   Arrays: O(1) access, O(n) insertion. Linked lists: O(1) insertion, O(n) access.
   Arrays use contiguous memory; linked lists use scattered memory with pointers.

---

## See Also

- [[Algorithms]] — Algorithms operating on these structures
- [[Time-Complexity]] — Detailed complexity analysis
- [[Programming-Languages]] — Implementations in various languages
- [[Problem-Solving]] — Patterns for solving data structure problems

---

> Full content: [04-Data-Structures](../04-Data-Structures/)
