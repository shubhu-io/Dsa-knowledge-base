# Error Handling in Python

## Overview

Python uses exceptions to handle errors. Exceptions are objects that represent errors
that occur during program execution. The `try/except/else/finally` block is the
primary mechanism for handling them.

---

## Basic Syntax

```python
try:
    # Code that might raise an exception
    result = 10 / 0
except ZeroDivisionError:
    # Handle specific exception
    print("Cannot divide by zero!")
except (TypeError, ValueError) as e:
    # Handle multiple exceptions
    print(f"Error: {e}")
except Exception as e:
    # Catch all other exceptions (use sparingly)
    print(f"Unexpected error: {e}")
else:
    # Runs only if no exception was raised
    print("Operation successful")
finally:
    # Always runs, whether or not an exception occurred
    print("Cleanup code here")
```

---

## Common Built-in Exceptions

| Exception | Description |
|-----------|-------------|
| `ValueError` | Wrong value (e.g., `int("abc")`) |
| `TypeError` | Wrong type (e.g., `"2" + 2`) |
| `IndexError` | Index out of range |
| `KeyError` | Dictionary key not found |
| `FileNotFoundError` | File doesn't exist |
| `AttributeError` | Attribute doesn't exist |
| `ImportError` | Module import fails |
| `ZeroDivisionError` | Division by zero |
| `StopIteration` | Iterator exhausted |
| `RecursionError` | Maximum recursion depth exceeded |

```python
# ValueError
try:
    num = int("abc")
except ValueError as e:
    print(f"Invalid conversion: {e}")

# KeyError
try:
    value = my_dict["missing_key"]
except KeyError as e:
    print(f"Key not found: {e}")

# IndexError
try:
    item = my_list[100]
except IndexError as e:
    print(f"Index out of range: {e}")
```

---

## Raising Exceptions

```python
def set_age(age: int) -> None:
    if not isinstance(age, int):
        raise TypeError("Age must be an integer")
    if age < 0 or age > 150:
        raise ValueError(f"Age must be between 0 and 150, got {age}")
    print(f"Age set to {age}")

# Usage
try:
    set_age(-5)
except ValueError as e:
    print(e)  # "Age must be between 0 and 150, got -5"
```

---

## Custom Exceptions

```python
class InsufficientFundsError(Exception):
    """Raised when withdrawal exceeds balance."""

    def __init__(self, balance: float, amount: float):
        self.balance = balance
        self.amount = amount
        super().__init__(
            f"Cannot withdraw ${amount:.2f}. Balance: ${balance:.2f}"
        )

class BankAccount:
    def __init__(self, balance: float = 0):
        self.balance = balance

    def withdraw(self, amount: float) -> float:
        if amount > self.balance:
            raise InsufficientFundsError(self.balance, amount)
        self.balance -= amount
        return self.balance

# Usage
account = BankAccount(100)
try:
    account.withdraw(150)
except InsufficientFundsError as e:
    print(e)  # "Cannot withdraw $150.00. Balance: $100.00"
    print(f"Tried to withdraw: ${e.amount}")
    print(f"Current balance: ${e.balance}")
```

---

## Exception Chaining

```python
# Raise a new exception while preserving the original
try:
    result = int("abc")
except ValueError as original:
    raise RuntimeError("Conversion failed") from original

# Output shows both exceptions:
# During handling of the above exception, another exception occurred:
# ...
# ValueError: invalid literal for int() with base 10: 'abc'
```

---

## Context Managers (with statement)

```python
class FileManager:
    """Context manager for file handling."""

    def __init__(self, filename: str, mode: str):
        self.filename = filename
        self.mode = mode
        self.file = None

    def __enter__(self):
        self.file = open(self.filename, self.mode)
        return self.file

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.file:
            self.file.close()
        if exc_type is not None:
            print(f"Exception occurred: {exc_val}")
        return False  # Don't suppress exception

# Usage
with FileManager("test.txt", "w") as f:
    f.write("Hello, World!")
```

### Using contextlib

```python
from contextlib import contextmanager

@contextmanager
def managed_resource(name):
    print(f"Acquiring {name}")
    resource = {"name": name, "active": True}
    try:
        yield resource
    except Exception as e:
        print(f"Error with {name}: {e}")
        resource["active"] = False
    finally:
        print(f"Releasing {name}")

# Usage
with managed_resource("database") as db:
    print(f"Using {db['name']}")
```

---

## Logging Exceptions

```python
import logging

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

def risky_operation():
    try:
        result = 10 / 0
    except ZeroDivisionError:
        logger.error("Division by zero", exc_info=True)
        raise  # Re-raise after logging

# Or log the full traceback
import traceback

try:
    risky_operation()
except Exception:
    logger.error("Operation failed:\n%s", traceback.format_exc())
```

---

## Assertions

```python
# Assertions are for debugging — they should catch programmer errors,
# not user input errors

def calculate_average(numbers: list) -> float:
    assert len(numbers) > 0, "List cannot be empty"
    assert all(isinstance(n, (int, float)) for n in numbers), "All items must be numbers"
    return sum(numbers) / len(numbers)

# Assertions are removed when running with -O flag
# python -O script.py  (assertions are skipped)
```

---

## Best Practices

### Do

```python
# 1. Be specific about exceptions
try:
    value = my_dict["key"]
except KeyError:
    handle_missing_key()

# 2. Use finally for cleanup
try:
    resource = acquire_resource()
    do_work(resource)
finally:
    release_resource(resource)

# 3. Log exceptions with context
try:
    process_data(data)
except Exception:
    logger.exception("Failed to process data")
    raise
```

### Don't

```python
# BAD: Catching all exceptions
try:
    do_something()
except:
    pass  # Silently swallows ALL errors

# BAD: Catching and ignoring
try:
    risky_operation()
except Exception:
    pass  # Hides bugs

# BAD: Using exceptions for flow control
try:
    value = my_dict["key"]
except KeyError:
    value = default  # Use dict.get() instead
```

---

## Exception Hierarchy

```
BaseException
├── SystemExit
├── KeyboardInterrupt
├── GeneratorExit
└── Exception
    ├── StopIteration
    ├── ArithmeticError
    │   ├── ZeroDivisionError
    │   ├── OverflowError
    │   └── FloatingPointError
    ├── AttributeError
    ├── EOFError
    ├── ImportError
    │   └── ModuleNotFoundError
    ├── LookupError
    │   ├── IndexError
    │   └── KeyError
    ├── NameError
    │   └── UnboundLocalError
    ├── OSError
    │   ├── FileNotFoundError
    │   ├── FileExistsError
    │   └── PermissionError
    ├── RuntimeError
    │   ├── NotImplementedError
    │   └── RecursionError
    ├── SyntaxError
    │   └── IndentationError
    ├── TypeError
    └── ValueError
```

---

## Quick Reference

| Pattern | Code |
|---------|------|
| Basic try/except | `try: ... except E: ...` |
| Catch all | `except Exception as e:` |
| Always run | `finally: ...` |
| Raise exception | `raise ValueError("msg")` |
| Custom exception | `class MyError(Exception): pass` |
| Assert | `assert condition, "message"` |
| Context manager | `with resource as r: ...` |

---

## Interview Questions

1. What is the difference between `try/except/else/finally`?
2. When should you use custom exceptions vs built-in exceptions?
3. What is exception chaining and when is it useful?
4. What happens if you don't catch an exception?
5. What is the difference between `raise` and `raise from`?

---

## See Also

- [[Python]] — Python overview
- [[file-handling]] — File I/O with error handling
- [[decorators]] — Decorators can handle errors too
