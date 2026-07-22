"""
Dynamic Programming Examples in Python

Covers classic DP problems with both recursive and tabulation approaches.
"""

from typing import List, Dict


# ============================================================
# 1. Fibonacci (Classic DP Intro)
# ============================================================

def fib_recursive(n: int) -> int:
    """Naive recursive Fibonacci. Time: O(2^n)"""
    if n <= 1:
        return n
    return fib_recursive(n - 1) + fib_recursive(n - 2)


def fib_memo(n: int) -> int:
    """Top-down DP with memoization. Time: O(n)"""
    memo = {}

    def helper(i: int) -> int:
        if i <= 1:
            return i
        if i in memo:
            return memo[i]
        memo[i] = helper(i - 1) + helper(i - 2)
        return memo[i]

    return helper(n)


def fib_tab(n: int) -> int:
    """Bottom-up tabulation. Time: O(n)"""
    if n <= 1:
        return n
    dp = [0] * (n + 1)
    dp[1] = 1
    for i in range(2, n + 1):
        dp[i] = dp[i - 1] + dp[i - 2]
    return dp[n]


def fib_optimized(n: int) -> int:
    """Space-optimized. Time: O(n), Space: O(1)"""
    if n <= 1:
        return n
    a, b = 0, 1
    for _ in range(2, n + 1):
        a, b = b, a + b
    return b


# ============================================================
# 2. Climbing Stairs
# ============================================================

def climb_stairs(n: int) -> int:
    """
    You can climb 1 or 2 steps. How many distinct ways to reach step n?

    Time: O(n)  |  Space: O(1)
    """
    if n <= 2:
        return n
    a, b = 1, 2
    for _ in range(3, n + 1):
        a, b = b, a + b
    return b


# ============================================================
# 3. Coin Change
# ============================================================

def coin_change(coins: List[int], amount: int) -> int:
    """
    Find minimum number of coins to make amount.
    Returns -1 if impossible.

    Time: O(amount * len(coins))  |  Space: O(amount)
    """
    dp = [float('inf')] * (amount + 1)
    dp[0] = 0

    for i in range(1, amount + 1):
        for coin in coins:
            if coin <= i and dp[i - coin] + 1 < dp[i]:
                dp[i] = dp[i - coin] + 1

    return dp[amount] if dp[amount] != float('inf') else -1


# ============================================================
# 4. 0/1 Knapsack
# ============================================================

def knapsack(weights: List[int], values: List[int], capacity: int) -> int:
    """
    0/1 Knapsack problem.

    Time: O(n * capacity)  |  Space: O(n * capacity)
    """
    n = len(weights)
    dp = [[0] * (capacity + 1) for _ in range(n + 1)]

    for i in range(1, n + 1):
        for w in range(capacity + 1):
            dp[i][w] = dp[i - 1][w]  # Don't take item i
            if weights[i - 1] <= w:
                dp[i][w] = max(
                    dp[i][w],
                    dp[i - 1][w - weights[i - 1]] + values[i - 1]
                )

    return dp[n][capacity]


def knapsack_optimized(weights: List[int], values: List[int], capacity: int) -> int:
    """
    Space-optimized 0/1 Knapsack.

    Time: O(n * capacity)  |  Space: O(capacity)
    """
    dp = [0] * (capacity + 1)

    for i in range(len(weights)):
        for w in range(capacity, weights[i] - 1, -1):
            dp[w] = max(dp[w], dp[w - weights[i]] + values[i])

    return dp[capacity]


# ============================================================
# 5. Longest Common Subsequence (LCS)
# ============================================================

def lcs(text1: str, text2: str) -> int:
    """
    Find length of longest common subsequence.

    Time: O(m * n)  |  Space: O(m * n)
    """
    m, n = len(text1), len(text2)
    dp = [[0] * (n + 1) for _ in range(m + 1)]

    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if text1[i - 1] == text2[j - 1]:
                dp[i][j] = dp[i - 1][j - 1] + 1
            else:
                dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])

    return dp[m][n]


# ============================================================
# 6. Longest Increasing Subsequence (LIS)
# ============================================================

def lis(nums: List[int]) -> int:
    """
    Find length of longest increasing subsequence.

    Time: O(n^2)  |  Space: O(n)
    """
    if not nums:
        return 0

    dp = [1] * len(nums)

    for i in range(1, len(nums)):
        for j in range(i):
            if nums[j] < nums[i]:
                dp[i] = max(dp[i], dp[j] + 1)

    return max(dp)


def lis_binary_search(nums: List[int]) -> int:
    """
    Optimized LIS using binary search.

    Time: O(n log n)  |  Space: O(n)
    """
    import bisect

    tails = []
    for num in nums:
        pos = bisect.bisect_left(tails, num)
        if pos == len(tails):
            tails.append(num)
        else:
            tails[pos] = num

    return len(tails)


# ============================================================
# 7. Maximum Subarray (Kadane's Algorithm)
# ============================================================

def max_subarray(nums: List[int]) -> int:
    """
    Find the contiguous subarray with the largest sum.

    Time: O(n)  |  Space: O(1)
    """
    max_sum = current_sum = nums[0]
    for num in nums[1:]:
        current_sum = max(num, current_sum + num)
        max_sum = max(max_sum, current_sum)
    return max_sum


# ============================================================
# 8. House Robber
# ============================================================

def rob(nums: List[int]) -> int:
    """
    Rob houses without robbing two adjacent houses.

    Time: O(n)  |  Space: O(1)
    """
    if not nums:
        return 0
    if len(nums) == 1:
        return nums[0]

    prev2, prev1 = 0, 0
    for num in nums:
        prev2, prev1 = prev1, max(prev1, prev2 + num)
    return prev1


# ============================================================
# 9. Grid Unique Paths
# ============================================================

def unique_paths(m: int, n: int) -> int:
    """
    Count unique paths from top-left to bottom-right (only right/down moves).

    Time: O(m * n)  |  Space: O(n)
    """
    dp = [1] * n
    for _ in range(1, m):
        for j in range(1, n):
            dp[j] += dp[j - 1]
    return dp[n - 1]


# ============================================================
# 10. Edit Distance
# ============================================================

def edit_distance(word1: str, word2: str) -> int:
    """
    Minimum operations to convert word1 to word2.
    Operations: insert, delete, replace.

    Time: O(m * n)  |  Space: O(m * n)
    """
    m, n = len(word1), len(word2)
    dp = [[0] * (n + 1) for _ in range(m + 1)]

    for i in range(m + 1):
        dp[i][0] = i
    for j in range(n + 1):
        dp[0][j] = j

    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if word1[i - 1] == word2[j - 1]:
                dp[i][j] = dp[i - 1][j - 1]
            else:
                dp[i][j] = 1 + min(
                    dp[i - 1][j],      # Delete
                    dp[i][j - 1],      # Insert
                    dp[i - 1][j - 1]   # Replace
                )

    return dp[m][n]


# ============================================================
# Demo
# ============================================================

if __name__ == "__main__":
    # Fibonacci
    print("=== Fibonacci ===")
    for n in range(11):
        print(f"fib({n}) = {fib_tab(n)}")

    # Climbing Stairs
    print("\n=== Climbing Stairs ===")
    for n in range(1, 6):
        print(f"climb_stairs({n}) = {climb_stairs(n)}")

    # Coin Change
    print("\n=== Coin Change ===")
    coins = [1, 5, 10, 25]
    amount = 30
    print(f"Coins: {coins}, Amount: {amount}")
    print(f"Min coins: {coin_change(coins, amount)}")

    # Knapsack
    print("\n=== 0/1 Knapsack ===")
    weights = [2, 3, 4, 5]
    values = [3, 4, 5, 6]
    capacity = 8
    print(f"Weights: {weights}")
    print(f"Values: {values}")
    print(f"Capacity: {capacity}")
    print(f"Max value: {knapsack(weights, values, capacity)}")

    # LCS
    print("\n=== Longest Common Subsequence ===")
    text1 = "abcde"
    text2 = "ace"
    print(f"LCS of '{text1}' and '{text2}': {lcs(text1, text2)}")

    # LIS
    print("\n=== Longest Increasing Subsequence ===")
    nums = [10, 9, 2, 5, 3, 7, 101, 18]
    print(f"Array: {nums}")
    print(f"LIS length: {lis(nums)}")

    # Max Subarray
    print("\n=== Maximum Subarray (Kadane's) ===")
    nums = [-2, 1, -3, 4, -1, 2, 1, -5, 4]
    print(f"Array: {nums}")
    print(f"Max subarray sum: {max_subarray(nums)}")

    # House Robber
    print("\n=== House Robber ===")
    nums = [2, 7, 9, 3, 1]
    print(f"Houses: {nums}")
    print(f"Max robbed: {rob(nums)}")

    # Unique Paths
    print("\n=== Unique Paths ===")
    print(f"Paths in 3x7 grid: {unique_paths(3, 7)}")

    # Edit Distance
    print("\n=== Edit Distance ===")
    word1 = "horse"
    word2 = "ros"
    print(f"Edit distance('{word1}', '{word2}'): {edit_distance(word1, word2)}")
