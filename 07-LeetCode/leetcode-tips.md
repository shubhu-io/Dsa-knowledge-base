# LeetCode Tips & Strategies

## Daily Practice Habits

### Consistency Over Intensity
- Solve at least 1-2 problems daily
- Maintain a streak to build momentum
- Spend 30-60 minutes focused practice minimum
- Review previous solutions weekly

### The Learning Loop
1. **Solve**: Attempt the problem without hints first
2. **Struggle**: Spend appropriate time before looking at solutions
3. **Study**: Read and understand the optimal solution
4. **Implement**: Code the optimal solution from scratch
5. **Review**: Revisit in 3-7 days without looking at notes

## Problem-Solving Framework

### The UMPIRE Method
- **U**nderstand: Clarify problem requirements and constraints
- **M**atch: Identify which pattern or data structure fits
- **P**lan: Outline your approach before coding
- **I**mplement: Write clean, bug-free code
- **R**eview: Check for edge cases and errors
- **E**valuate: Analyze time and space complexity

### Time Allocation

| Phase | Easy | Medium | Hard |
|-------|------|--------|------|
| Understanding | 1 min | 2 min | 3 min |
| Planning | 2 min | 5 min | 8 min |
| Coding | 8 min | 15 min | 25 min |
| Testing | 2 min | 5 min | 7 min |
| **Total** | **15 min** | **30 min** | **45 min** |

## Language-Specific Tips

### Python
```python
# Use collections for efficiency
from collections import defaultdict, deque, Counter

# Dictionary comprehension
squares = {x: x**2 for x in range(10)}

# Unpacking for swaps
a, b = b, a

# Useful built-ins
sorted(nums)         # Returns new sorted list
enumerate(nums)      # Index + value pairs
zip(list1, list2)    # Parallel iteration
any(condition)       # Check if any element satisfies
all(condition)       # Check if all elements satisfy
```

### Java
```java
// Use StringBuilder for string concatenation
StringBuilder sb = new StringBuilder();

// Initialize collections easily
List<Integer> list = new ArrayList<>(Arrays.asList(1, 2, 3));
Map<Integer, Integer> map = new HashMap<>();
Set<Integer> set = new HashSet<>();

// Use Arrays utility methods
Arrays.sort(nums);
Arrays.fill(arr, value);
Arrays.copyOf(arr, length);

// PriorityQueue for min-heap
PriorityQueue<Integer> minHeap = new PriorityQueue<>();
// For max-heap
PriorityQueue<Integer> maxHeap = new PriorityQueue<>(Collections.reverseOrder());
```

### C++
```cpp
// Use STL containers
vector<int> nums;
map<int, int> mp;
set<int> st;
unordered_map<int, int> ump;

// Useful algorithms
sort(nums.begin(), nums.end());
reverse(nums.begin(), nums.end());
*min_element(nums.begin(), nums.end());
*max_element(nums.begin(), nums.end());

// Priority queue
priority_queue<int> maxHeap;
priority_queue<int, vector<int>, greater<int>> minHeap;

// String stream for parsing
stringstream ss(s);
string token;
while (getline(ss, token, delimiter)) { }
```

## Optimization Techniques

### Before You Code
1. **Check Constraints**: This determines your allowed complexity
2. **Identify Edge Cases**: Empty input, single element, all same
3. **Recognize Patterns**: Match to known problem types

### Common Optimizations

| Brute Force | Optimized | Complexity Change |
|-------------|-----------|-------------------|
| Nested loops O(n²) | Hashmap O(n) | Square to linear |
| Sort each time O(n log n) | Single sort O(n log n) | Repeated to once |
| Recursion O(2^n) | DP O(n) | Exponential to polynomial |
| Linear search O(n) | Binary search O(log n) | Linear to logarithmic |

### Space-Time Tradeoffs
- **Use a hashmap** to trade space for time (lookup from O(n) to O(1))
- **Use bit manipulation** to reduce space (bitset vs boolean array)
- **Modify input in-place** when allowed to save space

## Interview-Specific Tips

### Communication
1. **Think aloud**: Share your thought process with the interviewer
2. **Ask questions**: Clarify ambiguous requirements
3. **Start with examples**: Walk through small test cases
4. **Discuss tradeoffs**: Compare approaches before implementing

### Coding Style
1. Write modular functions for complex logic
2. Use meaningful variable names
3. Add brief comments for complex sections
4. Handle edge cases explicitly

### When Stuck
1. **State what you know**: "I know we need to find..."
2. **Identify the block**: "I'm stuck on how to handle..."
3. **Consider simpler cases**: What if n=1 or n=2?
4. **Ask for a hint**: It's better than staying silent
5. **Fall back to brute force**: Show you can solve it suboptimally

## Common Pitfalls

### Technical Mistakes
- **Off-by-one errors**: Always check loop boundaries
- **Integer overflow**: Use long when multiplying large numbers
- **Null pointers**: Check before dereferencing
- **Empty collections**: Handle size-0 cases
- **Infinite recursion**: Ensure base case is reachable

### Interview Mistakes
- **Jumping to code**: Always plan first
- **Ignoring edge cases**: Empty, single, duplicate, overflow
- **Not testing**: Walk through your solution with examples
- **Optimizing prematurely**: Get correct solution first
- **Being silent**: Communicate throughout the process

## Tracking and Review

### Spaced Repetition Schedule
- **Day 1**: Solve the problem
- **Day 3**: Quick review of approach
- **Day 7**: Re-solve without looking at notes
- **Day 14**: Re-solve and compare solutions
- **Day 30**: Final review to confirm mastery

### Progress Metrics to Track
- Problems solved by difficulty
- Time to solve (first attempt vs re-solve)
- Patterns learned
- Weak areas identified
- Contest rating progression

## Contest Tips

### Speed Techniques
1. Read all problems first (2 minutes)
2. Start with the easiest problem
3. Use pre-built templates for common patterns
4. Test with provided examples only (not edge cases for contests)
5. Submit early and iterate if needed

### Virtual Contests
- Practice under timed conditions
- Simulate real contest pressure
- Review all problems after, even solved ones
- Track improvement over time
