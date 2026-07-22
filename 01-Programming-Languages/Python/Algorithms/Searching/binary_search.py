'''
Problem: Binary Search
Given a sorted array of integers nums and an integer target,
return the index if target is found. If not, return -1.

Approach:
- Use left and right pointers.
- While left <= right:
   mid = left + (right - left) // 2
   if nums[mid] == target: return mid
   elif nums[mid] < target: left = mid + 1
   else: right = mid - 1
- Return -1 if not found.
Time: O(log n), Space: O(1).

Example:
nums = [-1,0,3,5,9,12], target = 9 -> 4
'''

def binary_search(nums, target):
    left, right = 0, len(nums) - 1
    while left <= right:
        mid = left + (right - left) // 2
        if nums[mid] == target:
            return mid
        elif nums[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    return -1

if __name__ == "__main__":
    nums = [-1, 0, 3, 5, 9, 12]
    target = 9
    idx = binary_search(nums, target)
    print(f"Index of {target}: {idx}")