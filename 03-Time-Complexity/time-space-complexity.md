# Time and Space Complexity

## Big O Notation

Big O notation describes the upper bound of an algorithm's growth rate. It characterizes how the runtime or space requirements grow as the input size increases.

### Common Complexities

| Big O | Name | Example | Growth |
|-------|------|---------|--------|
| O(1) | Constant | Array access | Best |
| O(log n) | Logarithmic | Binary search | Great |
| O(n) | Linear | Linear search | Good |
| O(n log n) | Linearithmic | Merge sort | Fair |
| O(n²) | Quadratic | Bubble sort | Poor |
| O(n³) | Cubic | Matrix multiplication | Bad |
| O(2ⁿ) | Exponential | Recursive Fibonacci | Terrible |
| O(n!) | Factorial | Brute force permutations | Worst |

### Growth Rate Visualization

```
n = 10:
O(1)      = 1
O(log n)  = 3
O(n)      = 10
O(n log n) = 33
O(n²)     = 100
O(2ⁿ)     = 1024
O(n!)     = 3,628,800
```

## Time Complexity Analysis

### Constant Time - O(1)
```python
def get_first(arr):
    return arr[0]  # Always one operation
```

### Linear Time - O(n)
```python
def find_max(arr):
    max_val = arr[0]
    for num in arr:  # Loops through n elements
        if num > max_val:
            max_val = num
    return max_val
```

### Quadratic Time - O(n²)
```python
def bubble_sort(arr):
    n = len(arr)
    for i in range(n):        # n iterations
        for j in range(n-i-1):  # up to n iterations
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
```

### Logarithmic Time - O(log n)
```python
def binary_search(arr, target):
    left, right = 0, len(arr) - 1
    while left <= right:      # Halves search space each iteration
        mid = (left + right) // 2
        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    return -1
```

## Space Complexity Analysis

### O(1) Space
```python
def sum_array(arr):
    total = 0
    for num in arr:
        total += num
    return total  # Only one extra variable
```

### O(n) Space
```python
def create_copy(arr):
    copy = []           # New array of size n
    for num in arr:
        copy.append(num)
    return copy
```

### O(log n) Space
```python
def binary_search_recursive(arr, target, left, right):
    if left > right:
        return -1
    mid = (left + right) // 2
    if arr[mid] == target:
        return mid
    elif arr[mid] < target:
        return binary_search_recursive(arr, target, mid + 1, right)
    else:
        return binary_search_recursive(arr, target, left, mid - 1)
    # Recursion depth = log n
```

## Common Complexity Patterns

### Nested Loops
```python
# O(n²)
for i in range(n):
    for j in range(n):
        # constant work
```

### Loop with Halving
```python
# O(log n)
i = 1
while i < n:
    i *= 2
```

### Sequential Loops
```python
# O(n + m)
for i in range(n):
    # work
for j in range(m):
    # work
```

### Multiplicative Loops
```python
# O(n × m)
for i in range(n):
    for j in range(m):
        # work
```

## Best, Average, Worst Case

| Algorithm | Best | Average | Worst |
|-----------|------|---------|-------|
| Bubble Sort | O(n) | O(n²) | O(n²) |
| Quick Sort | O(n log n) | O(n log n) | O(n²) |
| Merge Sort | O(n log n) | O(n log n) | O(n log n) |
| Binary Search | O(1) | O(log n) | O(log n) |
| Linear Search | O(1) | O(n) | O(n) |

## Amortized Analysis

Some operations have occasional expensive costs but average out:
- **Dynamic Array Insert**: O(1) amortized (occasional O(n) resize)
- **Stack Push/Pop**: O(1) amortized
- **HashMap Insert**: O(1) amortized (occasional rehash)

## Tips for Analysis

1. Drop constants: O(2n) = O(n)
2. Drop lower order terms: O(n² + n) = O(n²)
3. Consider worst case for safety
4. Count operations, not time
5. Analyze recursive algorithms with recurrence relations