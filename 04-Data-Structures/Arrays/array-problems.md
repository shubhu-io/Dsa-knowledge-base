# Array Problems

## Easy Problems

### 1. Two Sum
**Problem**: Given an array of integers `nums` and an integer `target`, return indices of the two numbers such that they add up to `target`.

**Example**:
```
Input: nums = [2,7,11,15], target = 9
Output: [0,1]
Explanation: Because nums[0] + nums[1] == 9, we return [0, 1].
```

**Solution Approach**:
- Use a hash map to store numbers we've seen so far
- For each number, check if target - current number exists in the map
- If yes, return current index and the stored index
- If no, store current number with its index

**Python Solution**:
```python
def two_sum(nums, target):
    num_map = {}  # value -> index
    for i, num in enumerate(nums):
        complement = target - num
        if complement in num_map:
            return [num_map[complement], i]
        num_map[num] = i
    return []
```

### 2. Best Time to Buy and Sell Stock
**Problem**: Given an array where `prices[i]` is the price of a given stock on day `i`, return the maximum profit you can achieve. You may complete at most one transaction.

**Example**:
```
Input: prices = [7,1,5,3,6,4]
Output: 5
Explanation: Buy on day 2 (price = 1) and sell on day 5 (price = 6), profit = 6-1 = 5.
```

**Solution Approach**:
- Track minimum price seen so far
- Calculate potential profit at each step
- Update maximum profit if current profit is higher

**Python Solution**:
```python
def max_profit(prices):
    if not prices:
        return 0
    
    min_price = float('inf')
    max_profit = 0
    
    for price in prices:
        if price < min_price:
            min_price = price
        elif price - min_price > max_profit:
            max_profit = price - min_price
    
    return max_profit
```

### 3. Contains Duplicate
**Problem**: Given an integer array `nums`, return `true` if any value appears at least twice in the array, and return `false` if every element is distinct.

**Example**:
```
Input: nums = [1,2,3,1]
Output: true
```

**Solution Approach**:
- Use a hash set to track seen elements
- If element already exists in set, return true
- Otherwise add to set and continue

**Python Solution**:
```python
def contains_duplicate(nums):
    seen = set()
    for num in nums:
        if num in seen:
            return True
        seen.add(num)
    return False
```

### 4. Single Number
**Problem**: Given a non-empty array of integers `nums`, every element appears twice except for one. Find that single one.

**Example**:
```
Input: nums = [2,2,1]
Output: 1
```

**Solution Approach**:
- Use XOR operation: a XOR a = 0, a XOR 0 = a
- All duplicates cancel out, leaving the single number

**Python Solution**:
```python
def single_number(nums):
    result = 0
    for num in nums:
        result ^= num
    return result
```

### 5. Intersection of Two Arrays
**Problem**: Given two integer arrays `nums1` and `nums2`, return an array of their intersection. Each element in the result must be unique.

**Example**:
```
Input: nums1 = [1,2,2,1], nums2 = [2,2]
Output: [2]
```

**Solution Approach**:
- Convert both arrays to sets
- Find intersection of the sets
- Convert result back to list

**Python Solution**:
```python
def intersection(nums1, nums2):
    set1 = set(nums1)
    set2 = set(nums2)
    return list(set1 & set2)
```

## Medium Problems

### 1. Container With Most Water
**Problem**: Given n non-negative integers a1, a2, ..., an, where each represents a point at coordinate (i, ai). n vertical lines are drawn such that the two endpoints of line i is at (i, ai) and (i, 0). Find two lines, which together with x-axis forms a container, such that the container contains the most water.

**Example**:
```
Input: height = [1,8,6,2,5,4,8,3,7]
Output: 49
```

**Solution Approach**:
- Use two pointers: one at beginning, one at end
- Calculate area formed by lines at both pointers
- Move the pointer pointing to the shorter line inward
- Continue until pointers meet

**Python Solution**:
```python
def max_area(height):
    left = 0
    right = len(height) - 1
    max_area = 0
    
    while left < right:
        width = right - left
        current_area = min(height[left], height[right]) * width
        max_area = max(max_area, current_area)
        
        if height[left] < height[right]:
            left += 1
        else:
            right -= 1
    
    return max_area
```

### 2. 3Sum
**Problem**: Given an integer array nums, return all the triplets [nums[i], nums[j], nums[k]] such that i != j, i != k, and j != k, and nums[i] + nums[j] + nums[k] == 0.

**Example**:
```
Input: nums = [-1,0,1,2,-1,-4]
Output: [[-1,-1,2],[-1,0,1]]
```

**Solution Approach**:
- Sort the array
- Fix one element and use two pointers for the remaining part
- Skip duplicates to avoid duplicate triplets

**Python Solution**:
```python
def three_sum(nums):
    nums.sort()
    result = []
    n = len(nums)
    
    for i in range(n - 2):
        # Skip duplicates for the first number
        if i > 0 and nums[i] == nums[i-1]:
            continue
        
        left, right = i + 1, n - 1
        while left < right:
            total = nums[i] + nums[left] + nums[right]
            if total < 0:
                left += 1
            elif total > 0:
                right -= 1
            else:
                result.append([nums[i], nums[left], nums[right]])
                # Skip duplicates for second and third numbers
                while left < right and nums[left] == nums[left + 1]:
                    left += 1
                while left < right and nums[right] == nums[right - 1]:
                    right -= 1
                left += 1
                right -= 1
    
    return result
```

### 3. Maximum Subarray
**Problem**: Given an integer array nums, find the contiguous subarray (containing at least one number) which has the largest sum and return its sum.

**Example**:
```
Input: nums = [-2,1,-3,4,-1,2,1,-5,4]
Output: 6
Explanation: [4,-1,2,1] has the largest sum = 6.
```

**Solution Approach**:
- Use Kadane's algorithm
- Keep track of current maximum ending at each position
- Update global maximum if current maximum is greater

**Python Solution**:
```python
def max_subarray(nums):
    max_current = max_global = nums[0]
    
    for i in range(1, len(nums)):
        max_current = max(nums[i], max_current + nums[i])
        if max_current > max_global:
            max_global = max_current
    
    return max_global
```

### 4. Product of Array Except Self
**Problem**: Given an integer array nums, return an array answer such that answer[i] is equal to the product of all the elements of nums except nums[i].

**Example**:
```
Input: nums = [1,2,3,4]
Output: [24,12,8,6]
```

**Solution Approach**:
- Calculate prefix products (products of all elements to the left)
- Calculate suffix products (products of all elements to the right)
- Multiply prefix and suffix for each position

**Python Solution**:
```python
def product_except_self(nums):
    n = len(nums)
    answer = [1] * n
    
    # Calculate prefix products
    prefix = 1
    for i in range(n):
        answer[i] = prefix
        prefix *= nums[i]
    
    # Calculate suffix products and multiply with prefix
    suffix = 1
    for i in range(n - 1, -1, -1):
        answer[i] *= suffix
        suffix *= nums[i]
    
    return answer
```

### 5. Rotate Array
**Problem**: Given an array, rotate the array to the right by k steps, where k is non-negative.

**Example**:
```
Input: nums = [1,2,3,4,5,6,7], k = 3
Output: [5,6,7,1,2,3,4]
```

**Solution Approach**:
- Reverse the entire array
- Reverse the first k elements
- Reverse the remaining elements

**Python Solution**:
```python
def rotate(nums, k):
    n = len(nums)
    k = k % n  # Handle cases where k >= n
    
    # Helper function to reverse array in-place
    def reverse(start, end):
        while start < end:
            nums[start], nums[end] = nums[end], nums[start]
            start += 1
            end -= 1
    
    # Reverse entire array
    reverse(0, n - 1)
    # Reverse first k elements
    reverse(0, k - 1)
    # Reverse remaining elements
    reverse(k, n - 1)
```

## Hard Problems

### 1. Trapping Rain Water
**Problem**: Given n non-negative integers representing an elevation map where the width of each bar is 1, compute how much water it can trap after raining.

**Example**:
```
Input: height = [0,1,0,2,1,0,1,3,2,1,2,1]
Output: 6
```

**Solution Approach**:
- For each position, water trapped = min(left_max, right_max) - current_height
- Precompute left_max and right_max arrays
- Sum up water trapped at each position

**Python Solution**:
```python
def trap(height):
    if not height:
        return 0
    
    n = len(height)
    left_max = [0] * n
    right_max = [0] * n
    
    # Fill left_max array
    left_max[0] = height[0]
    for i in range(1, n):
        left_max[i] = max(left_max[i-1], height[i])
    
    # Fill right_max array
    right_max[n-1] = height[n-1]
    for i in range(n-2, -1, -1):
        right_max[i] = max(right_max[i+1], height[i])
    
    # Calculate trapped water
    water = 0
    for i in range(n):
        water += min(left_max[i], right_max[i]) - height[i]
    
    return water
```

### 2. Median of Two Sorted Arrays
**Problem**: Given two sorted arrays nums1 and nums2 of size m and n respectively, return the median of the two sorted arrays.

**Example**:
```
Input: nums1 = [1,3], nums2 = [2]
Output: 2.00000
Explanation: merged array = [1,2,3] and median is 2.
```

**Solution Approach**:
- Use binary search on the smaller array
- Partition both arrays such that left part has equal elements as right part
- Ensure all elements in left part <= all elements in right part

**Python Solution**:
```python
def find_median_sorted_arrays(nums1, nums2):
    # Ensure nums1 is the smaller array
    if len(nums1) > len(nums2):
        nums1, nums2 = nums2, nums1
    
    m, n = len(nums1), len(nums2)
    imin, imax = 0, m
    half_len = (m + n + 1) // 2
    
    while imin <= imax:
        i = (imin + imax) // 2
        j = half_len - i
        
        if i < m and nums2[j-1] > nums1[i]:
            # i is too small, increase it
            imin = i + 1
        elif i > 0 and nums1[i-1] > nums2[j]:
            # i is too big, decrease it
            imax = i - 1
        else:
            # i is perfect
            if i == 0: max_of_left = nums2[j-1]
            elif j == 0: max_of_left = nums1[i-1]
            else: max_of_left = max(nums1[i-1], nums2[j-1])
            
            if (m + n) % 2 == 1:
                return max_of_left
            
            if i == m: min_of_right = nums2[j]
            elif j == n: min_of_right = nums1[i]
            else: min_of_right = min(nums1[i], nums2[j])
            
            return (max_of_left + min_of_right) / 2.0
```

### 3. Longest Consecutive Sequence
**Problem**: Given an unsorted array of integers nums, return the length of the longest consecutive elements sequence.

**Example**:
```
Input: nums = [100,4,200,1,3,2]
Output: 4
Explanation: The longest consecutive elements sequence is [1, 2, 3, 4]. Therefore its length is 4.
```

**Solution Approach**:
- Use a set for O(1) lookups
- Only start counting from numbers that don't have a predecessor
- For each sequence start, count upward

**Python Solution**:
```python
def longest_consecutive(nums):
    if not nums:
        return 0
    
    num_set = set(nums)
    longest_streak = 0
    
    for num in num_set:
        # Check if it's the start of a sequence
        if num - 1 not in num_set:
            current_num = num
            current_streak = 1
            
            # Count upward
            while current_num + 1 in num_set:
                current_num += 1
                current_streak += 1
            
            longest_streak = max(longest_streak, current_streak)
    
    return longest_streak
```

### 4. Spiral Matrix
**Problem**: Given an m x n matrix, return all elements of the matrix in spiral order.

**Example**:
```
Input: matrix = [[1,2,3],[4,5,6],[7,8,9]]
Output: [1,2,3,6,9,8,7,4,5]
```

**Solution Approach**:
- Use four boundaries: top, bottom, left, right
- Traverse right along top boundary, then increment top
- Traverse down along right boundary, then decrement right
- Traverse left along bottom boundary, then decrement bottom
- Traverse up along left boundary, then increment left
- Repeat until boundaries cross

**Python Solution**:
```python
def spiral_order(matrix):
    if not matrix:
        return []
    
    rows, cols = len(matrix), len(matrix[0])
    top, bottom = 0, rows - 1
    left, right = 0, cols - 1
    result = []
    
    while top <= bottom and left <= right:
        # Traverse right
        for col in range(left, right + 1):
            result.append(matrix[top][col])
        top += 1
        
        # Traverse down
        for row in range(top, bottom + 1):
            result.append(matrix[row][right])
        right -= 1
        
        # Traverse left (if still in valid rows)
        if top <= bottom:
            for col in range(right, left - 1, -1):
                result.append(matrix[bottom][col])
            bottom -= 1
        
        # Traverse up (if still in valid columns)
        if left <= right:
            for row in range(bottom, top - 1, -1):
                result.append(matrix[row][left])
            left += 1
    
    return result
```

### 5. Set Matrix Zeroes
**Problem**: Given an m x n integer matrix matrix, if an element is 0, set its entire row and column to 0's, and return the matrix.

**Example**:
```
Input: matrix = [[1,1,1],[1,0,1],[1,1,1]]
Output: [[1,0,1],[0,0,0],[1,0,1]]
```

**Solution Approach**:
- Use first row and first column as markers
- First pass: mark rows and columns that need to be zeroed
- Second pass: set cells to zero based on markers
- Handle first row and column specially

**Python Solution**:
```python
def set_zeroes(matrix):
    if not matrix:
        return
    
    rows, cols = len(matrix), len(matrix[0])
    first_row_has_zero = False
    first_col_has_zero = False
    
    # Check if first row has zero
    for j in range(cols):
        if matrix[0][j] == 0:
            first_row_has_zero = True
            break
    
    # Check if first column has zero
    for i in range(rows):
        if matrix[i][0] == 0:
            first_col_has_zero = True
            break
    
    # Check for zeros in the rest of the matrix
    for i in range(1, rows):
        for j in range(1, cols):
            if matrix[i][j] == 0:
                matrix[i][0] = 0
                matrix[0][j] = 0
    
    # Set zeros based on markers in first row and column
    for i in range(1, rows):
        for j in range(1, cols):
            if matrix[i][0] == 0 or matrix[0][j] == 0:
                matrix[i][j] = 0
    
    # Set first row to zero if needed
    if first_row_has_zero:
        for j in range(cols):
            matrix[0][j] = 0
    
    # Set first column to zero if needed
    if first_col_has_zero:
        for i in range(rows):
            matrix[i][0] = 0
```

## Additional Practice Problems

### Easy
1. Find the maximum element in an array
2. Find the minimum element in an array
3. Check if array is sorted
4. Reverse an array
5. Find sum of all elements in an array
6. Find average of array elements
7. Count occurrences of an element in array
8. Find missing number in array of 0..n
9. Find duplicate number in array
10. Move all zeros to end of array

### Medium
1. Find pair with given sum in array
2. Find subarray with given sum
3. Find maximum product subarray
4. Find equilibrium index of an array
5. Find leaders in an array
6. Find minimum number of platforms required for railway station
7. Find maximum difference between two elements such that larger element appears after smaller number
8. Find the repeating and missing elements
9. Find minimum absolute difference in array
10. Find the element that appears once in array where every other element appears twice

### Hard
1. Find minimum number of jumps to reach end of array
2. Find length of longest increasing subsequence
3. Find maximum sum such that no two elements are adjacent
4. Find the maximum circular subarray sum
5. Find the smallest positive integer value that cannot be represented as sum of subset of array
6. Find the minimum size subarray sum
7. Find the maximum length subarray with given sum
8. Find the maximum product of three numbers
9. Find the kth largest element in an array
10. Find the minimum difference between maximum and minimum array elements after k modifications

## Summary
Arrays are versatile data structures that appear in countless coding interview questions. Mastering array manipulation techniques is essential for success in technical interviews. The key patterns to recognize include:
- Two pointers (opposite ends, same direction, fast/slow)
- Sliding window
- Prefix sum
- In-place modification
- Sorting as a preprocessing step
- Using hash maps for frequency counting
- Boundary tracking (for matrix problems)

When solving array problems, always consider:
1. Time and space complexity requirements
2. Edge cases (empty array, single element, duplicates)
3. Whether the array is sorted or not
4. If you can modify the input array or need to preserve it
5. Whether you need to return values, indices, or modify in-place