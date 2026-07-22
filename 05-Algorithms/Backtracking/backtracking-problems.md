# Backtracking Problems

This file contains a comprehensive collection of backtracking problems organized by difficulty level, each with detailed explanations, examples, and solutions.

## Easy Problems

### 1. Generate Parentheses
**Problem**: Given n pairs of parentheses, write a function to generate all combinations of well-formed parentheses.

**Examples**:
```
Input: n = 3
Output: ["((()))","(()())","(())()","()(())","()()()"]

Input: n = 1
Output: ["()"]
```

**Constraints**:
- 1 <= n <= 8

**Solution Approach**:
Use backtracking to build strings by adding '(' or ')' while maintaining:
1. Number of '(' <= n
2. Number of ')' <= number of '(' (to ensure validity)

**Algorithm**:
- Start with empty string and counts of open/close parentheses = 0
- At each step, if we can add '(', do so and recurse
- If we can add ')' (more opens than closes), do so and recurse
- When string length = 2*n, add to result

**Python Solution**:
```python
def generateParenthesis(n):
    def backtrack(s, left, right):
        if len(s) == 2 * n:
            result.append(s)
            return
        if left < n:
            backtrack(s + '(', left + 1, right)
        if right < left:
            backtrack(s + ')', left, right + 1)
    
    result = []
    backtrack('', 0, 0)
    return result
```

**Java Solution**:
```java
public List<String> generateParenthesis(int n) {
    List<String> result = new ArrayList<>();
    backtrack(result, new StringBuilder(), 0, 0, n);
    return result;
}

private void backtrack(List<String> result, StringBuilder current, int open, int close, int max) {
    if (current.length() == 2 * max) {
        result.add(current.toString());
        return;
    }
    
    if (open < max) {
        current.append('(');
        backtrack(result, current, open + 1, close, max);
        current.deleteCharAt(current.length() - 1);
    }
    
    if (close < open) {
        current.append(')');
        backtrack(result, current, open, close + 1, max);
        current.deleteCharAt(current.length() - 1);
    }
}
```

**Time Complexity**: O(4^n / sqrt(n)) - Catalan number
**Space Complexity**: O(n) for recursion stack + O(4^n / sqrt(n)) for output

---

### 2. Subsets (Power Set)
**Problem**: Given an integer array `nums` of unique elements, return all possible subsets (the power set).

**Examples**:
```
Input: nums = [1,2,3]
Output: [[],[1],[2],[1,2],[3],[1,3],[2,3],[1,2,3]]

Input: nums = [0]
Output: [[],[0]]
```

**Solution Approach**:
For each element, we have two choices: include it or exclude it.
Use backtracking to explore both choices.

**Algorithm**:
- Start with empty subset
- At each index i, we can either:
  - Exclude nums[i] and move to i+1
  - Include nums[i] and move to i+1
- When we reach end of array, add current subset to result

**Python Solution**:
```python
def subsets(nums):
    def backtrack(start, path):
        result.append(list(path))
        
        for i in range(start, len(nums)):
            path.append(nums[i])
            backtrack(i + 1, path)
            path.pop()  # Backtrack
    
    result = []
    backtrack(0, [])
    return result
```

**Alternative Simple Approach**:
```python
def subsets(nums):
    result = [[]]
    for num in nums:
        result += [curr + [num] for curr in result]
    return result
```

**Time Complexity**: O(n * 2^n) - n for copying each subset
**Space Complexity**: O(n) for recursion stack + O(n * 2^n) for output

---

### 3. Permutations
**Problem**: Given an array `nums` of distinct integers, return all possible permutations.

**Examples**:
```
Input: nums = [1,2,3]
Output: [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]

Input: nums = [0,1]
Output: [[0,1],[1,0]]
```

**Solution Approach**:
Build permutations by selecting each unused element at each position.

**Algorithm**:
- Use a boolean array to track which elements are used
- At each position, try each unused element
- Mark as used, recurse, then unmark (backtrack)

**Python Solution**:
```python
def permute(nums):
    def backtrack(path, used):
        if len(path) == len(nums):
            result.append(list(path))
            return
        
        for i in range(len(nums)):
            if not used[i]:
                used[i] = True
                path.append(nums[i])
                backtrack(path, used)
                path.pop()
                used[i] = False
    
    result = []
    backtrack([], [False] * len(nums))
    return result
```

**Java Solution**:
```java
public List<List<Integer>> permute(int[] nums) {
    List<List<Integer>> result = new ArrayList<>();
    List<Integer> current = new ArrayList<>();
    boolean[] used = new boolean[nums.length];
    backtrack(nums, result, current, used);
    return result;
}

private void backtrack(int[] nums, List<List<Integer>> result, 
                      List<Integer> current, boolean[] used) {
    if (current.size() == nums.length) {
        result.add(new ArrayList<>(current));
        return;
    }
    
    for (int i = 0; i < nums.length; i++) {
        if (!used[i]) {
            used[i] = true;
            current.add(nums[i]);
            backtrack(nums, result, current, used);
            current.remove(current.size() - 1);
            used[i] = false;
        }
    }
}
```

**Time Complexity**: O(n * n!) - n! permutations, each of length n
**Space Complexity**: O(n) for recursion stack + O(n * n!) for output

---

### 4. Combination Sum
**Problem**: Given an array of distinct integers `candidates` and a target integer `target`, return a list of all unique combinations of candidates where the chosen numbers sum to target. You may return the combinations in any order.

**Examples**:
```
Input: candidates = [2,3,6,7], target = 7
Output: [[2,2,3],[7]]
Explanation: 2 and 3 are candidates, and 2 + 2 + 3 = 7. Note that 2 can be used multiple times.

Input: candidates = [2,3,5], target = 8
Output: [[2,2,2,2],[2,3,3],[3,5]]
```

**Solution Approach**:
Use backtracking to try each candidate, allowing reuse of same element.

**Algorithm**:
- Sort candidates to help with pruning
- At each step, try each candidate from current index onward
- Subtract candidate value from target
- If target == 0, add combination to result
- If target < 0, backtrack (prune)

**Python Solution**:
```python
def combinationSum(candidates, target):
    def backtrack(start, path, remaining):
        if remaining == 0:
            result.append(list(path))
            return
        if remaining < 0:
            return
        
        for i in range(start, len(candidates)):
            # Since we can reuse same element, we start from i (not i+1)
            if candidates[i] > remaining:  # Pruning
                break
            
            path.append(candidates[i])
            backtrack(i, path, remaining - candidates[i])  # Not i+1 because reuse allowed
            path.pop()  # Backtrack
    
    result = []
    candidates.sort()  # For effective pruning
    backtrack(0, [], target)
    return result
```

**Time Complexity**: O(N^(T/M + 1)) where N = number of candidates, T = target, M = min candidate value
**Space Complexity**: O(T/M) for recursion depth

---

### 5. Word Search
**Problem**: Given an m x n grid of characters `board` and a string `word`, return true if word exists in the grid.

**Examples**:
```
Input: board = [["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]], word = "ABCCED"
Output: true

Input: board = [["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]], word = "SEE"
Output: true

Input: board = [["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]], word = "ABCB"
Output: false
```

**Solution Approach**:
Use backtracking to try starting from each cell and explore neighbors.

**Algorithm**:
- For each cell in board, if it matches first char of word, start DFS
- In DFS: if current char matches word[index], mark visited and explore 4 directions
- If we reach end of word, return true
- Backtrack by unmarking visited cell

**Python Solution**:
```python
def exist(board, word):
    def backtrack(row, col, index):
        if index == len(word):
            return True
        
        # Check boundaries and character match
        if (row < 0 or row >= len(board) or 
            col < 0 or col >= len(board[0]) or
            board[row][col] != word[index]):
            return False
        
        # Mark as visited
        temp = board[row][col]
        board[row][col] = '#'
        
        # Explore 4 directions
        found = (backtrack(row + 1, col, index + 1) or
                backtrack(row - 1, col, index + 1) or
                backtrack(row, col + 1, index + 1) or
                backtrack(row, col - 1, index + 1))
        
        # Backtrack
        board[row][col] = temp
        return found
    
    for i in range(len(board)):
        for j in range(len(board[0])):
            if backtrack(i, j, 0):
                return True
    return False
```

**Time Complexity**: O(m * n * 4^L) where L = length of word
**Space Complexity**: O(L) for recursion stack

---

### 6. Combinations
**Problem**: Given two integers n and k, return all possible combinations of k numbers chosen from the range [1, n].

**Examples**:
```
Input: n = 4, k = 2
Output: [[1,2],[1,3],[1,4],[2,3],[2,4],[3,4]]
Explanation: There are 4 choose 2 = 6 combinations.

Input: n = 1, k = 1
Output: [[1]]
```

**Solution Approach**:
Similar to subsets but with fixed size k.

**Algorithm**:
- Start from 1, try to build combinations of size k
- At each step, we can choose a number from current to n
- When we have k numbers, add to result

**Python Solution**:
```python
def combine(n, k):
    def backtrack(start, path):
        if len(path) == k:
            result.append(list(path))
            return
        
        for i in range(start, n + 1):
            path.append(i)
            backtrack(i + 1, path)
            path.pop()
    
    result = []
    backtrack(1, [])
    return result
```

**Time Complexity**: O(k * C(n,k)) where C(n,k) is binomial coefficient
**Space Complexity**: O(k) for recursion stack + O(k * C(n,k)) for output

---

## Medium Problems

### 7. Combination Sum II
**Problem**: Given a collection of candidate numbers (candidates) and a target number (target), find all unique combinations in candidates where the candidate numbers sum to target. Each number in candidates may only be used once in the combination.

**Examples**:
```
Input: candidates = [10,1,2,7,6,1,5], target = 8
Output: [[1,1,6],[1,2,5],[1,7],[2,6]]

Input: candidates = [2,5,2,1,2], target = 5
Output: [[1,2,2],[5]]
```

**Solution Approach**:
Similar to Combination Sum but with duplicates and each element used once.

**Key Differences from Combination Sum**:
1. Each element can be used only once (move to i+1)
2. Need to handle duplicates in input

**Algorithm**:
- Sort candidates to group duplicates
- Skip duplicates at same recursion level
- Use each element only once (call with i+1)

**Python Solution**:
```python
def combinationSum2(candidates, target):
    def backtrack(start, path, remaining):
        if remaining == 0:
            result.append(list(path))
            return
        if remaining < 0:
            return
        
        prev = -1  # To track duplicates at same level
        for i in range(start, len(candidates)):
            # Skip duplicates
            if candidates[i] == prev:
                continue
            # Pruning
            if candidates[i] > remaining:
                break
            
            path.append(candidates[i])
            backtrack(i + 1, path, remaining - candidates[i])  # i+1 because no reuse
            path.pop()
            prev = candidates[i]
    
    result = []
    candidates.sort()
    backtrack(0, [], target)
    return result
```

**Time Complexity**: O(2^n) in worst case
**Space Complexity**: O(n) for recursion stack

---

### 8. Letter Combinations of a Phone Number
**Problem**: Given a string containing digits from 2-9 inclusive, return all possible letter combinations that the number could represent.

**Examples**:
```
Input: digits = "23"
Output: ["ad","ae","af","bd","be","bf","cd","ce","cf"]

Input: digits = ""
Output: []

Input: digits = "2"
Output: ["a","b","c"]
```

**Mapping**:
```
2: abc, 3: def, 4: ghi, 5: jkl, 6: mno,
7: pqrs, 8: tuv, 9: wxyz
```

**Solution Approach**:
For each digit, try all possible letters and recurse.

**Algorithm**:
- Create mapping from digits to letters
- Use backtracking to build combinations
- At each position, try all letters for current digit

**Python Solution**:
```python
def letterCombinations(digits):
    if not digits:
        return []
    
    phone_map = {
        '2': 'abc', '3': 'def', '4': 'ghi', '5': 'jkl',
        '6': 'mno', '7': 'pqrs', '8': 'tuv', '9': 'wxyz'
    }
    
    def backtrack(index, path):
        if index == len(digits):
            result.append(''.join(path))
            return
        
        possible_letters = phone_map[digits[index]]
        for letter in possible_letters:
            path.append(letter)
            backtrack(index + 1, path)
            path.pop()
    
    result = []
    backtrack(0, [])
    return result
```

**Time Complexity**: O(4^N * N) where N = length of digits
**Space Complexity**: O(N) for recursion stack

---

### 9. Palindrome Partitioning
**Problem**: Given a string s, partition s such that every substring of the partition is a palindrome. Return all possible palindrome partitioning of s.

**Examples**:
```
Input: s = "aab"
Output: [["a","a","b"],["aa","b"]]

Input: s = "a"
Output: [["a"]]
```

**Solution Approach**:
Use backtracking to try all possible partitions, checking if each substring is palindrome.

**Algorithm**:
- At each position, try all possible substrings starting from current position
- If substring is palindrome, add to current partition and recurse
- When we reach end of string, add partition to result

**Python Solution**:
```python
def partition(s):
    def is_palindrome(string):
        return string == string[::-1]
    
    def backtrack(start, path):
        if start == len(s):
            result.append(list(path))
            return
        
        for end in range(start + 1, len(s) + 1):
            substring = s[start:end]
            if is_palindrome(substring):
                path.append(substring)
                backtrack(end, path)
                path.pop()
    
    result = []
    backtrack(0, [])
    return result
```

**Optimization**: Precompute palindrome table to make checking O(1)
```python
def partition(s):
    n = len(s)
    # dp[i][j] = True if s[i:j+1] is palindrome
    dp = [[False] * n for _ in range(n)]
    
    # All single chars are palindromes
    for i in range(n):
        dp[i][i] = True
    
    # Check for palindromes of length 2 and more
    for length in range(2, n + 1):
        for i in range(n - length + 1):
            j = i + length - 1
            if length == 2:
                dp[i][j] = (s[i] == s[j])
            else:
                dp[i][j] = (s[i] == s[j] and dp[i+1][j-1])
    
    def backtrack(start, path):
        if start == n:
            result.append(list(path))
            return
        
        for end in range(start, n):
            if dp[start][end]:
                path.append(s[start:end+1])
                backtrack(end + 1, path)
                path.pop()
    
    result = []
    backtrack(0, [])
    return result
```

**Time Complexity**: O(n * 2^n) worst case (each position can be cut or not)
**Space Complexity**: O(n^2) for DP table + O(n) for recursion stack

---

### 10. Sudoku Solver
**Problem**: Write a program to solve a Sudoku puzzle by filling the empty cells.

**Examples**:
```
Input: board = 
[["5","3",".",".","7",".",".",".","."],
["6",".",".","1","9","5",".",".","."],
[".","9","8",".",".",".",".","6","."],
["8",".",".",".","6",".",".",".","3"],
["4",".",".","8",".","3",".",".","1"],
["7",".",".",".","2",".",".",".","6"],
[".","6",".",".",".",".","2","8","."],
[".",".",".","4","1","9",".",".","5"],
[".",".",".",".","8",".",".","7","9"]]

Output: 
[["5","3","4","6","7","8","9","1","2"],
["6","7","2","1","9","5","3","4","8"],
["1","9","8","3","4","2","5","6","7"],
["8","5","9","7","6","1","4","2","3"],
["4","2","6","8","5","3","7","9","1"],
["7","1","3","9","2","4","8","5","6"],
["9","6","1","5","3","7","2","8","4"],
["2","8","7","4","1","9","6","3","5"],
["3","4","5","2","8","6","1","7","9"]]
```

**Solution Approach**:
Use backtracking to try numbers 1-9 in each empty cell, validating Sudoku constraints.

**Algorithm**:
- Find empty cell
- Try digits 1-9
- Check if digit is valid if:
   - Not in same row
   - Not in same column
   - Not in same 3x3 box
- If valid, place digit and recurse
- If recursion succeeds, return true
- Otherwise, backtrack and try next digit

**Python Solution**:
```python
def solveSudoku(board):
    def is_valid(row, col, num):
        # Check row
        for j in range(9):
            if board[row][j] == num:
                return False
        
        # Check column
        for i in range(9):
            if board[i][col] == num:
                return False
        
        # Check 3x3 box
        start_row, start_col = 3 * (row // 3), 3 * (col // 3)
        for i in range(3):
            for j in range(3):
                if board[start_row + i][start_col + j] == num:
                    return False
        
        return True
    
    def backtrack():
        for i in range(9):
            for j in range(9):
                if board[i][j] == '.':
                    for num in map(str, range(1, 10)):
                        if is_valid(i, j, num):
                            board[i][j] = num
                            if backtrack():
                                return True
                            board[i][j] = '.'  # Backtrack
                    return False  # Trigger backtracking - no valid number
        return True  # All cells filled
    
    backtrack()
```

**Time Complexity**: O(9^(n*n)) worst case, but much better with pruning
**Space Complexity**: O(1) modifying board in-place + O(81) for recursion stack

---

### 11. N-Queens
**Problem**: The n-queens puzzle is the problem of placing n queens on an n x n chessboard such that no two queens attack each other.

**Examples**:
```
Input: n = 4
Output: [[".Q..","...Q","Q...","..Q."],["..Q.","Q...","...Q",".Q.."]]

Input: n = 1
Output: [["Q"]]
```

**Solution Approach**:
Place queens row by row, checking column and diagonal constraints.

**Algorithm**:
- Place queen in each row
- For each position in row, check if it's safe:
   - No queen in same column
   - No queen in same diagonal (both diagonals)
- If safe, place queen and recurse to next row
- When all rows filled, add solution

**Python Solution**:
```python
def solveNQueens(n):
    def is_valid(board, row, col):
        # Check column
        for i in range(row):
            if board[i][col] == 'Q':
                return False
        
        # Check upper-left diagonal
        i, j = row - 1, col - 1
        while i >= 0 and j >= 0:
            if board[i][j] == 'Q':
                return False
            i -= 1
            j -= 1
        
        # Check upper-right diagonal
        i, j = row - 1, col + 1
        while i >= 0 and j < n:
            if board[i][j] == 'Q':
                return False
            i -= 1
            j += 1
        
        return True
    
    def backtrack(row, board):
        if row == n:
            result.append(["".join(row) for row in board])
            return
        
        for col in range(n):
            if is_valid(board, row, col):
                board[row][col] = 'Q'
                backtrack(row + 1, board)
                board[row][col] = '.'  # Backtrack
    
    result = []
    board = [['.' for _ in range(n)] for _ in range(n)]
    backtrack(0, board)
    return result
```

**Optimized Version** using sets for O(1) checking:
```python
def solveNQueens(n):
    def backtrack(row, diagonals, anti_diagonals, cols, state):
        if row == n:
            result.append(["".join(row) for row in state])
            return
        
        for col in range(n):
            curr_diagonal = row - col
            curr_anti_diagonal = row + col
            if (col in cols or 
                curr_diagonal in diagonals or 
                curr_anti_diagonal in anti_diagonals):
                continue
            
            # Place queen
            cols.add(col)
            diagonals.add(curr_diagonal)
            anti_diagonals.add(curr_anti_diagonal)
            state[row][col] = 'Q'
            
            # Recurse
            backtrack(row + 1, diagonals, anti_diagonals, cols, state)
            
            # Remove queen (backtrack)
            cols.remove(col)
            diagonals.remove(curr_diagonal)
            anti_diagonals.remove(curr_anti_diagonal)
            state[row][col] = '.'
    
    result = []
    empty_board = [["."] * n for _ in range(n)]
    backtrack(0, set(), set(), set(), empty_board)
    return result
```

**Time Complexity**: O(n!) - much better than O(n^n) due to pruning
**Space Complexity**: O(n^2) for board + O(n) for recursion stack + O(n) for sets

---

### 12. Restore IP Addresses
**Problem**: Given a string s containing only digits, return all possible valid IP addresses that can be obtained from s.

**Examples**:
```
Input: s = "25525511135"
Output: ["255.255.11.135","255.255.111.35"]

Input: s = "0000"
Output: ["0.0.0.0"]

Input: s = "101023"
Output: ["1.0.10.23","1.0.102.3","10.1.0.23","10.10.2.3","101.0.2.3"]
```

**Solution Approach**:
Use backtracking to place 3 dots to split string into 4 valid parts.

**Constraints for valid IP part**:
- Must be between 0 and 255
- Cannot have leading zeros unless it's "0"

**Algorithm**:
- Place dots at positions to create 4 segments
- Each segment must be valid (0-255, no leading zeros)
- When we place 3 dots and reach end, we have valid IP

**Python Solution**:
```python
def restoreIpAddresses(s):
    def is_valid(segment):
        # Check if segment is valid IP part
        if len(segment) > 3:
            return False
        if len(section) > 1 and section[0] == '0':  # Leading zero
            return False
        return int(segment) <= 255
    
    def backtrack(start, parts):
        # If we have 4 parts and used all characters
        if len(parts) == 4:
            if start == len(s):
                result.append(".".join(parts))
            return
        
        # If we have 4 parts but not used all chars, or vice versa
        if len(parts) == 4 or start >= len(s):
            return
        
        # Try segments of length 1, 2, 3
        for length in range(1, 4):
            if start + length > len(s):
                break
            
            segment = s[start:start + length]
            if is_valid(segment):
                parts.append(segment)
                backtrack(start + length, parts)
                parts.pop()  # Backtrack
    
    result = []
    backtrack(0, [])
    return result
```

**Time Complexity**: O(1) - bounded by constant (max 3^4 possibilities)
**Space Complexity**: O(1) for recursion depth + O(1) for output (max limited)

---

### 13. Matchsticks to Square
**Problem**: You are given an integer array `matchsticks` where `matchsticks[i]` is the length of the i-th matchstick. You want to use all the matchsticks to make one square. You should not break any stick, but you can link them up, and each matchstick must be used exactly once.

**Examples**:
```
Input: matchsticks = [1,1,2,2,2]
Output: true
Explanation: You can form a square with length 2, one side of the square came from two sticks with length 1.

Input: matchsticks = [3,3,3,3,4]
Output: false
```

**Solution Approach**:
Use backtracking to try assigning each stick to one of 4 sides.

**Key Insight**: 
- Total length must be divisible by 4
- Each side must equal total_length / 4
- Sort in descending order for better pruning

**Algorithm**:
- Calculate target side length = total / 4
- If any stick > target, return false
- Try to assign each stick to one of 4 sides
- Use backtracking with pruning

**Python Solution**:
```python
def makesquare(matchsticks):
    if not matchsticks or len(matchsticks) < 4:
        return False
    
    total = sum(matchsticks)
    if total % 4 != 0:
        return False
    
    target = total // 4
    matchsticks.sort(reverse=True)  # Sort descending for better pruning
    
    if matchsticks[0] > target:
        return False
    
    sides = [0] * 4
    
    def backtrack(index):
        if index == len(matchsticks):
            return all(side == target for side in sides)
        
        for i in range(4):
            # Optimization: if putting this stick in side i would exceed target, skip
            if sides[i] + matchsticks[index] > target:
                continue
            
            # Optimization: if this side has same length as previous tried side, skip
            # Avoids duplicate work (trying same configuration in different order)
            if i > 0 and sides[i] == sides[i-1]:
                continue
            
            sides[i] += matchsticks[index]
            if backtrack(index + 1):
                return True
            sides[i] -= matchsticks[index]  # Backtrack
        
        return False
    
    return backtrack(0)
```

**Time Complexity**: O(4^n) worst case, but much better with pruning and sorting
**Space Complexity**: O(n) for recursion stack

---

### 14. Remove Invalid Parentheses
**Problem**: Given a string s that contains parentheses and letters, remove the minimum number of invalid parentheses to make the input string valid.

**Examples**:
```
Input: s = "()())()"
Output: ["(())()","()()()"]

Input: s = "(a)())()"
Output: ["(a())()","(a)()()"]

Input: s = ")("
Output: [""]
```

**Solution Approach**:
Use BFS or DFS to remove minimum number of parentheses.

**Better Approach**: First calculate how many left and right parentheses to remove, then use backtracking.

**Algorithm**:
1. First pass: count misplaced parentheses
   - Left to right: count extra ')'
   - Right to left: count extra '('
2. Use backtracking to remove exactly those many parentheses
3. Avoid duplicates by skipping same characters at same level

**Python Solution**:
```python
def removeInvalidParentheses(s):
    def is_valid(string):
        count = 0
        for char in string:
            if char == '(':
                count += 1
            elif char == ')':
                count -= 1
                if count < 0:
                    return False
        return count == 0
    
    def remove_invalid(s, start, left_rem, right_rem):
        if left_rem == 0 and right_rem == 0:
            if is_valid(s):
                result.add(s)
            return
        
        for i in range(start, len(s)):
            # Skip duplicates to avoid redundant work
            if i > start and s[i] == s[i-1]:
                continue
            
            # Pruning: if remaining chars can't satisfy requirements
            if left_rem + right_rem > len(s) - i:
                break
            
            # Try removing s[i]
            if s[i] == '(' and left_rem > 0:
                remove_invalid(s[:i] + s[i+1:], i, left_rem - 1, right_rem)
            elif s[i] == ')' and right_rem > 0:
                remove_invalid(s[:i] + s[i+1:], i, left_rem, right_rem - 1)
    
    # First, count how many left and right parentheses to remove
    left_rem = right_rem = 0
    for char in s:
        if char == '(':
            left_rem += 1
        elif char == ')':
            if left_rem == 0:
                right_rem += 1
            else:
                left_rem -= 1
    
    result = set()
    remove_invalid(s, 0, left_rem, right_rem)
    return list(result)
```

**Time Complexity**: O(2^n) worst case
**Space Complexity**: O(n) for recursion stack + O(k) for results

---

### 15. Word Break II
**Problem**: Given a string s and a dictionary of strings wordDict, add spaces in s to construct a sentence where each word is a valid dictionary word. Return all such possible sentences.

**Examples**:
```
Input: s = "catsanddog", wordDict = ["cat","cats","and","sand","dog"]
Output: ["cats and dog","cat sand dog"]

Input: s = "pineapplepenapple", wordDict = ["apple","pen","applepen","pine","pineapple"]
Output: ["pine apple pen apple","pineapple pen apple","pine applepen apple"]
```

**Solution Approach**:
Use backtracking with memoization to avoid recomputation.

**Algorithm**:
- Try to split string at each position
- If left part is in dict, recursively solve for right part
- Memoize results for substrings to avoid recomputation
- Build sentences by combining left word with right sentences

**Python Solution**:
```python
def wordBreak(s, wordDict):
    word_set = set(wordDict)
    memo = {}
    
    def backtrack(start):
        if start in memo:
            return memo[start]
        
        if start == len(s):
            return [""]
        
        sentences = []
        for end in range(start + 1, len(s) + 1):
            word = s[start:end]
            if word in word_set:
                # Get all sentences for the remainder
                for sentence in backtrack(end):
                    if sentence:  # Not empty
                        sentences.append(word + " " + sentence)
                    else:  # Base case
                        sentences.append(word)
        
        memo[start] = sentences
        return sentences
    
    return backtrack(0)
```

**Optimization**: Check if solution possible first using DP
```python
def wordBreak(s, wordDict):
    word_set = set(wordDict)
    n = len(s)
    
    # First check if segmentation is possible
    dp = [False] * (n + 1)
    dp[0] = True
    for i in range(1, n + 1):
        for j in range(i):
            if dp[j] and s[j:i] in word_set:
                dp[i] = True
                break
    
    if not dp[n]:
        return []
    
    memo = {}
    
    def backtrack(start):
        if start == len(s):
            return [""]
        if start in memo:
            return memo[start]
        
        sentences = []
        for end in range(start + 1, len(s) + 1):
            word = s[start:end]
            if word in word_set:
                for suffix in backtrack(end):
                    if suffix:
                        sentences.append(word + " " + suffix)
                    else:
                        sentences.append(word)
        
        memo[start] = sentences
        return sentences
    
    return backtrack(0)
```

**Time Complexity**: O(n^2 * m) where n = string length, m = avg word length
**Space Complexity**: O(n^2) for memo + O(n) for recursion stack

---

## Hard Problems

### 16. Split Array into Fibonacci Sequence
**Problem**: Given a string S of digits, such as "123456579", we can split it into a Fibonacci-like sequence [123, 456, 579].

Formally, a Fibonacci-like sequence is a list F of non-negative integers such that:
- 0 <= F[i] <= 2^31 - 1
- F.length >= 3
- F[i] + F[i+1] = F[i+2] for all 0 <= i < F.length - 2

**Examples**:
```
Input: S = "123456579"
Output: [123,456,579]

Input: S = "11235813"
Output: [1,1,2,3,5,8,13]

Input: S = "112358130"
Output: []
Explanation: The task is impossible.
```

**Solution Approach**:
Use backtracking to try splitting the string into numbers that form Fibonacci sequence.

**Constraints**:
- Each number must fit in 32-bit signed integer
- No leading zeros unless number is 0
- First two numbers determine the rest

**Algorithm**:
- Try all possible splits for first two numbers
- For each pair, generate subsequent numbers and check if they match string
- Use backtracking with pruning

**Python Solution**:
```python
def splitIntoFibonacci(S):
    def backtrack(index, path):
        # If we've used all characters and have at least 3 numbers
        if index == len(S) and len(path) >= 3:
            return list(path)
        
        # Try numbers of length 1 to 10 (since 2^31-1 has 10 digits)
        for i in range(index, min(len(S), index + 10)):
            # Leading zero check
            if i > index and S[index] == '0':
                break
            
            # Prevent overflow
            num_str = S[index:i+1]
            if len(num_str) > 10:
                break
            num = int(num_str)
            if num > 2**31 - 1:
                break
            
            # If we have less than 2 numbers, or this continues the Fibonacci property
            if len(path) < 2 or num == path[-1] + path[-2]:
                path.append(num)
                result = backtrack(i + 1, path)
                if result:
                    return result
                path.pop()  # Backtrack
        
        return None
    
    result = backtrack(0, [])
    return result if result else []
```

**Time Complexity**: O(N^2) where N = length of string
**Space Complexity**: O(N) for recursion stack

---

### 17. Number of Ways to Reorder Array to Get Same BST
**Problem**: Given an array `nums` that represents a permutation of integers from 1 to n. We are going to construct a binary search tree (BST) by inserting the elements of `nums` in order into an initially empty BST. Find the number of different ways to reorder `nums` so that the constructed BST is identical to the original BST formed from `nums`.

**Examples**:
```
Input: nums = [2,1,3]
Output: 1
Explanation: [2,1,3] is the only way to reorder the array to get the same BST.

Input: nums = [3,4,5,1,2]
Output: 5
Explanation: The 5 possible arrays are:
[3,1,2,4,5]
[3,1,4,2,5]
[3,1,4,5,2]
[3,4,1,2,5]
[3,4,1,5,2]
```

**Solution Approach**:
Use recursion with combinatorics. The BST structure depends on relative ordering.

**Key Insight**:
- Root is always first element
- Left subtree contains elements < root
- Right subtree contains elements > root
- We can interleave left and right subtree elements in any way that preserves their internal order

**Algorithm**:
- Find root (first element)
- Split remaining into left (< root) and right (> root)
- Number of ways = C(left_size + right_size, left_size) * ways(left) * ways(right)
- Use memoization for efficiency

**Python Solution**:
```python
def numOfWays(nums):
    MOD = 10**9 + 7
    
    # Precompute factorials for combination calculation
    max_n = len(nums)
    fact = [1] * (max_n + 1)
    inv_fact = [1] * (max_n + 1)
    
    for i in range(1, max_n + 1):
        fact[i] = fact[i-1] * i % MOD
    
    # Fermat's little theorem for modular inverse
    inv_fact[max_n] = pow(fact[max_n], MOD-2, MOD)
    for i in range(max_n, 0, -1):
        inv_fact[i-1] = inv_fact[i] * i % MOD
    
    def nCr(n, r):
        if r < 0 or r > n:
            return 0
        return fact[n] * inv_fact[r] % MOD * inv_fact[n-r] % MOD
    
    def count_ways(arr):
        if len(arr) <= 2:
            return 1
        
        root = arr[0]
        left = [x for x in arr[1:] if x < root]
        right = [x for x in arr[1:] if x > root]
        
        # Ways to interleave left and right subtrees
        ways_to_interleave = nCr(len(left) + len(right), len(left))
        
        # Recursively count ways for left and right subtrees
        ways_left = count_ways(left)
        ways_right = count_ways(right)
        
        return (ways_to_interleave * ways_left % MOD) * ways_right % MOD
    
    # Subtract 1 because we want different orderings (excluding original)
    return (count_ways(nums) - 1 + MOD) % MOD
```

**Time Complexity**: O(n^2) due to list comprehensions in recursion
**Space Complexity**: O(n) for recursion stack + O(n) for factorial arrays

---

### 18. Regular Expression Matching
**Problem**: Given an input string s and a pattern p, implement regular expression matching with support for '.' and '*' where:
- '.' Matches any single character.
- '*' Matches zero or more of the preceding element.

**Examples**:
```
Input: s = "aa", p = "a"
Output: false
Explanation: "a" does not match the entire string "aa".

Input: s = "aa", p = "a*"
Output: true
Explanation: '*' means zero or more of the preceding element, 'a'. 
Therefore, by repeating 'a' once, it becomes "aa".

Input: s = "ab", p = ".*"
Output: true
Explanation: ".*" means "zero or more (*) of any character (.)".
```

**Solution Approach**:
Use backtracking with memoization (or DP) to handle the complex matching rules.

**Key Insights**:
- '*' can match zero or more of preceding element
- Need to consider both cases: use * (match one more) or don't use * (skip)
- '.' matches any single character

**Algorithm**:
- Recursive function matching s[i:] with p[j:]
- Handle '*' by trying both options (skip or use)
- Use memoization to avoid recomputation

**Python Solution**:
```python
def isMatch(s, p):
    memo = {}
    
    def dp(i, j):
        if (i, j) in memo:
            return memo[(i, j)]
        
        # If we've reached end of pattern
        if j == len(p):
            ans = (i == len(s))
        else:
            # Check if first characters match
            first_match = i < len(s) and p[j] in {s[i], '.'}
            
            # Handle '*' pattern
            if j + 1 < len(p) and p[j+1] == '*':
                # Two options: 
                # 1. Skip the '*' pattern (match zero times)
                # 2. Use the '*' pattern (match one or more times)
                ans = dp(i, j+2) or (first_match and dp(i+1, j))
            else:
                # Simple case: characters must match and move forward
                ans = first_match and dp(i+1, j+1)
        
        memo[(i, j)] = ans
        return ans
    
    return dp(0, 0)
```

**Time Complexity**: O(T * P) where T = len(s), P = len(p) due to memoization
**Space Complexity**: O(T * P) for memo table

---

### 19. Word Search II
**Problem**: Given an m x n board of characters and a list of strings words, return all words on the board.

**Examples**:
```
Input: board = [["o","a","a","n"],["e","t","a","e"],["i","h","k","r"],["i","f","l","v"]], 
       words = ["oath","pea","eat","rain"]
Output: ["eat","oath"]
```

**Solution Approach**:
Combine Trie for efficient prefix checking with backtracking for board traversal.

**Algorithm**:
1. Build a Trie from all words
2. For each cell on board, start DFS if letter is in Trie root
3. During DFS:
   - Check if current path forms a word (terminal node in Trie)
   - Explore 4 directions if next letter is in current Trie node's children
   - Backtrack by unmarking visited cell
4. Optimization: Remove found words from Trie to prevent duplicates

**Python Solution**:
```python
class TrieNode:
    def __init__(self):
        self.children = {}
        self.word = None  # Store word at leaf nodes
        self.count = 0    # For duplicate word handling

def findWords(board, words):
    # Build Trie
    root = TrieNode()
    for word in words:
        node = root
        for char in word:
            if char not in node.children:
                node.children[char] = TrieNode()
            node = node.children[char]
        node.word = word
        node.count += 1
    
    def backtrack(row, col, parent):
        letter = board[row][col]
        curr_node = parent.children.get(letter)
        
        # If letter not in current trie node, return
        if not curr_node:
            return
        
        # Check if we found a word
        if curr_node.word:
            found_words.append(curr_node.word)
            # Mark as used to avoid duplicates
            curr_node.word = None
        
        # Mark as visited
        board[row][col] = '#'
        
        # Explore neighbors
        for dx, dy in [(0, 1), (0, -1), (1, 0), (-1, 0)]:
            new_row, new_col = row + dx, col + dy
            if (0 <= new_row < len(board) and 
                0 <= new_col < len(board[0]) and 
                board[new_row][new_col] != '#'):
                backtrack(new_row, new_col, curr_node)
        
        # Bitset optimization: if no children left, prune
        if not curr_node.children:
            del parent.children[letter]
        
        # Backtrack
        board[row][col] = letter
    
    found_words = []
    for i in range(len(board)):
        for j in range(len(board[0])):
            if board[i][j] in root.children:
                backtrack(i, j, root)
    
    return found_words
```

**Time Complexity**: O(M * N * 4^L) where M,N = board dimensions, L = max word length
**Space Complexity**: O(W * L) for Trie where W = number of words, L = avg length

---

### 20. Strobogrammatic Number II
**Problem**: A strobogrammatic number is a number that looks the same when rotated 180 degrees (looked at upside down).

Find all strobogrammatic numbers that are of length n.

**Examples**:
```
Input: n = 2
Output: ["11","69","88","96"]

Input: n = 1
Output: ["0","1","8"]
```

**Valid pairs**: 0-0, 1-1, 6-9, 8-8, 9-6

**Solution Approach**:
Use recursion to build numbers from outside to inside.

**Algorithm**:
- Base cases: n=0 (empty string), n=1 ("0","1","8")
- For n >= 2: add pairs to outside of solutions for n-2
- Handle leading zero restriction

**Python Solution**:
```python
def findStrobogrammatic(n):
    def helper(n, final_length):
        if n == 0:
            return [""]
        if n == 1:
            return ["0", "1", "8"]
        
        middles = helper(n-2, final_length)
        result = []
        
        for middle in middles:
            # Add pairs around the middle
            if n != final_length:  # Allow 0 as outer pair only if not outermost
                result.append("0" + middle + "0")
            result.append("1" + middle + "1")
            result.append("6" + middle + "9")
            result.append("8" + middle + "8")
            result.append("9" + middle + "6")
        
        return result
    
    return helper(n, n)
```

**Alternative Iterative Approach**:
```python
def findStrobogrammatic(n):
    if n == 0:
        return [""]
    
    # Start with appropriate base
    if n % 2 == 1:
        nums = ["0", "1", "8"]
    else:
        nums = [""]
    
    pairs = [("0","0"), ("1","1"), ("6","9"), ("8","8"), ("9","6")]
    
    # Build from center outward
    while n > 1:
        new_nums = []
        for num in nums:
            for a, b in pairs:
                # Don't allow leading zero
                if n != 2 or a != "0":  # Allow 0 only if not outermost pair
                    new_nums.append(a + num + b)
        nums = new_nums
        n -= 2
    
    return nums
```

**Time Complexity**: O(5^(n/2)) - 5 choices for each pair position
**Space Complexity**: O(5^(n/2)) for storing results

---

## Summary

This collection covers the full spectrum of backtracking problems from basic to advanced:

### Pattern Recognition
1. **Combination/Permutation**: Selection with/without order, with/without repetition
2. **Subset/Power Set**: All possible selections
3. **Partition Problems**: Dividing string/array into valid parts
4. **Constraint Satisfaction**: Sudoku, N-Queens, Word Search
5. **Combinatorial Optimization**: Combination Sum, Matchsticks
6. **String Processing**: Word Break, Parentheses Removal, Strobogrammatic
7. **Tree/Graph Reconstruction**: BST reordering, Fibonacci split
8. **Pattern Matching**: Regular Expression, Word Search with Trie

### Key Techniques
1. **State Representation**: Choosing right data structure for partial solution
2. **Pruning Strategies**: Early termination when path cannot lead to solution
3. **Memoization**: Caching results of subproblems to avoid recomputation
4. **Heuristics**: Variable/value ordering to find solutions faster
5. **Optimization Techniques**: Sorting, duplicate skipping, symmetry breaking
6. **Hybrid Approaches**: Combining with other data structures (Trie, DP)

### When to Use Backtracking
- Need to find all or some solutions
- Solution can be built incrementally
- Constraints can be checked early (enabling pruning)
- Problem has natural recursive structure
- Input size is small enough for exponential search (or effective pruning)

### Optimization Strategies
1. **Sorting**: For better pruning (try larger/smaller elements first)
2. **Early Termination**: Stop when current path cannot improve best solution
3. **Duplicate Handling**: Skip identical choices at same recursion level
4. **Symmetry Breaking**: Avoid exploring equivalent solutions
5. **Memoization**: Cache results of identical subproblems
6. **Heuristic Ordering**: Try most promising options first (MRV, LCV)
7. **Iterative Deepening**: For depth-limited search when solution depth unknown
8. **Bidirectional Search**: Search from both ends when applicable

The key to mastering backtracking is recognizing when it's applicable and developing intuition for effective pruning strategies that make exponential problems tractable in practice.