# Problem Solving Interview Questions

## Frequently Asked Questions

### Conceptual Questions

**Q: What is the difference between brute force and optimal solution?**
A: Brute force tries all possible solutions (exponential time). Optimal solutions use patterns/algorithms to reduce time complexity (polynomial or better).

**Q: How do you approach a problem you've never seen before?**
A: 
1. Read and understand the problem
2. Work through examples by hand
3. Identify patterns or similar problems
4. Start with brute force
5. Optimize step by step

**Q: What is the importance of analyzing time and space complexity?**
A: It helps determine if a solution will meet performance requirements and scale with input size.

### Problem Solving Scenarios

**Q: You're given an unsorted array. Find two numbers that add up to a target.**
A: Use HashMap approach (O(n) time, O(n) space) or Two Pointers if sorted (O(n) time, O(1) space).

**Q: Design a function to check if a string is a palindrome.**
A: Two pointer approach from both ends, comparing characters. Handle case sensitivity and non-alphanumeric characters.

**Q: Find the maximum subarray sum.**
A: Kadane's algorithm - track current sum and max sum, reset current sum when it goes negative.

### Behavioral Questions

**Q: Describe a time you solved a complex problem.**
A: Use STAR method:
- Situation: Set the context
- Task: What was your responsibility
- Action: What you did
- Result: The outcome

**Q: How do you handle debugging complex issues?**
A: 
1. Reproduce the issue consistently
2. Add logging/print statements
3. Use debugger to step through code
4. Check edge cases
5. Review recent changes
6. Ask for help if stuck > 30 minutes

## Problem Solving Frameworks

### STAR Method
- **S**ituation: Context
- **T**ask: Your responsibility
- **A**ction: What you did
- **R**esult: Outcome

### PDCA Cycle
- **P**lan: Design the solution
- **D**o: Implement it
- **C**heck: Test and verify
- **A**ct: Improve or move on

### 5 Whys
Keep asking "why" to find root cause of problems.

## Tips for Technical Interviews

1. Think out loud - interviewers want to see your process
2. Start with the simplest solution
3. Ask clarifying questions
4. Test your solution with examples
5. Be open to hints
6. Stay calm and composed