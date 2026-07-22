# Stack Tutorial

## Overview
A stack is a linear data structure that follows the Last-In-First-Out (LIFO) principle. The last element added to the stack is the first one to be removed.

## Key Operations
- **Push**: Add an element to the top of the stack
- **Pop**: Remove and return the top element from the stack
- **Peek/Top**: Return the top element without removing it
- **isEmpty**: Check if the stack is empty
- **Size**: Return the number of elements in the stack

## Time Complexity
- Push: O(1)
- Pop: O(1)
- Peek: O(1)
- isEmpty: O(1)
- Size: O(1)

## Implementation Approaches
1. **Array-Based Stack**: Uses a fixed or dynamic array
2. **Linked List-Based Stack**: Uses a linked list where head is the top

## Common Applications
- Function call stack in programming languages
- Expression evaluation and conversion (infix to postfix/prefix)
- Backtracking algorithms
- Undo/Redo functionality in editors
- Browser history (back/forward navigation)
- Parentheses/bracket matching
- Memory management

## Variations
- **Min Stack**: Supports retrieving minimum element in O(1)
- **Max Stack**: Supports retrieving maximum element in O(1)
- **Stack with getMin/Max**: Extended stack operations

## When to Use
Use stacks when you need LIFO behavior, such as:
- Managing function calls
- Parsing expressions
- Implementing undo mechanisms
- Backtracking algorithms

Avoid when you need FIFO behavior or random access to elements.

## Related Concepts
- **Queue**: First-In-First-Out (FIFO) counterpart
- **Deque**: Double-ended queue allowing operations at both ends
- **Priority Queue**: Elements served based on priority

## Practice Problems
1. Valid Parentheses
2. Implement Queue using Stacks
3. Min Stack
4. Evaluate Reverse Polish Notation
5. Daily Temperatures
6. Remove All Adjacent Duplicates in String
7. Longest Valid Parentheses
8. Basic Calculator

## Implementation Tips
- Handle stack overflow/underflow conditions
- Consider using dynamic arrays or linked lists for flexible sizing
- For performance-critical applications, consider array-based implementation
- Remember that peek operation doesn't modify the stack

## Further Reading
- "Introduction to Algorithms" by Cormen et al. (Stacks and Queues section)
- GeeksforGeeks Stack section
- LeetCode Stack and Queue problems
- Visualgo.net stack visualization
