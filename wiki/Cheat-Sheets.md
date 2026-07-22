# Cheat Sheets

## Overview

Quick reference guides for the most commonly used tools and languages in computer science and software engineering. Perfect for interview prep and daily development.

## Python Quick Reference

### Data Structures

```python
# Lists
lst = [1, 2, 3]
lst.append(4)          # Add to end
lst.insert(0, 0)       # Insert at index
lst.pop()              # Remove last
lst.pop(0)             # Remove at index
lst.sort()             # In-place sort
sorted_lst = sorted(lst, reverse=True)
lst[1:3]               # Slice [1, 3)

# Dictionaries
d = {"key": "value"}
d.get("missing", None)  # Safe access
d.setdefault("new", [])
{**d1, **d2}           # Merge dicts
{k: v for k, v in items if condition}  # Dict comprehension

# Sets
s = {1, 2, 3}
s.add(4)
s.discard(5)           # No error if missing
a & b                  # Intersection
a | b                  # Union
a - b                  # Difference

# Deques (O(1) both ends)
from collections import deque
dq = deque([1, 2, 3])
dq.appendleft(0)
dq.pop()
```

### Common Patterns

```python
# Defaultdict
from collections import defaultdict
graph = defaultdict(list)
graph["a"].append("b")

# Counter
from collections import Counter
counts = Counter("abracadabra")  # {'a': 5, 'b': 2, ...}

# itertools
from itertools import combinations, permutations
list(combinations([1, 2, 3], 2))  # [(1,2), (1,3), (2,3)]
list(permutations([1, 2, 3], 2))  # All ordered pairs

# File reading
with open("file.txt", "r") as f:
    lines = f.readlines()
    content = f.read()

# Lambda and sorting
students.sort(key=lambda s: s["gpa"], reverse=True)

# Ternary
value = "yes" if condition else "no"

# Walrus operator (Python 3.8+)
if (n := len(data)) > 10:
    print(f"Long data: {n}")
```

## SQL Quick Reference

### Essential Queries

```sql
-- Select with conditions
SELECT name, age FROM users WHERE age > 21 ORDER BY name ASC LIMIT 10;

-- Aggregation
SELECT department, COUNT(*) as count, AVG(salary) as avg_salary
FROM employees
GROUP BY department
HAVING COUNT(*) > 5
ORDER BY avg_salary DESC;

-- Joins
SELECT o.id, u.name, o.total
FROM orders o
INNER JOIN users u ON o.user_id = u.id;

-- Subquery
SELECT * FROM products
WHERE price > (SELECT AVG(price) FROM products);

-- Window functions
SELECT name, salary,
       RANK() OVER (ORDER BY salary DESC) as rank,
       AVG(salary) OVER (PARTITION BY dept) as dept_avg
FROM employees;

-- Common Table Expression
WITH monthly_sales AS (
    SELECT DATE_TRUNC('month', created_at) as month,
           SUM(amount) as total
    FROM orders
    GROUP BY 1
)
SELECT month, total,
       LAG(total) OVER (ORDER BY month) as prev_month
FROM monthly_sales;
```

## Git Quick Reference

### Essential Commands

```bash
# Branching
git branch feature/new-login       # Create branch
git checkout -b feature/new-login  # Create and switch
git switch feature/new-login       # Switch (modern)
git branch -d feature/old          # Delete local branch

# Stashing
git stash                          # Stash changes
git stash push -m "WIP feature"    # Named stash
git stash list                     # View stashes
git stash pop                      # Apply and remove
git stash apply stash@{0}         # Apply without removing

# Undoing
git reset --soft HEAD~1            # Undo commit, keep changes
git reset --hard HEAD~1            # Undo commit, discard changes
git revert HEAD                    # Create new commit undoing changes
git restore --staged file.txt      # Unstage file

# History
git log --oneline --graph --all    # Visual history
git log --author="name" --since="2024-01-01"
git diff main..feature             # Compare branches
git blame file.txt                 # Who changed what

# Advanced
git rebase -i HEAD~5               # Interactive rebase
git cherry-pick abc1234            # Apply specific commit
git reflog                         # Find lost commits
git bisect start                   # Binary search for bugs
```

## JavaScript Quick Reference

### ES6+ Features

```javascript
// Destructuring
const { name, age, ...rest } = person;
const [first, second, ...others] = array;

// Spread / Rest
const merged = [...arr1, ...arr2];
const copy = { ...originalObj };

// Arrow functions
const double = x => x * 2;
const add = (a, b) => a + b;

// Optional chaining + Nullish coalescing
const city = user?.address?.city ?? "Unknown";

// Array methods
arr.map(x => x * 2);           // Transform
arr.filter(x => x > 5);        // Filter
arr.reduce((sum, x) => sum + x, 0);  // Accumulate
arr.find(x => x.id === 1);     // Find first
arr.some(x => x > 0);          // Any match?
arr.every(x => x > 0);         // All match?

// Async/Await
async function fetchData() {
  try {
    const res = await fetch(url);
    const data = await res.json();
    return data;
  } catch (err) {
    console.error(err);
  }
}

// Promise.all for parallel requests
const [users, posts] = await Promise.all([
  fetchUsers(),
  fetchPosts()
]);

// Template literals
const msg = `Hello, ${name}! You have ${count} messages.`;
```

## Big O Quick Reference

### Time Complexity

| Complexity | Name | Example |
|------------|------|---------|
| O(1) | Constant | Array index access |
| O(log n) | Logarithmic | Binary search |
| O(n) | Linear | Array traversal |
| O(n log n) | Linearithmic | Merge sort, heap sort |
| O(n^2) | Quadratic | Nested loops, bubble sort |
| O(n^3) | Cubic | Matrix multiplication |
| O(2^n) | Exponential | Subsets, brute-force recursion |
| O(n!) | Factorial | Permutations |

### Space Complexity of Common Structures

| Structure | Access | Search | Insert | Delete |
|-----------|--------|--------|--------|--------|
| Array | O(1) | O(n) | O(n) | O(n) |
| Linked List | O(n) | O(n) | O(1) | O(1) |
| Hash Table | O(1)* | O(1)* | O(1)* | O(1)* |
| Binary Search Tree | O(log n) | O(log n) | O(log n) | O(log n) |
| Heap | O(1) min/max | O(n) | O(log n) | O(log n) |

*Average case; worst case O(n) for hash tables with collisions.

### Common Complexity Examples

```
O(1)       - Hash map lookup, array push/pop, stack push/pop
O(log n)   - Binary search, balanced BST operations
O(n)       - Linear search, single loop through array
O(n log n) - Merge sort, quicksort (average), heap sort
O(n^2)     - Nested loops, bubble/insertion/selection sort
O(2^n)     - Recursive Fibonacci, power set generation
```

## Common Interview Questions

1. **When would you use a hash map vs a tree?** Hash map for O(1) average lookups; tree when you need sorted order or range queries.

2. **What is the time complexity of operations on a heap?** Insert: O(log n), Extract min/max: O(log n), Peek: O(1), Build heap: O(n).

3. **How does merge sort achieve O(n log n)?** Divides array in half (log n levels) and merges each level in O(n) time.

4. **What is amortized analysis?** Average time per operation over worst-case sequence; e.g., dynamic array append is O(1) amortized despite occasional O(n) resize.

5. **Difference between `==` and `===` in JavaScript?** `==` performs type coercion; `===` checks both value and type without coercion.

## See Also

- [[Web-Development]]
- [[AI-ML]]
- [[DevOps-Cloud]]

> Full content: [52-Cheat-Sheets](../52-Cheat-Sheets/)
