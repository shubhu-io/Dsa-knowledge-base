# Data Structures and Algorithms (DSA) - Q&A

## Common DSA Interview Questions

### Arrays & Strings
1. **Q**: How do you reverse an array in place?
   **A**: Use two pointers (start and end) and swap elements until they meet.

2. **Q**: How do you check if two strings are anagrams?
   **A**: Sort both strings and compare, or use character frequency counting.

3. **Q**: How do you find the maximum subarray sum?
   **A**: Use Kadane's algorithm (O(n) time complexity).

### Linked Lists
1. **Q**: How do you reverse a linked list?
   **A**: Iteratively or recursively by changing the next pointers.

2. **Q**: How do you detect a cycle in a linked list?
   **A**: Use Floyd's cycle-finding algorithm (tortoise and hare).

3. **Q**: How do you find the middle element of a linked list?
   **A**: Use slow and fast pointers (fast moves two steps, slow one step).

### Trees & Graphs
1. **Q**: What is the difference between BFS and DFS?
   **A**: BFS uses a queue and explores level by level; DFS uses a stack (or recursion) and goes deep first.

2. **Q**: How do you check if a binary tree is balanced?
   **A**: Check if the height difference between left and right subtrees is at most 1 for every node.

3. **Q**: What is Dijkstra's algorithm used for?
   **A**: Finding the shortest path from a single source to all other nodes in a weighted graph.

### Sorting & Searching
1. **Q**: What is the time complexity of quicksort in the worst case?
   **A**: O(n²) - occurs when the pivot is consistently the smallest or largest element.

2. **Q**: When would you use merge sort over quicksort?
   **A**: When you need stable sort or guaranteed O(n log n) time complexity.

3. **Q**: How does binary search work?
   **A**: Repeatedly divide the search interval in half until the target is found or the interval is empty.

### Dynamic Programming
1. **Q**: What is the difference between memoization and tabulation?
   **A**: Memoization is top-down (recursive with caching); tabulation is bottom-up (iterative table filling).

2. **Q**: How do you solve the Fibonacci sequence using DP?
   **A**: Use memoization to store previously computed values to avoid redundant calculations.

3. **Q**: What is the longest common subsequence (LCS) problem?
   **A**: Find the longest subsequence common to two sequences (not necessarily contiguous).

### System Design & Advanced Topics
1. **Q**: How would you design a URL shortener like bit.ly?
   **A**: Use hash functions to map long URLs to short codes, handle collisions, and design for scalability.

2. **Q**: What is a Bloom filter?
   **A**: A probabilistic data structure for testing set membership with false positives possible.

3. **Q**: Explain the CAP theorem.
   **A**: In a distributed system, you can only guarantee two out of three: Consistency, Availability, Partition tolerance.

## Tips for Answering DSA Questions
1. **Clarify the problem**: Ask clarifying questions before jumping to solution.
2. **Think aloud**: Explain your thought process as you work through the problem.
3. **Start with brute force**: Mention a naive solution first, then optimize.
4. **Consider edge cases**: Empty inputs, single elements, large values, etc.
5. **Discuss trade-offs**: Time vs. space complexity, readability vs. performance.
6. **Test your solution**: Walk through your code with sample inputs.
7. **Stay calm**: If stuck, explain what you're thinking and ask for hints.

## Practice Resources
- **LeetCode**: Start with Easy problems, then Medium, then Hard
- **HackerRank**: Good for language-specific practice
- **GeeksforGeeks**: Excellent explanations and visualizations
- **Interview Cake**: Focuses on interview-specific problem solving
- **Cracking the Coding Interview** (book): Classic interview preparation guide

Remember: The goal is not just to solve the problem, but to demonstrate your problem-solving process and communication skills.