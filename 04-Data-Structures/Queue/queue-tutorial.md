# Queue Tutorial

## Overview
A queue is a linear data structure that follows the First-In-First-Out (FIFO) principle. The first element added to the queue will be the first one to be removed.

## Key Operations
- **Enqueue**: Add an element to the rear of the queue
- **Dequeue**: Remove and return the front element from the queue
- **Front/Peek**: Return the front element without removing it
- **Rear**: Return the rear element without removing it
- **isEmpty**: Check if the queue is empty
- **Size**: Return the number of elements in the queue

## Time Complexity
- Enqueue: O(1)
- Dequeue: O(1)
- Front/Peek: O(1)
- Rear: O(1)
- isEmpty: O(1)
- Size: O(1)

## Implementation Approaches
1. **Array-Based Queue**: Uses a fixed or circular array
2. **Linked List-Based Queue**: Uses a linked list with head and tail pointers
3. **Two-Stack Queue**: Uses two stacks to simulate queue behavior

## Common Applications
- Breadth-First Search (BFS) in graphs
- CPU scheduling and disk scheduling
- IO Buffers, pipes, file IO
- Handling of interrupts in real-time systems
- Call center phone systems
- Asynchronous data transfer (files, IO buffers)
- Buffering in multimedia streaming
- Print spooling
- Traffic management systems

## Variations
- **Circular Queue**: Efficient use of array space by wrapping around
- **Priority Queue**: Elements dequeued based on priority (not FIFO)
- **Deque (Double-ended Queue)**: Insertion/deletion allowed at both ends
- **Blocking Queue**: Blocks operations when empty/full (used in threading)

## When to Use
Use queues when you need FIFO behavior, such as:
- Managing tasks in order of arrival
- Breadth-first traversal
- Handling requests in servers
- Buffering data streams
- Simulating real-world queues

Avoid when you need LIFO behavior or frequent access to middle elements.

## Related Concepts
- **Stack**: Last-In-First-Out (LIFO) counterpart
- **Priority Queue**: Elements served by priority rather than arrival time
- **Deque**: Generalization allowing operations at both ends

## Practice Problems
1. Implement Queue using Stacks
2. Binary Tree Level Order Traversal
3. Design Circular Queue
4. First Unique Number
5. Sliding Window Maximum
6. Moving Average from Data Stream
7. Maximum Frequency Stack
8. Implement Stack using Queues

## Implementation Tips
- For array-based implementation, consider circular arrays to avoid wasting space
- Handle overflow and underflow conditions properly
- For thread-safe queues, consider using concurrent implementations
- Remember that peek operations don't modify the queue

## Further Reading
- "Introduction to Algorithms" by Cormen et al. (Queues section)
- GeeksforGeeks Queue section
- LeetCode Queue problems
- Visualgo.net queue visualization
- Understanding circular buffer implementation
