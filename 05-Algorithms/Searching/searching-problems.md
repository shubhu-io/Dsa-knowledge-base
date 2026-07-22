# Searching Problems

## Problem List

This file contains a collection of searching problems categorized by difficulty level, along with their solutions.

## Easy Problems

### 1. Linear Search
**Problem**: Given an array arr[] of size n and an integer x, write a function to search x in arr[]. Return the index of x if present, otherwise return -1.

**Solution**:
```cpp
int linearSearch(int arr[], int n, int x) {
    for (int i = 0; i < n; i++) {
        if (arr[i] == x)
            return i;
    }
    return -1;
}
```

### 2. Binary Search (Iterative)
**Problem**: Given a sorted array arr[] of size n and an integer x, write a function to search x in arr[]. Return the index of x if present, otherwise return -1.

**Solution**:
```cpp
int binarySearch(int arr[], int n, int x) {
    int left = 0, right = n - 1;
    while (left <= right) {
        int mid = left + (right - left) / 2;
        
        // Check if x is present at mid
        if (arr[mid] == x)
            return mid;
        
        // If x greater, ignore left half
        if (arr[mid] < x)
            left = mid + 1;
        
        // If x is smaller, ignore right half
        else
            right = mid - 1;
    }
    
    // If we reach here, then element was not present
    return -1;
}
```

### 3. Binary Search (Recursive)
**Problem**: Implement binary search using recursion.

**Solution**:
```cpp
int binarySearchRecursive(int arr[], int left, int right, int x) {
    if (right >= left) {
        int mid = left + (right - left) / 2;
        
        // If the element is present at the middle itself
        if (arr[mid] == x)
            return mid;
        
        // If element is smaller than mid, then it can only be present in left subarray
        if (arr[mid] > x)
            return binarySearchRecursive(arr, left, mid - 1, x);
        
        // Else the element can only be present in right subarray
        return binarySearchRecursive(arr, mid + 1, right, x);
    }
    
    // We reach here when element is not present in array
    return -1;
}

// Wrapper function
int binarySearch(int arr[], int n, int x) {
    return binarySearchRecursive(arr, 0, n - 1, x);
}
```

### 4. Search in a 2D Matrix
**Problem**: Write an efficient algorithm that searches for a value in an m x n matrix. This matrix has the following properties:
- Integers in each row are sorted from left to right.
- The first integer of each row is greater than the last integer of the previous row.

**Solution**:
```cpp
bool searchMatrix(vector<vector<int>>& matrix, int target) {
    if (matrix.empty() || matrix[0].empty()) return false;
    
    int rows = matrix.size();
    int cols = matrix[0].size();
    int left = 0, right = rows * cols - 1;
    
    while (left <= right) {
        int mid = left + (right - left) / 2;
        int midElement = matrix[mid / cols][mid % cols];
        
        if (midElement == target)
            return true;
        else if (midElement < target)
            left = mid + 1;
        else
            right = mid - 1;
    }
    
    return false;
}
```

### 5. Find Minimum in Rotated Sorted Array
**Problem**: Suppose an array sorted in ascending order is rotated at some pivot unknown to you beforehand. Find the minimum element.

**Solution**:
```cpp
int findMin(vector<int>& nums) {
    int left = 0, right = nums.size() - 1;
    
    while (left < right) {
        int mid = left + (right - left) / 2;
        
        // If mid element is greater than rightmost element,
        // then the minimum is in the right part
        if (nums[mid] > nums[right])
            left = mid + 1;
        else
            // Otherwise, the minimum is in the left part including mid
            right = mid;
    }
    
    return nums[left];
}
```

### 6. Search in Rotated Sorted Array
**Problem**: Suppose an array sorted in ascending order is rotated at some pivot unknown to you beforehand. Search for a target value.

**Solution**:
```cpp
int search(vector<int>& nums, int target) {
    int left = 0, right = nums.size() - 1;
    
    while (left <= right) {
        int mid = left + (right - left) / 2;
        
        if (nums[mid] == target)
            return mid;
        
        // Check if left half is sorted
        if (nums[left] <= nums[mid]) {
            // Left half is sorted
            if (target >= nums[left] && target < nums[mid])
                right = mid - 1;
            else
                left = mid + 1;
        } else {
            // Right half is sorted
            if (target > nums[mid] && target <= nums[right])
                left = mid + 1;
            else
                right = mid - 1;
        }
    }
    
    return -1;
}
```

### 7. Peak Element
**Problem**: A peak element is an element that is greater than its neighbors. Given an input array nums, where nums[i] ≠ nums[i+1], find a peak element and return its index.

**Solution**:
```cpp
int findPeakElement(vector<int>& nums) {
    int left = 0, right = nums.size() - 1;
    
    while (left < right) {
        int mid = left + (right - left) / 2;
        
        if (nums[mid] > nums[mid + 1])
            right = mid;
        else
            left = mid + 1;
    }
    
    return left;
}
```

### 8. First Bad Version
**Problem**: You are a product manager and currently leading a team to develop a new product. Unfortunately, the latest version of your product fails the quality check. Since each version is developed based on the previous version, all the versions after a bad version are also bad.

Suppose you have n versions [1, 2, ..., n] and you want to find out the first bad one, which causes all the following ones to be bad.

You are given an API bool isBadVersion(version) which returns whether version is bad. Implement a function to find the first bad version.

**Solution**:
```cpp
// Forward declaration of isBadVersion API.
bool isBadVersion(int version);

int firstBadVersion(int n) {
    int left = 1, right = n;
    
    while (left < right) {
        int mid = left + (right - left) / 2;
        
        if (isBadVersion(mid))
            right = mid;
        else
            left = mid + 1;
    }
    
    return left;
}
```

### 9. Search Insert Position
**Problem**: Given a sorted array and a target value, return the index if the target is found. If not, return the index where it would be if it were inserted in order.

**Solution**:
```cpp
int searchInsert(vector<int>& nums, int target) {
    int left = 0, right = nums.size();
    
    while (left < right) {
        int mid = left + (right - left) / 2;
        
        if (nums[mid] >= target)
            right = mid;
        else
            left = mid + 1;
    }
    
    return left;
}
```

### 10. Valid Perfect Square
**Problem**: Given a positive integer num, write a function which returns True if num is a perfect square else False.

**Solution**:
```cpp
bool isPerfectSquare(int num) {
    long left = 1, right = num;
    
    while (left <= right) {
        long mid = left + (right - left) / 2;
        long square = mid * mid;
        
        if (square == num)
            return true;
        else if (square < num)
            left = mid + 1;
        else
            right = mid - 1;
    }
    
    return false;
}
```

## Medium Problems

### 11. Find First and Last Position of Element in Sorted Array
**Problem**: Given an array of integers nums sorted in non-decreasing order, find the starting and ending position of a given target value.

**Solution**:
```cpp
vector<int> searchRange(vector<int>& nums, int target) {
    int left = 0, right = nums.size() - 1;
    int first = -1, last = -1;
    
    // Find first occurrence
    while (left <= right) {
        int mid = left + (right - left) / 2;
        
        if (nums[mid] >= target)
            right = mid - 1;
        else
            left = mid + 1;
        
        if (nums[mid] == target)
            first = mid;
    }
    
    // If target not found, return [-1, -1]
    if (first == -1)
        return {-1, -1};
    
    // Reset for finding last occurrence
    left = 0;
    right = nums.size() - 1;
    
    // Find last occurrence
    while (left <= right) {
        int mid = left + (right - left) / 2;
        
        if (nums[mid] <= target)
            left = mid + 1;
        else
            right = mid - 1;
        
        if (nums[mid] == target)
            last = mid;
    }
    
    return {first, last};
}
```

### 12. Pow(x, n)
**Problem**: Implement pow(x, n), which calculates x raised to the power n (i.e., x^n).

**Solution**:
```cpp
double myPow(double x, int n) {
    // Handle edge cases
    if (n == 0) return 1.0;
    if (n == INT_MIN) return 1.0 / (myPow(x, INT_MAX) * x); // Avoid overflow
    
    // Handle negative exponent
    if (n < 0) {
        x = 1 / x;
        n = -n;
    }
    
    double result = 1.0;
    while (n > 0) {
        // If n is odd, multiply x with result
        if (n % 2 == 1)
            result *= x;
        
        // Square x and halve n
        x *= x;
        n /= 2;
    }
    
    return result;
}
```

### 13. Search Suggestions System
**Problem**: Given an array of strings products and a string searchWord. We want to design a system that suggests at most three product names from products after each character of searchWord is typed.

**Solution**:
```cpp
vector<vector<string>> suggestedProducts(vector<string>& products, string searchWord) {
    sort(products.begin(), products.end());
    vector<vector<string>> result;
    
    string prefix = "";
    for (char c : searchWord) {
        prefix += c;
        vector<string> suggestions;
        
        // Find the first product that matches the prefix
        auto it = lower_bound(products.begin(), products.end(), prefix);
        
        // Check up to 3 products that match the prefix
        int count = 0;
        for (auto iter = it; iter != products.end() && count < 3; ++iter) {
            if (iter->find(prefix) == 0) {
                suggestions.push_back(*iter);
                count++;
            } else {
                break;
            }
        }
        
        result.push_back(suggestions);
    }
    
    return result;
}
```

### 14. Capacity To Ship Packages Within D Days
**Problem**: A conveyor belt has packages that must be shipped from one port to another within D days.

The i-th package on the conveyor belt has a weight of weights[i]. Each day, we load the ship with packages on the conveyor belt (in the order given by weights). We may not load more weight than the maximum weight capacity of the ship.

Return the least weight capacity of the ship that will result in all the packages on the conveyor belt being shipped within D days.

**Solution**:
```cpp
int shipWithinDays(vector<int>& weights, int D) {
    int left = *max_element(weights.begin(), weights.end()); // Minimum capacity
    int right = accumulate(weights.begin(), weights.end(), 0); // Maximum capacity
    
    while (left < right) {
        int mid = left + (right - left) / 2;
        int daysNeeded = 1;
        int currentWeight = 0;
        
        for (int weight : weights) {
            if (currentWeight + weight > mid) {
                daysNeeded++;
                currentWeight = weight;
            } else {
                currentWeight += weight;
            }
        }
        
        if (daysNeeded <= D)
            right = mid;
        else
            left = mid + 1;
    }
    
    return left;
}
```

### 15. Koko Eating Bananas
**Problem**: Koko loves to eat bananas. There are n piles of bananas, the i-th pile has piles[i] bananas. The guards have gone and will come back in H hours.

Koko can decide her bananas-per-hour eating speed of k. Each hour, she chooses some pile of bananas and eats k bananas from that pile. If the pile has less than k bananas, she eats all of them instead, and will not eat any more bananas during this hour.

Koko likes to eat slowly but still wants to finish eating all the bananas before the guards return.

Return the minimum integer k such that she can eat all the bananas within H hours.

**Solution**:
```cpp
int minEatingSpeed(vector<int>& piles, int h) {
    int left = 1;
    int right = *max_element(piles.begin(), piles.end());
    
    while (left < right) {
        int mid = left + (right - left) / 2;
        long hoursNeeded = 0;
        
        for (int pile : piles) {
            hoursNeeded += (pile + mid - 1) / mid; // Ceiling division
        }
        
        if (hoursNeeded <= h)
            right = mid;
        else
            left = mid + 1;
    }
    
    return left;
}
```

### 16. Find Smallest Letter Greater Than Target
**Problem**: Given a list of sorted characters letters containing only lowercase letters, and given a target letter target, find the smallest element in the list that is larger than the given target.

**Solution**:
```cpp
char nextGreatestLetter(vector<char>& letters, char target) {
    int left = 0, right = letters.size();
    
    while (left < right) {
        int mid = left + (right - left) / 2;
        
        if (letters[mid] <= target)
            left = mid + 1;
        else
            right = mid;
    }
    
    // Wrap around if necessary
    return letters[left % letters.size()];
}
```

### 17. Search in a Binary Search Tree
**Problem**: Given the root node of a binary search tree (BST) and a value. You need to find the node in the BST that the node's value equals the given value. Return the subtree rooted with that node. If such node doesn't exist, you should return NULL.

**Solution**:
```cpp
TreeNode* searchBST(TreeNode* root, int val) {
    if (!root || root->val == val)
        return root;
    
    if (val < root->val)
        return searchBST(root->left, val);
    else
        return searchBST(root->right, val);
}
```

### 18. Insert into a Binary Search Tree
**Problem**: Given the root node of a binary search tree (BST) and a value to be inserted into the tree, insert the value into the BST. Return the root node of the BST after the insertion.

**Solution**:
```cpp
TreeNode* insertIntoBST(TreeNode* root, int val) {
    if (!root)
        return new TreeNode(val);
    
    if (val < root->val)
        root->left = insertIntoBST(root->left, val);
    else
        root->right = insertIntoBST(root->right, val);
    
    return root;
}
```

### 19. Search in a Binary Search Tree (Iterative)
**Problem**: Implement iterative search in a BST.

**Solution**:
```cpp
TreeNode* searchBST(TreeNode* root, int val) {
    while (root && root->val != val) {
        if (val < root->val)
            root = root->left;
        else
            root = root->right;
    }
    return root;
}
```

### 20. Find Minimum in Subarray
**Problem**: Given an array of integers nums and an integer k, return the minimum sum of any contiguous subarray of size k.

**Solution**:
```cpp
int minSubArrayLen(int target, vector<int>& nums) {
    int left = 0;
    int sum = 0;
    int minLen = INT_MAX;
    
    for (int right = 0; right < nums.size(); right++) {
        sum += nums[right];
        
        while (sum >= target) {
            minLen = min(minLen, right - left + 1);
            sum -= nums[left];
            left++;
        }
    }
    
    return minLen == INT_MAX ? 0 : minLen;
}
```

## Hard Problems

### 21. Median of Two Sorted Arrays
**Problem**: Given two sorted arrays nums1 and nums2 of size m and n respectively, return the median of the two sorted arrays.

**Solution**:
```cpp
double findMedianSortedArrays(vector<int>& nums1, vector<int>& nums2) {
    // Ensure nums1 is the smaller array
    if (nums1.size() > nums2.size())
        return findMedianSortedArrays(nums2, nums1);
    
    int m = nums1.size();
    int n = nums2.size();
    int left = 0, right = m;
    
    while (left <= right) {
        int partition1 = left + (right - left) / 2;
        int partition2 = (m + n + 1) / 2 - partition1;
        
        int maxLeft1 = (partition1 == 0) ? INT_MIN : nums1[partition1 - 1];
        int minRight1 = (partition1 == m) ? INT_MAX : nums1[partition1];
        
        int maxLeft2 = (partition2 == 0) ? INT_MIN : nums2[partition2 - 1];
        int minRight2 = (partition2 == n) ? INT_MAX : nums2[partition2];
        
        if (maxLeft1 <= minRight2 && maxLeft2 <= minRight1) {
            if ((m + n) % 2 == 0) {
                return (max(maxLeft1, maxLeft2) + min(minRight1, minRight2)) / 2.0;
            } else {
                return max(maxLeft1, maxLeft2);
            }
        } else if (maxLeft1 > minRight2) {
            right = partition1 - 1;
        } else {
            left = partition1 + 1;
        }
    }
    
    throw invalid_argument("Input arrays are not sorted");
}
```

### 22. Search in a Sorted Array of Unknown Size
**Problem**: Given an integer array sorted in ascending order and a target value. Assume the array size is unknown to you. You may only access the array using an ArrayReader interface, where ArrayReader.get(k) returns the element of the array at index k (0-indexed).

**Solution**:
```cpp
// This is the ArrayReader interface definition.
// You should not implement it, or speculate about its implementation
class ArrayReader {
  public:
    int get(int index);
};

int search(ArrayReader& reader, int target) {
    // Find bounds
    int left = 0, right = 1;
    while (reader.get(right) < target) {
        left = right;
        right *= 2;
    }
    
    // Binary search within bounds
    while (left <= right) {
        int mid = left + (right - left) / 2;
        int midVal = reader.get(mid);
        
        if (midVal == target)
            return mid;
        else if (midVal < target)
            left = mid + 1;
        else
            right = mid - 1;
    }
    
    return -1;
}
```

### 23. Find K Closest Elements
**Problem**: Given a sorted integer array arr, two integers k and x, return the k closest integers to x in the array. The result should also be sorted in ascending order.

**Solution**:
```cpp
vector<int> findClosestElements(vector<int>& arr, int k, int x) {
    int left = 0, right = arr.size() - k;
    
    while (left < right) {
        int mid = left + (right - left) / 2;
        
        if (x - arr[mid] > arr[mid + k] - x)
            left = mid + 1;
        else
            right = mid;
    }
    
    return vector<int>(arr.begin() + left, arr.begin() + left + k);
}
```

### 24. Find Right Interval
**Problem**: You are given an array of intervals, where intervals[i] = [starti, endi] and each starti is unique.

The right interval for an interval i is an interval j such that startj >= endi and startj is minimized. Note that i may equal j.

Return an array of right interval indices for each interval i. If no right interval exists for interval i, then put -1 at index i.

**Solution**:
```cpp
vector<int> findRightInterval(vector<vector<int>>& intervals) {
    int n = intervals.size();
    vector<int> result(n, -1);
    
    // Create a map of start points to their indices
    map<int, int> startMap;
    for (int i = 0; i < n; i++) {
        startMap[intervals[i][0]] = i;
    }
    
    // For each interval, find the right interval
    for (int i = 0; i < n; i++) {
        int end = intervals[i][1];
        auto it = startMap.lower_bound(end);
        
        if (it != startMap.end()) {
            result[i] = it->second;
        }
    }
    
    return result;
}
```

### 25. Search Suggestion System (Trie-based)
**Problem**: Given an array of strings products and a string searchWord. We want to design a system that suggests at most three product names from products after each character of searchWord is typed.

**Solution**:
```cpp
struct TrieNode {
    vector<string> suggestions;
    TrieNode* children[26];
    
    TrieNode() {
        fill(begin(children), end(children), nullptr);
    }
};

class Trie {
private:
    TrieNode* root;
    
public:
    Trie() {
        root = new TrieNode();
    }
    
    void insert(string word) {
        TrieNode* current = root;
        for (char c : word) {
            int index = c - 'a';
            if (!current->children[index]) {
                current->children[index] = new TrieNode();
            }
            current = current->children[index];
            
            // Add word to suggestions if less than 3
            if (current->suggestions.size() < 3) {
                current->suggestions.push_back(word);
            }
        }
    }
    
    vector<vector<string>> search(string prefix) {
        vector<vector<string>> result;
        TrieNode* current = root;
        
        for (char c : prefix) {
            int index = c - 'a';
            if (!current->children[index]) {
                // If prefix doesn't exist, all remaining results are empty
                while (result.size() < prefix.size()) {
                    result.push_back({});
                }
                return result;
            }
            current = current->children[index];
            result.push_back(current->suggestions);
        }
        
        return result;
    }
};

vector<vector<string>> suggestedProducts(vector<string>& products, string searchWord) {
    Trie trie;
    for (string& product : products) {
        trie.insert(product);
    }
    
    return trie.search(searchWord);
}
```

## Summary

This collection covers searching problems from easy to hard difficulty levels. Key insights:

1. **Binary Search Variants**: Master the different ways to apply binary search (finding first/last occurrence, searching in rotated arrays, etc.)
2. **Template Pattern**: Many searching problems follow similar patterns - identifying the search space and condition to move left/right
3. **Beyond Arrays**: Searching concepts apply to BSTs, tries, and other data structures
4. **Optimization**: Understanding when to use hash tables, binary search, or other techniques based on data characteristics
5. **Real-world Applications**: Many problems model real scenarios like version control, scheduling, and recommendation systems

Practice these problems to develop strong searching skills, which are essential for efficient data retrieval and problem-solving in computer science.