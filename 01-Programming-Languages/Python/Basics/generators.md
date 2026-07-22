# Generators and Iterators in Python

## Overview

Generators are functions that produce a sequence of values lazily — they generate
one value at a time and only when needed. This makes them memory-efficient for
large datasets. Iterators are objects that implement the `__iter__` and `__next__`
methods.

---

## Generator Functions (yield)

```python
def countdown(n):
    """Generate countdown from n to 1."""
    while n > 0:
        yield n
        n -= 1

# Usage
for num in countdown(5):
    print(num)  # 5, 4, 3, 2, 1

# Generators are lazy — nothing runs until you iterate
gen = countdown(3)  # Nothing printed yet
next(gen)  # 5
next(gen)  # 4
next(gen)  # 3
# next(gen)  # StopIteration exception
```

### How yield Works

```python
def simple_generator():
    print("First value")
    yield 1
    print("Second value")
    yield 2
    print("Third value")
    yield 3

gen = simple_generator()
next(gen)  # Prints "First value", returns 1
# Function is paused at the yield
next(gen)  # Prints "Second value", returns 2
next(gen)  # Prints "Third value", returns 3
```

---

## Generator Expressions

```python
# List comprehension (creates full list in memory)
squares_list = [x**2 for x in range(1000000)]

# Generator expression (lazy, one item at a time)
squares_gen = (x**2 for x in range(1000000))

# Use in functions
total = sum(x**2 for x in range(100))  # No extra brackets
max_val = max(x**2 for x in range(100))

# Memory comparison
import sys
list_size = sys.getsizeof([x**2 for x in range(1000)])   # ~8856 bytes
gen_size = sys.getsizeof(x**2 for x in range(1000))      # ~200 bytes
```

---

## Iterator Protocol

```python
class CountDown:
    """Custom iterator using iterator protocol."""

    def __init__(self, start):
        self.current = start

    def __iter__(self):
        return self  # Returns itself as the iterator

    def __next__(self):
        if self.current <= 0:
            raise StopIteration
        value = self.current
        self.current -= 1
        return value

# Usage
for num in CountDown(5):
    print(num)  # 5, 4, 3, 2, 1

# Convert to list
list(CountDown(3))  # [3, 2, 1]
```

---

## Built-in Generators

```python
# range (lazy)
for i in range(1000000):
    pass  # Only one number in memory at a time

# enumerate
for i, val in enumerate(["a", "b", "c"]):
    print(i, val)

# zip
list(zip([1, 2], ["a", "b"]))  # [(1, 'a'), (2, 'b')]

# map
list(map(str, [1, 2, 3]))  # ['1', '2', '3']

# filter
list(filter(lambda x: x > 0, [-1, 2, -3, 4]))  # [2, 4]

# reversed
list(reversed([1, 2, 3]))  # [3, 2, 1]
```

---

## Practical Generators

### Infinite Sequence

```python
def fibonacci():
    """Generate infinite Fibonacci sequence."""
    a, b = 0, 1
    while True:
        yield a
        a, b = b, a + b

# Take first 10
from itertools import islice
list(islice(fibonacci(), 10))  # [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
```

### Read Large Files

```python
def read_large_file(filepath):
    """Read a file line by line (memory efficient)."""
    with open(filepath, "r") as f:
        for line in f:
            yield line.strip()

# Process without loading entire file
for line in read_large_file("huge_file.txt"):
    process(line)
```

### Batch Processing

```python
def batch(iterable, batch_size):
    """Yield successive batches from iterable."""
    batch = []
    for item in iterable:
        batch.append(item)
        if len(batch) == batch_size:
            yield batch
            batch = []
    if batch:
        yield batch

# Process in chunks of 100
for chunk in batch(range(1000), 100):
    process_batch(chunk)
```

### Pipeline Pattern

```python
def read_data(source):
    """Stage 1: Read"""
    for item in source:
        yield item

def filter_data(data, predicate):
    """Stage 2: Filter"""
    for item in data:
        if predicate(item):
            yield item

def transform_data(data, func):
    """Stage 3: Transform"""
    for item in data:
        yield func(item)

# Chain generators (lazy pipeline)
raw = read_data(range(1000))
filtered = filter_data(raw, lambda x: x % 2 == 0)
doubled = transform_data(filtered, lambda x: x * 2)

for val in doubled:
    process(val)
```

### Coroutines (yield with send)

```python
def accumulator():
    """Accumulate values sent to the generator."""
    total = 0
    while True:
        value = yield total
        if value is None:
            break
        total += value

acc = accumulator()
next(acc)          # Prime the coroutine (advance to first yield)
acc.send(10)       # Returns 10
acc.send(20)       # Returns 30
acc.send(30)       # Returns 60
```

---

## itertools Module

```python
import itertools

# Count (infinite)
counter = itertools.count(10, 2)  # 10, 12, 14, ...
list(islice(counter, 5))  # [10, 12, 14, 16, 18]

# Cycle (infinite)
cycler = itertools.cycle([1, 2, 3])  # 1, 2, 3, 1, 2, 3, ...
list(islice(cycler, 6))  # [1, 2, 3, 1, 2, 3]

# Chain (combine iterables)
combined = itertools.chain([1, 2], [3, 4], [5, 6])
list(combined)  # [1, 2, 3, 4, 5, 6]

# Groupby
data = [("A", 1), ("A", 2), ("B", 3), ("B", 4)]
for key, group in itertools.groupby(data, key=lambda x: x[0]):
    print(key, list(group))

# Permutations and Combinations
list(itertools.permutations([1, 2, 3], 2))  # [(1,2), (1,3), (2,1), ...]
list(itertools.combinations([1, 2, 3], 2))  # [(1,2), (1,3), (2,3)]
```

---

## Generators vs Lists

| Feature | Generator | List |
|---------|-----------|------|
| Memory | O(1) per item | O(n) |
| Speed | Lazy (on-demand) | Eager (all at once) |
| Reusability | Single use | Multiple use |
| Access | Sequential only | Random access |
| Use when | Large/infinite data | Need all items at once |

---

## Common Patterns

### Delegating to Sub-generators (yield from)

```python
def flatten(nested):
    """Flatten nested lists using yield from."""
    for item in nested:
        if isinstance(item, list):
            yield from flatten(item)
        else:
            yield item

list(flatten([1, [2, 3], [4, [5, 6]]]))  # [1, 2, 3, 4, 5, 6]
```

### Generator Decorator

```python
import functools

def generator_decorator(func):
    """Ensure function returns a generator."""
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        return func(*args, **kwargs)
    return wrapper
```

---

## Interview Questions

1. What is the difference between a generator and an iterator?
2. When would you use a generator instead of a list?
3. How does `yield from` work?
4. What is the advantage of generator expressions over list comprehensions?
5. How do you create an infinite sequence with a generator?

---

## See Also

- [[Python]] — Python overview
- [[decorators]] — Decorators
- [[comprehensions]] — List/dict/set comprehensions
- [[oop]] — OOP concepts (custom iterators)
