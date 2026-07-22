# Linked List Cheat Sheet

## Core Concepts

### What is a Linked List?
A linear data structure where elements are not stored in contiguous memory locations. Each element (node) contains data and a reference to the next node.

### Key Properties
- **Dynamic Size**: Can grow or shrink during runtime
- **Non-contiguous Memory**: Nodes can be scattered throughout memory
- **Pointer-based**: Each node contains data and reference(s) to other nodes
- **Efficient Insertions/Deletions**: O(1) at known position
- **Sequential Access**: Elements accessed by traversing from head
- **No Random Access**: Cannot directly access element at index i

## Node Structure

### Singly Linked List Node
```
[ Data | Next ]
```
- Data: The value stored
- Next: Reference to the next node (null for last node)

### Doubly Linked List Node
```
[ Prev | Data | Next ]
```
- Prev: Reference to the previous node (null for first node)
- Data: The value stored
- Next: Reference to the next node (null for last node)

## Types of Linked Lists

| Type | Structure | Traversal | Use Cases |
|------|-----------|-----------|-----------|
| **Singly Linked List** | Node → Node → ... → Null | Forward only | Stacks, queues, chaining in hash tables |
| **Doubly Linked List** | Null ← Node ↔ Node ↔ ... ↔ Null | Forward & backward | LRU cache, undo/redo, browser history |
| **Circular Linked List** | Last node → First node (circle) | Forward (circular) | Round-robin scheduling, multiplayer games |
| **Doubly Circular Linked List** | Circular with prev/next | Both directions | Advanced buffering, complex simulations |

## Core Operations and Time Complexities

### Singly Linked List
| Operation | Time Complexity | Space Complexity | Description |
|-----------|----------------|------------------|-------------|
| Access by Index | O(n) | O(1) | Traverse from head |
| Search | O(n) | O(1) | Linear search |
| Insert at Head | O(1) | O(1) | Direct insertion |
| Insert at Tail | O(n)* | O(1)* | *With tail pointer: O(1) |
| Insert at Middle | O(n) | O(1) | Requires traversal |
| Delete at Head | O(1) | O(1) | Direct removal |
| Delete at Tail | O(n)* | O(1)* | *With tail pointer: O(1) |
| Delete at Middle | O(n) | O(1) | Requires traversal |
| Space per Node | O(1) | O(1) | Data + one pointer |

### Doubly Linked List
| Operation | Time Complexity | Space Complexity | Description |
|-----------|----------------|------------------|-------------|
| Access by Index | O(n) | O(1) | Traverse from head or tail |
| Search | O(n) | O(1) | Linear search |
| Insert at Head | O(1) | O(1) | Direct insertion |
| Insert at Tail | O(1) | O(1) | Direct insertion |
| Insert at Middle | O(n) | O(1) | Requires traversal |
| Delete at Head | O(1) | O(1) | Direct removal |
| Delete at Tail | O(1) | O(1) | Direct removal |
| Delete at Middle | O(n) | O(1) | Requires traversal |
| Space per Node | O(1) | O(1) | Data + two pointers |

## Implementation Techniques

### 1. Dummy Node Technique
Use a dummy node to simplify edge cases:
```python
dummy = ListNode(0)
dummy.next = head
# Operations on dummy.next instead of head
# Eliminates special case for head modifications
```

### 2. Two Pointers (Fast/Slow) Technique
Useful for finding middle, detecting cycles, etc.:
```python
slow = fast = head
while fast and fast.next:
    slow = slow.next  # Moves 1 step
    fast = fast.next.next  # Moves 2 steps
# slow is at middle when fast reaches end
```

### 3. In-Place Reversal
Reverse links without extra space:
```python
prev = None
current = head
while current:
    next_temp = current.next
    current.next = prev
    prev = current
    current = next_temp
# prev is new head
```

### 4. Merge Two Sorted Lists
Use dummy node to simplify:
```python
dummy = ListNode(0)
current = dummy
while l1 and l2:
    if l1.val < l2.val:
        current.next = l1
        l1 = l1.next
    else:
        current.next = l2
        l2 = l2.next
    current = current.next
current.next = l1 if l1 else l2
# Result is dummy.next
```

## Common Algorithms and Patterns

### 1. Finding Middle of List
**Use Cases**: Splitting lists, palindrome checking, reordering
**Pattern**: Fast/slow pointers
```python
slow = fast = head
while fast and fast.next:
    slow = slow.next
    fast = fast.next.next
# slow is middle (or first middle in even-length list)
```

### 2. Detecting Cycle
**Use Cases**: Cyclic list detection, finding cycle start
**Pattern**: Floyd's Tortoise and Hare
```python
slow = fast = head
while fast and fast.next:
    slow = slow.next
    fast = fast.next.next
    if slow == fast:
        return True  # Cycle detected
return False
```

### 3. Finding Cycle Start
**Use Cases**: Finding where cycle begins
**Pattern**: Floyd's algorithm + reset
```python
# First, detect cycle
slow = fast = head
while fast and fast.next:
    slow = slow.next
    fast = fast.next.next
    if slow == fast:
        break
else:
    return None  # No cycle

# Find start of cycle
slow = head
while slow != fast:
    slow = slow.next
    fast = fast.next
return slow  # Start of cycle
```

### 4. Reversing a List
**Use Cases**: Palindrome checking, reordering, stack implementation
**Pattern**: Three-pointer technique
```python
prev = None
current = head
while current:
    next_temp = current.next
    current.next = prev
    prev = current
    current = next_temp
# prev is new head
```

### 5. Merge Sort on Linked List
**Use Cases**: Sorting linked lists efficiently
**Pattern**: Divide and conquer
```python
def merge_sort(head):
    if not head or not head.next:
        return head
    
    # Split list
    slow = fast = head
    prev = None
    while fast and fast.next:
        prev = slow
        slow = slow.next
        fast = fast.next.next
    prev.next = None  # Break first half
    
    # Recursively sort and merge
    left = merge_sort(head)
    right = merge_sort(slow)
    return merge_two_sorted_lists(left, right)
```

### 6. Intersection of Two Lists
**Use Cases**: Finding common node in two lists
**Pattern**: Length difference adjustment
```python
def get_intersection(headA, headB):
    lenA, lenB = get_length(headA), get_length(headB)
    currA, currB = headA, headB
    
    # Advance longer list
    if lenA > lenB:
        for _ in range(lenA - lenB):
            currA = currA.next
    else:
        for _ in range(lenB - lenA):
            currB = currB.next
    
    # Move together
    while currA and currB:
        if currA == currB:
            return currA
        currA = currA.next
        currB = currB.next
    return None

def get_length(head):
    length = 0
    while head:
        length += 1
        head = head.next
    return length
```

### 7. Removing Nth Node from End
**Use Cases**: Removing nodes from end, sliding window variations
**Pattern**: Two pointers with fixed distance
```python
def remove_nth_from_end(head, n):
    dummy = ListNode(0)
    dummy.next = head
    first = second = dummy
    
    # Advance first n+1 steps
    for _ in range(n + 1):
        first = first.next
    
    # Move both pointers
    while first:
        first = first.next
        second = second.next
    
    # Skip target node
    second.next = second.next.next
    return dummy.next
```

### 8. Adding Two Numbers (Reverse Order)
**Use Cases**: Large number addition, digit-by-digit operations
**Pattern**: Simultaneous traversal with carry
```python
def add_two_numbers(l1, l2):
    dummy = ListNode(0)
    current = dummy
    carry = 0
    
    while l1 or l2 or carry:
        val1 = l1.val if l1 else 0
        val2 = l2.val if l2 else 0
        
        total = val1 + val2 + carry
        carry = total // 10
        digit = total % 10
        
        current.next = ListNode(digit)
        current = current.next
        
        l1 = l1.next if l1 else None
        l2 = l2.next if l2 else None
    
    return dummy.next
```

## Language-Specific Implementation Notes

### C/C++
- **Manual Memory Management**: Must explicitly allocate/free nodes
- **Pointer Syntax**: `node->next` for access, `(*node).next` equivalent
- **Null Pointers**: Use `NULL` or `nullptr` (C++11+)
- **Structs vs Classes**: Can use either for node definition
- **Templates**: For generic linked lists
- **Memory Leaks**: Critical to free nodes when removing from list

### Java
- **Automatic Memory Management**: Garbage collection handles unreachable nodes
- **Null References**: Use `null` for empty references
- **Inner Classes**: Common to define Node as inner class
- **Generics**: For type safety (`LinkedList<T>`)
- **Immutability**: Consider making data final if appropriate
- **Iterator Pattern**: Often implement Iterator interface

### Python
- **Automatic Memory Management**: Reference counting + garbage collection
- **None**: Represents null/empty references
- **Classes**: Standard class definition for nodes
- **Type Hints**: Available but not enforced (PEP 484)
- **Properties**: Can use `@property` for controlled access
- **__repr__**: Useful for debugging node values
- **Iteration**: Implement `__iter__` for for-loops

### JavaScript
- **Automatic Memory Management**: Garbage collection
- **null**: Represents empty references
- **Constructor Functions**: Or ES6 classes for nodes
- **Prototypes**: Can add methods to Node.prototype
- **Weak References**: Available via WeakRef for special cases
- **Iteration**: Implement Symbol.iterator for for-of loops
- **Type Checking**: Use typeof or instanceof for validation

## Space-Time Tradeoffs

### Compared to Arrays
| Aspect | Linked List | Array |
|--------|-------------|-------|
| Access by Index | O(n) | O(1) |
| Search | O(n) | O(n) unsorted, O(log n) sorted |
| Insert at Head | O(1) | O(n) |
| Insert at Tail | O(1)* | O(1)** |
| Insert at Middle | O(n) | O(n) |
| Delete at Head | O(1) | O(n) |
| Delete at Tail | O(1)* | O(1)** |
| Delete at Middle | O(n) | O(n) |
| Memory Overhead | High (pointers) | Low |
| Cache Locality | Poor | Excellent |
| Size Flexibility | Excellent | Limited |
| *With tail pointer | **Amortized for dynamic arrays |

### Compared to Dynamic Arrays
| Aspect | Linked List | Dynamic Array |
|--------|-------------|---------------|
| Access by Index | O(n) | O(1) |
| Insert at End | O(1) | O(1) amortized |
| Insert at Beginning | O(1) | O(n) |
| Random Access | Poor | Excellent |
| Memory Allocation | Per node | Contiguous blocks |
| Memory Overhead | Higher | Lower |
| Worst-case Insert Time | O(1) | O(n) (resize) |
| Memory Fragmentation | Possible | Less likely |
| Locality of Reference | Poor | Excellent |

### Compared to Hash Tables
| Aspect | Linked List | Hash Table |
|--------|-------------|------------|
| Access by Index | O(n) | N/A |
| Access by Key | O(n) | O(1) avg |
| Insertion | O(1)* | O(1) avg |
| Deletion | O(1)* | O(1) avg |
| Memory Usage | Lower per element | Higher (buckets, pointers) |
| Ordering | Maintains insertion order | No guaranteed order |
| *At head/tail with pointers |

## When to Use Linked Lists

### ✅ Use Linked Lists When:
- You need frequent insertions/deletions at head or tail
- Memory allocation is dynamic and unpredictable
- You want to avoid array resizing overhead
- Implementing stacks, queues, or other ADTs
- You have reference to node and need O(1) insertion/deletion nearby
- Memory is fragmented and contiguous allocation difficult
- Implementing algorithms that benefit from sequential access with modifications
- You're working with data where size changes frequently

### ❌ Avoid Linked Lists When:
- You need random access by index (O(n) vs O(1) for arrays)
- Memory usage is critical (pointer overhead significant)
- Cache performance is important (poor locality causes cache misses)
- You're doing frequent traversals (arrays have better locality)
- Implementing algorithms requiring frequent indexing (like many sorts)
- You're in environment with limited pointer manipulation
- You need backward compatibility with array-expecting systems
- Memory allocation/deallocation overhead is significant
- You need efficient searching by value (consider hash tables or trees)

## Common Applications

### 1. Implementing Other Data Structures
- **Stacks**: Push/pop at head (O(1) both)
- **Queues**: Enqueue at tail, dequeue at head (O(1) with tail pointer)
- **Hash Tables**: Chaining for collision resolution
- **Graphs**: Adjacency list representation
- **Heaps**: Fibonacci heaps use linked lists
- **Priority Queues**: Can be implemented (though binary heaps better)

### 2. Operating Systems
- **Process Scheduling**: Ready queues, waiting queues
- **Memory Management**: Free lists, allocation tracking
- **File Systems**: Directory entries, FAT structures
- **Device Drivers**: Buffer management, interrupt queues

### 3. Real-Time Systems
- **Event Queues**: Priority-based event handling
- **Buffer Management**: Network packet buffers, I/O streams
- **Resource Tracking**: Semaphore queues, mutex wait lists
- **Interrupt Handling**: Linked lists of handlers by priority

### 4. Applications
- **Music Players**: Playlists with next/previous navigation
- **Web Browsers**: Back/forward history (doubly linked list)
- **Image Viewers**: Undo/redo for zoom/pan operations
- **Text Editors**: Undo/redo functionality
- **Polynomial Arithmetic**: Each node = term (coefficient, exponent)
- **Large Number Arithmetic**: Storing digits beyond built-in types
- **Symbol Tables**: In compilers (though hash tables more common)
- **Memory Allocation**: Free lists in malloc/free implementations
- **Event Systems**: Callback lists, observer patterns

## Common Pitfalls and How to Avoid Them

### 1. Forgetting to Update Tail Pointer
**Problem**: After insertion/deletion at tail, tail pointer not updated
**Solution**: Always update tail when modifying end of list
- Insertion at tail: `tail = newNode`
- Deletion at tail: Traverse to find new tail or use doubly linked list

### 2. Memory Leaks (C/C++)
**Problem**: Forgetting to free nodes when removing from list
**Solution**: Always `delete`/`free` nodes that are removed from list
- In garbage collected languages, ensure no references remain

### 3. Losing Reference to List (Head Pointer)
**Problem**: After operations, lose reference to actual head of list
**Solution**: Use dummy node or carefully track head pointer changes
- Especially important when removing head node

### 4. Infinite Loops Due to Cycles
**Problem**: Traversal loops forever due to unintended cycle
**Solution**: Use cycle detection algorithms or limit iterations
- Be careful when creating circular lists intentionally

### 5. Off-by-One Errors in Position-Based Operations
**Problem**: Incorrect index handling (0-based vs 1-based confusion)
**Solution**: Clearly define indexing convention and be consistent
- Test with edge cases: empty list, single element, head, tail

### 6. Not Handling Empty List Edge Cases
**Problem**: Operations fail on empty or single-element lists
**Solution**: Always check for empty list.head = null, tail = null, size = 0 conditions
- Test with empty list, single element, two elements

### 7. Incorrect Pointer Updates in Doubly Linked Lists
**Problem**: Forgetting to update both prev and next pointers
**Solution**: Always update both directions when modifying links
- When inserting: set newNode.next, newNode.prev, and neighbors' pointers
- When deleting: update neighbors' pointers to skip removed node

### 8. Not Terminating Lists Properly
**Problem**: Last node's next pointer not set to null
**Solution**: Always ensure last node's next pointer is null
- Especially important after insertions/deletions

### 9. Using Released/Invalid Pointers
**Problem**: Accessing memory after it's been freed
**Solution**: Set pointers to null after freeing/nulling
- Be careful with pointer validity during complex operations

### 10. Stack Overflow in Recursive Solutions
**Problem**: Recursive depth too large for long lists
**Solution**: Use iterative approaches for list traversal/processing
- Convert recursion to iteration when dealing with potentially long lists

## Performance Optimization Techniques

### 1. Cache Conscious Allocation
- Use memory pools for node allocation to improve locality
- Pre-allocate blocks of nodes instead of individual allocations
- Reduces allocation/fragmentation overhead

### 2. Node Pooling
- Reuse nodes instead of allocating/freeing frequently
- Maintain a free list of available nodes
- Particularly useful in real-time/system programming

### 3. Contiguous Node Allocation
- Allocate nodes in arrays when possible for better locality
- Use array indices as "pointers" instead of actual memory addresses
- Combines array locality with linked list flexibility

### 4. Lazy Deletion
- Mark nodes as deleted instead of immediately removing
- Actual removal during garbage collection or low-activity periods
- Reduces immediate pointer update overhead

### 5. Batch Operations
- Perform multiple insertions/deletions in batches
- Reduces traversal overhead when operations are localized
- Particularly useful for bulk data loading/modification

### 6. Hybrid Approaches
- Combine linked lists with arrays (unrolled linked lists)
- Each node contains array of elements rather than single element
- Improves cache performance while maintaining O(1) insertion/deletion

## Quick Reference Formulas

### List Operations
- **Length**: Traverse and count nodes: O(n)
- **Middle Position**: floor(n/2) for 0-based indexing
- **Distance Between Nodes**: Traverse from one to another: O(distance)
- **Concatenation**: Connect tail of first to head of second: O(1) with tail pointers

### Memory Overhead
- **Singly Linked List**: 1 pointer per node + data
- **Doubly Linked List**: 2 pointers per node + data
- **Pointer Size**: Typically 4 or 8 bytes depending on architecture
- **Overhead Ratio**: For small data types, overhead can exceed data size

### Time Complexity for Common Patterns
- **Reverse List**: O(n) time, O(1) space
- **Find Middle**: O(n) time, O(1) space
- **Detect Cycle**: O(n) time, O(1) space
- **Merge Sorted Lists**: O(n+m) time, O(1) space
- **Insert at Known Position**: O(1) time, O(1) space
- **Delete Known Node**: O(1) time, O(1) space
- **Insert/Delete by Value**: O(n) time, O(1) space (search then O(1) op)

## Real-World Examples

### 1. Browser History (Doubly Linked List)
- Each node = webpage visit
- Back/Forward navigation = move prev/next
- New visit = insert after current, discard forward history
- Efficient O(1) navigation in both directions

### 2. Music Playlist (Singly or Doubly Linked List)
- Each node = song
- Next/Previous = move to next/prev node
- Insert/Remove song = O(1) with reference to position
- Shuffle play = random node access (less efficient)

### 3. Undo/Redo in Text Editors (Doubly Linked List)
- Each node = document state
- Undo = move to prev node
- Redo = move to next node
- New action = insert after current, discard future history
- Efficient O(1) operations for undo/redo

### 4. Free List in Memory Allocator
- Each node = free memory block
- Allocation = remove block from list
- Deallocation = insert block into list
- Coalescing = merge adjacent free blocks
- Efficient O(1) allocation/deallocation with proper data structures

### 5. Hash Table with Chaining
- Each array index = head of linked list
- Collision resolution = append to linked list at index
- Search/Insert/Delete = O(1) average with good hash function
- Worst case O(n) if all keys hash to same bucket

### 6. Polynomial Representation
- Each node = term (coefficient, exponent)
- Addition = merge like terms
- Multiplication = distribute and combine
- Evaluation = substitute and compute
- Efficient for sparse polynomials

### 7. Large Number Arithmetic
- Each node = digit of large number
- Addition/Subtraction = digit-by-digit with carry
- Multiplication = long multiplication algorithm
- Division = long division algorithm
- Enables arithmetic beyond built-in type limits

### 8. Event Handling Systems
- Each node = event handler/callback
- Registration = insert handler into list
- Deregistration = remove handler from list
- Triggering = traverse list and invoke handlers
- Efficient O(1) registration/deregistration with references

## Interview Tips

### What Interviewers Look For
1. **Pointer Manipulation Skills**: Correctly updating next/prev pointers
2. **Edge Case Handling**: Empty lists, single elements, two elements
3. **Memory Management**: Proper allocation/deallocation (where applicable)
4. **Algorithm Knowledge**: Understanding of classic linked list algorithms
5. **Time/Space Complexity Awareness**: Optimizing for efficiency
6. **Clean Code**: Readable, well-commented implementations
7. **Testing Approach**: Considering various test cases including edge cases

### Common Interview Questions
1. Reverse a linked list
2. Detect a cycle in a linked list
3. Find the middle element of a linked list
4. Remove duplicates from a sorted linked list
5. Merge two sorted linked lists
6. Find the kth element from the end
7. Check if a linked list is a palindrome
8. Rotate a linked list
9. Copy a list with random pointers
10. Add two numbers represented by linked lists

### Follow-up Questions to Expect
- How would you detect a cycle in a linked list?
- Can you reverse a linked list in groups of size k?
- How would you merge k sorted linked lists?
- What's the difference between singly and doubly linked lists?
- How would you implement an LRU cache using linked lists?
- What are the disadvantages of using linked lists vs arrays?
- How would you find the intersection of two linked lists?
- Can you implement a queue using two stacks?
- How would you sort a linked list?
- What is a skip list and how does it improve upon linked lists?

### Best Practices for Interview Answers
1. **Clarify Requirements**: Ask about list type, constraints, modification permissions
2. **Discuss Trade-offs**: Mention time/space complexity and alternatives
3. **Consider Edge Cases**: Empty list, single element, two elements, large lists
4. **Talk Through Approach**: Explain algorithm before coding, justify choices
5. **Write Clean Code**: Meaningful variable names (slow/fast, current/prev), clean formatting
6. **Test Solution**: Walk through examples mentally to catch logical errors
7. **Mention Alternatives**: Discuss other approaches and justify your choice
8. **Address Memory Management**: In C/C++, discuss allocation/deallocation and leaks
9. **Consider Immutability**: If asked not to modify original, discuss copying approaches
10. **Think About Extensions**: How would solution change for different list types?

## Remember
Linked lists are fundamental data structures that excel in scenarios requiring frequent insertions and deletions. While they lack the random access efficiency of arrays, their dynamic size and O(1) insertion/deletion at known positions make them indispensable for many applications.

The key to mastering linked lists is understanding pointer manipulation and being able to visualize the structural changes during operations. Practice with the common patterns (two pointers, dummy nodes, in-place reversal) and you'll be well-prepared for linked list problems in interviews and real-world applications.

When solving linked list problems, always draw diagrams to visualize pointer changes, especially for complex operations like reversal, merging, or reordering. This visual approach helps prevent logical errors and makes it easier to understand complex transformations.