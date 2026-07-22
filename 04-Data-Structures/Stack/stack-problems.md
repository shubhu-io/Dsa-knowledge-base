# Stack Problems

## Easy Problems

### 1. Valid Parentheses
**Problem**: Given a string s containing just the characters '(', ')', '{', '}', '[' and ']', determine if the input string is valid.

An input string is valid if:
1. Open brackets must be closed by the same type of brackets.
2. Open brackets must be closed in the correct order.
3. Every close bracket has a corresponding open bracket of the same type.

**Example**:
```
Input: s = "()[]{}"
Output: true
```

**Solution Approach**:
- Use a stack to track opening brackets
- When encountering a closing bracket, check if it matches the top of the stack
- Time: O(n), Space: O(n)

**Python Solution**:
```python
def is_valid(s):
    stack = []
    mapping = {')': '(', '}': '{', ']': '['}
    
    for char in s:
        if char in mapping:  # Closing bracket
            if stack and stack[-1] == mapping[char]:
                stack.pop()
            else:
                return False
        else:  # Opening bracket
            stack.append(char)
    
    return not stack
```

### 2. Implement Queue using Stacks
**Problem**: Implement a first in first out (FIFO) queue using only two stacks. The implemented queue should support all the functions of a normal queue (push, peek, pop, and empty).

**Example**:
```
Input
["MyQueue", "push", "push", "peek", "pop", "empty"]
[[], [1], [2], [], [], []]
Output
[null, null, null, 1, 1, false]
```

**Solution Approach**:
- Use two stacks: stack1 for incoming elements, stack2 for outgoing elements
- When popping or peeking, if stack2 is empty, transfer all elements from stack1 to stack2
- Time: Amortized O(1) per operation, space: O(n)

**Python Solution**:
```python
class MyQueue:
    def __init__(self):
        self.stack1 = []  # For push operations
        self.stack2 = []  # For pop/peek operations
    
    def push(self, x: int) -> None:
        self.stack1.append(x)
    
    def pop(self) -> int:
        self.peek()  # Ensure stack2 has elements if needed
        return self.stack2.pop()
    
    def peek(self) -> int:
        if not self.stack2:
            while self.stack1:
                self.stack2.append(self.stack1.pop())
        return self.stack2[-1]
    
    def empty(self) -> bool:
        return not self.stack1 and not self.stack2
```

### 3. Min Stack
**Problem**: Design a stack that supports push, pop, top, and retrieving the minimum element in constant time.

Implement the MinStack class:
- MinStack() initializes the stack object.
- void push(int val) pushes the element val onto the stack.
- void pop() removes the element on the top of the stack.
- int top() gets the top element of the stack.
- int getMin() retrieves the minimum element in the stack.

**Example**:
```
Input
["MinStack","push","push","push","getMin","pop","top","getMin"]
[[],[-2],[0],[-3],[],[],[],[]]
Output
[null,null,null,0,-3,3,0]
```

**Solution Approach**:
- Use two stacks: one for all elements, one for tracking minimum values
- When pushing, also push to min stack if value is less than or equal to current min
- When popping, also pop from min stack if the popped value equals current min
- Time: O(1) for all operations, Space: O(n)

**Python Solution**:
```python
class MinStack:
    def __init__(self):
        self.stack = []
        self.min_stack = []
    
    def push(self, val: int) -> None:
        self.stack.append(val)
        if not self.min_stack or val <= self.min_stack[-1]:
            self.min_stack.append(val)
    
    def pop(self) -> None:
        if self.stack:
            val = self.stack.pop()
            if val == self.min_stack[-1]:
                self.min_stack.pop()
    
    def top(self) -> int:
        if self.stack:
            return self.stack[-1]
        raise IndexError("Stack is empty")
    
    def getMin(self) -> int:
        if self.min_stack:
            return self.min_stack[-1]
        raise IndexError("Stack is empty")
```

### 4. Baseball Game
**Problem**: You are keeping the scores for a baseball game with strange rules. At the beginning of the game, you start with an empty record. You are given a list of strings operations, where operations[i] is the i-th operation you must apply to the record and is one of the following:
- An integer x: Record a new score of x.
- '+': Record a new score that is the sum of the previous two scores.
- 'D': Record a new score that is double the previous score.
- 'C': Invalidate the previous score, removing it from the record.

**Example**:
```
Input: ops = ["5","2","C","D","+"]
Output: 30
Explanation:
"5" - Add 5 to the record, record is now [5].
"2" - Add 2 to the record, record is now [5, 2].
"C" - Invalidate and remove the previous score, record is now [5].
"D" - Add 2 * 5 = 10 to the record, record is now [5, 10].
"+" - Add 5 + 10 = 15 to the record, record is now [5, 10, 15].
The total sum is 5 + 10 + 15 = 30.
```

**Solution Approach**:
- Use a stack to keep track of valid scores
- Process each operation according to its type
- Time: O(n), Space: O(n)

**Python Solution**:
```python
def cal_points(ops):
    stack = []
    
    for op in ops:
        if op == "+":
            # Sum of last two scores
            stack.append(stack[-1] + stack[-2])
        elif op == "D":
            # Double the last score
            stack.append(2 * stack[-1])
        elif op == "C":
            # Remove last score
            stack.pop()
        else:
            # Integer score
            stack.append(int(op))
    
    return sum(stack)
```

### 5. Backspace String Compare
**Problem**: Given two strings s and t, return true if they are equal when both are typed into empty text editors. '#' means a backspace character.

**Example**:
```
Input: s = "ab#c", t = "ad#c"
Output: true
Explanation: Both s and t become "ac".
```

**Solution Approach**:
- Use stack to process each string, applying backspaces
- Compare the resulting strings
- Time: O(n+m), Space: O(n+m)

**Python Solution**:
```python
def backspace_compare(s, t):
    def build_string(string):
        stack = []
        for char in string:
            if char == '#':
                if stack:
                    stack.pop()
            else:
                stack.append(char)
        return ''.join(stack)
    
    return build_string(s) == build_string(t)
```

## Medium Problems

### 1. Daily Temperatures
**Problem**: Given an array of integers temperatures represents the daily temperatures, return an array answer such that answer[i] is the number of days you have to wait after the i-th day to get a warmer temperature. If there is no future day for which this is possible, keep answer[i] == 0 instead.

**Example**:
```
Input: temperatures = [73,74,75,71,69,72,76,73]
Output: [1,1,4,2,1,1,0,0]
```

**Solution Approach**:
- Use a stack to store indices of temperatures
- Iterate through temperatures, and for each temperature, pop from stack while current temperature is greater than stack's top temperature
- Update result for popped indices
- Time: O(n), Space: O(n)

**Python Solution**:
```python
def daily_temperatures(temperatures):
    result = [0] * len(temperatures)
    stack = []  # Stores indices
    
    for i, temp in enumerate(temperatures):
        while stack and temp > temperatures[stack[-1]]:
            prev_index = stack.pop()
            result[prev_index] = i - prev_index
        stack.append(i)
    
    return result
```

### 2. Maximum Frequency Stack
**Problem**: Implement FreqStack, a class which simulates the operation of a stack-like data structure.

FreqStack has two functions:
- push(int x): pushes an integer x onto the stack.
- pop(): removes and returns the most frequent element in the stack.
  - If there is a tie for most frequent element, the element closest to the top of the stack is returned.

**Example**:
```
Input
["FreqStack","push","push","push","push","push","push","pop","pop","pop","pop"],
[[],[5],[7],[5],[7],[4],[5],[],[],[],[]]
Output
[null,null,null,null,null,null,null,5,7,5,4]
```

**Solution Approach**:
- Use two dictionaries: one for frequency of elements, one for grouping elements by frequency
- Track max frequency
- When pushing, update frequency and add to corresponding frequency group
- When popping, remove from max frequency group, update max if needed
- Time: O(1) for both operations, Space: O(n)

**Python Solution**:
```python
from collections import defaultdict

class FreqStack:
    def __init__(self):
        self.freq = defaultdict(int)  # Maps value -> frequency
        self.group = defaultdict(list)  # Maps frequency -> list of values
        self.maxfreq = 0
    
    def push(self, val: int) -> None:
        self.freq[val] += 1
        if self.freq[val] > self.maxfreq:
            self.maxfreq = self.freq[val]
        self.group[self.freq[val]].append(val)
    
    def pop(self) -> int:
        val = self.group[self.maxfreq].pop()
        self.freq[val] -= 1
        if not self.group[self.maxfreq]:
            self.maxfreq -= 1
        return val
```

### 3. Remove All Adjacent Duplicates in String II
**Problem**: You are given a string s and an integer k, a k duplicate removal consists of choosing k adjacent and equal letters from s and removing them, causing the left and the right side of the deleted substring to concatenate together.

We repeatedly make k duplicate removals on s until we no longer can.

**Example**:
```
Input: s = "deeedbbcccbdaa", k = 3
Output: "aa"
```

**Solution Approach**:
- Use stack to store pairs of (character, count)
- Iterate through string, updating count for consecutive characters
- When count reaches k, pop from stack
- Time: O(n), Space: O(n)

**Python Solution**:
```python
def remove_duplicates(s, k):
    stack = []  # Each element is [character, count]
    
    for char in s:
        if stack and stack[-1][0] == char:
            stack[-1][1] += 1
            if stack[-1][1] == k:
                stack.pop()
        else:
            stack.append([char, 1])
    
    # Reconstruct string
    result = []
    for char, count in stack:
        result.append(char * count)
    return ''.join(result)
```

### 4. Basic Calculator
**Problem**: Given a string s representing a valid expression, implement a basic calculator to evaluate it.

**Example**:
```
Input: s = "1 + 1"
Output: 2
```

**Solution Approach**:
- Use stack to handle parentheses and signs
- Iterate through string, processing numbers and operators
- When encountering '(', push current result and sign to stack
- When encountering ')', pop sign and previous result from stack
- Time: O(n), Space: O(n)

**Python Solution**:
```python
def calculate(s):
    stack = []
    result = 0
    sign = 1  # 1 for positive, -1 for negative
    i = 0
    
    while i < len(s):
        char = s[i]
        if char.isdigit():
            # Parse full number
            num = 0
            while i < len(s) and s[i].isdigit():
                num = num * 10 + int(s[i])
                i += 1
            result += sign * num
            continue  # Skip the increment at end of loop
        elif char == '+':
            sign = 1
        elif char == '-':
            sign = -1
        elif char == '(':
            # Push current result and sign to stack
            stack.append(result)
            stack.append(sign)
            # Reset result and sign for new sub-expression
            result = 0
            sign = 1
        elif char == ')':
            # Pop sign and previous result
            result *= stack.pop()  # Apply sign
            result += stack.pop()  # Add previous result
        i += 1
    
    return result
```

### 5. Decode String
**Problem**: Given an encoded string, return its decoded string.

The encoding rule is: k[encoded_string], where the encoded_string inside the square brackets is being repeated exactly k times. Note that k is guaranteed to be a positive integer.

**Example**:
```
Input: s = "3[a]2[bc]"
Output: "aaabcbc"
```

**Solution Approach**:
- Use two stacks: one for counts, one for strings
- When encountering digits, build the complete number
- When encountering '[', push current string and count to stacks
- When encountering ']', pop from stacks and build repeated string
- Otherwise, append character to current string
- Time: O(n), Space: O(n)

**Python Solution**:
```python
def decode_string(s):
    stack = []
    current_num = 0
    current_str = ''
    
    for char in s:
        if char.isdigit():
            # Build complete number
            current_num = current_num * 10 + int(char)
        elif char == '[':
            # Push current state to stacks
            stack.append(current_str)
            stack.append(current_num)
            # Reset for new substring
            current_str = ''
            current_num = 0
        elif char == ']':
            # Pop count and previous string
            num = stack.pop()
            prev_str = stack.pop()
            # Build repeated string
            current_str = prev_str + current_str * num
        else:
            # Regular character
            current_str += char
    
    return current_str
```

## Hard Problems

### 1. Largest Rectangle in Histogram
**Problem**: Given an array of integers heights representing the histogram's bar height where the width of each bar is 1, return the area of the largest rectangle in the histogram.

**Example**:
```
Input: heights = [2,1,5,6,2,3]
Output: 10
```

**Solution Approach**:
- Use stack to store indices of bars in increasing order of height
- When encountering a bar shorter than stack top, calculate area for bars in stack
- Add sentinel values at beginning and end to handle edge cases
- Time: O(n), Space: O(n)

**Python Solution**:
```python
def largest_rectangle_area(heights):
    # Add sentinels
    heights = [0] + heights + [0]
    stack = [0]  # Store indices
    max_area = 0
    
    for i in range(1, len(heights)):
        # While current bar is lower than stack top
        while heights[i] < heights[stack[-1]]:
            height = heights[stack.pop()]
            width = i - stack[-1] - 1
            max_area = max(max_area, height * width)
        stack.append(i)
    
    return max_area
```

### 2. Trapping Rain Water II
**Problem**: Given an m x n integer matrix heightMap representing the height of each unit cell in a 2D elevation map, return the volume of water it can trap after raining.

**Example**:
```
Input: heightMap = [[1,4,3,1,3,2],[3,2,1,3,2,4],[2,3,3,2,3,1]]
Output: 4
```

**Solution Approach**:
- Use priority queue (min-heap) to simulate water filling from boundaries
- Start from boundary cells, process lowest height first
- For each cell, check neighbors and calculate trapped water
- Time: O(mn log(mn)), Space: O(mn)

**Python Solution**:
```python
import heapq

def trap_rain_water(heightMap):
    if not heightMap or not heightMap[0]:
        return 0
    
    m, n = len(heightMap), len(heightMap[0])
    visited = [[False] * n for _ in range(m)]
    heap = []
    
    # Add all boundary cells to heap
    for i in range(m):
        for j in [0, n-1]:
            heapq.heappush(heap, (heightMap[i][j], i, j))
            visited[i][j] = True
    for j in range(n):
        for i in [0, m-1]:
            if not visited[i][j]:
                heapq.heappush(heap, (heightMap[i][j], i, j))
                visited[i][j] = True
    
    result = 0
    directions = [(0,1), (0,-1), (1,0), (-1,0)]
    
    while heap:
        height, x, y = heapq.heappop(heap)
        for dx, dy in directions:
            nx, ny = x + dx, y + dy
            if 0 <= nx < m and 0 <= ny < n and not visited[nx][ny]:
                # Water trapped is max(0, current height - neighbor height)
                result += max(0, height - heightMap[nx][ny])
                # Push neighbor with max height (current or neighbor)
                heapq.heappush(heap, (max(height, heightMap[nx][ny]), nx, ny))
                visited[nx][ny] = True
    
    return result
```

### 3. Remove K Digits
**Problem**: Given string num representing a non-negative integer num and an integer k, return the smallest possible integer after removing k digits from num.

**Example**:
```
Input: num = "1432219", k = 3
Output: "1219"
```

**Solution Approach**:
- Use stack to build result string
- Iterate through digits, and while we can remove digits (k > 0) and stack is not empty and top of stack > current digit, pop from stack
- Push current digit to stack
- If still have k > 0 after processing, remove from end
- Remove leading zeros
- Time: O(n), Space: O(n)

**Python Solution**:
```python
def remove_k_digits(num, k):
    if len(num) <= k:
        return "0"
    
    stack = []
    
    for digit in num:
        # While we can remove and last digit in stack is larger than current
        while k > 0 and stack and stack[-1] > digit:
            stack.pop()
            k -= 1
        stack.append(digit)
    
    # If still need to remove digits, remove from end
    if k > 0:
        stack = stack[:-k]
    
    # Remove leading zeros
    result = ''.join(stack).lstrip('0')
    return result if result else "0"
```

### 4. Next Greater Element II
**Problem**: Given a circular integer array nums (i.e., the next element of nums[nums.length - 1] is nums[0]), return the next greater number for every element in nums.

The next greater number of a number x is the first greater number to its right in the array. If it doesn't exist, return -1 for this number.

**Example**:
```
Input: nums = [1,2,1]
Output: [2,-1,2]
```

**Solution Approach**:
- Use stack to store indices
- Iterate through array twice (to handle circular nature)
- For each element, pop from stack while current element is greater than stack's top element
- Push current index to stack
- Time: O(n), Space: O(n)

**Python Solution**:
```python
def next_greater_elements(nums):
    n = len(nums)
    result = [-1] * n
    stack = []  # Stores indices
    
    # Iterate twice to handle circular nature
    for i in range(2 * n):
        curr_index = i % n
        while stack and nums[curr_index] > nums[stack[-1]]:
            top_index = stack.pop()
            result[top_index] = nums[curr_index]
        if i < n:  # Only push during first pass
            stack.append(curr_index)
    
    return result
```

### 5. Sum of Subarray Minimums
**Problem**: Given an array of integers arr, find the sum of min(b), where b ranges over every (contiguous) subarray of arr. Since the answer may be large, return the answer modulo 10^9 + 7.

**Example**:
```
Input: arr = [3,1,2,4]
Output: 17
```

**Solution Approach**:
- Use monotonic stack to find previous less element and next less element for each element
- For each element, calculate how many subarrays it is the minimum of
- Sum up contributions of all elements
- Time: O(n), Space: O(n)

**Python Solution**:
```python
def sum_subarray_mins(arr):
    MOD = 10**9 + 7
    n = len(arr)
    
    # Arrays to store distances to previous/lesser elements
    left = [0] * n  # Distance to previous less element
    right = [0] * n  # Distance to next less element
    
    # Monotonic increasing stack for previous less
    stack = []
    for i in range(n):
        count = 1
        while stack and stack[-1][0] > arr[i]:
            count += stack.pop()[1]
        left[i] = count
        stack.append((arr[i], count))
    
    # Clear stack for next less
    stack = []
    for i in range(n-1, -1, -1):
        count = 1
        while stack and stack[-1][0] >= arr[i]:
            count += stack.pop()[1]
        right[i] = count
        stack.append((arr[i], count))
    
    # Calculate result
    result = 0
    for i in range(n):
        result = (result + arr[i] * left[i] * right[i]) % MOD
    
    return result
```

## Additional Practice Problems

### Easy
1. Implement Stack using Linked List
2. Implement Stack using Array
3. Check for Balanced Parentheses in an Expression
4. Reverse a Stack using Recursion
5. Sort a Stack using Recursion
6. Next Greater Element
7. Previous Greater Element
8. Stock Span Problem
9. Infix to Postfix Conversion
10. Postfix Expression Evaluation

### Medium
1. LRU Cache Implementation
2. Maximum of Minimum for Every Window Size
3. Celebrity Problem
4. The Celebrity Problem
5. Reverse First K Elements of Queue
6. Interleave First Half of Queue with Second Half
7. Generate Binary Numbers
8. Implement Stack using Queues
9. Implement Queue using Stacks (already covered)
10. Next Greater Element III

### Hard
1. Maximum Rectangle in Binary Matrix
2. Sum of Subarray Maximums
3. Minimum Cost Tree From Leaf Values
4. Maximum Binary Tree
5. Construct Binary Tree from String
6. Remove All Adjacent Duplicates in String II (already covered)
7. Make String Great
8. Maximum Binary Tree II
9. Print Binary Tree in 2D
10. Binary Tree Zigzag Level Order Traversal

## Summary
Stacks are fundamental data structures that excel in scenarios requiring Last-In-First-Out (LIFO) behavior. Mastering stack-based problems is crucial for technical interviews as they test your ability to recognize when a problem fits the stack paradigm and apply appropriate stack-based solutions.

Key patterns to remember:
- **Monotonic Stack**: Maintaining stack in sorted order (increasing or decreasing) for problems like next greater element, largest rectangle in histogram
- **Two Stacks**: Using one stack for input, another for output (e.g., queue implementation with stacks)
- **Stack with Additional Tracking**: Using auxiliary stacks to track min/max values
- **String Processing**: Using stacks for parsing, validation, and transformation of strings
- **Recursion Simulation**: Using explicit stack to simulate recursive function calls

When solving stack problems, always consider:
1. Whether the problem involves LIFO behavior
2. What information needs to be stored in each stack element
3. How to efficiently retrieve required information (sometimes requiring auxiliary data structures)
4. Edge cases: empty input, single element, all same elements, alternating patterns
5. Time and space complexity optimization
6. Whether to use array-based or linked-list-based implementation based on requirements

Common real-world applications of stacks include:
- Function call management in programming languages
- Undo/redo functionality in applications
- Expression evaluation and parsing (compilers, calculators)
- Backtracking algorithms (maze solving, game AI)
- Navigation history (web browsers)
- Syntax validation (bracket matching, HTML/XML parsing)
- Memory management (stack allocation, garbage collection)
- Algorithm implementations (DFS, iterative tree traversals)

By practicing these problems and understanding the underlying patterns, you'll develop the intuition needed to quickly recognize when a stack-based approach is appropriate and implement efficient solutions.