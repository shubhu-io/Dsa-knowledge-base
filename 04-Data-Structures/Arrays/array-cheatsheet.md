# Array Cheat Sheet

## Core Concepts

### What is an Array?
A data structure that stores elements of the same type in contiguous memory locations, allowing efficient index-based access.

### Key Properties
- **Contiguous Memory**: Elements stored sequentially in memory
- **Fixed Size**: Static arrays have predetermined size (dynamic arrays can resize)
- **Homogeneous Elements**: All elements must be of the same data type
- **Index-Based Access**: Elements accessed using numerical indices (typically 0-based)
- **Random Access**: O(1) time complexity for accessing any element by index
- **Cache Friendly**: Spatial locality due to contiguous memory layout

## Memory Layout and Address Calculation

### Single-Dimensional Array
```
Memory Address:  2000    2004    2008    2012    2016    2020
Element Index:      0       1       2       3       4       5
Element Value:     10      20      30      40      50      60
                  [byte 0-3][4-7][8-11][12-15][16-19][20-23]
```

**Address Calculation Formula**:
```
address_of_element[i] = base_address + (i × element_size_in_bytes)
```

### Two-Dimensional Array (Row-Major Order)
```
                 Column 0   Column 1   Column 2
Row 0        [  a00     a01     a02    ]
Row 1        [  a10     a11     a12    ]
Row 2        [  a20     a21     a22    ]
```

**Address Calculation Formula (Row-Major)**:
```
address[row][col] = base_address + ((row × number_of_columns) + col) × element_size
```

**Address Calculation Formula (Column-Major)**:
```
address[row][col] = base_address + ((col × number_of_rows) + row) × element_size
```

## Types of Arrays

| Type | Description | Use Cases |
|------|-------------|-----------|
| **Static Array** | Fixed size at compile/allocation time | Embedded systems, performance-critical code |
| **Dynamic Array** | Resizable array (e.g., Vector, ArrayList) | General-purpose containers, when size changes |
| **Multi-dimensional Array** | Array of arrays (matrices, tensors) | Mathematical computations, graphics, game boards |
| **Jagged Array** | Array where each row can have different length | Text processing, sparse data representation |
| **Sparse Array** | Optimized for arrays with many default values | Scientific computing, large mostly-empty matrices |
| **Circular Buffer** | Fixed-size buffer treating end as connected to beginning | Queues, buffering, streaming data |
| **Bit Array** | Array storing individual bits | Flags, bitsets, bloom filters |

## Core Operations and Time Complexities

### Access Operations
| Operation | Time Complexity | Space Complexity | Description |
|-----------|----------------|------------------|-------------|
| Access by Index | O(1) | O(1) | Direct memory calculation |
| Access by Index (2D) | O(1) | O(1) | Formula-based calculation |
| Boundary Check | O(1) | O(1) | Verify index is valid |

### Search Operations
| Operation | Time Complexity | Space Complexity | Description |
|-----------|----------------|------------------|-------------|
| Linear Search | O(n) | O(1) | Sequential scan |
| Binary Search | O(log n) | O(1) | Requires sorted array |
| Find Min/Max | O(n) | O(1) | Single pass scan |
| Find Kth Smallest | O(n) avg | O(1) | Quickselect algorithm |

### Modification Operations
| Operation | Time Complexity | Space Complexity | Description |
|-----------|----------------|------------------|-------------|
| Update Element | O(1) | O(1) | Direct access and modification |
| Insert at End | O(1)* | O(1)* | *Amortized for dynamic arrays |
| Insert at Beginning | O(n) | O(1) | Requires shifting all elements |
| Insert at Middle | O(n) | O(1) | Requires shifting elements |
| Delete from End | O(1) | O(1) | Simple removal |
| Delete from Beginning | O(n) | O(1) | Requires shifting all elements |
| Delete from Middle | O(n) | O(1) | Requires shifting elements |
| Insert Many Elements | O(n+m) | O(1) | m = number of elements to insert |

### Bulk Operations
| Operation | Time Complexity | Space Complexity | Description |
|-----------|----------------|------------------|-------------|
| Copy Array | O(n) | O(n) | Element-by-element copying |
| Fill Array | O(n) | O(1) | Set all elements to value |
| Compare Arrays | O(n) | O(1) | Element-by-element comparison |
| Reverse Array | O(n) | O(1) | In-place reversal |
| Sort Array | O(n log n) | O(1) or O(n) | Depends on algorithm |

## Common Algorithms and Patterns

### 1. Two Pointers Technique
**Use Cases**: Finding pairs, removing duplicates, reversing arrays
**Pattern**: 
```python
left, right = 0, len(arr) - 1
while left < right:
    # Process arr[left] and arr[right]
    if condition:
        left += 1
    else:
        right -= 1
```

**Examples**: 
- Two Sum (sorted array)
- Reverse array
- Remove duplicates from sorted array
- Container with most water
- 3Sum

### 2. Sliding Window
**Use Cases**: Finding subarrays/substrings with specific properties
**Pattern**:
```python
left = 0
for right in range(len(arr)):
    # Expand window by including arr[right]
    while condition_not_met:
        # Shrink window by removing arr[left]
        left += 1
    # Update answer based on current window
```

**Examples**:
- Maximum sum subarray of size k
- Longest substring without repeating characters
- Minimum size subarray sum
- Fruit baskets problem

### 3. Prefix Sum
**Use Cases**: Range sum queries, subarray sum problems
**Pattern**:
```python
# Precompute prefix sums
prefix = [0] * (len(arr) + 1)
for i in range(len(arr)):
    prefix[i+1] = prefix[i] + arr[i]

# Range sum from i to j (inclusive)
range_sum = prefix[j+1] - prefix[i]
```

**Examples**:
- Range sum queries
- Subarray sum equals k
- Product of array except self
- Continuous subarray sum

### 4. Frequency Counting
**Use Cases**: Finding duplicates, counting occurrences, grouping similar elements
**Pattern**:
```python
freq = {}
for element in array:
    freq[element] = freq.get(element, 0) + 1
```

**Examples**:
- First non-repeating character
- Find all duplicates in array
- Top K frequent elements
- Group anagrams
- Valid anagram

### 5. In-Place Modification
**Use Cases**: Rearranging elements without extra space
**Techniques**:
- Overwriting elements
- Swapping elements
- Using two pointers to separate elements
- Using array indices as markers (negation, adding n, etc.)

**Examples**:
- Remove duplicates
- Move zeros to end
- Rotate array
- Set matrix zeroes
- First missing positive

## Implementation Language-Specific Notes

### C/C++
- **Static Arrays**: `int arr[100];` (stack allocation)
- **Dynamic Arrays**: `int* arr = new int[size];` (heap allocation) or `std::vector<int> arr;`
- **Pointer Arithmetic**: `*(arr + i)` is equivalent to `arr[i]`
- **Array Decay**: Arrays passed to functions become pointers
- **sizeof Operator**: `sizeof(arr)/sizeof(arr[0])` gives array length (only works in scope where declared)
- **Multidimensional Layout**: Row-major order by default
- **Library Functions**: `memcpy`, `memmove`, `std::copy`, `std::fill`

### Java
- **Declaration**: `int[] arr = new int[100];` or `int[] arr = {1,2,3};`
- **ArrayList**: `ArrayList<Integer> list = new ArrayList<>();` (dynamic array)
- **Bounds Checking**: Automatic on every access (performance overhead)
- **Utility Methods**: `Arrays.copyOf()`, `Arrays.fill()`, `Arrays.sort()`, `Arrays.binarySearch()`
- **Multidimensional**: `int[][] matrix = new int[3][4];`
- **System.arraycopy()**: Most efficient way to copy arrays
- **Arrays.asList()**: Fixed-size list backed by array

### Python
- **Lists**: Dynamic arrays of object references (`[1, 2, 3]`)
- **Everything is Object**: Boxing overhead for primitive types
- **List Methods**: `append()`, `insert()`, `pop()`, `remove()`, `sort()`, `reverse()`
- **Slicing**: `arr[start:stop:step]` creates new list (shallow copy)
- **Negative Indices**: `arr[-1]` is last element
- **List Comprehensions**: `[x*2 for x in arr]` for transformations
- **array module**: `array.array('i', [1,2,3])` for typed arrays (more memory efficient)
- **Time Complexity Guarantees**: Documented in Python docs

### JavaScript
- **Arrays are Objects**: Specialized objects with numeric keys and length property
- **Dynamic**: Size can change automatically
- **Sparse Arrays**: Possible to have "holes" (missing indices)
- **Methods**: `push()`, `pop()`, `shift()`, `unshift()`, `splice()`, `slice()`
- **Iteration Methods**: `forEach()`, `map()`, `filter()`, `reduce()`, `some()`, `every()`
- **Typed Arrays**: `Int8Array`, `Uint8Array`, `Int16Array`, `Uint16Array`, `Int32Array`, `Uint32Array`, `Float32Array`, `Float64Array`
- **Performance**: Varies between engines (V8, SpiderMonkey, JavaScriptCore)
- **Copy-on-Write**: Some operations use copy-on-write semantics

## Space-Time Tradeoffs

### Compared to Linked Lists
| Aspect | Array | Linked List |
|--------|-------|-------------|
| Access | O(1) | O(n) |
| Insertion/Deletion | O(n) | O(1)* |
| Memory Overhead | Low | High (pointers) |
| Cache Locality | Excellent | Poor |
| Size Flexibility | Limited (dynamic arrays help) | Excellent |
| *With known position |

### Compared to Hash Tables
| Aspect | Array | Hash Table |
|--------|-------|------------|
| Access by Index | O(1) | N/A |
| Access by Key | O(n) | O(1) avg |
| Insertion | O(n)* | O(1) avg |
| Deletion | O(n)* | O(1) avg |
| Memory Usage | Lower | Higher (buckets, pointers) |
| Ordering | Maintains insertion order | No guaranteed order |
| *At beginning/middle; O(1) at end for dynamic arrays |

### Compared to Binary Search Trees
| Aspect | Array (Sorted) | BST |
|--------|----------------|-----|
| Search | O(log n) | O(log n) avg, O(n) worst |
| Insertion | O(n) | O(log n) avg, O(n) worst |
| Deletion | O(n) | O(log n) avg, O(n) worst |
| Min/Max | O(1) | O(log n) avg, O(n) worst |
| Predecessor/Successor | O(1) | O(log n) avg, O(n) worst |
| Range Queries | O(k + log n) | O(k + log n) |
| Memory | Lower | Higher (pointers) |
| Implementation | Simple | More complex |

## When to Use Arrays

### ✅ Use Arrays When:
- You need fast access by index (O(1))
- Memory efficiency is important
- Dataset size is known or bounded
- You perform frequent iterations
- Cache performance matters (due to locality)
- You need to maintain insertion order
- Implementing other data structures (heaps, hash tables, etc.)

### ❌ Avoid Arrays When:
- You need frequent insertions/deletions at beginning/middle
- Dataset size changes frequently and unpredictably
- You need heterogeneous data types (in statically typed languages)
- Memory is severely fragmented
- You need guaranteed O(1) insertion/deletion everywhere
- You need frequent searching by value (not index)

## Common Pitfalls and How to Avoid Them

### 1. Off-by-One Errors
**Problem**: Incorrect loop bounds or index calculations
**Solution**:
- Remember valid indices are 0 to length-1
- Use `< length` not `<= length` in loops
- Test with edge cases: empty array, single element, two elements
- Draw diagrams to visualize indices

### 2. Assuming O(1) Insertion
**Problem**: Thinking all insertions are constant time
**Solution**:
- Only appending to dynamic arrays is amortized O(1)
- Insertion at beginning/middle is O(n) due to shifting
- Consider linked lists or other data structures if frequent middle insertions needed

### 3. Forgetting Array Decay (C/C++)
**Problem**: Passing arrays to functions loses size information
**Solution**:
- Pass size as separate parameter
- Use structs to wrap array and size
- Use `std::array` or `std::vector` in C++
- Use templates to deduce array size (C++11+)

### 4. Memory Waste in Dynamic Arrays
**Problem**: Overallocating leads to wasted memory
**Solution**:
- Initialize with reasonable capacity if size is known
- Consider shrink-to-fit when size decreases significantly
- Be aware of growth factor (usually 2x) and its memory implications
- Use `reserve()`/`shrink_to_fit()` in C++ vectors when appropriate

### 5. Ignoring Cache Benefits
**Problem**: Not leveraging spatial locality
**Solution**:
- Access elements sequentially when possible
- Consider data layout transformation (AoS vs SoA)
- Use blocking/tiling for multidimensional access
- Profile to identify cache-miss bottlenecks

### 6. Confusing Value vs Reference Types
**Problem**: Unexpected behavior when arrays contain objects
**Solution**:
- Understand whether your language uses value or reference semantics
- In Java/C#/Python: array elements are references to objects
- In C/C++: depends on whether you store objects or pointers
- Be careful with mutable objects in arrays

### 7. Incorrect Multidimensional Array Indexing
**Problem**: Mixing up row-major and column-major calculations
**Solution**:
- Know which language uses which ordering (C/C++/Java/Python: row-major; Fortran/MATLAB: column-major)
- Draw small examples to verify
- Encapsulate access in helper functions/macros

## Performance Optimization Techniques

### 1. Loop Optimization
```c
// Naive version
for (int i = 0; i < n; i++) {
    result += process(array[i]);
}

// Optimized versions:
// Loop unrolling (process 4 elements per iteration)
for (int i = 0; i < n; i += 4) {
    result += process(array[i]);
    result += process(array[i+1]);
    result += process(array[i+2]);
    result += process(array[i+3]);
    // Handle remainder...
}

// Cache blocking for 2D arrays
for (int ii = 0; ii < n; ii += BLOCK_SIZE) {
    for (int jj = 0; jj < n; jj += BLOCK_SIZE) {
        for (int i = ii; i < min(ii+BLOCK_SIZE, n); i++) {
            for (int j = jj; j < min(jj+BLOCK_SIZE, n); j++) {
                result += process(matrix[i][j]);
            }
        }
    }
}
```

### 2. Memory Access Patterns
- **Prefer sequential access** over random access
- **Access stride-1 patterns** for best prefetching
- **Consider data layout transformation** (AoS vs SoA)
- **Use blocking/tiling** for multidimensional access
- **Align data to cache line boundaries** (typically 64 bytes)

### 3. Reference Locality Improvements
- **Structure of Arrays (SoA)** vs **Array of Structures (AoS)**
- **Data partitioning** for cache efficiency
- **Memory pooling** to reduce allocation/fragmentation
- **Object reuse** to minimize allocation overhead

### 4. SIMD Vectorization
Modern CPUs can process multiple array elements simultaneously:
- **Intel SSE/AVX**: 128-bit/256-bit/512-bit registers
- **ARM NEON**: 64-bit/128-bit registers
- **GPU threads**: Massive parallelism

**Example**: Vector addition with SIMD
```c
// Pseudocode for SIMD vector addition
for (int i = 0; i < n; i += VECTOR_SIZE) {
    // Load VECTOR_SIZE elements into vector registers
    vec_a = load_vector(&a[i]);
    vec_b = load_vector(&b[i]);
    
    // Perform operation on all elements in parallel
    vec_result = add_vectors(vec_a, vec_b);
    
    // Store results back to memory
    store_vector(&result[i], vec_result);
}
```

## Specialized Arrays

### Bit Arrays
- Store individual bits rather than bytes
- Each element represents a boolean value (0 or 1)
- Memory efficient for large sets of boolean flags
- Operations: bitwise AND, OR, XOR, NOT, shifts
- Used in: bitmap indices, bloom filters, bitsets

### Circular Buffers (Ring Buffers)
- Fixed-size buffer treating end as connected to beginning
- Efficient for FIFO queues and streaming data
- No need to shift elements on enqueue/dequeue
- Implementation: maintain head and tail pointers
- Used in: hardware drivers, audio processing, network packets

### Sparse Arrays
- Optimized for arrays with many default/zero values
- Only store non-default values with their indices
- Significant memory savings when sparsity is high
- Implementations: hash maps, coordinate lists, compressed sparse row (CSR)
- Used in: scientific computing, graphics, machine learning, graph algorithms

## Mathematical Properties

### Sum of Elements
```
Sum = Σ(array[i]) for i = 0 to n-1
```

### Mean (Average)
```
Mean = (Σ(array[i])) / n
```

### Variance
```
Variance = (Σ((array[i] - mean)²)) / n
```

### Standard Deviation
```
StdDev = sqrt(Variance)
```

### Dot Product (for vectors)
```
A · B = Σ(A[i] * B[i]) for i = 0 to n-1
```

### Cross Product (3D vectors)
```
A × B = [A[1]*B[2] - A[2]*B[1], 
         A[2]*B[0] - A[0]*B[2], 
         A[0]*B[1] - A[1]*B[0]]
```

### Matrix Operations
- **Addition**: C[i][j] = A[i][j] + B[i][j]
- **Multiplication**: C[i][j] = Σ(A[i][k] * B[k][j]) for k = 0 to n-1
- **Transpose**: B[j][i] = A[i][j]
- **Trace**: sum(A[i][i]) for i = 0 to n-1
- **Determinant**: Recursive calculation (O(n!) naive, O(n³) with LU decomposition)

## Real-World Applications

### 1. Database Systems
- Indexing (primary keys, secondary indexes)
- Join operations (hash joins, merge joins)
- Buffer pools for caching disk pages
- Storing tuples/records in tables

### 2. Graphics and Game Development
- Frame buffers (pixel arrays)
- Texture maps
- Vertex buffers (3D models)
- Game boards (chess, checkers, Go)
- Tile maps (2D games)
- Z-buffers (depth testing)

### 3. Scientific Computing
- Matrix operations (linear algebra)
- Finite element analysis
- Computational fluid dynamics
- Signal processing (FFT, filtering)
- Monte Carlo simulations

### 4. Operating Systems
- Process control blocks (arrays of structures)
- File system buffers
- Page tables (virtual memory)
- Device drivers (buffers, registers)
- Scheduling queues

### 5. Networking
- Packet buffers
- Routing tables
- ARP cache
- Connection tracking tables
- Quality of service queues

### 6. Compiler Design
- Symbol tables
- Constant pools
- Instruction arrays (bytecode)
- Parse trees (often implemented using arrays)
- Stack frames

### 7. Machine Learning
- Feature vectors
- Weight matrices
- Activation arrays
- Gradient storage
- Batch processing arrays

### 8. Embedded Systems
- Lookup tables (trigonometric functions, logarithms)
- Circular buffers (UART, SPI, I2C communication)
- State machines
- Calibration data
- Sensor readings buffers

## Interview Tips

### What Interviewers Look For
1. **Understanding of array properties**: Contiguous memory, indexing, time complexities
2. **Problem-solving ability**: Applying array manipulation techniques to solve problems
3. **Optimization skills**: Improving brute force solutions to optimal ones
4. **Edge case handling**: Empty arrays, single elements, duplicates, boundary conditions
5. **Space complexity awareness**: In-place modifications vs. extra space usage
6. **Knowledge of algorithms**: Two pointers, sliding window, prefix sum, etc.

### Common Interview Questions
1. Find missing number in array
2. Find duplicate number in array
3. Rotate array by k positions
4. Merge two sorted arrays
5. Find intersection of two arrays
6. Maximum subarray sum (Kadane's algorithm)
7. Trapping rain water
8. Product of array except self
9. Set matrix zeroes
10. Spiral matrix traversal

### Follow-up Questions to Expect
- How would you handle a very large array that doesn't fit in memory?
- What if the array is sorted? How does that change your approach?
- Can you solve this without using extra space?
- What if you need to maintain the relative order of elements?
- How would you parallelize this operation?
- What are the cache implications of your solution?

### Best Practices for Interview Answers
1. **Clarify requirements**: Ask about constraints, expected input size, operation distribution
2. **Start with brute force**: Mention naive solution before optimizing
3. **Discuss trade-offs**: Time/space complexity, when approach might not work
4. **Consider edge cases**: Empty input, single element, duplicates, invalid inputs
5. **Talk through your thinking**: Explain why you chose approach, what optimizations you considered
6. **Mention alternatives**: Discuss when other data structures might be better
7. **Write clean code**: Use meaningful variable names, add comments for complex logic
8. **Test your solution**: Walk through with example input to catch mistakes

## Quick Reference Formulas

### Address Calculation
- **1D Array**: `addr[i] = base_addr + i × elem_size`
- **2D Array (Row-Major)**: `addr[i][j] = base_addr + (i × cols + j) × elem_size`
- **2D Array (Column-Major)**: `addr[i][j] = base_addr + (j × rows + i) × elem_size`

### Common Algorithms
- **Kadane's Algorithm** (Max Subarray): 
  ```
  max_ending_here = max(0, max_ending_here + x)
  max_so_far = max(max_so_far, max_ending_here)
  ```
  
- **Prefix Sum**: 
  ```
  prefix[0] = 0
  prefix[i] = prefix[i-1] + arr[i-1]
  range_sum(i, j) = prefix[j+1] - prefix[i]
  ```

- **Sliding Window Maximum** (using deque):
  ```
  Maintain deque of useful elements in current window
  Front of deque = maximum of current window
  ```

### Time Complexity Reference
| Operation | Array (Static) | Array (Dynamic) | Linked List | Hash Table | BST |
|-----------|----------------|-----------------|-------------|------------|-----|
| Access by Index | O(1) | O(1) | O(n) | O(n) | O(n) |
| Search | O(n) | O(n) | O(n) | O(1) avg | O(log n) avg |
| Insert at End | N/A | O(1)* | O(1) | O(1) avg | O(log n) avg |
| Insert at Beginning | O(n) | O(n) | O(1) | O(1) avg | O(log n) avg |
| Insert at Middle | O(n) | O(n) | O(1)* | O(n) | O(log n) avg |
| Delete from End | N/A | O(1) | O(1)* | O(1) avg | O(log n) avg |
| Delete from Beginning | O(n) | O(n) | O(1) | O(1) avg | O(log n) avg |
| Delete from Middle | O(n) | O(n) | O(1)* | O(1) avg | O(log n) avg |
| Space | O(n) | O(n) | O(n) | O(n) | O(n) |

*Amortized cost; *With known position

## Remember
Arrays are deceptively simple but incredibly powerful data structures. Their strength lies in providing constant-time access to elements through direct memory addressing, making them ideal for scenarios where lookup performance is critical. While they have limitations in terms of flexibility (fixed size for traditional arrays) and insertion/deletion efficiency, these drawbacks are often outweighed by their performance benefits in many applications.

Understanding arrays deeply—including their memory layout, performance characteristics, and common manipulation patterns—is essential for any programmer. Many advanced data structures (hash tables, heaps, hash maps) and algorithms (sorting, searching, dynamic programming) are built upon or closely related to array concepts.

The key to mastering arrays is recognizing when their strengths align with your problem's requirements and applying the appropriate techniques (two pointers, sliding window, prefix sum, etc.) to leverage their efficiency effectively.