"""
Recursion Examples in Python

Demonstrates recursive thinking, common patterns, and optimization with memoization.
"""

from typing import List, Optional


# ============================================================
# 1. Basic Recursion
# ============================================================

def factorial(n: int) -> int:
    """Calculate factorial recursively. Time: O(n)"""
    if n <= 1:
        return 1
    return n * factorial(n - 1)


def fibonacci(n: int) -> int:
    """Naive recursive Fibonacci. Time: O(2^n)"""
    if n <= 1:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)


# ============================================================
# 2. String Recursion
# ============================================================

def reverse_string(s: str) -> str:
    """Reverse a string recursively."""
    if len(s) <= 1:
        return s
    return reverse_string(s[1:]) + s[0]


def is_palindrome(s: str) -> bool:
    """Check if string is palindrome recursively."""
    if len(s) <= 1:
        return True
    if s[0] != s[-1]:
        return False
    return is_palindrome(s[1:-1])


def count_char(s: str, char: str) -> int:
    """Count occurrences of char in string."""
    if not s:
        return 0
    return (1 if s[0] == char else 0) + count_char(s[1:], char)


# ============================================================
# 3. Array Recursion
# ============================================================

def sum_array(nums: List[int]) -> int:
    """Sum all elements recursively."""
    if not nums:
        return 0
    return nums[0] + sum_array(nums[1:])


def find_max(nums: List[int]) -> int:
    """Find maximum element recursively."""
    if len(nums) == 1:
        return nums[0]
    rest_max = find_max(nums[1:])
    return nums[0] if nums[0] > rest_max else rest_max


def binary_search_recursive(arr: List[int], target: int,
                            low: int = 0, high: int = -1) -> int:
    """Binary search using recursion."""
    if high == -1:
        high = len(arr) - 1
    if low > high:
        return -1

    mid = (low + high) // 2
    if arr[mid] == target:
        return mid
    elif arr[mid] < target:
        return binary_search_recursive(arr, target, mid + 1, high)
    else:
        return binary_search_recursive(arr, target, low, mid - 1)


# ============================================================
# 4. Divide and Conquer
# ============================================================

def merge_sort(arr: List[int]) -> List[int]:
    """Merge sort using recursion."""
    if len(arr) <= 1:
        return arr

    mid = len(arr) // 2
    left = merge_sort(arr[:mid])
    right = merge_sort(arr[mid:])

    return merge(left, right)


def merge(left: List[int], right: List[int]) -> List[int]:
    """Merge two sorted arrays."""
    result = []
    i = j = 0

    while i < len(left) and j < len(right):
        if left[i] <= right[j]:
            result.append(left[i])
            i += 1
        else:
            result.append(right[j])
            j += 1

    result.extend(left[i:])
    result.extend(right[j:])
    return result


def quick_sort(arr: List[int]) -> List[int]:
    """Quick sort using recursion."""
    if len(arr) <= 1:
        return arr

    pivot = arr[len(arr) // 2]
    left = [x for x in arr if x < pivot]
    middle = [x for x in arr if x == pivot]
    right = [x for x in arr if x > pivot]

    return quick_sort(left) + middle + quick_sort(right)


# ============================================================
# 5. Backtracking
# ============================================================

def permutations(nums: List[int]) -> List[List[int]]:
    """Generate all permutations."""
    result = []

    def backtrack(start: int) -> None:
        if start == len(nums):
            result.append(nums[:])
            return

        for i in range(start, len(nums)):
            nums[start], nums[i] = nums[i], nums[start]
            backtrack(start + 1)
            nums[start], nums[i] = nums[i], nums[start]

    backtrack(0)
    return result


def subsets(nums: List[int]) -> List[List[int]]:
    """Generate all subsets."""
    result = []

    def backtrack(start: int, current: List[int]) -> None:
        result.append(current[:])

        for i in range(start, len(nums)):
            current.append(nums[i])
            backtrack(i + 1, current)
            current.pop()

    backtrack(0, [])
    return result


def solve_n_queens(n: int) -> List[List[str]]:
    """Solve N-Queens problem."""
    results = []

    def backtrack(row: int, cols: set, diag1: set, diag2: set,
                  board: List[str]) -> None:
        if row == n:
            results.append(board[:])
            return

        for col in range(n):
            if col in cols or (row - col) in diag1 or (row + col) in diag2:
                continue

            cols.add(col)
            diag1.add(row - col)
            diag2.add(row + col)
            board.append('.' * col + 'Q' + '.' * (n - col - 1))

            backtrack(row + 1, cols, diag1, diag2, board)

            cols.remove(col)
            diag1.remove(row - col)
            diag2.remove(row + col)
            board.pop()

    backtrack(0, set(), set(), set(), [])
    return results


# ============================================================
# 6. Tree Recursion
# ============================================================

class TreeNode:
    def __init__(self, val: int = 0,
                 left: Optional['TreeNode'] = None,
                 right: Optional['TreeNode'] = None):
        self.val = val
        self.left = left
        self.right = right


def tree_height(root: Optional[TreeNode]) -> int:
    """Find height of binary tree."""
    if not root:
        return 0
    return 1 + max(tree_height(root.left), tree_height(root.right))


def tree_sum(root: Optional[TreeNode]) -> int:
    """Sum all nodes in binary tree."""
    if not root:
        return 0
    return root.val + tree_sum(root.left) + tree_sum(root.right)


def tree_inorder(root: Optional[TreeNode]) -> List[int]:
    """Inorder traversal."""
    if not root:
        return []
    return tree_inorder(root.left) + [root.val] + tree_inorder(root.right)


def is_same_tree(p: Optional[TreeNode], q: Optional[TreeNode]) -> bool:
    """Check if two trees are identical."""
    if not p and not q:
        return True
    if not p or not q:
        return False
    return (p.val == q.val and
            is_same_tree(p.left, q.left) and
            is_same_tree(p.right, q.right))


# ============================================================
# 7. Memoization Pattern
# ============================================================

def memoize(func):
    """Generic memoization decorator."""
    cache = {}

    def wrapper(*args):
        if args not in cache:
            cache[args] = func(*args)
        return cache[args]

    return wrapper


@memoize
def fib_memo(n: int) -> int:
    """Memoized Fibonacci. Time: O(n)"""
    if n <= 1:
        return n
    return fib_memo(n - 1) + fib_memo(n - 2)


@memoize
def grid_paths(m: int, n: int) -> int:
    """Count paths in m x grid (right/down moves only)."""
    if m == 1 or n == 1:
        return 1
    return grid_paths(m - 1, n) + grid_paths(m, n - 1)


# ============================================================
# Demo
# ============================================================

if __name__ == "__main__":
    # Basic recursion
    print("=== Basic Recursion ===")
    print(f"factorial(10) = {factorial(10)}")
    print(f"fibonacci(10) = {fibonacci(10)}")

    # String recursion
    print("\n=== String Recursion ===")
    print(f"reverse('hello') = {reverse_string('hello')}")
    print(f"is_palindrome('racecar') = {is_palindrome('racecar')}")
    print(f"count_char('hello', 'l') = {count_char('hello', 'l')}")

    # Array recursion
    print("\n=== Array Recursion ===")
    nums = [3, 1, 4, 1, 5, 9, 2, 6]
    print(f"sum_array({nums}) = {sum_array(nums)}")
    print(f"find_max({nums}) = {find_max(nums)}")

    sorted_nums = [1, 2, 3, 4, 5, 6, 7, 8]
    print(f"binary_search({sorted_nums}, 5) = {binary_search_recursive(sorted_nums, 5)}")

    # Divide and Conquer
    print("\n=== Divide and Conquer ===")
    unsorted = [38, 27, 43, 3, 9, 82, 10]
    print(f"merge_sort({unsorted}) = {merge_sort(unsorted)}")
    print(f"quick_sort({unsorted}) = {quick_sort(unsorted)}")

    # Backtracking
    print("\n=== Backtracking ===")
    print(f"permutations([1,2,3]) = {permutations([1, 2, 3])}")
    print(f"subsets([1,2,3]) = {subsets([1, 2, 3])}")

    queens = solve_n_queens(4)
    print(f"4-Queens solutions: {len(queens)}")
    for i, board in enumerate(queens):
        print(f"  Solution {i + 1}:")
        for row in board:
            print(f"    {row}")

    # Tree recursion
    print("\n=== Tree Recursion ===")
    root = TreeNode(1)
    root.left = TreeNode(2)
    root.right = TreeNode(3)
    root.left.left = TreeNode(4)
    root.left.right = TreeNode(5)

    print(f"Height: {tree_height(root)}")
    print(f"Sum: {tree_sum(root)}")
    print(f"Inorder: {tree_inorder(root)}")

    # Memoization
    print("\n=== Memoization ===")
    print(f"fib_memo(50) = {fib_memo(50)}")
    print(f"grid_paths(10, 10) = {grid_paths(10, 10)}")
