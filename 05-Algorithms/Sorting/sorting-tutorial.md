# Sorting Algorithms Tutorial

## Introduction to Sorting

Sorting

Sorting is the process of arranging elements of a collection in a specific order (typically ascending or descending). Sorting is a fundamental operation in computer science with widespread across domains:
- **and indexing
- **inr for r
- **quency of the most studied problems in computer science due to its importance as a building block for many other algorithms and its wide range of applications.

### Why Sorting Matters

- **Search Efficiency**: Sorted data enables binary search (O(log n) vs O(n))
- **Duplicate Detection**: Adjacent duplicates are easy to find in sorted arrays
- **Frequency Counting**: Count occurrences efficiently in sorted data
- **Range Queries**: Find all elements in a range quickly
- **Data Analysis**: Medians, percentiles, statistical calculations
- **Algorithm Preprocessing**: Many algorithms require sorted input (e.g., merge intervals, convex hull)
- **User Experience**: Presenting data in sorted order is often more usable

### Classification of Sorting Algorithms

Sorting algorithms can be classified along several dimensions:

1. **By Time Complexity**:
   - O(n²): Simple sorts (Bubble, Selection, Insertion)
   - O(n log n): Efficient sorts (Merge, Heap, Quick, Timsort)
   - O(n): Linear sorts (Counting, Radix, Bucket - with constraints)

2. **By Space Complexity**:
   - In-place: O(1) extra space (Heap sort, In-place Quick sort)
   - Not in-place: O(n) or more (Merge sort, typical Counting sort)

3. **By Stability**:
   - Stable: Maintains relative order of equal elements (Merge, Insertion, Bubble)
   - Unstable: May change relative order of equal elements (Heap, Quick, Selection)

4. **By Comparison vs Non-comparison**:
   - Comparison-based: Compare elements to determine order (most sorts)
   - Non-comparison-based: Use properties of data (Counting, Radix, Bucket)

5. **By Adaptive vs Non-adaptive**:
   - Adapts to existing order: Better performance on partially sorted data (Insertion, Bubble)
   - Non-adaptive: Same performance regardless of input order (Selection, Heap, Merge)

6. **By Recursive vs Iterative**:
   - Recursive: Uses function calls (Merge, Quick)
   - Iterative: Uses loops (Heap, Insertion, Selection, Bubble)

## Fundamental Sorting Algorithms

### 1. Bubble Sort
Repeatedly steps through the list, compares adjacent elements and swaps them if they are in the wrong order.

```cpp
void bubbleSort(vector<int>& arr) {
    int n = arr.size();
    for (int i = 0; i < n-1; i++) {
        // Last i elements are already in place
        for (int j = 0; j < n-i-1; j++) {
            if (arr[j] > arr[j+1]) {
                swap(arr[j], arr[j+1]);
            }
        }
    }
}
```

**Optimized Version** (stops early if no swaps):
```cpp
void bubbleSort(vector<int>& arr) {
    int n = arr.size();
    for (int i = 0; i < n-1; i++) {
        bool swapped = false;
    int j = 0; j < n-i-1; j++) {
            if (arr[j] > arr[j+1]) {
                swap(arr[j], arr[j+1]);
                swapped = true;
            }
        }
        if (!swapped) break; // Array is sorted
    }
}
```

**Characteristics**:
- Time: O(n²) worst/average, O(n) best (when already sorted)
- Space: O(1)
- Stable: Yes
- Adaptive: Yes (with optimization)
- Use when: Simplicity is paramount, small datasets, nearly sorted data

### 2. Selection Sort
Divides the input into sorted and unsorted regions. Repeatedly selects the smallest element from the unsorted region and moves it to the end of the sorted region.

```cpp
void selectionSort(vector<int>& arr) {
    int n = arr.size();
    for (int i = 0; i < n-1; i++) {
        int minIdx = i;
        // Find minimum element in unsorted array
        for (int j = i+1; j < n; j++) {
            if (arr[j] < arr[minIdx]) {
                minIdx = j;
            }
        }
        // Swap the found minimum element with the first element
        swap(arr[minIdx], arr[i]);
    }
}
```

**Characteristics**:
- Time: O(n²) for all cases
- Space: O(1)
- Stable: No (unless modified)
- Adaptive: No
- Use when: Memory writes are expensive (minimizes swaps to O(n))

### 3. Insertion Sort
Builds the final sorted array one item at a time. It is much less efficient on large lists than more advanced algorithms.

```cpp
void insertionSort(vector<int>& arr) {
    int n = arr.size();
    for (int i = 1; i < n; i++) {
        int key = arr[i];
        int j = i - 1;
        
        // Move elements of arr[0..i-1] that are greater than key
        // to one position ahead of their current position
        while (j >= 0 && arr[j] > key) {
            arr[j+1] = arr[j];
            j--;
        }
        arr[j+1] = key;
    }
}
```

**Characteristics**:
- Time: O(n²) worst/average, O(n) best (when already sorted)
- Space: O(1)
- Stable: Yes
- Adaptive: Yes
- Use when: Small datasets, nearly sorted data, as a subroutine in other algorithms (e.g., quicksort for small subarrays)

### 4. Merge Sort
Divide and conquer algorithm that divides the array into halves, sorts them recursively, and then merges the sorted halves.

```cpp
void merge(vector<int>& arr, int left, int mid, int right) {
    int n1 = mid - left + 1;
    int n2 = right - mid;
    
    vector<int> L(n1), R(n2);
    for (int i = 0; i < n1; i++)
        L[i] = arr[left + i];
    for (int j = 0; j < n2; j++)
        R[j] = arr[mid + 1 + j];
    
    // Merge the temp arrays back into arr[l..r]
    int i = 0, j = 0, k = left;
    while (i < n1 && j < n2) {
        if (L[i] <= R[j]) {
            arr[k] = L[i];
            i++;
        } else {
            arr[k] = R[j];
            j++;
        }
        k++;
    }
    
    // Copy remaining elements of L[]
    while (i < n1) {
        arr[k] = L[i];
        i++;
        k++;
    }
    
    // Copy remaining elements of R[]
    while (j < n2) {
        arr[k] = R[j];
        j++;
        k++;
    }
}

void mergeSort(vector<int>& arr, int left, int right) {
    if (left >= right) return;
    
    int mid = left + (right - left) / 2;
    mergeSort(arr, left, mid);
    mergeSort(arr, mid + 1, right);
    merge(arr, left, mid, right);
}

// Wrapper function
void mergeSort(vector<int>& arr) {
    mergeSort(arr, 0, arr.size() - 1);
}
```

**Characteristics**:
- Time: O(n log n) for all cases
- Space: O(n) auxiliary
- Stable: Yes
- Adaptive: No
- Use when: Stable sort needed, consistent O(n log n) performance required, linked lists

### 5. Quick Sort
Pick an element as pivot and partition the array around the pivot, placing smaller elements to the left and greater elements to the right.

```cpp
int partition(vector<int>& arr, int low, int high) {
    int pivot = arr[high]; // pivot
    int i = (low - 1); // Index of smaller element
    
    for (int j = low; j <= high - 1; j++) {
        // If current element is smaller than or equal to pivot
        if (arr[j] <= pivot) {
            i++; // increment index of smaller element
            swap(arr[i], arr[j]);
        }
    }
    swap(arr[i + 1], arr[high]);
    return (i + 1);
}

void quickSort(vector<int>& arr, int low, int high) {
    if (low < high) {
        // pi is partitioning index, arr[p] is now at right place
        int pi = partition(arr, low, high);
        
        // Separately sort elements before and after partition
        quickSort(arr, low, pi - 1);
        quickSort(arr, pi + 1, high);
    }
}

// Wrapper function
void quickSort(vector<int>& arr) {
    quickSort(arr, 0, arr.size() - 1);
}
```

**Optimizations**:
1. **Randomized Pivot**: Choose random pivot to avoid worst-case on sorted arrays
2. **Three-way Partition**: Handle duplicate keys efficiently
3. **Insertion Sort for Small Arrays**: Switch to insertion sort for small subarrays
4. **Tail Recursion Elimination**: Reduce stack space usage

```cpp
// Randomized version
int partitionRandom(vector<int>& arr, int low, int high) {
    srand(time(nullptr));
    int random = low + rand() % (high - low);
    swap(arr[random], arr[high]);
    return partition(arr, low, high);
}
```

**Characteristics**:
- Time: O(n log n) average, O(n²) worst (rare with good pivot selection)
- Space: O(log n) average (stack space), O(n) worst case
- Stable: No (standard implementation)
- Adaptive: No
- Use when: Average case performance is important, memory is limited (in-place)

### 6. Heap Sort
Comparison-based sorting technique based on Binary Heap data structure. It is similar to selection sort where we first find the maximum element and place it at the end.

```cpp
void heapify(vector<int>& arr, int n, int i) {
    int largest = i; // Initialize largest as root
    int left = 2 * i + 1;
    int right = 2 * i + 2;
    
    // If left child is larger than root
    if (left < n && arr[left] > arr[largest])
        largest = left;
    
    // If right child is larger than largest so far
    if (right < n && arr[right] > arr[largest])
        largest = right;
    
    // If largest is not root
    if (largest != i) {
        swap(arr[i], arr[largest]);
        // Recursively heapify the affected sub-tree
        heapify(arr, n, largest);
    }
}

void heapSort(vector<int>& arr) {
    int n = arr.size();
    
    // Build heap (rearrange array)
    for (int i = n / 2 - 1; i >= 0; i--)
        heapify(arr, n, i);
    
    // One by one extract an element from heap
    for (int i = n-1; i >= 0; i--) {
        // Move current root to end
        swap(arr[0], arr[i]);
        
        // Call max heapify on the reduced heap
        heapify(arr, i, 0);
    }
}
```

**Characteristics**:
- Time: O(n log n) for all cases
- Space: O(1)
- Stable: No
- Adaptive: No
- Use when: Guaranteed O(n log n) performance required, memory is constrained

## Non-Comparison Based Sorting Algorithms

These algorithms work under specific assumptions about the input data and can achieve linear time complexity.

### 1. Counting Sort
Works by counting the number of objects having distinct key values, then doing arithmetic to calculate the position of each object in the output sequence.

```cpp
void countingSort(vector<int>& arr) {
    if (arr.empty()) return;
    
    // Find the maximum element to know the range
    int maxVal = *max_element(arr.begin(), arr.end());
    int minVal = *min_element(arr.begin(), arr.end());
    int range = maxVal - minVal + 1;
    
    // Create and initialize count array
    vector<int> count(range, 0);
    vector<int> output(arr.size());
    
    // Store count of each element
    for (int i = 0; i < arr.size(); i++)
        count[arr[i] - minVal]++;
    
    // Change count[i] so that it contains actual position of this element in output array
    for (int i = 1; i < range; i++)
        count[i] += count[i-1];
    
    // Build the output array
    for (int i = arr.size() - 1; i >= 0; i--) {
        output[count[arr[i] - minVal] - 1] = arr[i];
        count[arr[i] - minVal]--;
    }
    
    // Copy the output array to arr, so that arr now contains sorted elements
    for (int i = 0; i < arr.size(); i++)
        arr[i] = output[i];
}
```

**Characteristics**:
- Time: O(n + k) where k is range of input
- Space: O(n + k)
- Stable: Yes
- Use when: Range of input data (k) is not significantly greater than number of objects (n)

### 2. Radix Sort
Sorts numbers digit by digit starting from least significant digit to most significant digit. Uses counting sort as a subroutine to sort digits.

```cpp
// A utility function to get maximum value in arr[]
int getMax(const vector<int>& arr) {
    return *max_element(arr.begin(), arr.end());
}

// A function to do counting sort of arr[] according to the digit represented by exp.
void countSortForRadix(vector<int>& arr, int exp) {
    int n = arr.size();
    vector<int> output(n); // output array
    int count[10] = {0};
    
    // Store count of occurrences in count[]
    for (int i = 0; i < n; i++)
        count[(arr[i] / exp) % 10]++;
    
    // Change count[i] so that count[i] now contains actual
    //  position of this digit in output[]
    for (int i = 1; i < 10; i++)
        count[i] += count[i-1];
    
    // Build the output array
    for (int i = n - 1; i >= 0; i--) {
        output[count[(arr[i] / exp) % 10] - 1] = arr[i];
        count[(arr[i] / exp) % 10]--;
    }
    
    // Copy the output array to arr[], so that arr[] now
    // contains sorted numbers according to current digit
    for (int i = 0; i < n; i++)
        arr[i] = output[i];
}

// The main function that sorts arr[] of size n using Radix Sort
void radixSort(vector<int>& arr) {
    // Find the maximum number to know number of digits
    int m = getMax(arr);
    
    // Do counting sort for every digit. Note that instead
    // of passing digit number, exp is passed. exp is 10^i where i is current digit number
    for (int exp = 1; m/exp > 0; exp *= 10)
        countSortForRadix(arr, exp);
}
```

**Characteristics**:
- Time: O(d*(n+b)) where d is number of digits, b is base
- Space: O(n + b)
- Stable: Yes (if stable sort used as subroutine)
- Use when: Sorting integers or strings with fixed-length keys

### 3. Bucket Sort
Distributes elements into a number of buckets. Each bucket is then sorted individually, either using a different sorting algorithm or by recursively applying the bucket sort.

```cpp
void bucketSort(vector<float>& arr) {
    int n = arr.size();
    if (n == 0) return;
    
    // 1) Create n empty buckets
    vector<vector<float>> buckets(n);
    
    // 2) Put array elements in different buckets
    for (int i = 0; i < n; i++) {
        int bucketIndex = n * arr[i]; // Assuming input is in [0,1)
        buckets[bucketIndex].push_back(arr[i]);
    }
    
    // 3) Sort individual buckets
    for (int i = 0; i < n; i++) {
        sort(buckets[i].begin(), buckets[i].end());
    }
    
    // 4) Concatenate all buckets into arr[]
    int index = 0;
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < buckets[i].size(); j++) {
            arr[index++] = buckets[i][j];
        }
    }
}
```

**Characteristics**:
- Time: O(n + k) average case where k is number of buckets
- Space: O(n + k)
- Stable: Depends on sorting algorithm used for buckets
- Use when: Input is uniformly distributed over a range

## Advanced and Hybrid Sorting Algorithms

### 1. Timsort
Hybrid sorting algorithm derived from merge sort and insertion sort, designed to perform well on many kinds of real-world data. It's the default sorting algorithm in Python and Java.

```cpp
// Simplified Timsort implementation
const int RUN = 32; // Size of small subarrays to be sorted with insertion sort

void insertionSort(vector<int>& arr, int left, int right) {
    for (int i = left + 1; i <= right; i++) {
        int temp = arr[i];
        int j = i - 1;
        while (j >= left && arr[j] > temp) {
            arr[j+1] = arr[j];
            j--;
        }
        arr[j+1] = temp;
    }
}

void merge(vector<int>& arr, int l, int m, int r) {
    int len1 = m - l + 1, len2 = r - m;
    vector<int> left(len1), right(len2);
    for (int i = 0; i < len1; i++)
        left[i] = arr[l + i];
    for (int i = 0; i < len2; i++)
        right[i] = arr[m + 1 + i];
    
    int i = 0, j = 0, k = l;
    while (i < len1 && j < len2) {
        if (left[i] <= right[j]) {
            arr[k] = left[i];
            i++;
        } else {
            arr[k] = right[j];
            j++;
        }
        k++;
    }
    while (i < len1) {
        arr[k] = left[i];
        i++;
        k++;
    }
    while (j < len2) {
        arr[k] = right[j];
        j++;
        k++;
    }
}

void timSort(vector<int>& arr) {
    int n = arr.size();
    
    // Sort individual subarrays of size RUN
    for (int i = 0; i < n; i += RUN)
        insertionSort(arr, i, min((i+31), (n-1)));
    
    // Start merging from size RUN (or 32). It will merge
    // to form size 64, then 128, 256 and so on ....
    for (int size = RUN; size < n; size = 2*size) {
        // pick starting point of left sub array. We
        // are going to merge arr[left..left+size-1] and
        // left+size, left+2*size-1 ........
        for (int left = 0; left < n; left += 2*size) {
            // find 
            // mid point is left + size - 1
            int mid = left + size - 1;
            int right = min((left + 2*size - 1), (n-1));
            
            // merge subarray arr[left.....mid] &
            // subarray arr[mid+1....right]
            if (mid < right)
                merge(arr, left, mid, right);
        }
    }
}
```

**Characteristics**:
- Time: O(n log n) worst case, O(n) best case (already sorted)
- Space: O(n)
- Stable: Yes
- Adaptive: Yes
- Use when: General purpose sorting with good performance on real-world data

### 2. Introsort (Introspective Sort)
Hybrid sorting algorithm that provides both fast average performance and optimal worst-case performance. It begins with quicksort and switches to heapsort when the recursion depth exceeds a level based on the number of elements being sorted.

```cpp
int partition(vector<int>& arr, int low, int high) {
    int pivot = arr[high];
    int i = low - 1;
    
    for (int j = low; j <= high - 1; j++) {
        if (arr[j] < pivot) {
            i++;
            swap(arr[i], arr[j]);
        }
    }
    swap(arr[i + 1], arr[high]);
    return (i + 1);
}

void heapify(vector<int>& arr, int n, int i) {
    int largest = i;
    int left = 2 * i + 1;
    int right = 2 * i + 2;
    
    if (left < n && arr[left] > arr[largest])
        largest = left;
    
    if (right < n && arr[right] > arr[largest])
        largest = right;
    
    if (largest != i) {
        swap(arr[i], arr[largest]);
        heapify(arr, n, largest);
    }
}

void heapSort(vector<int>& arr, int n, int low) {
    // Build heap
    for (int i = n / 2 - 1; i >= 0; i--)
        heapify(arr, n, i + low);
    
    // Extract elements from heap
    for (int i = n-1; i >= 0; i--) {
        swap(arr[low], arr[low + i]);
        heapify(arr, i, low);
    }
}

void introsortUtil(vector<int>& arr, int low, int high, int depthLimit) {
    // If partition size is small, do insertion sort
    if (high - low <= 16) {
        insertionSort(arr, low, high);
        return;
    }
    
    // If depth is zero, use heapsort
    if (depthLimit == 0) {
        heapSort(arr, high - low + 1, low);
        return;
    }
    
    // Otherwise, use quicksort
    int pivot = partition(arr, low, high);
    
    // Recursively sort elements before and after partition
    introsortUtil(arr, low, pivot - 1, depthLimit - 1);
    introsortUtil(arr, pivot + 1, high, depthLimit - 1);
}

void introsort(vector<int>& arr) {
    int depthLimit = 2 * log2(arr.size());
    introsortUtil(arr, 0, arr.size() - 1, depthLimit);
}
```

**Characteristics**:
- Time: O(n log n) worst case
- Space: O(log n) (quicksort stack) or O(1) if using iterative heap sort
- Stable: No
- Adaptive: No
- Use when: Need guaranteed O(n log n) performance with good average case

## Sorting Algorithm Comparison

| Algorithm | Best Case | Average Case | Worst Case | Space | Stable | Adaptive | In-place |
|-----------|-----------|--------------|------------|-------|--------|----------|----------|
| Bubble Sort | O(n) | O(n²) | O(n²) | O(1) | Yes | Yes | Yes |
| Selection Sort | O(n²) | O(n²) | O(n²) | O(1) | No | No | Yes |
| Insertion Sort | O(n) | O(n²) | O(n²) | O(1) | Yes | Yes | Yes |
| Merge Sort | O(n log n) | O(n log n) | O(n log n) | O(n) | Yes | No | No |
| Quick Sort | O(n log n) | O(n log n) | O(n²) | O(log n) | No | No | Yes |
| Heap Sort | O(n log n) | O(n log n) | O(n log n) | O(1) | No | No | Yes |
| Counting Sort | O(n+k) | O(n+k) | O(n+k) | O(n+k) | Yes | No | No |
| Radix Sort | O(d(n+b)) | O(d(n+b)) | O(d(n+b)) | O(n+b) | Yes | No | No |
| Bucket Sort | O(n+k) | O(n+k) | O(n²) | O(n+k) | Depends | No | No |
| Timsort | O(n) | O(n log n) | O(n log n) | O(n) | Yes | Yes | No |
| Introsort | O(n log n) | O(n log n) | O(n log n) | O(log n) | No | No | Yes |

*Where: n = number of elements, k = range of input, d = number of digits, b = base*

## Choosing the Right Sorting Algorithm

### Decision Factors

| Scenario | Recommended Algorithm |
|----------|----------------------|
| Small dataset (n < 50) | Insertion Sort (simple, adaptive) |
| Nearly sorted data | Insertion Sort or Bubble Sort (with early termination) |
| Stable sort required | Merge Sort, Timsort, or Insertion Sort |
| Memory severely constrained | Heap Sort or In-place Quick Sort |
| Guaranteed O(n log n) worst-case | Heap Sort or Merge Sort |
| Average case performance critical | Quick Sort (with good pivot selection) |
| Sorting integers with small range | Counting Sort |
| Sorting integers/fixed-width strings | Radix Sort |
| Uniformly distributed floats | Bucket Sort |
| General purpose sorting | Timsort or Introsort (used in standard libraries) |
| External sorting (data doesn't fit in memory) | External Merge Sort |

### When to Use Standard Library Sort

Most modern languages provide highly optimized sorting functions:
- C++: `std::sort` (typically Introsort), `std::stable_sort` (typically Merge Sort)
- Java: `Arrays.sort()` (Dual-Pivot Quicksort for primitives, Timsort for objects)
- Python: `sorted()` and `list.sort()` (Timsort)
- Go: `sort.Sort()` (introspecSort - hybrid of quicksort, heapsort, and insertion sort)

Use these unless you have specific requirements that the standard library doesn't meet.

## Sorting Stability

**Stable Sort**: Maintains the relative order of records with equal keys (i.e., values).

Example: Sorting students by grade then by name:
- Input: [(85, "Alice"), (90, "Bob"), (85, "Charlie"), (90, "David")]
- Stable sort by grade: [(85, "Alice"), (85, "Charlie"), (90, "Bob"), (90, "David")]
- Unstable sort might produce: [(85, "Charlie"), (85, "Alice"), (90, "David"), (90, "Bob")]

**Stable Algorithms**: Bubble Sort, Insertion Sort, Merge Sort, Timsort, Counting Sort, Radix Sort (when using stable subroutine)

**Unstable Algorithms**: Selection Sort, Quick Sort, Heap Sort, Shell Sort

## Common Sorting Problems and Variations

### 1. Sorting Custom Objects
```cpp
struct Student {
    string name;
    int age;
    double gpa;
};

// Sort by GPA (descending), then by age (ascending), then by name (lexicographic)
bool compareStudents(const Student& a, const Student& b) {
    if (a.gpa != b.gpa)
        return a.gpa > b.gpa; // Descending GPA
    if (a.age != b.age)
        return a.age < b.age; // Ascending age
    return a.name < b.name; // Lexicographic name
}

// Usage:
// sort(students.begin(), students.end(), compareStudents);
```

### 2. Sorting with Custom Comparators (Lambdas)
```cpp
// Sort strings by length, then lexicographically
sort(strings.begin(), strings.end(), 
     [](const string& a, const string& b) {
         if (a.length() != b.length())
             return a.length() < b.length();
         return a < b;
     });
```

### 3. Sorting Only Part of an Array
```cpp
// Sort elements from index 2 to index 7 (inclusive)
sort(arr.begin() + 2, arr.begin() + 8);

// Sort in descending order
sort(arr.begin(), arr.end(), greater<int>());
```

### 4. Finding Kth Smallest/Largest Element
```cpp
// Using partial sort (more efficient than full sort when k << n)
int kthSmallest(vector<int>& arr, int k) {
    nth_element(arr.begin(), arr.begin() + k - 1, arr.end());
    return arr[k-1];
}

// Or using a heap for better performance when k is small
int kthSmallestHeap(vector<int>& arr, int k) {
    priority_queue<int> maxHeap; // Max heap
    
    for (int num : arr) {
        if (maxHeap.size() < k) {
            maxHeap.push(num);
        } else if (num < maxHeap.top()) {
            maxHeap.pop();
            maxHeap.push(num);
        }
    }
    return maxHeap.top();
}
```

### 5. Counting Inversions
```cpp
// Count inversions using modified merge sort
long long mergeAndCount(vector<int>& arr, int left, int mid, int right) {
    int n1 = mid - left + 1;
    int n2 = right - mid;
    
    vector<int> Left(n1), Right(n2);
    for (int i = 0; i < n1; i++)
        Left[i] = arr[left + i];
    for (int j = 0; j < n2; j++)
        Right[j] = arr[mid + 1 + j];
    
    int i = 0, j = 0, k = left;
    long long invCount = 0;
    
    while (i < n1 && j < n2) {
        if (Left[i] <= Right[j]) {
            arr[k] = Left[i];
            i++;
        } else {
            arr[k] = Right[j];
            j++;
            // All remaining elements in Left[i..n1-1] are greater than Right[j]
            invCount += (n1 - i);
        }
        k++;
    }
    
    while (i < n1) {
        arr[k] = Left[i];
        i++;
        k++;
    }
    
    while (j < n2) {
        arr[k] = Right[j];
        j++;
        k++;
    }
    
    return invCount;
}

long long mergeSortAndCount(vector<int>& arr, int left, int right) {
    long long invCount = 0;
    if (left < right) {
        int mid = (left + right) / 2;
        
        invCount += mergeSortAndCount(arr, left, mid);
        invCount += mergeSortAndCount(arr, mid + 1, right);
        
        invCount += mergeAndCount(arr, left, mid, right);
    }
    return invCount;
}

long long countInversions(vector<int>& arr) {
    return mergeSortAndCount(arr, 0, arr.size() - 1);
}
```

## Sorting in Different Data Structures

### 1. Sorting a Linked List (Merge Sort)
```cpp
struct ListNode {
    int val;
    ListNode* next;
    ListNode(int x) : val(x), next(nullptr) { 
}
```

```// Find middle of linked list using slow and fast pointers
ListNode* findMiddle(ListNode* head) {
    if (!head || !head->next) return head;
    
    ListNode* slow = head;
    ListNode* fast = head->next;
    
    while (fast && fast->next) {
        slow = slow->next;
        fast = fast->next->next;
    }
    
    return slow;
}

// Merge two sorted linked lists
ListNode* mergeLists(ListNode* l1, ListNode* l2) {
    if (!l1) return l2;
    if (!l2) return l1;
    
    if (l1->val < l2->val) {
        l1->next = mergeLists(l1->next, l2);
        return l1;
    } else {
        l2->next = mergeLists(l1, l2->next);
        return l2;
    }
}

// Merge sort for linked list
ListNode* mergeSortList(ListNode* head) {
    if (!head || !head->next) return head;
    
    // Split the list into two halves
    ListNode* middle = findMiddle(head);
    ListNode* nextToMiddle = middle->next;
    middle->next = nullptr;
    
    // Recursively sort both halves
    ListNode* left = mergeSortList(head);
    ListNode* right = mergeSortList(nextToMiddle);
    
    // Merge the sorted halves
    return mergeLists(left, right);
}
```

### 2. Sorting a Stack (Using Recursion)
```cpp
// Insert element in sorted way into sorted stack
void sortedInsert(stack<int>& s, int element) {
    // Base case: either stack is empty or newly inserted
    // element is greater than top (more than all existing)
    if (s.empty() || element > s.top()) {
        s.push(element);
        return;
    }
    
    // If top is greater, remove the top item and recur
    int temp = s.top();
    s.pop();
    sortedInsert(s, element);
    
    // Put back the top item we removed
    s.push(temp);
}

// Main function to sort the stack
void sortStack(stack<int>& s) {
    // Base case: if stack is empty or has one element
    if (s.empty() || s.size() == 1) 
        return;
    
    // Remove the top item
    int temp = s.top();
    s.pop();
    
    // Sort remaining stack
    sortStack(s);
    
    // Push the top item back in sorted stack
    sortedInsert(s, temp);
}
```

## Performance Analysis and Optimization Techniques

### 1. Cache Optimization
- **Access Pattern**: Sequential access is cache-friendly
- **Blocking**: Process data in chunks that fit in cache
- **Example**: Cache-aware merge sort that uses blocked merging

### 2. Branch Prediction Optimization
- **Predictable Branches**: Sorting algorithms often have predictable branches
- **Loop Unrolling**: Reduce branch penalty by doing more work per iteration
- **Example**: Comparing multiple elements per iteration in inner loops

### 3. Instruction Level Parallelism (ILP)
- **Independent Operations**: Modern CPUs can execute multiple instructions per cycle
- **Example**: Comparing and swapping non-adjacent elements that don't depend on each other

### 4. Memory Allocation Strategies
- **Pre-allocation**: Allocate temporary arrays once instead of repeatedly
- **Memory Pools**: Reuse memory instead of frequent malloc/free
- **Stack Allocation**: For small fixed-size arrays, use stack instead of heap

### 5. Adaptive Optimizations
- **Early Detection**: Check if array is already sorted before starting
- **Short-circuiting**: For nearly sorted data, use adaptive algorithms
- **Hybrid Approaches**: Switch algorithms based on subarray size or other criteria

### 6. Parallel Sorting
- **Sample Sort**: Partition data using samples, sort partitions in parallel
- **Parallel Merge Sort**: Divide array, sort parts in parallel, merge results
- **Radix Sort**: Naturally parallelizable by digit position
- **Bitonic Sort**: Designed for parallel architectures (GPUs, supercomputers)

## Common Mistakes and How to Avoid Them

### 1. Off-by-One Errors in Loops
```cpp
// Wrong
for (int i = 0; i <= n; i++) {  // Goes one element too far
    // ...
}

// Correct
for (int i = 0; i < n; i++) {  // Stops at n-1
    // ...
}
```

### 2. Incorrect Boundary Conditions in Merge/Partition
```cpp
// Wrong - might miss elements or access out of bounds
while (i <= mid && j <= right) {  // Should be i < n1 and j < n2
    // ...
}

// Correct
while (i < n1 && j < n2) {
    // ...
}
```

### 3. Forgetting to Handle Empty or Single-element Cases
```cpp
// Wrong - crashes on empty array
void quickSort(vector<int>& arr, int low, int high) {
    int pi = partition(arr, low, high);  // Crash if low > high
    // ...
}

// Correct
void quickSort(vector<int>& arr, int low, int high) {
    if (low < high) {  // Handles empty and single-element cases
        int pi = partition(arr, low, high);
        quickSort(arr, low, pi - 1);
        quickSort(arr, pi + 1, high);
    }
}
```

### 4. Incorrect Stability Implementation
```cpp
// Wrong - changes order of equal elements
if (arr[j] < pivot) {  // Should be <= for stability when moving smaller elements
    i++;
    swap(arr[i], arr[j]);
}

// Correct for stability (when moving elements <= pivot)
if (arr[j] <= pivot) {
    i++;
    swap(arr[i], arr[j]);
}
```

### 5. Integer Overflow in Index Calculations
```cpp
// Wrong - can overflow for large arrays
int mid = (left + right) / 2;

// Correct
int mid = left + (right - left) / 2;
```

### 6. Not Handling Duplicate Keys Properly
```cpp
// Wrong - may cause infinite loop or incorrect partitioning
while (arr[left] < pivot) left++;
while (arr[right] > pivot) right--;

// Better - handles duplicates correctly
while (arr[left] <= pivot) left++;
while (arr[right] >= pivot) right--;
```

### 7. Improper Random Number Generation
```cpp
// Wrong - reseeding every call causes poor randomness
int getRandomPivot(int low, int high) {
    srand(time(NULL));  // Don't do this!
    return low + rand() % (high - low + 1);
}

// Correct - seed once, reuse generator
static default_random_engine generator;
uniform_int_distribution<int> distribution(low, high);
return distribution(generator);
```

## Practical Applications of Sorting

### 1. Database Systems
- **Index Creation**: B-Tree indexes require sorted data
- **Merge Join**: Efficient join algorithm for sorted tables
- **Duplicate Elimination**: Remove duplicates during query processing
- **Order By Clause**: Satisfy ORDER BY requirements in SQL queries

### 2. External Sorting (Big Data)
- **External Merge Sort**: Sort data that doesn't fit in memory
- **MapReduce Sorting**: Sort large datasets across clusters
- **Terabyte Sort Benchmark**: Annual competition for fastest sorting of 1TB dataset

### 3. Computer Graphics
- **Z-Buffer Sorting**: Sort polygons by depth for correct rendering
- **Scanline Algorithms**: Sort edges by y-coordinate for polygon filling
- **Ray Tracing**: Sort objects by distance for early termination

### 4. Operating Systems
- **Process Scheduling**: Sort processes by priority or arrival time
- **File System Directories**: Maintain sorted directory listings for fast lookup
- **Memory Management**: Sort free memory blocks by size for allocation algorithms

### 5. Scientific Computing
- **Data Analysis**: Sort experimental data for statistical analysis
- **Computational Geometry**: Sort points by angle or coordinate for algorithms
- **Bioinformatics**: Sort DNA sequences for alignment algorithms
- **Network Analysis**: Sort nodes by degree for graph algorithms

### 6. Machine Learning
- **Nearest Neighbors**: Sort distances to find k-nearest neighbors
- **Decision Trees**: Sort feature values to find optimal split points
- **Ranking Algorithms**: Sort items by relevance score
- **Feature Selection**: Sort features by importance score

### 7. Game Development
- **Leaderboards**: Sort player scores for display
- **Collision Detection**: Sort objects by spatial coordinates for sweep-and-prune
- **Rendering**: Sort transparent objects by depth for correct blending
- **Resource Management**: Sort resources by priority for allocation

### 8. Web Applications
- **Search Results**: Sort by relevance, date, or popularity
- **E-commerce**: Sort products by price, rating, or popularity
- **Social Media**: Sort posts by time or engagement metrics
- **Financial Data**: Sort stock prices or trading volumes

## Summary

Sorting algorithms form a fundamental building block in computer science. Understanding their trade-offs and characteristics enables developers to choose the right tool for specific problems.

### Key Takeaways:
1. **Know Your Data**: Distribution, size, and characteristics dictate algorithm choice
2. **Understand Trade-offs**: Time vs. space, stability, adaptiveness, worst-case vs. average-case
3. **Consider the Environment**: Memory hierarchy, parallelism available, external constraints
4. **Leverage Standard Libraries**: Highly optimized implementations exist for most use cases
5. **Profile When Necessary**: Theoretical complexity doesn't always match real-world performance
6. **Think Hybrid**: Many real-world scenarios benefit from combining approaches
7. **Stay Current**: New variants and optimizations continue to emerge

### Quick Reference Guide:
- **Need simplicity & small data?** → Insertion Sort
- **Need guaranteed O(n log n)?** → Merge Sort or Heap Sort
- **Need average-case speed & in-place?** → Quick Sort (with good pivot)
- **Need stability & good real-world performance?** → Timsort
- **Sorting integers with small range?** → Counting Sort
- **Sorting integers/fixed-width strings?** → Radix Sort
- **Need external sorting (data > RAM)?** → External Merge Sort
- **Want general purpose, battle-tested solution?** → Standard Library Sort

By mastering these concepts and understanding when to apply each technique, you'll be able to efficiently solve sorting problems in virtually any context.