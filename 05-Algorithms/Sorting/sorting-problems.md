# Sorting Problems

## Problem List

This file contains a collection of sorting problems categorized by difficulty level, along with their solutions.

## Easy Problems

### 1. Bubble Sort
**Problem**: Implement bubble sort to sort an array of integers in ascending order.

**Solution**:
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

**Optimized Version** (early termination):
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
        // If no swapping occurred, array is sorted
        if (!swapped) break;
    }
}
```

### 2. Selection Sort
**Problem**: Implement selection sort to sort an array of integers in ascending order.

**Solution**:
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

### 3. Insertion Sort
**Problem**: Implement insertion sort to sort an array of integers in ascending order.

**Solution**:
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

### 4. Merge Sort
**Problem**: Implement merge sort to sort an array of integers in ascending order.

**Solution**:
```cpp
void merge(vector<int>& arr, int left, int mid, int right) {
    int n1 = mid - left + 1;
    int n2 = right - mid;
    
    vector<int> L(n1), R(n2);
    for (int i = 0; i < n1; i++)
        L[i] = arr[left + i];
    for (int j = 0; j < n2; j++)
        R[j] = arr[mid + 1 + j];
    
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
    
    while (i < n1) {
        arr[k] = L[i];
        i++;
        k++;
    }
    
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

### 5. Quick Sort
**Problem**: Implement quick sort to sort an array of integers in ascending order.

**Solution**:
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

### 6. Heap Sort
**Problem**: Implement heap sort to sort an array of integers in ascending order.

**Solution**:
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

### 7. Counting Sort
**Problem**: Implement counting sort to sort an array of integers with a known range.

**Solution**:
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

### 8. Radix Sort
**Problem**: Implement radix sort to sort an array of non-negative integers.

**Solution**:
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

### 9. Sort an Array of 0s, 1s, and 2s
**Problem**: Given an array A[] consisting of only 0s, 1s, and 2s. Sort the array in ascending order.

**Solution** (Dutch National Flag algorithm):
```cpp
void sort012(vector<int>& arr) {
    int low = 0, mid = 0, high = arr.size() - 1;
    
    while (mid <= high) {
        switch (arr[mid]) {
            case 0:
                swap(arr[low++], arr[mid++]);
                break;
            case 1:
                mid++;
                break;
            case 2:
                swap(arr[mid], arr[high--]);
                break;
        }
    }
}
```

### 10. Check if Array is Sorted
**Problem**: Given an array, check if it is sorted in ascending order.

**Solution**:
```cpp
bool isSorted(const vector<int>& arr) {
    for (int i = 1; i < arr.size(); i++) {
        if (arr[i] < arr[i-1])
            return false;
    }
    return true;
}
```

## Medium Problems

### 11. Sort Colors (LeetCode 75)
**Problem**: Given an array nums with n objects colored red, white, or blue, sort them in-place so that objects of the same color are adjacent, with the colors in the order red, white, and blue.

**Solution** (Same as Dutch National Flag):
```cpp
void sortColors(vector<int>& nums) {
    int low = 0, mid = 0, high = nums.size() - 1;
    
    while (mid <= high) {
        if (nums[mid] == 0) {
            swap(nums[low++], nums[mid++]);
        } else if (nums[mid] == 1) {
            mid++;
        } else { // nums[mid] == 2
            swap(nums[mid], nums[high--]);
        }
    }
}
```

### 12. Merge Two Sorted Arrays
**Problem**: Given two sorted integer arrays nums1 and nums2, merge nums2 into nums1 as one sorted array.

**Note**: The number of elements initialized in nums1 and nums2 are m and n respectively. You may assume that nums1 has enough space (size that is equal to m + n) to hold additional elements from nums2.

**Solution**:
```cpp
void merge(vector<int>& nums1, int m, vector<int>& nums2, int n) {
    // Start from the end of both arrays
    int i = m - 1; // End of nums1's elements
    int j = n - 1; // End of nums2
    int k = m + n - 1; // End of nums1's total space
    
    // Merge in reverse order
    while (i >= 0 && j >= 0) {
        if (nums1[i] > nums2[j]) {
            nums1[k--] = nums1[i--];
        } else {
            nums1[k--] = nums2[j--];
        }
    }
    
    // Copy remaining elements of nums2 if any
    while (j >= 0) {
        nums1[k--] = nums2[j--];
    }
}
```

### 13. Sort Array by Parity
**Problem**: Given an array A of non-negative integers, return an array consisting of all the even elements of A, followed by all the odd elements of A.

**Solution**:
```cpp
vector<int> sortArrayByParity(vector<int>& A) {
    int left = 0, right = A.size() - 1;
    
    while (left < right) {
        // Move left pointer until odd number found
        while (left < right && A[left] % 2 == 0) {
            left++;
        }
        // Move right pointer until even number found
        while (left < right && A[right] % 2 == 1) {
            right--;
        }
        // Swap if pointers haven't crossed
        if (left < right) {
            swap(A[left], A[right]);
            left++;
            right--;
        }
    }
    
    return A;
}
```

### 14. Sort Array by Increasing Frequency
**Problem**: Given an array of integers nums, sort the array in increasing order based on the frequency of the values. If multiple values have the same frequency, sort them in decreasing order.

**Solution**:
```cpp
vector<int> frequencySort(vector<int>& nums) {
    // Count frequencies
    unordered_map<int, int> freq;
    for (int num : nums) {
        freq[num]++;
    }
    
    // Sort by frequency (ascending), then by value (descending)
    sort(nums.begin(), nums.end(), [&](int a, int b) {
        if (freq[a] != freq[b]) {
            return freq[a] < freq[b]; // Lower frequency first
        }
        return a > b; // For same frequency, higher value first
    });
    
    return nums;
}
```

### 15. Sort Integers by The Number of 1 Bits
**Problem**: Given an array of integers arr. You are sorted by the number of 1's in their binary representation and in case of tie, sort by their decimal value

**Solution**:
```cpp
vector<int> sortByBits(vector<int>& arr) {
    // Count bits and sort
    sort(arr.begin(), arr.end(), [](int a, int b) {
        int countA = __builtin_popcount(a);
        int countB = __builtin_popcount(b);
        if (countA != countB) {
            return countA < countB; // Fewer 1 bits first
        }
        return a < b; // If same number of 1 bits, sort by value
    });
    
    return arr;
}
```

### 16. Kth Largest Element in an Array
**Problem**: Find the kth largest element in an unsorted array. Note that it is the kth largest element in the sorted order, not the kth distinct element.

**Solution** (using min-heap):
```cpp
int findKthLargest(vector<int>& nums, int k) {
    // Min heap to store k largest elements
    priority_queue<int, vector<int>, greater<int>> minHeap;
    
    for (int num : nums) {
        if (minHeap.size() < k) {
            minHeap.push(num);
        } else if (num > minHeap.top()) {
            minHeap.pop();
            minHeap.push(num);
        }
    }
    
    return minHeap.top();
}
```

**Alternative Solution** (using quickselect):
```cpp
int partition(vector<int>& nums, int left, int right) {
    int pivot = nums[right];
    int i = left;
    
    for (int j = left; j < right; j++) {
        if (nums[j] <= pivot) {
            swap(nums[i], nums[j]);
            i++;
        }
    }
    swap(nums[i], nums[right]);
    return i;
}

int quickSelect(vector<int>& nums, int left, int right, int k) {
    // If the partition contains exactly k elements
    if (left == right) 
        return nums[left];
    
    // Partition the array and get the position of pivot
    int pivotIndex = partition(nums, left, right);
    
    // The pivot is in its final sorted position
    if (k == pivotIndex + 1) 
        return nums[pivotIndex];
    // If k is less than the pivot position, search left
    else if (k < pivotIndex + 1)
        return quickSelect(nums, left, pivotIndex - 1, k);
    // If k is more than the pivot position, search right
    else
        return quickSelect(nums, pivotIndex + 1, right, k);
}

int findKthLargest(vector<int>& nums, int k) {
    // kth largest is (n-k)th smallest in 0-indexed array
    int n = nums.size();
    return quickSelect(nums, 0, n-1, n - k + 1);
}
```

### 17. Sort a Nearly Sorted (K Sorted) Array
**Problem**: Given an array of n elements, where each element is at most k away from its target position, devise an algorithm that sorts in O(n log k) time.

**Solution** (using min-heap):
```cpp
vector<int> sortKSortedArray(vector<int>& arr, int k) {
    int n = arr.size();
    vector<int> result;
    
    // Create a min heap of size k+1
    priority_queue<int, vector<int>, greater<int>> minHeap;
    
    // Insert first k+1 elements into the heap
    for (int i = 0; i <= min(k, n-1); i++) {
        minHeap.push(arr[i]);
    }
    
    // For remaining elements, extract min from heap and add next element
    int index = 0;
    for (int i = k+1; i < n; i++) {
        result[index++] = minHeap.top();
        minHeap.pop();
        minHeap.push(arr[i]);
    }
    
    // Extract remaining elements from heap
    while (!minHeap.empty()) {
        result[index++] = minHeap.top();
        minHeap.pop();
    }
    
    return result;
}
```

### 18. Count Inversions
**Problem**: Count the number of inversions in an array. Two elements arr[i] and arr[j] form an inversion if arr[i] > arr[j] and i < j.

**Solution** (using merge sort):
```cpp
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

### 19. Find the Minimum Number of Swaps Required to Sort the Array
**Problem**: Given an array of n distinct elements, find the minimum number of swaps required to sort the array.

**Solution**:
```cpp
int minSwaps(vector<int>& arr) {
    int n = arr.size();
    // Create an array of pairs where first element is array element
    // and second element is its original index
    vector<pair<int, int>> arrPos(n);
    for (int i = 0; i < n; i++)
        arrPos[i] = {arr[i], i};
    
    // Sort the array by array element values to get 
    // right position of every element as second element of pair
    sort(arrPos.begin(), arrPos.end());
    
    // To keep track of visited elements. Initialize 
    // all elements as not visited or false.
    vector<bool> vis(n, false);
    
    // Initialize result
    int ans = 0;
    
    // Traverse array elements
    for (int i = 0; i < n; i++) {
        // already swapped or already present at correct position
        if (vis[i] || arrPos[i].second == i)
            continue;
        
        // find number of nodes in this cycle and add to ans
        int cycle_size = 0;
        int j = i;
        while (!vis[j]) {
            vis[j] = true;
            // move to next node
            j = arrPos[j].second;
            cycle_size++;
        }
        
        // Update answer by adding current cycle
        if (cycle_size > 0) {
            ans += (cycle_size - 1);
        }
    }
    
    // Return result
    return ans;
}
```

### 20. Sort a Stack Using Recursion
**Problem**: Given a stack, sort it using recursion such that the smallest items are on the top.

**Solution**:
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

## Hard Problems

### 21. Merge k Sorted Lists
**Problem**: Merge k sorted linked lists and return it as one sorted list. Analyze and describe its complexity.

**Solution** (using min-heap):
```cpp
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode() : val(0), next(nullptr) {}
 *     ListNode(int x) : val(x), next(nullptr) {}
 *     ListNode(int x, ListNode *next) : val(x), next(next) {}
 * };
 */

struct compare {
    bool operator()(ListNode* a, ListNode* b) {
        return a->val > b->val;
    }
};

ListNode* mergeKLists(vector<ListNode*>& lists) {
    // Create a min heap
    priority_queue<ListNode*, vector<ListNode*>, compare> minHeap;
    
    // Push the first node of each list into the heap
    for (auto node : lists) {
        if (node != nullptr) {
            minHeap.push(node);
        }
    }
    
    // Create a dummy head for the result list
    ListNode* dummy = new ListNode(0);
    ListNode* tail = dummy;
    
    // Extract the minimum element from heap and add next element from that list
    while (!minHeap.empty()) {
        ListNode* minNode = minHeap.top();
        minHeap.pop();
        
        tail->next = minNode;
        tail = tail->next;
        
        if (minNode->next != nullptr) {
            minHeap.push(minNode->next);
        }
    }
    
    return dummy->next;
}
```

**Alternative Solution** (divide and conquer):
```cpp
ListNode* mergeTwoLists(ListNode* l1, ListNode* l2) {
    if (!l1) return l2;
    if (!l2) return l1;
    
    if (l1->val < l2->val) {
        l1->next = mergeTwoLists(l1->next, l2);
        return l1;
    } else {
        l2->next = mergeTwoLists(l1, l2->next);
        return l2;
    }
}

ListNode* mergeKLists(vector<ListNode*>& lists) {
    if (lists.empty()) return nullptr;
    
    int interval = 1;
    int n = lists.size();
    
    while (interval < n) {
        for (int i = 0; i < n - interval; i += interval * 2) {
            lists[i] = mergeTwoLists(lists[i], lists[i + interval]);
        }
        interval *= 2;
    }
    
    return lists[0];
}
```

### 22. Sort a Matrix in All Increasing Order
**Problem**: Given a square matrix of size N x N, sort the matrix in such a way that the first row is sorted in increasing order, the second row is sorted in increasing order and so on, and also the first column is sorted in increasing order, the second column is sorted in increasing order and so on.

**Solution** (flatten, sort, reshape):
```cpp
vector<vector<int>> sortMatrix(vector<vector<int>>& matrix) {
    int n = matrix.size();
    
    // Flatten the matrix into a 1D array
    vector<int> flat;
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            flat.push_back(matrix[i][j]);
        }
    }
    
    // Sort the flattened array
    sort(flat.begin(), flat.end());
    
    // Reshape back into matrix
    vector<vector<int>> result(n, vector<int>(n));
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            result[i][j] = flat[i * n + j];
        }
    }
    
    return result;
}
```

### 23. Find the Minimum Difference Between Any Two Elements
**Problem**: Given an array of integers, find the minimum absolute difference between any two elements in the array.

**Solution**:
```cpp
int minimumAbsoluteDifference(vector<int>& arr) {
    // Sort the array first
    sort(arr.begin(), arr.end());
    
    // Find minimum difference between consecutive elements
    int minDiff = INT_MAX;
    for (int i = 1; i < arr.size(); i++) {
        minDiff = min(minDiff, abs(arr[i] - arr[i-1]));
    }
    
    return minDiff;
}
```

### 24. Maximum Gap (LeetCode 164)
**Problem**: Given an integer array nums, return the maximum difference between two successive elements in its sorted form. If the array contains less than two elements, return 0.

**Solution** (using bucket sort/pigeonhole principle):
```cpp
int maximumGap(vector<int>& nums) {
    int n = nums.size();
    if (n < 2) return 0;
    
    // Find min and max elements
    int minVal = *min_element(nums.begin(), nums.end());
    int maxVal = *max_element(nums.begin(), nums.end());
    
    // Edge case: all elements are same
    if (minVal == maxVal) return 0;
    
    // Calculate minimum possible gap
    double gap = double(maxVal - minVal) / (n - 1);
    int bucketSize = max(1, (int)ceil(gap));
    
    // Calculate number of buckets
    int bucketCount = (maxVal - minVal) / bucketSize + 1;
    
    // Create buckets to store min and max of each bucket
    vector<int> minBucket(bucketCount, INT_MAX);
    vector<int> maxBucket(bucketCount, INT_MIN);
    vector<bool> used(bucketCount, false);
    
    // Place elements in buckets
    for (int num : nums) {
        int bucketIdx = (num - minVal) / bucketSize;
        used[bucketIdx] = true;
        minBucket[bucketIdx] = min(minBucket[bucketIdx], num);
        maxBucket[bucketIdx] = max(maxBucket[bucketIdx], num);
    }
    
    // Calculate maximum gap by comparing adjacent buckets
    int maxGap = 0;
    int prevMax = minVal; // Start with min value
    
    for (int i = 0; i < bucketCount; i++) {
        if (!used[i]) continue; // Skip empty bucket
        
        maxGap = max(maxGap, minBucket[i] - prevMax);
        prevMax = maxBucket[i];
    }
    
    return maxGap;
}
```

### 25. Sort Characters By Frequency
**Problem**: Given a string, sort it in decreasing order based on the frequency of characters.

**Solution**:
```cpp
string frequencySort(string s) {
    // Count frequency of each character
    unordered_map<char, int> freq;
    for (char c : s) {
        freq[c]++;
    }
    
    // Create vector of pairs for sorting
    vector<pair<char, int>> freqVec;
    for (auto& p : freq) {
        freqVec.push_back(p);
    }
    
    // Sort by frequency (descending), then by character (ascending) for tie-breaking
    sort(freqVec.begin(), freqVec.end(), [](const pair<char, int>& a, const pair<char, int>& b) {
        if (a.second != b.second) {
            return a.second > b.second; // Higher frequency first
        }
        return a.first < b.first; // For same frequency, lexicographically smaller first
    });
    
    // Build result string
    string result;
    for (auto& p : freqVec) {
        result.append(p.second, p.first);
    }
    
    return result;
}
```

### 26. Sort Array According to Count of Set Bits
**Problem**: Sort an array according to the count of set bits in binary representation of array elements. If two numbers have the same number of set bits, sort them according to their decimal value.

**Solution**:
```cpp
vector<int> sortBySetBitCount(vector<int>& arr) {
    stable_sort(arr.begin(), arr.end(), [](int a, int b) {
        int countA = __builtin_popcount(a);
        int countB = __builtin_popcount(b);
        return countA > countB; // Descending order of set bits
    });
    
    return arr;
}
```

**Note**: Using stable_sort to maintain relative order for elements with same set bit count
**Alternative without stable_sort** (explicit secondary sort):
```cpp
vector<int> sortBySetBitCount(vector<int>& arr) {
    sort(arr.begin(), arr.end(), [](int a, int b) {
        int countA = __builtin_popcount(a);
        int countB = __builtin_popcount(b);
        if (countA != countB) {
            return countA > countB; // Descending order of set bits
        }
        return a < b; // For same set bit count, ascending order of value
    });
    
    return arr;
}
```

### 27. Minimum Number of Platforms Required for a Railway/Bus Station
**Problem**: Given arrival and departure times of all trains that reach a railway station, find the minimum number of platforms required for the railway station so that no train waits.

**Solution**:
```cpp
int findPlatform(vector<int>& arr, vector<int>& dep) {
    // Sort arrival and departure arrays
    sort(arr.begin(), arr.end());
    sort(dep.begin(), dep.end());
    
    // plat_needed indicates number of platforms needed at a time
    int plat_needed = 1, result = 1;
    int i = 1, j = 0;
    
    // Similar to merge in merge sort to process 
    // all events in sorted order
    while (i < arr.size() && j < dep.size()) {
        // If next event in sorted order is arrival, 
        // increment count of platforms needed
        if (arr[i] <= dep[j]) {
            plat_needed++;
            i++;
            
            // Update result if needed
            if (plat_needed > result)
                result = plat_needed;
        } 
        // Else decrement count of platforms needed
        else {
            plat_needed--;
            j++;
        }
    }
    
    return result;
}
```

### 28. Sort a Linked List of 0s, 1s and 2s
**Problem**: Given a linked list of 0s, 1s and 2s, sort it.

**Solution**:
```cpp
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode() : val(0), next(nullptr) {}
 *     ListNode(int x) : val(x), next(nullptr) {}
 *     ListNode(int x, ListNode *next) : val(x), next(next) {}
 * };
 */

ListNode* sortList(ListNode* head) {
    if (!head) return nullptr;
    
    // Count occurrences of 0, 1, and 2
    int count[3] = {0};
    ListNode* temp = head;
    while (temp) {
        count[temp->val]++;
        temp = temp->next;
    }
    
    // Overwrite the list with sorted values
    temp = head;
    int i = 0;
    while (temp) {
        if (count[i] == 0) {
            i++;
        }
        temp->val = i;
        count[i]--;
        temp = temp->next;
    }
    
    return head;
}
```

### 29. Largest Number Formed from an Array
**Problem**: Given a list of non-negative integers, arrange them such that they form the largest number.

**Solution**:
```cpp
string largestNumber(vector<int>& nums) {
    // Convert all integers to strings
    vector<string> strNums;
    for (int num : nums) {
        strNums.push_back(to_string(num));
    }
    
    // Custom comparator: which combination is larger?
    sort(strNums.begin(), strNums.end(), [](const string& a, const string& b) {
        return a + b > b + a; // If a+b is larger, a should come before b
    });
    
    // Edge case: if the largest number is 0, return "0"
    if (strNums[0] == "0") {
        return "0";
    }
    
    // Concatenate all strings
    string result;
    for (const string& str : strNums) {
        result += str;
    }
    
    return result;
}
```

### 30. Sort an Array in Wave Form
**Problem**: Given an unsorted array of integers, sort the array into a wave like array. An array 'arr[0..n-1]' is sorted in wave form if: arr[0] >= arr[1] <= arr[2] >= arr[3] <= arr[4] >= ...

**Solution**:
```cpp
void sortInWave(vector<int>& arr) {
    // Sort the array first
    sort(arr.begin(), arr.end());
    
    // Swap adjacent elements
    for (int i = 0; i < arr.size()-1; i += 2) {
        swap(arr[i], arr[i+1]);
    }
}
```

**Alternative single-pass solution**:
```cpp
void sortInWave(vector<int>& arr) {
    // Traverse all even positioned elements
    for (int i = 0; i < arr.size(); i += 2) {
        // If current even element is smaller than previous
        if (i > 0 && arr[i-1] > arr[i])
            swap(arr[i], arr[i-1]);
        
        // If current even element is smaller than next
        if (i < arr.size()-1 && arr[i] < arr[i+1])
            swap(arr[i], arr[i+1]);
    }
}
```

## Summary

This collection covers sorting problems from easy to hard difficulty levels. Key insights:

1. **Master the Basics**: Understanding fundamental sorting algorithms (bubble, selection, insertion, merge, quick, heap) is essential
2. **Know When to Use Which**: Different algorithms excel in different scenarios based on data characteristics
3. **Handle Edge Cases**: Empty arrays, single elements, duplicates, already sorted data
4. **Consider Space vs Time**: In-place algorithms vs those requiring extra space
5. **Stability Matters**: Some applications require maintaining relative order of equal elements
6. **Think Beyond Numbers**: Sorting applies to strings, objects, complex data structures
7. **Hybrid Approaches**: Many real-world solutions combine multiple techniques
8. **Leverage Standard Libraries**: Built-in sort functions are highly optimized for most use cases

Practice these problems to develop strong sorting skills, which are fundamental to efficient data processing and problem-solving in computer science.