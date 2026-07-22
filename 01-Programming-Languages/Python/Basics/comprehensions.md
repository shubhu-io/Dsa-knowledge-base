# List, Dict, and Set Comprehensions

## Overview

Comprehensions are concise, Pythonic ways to create lists, dictionaries, and sets
from existing iterables. They replace verbose loops with a single readable expression.

---

## List Comprehensions

### Basic Syntax

```python
# [expression for item in iterable]
squares = [x**2 for x in range(10)]
# [0, 1, 4, 9, 16, 25, 36, 49, 64, 81]

# [expression for item in iterable if condition]
evens = [x for x in range(20) if x % 2 == 0]
# [0, 2, 4, 6, 8, 10, 12, 14, 16, 18]

# [expression for item in iterable if condition1 if condition2]
divisible_by_6 = [x for x in range(30) if x % 2 == 0 if x % 3 == 0]
# [0, 6, 12, 18, 24]
```

### Nested Loops

```python
# Flatten a 2D list
matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
flat = [num for row in matrix for num in row]
# [1, 2, 3, 4, 5, 6, 7, 8, 9]

# Equivalent nested loop
flat = []
for row in matrix:
    for num in row:
        flat.append(num)
```

### If-Else (Ternary)

```python
# [expression_if_true if condition else expression_if_false for item in iterable]
labels = ["even" if x % 2 == 0 else "odd" for x in range(5)]
# ['even', 'odd', 'even', 'odd', 'even']

# Classify numbers
nums = [1, -2, 3, -4, 5]
result = ["positive" if x > 0 else "negative" for x in nums]
# ['positive', 'negative', 'positive', 'negative', 'positive']
```

### Nested Comprehensions

```python
# Create a 3x3 identity matrix
identity = [[1 if i == j else 0 for j in range(3)] for i in range(3)]
# [[1, 0, 0], [0, 1, 0], [0, 0, 1]]

# Transpose a matrix
matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
transposed = [[row[i] for row in matrix] for i in range(3)]
# [[1, 4, 7], [2, 5, 8], [3, 6, 9]]
```

---

## Dict Comprehensions

### Basic Syntax

```python
# {key_expr: value_expr for item in iterable}
squares_dict = {x: x**2 for x in range(6)}
# {0: 0, 1: 1, 2: 4, 3: 9, 4: 16, 5: 25}

# With condition
even_squares = {x: x**2 for x in range(10) if x % 2 == 0}
# {0: 0, 2: 4, 4: 16, 6: 36, 8: 64}
```

### From Two Sequences

```python
keys = ["name", "age", "city"]
values = ["Alice", 30, "NYC"]

person = {k: v for k, v in zip(keys, values)}
# {'name': 'Alice', 'age': 30, 'city': 'NYC'}
```

### Invert a Dictionary

```python
original = {"a": 1, "b": 2, "c": 3}
inverted = {v: k for k, v in original.items()}
# {1: 'a', 2: 'b', 3: 'c'}
```

### Filter and Transform

```python
scores = {"Alice": 85, "Bob": 92, "Charlie": 78, "Diana": 95}

# Only high scores
high_scores = {name: score for name, score in scores.items() if score >= 90}
# {'Bob': 92, 'Diana': 95}

# Add grade to each score
graded = {
    name: {"score": score, "grade": "A" if score >= 90 else "B" if score >= 80 else "C"}
    for name, score in scores.items()
}
```

---

## Set Comprehensions

### Basic Syntax

```python
# {expr for item in iterable}
unique_squares = {x**2 for x in [-2, -1, 0, 1, 2]}
# {0, 1, 4}

# With condition
vowels = {char.lower() for char in "Hello World" if char.lower() in "aeiou"}
# {'e', 'o'}
```

### Practical Uses

```python
# Find unique characters
text = "hello world"
unique_chars = {c for c in text if c != ' '}
# {'h', 'e', 'l', 'o', 'w', 'r', 'd'}

# Set operations with comprehensions
a = {1, 2, 3, 4, 5}
b = {4, 5, 6, 7, 8}
diff = {x for x in a if x not in b}
# {1, 2, 3}
```

---

## Generator Expressions

Similar to list comprehensions but use `()` and produce items lazily.

```python
# Generator expression (lazy evaluation)
gen = (x**2 for x in range(1000000))

# Use in functions that accept iterables
total = sum(x**2 for x in range(100))  # No extra brackets needed
avg = sum(data) / len(data)

# Memory efficient for large datasets
with open("big_file.txt") as f:
    lines = (line.strip() for line in f)  # Generator, not list
    non_empty = (line for line in lines if line)
    for line in non_empty:
        process(line)
```

---

## When to Use Comprehensions

### Use When

```python
# Simple transformation
upper_names = [name.upper() for name in names]

# Simple filtering
adults = [person for person in people if person.age >= 18]

# Dictionary inversion
mapping = {v: k for k, v in original.items()}
```

### Avoid When

```python
# Too complex — use a regular loop instead
result = [
    transform(item)
    for item in iterable
    if complex_condition(item)
    if another_condition(item)
    for sub_item in item.children  # Hard to read
    if sub_item.valid
]

# Side effects — use a regular loop
[print(x) for x in range(10)]  # BAD: creates unnecessary list

# Better
for x in range(10):
    print(x)
```

---

## Performance Comparison

```python
import timeit

# List comprehension vs loop
setup = "nums = list(range(1000))"

# Loop approach
loop_time = timeit.timeit(
    "result = []\nfor n in nums:\n    result.append(n**2)",
    setup=setup,
    number=10000
)

# Comprehension approach
comp_time = timeit.timeit(
    "result = [n**2 for n in nums]",
    setup=setup,
    number=10000
)

# Comprehension is typically 20-30% faster
# Loop: ~1.2s  |  Comprehension: ~0.9s
```

---

## Interview Questions

1. What is the difference between a list comprehension and a generator expression?
2. When should you avoid using comprehensions?
3. How do you flatten a nested list using comprehensions?
4. What is the time complexity of a list comprehension with a filter?
5. How do you create a dictionary from two lists?

---

## See Also

- [[Python]] — Python overview
- [[syntax]] — Python syntax basics
- [[generators]] — Generators and iterators
- [[decorators]] — Decorators
