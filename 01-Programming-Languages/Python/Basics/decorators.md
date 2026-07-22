# Decorators in Python

## Overview

Decorators modify the behavior of functions or classes without changing their source
code. They are functions that take a function and return a new function, typically
using the `@decorator` syntax.

---

## Basic Syntax

```python
def my_decorator(func):
    def wrapper(*args, **kwargs):
        print("Before function call")
        result = func(*args, **kwargs)
        print("After function call")
        return result
    return wrapper

@my_decorator
def say_hello(name):
    print(f"Hello, {name}!")

# Equivalent to: say_hello = my_decorator(say_hello)
say_hello("Alice")
# Before function call
# Hello, Alice!
# After function call
```

---

## Common Decorators

### @property

```python
class Circle:
    def __init__(self, radius):
        self._radius = radius

    @property
    def radius(self):
        return self._radius

    @radius.setter
    def radius(self, value):
        if value < 0:
            raise ValueError("Radius cannot be negative")
        self._radius = value

    @property
    def area(self):
        return 3.14159 * self._radius ** 2

c = Circle(5)
print(c.radius)   # 5
print(c.area)     # 78.53975
c.radius = 10     # Works via setter
```

### @staticmethod and @classmethod

```python
class MathUtils:
    @staticmethod
    def add(a, b):
        return a + b

    @classmethod
    def from_string(cls, expr):
        a, b = map(int, expr.split("+"))
        return cls.add(a, b)

MathUtils.add(2, 3)              # 5
MathUtils.from_string("2+3")     # 5
```

### @functools.wraps

```python
import functools

def my_decorator(func):
    @functools.wraps(func)  # Preserves original function's metadata
    def wrapper(*args, **kwargs):
        return func(*args, **kwargs)
    return wrapper

@my_decorator
def greet(name):
    """Greet someone."""
    return f"Hello, {name}!"

print(greet.__name__)  # "greet" (not "wrapper")
print(greet.__doc__)   # "Greet someone."
```

---

## Decorators with Arguments

```python
import functools

def repeat(times):
    """Repeat a function `times` times."""
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            result = None
            for _ in range(times):
                result = func(*args, **kwargs)
            return result
        return wrapper
    return decorator

@repeat(times=3)
def greet(name):
    print(f"Hello, {name}!")
    return name

greet("Alice")
# Hello, Alice!
# Hello, Alice!
# Hello, Alice!
```

---

## Practical Decorators

### Timer

```python
import time
import functools

def timer(func):
    """Measure execution time."""
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        start = time.perf_counter()
        result = func(*args, **kwargs)
        elapsed = time.perf_counter() - start
        print(f"{func.__name__} took {elapsed:.4f}s")
        return result
    return wrapper

@timer
def slow_function():
    time.sleep(1)

slow_function()  # "slow_function took 1.0012s"
```

### Cache / Memoization

```python
import functools

@functools.lru_cache(maxsize=128)
def fibonacci(n):
    if n < 2:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)

print(fibonacci(100))  # Instant, cached results
print(fibonacci.cache_info())  # Cache statistics
```

### Retry

```python
import time
import functools

def retry(max_attempts=3, delay=1):
    """Retry a function on failure."""
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            for attempt in range(max_attempts):
                try:
                    return func(*args, **kwargs)
                except Exception as e:
                    if attempt == max_attempts - 1:
                        raise
                    print(f"Attempt {attempt + 1} failed: {e}")
                    time.sleep(delay)
        return wrapper
    return decorator

@retry(max_attempts=3, delay=0.5)
def unreliable_api():
    import random
    if random.random() < 0.7:
        raise ConnectionError("API unavailable")
    return "Success!"
```

### Validate Input

```python
import functools

def validate_types(*types):
    """Validate argument types."""
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            for arg, expected in zip(args, types):
                if not isinstance(arg, expected):
                    raise TypeError(
                        f"Expected {expected.__name__}, got {type(arg).__name__}"
                    )
            return func(*args, **kwargs)
        return wrapper
    return decorator

@validate_types(int, int)
def add(a, b):
    return a + b

add(2, 3)    # 5
add("2", 3)  # TypeError: Expected int, got str
```

### Rate Limit

```python
import time
import functools

def rate_limit(calls_per_second=10):
    """Limit function calls per second."""
    min_interval = 1.0 / calls_per_second
    last_called = [0.0]

    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            elapsed = time.time() - last_called[0]
            left_to_wait = min_interval - elapsed
            if left_to_wait > 0:
                time.sleep(left_to_wait)
            last_called[0] = time.time()
            return func(*args, **kwargs)
        return wrapper
    return decorator

@rate_limit(calls_per_second=5)
def api_call():
    print("API called!")

# Calls are rate-limited to 5 per second
```

---

## Class-Based Decorators

```python
class CountCalls:
    """Count how many times a function is called."""

    def __init__(self, func):
        self.func = func
        self.num_calls = 0

    def __call__(self, *args, **kwargs):
        self.num_calls += 1
        print(f"Call {self.num_calls} to {self.func.__name__}")
        return self.func(*args, **kwargs)

@CountCalls
def say_hello():
    print("Hello!")

say_hello()  # "Call 1 to say_hello" | "Hello!"
say_hello()  # "Call 2 to say_hello" | "Hello!"
print(say_hello.num_calls)  # 2
```

---

## Stacking Decorators

```python
@decorator_a
@decorator_b
def my_function():
    pass

# Equivalent to:
# my_function = decorator_a(decorator_b(my_function))
# Execution order: decorator_b wraps first, then decorator_a

@timer
@retry(max_attempts=3)
def critical_operation():
    pass

# retried first, then timed
```

---

## Decorator Patterns

### Caching with Custom Implementation

```python
import functools

def cache(max_size=128):
    """Simple caching decorator."""
    def decorator(func):
        cache_dict = {}

        @functools.wraps(func)
        def wrapper(*args):
            if args in cache_dict:
                return cache_dict[args]
            result = func(*args)
            if len(cache_dict) >= max_size:
                cache_dict.pop(next(iter(cache_dict)))
            cache_dict[args] = result
            return result

        wrapper.cache_clear = cache_dict.clear
        return wrapper
    return decorator
```

### Singleton Pattern

```python
def singleton(cls):
    """Ensure only one instance of a class exists."""
    instances = {}

    @functools.wraps(cls)
    def get_instance(*args, **kwargs):
        if cls not in instances:
            instances[cls] = cls(*args, **kwargs)
        return instances[cls]

    return get_instance

@singleton
class Database:
    def __init__(self):
        self.connection = "connected"

db1 = Database()
db2 = Database()
print(db1 is db2)  # True
```

---

## Interview Questions

1. What is the difference between a decorator and a higher-order function?
2. Why is `@functools.wraps` important?
3. How do you create a decorator that can be used with or without arguments?
4. What is the execution order when stacking decorators?
5. How would you implement a caching decorator?

---

## See Also

- [[Python]] — Python overview
- [[generators]] — Generators and iterators
- [[comprehensions]] — List/dict/set comprehensions
- [[oop]] — OOP concepts
