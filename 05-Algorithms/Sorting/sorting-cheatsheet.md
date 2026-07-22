# Sorting Algorithms Cheat Sheet

## Fundamental Concepts

### Definition
Sorting is the process of arranging elements of a collection in a specific order (typically ascending or descending).

### Key Properties
- **In-place**: Uses only O(1) extra memory
- **Stable**: Maintains relative order of equal elements
- **Adaptive**: Performs better on partially sorted data
- **Online**: Can sort a stream as it receives data
- **Comparison-based**: Determines order by comparing elements
- **Non-comparison-based**: Uses properties of data (radix, counting sort)

## Essential Sorting Algorithms

### 1. Bubble Sort
```cpp
void bubbleSort(vector<int>& arr) {
    int n = arr.size();
    for (int i = 0; i < n-1; i++) {
        bool swapped = false;
        for (int j = 0; j < n-i-1; j++) {
            if (arr[j] > arr[j+1]) {
                swap(arr[j], arr[j+1]);
                swapped = true;
            }
        }
        if (!swapped) break;
    }
}
```
- Time: O(n²) worst/avg, O(n) best
- Space: O(1)
- Stable: Yes
- Adaptive: Yes
- Use when: Simplicity, small data, nearly sorted

### 2. Selection Sort
```cpp
void selectionSort(vector<int>& arr) {
    int n = arr.size();
    for (int i = 0; i < n-1; i++) {
        int minIdx = i;
        for (int j = i+1; j < n; j++) {
            if (arr[j] < arr[minIdx]) minIdx = j;
        }
        swap(arr[minIdx], arr[i]);
    }
}
```
- Time: O(n²) all cases
- Space: O(1)
- Stable: No
- Adaptive: No
- Use when: Minimizing writes (O(n) swaps)

### 3. Insertion Sort
```cpp
void insertionSort(vector<int>& arr) {
    int n = arr.size();
    for (int i = 1; i < n; i++) {
        int key = arr[i];
        int j = i - 1;
        while (j >= 0 && arr[j] > key) {
            arr[j+1] = arr[j];
            j--;
        }
        arr[j+1] = key;
    }
}
```
- Time: O(n²) worst/avg, O(n) best
- Space: O(1)
- Stable: Yes
- Adaptive: Yes
- Use when: Small data, nearly sorted, as subroutine in other sorts

### 4. Merge Sort
```cpp
void merge(vector<int>& arr, int l, int m, int r) {
    int n1 = m - l + 1, n2 = r - m;
    vector<int> L(n1), R(n2);
    for (int i = 0; i < n1; i++) L[i] = arr[l + i];
    for (int j = 0; i < n2; j++) R[j] = arr[m + 1 + j];
    
    int i = 0, j = 0, k = l;
    while (i < n1 && j < n2) {
        if (L[i] <= R[j]) arr[k++] = L[i++];
        else arr[k++] = R[j++];
    }
    while (i < n1) arr[k++] = L[i++];
    while (j < n2) arr[k++] = R[j++];
}

void mergeSort(vector<int>& arr, int l, int r) {
    if (l >= r) return;
    int m = l + (r - l) / 2;
    mergeSort(arr, l, m);
    mergeSort(arr, m + 1, r);
    merge(arr, l, m, r);
}
```
- Time: O(n log n) all cases
- Space: O(n)
- Stable: Yes
- Adaptive: No
- Use when: Stable sort needed, consistent performance, linked lists

### 5. Quick Sort
```cpp
int partition(vector<int>& arr, int low, int high) {
    int pivot = arr[high];
    int i = low - 1;
    for (int j = low; j < high; j++) {
        if (arr[j] <= pivot) {
            i++;
            swap(arr[i], arr[j]);
        }
    }
    swap(arr[i + 1], arr[high]);
    return i + 1;
}

void quickSort(vector<int>& arr, int low, int high) {
    if (low < high) {
        int pi = partition(arr, low, high);
        quickSort(arr, low, pi - 1);
        quickSort(arr, pi + 1, high);
    }
}
```
- Time: O(n log n) avg, O(n²) worst
- Space: O(log n) avg (stack), O(n) worst
- Stable: No
- Adaptive: No
- Use when: Average-case performance, memory constrained

### 6. Heap Sort
```cpp
void heapify(vector<int>& arr, int n, int i) {
    int largest = i;
    int left = 2*i + 1, right = 2*i + 2;
    if (left < n && arr[left] > arr[largest]) largest = left;
    if (right < n && arr[right] > arr[largest]) largest = right;
    if (largest != i) {
        swap(arr[i], arr[largest]);
        heapify(arr, n, largest);
    }
}

void heapSort(vector<int>& arr) {
    int n = arr.size();
    for (int i = n/2 - 1; i >= 0; i--) heapify(arr, n, i);
    for (int i = n-1; i >= 0; i--) {
        swap(arr[0], arr[i]);
        heapify(arr, i, 0);
    }
}
```
- Time: O(n log n) all cases
- Space: O(1)
- Stable: No
- Adaptive: No
- Use when: Guaranteed O(n log n), memory constrained

## Non-Comparison Based Sorts

### 1. Counting Sort
```cpp
void countingSort(vector<int>& arr) {
    if (arr.empty()) return;
    int maxVal = *max_element(arr.begin(), arr.end());
    int minVal = *min_element(arr.begin(), arr.end());
    int range = maxVal - minVal + 1;
    
    vector<int> count(range, 0), output(arr.size());
    
    for (int num : arr) count[num - minVal]++;
    for (int i = 1; i < range; i++) count[i] += count[i-1];
    for (int i = arr.size()-1; i >= 0; i--) {
        output[count[arr[i] - minVal] - 1] = arr[i];
        count[arr[i] - minVal]--;
    }
    for (int i = 0; i < arr.size(); i++) arr[i] = output[i];
}
```
- Time: O(n + k) where k = range
- Space: O(n + k)
- Stable: Yes
- Use when: Range of input (k) is O(n)

### 2. Radix Sort
```cpp
int getMax(const vector<int>& arr) {
    return *max_element(arr.begin(), arr.end());
}

void countSort(vector<int>& arr, int exp) {
    int n = arr.size();
    vector<int> output(n);
    int count[10] = {0};
    
    for (int i = 0; i < n; i++) count[(arr[i]/exp)%10]++;
    for (int i = 1; i < 10; i++) count[i] += count[i-1];
    for (int i = n-1; i >= 0; i--) {
        output[count[(arr[i]/exp)%10] - 1] = arr[i];
        count[(arr[i]/exp)%10]--;
    }
    for (int i = 0; i < n; i++) arr[i] = output[i];
}

void radixSort(vector<int>& arr) {
    int m = getMax(arr);
    for (int exp = 1; m/exp > 0; exp *= 10)
        countSort(arr, exp);
}
```
- Time: O(d*(n+b)) where d=digits, b=base
- Space: O(n+b)
- Stable: Yes
- Use when: Sorting integers or fixed-length strings

## Comparison-Based Sort Summary

| Algorithm | Best | Average | Worst | Space | Stable | Adaptive |
|-----------|------|---------|-------|-------|--------|----------|
| Bubble | O(n) | O(n²) | O(n²) | O(1) | Yes | Yes |
| Selection | O(n²) | O(n²) | O(n²) | O(1) | No | No |
| Insertion | O(n) | O(n²) | O(n²) | O(1) | Yes | Yes |
| Merge | O(n log n) | O(n log n) | O(n log n) | O(n) | Yes | No |
| Quick | O(n log n) | O(n log n) | O(n²) | O(log n) | No | No |
| Heap | O(n log n) | O(n log n) | O(n log n) | O(1) | No | No |

## Non-Comparison Sort Summary

| Algorithm | Time | Space | Stable | Notes |
|-----------|------|-------|--------|-------|
| Counting | O(n+k) | O(n+k) | Yes | k = range of input |
| Radix | O(d(n+b)) | O(n+b) | Yes | d = digits, b = base |
| Bucket | O(n+k) avg | O(n+k) | Depends | k = buckets, uniform dist. |

## Choosing the Right Algorithm

### Decision Matrix

| Constraint | Best Choice |
|------------|-------------|
| Small n (< 50) | Insertion Sort |
| Nearly sorted data | Insertion Sort (adaptive) |
| Stable sort required | Merge Sort, Timsort |
| Memory severely constrained | Heap Sort |
| Guaranteed O(n log n) worst-case | Heap Sort, Merge Sort |
| Average-case performance critical | Quick Sort |
| Integer sorting, small range | Counting Sort |
| Integer/fixed-width string sorting | Radix Sort |
| Uniformly distributed floats | Bucket Sort |
| General purpose | Timsort/Introsort (standard library) |

### Quick Reference
- **Need simplicity?** → Insertion Sort
- **Need guaranteed performance?** → Merge Sort or Heap Sort
- **Need average-case speed & in-place?** → Quick Sort
- **Need stability & real-world performance?** → Timsort
- **Sorting integers with limited range?** → Counting Sort
- **Sorting integers/fixed-width strings?** → Radix Sort
- **External sorting (data > RAM)?** → External Merge Sort
- **Want standard, battle-tested solution?** → Standard Library Sort

## Implementation Tips

### 1. Boundary Checking
```cpp
if (arr.empty()) return;
if (arr.size() == 1) return;
```

### 2. Avoiding Overflow
```cpp
// Dangerous: (left + right) / 2
int mid = left + (right - left) / 2;
```

### 3. Working with Comparators
```cpp
// Descending order
sort(arr.begin(), arr.end(), greater<int>());

// Custom comparator
sort(arr.begin(), arr.end(), [](const A& a, const A& b) {
    return a.key < b.key;
});
```

### 4. Sorting Only Part
```cpp
// Sort elements [2, 7)
sort(arr.begin() + 2, arr.begin() + 8);

// Sort in descending order
sort(arr.begin(), arr.end(), greater<int>());
```

### 5. Custom Object Sorting
```cpp
struct Person {
    string name;
    int age;
};

// Sort by age, then name
sort(people.begin(), people.end(), [](const Person& a, const Person& b) {
    if (a.age != b.age) return a.age < b.age;
    return a.name < b.name;
});
```

## Time and Space Complexity Cheat Sheet

### Comparison Sorts
| Algorithm | Best | Average | Worst | Space |
|-----------|------|---------|-------|-------|
| Bubble | O(n) | O(n²) | O(n²) | O(1) |
| Selection | O(n²) | O(n²) | O(n²) | O(1) |
| Insertion | O(n) | O(n²) | O(n²) | O(1) |
| Merge | O(n log n) | O(n log n) | O(n log n) | O(n) |
| Quick | O(n log n) | O(n log n) | O(n²) | O(log n) |
| Heap | O(n log n) | O(n log n) | O(n log n) | O(1) |

### Non-Comparison Sorts
| Algorithm | Time | Space | Condition |
|-----------|------|-------|-----------|
| Counting | O(n+k) | O(n+k) | k = range |
| Radix | O(d(n+b)) | O(n+b) | d = digits |
| Bucket | O(n+k) avg | O(n+k) | uniform dist. |

## Stability Reference

### Stable Algorithms
- Bubble Sort
- Insertion Sort
- Merge Sort
- Timsort
- Counting Sort
- Radix Sort (with stable subroutine)

### Unstable Algorithms
- Selection Sort
- Quick Sort
- Heap Sort
- Shell Sort

## Common Variations

### 1. Three-Way Quick Sort (for duplicates)
```cpp
void threeWayPartition(vector<int>& arr, int low, int high, 
                      int& lt, int& gt) {
    int pivot = arr[high];
    int i = low;
    lt = low;
    gt = high;
    
    while (i <= gt) {
        if (arr[i] < pivot) {
            swap(arr[i++], arr[lt++]);
        } else if (arr[i] > pivot) {
            swap(arr[i], arr[gt--]);
        } else {
            i++;
        }
    }
}
```

### 2. Insertion Sort Optimization (binary search)
```cpp
void binaryInsertionSort(vector<int>& arr) {
    for (int i = 1; i < arr.size(); i++) {
        int key = arr[i];
        // Find location to insert using binary search
        int left = 0, right = i - 1;
        while (left <= right) {
            int mid = left + (right - left) / 2;
            if (arr[mid] > key) 
                right = mid - 1;
            else
                left = mid + 1;
        }
        
        // Shift elements to make space
        for (int j = i - 1; j >= left; j--) {
            arr[j+1] = arr[j];
        }
        arr[left] = key;
    }
}
```

### 3. Adaptive Merge Sort (natural merge)
```cpp
// Takes advantage of existing runs in data
void naturalMergeSort(vector<int>& arr) {
    // Implementation identifies and merges naturally occurring sorted subsequences
}
```

## Memory Optimization Techniques

### 1. In-Place Merge Sort Variants
```cpp
// Complex but reduces space to O(1)
// Generally slower than standard merge sort
```

### 2. Stack Allocation for Small Arrays
```cpp
// For small fixed-size arrays, use stack instead of heap
void sortSmallArray(int arr[10]) {
    // Use stack allocation, no dynamic memory needed
}
```

### 3. Memory Pooling
```cpp
// Pre-allocate memory for temporary arrays
// Reuse instead of repeated allocation/deallocation
```

## Performance Optimization

### 1. Cache Efficiency
- Access memory sequentially when possible
- Block algorithms to improve locality
- Consider memory layout (AoS vs SoA)

### 2. Branch Prediction
- Sort predictable data first
- Use conditional moves when possible
- Profile to find mispredicted branches

### 3. Instruction Level Parallelism
- Independent operations can execute in parallel
- Loop unrolling for small fixed-size operations
- SIMD where applicable

### 4. Adaptive Techniques
- Check if already sorted before sorting
- Switch algorithms based on subarray size
- Use insertion sort for small subarrays

## Specialized Sorting Problems

### 1. Sorting Linked Lists
- Use merge sort (O(n log n) time, O(log n) space for recursion)
- Avoid random access algorithms

### 2. Sorting Stacks
- Use recursion with helper function
- Time: O(n²), Space: O(n) for call stack

### 3. External Sorting
- Data doesn't fit in memory
- Use external merge sort
- Minimize disk I/O

### 4. Parallel Sorting
- Sample sort, parallel merge sort, bitonic sort
- Consider GPU acceleration for radix sort

## Summary

Mastering sorting algorithms requires understanding both theoretical foundations and practical considerations. Key principles:

1. **Match algorithm to data characteristics**: Size, distribution, ordering requirements
2. **Consider implementation constraints**: Memory, stability, performance needs
3. **Profile when necessary**: Theoretical complexity ≠ real-world performance
4. **Leverage existing solutions**: Standard libraries are highly optimized
5. **Think beyond basic algorithms**: Hybrids, adaptations, specializations exist
6. **Understand trade-offs**: No single algorithm is best for all scenarios

Whether you're building a database index, processing scientific data, or creating a user interface, choosing the right sorting algorithm can significantly impact your application's performance and correctness.