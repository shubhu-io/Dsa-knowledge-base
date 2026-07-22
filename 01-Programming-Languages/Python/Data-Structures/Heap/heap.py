"""
Heap / Priority Queue Implementations in Python

Demonstrates min-heap, max-heap, and heap sort.
Python's heapq module provides min-heap operations.
"""

from typing import Any, List, Optional
import heapq


# ============================================================
# 1. Min-Heap (Array-Based)
# ============================================================

class MinHeap:
    """
    Min-heap using an array.

    Properties:
        - Parent of node i: (i - 1) // 2
        - Left child of node i: 2 * i + 1
        - Right child of node i: 2 * i + 2

    Time Complexity:
        - Insert: O(log n)
        - Extract Min: O(log n)
        - Peek: O(1)
    Space Complexity: O(n)
    """

    def __init__(self):
        self._heap: List[Any] = []

    def _parent(self, i: int) -> int:
        return (i - 1) // 2

    def _left_child(self, i: int) -> int:
        return 2 * i + 1

    def _right_child(self, i: int) -> int:
        return 2 * i + 2

    def _swap(self, i: int, j: int) -> None:
        self._heap[i], self._heap[j] = self._heap[j], self._heap[i]

    def _heapify_up(self, i: int) -> None:
        """Restore heap property by bubbling up."""
        while i > 0 and self._heap[i] < self._heap[self._parent(i)]:
            self._swap(i, self._parent(i))
            i = self._parent(i)

    def _heapify_down(self, i: int) -> None:
        """Restore heap property by bubbling down."""
        smallest = i
        left = self._left_child(i)
        right = self._right_child(i)

        if left < len(self._heap) and self._heap[left] < self._heap[smallest]:
            smallest = left
        if right < len(self._heap) and self._heap[right] < self._heap[smallest]:
            smallest = right

        if smallest != i:
            self._swap(i, smallest)
            self._heapify_down(smallest)

    def insert(self, value: Any) -> None:
        """Insert a value into the heap."""
        self._heap.append(value)
        self._heapify_up(len(self._heap) - 1)

    def extract_min(self) -> Any:
        """Remove and return the minimum value."""
        if self.is_empty():
            raise IndexError("extract from empty heap")
        min_val = self._heap[0]
        last = self._heap.pop()
        if self._heap:
            self._heap[0] = last
            self._heapify_down(0)
        return min_val

    def peek(self) -> Any:
        """Return the minimum value without removing it."""
        if self.is_empty():
            raise IndexError("peek from empty heap")
        return self._heap[0]

    def is_empty(self) -> bool:
        return len(self._heap) == 0

    def size(self) -> int:
        return len(self._heap)

    def __repr__(self) -> str:
        return f"MinHeap({self._heap})"


# ============================================================
# 2. Max-Heap (Using Min-Heap with Negation)
# ============================================================

class MaxHeap:
    """Max-heap implemented by negating values in a MinHeap."""

    def __init__(self):
        self._heap = MinHeap()

    def insert(self, value: Any) -> None:
        self._heap.insert(-value)

    def extract_max(self) -> Any:
        return -self._heap.extract_min()

    def peek(self) -> Any:
        return -self._heap.peek()

    def is_empty(self) -> bool:
        return self._heap.is_empty()

    def size(self) -> int:
        return self._heap.size()


# ============================================================
# 3. Heap Sort
# ============================================================

def heap_sort(arr: List[int]) -> List[int]:
    """
    Sort array using heap sort.

    Time: O(n log n)  |  Space: O(n)
    """
    heap = MinHeap()
    for val in arr:
        heap.insert(val)

    sorted_arr = []
    while not heap.is_empty():
        sorted_arr.append(heap.extract_min())

    return sorted_arr


def heap_sort_inplace(arr: List[int]) -> None:
    """
    In-place heap sort using heapq.

    Time: O(n log n)  |  Space: O(1)
    """
    heapq.heapify(arr)
    sorted_arr = []
    while arr:
        sorted_arr.append(heapq.heappop(arr))
    arr.extend(sorted_arr)


# ============================================================
# 4. Top K Elements
# ============================================================

def find_k_largest(nums: List[int], k: int) -> List[int]:
    """
    Find the k largest elements using a min-heap of size k.

    Time: O(n log k)  |  Space: O(k)
    """
    min_heap = nums[:k]
    heapq.heapify(min_heap)

    for num in nums[k:]:
        if num > min_heap[0]:
            heapq.heapreplace(min_heap, num)

    return sorted(min_heap, reverse=True)


def find_k_smallest(nums: List[int], k: int) -> List[int]:
    """
    Find the k smallest elements using a max-heap of size k.

    Time: O(n log k)  |  Space: O(k)
    """
    max_heap = [-num for num in nums[:k]]
    heapq.heapify(max_heap)

    for num in nums[k:]:
        if num < -max_heap[0]:
            heapq.heapreplace(max_heap, -num)

    return sorted([-x for x in max_heap])


# ============================================================
# 5. Median Finder (Two Heaps)
# ============================================================

class MedianFinder:
    """
    Find median of a stream of numbers.

    Uses two heaps:
        - max_heap: stores smaller half
        - min_heap: stores larger half

    Time Complexity:
        - addNum: O(log n)
        - findMedian: O(1)
    Space Complexity: O(n)
    """

    def __init__(self):
        self._max_heap = []  # Lower half (negated for max-heap)
        self._min_heap = []  # Upper half

    def add_num(self, num: int) -> None:
        heapq.heappush(self._max_heap, -num)
        heapq.heappush(self._min_heap, -heapq.heappop(self._max_heap))

        if len(self._min_heap) > len(self._max_heap):
            heapq.heappush(self._max_heap, -heapq.heappop(self._min_heap))

    def find_median(self) -> float:
        if len(self._max_heap) > len(self._min_heap):
            return -self._max_heap[0]
        return (-self._max_heap[0] + self._min_heap[0]) / 2.0


# ============================================================
# 6. Merge K Sorted Lists (Using Min-Heap)
# ============================================================

def merge_k_sorted(lists: List[List[int]]) -> List[int]:
    """
    Merge k sorted lists into one sorted list.

    Time: O(N log k) where N is total elements  |  Space: O(k)
    """
    result = []
    min_heap = []

    for i, lst in enumerate(lists):
        if lst:
            heapq.heappush(min_heap, (lst[0], i, 0))

    while min_heap:
        val, list_idx, elem_idx = heapq.heappop(min_heap)
        result.append(val)

        if elem_idx + 1 < len(lists[list_idx]):
            next_val = lists[list_idx][elem_idx + 1]
            heapq.heappush(min_heap, (next_val, list_idx, elem_idx + 1))

    return result


# ============================================================
# Demo
# ============================================================

if __name__ == "__main__":
    # Min-Heap
    print("=== Min-Heap ===")
    heap = MinHeap()
    for val in [5, 3, 8, 1, 2, 7]:
        heap.insert(val)
        print(f"Inserted {val}: {heap}")

    print(f"Peek (min): {heap.peek()}")
    while not heap.is_empty():
        print(f"Extract min: {heap.extract_min()}")

    # Max-Heap
    print("\n=== Max-Heap ===")
    max_heap = MaxHeap()
    for val in [5, 3, 8, 1, 2, 7]:
        max_heap.insert(val)
    print(f"Peek (max): {max_heap.peek()}")
    while not max_heap.is_empty():
        print(f"Extract max: {max_heap.extract_max()}")

    # Heap Sort
    print("\n=== Heap Sort ===")
    arr = [64, 34, 25, 12, 22, 11, 90]
    sorted_arr = heap_sort(arr)
    print(f"Original: {arr}")
    print(f"Sorted: {sorted_arr}")

    # Top K
    print("\n=== Top K Elements ===")
    nums = [3, 1, 5, 12, 2, 11, 8, 7]
    print(f"3 largest: {find_k_largest(nums, 3)}")
    print(f"3 smallest: {find_k_smallest(nums, 3)}")

    # Median Finder
    print("\n=== Median Finder ===")
    mf = MedianFinder()
    for num in [5, 15, 1, 3]:
        mf.add_num(num)
        print(f"Added {num}, median = {mf.find_median()}")

    # Merge K Sorted Lists
    print("\n=== Merge K Sorted Lists ===")
    lists = [[1, 4, 7], [2, 5, 8], [3, 6, 9]]
    merged = merge_k_sorted(lists)
    print(f"Input: {lists}")
    print(f"Merged: {merged}")
