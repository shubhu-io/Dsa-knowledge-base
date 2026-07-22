# DSA Cheat Sheets

Quick reference guides for essential programming languages and tools used in data structures and algorithms.

---

## What's Included

| Cheat Sheet | Topics Covered |
|-------------|----------------|
| Python | Data structures, syntax, built-ins |
| JavaScript | ES6+, arrays, objects, async |
| SQL | Queries, joins, indexes, optimization |
| Git | Commands, workflows, branching |

---

## How to Use These Cheat Sheets

### For Learning
- Review before studying a new topic
- Use as a quick reference while coding
- Test your knowledge with the examples

### For Interviews
- Review the day before your interview
- Keep handy during practice sessions
- Use for quick syntax refreshers

### For Projects
- Reference while implementing
- Copy-paste common patterns
- Verify syntax correctness

---

## Quick Access

### Python
```python
# List comprehension
squares = [x**2 for x in range(10)]

# Dictionary
user = {"name": "Alice", "age": 30}

# Lambda
add = lambda x, y: x + y
```

### JavaScript
```javascript
// Destructuring
const { name, age } = user;

// Spread operator
const newArr = [...oldArr, newItem];

// Optional chaining
const city = user?.address?.city;
```

### SQL
```sql
-- JOIN
SELECT * FROM users u
JOIN orders o ON u.id = o.user_id;

-- Window function
SELECT *, ROW_NUMBER() OVER (ORDER BY salary) as rank
FROM employees;
```

### Git
```bash
# Branch and switch
git checkout -b feature/new-thing

# Interactive rebase
git rebase -i HEAD~3

# Stash
git stash push -m "work in progress"
```

---

## DSA-Specific Cheat Sheets

### Time Complexity

| Operation | Array | Linked List | BST | Hash Map |
|-----------|-------|-------------|-----|----------|
| Access | O(1) | O(n) | O(log n) | O(1) |
| Search | O(n) | O(n) | O(log n) | O(1) |
| Insert | O(n) | O(1) | O(log n) | O(1) |
| Delete | O(n) | O(1) | O(log n) | O(1) |

### Space Complexity

| Data Structure | Space |
|----------------|-------|
| Array | O(n) |
| Linked List | O(n) |
| Binary Tree | O(n) |
| Hash Map | O(n) |
| Graph (adj list) | O(V + E) |

---

## Common Patterns

### Two Pointers
```python
def two_sum_sorted(arr, target):
    left, right = 0, len(arr) - 1
    while left < right:
        current = arr[left] + arr[right]
        if current == target:
            return [left, right]
        elif current < target:
            left += 1
        else:
            right -= 1
    return []
```

### Sliding Window
```python
def max_subarray_sum(arr, k):
    window_sum = sum(arr[:k])
    max_sum = window_sum
    for i in range(k, len(arr)):
        window_sum += arr[i] - arr[i-k]
        max_sum = max(max_sum, window_sum)
    return max_sum
```

### Binary Search
```python
def binary_search(arr, target):
    left, right = 0, len(arr) - 1
    while left <= right:
        mid = (left + right) // 2
        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    return -1
```

---

## Interview Checklist

```
BEFORE THE INTERVIEW
□ Review Python syntax
□ Review JavaScript syntax (if applicable)
□ Review SQL queries
□ Review Git commands
□ Practice common patterns

DURING THE INTERVIEW
□ Clarify the problem
□ Identify data structures needed
□ Discuss time/space complexity
□ Write clean code
□ Test with examples

AFTER THE INTERVIEW
□ Send follow-up email
□ Note any feedback
□ Practice weak areas
□ Update your notes
```

---

## Contributing

These cheat sheets are living documents. Feel free to:
- Add missing topics
- Fix errors
- Improve examples
- Add new languages

---

## License

These cheat sheets are provided as-is for educational purposes.
