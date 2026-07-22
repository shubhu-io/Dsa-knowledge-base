# File Handling in Python

## Overview

Python provides built-in functions and the `os` module for working with files and
directories. Always use the `with` statement to ensure files are properly closed.

---

## Reading Files

### Basic Reading

```python
# Read entire file
with open("data.txt", "r") as f:
    content = f.read()

# Read line by line
with open("data.txt", "r") as f:
    for line in f:
        print(line.strip())

# Read all lines into a list
with open("data.txt", "r") as f:
    lines = f.readlines()  # Includes newline characters

# Read without newlines
with open("data.txt", "r") as f:
    lines = [line.strip() for line in f]
```

### Reading in Chunks

```python
# Read in chunks (good for large files)
with open("large_file.txt", "r") as f:
    while True:
        chunk = f.read(1024)  # Read 1024 bytes at a time
        if not chunk:
            break
        process(chunk)
```

---

## Writing Files

### Basic Writing

```python
# Write (overwrites existing content)
with open("output.txt", "w") as f:
    f.write("Hello, World!\n")
    f.write("Second line\n")

# Append to file
with open("output.txt", "a") as f:
    f.write("Appended line\n")

# Write multiple lines
lines = ["Line 1\n", "Line 2\n", "Line 3\n"]
with open("output.txt", "w") as f:
    f.writelines(lines)
```

### Using print()

```python
# print() to file
with open("output.txt", "w") as f:
    print("Hello", file=f)
    print("World", file=f)
```

---

## File Modes

| Mode | Description |
|------|-------------|
| `"r"` | Read (default) |
| `"w"` | Write (truncates file) |
| `"a"` | Append |
| `"x"` | Create (fails if exists) |
| `"b"` | Binary mode (add to other modes: `"rb"`, `"wb"`) |
| `"t"` | Text mode (default, add to other modes: `"rt"`) |
| `"+"` | Read and write (`"r+"`, `"w+"`, `"a+"`) |

```python
# Binary mode (for images, videos, etc.)
with open("image.jpg", "rb") as f:
    data = f.read()

with open("copy.jpg", "wb") as f:
    f.write(data)
```

---

## Working with Paths (os.path and pathlib)

### Using os.path

```python
import os

# Path operations
path = "/home/user/documents/file.txt"
os.path.basename(path)      # "file.txt"
os.path.dirname(path)       # "/home/user/documents"
os.path.splitext(path)      # ("/home/user/documents/file", ".txt")
os.path.exists(path)        # True or False
os.path.isfile(path)        # True if file
os.path.isdir(path)         # True if directory
os.path.getsize(path)       # File size in bytes

# Join paths (cross-platform)
full_path = os.path.join("folder", "subfolder", "file.txt")

# List directory
files = os.listdir("/home/user")
```

### Using pathlib (Modern, Recommended)

```python
from pathlib import Path

# Create Path object
p = Path("/home/user/documents/file.txt")

# Path operations
p.name          # "file.txt"
p.stem          # "file"
p.suffix        # ".txt"
p.parent        # Path("/home/user/documents")
p.exists()      # True or False
p.is_file()     # True if file
p.is_dir()      # True if directory
p.stat().st_size # File size in bytes

# Join paths
full_path = Path("folder") / "subfolder" / "file.txt"

# Read/Write (pathlib makes it easy)
content = p.read_text()
p.write_text("Hello, World!")

# List directory
for f in Path(".").iterdir():
    print(f.name)

# Glob patterns
py_files = list(Path(".").glob("*.py"))
recursive = list(Path(".").glob("**/*.txt"))  # Recursive
```

---

## CSV Files

```python
import csv

# Reading CSV
with open("data.csv", "r") as f:
    reader = csv.reader(f)
    header = next(reader)  # First row
    for row in reader:
        print(row)

# Writing CSV
with open("output.csv", "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(["Name", "Age", "City"])
    writer.writerow(["Alice", 30, "NYC"])
    writer.writerow(["Bob", 25, "SF"])

# Using DictReader/DictWriter
with open("data.csv", "r") as f:
    reader = csv.DictReader(f)
    for row in reader:
        print(row["Name"], row["Age"])
```

---

## JSON Files

```python
import json

# Reading JSON
with open("data.json", "r") as f:
    data = json.load(f)  # Python dict/list

# Writing JSON
data = {"name": "Alice", "age": 30, "hobbies": ["reading", "coding"]}
with open("output.json", "w") as f:
    json.dump(data, f, indent=2)

# Pretty print
print(json.dumps(data, indent=2))
```

---

## Temporary Files

```python
import tempfile

# Create temporary file
with tempfile.NamedTemporaryFile(mode="w", suffix=".txt", delete=False) as f:
    f.write("temporary data")
    temp_path = f.name

# Create temporary directory
with tempfile.TemporaryDirectory() as tmpdir:
    # Use tmpdir for temporary storage
    # Directory is automatically deleted when context exits
    pass
```

---

## Error Handling

```python
# Handle file not found
try:
    with open("nonexistent.txt", "r") as f:
        content = f.read()
except FileNotFoundError:
    print("File not found!")
except PermissionError:
    print("Permission denied!")
except IOError as e:
    print(f"IO error: {e}")
```

---

## Common Patterns

### Process Large File Line by Line

```python
# Memory-efficient processing of large files
def process_large_file(filepath):
    with open(filepath, "r") as f:
        for line_num, line in enumerate(f, 1):
            process_line(line.strip())
```

### Copy a File

```python
import shutil

shutil.copy2("source.txt", "dest.txt")  # Preserves metadata
shutil.copy("source.txt", "dest.txt")   # Without metadata
```

### File Compression

```python
import gzip

# Write compressed
with gzip.open("data.gz", "wt") as f:
    f.write("compressed content")

# Read compressed
with gzip.open("data.gz", "rt") as f:
    content = f.read()
```

---

## Quick Reference

| Task | Code |
|------|------|
| Read file | `open("f.txt").read()` |
| Read lines | `open("f.txt").readlines()` |
| Write file | `open("f.txt", "w").write("data")` |
| Append | `open("f.txt", "a").write("data")` |
| Check exists | `Path("f.txt").exists()` |
| List files | `os.listdir(".")` or `Path(".").iterdir()` |
| File size | `os.path.getsize("f.txt")` or `Path("f.txt").stat().st_size` |
| Delete file | `os.remove("f.txt")` or `Path("f.txt").unlink()` |
| Rename | `os.rename("old.txt", "new.txt")` |
| Create dir | `os.makedirs("dir/sub")` or `Path("dir/sub").mkdir(parents=True)` |

---

## Interview Questions

1. What is the difference between `read()`, `readline()`, and `readlines()`?
2. Why should you use the `with` statement instead of manually calling `close()`?
3. How do you efficiently process a multi-GB file without loading it into memory?
4. What is the difference between text mode and binary mode?
5. How do you handle CSV files with inconsistent column counts?

---

## See Also

- [[Python]] — Python overview
- [[Basics/syntax]] — Python syntax basics
- [[error-handling]] — Exception handling
