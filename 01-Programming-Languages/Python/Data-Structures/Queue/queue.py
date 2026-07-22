"""
Queue Implementations in Python

Demonstrates various queue types: simple queue, deque, priority queue.
"""

from typing import Any, List
from collections import deque
import heapq


# ============================================================
# 1. Simple Queue (Using List)
# ============================================================

class SimpleQueue:
    """
    Basic queue using a list.

    Time Complexity:
        - enqueue: O(n) — shifting elements
        - dequeue: O(1)
        - peek: O(1)
    Space Complexity: O(n)
    """

    def __init__(self):
        self._items: List[Any] = []

    def enqueue(self, item: Any) -> None:
        """Add item to the back of the queue."""
        self._items.append(item)

    def dequeue(self) -> Any:
        """Remove and return the front item."""
        if self.is_empty():
            raise IndexError("dequeue from empty queue")
        return self._items.pop(0)

    def peek(self) -> Any:
        """Return the front item without removing it."""
        if self.is_empty():
            raise IndexError("peek from empty queue")
        return self._items[0]

    def is_empty(self) -> bool:
        return len(self._items) == 0

    def size(self) -> int:
        return len(self._items)

    def __repr__(self) -> str:
        return f"Queue({self._items})"


# ============================================================
# 2. Deque-Based Queue (Optimal)
# ============================================================

class DequeQueue:
    """
    Queue using collections.deque (optimal for queue operations).

    Time Complexity:
        - enqueue: O(1)
        - dequeue: O(1)
        - peek: O(1)
    Space Complexity: O(n)
    """

    def __init__(self):
        self._items: deque = deque()

    def enqueue(self, item: Any) -> None:
        self._items.append(item)

    def dequeue(self) -> Any:
        if self.is_empty():
            raise IndexError("dequeue from empty queue")
        return self._items.popleft()

    def peek(self) -> Any:
        if self.is_empty():
            raise IndexError("peek from empty queue")
        return self._items[0]

    def is_empty(self) -> bool:
        return len(self._items) == 0

    def size(self) -> int:
        return len(self._items)

    def __repr__(self) -> str:
        return f"DequeQueue({list(self._items)})"


# ============================================================
# 3. Stack Using Two Queues
# ============================================================

class StackUsingQueues:
    """
    Stack implementation using two queues.

    Time Complexity:
        - push: O(n) — requires one full queue transfer
        - pop: O(1)
    Space Complexity: O(n)
    """

    def __init__(self):
        self._q1: deque = deque()
        self._q2: deque = deque()

    def push(self, item: Any) -> None:
        """Push item onto stack."""
        self._q2.append(item)
        while self._q1:
            self._q2.append(self._q1.popleft())
        self._q1, self._q2 = self._q2, self._q1

    def pop(self) -> Any:
        """Pop and return the top item."""
        if self.is_empty():
            raise IndexError("pop from empty stack")
        return self._q1.popleft()

    def peek(self) -> Any:
        if self.is_empty():
            raise IndexError("peek from empty stack")
        return self._q1[0]

    def is_empty(self) -> bool:
        return len(self._q1) == 0

    def size(self) -> int:
        return len(self._q1)


# ============================================================
# 4. Priority Queue (Using Heap)
# ============================================================

class PriorityQueue:
    """
    Priority queue using Python's heapq (min-heap).

    Time Complexity:
        - push: O(log n)
        - pop: O(log n)
        - peek: O(1)
    Space Complexity: O(n)
    """

    def __init__(self):
        self._heap: List[tuple] = []
        self._index: int = 0  # For stable sorting

    def push(self, item: Any, priority: int) -> None:
        """Add item with given priority (lower = higher priority)."""
        heapq.heappush(self._heap, (priority, self._index, item))
        self._index += 1

    def pop(self) -> Any:
        """Remove and return the highest priority item."""
        if self.is_empty():
            raise IndexError("pop from empty priority queue")
        priority, _, item = heapq.heappop(self._heap)
        return item

    def peek(self) -> Any:
        if self.is_empty():
            raise IndexError("peek from empty priority queue")
        return self._heap[0][2]

    def is_empty(self) -> bool:
        return len(self._heap) == 0

    def size(self) -> int:
        return len(self._heap)

    def __repr__(self) -> str:
        items = [(p, i) for p, _, i in sorted(self._heap)]
        return f"PriorityQueue({items})"


# ============================================================
# 5. Circular Queue
# ============================================================

class CircularQueue:
    """
    Fixed-size circular queue using an array.

    Time Complexity:
        - enqueue: O(1)
        - dequeue: O(1)
        - peek: O(1)
    Space Complexity: O(k) where k is capacity
    """

    def __init__(self, capacity: int):
        self._capacity = capacity
        self._queue = [None] * capacity
        self._front = 0
        self._rear = -1
        self._size = 0

    def enqueue(self, item: Any) -> None:
        if self.is_full():
            raise IndexError("enqueue to full queue")
        self._rear = (self._rear + 1) % self._capacity
        self._queue[self._rear] = item
        self._size += 1

    def dequeue(self) -> Any:
        if self.is_empty():
            raise IndexError("dequeue from empty queue")
        item = self._queue[self._front]
        self._queue[self._front] = None
        self._front = (self._front + 1) % self._capacity
        self._size -= 1
        return item

    def peek(self) -> Any:
        if self.is_empty():
            raise IndexError("peek from empty queue")
        return self._queue[self._front]

    def is_empty(self) -> bool:
        return self._size == 0

    def is_full(self) -> bool:
        return self._size == self._capacity

    def size(self) -> int:
        return self._size


# ============================================================
# Applications
# ============================================================

def bfs_level_order(root) -> List[List[int]]:
    """BFS level-order traversal of a binary tree."""
    if not root:
        return []

    result = []
    queue = deque([root])

    while queue:
        level = []
        for _ in range(len(queue)):
            node = queue.popleft()
            level.append(node.val)
            if node.left:
                queue.append(node.left)
            if node.right:
                queue.append(node.right)
        result.append(level)

    return result


def sliding_window_max(nums: List[int], k: int) -> List[int]:
    """
    Find maximum in each sliding window of size k.

    Time: O(n)  |  Space: O(k)
    """
    result = []
    dq = deque()  # Stores indices

    for i in range(len(nums)):
        # Remove elements outside current window
        while dq and dq[0] < i - k + 1:
            dq.popleft()

        # Remove smaller elements from back
        while dq and nums[dq[-1]] < nums[i]:
            dq.pop()

        dq.append(i)

        # Record result once window is complete
        if i >= k - 1:
            result.append(nums[dq[0]])

    return result


# ============================================================
# Demo
# ============================================================

if __name__ == "__main__":
    # Simple Queue
    print("=== Simple Queue ===")
    q = SimpleQueue()
    for i in range(5):
        q.enqueue(i)
        print(f"Enqueued {i}: {q}")
    while not q.is_empty():
        print(f"Dequeued: {q.dequeue()}")

    # Deque Queue
    print("\n=== Deque Queue ===")
    dq = DequeQueue()
    for i in ["A", "B", "C"]:
        dq.enqueue(i)
    print(f"Front: {dq.peek()}")
    print(f"Size: {dq.size()}")
    print(f"Dequeued: {dq.dequeue()}")

    # Stack using Queues
    print("\n=== Stack (Two Queues) ===")
    stack = StackUsingQueues()
    for i in range(1, 4):
        stack.push(i)
    print(f"Popped: {stack.pop()}")   # 3
    print(f"Popped: {stack.pop()}")   # 2
    stack.push(4)
    print(f"Peek: {stack.peek()}")   # 4

    # Priority Queue
    print("\n=== Priority Queue ===")
    pq = PriorityQueue()
    pq.push("Low priority", 3)
    pq.push("High priority", 1)
    pq.push("Medium priority", 2)
    pq.push("Critical", 0)
    print(f"Peek: {pq.peek()}")
    while not pq.is_empty():
        print(f"Pop: {pq.pop()}")

    # Circular Queue
    print("\n=== Circular Queue ===")
    cq = CircularQueue(3)
    cq.enqueue("A")
    cq.enqueue("B")
    cq.enqueue("C")
    print(f"Full: {cq.is_full()}")
    print(f"Dequeued: {cq.dequeue()}")
    cq.enqueue("D")
    while not cq.is_empty():
        print(f"Dequeued: {cq.dequeue()}")

    # Sliding Window Max
    print("\n=== Sliding Window Max ===")
    nums = [1, 3, -1, -3, 5, 3, 6, 7]
    k = 3
    result = sliding_window_max(nums, k)
    print(f"Input: {nums}, k={k}")
    print(f"Result: {result}")
