# Python Syntax Basics

## Hello, World!
```python
print("Hello, World!")
```

## Variables and Data Types
```python
# Variables don't need type declaration
name = "Alice"        # String
age = 25              # Integer
height = 5.9          # Float
is_student = True     # Boolean
```

## Basic Data Types
- **int**: Integer numbers (..., -2, -1, 0, 1, 2, ...)
- **float**: Floating point numbers (3.14, -0.5, 2.0)
- **str**: Text ("hello", 'world')
- **bool**: True or False
- **None**: Represents absence of value

## Type Conversion
```python
# Convert to integer
int("42")      # 42
int(3.14)      # 3 (truncates)

# Convert to float
float("3.14")  # 3.14
float(42)      # 42.0

# Convert to string
str(42)        # "42"
str(3.14)      # "3.14"

# Convert to boolean
bool(0)        # False
bool(1)        # True
bool("")       # False
bool("hello")  # True
```

## Input and Output
```python
# Output
print("Hello")
print("Name:", name)
print(f"Age: {age}")  # f-string (Python 3.6+)
print("{} is {} years old".format(name, age))

# Input (always returns string)
name = input("What is your name? ")
age = int(input("How old are you? "))
```

## Operators

### Arithmetic
```python
+  # Addition
-  # Subtraction
*  # Multiplication
/  # Division (returns float)
// Floor division (returns int)
%  # Modulus (remainder)
** # Exponentiation
```

### Comparison
```python
==   # Equal to
!=   # Not equal to
<    # Less than
>    # Greater than
<=   # Less than or equal to
>=   # Greater than or equal to
```

### Logical
```python
and  # Logical AND
or   # Logical OR
not  # Logical NOT
```

## Control Flow

### Conditional Statements
```python
if age >= 18:
    print("Adult")
elif age >= 13:
    print("Teenager")
else:
    print("Child")
```

### Loops
```python
# For loop
for i in range(5):      # 0, 1, 2, 3, 4
    print(i)

for fruit in ["apple", "banana", "cherry"]:
    print(fruit)

# While loop
count = 0
while count < 5:
    print(count)
    count += 1

# Loop control
break   # Exit loop immediately
continue # Skip to next iteration
```

## Functions
```python
def greet(name):
    """Greets a person by name."""
    return f"Hello, {name}!"

def add(a, b):
    """Returns the sum of two numbers."""
    return a + b

# Function calls
message = greet("Alice")
result = add(5, 3)
```

### Function Parameters
```python
def greet(name, greeting="Hello"):
    return f"{greeting}, {name}!"

# Call with positional arguments
greet("Alice")           # "Hello, Alice!"
greet("Alice", "Hi")     # "Hi, Alice!"

# Call with keyword arguments
greet(name="Bob")
greet(greeting="Hey", name="Bob")
```

## Data Structures

### Lists (Arrays)
```python
# Creation
fruits = ["apple", "banana", "cherry"]
numbers = [1, 2, 3, 4, 5]
empty = []

# Access
fruits[0]        # "apple" (first element)
fruits[-1]       # "cherry" (last element)
fruits[1:3]      # ["banana", "cherry"] (slicing)

# Modification
fruits.append("orange")     # Add to end
fruits.insert(1, "blueberry")  # Insert at position
fruits.remove("banana")     # Remove first occurrence
popped = fruits.pop()       # Remove and return last item

# Methods
len(fruits)         # Length
fruits.sort()       # Sort in place
fruits.reverse()    # Reverse in place
```

### Tuples (Immutable)
```python
# Creation
point = (10, 20)
single_item = (5,)  # Note the comma
same_as_5 = (5)     # This is just integer 5!

# Access (same as lists)
point[0]  # 10

# Tuples are immutable:
# point[0] = 15  # Error!
```

### Dictionaries (Key-Value Storage)
```python
# Creation
student = {
    "name": "Alice",
    "age": 20,
    "major": "Computer Science"
}
empty_dict = {}

# Access
student["name"]        # "Alice"
student.get("age")     # 20 (returns None if key missing)
student.get("grade", "N/A")  # "N/A" if key missing

# Modification
student["age"] = 21
student["email"] = "alice@example.com"
del student["median"]  # Remove key-value pair

# Methods
list(student.keys())   # ["name", "age", "major"]
list(student.values()) # ["Alice", 20, "Computer Science"]
list(student.items())  # [("name", "Alice"), ...]
```

### Sets (Unique Elements)
```python
# Creation
numbers = {1, 2, 3, 2, 1}  # {1, 2, 3}
fruits = {"apple", "banana", "cherry"}

# Operations
numbers.add(4)
numbers.remove(2)
2 in numbers  # False (after removal)

# Set operations
a = {1, 2, 3}
b = {3, 4, 5}
a | b  # Union: {1, 2, 3, 4, 5}
a & b  # Intersection: {3}
a - b  # Difference: {1, 2}
a ^ b  # Symmetric difference: {1, 2, 4, 5}
```

## String Operations
```python
text = "Hello, World!"

# Indexing and slicing
text[0]      # 'H'
text[7:12]   # "World"
text[:5]     # "Hello"
text[7:]     # "World!"
text[-1]     # '!'

# Methods
text.upper()         # "HELLO, WORLD!"
text.lower()         # "hello, world!"
text.title()         # "Hello, World!"
text.strip()         # Removes whitespace
text.split(",")      # ["Hello", " World!"]
" ".join(["a", "b"]) # "a b"
text.replace("Hello", "Hi")  # "Hi, World!"
```

## Common Built-in Functions
```python
# Mathematical
abs(-5)        # 5
max(1, 5, 3)   # 5
min(1, 5, 3)   # 3
pow(2, 3)      # 8 (2^3)
round(3.14159, 2)  # 3.14

# Type conversion
len([1, 2, 3])     # 3
list("hello")      # ['h', 'e', 'l', 'l', 'o']
tuple([1, 2, 3])   # (1, 2, 3)
set([1, 1, 2, 2])  # {1, 2}
str(42)            # "42"
int("42 "42")        # 42

# Iteration helpers
range(5)           # 0, 1, 2, 3, 4
range(2, 8, 2)     # 2, 4, 6
enumerate(['a', 'b'])  # (0, 'a'), (1, 'b')
zip([1, 2], ['a', 'b']) # (1, 'a'), (2, 'b')
```

## Comments and Documentation
```python
# This is a single-line comment

"""
This is a
multi-line comment
or docstring
"""

def my_function():
    """
    This is a docstring.
    It explains what the function does.
    """
    pass
```

## Common Mistakes to Avoid

### 1. Indentation Errors
```python
# WRONG - inconsistent indentation
if True:
print("Hello")  # IndentationError

# CORRECT
if True:
    print("Hello")  # Consistent indentation
```

### 2. Using = instead of ==
```python
# WRONG - assignment instead of comparison
if x = 5:
    print("x is 5")

# CORRECT
if x == 5:
    print("x is 5")
```

### 3. Forgetting Colon
```python
# WRONG - missing colon
if x > 0
    print("Positive")

# CORRECT
if x > 0:
    print("Positive")
```

### 4. Off-by-one with range
```python
# Prints 0,1,2,3,4 (5 numbers)
for i in range(5):
    print(i)

# To get 1,2,3,4,5:
for i in range(1, 6):
    print(i)
```

### 5. Mutable Default Arguments
```python
# WRONG - shared between calls
def add_item(item, my_list=[]):
    my_list.append(item)
    return my_list

# CORRECT
def add_item(item, my_list=None):
    if my_list is None:
        my_list = []
    my_list.append(item)
    return my_list
```

## Practice Exercises

### Level 1
1. Write a program that asks for your name and age, then prints a message
2. Calculate the area of a rectangle given length and width
3. Check if a number is even or odd
4. Find the largest of three numbers
5. Print numbers from 1 to 10

### Level 2
1. Calculate factorial of a number
2. Check if a string is a palindrome
3. Find all prime numbers up to N
4. Reverse a list without using reverse()
5. Count vowels in a string

### Level 3
1. Implement bubble sort
2. Find the second largest number in a list
3. Check if two strings are anagrams
4. Implement a simple calculator (+,-,*,/)
5. Generate Fibonacci sequence up to N terms

## Next Steps
After mastering basic syntax, move on to:
- Data structures in depth (lists, dicts, sets)
- File I/O
- Functions scope and recursion
- Object-oriented programming basics
- Working with modules and packages
- Error handling with try/except
- List comprehensions and lambda functions

Remember: Practice by writing code, not just reading it!
