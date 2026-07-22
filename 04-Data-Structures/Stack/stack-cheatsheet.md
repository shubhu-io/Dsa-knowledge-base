# Stack Cheat Sheet

## Core Concepts

### What is a Stack?
A linear data structure that follows the Last-In-First-Out (LIFO) principle, meaning the last element added to the stack will be the first one to be removed.

### Key Characteristics
- **LIFO Principle**: Last In, First Out - the most recently added element is the first to be removed
- **Restricted Access**: Only the top element is accessible at any time
- **Dynamic Size**: Can grow and shrink as needed during runtime
- **Efficient Operations**: Push and pop operations are O(1) time complexity
- **Simple Implementation**: Can be implemented using arrays or linked lists

## Stack Structure
```
Top
 ↓
[ A ]  ← Most recently added (top)
[ B ]
[ C ]  ← Least recently added (bottom)
[ D ]
Base
```

Operations only occur at the top:
- **Push**: Add element to top of stack
- **Pop**: Remove element from top of stack
- **Peek/Top**: View element at top without removing it

## Types of Stacks

### 1. Array-Based Stack
- Uses contiguous memory allocation (array)
- Fixed size or dynamically resizable
- Excellent cache locality due to contiguous memory
- May waste space if overallocated (array-based)

### 2. Linked List-Based Stack
- Uses linked list for storage
- Dynamic size without wasted space
- Slightly more memory overhead due to pointers
- Efficient insertions/deletions at head

### 3. Specialized Stack Variations
- **Min Stack**: Tracks minimum element for O(1) min retrieval
- **Max Stack**: Tracks maximum element for O(1) max retrieval
- **Stack with Middle Operation**: Maintains pointer to middle element
- **Dual Stack**: Two stacks sharing same array (grow from opposite ends)

## Core Operations and Time Complexities

| Operation | Time Complexity | Space Complexity | Description |
|-----------|----------------|------------------|-------------|
| Push | O(1) | O(1) | Add element to top |
| Pop | O(1) | O(1) | Remove element from top |
| Peek/Top | O(1) | O(1) | View top element without removal |
| isEmpty | O(1) | O(1) | Check if stack has no elements |
| size | O(1) | O(1) | Return number of elements |
| Search | O(n) | O(1) | Find element (requires popping) |

## Implementation Techniques

### 1. Array-Based Implementation
```python
class Stack:
    def __init__(self):
        self.items = []
        self.capacity = 10  # Optional fixed capacity
    
    def push(self, item):
        if len(self.items) >= self.capacity:
            raise OverflowError("Stack overflow")
        self.items.append(item)
    
    def pop(self):
        if self.is_empty():
            raise IndexError("Pop from empty stack")
        return self.items.pop()
    
    def peek(self):
        if self.is_empty():
            raise IndexError("Peek from empty stack")
        return self.items[-1]
```

### 2. Linked List-Based Implementation
```python
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class Stack:
    def __init__(self):
        self.top = None
        self.size = 0
    
    def push(self, data):
        new_node = Node(data)
        new_node.next = self.top
        self.top = new_node
        self.size += 1
    
    def pop(self):
        if self.is_empty():
            raise IndexError("Pop from empty stack")
        data = self.top.data
        self.top = self.top.next
        self.size -= 1
        return data
```

## Common Algorithms and Patterns

### 1. Matching Pairs (Parentheses/Brackets Validation)
**Use Case**: Validating expressions, HTML/XML tags
**Pattern**: 
- Push opening brackets/tokens
- When encountering closing bracket, check if it matches stack top
- Pop if match, invalid if mismatch or stack empty when closing
- Valid if stack empty at end

### 2. Monotonic Stack
**Use Case**: Next greater element, largest rectangle in histogram
**Pattern**: 
- Maintain stack in sorted order (increasing or decreasing)
- For next greater element: decreasing stack
- For previous less than current
- For previous less element: increasing stack
- Each element pushed and popped at most once: O(n)

### 3. Two-Stack Approach
**Use Case**: Implementing queues with stacks, undo/redo systems
**Pattern**: 
- Stack A for incoming operations
- Stack B for outgoing operations
- Transfer from A to B when B is empty
- Amortized O(1) per operation

### 4. Stack with Auxiliary Storage
**Use Case**: Min/Max stacks, tracking additional information
**Pattern**: 
- Main stack for primary data
- Auxiliary stack for metadata (min, max, frequency, etc.)
- Update both stacks on push/pop operations

### 5. String Processing
**Use Case**: Expression evaluation, parsing, transformation
**Pattern**: 
- Use stack to hold intermediate results
- Process input character by character
- Apply operations based on current character and stack state
- Common in compilers and interpreters

## Specialized Stack Variations

### Min Stack
Tracks minimum element for O(1) retrieval:
```python
class MinStack:
    def __init__(self):
        self.stack = []
        self.min_stack = []
    
    def push(self, val):
        self.stack.append(val)
        if not self.min_stack or val <= self.min_stack[-1]:
            self.min_stack.append(val)
    
    def pop(self):
        if self.stack:
            val = self.stack.pop()
            if val == self.min_stack[-1]:
                self.min_stack.pop()
            return val
    
    def get_min(self):
        if self.min_stack:
            return self.min_stack[-1]
```

### Max Stack
Similar to Min Stack but tracks maximum element.

### Stack with Middle Operation
Maintains pointer to middle for O(1) access:
- Update middle pointer on push/pop based on size parity
- Complex but enables O(1) middle access

### Dual Stack (Two Stacks in One Array)
Two stacks sharing same array:
- Stack 1 grows from left to right
- Stack 2 grows from right to left
- Efficient memory utilization
- Overflow when stacks meet

## When to Use Stacks

### ✅ Use Stacks When:
- You need LIFO (Last-In-First-Out) behavior
- Implementing function call management
- Evaluating expressions (infix, postfix, prefix)
- Implementing backtracking algorithms (maze solving, game AI)
- Providing undo/redo functionality
- Parsing syntax (HTML, XML, programming languages)
- Implementing depth-first search (DFS)
- Validating syntax (bracket matching, tag validation)
- Managing temporary data in algorithms
- Implementing compiler components (symbol tables, parsing)

### ❌ Avoid Stacks When:
- You need FIFO (First-In-First-Out) behavior (use queue instead)
- You need random access to elements
- You need to access elements in the middle efficiently
- You need to search for specific elements frequently
- You need to maintain insertion order for iteration
- You need to access both ends efficiently (use deque instead)

## Space-Time Tradeoffs

### Array-Based vs Linked List-Based Stacks
| Aspect | Array-Based | Linked List-Based |
|--------|-------------|-------------------|
| Access by Index | O(n) | O(n) |
| Push/Pop | O(1) amortized | O(1) worst case |
| Memory Allocation | Contiguous | Non-contiguous |
| Cache Locality | Excellent | Poor |
| Allocation Overhead | Low (bulk allocation) | High (per-node) |
| Memory Wastage | Possible (if overallocated) | None |
| Size Limit | Fixed or resize cost | Limited only by memory |
| Implementation Simplicity | Simple | Slightly more complex (pointers) |

### Compared to Other Data Structures
| Aspect | Stack | Queue | Priority Queue | Array |
|--------|-------|-------|----------------|-------|
| Access Pattern | LIFO | FIFO | Priority-based | Random |
| Insertion | O(1) at top | O(1) at rear | O(log n) | O(n) at beginning/middle |
| Deletion | O(1) at top | O(1) at front | O(1) | O(n) at beginning/middle |
| Peek | O(1) at top | O(1) at front | O(1) | O(1) |
| Use Case | Function calls, undo/redo | Printing, BFS | Scheduling, Dijkstra | General storage |

## Common Algorithms Using Stacks

### 1. Expression Evaluation and Conversion
- **Infix to Postfix**: Use stack to handle operator precedence
- **Postfix Evaluation**: Use stack to store operands
- **Infix Evaluation**: Use two stacks (operands and operators)
- **Prefix Evaluation**: Similar to postfix but right-to-left

### 2. Syntax Parsing and Validation
- **Balanced Parentheses**: Stack for matching opening/closing
- **HTML/XML Validation**: Stack for tag matching
- **Compiler Syntax Analysis**: Stack-based parsers (LL, LR)

### 3. Graph Algorithms
- **Depth-First Search (DFS)**: Explicit stack for graph traversal
- **Iterative DFS**: Alternative to recursive DFS
- **Topological Sorting**: Using stack for ordering

### 4. Array Processing Problems
- **Next Greater Element**: Monotonic stack
- **Previous Smaller Element**: Monotonic stack
- **Largest Rectangle in Histogram**: Monotonic stack
- **Trapping Rain Water**: Stack-based approach
- **Remove Adjacent Duplicates**: Stack for elimination

### 5. Problem-Solving Patterns
- **Backtracking**: Maze solving, puzzle solutions
- **History Tracking**: Undo/redo, navigation history
- **Frequency Tracking**: Using stacks with hash maps
- **Nested Structure Processing**: Parsing nested constructs
- **Temporal Reasoning**: Stock span, daily temperatures

## Performance Characteristics

### Time Complexity Summary
| Operation | Array-Based | Linked List-Based | Notes |
|-----------|-------------|-------------------|-------|
| Push | O(1) amortized | O(1) worst case | Amortized due to resizing |
| Pop | O(1) amortized | O(1) worst case | Same as push |
| Peek | O(1) | O(1) | Constant time |
| Search | O(n) | O(n) | Linear scan required |
| Access by Index | O(n) | O(n) | Requires popping |

### Space Complexity
- **Base Structure**: O(n) for n elements
- **Auxiliary Space**: Varies by algorithm (O(1) to O(n))
- **Overhead**: 
  - Array-based: Minimal (just array storage)
  - Linked list-based: Pointer overhead per node

### Amortized Analysis for Array-Based Stack
When using dynamic resizing (typically doubling size):
- Most push operations: O(1) (no resize needed)
- Occasional push operations: O(n) (when resize occurs)
- Amortized cost per operation: O(1)
- Proof: For n insertions starting from size 1:
  - Total cost = n (inserts) + (1 + 2 + 4 + ... + 2^k) where 2^k < n
  - Geometric series sum < 2n
  - Total cost < 3n
  - Amortized cost per operation < 3 = O(1)

## Real-World Examples

### 1. Function Call Stack
- Stores return addresses, parameters, local variables
- Each function call pushes a stack frame
- Each return pops a stack frame
- Critical for recursion and program execution flow

### 2. Undo/Redo Systems
- **Undo Stack**: Stores actions for reversing
- **Redo Stack**: Stores undone actions for redoing
- New action: Push to undo stack, clear redo stack
- Undo: Pop from undo stack, push to redo stack
- Redo: Pop from redo stack, push to undo stack

### 3. Web Browser Navigation
- **Back Stack**: Stores visited pages for back navigation
- **Forward Stack**: Stores pages for forward navigation
- New visit: Push to back stack, clear forward stack
- Back: Pop from back stack, push to forward stack
- Forward: Pop from forward stack, push to back stack

### 4. Expression Calculators
- **Infix to Postfix**: Shunting-yard algorithm using stacks
- **Postfix Evaluation**: Stack-based operand storage
- **Memory Functions**: Stack-based memory storage/recall
- **Parentheses Matching**: Stack for tracking open parentheses

### 5. Compiler Components
- **Syntax Parsing**: Stack-based parsers (LR, LL)
- **Symbol Table Management**: Scope tracking
- **Intermediate Code Generation**: Temporary variable management
- **Memory Allocation**: Stack allocation for local variables

### 6. Algorithmic Applications
- **Depth-First Search (DFS)**: Graph and tree traversal
- **Iterative Tree Traversals**: Preorder, inorder, postorder
- **Backtracking Algorithms**: Maze solving, Sudoku, N-queens
- **Syntax Validation**: Bracket matching, HTML validation
- **Histogram Problems**: Largest rectangle, trapping rain water

## Common Pitfalls and How to Avoid Them

### 1. Forgetting to Check for Empty Stack
**Problem**: Calling pop() or peek() on empty stack
**Solution**: Always check isEmpty() before pop/peek operations
- Use try/catch for exception handling
- Return optional values or sentinel values where appropriate
- Validate preconditions in documentation

### 2. Incorrect Stack Overflow Handling
**Problem**: Not handling growth limits properly
**Solution**:
- For fixed-size stacks: Check capacity before push
- For dynamic stacks: Implement proper resizing strategy
- Provide clear error messages for overflow conditions
- Consider lazy resizing or predictive sizing based on usage patterns

### 3. Confusing Stack with Other Data Structures
**Problem**: Using stack when queue or other structure is more appropriate
**Solution**: Clearly understand problem requirements
- Stack: LIFO (undo/redo, function calls)
- Queue: FIFO (printing, BFS, waiting lines)
- Priority Queue: Priority-based (scheduling, Dijkstra)
- Deque: Both ends access (sliding window, palindrome check)

### 4. Inefficient Implementations
**Problem**: Using O(n) operations when O(1) is possible
**Solution**:
- Always restrict operations to top of stack
- Avoid traversing stack for operations that should be O(1)
- Use auxiliary data structures for extended functionality
- Profile and optimize hot paths in performance-critical code

### 5. Memory Leaks (Manual Memory Management)
**Problem**: Not deallocating memory when popping elements
**Solution**:
- Properly free/delete nodes when removing from stack
- In garbage-collected languages, ensure no lingering references
- Use object pools for frequent allocation/deallocation scenarios
- Validate memory cleanup in testing and debugging

### 6. Stack Overflow in Recursion
**Problem**: Deep recursion exceeding stack limits
**Solution**:
- Convert recursive algorithms to iterative using explicit stacks
- Increase stack size if system permits (platform-dependent)
- Use tail call optimization when available and applicable
- Consider hybrid approach: recursion for small depths, iteration for large

### 7. Not Considering Thread Safety
**Problem**: Concurrent access leading to race conditions
**Solution**:
- Implement locking mechanisms for shared stacks
- Use thread-safe stack implementations when available
- Consider immutable or persistent stack variants
- Use actor model or message passing for concurrency

### 8. Ignoring Cache Performance
**Problem**: Poor cache utilization in array-based stacks
**Solution**:
- Ensure proper memory alignment
- Consider cache-friendly allocation patterns
- Profile cache miss rates in performance-critical applications
- Use stack coloring or partitioning techniques for multi-core

## Quick Reference Formulas

### Basic Operations
- **Push**: `stack.append(item)` (array-based) or create new node pointing to current top
- **Pop**: `stack.pop()` (array-based) or save top data, update top to top.next
- **Peek**: `stack[-1]` (array-based) or `top.data` (linked list-based)
- **isEmpty**: `len(stack) == 0` (array-based) or `top == None` (linked list-based)
- **Size**: `len(stack)` (array-based) or maintain size counter (linked list)

### Advanced Patterns
- **Two Stacks Queue**: 
  - Push to stack1
  - For pop/peek: if stack2 empty, transfer all from stack1 to stack2, then pop/peek from stack2
- **Min/Max Stack**: 
  - Main stack for values
  - Auxiliary stack for tracking min/max at each level
- **Monotonic Stack**: 
  - Maintain stack in sorted order
  - Pop elements violating order before pushing new element
- **History Tracking**: 
  - Main stack for current state
  - Auxiliary stacks for undo/redo history

### Memory Utilization
- **Array-Based Stack**: 
  - Memory = allocated array size × element size
  - Utilization = (number of elements / array capacity) × 100%
  - Ideal resize factor: ~1.5-2.0 for amortized O(1) performance
- **Linked List-Based Stack**: 
  - Memory = number of nodes × (element size + pointer size)
  - Pointer overhead: typically 1× or 2× element size depending on implementation

### Amortized Analysis for Dynamic Arrays
When array doubles in size on overflow:
- Let n = number of elements after n insertions starting from size 1
- Total cost = n (insertions) + Σ(2^i) for i=0 to k where 2^k < n
- Geometric series sum = 2^(k+1) - 1 < 2n
- Total cost < 3n
- Amortized cost per operation < 3 = O(1)

## Interview Tips

### What Interviewers Look For
1. **Understanding of LIFO Principle**: Correctly applying stack behavior
2. **Implementation Skills**: Ability to implement stacks using different methods
3. **Problem Recognition**: Identifying when a problem requires stack-based solution
4. **Edge Case Handling**: Empty stack, single element, full stack (if fixed size)
5. **Algorithm Knowledge**: Familiarity with classic stack-based algorithms
6. **Complexity Awareness**: Understanding time/space tradeoffs
7. **Code Quality**: Clean, readable, well-commented implementations
8. **Problem-Solving Approach**: Systematic approach to breaking down problems

### Common Interview Questions
1. Implement a stack using queues
2. Implement a queue using stacks
3. Valid parentheses
4. Remove all adjacent duplicates in string
5. Daily temperatures
6. Largest rectangle in histogram
7. Basic calculator (expression evaluation)
8. Min stack / Max stack
9. Decode string
10. Backspace string compare
11. Stock span problem
12. Next greater element
13. Implement Stack using Linked List
14. Implement Stack using Array
15. Check for Balanced Parentheses

### Follow-up Questions to Expect
- How would you implement a stack using two queues?
- Can you implement a stack that supports getMin() in O(1) time?
- How would you evaluate an expression given in infix notation?
- What's the difference between stack and heap memory in program execution?
- How would you implement an undo/redo feature using stacks?
- How would you check for balanced parentheses in an expression with multiple types?
- Can you implement a stack using linked list with both push and pop operations?
- How would you implement a stack with fixed capacity and overflow handling?
- What are the applications of stacks in compiler design and execution?
- How would you implement a stack that can return the kth element from the top?
- What is a monotonic stack and how is it used in solving array problems?
- How would you implement a stack that tracks the median element efficiently?

### Best Practices for Interview Answers
1. **Clarify Requirements**: Ask about stack type, constraints, required operations
2. **Discuss Trade-offs**: Mention time/space complexity and implementation choices
3. **Consider Edge Cases**: Empty stack, single element, large inputs, malformed input
4. **Talk Through Approach**: Explain algorithm before coding, justify design decisions
5. **Write Clean Code**: 
   - Meaningful variable names (not just 'x' or 'temp')
   - Proper indentation and formatting
   - Comments for non-obvious logic
   - Handle edge cases explicitly
6. **Test Your Solution**: 
   - Walk through examples with your code
   - Check edge cases explicitly
   - Verify correctness of complex logic
7. **Mention Alternatives**: 
   - Discuss other approaches and explain why you chose yours
   - Show awareness of trade-offs
8. **Address Memory Management**: 
   - In applicable languages, discuss allocation/deallocation
   - Mention potential leaks and how to avoid them
9. **Consider Extensions**: 
   - How would your solution change for enhanced requirements?
   - Show foresight for potential follow-up questions
10. **Think About Real-World Applications**: 
    - Relate to practical use cases
    - Demonstrate broader understanding beyond the interview problem

## Remember
Stacks are fundamental data structures that embody the Last-In-First-Out principle. While seemingly simple, they form the basis for many complex algorithms and system functionalities.

The key to mastering stacks is understanding not just how they work, but when to use them. Recognizing the patterns that indicate a stack-based solution is crucial:
- Problems involving reversal of order
- Nested structures requiring matching (parentheses, tags)
- History tracking needs (undo/redo, navigation)
- Backtracking scenarios
- Expression evaluation and parsing
- Monotonic sequences and windowing problems

By internalizing these patterns and practicing stack-based problems, you'll develop the intuition to quickly identify when a stack is the right tool for the job and implement efficient, correct solutions. Whether you're preparing for technical interviews, working on software projects, or studying computer science theory, a deep understanding of stacks will serve you well across numerous domains and applications.