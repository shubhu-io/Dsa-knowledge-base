# Two Sum Problem
# Given an array of integers nums and an integer target,
# return indices of the two numbers such that they add up to target.

def two_sum(nums, target):
    """
    Returns indices of the two numbers such that they add up to target.
    Uses a hash map for O(n) time complexity.
    """
    num_to_index = {}
    for i, num in enumerate(nums):
        complement = target - num
        if complement in num_to_index:
            return [num_to_index[complement], i]
        num_to_index[num] = i
    return []

# Example usage
if __name__ == "__main__":
    print(two_sum([2, 7, 11, 15], 9))  # Output: [0, 1]