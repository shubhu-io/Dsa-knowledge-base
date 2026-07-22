# Project Implementation Guide

Step-by-step methodology for implementing DSA projects from conception to completion.

---

## Phase 1: Planning (20% of time)

### 1.1 Problem Definition

Before writing code, clearly define the problem:

```markdown
## Problem Statement Template

**What:** [One sentence description]
**Why:** [Motivation/use case]
**Who:** [Target users]
**Success Criteria:** [How we know it's done]

### Requirements
- Functional: [What it must do]
- Non-functional: [Performance, scale constraints]
- Constraints: [Memory, time limits]

### Out of Scope
- [What we explicitly won't build]
```

### 1.2 Concept Selection

Identify which DSA concepts apply:

| Problem Type | Likely Data Structures |
|-------------|----------------------|
| Fast lookup | Hash Map |
| Ordered data | BST, Balanced Tree |
| Sequence with inserts at ends | Deque, Linked List |
| Priority processing | Heap, Priority Queue |
| Hierarchical data | Tree, Trie |
| Relationships | Graph |
| Caching | LRU Cache |
| Sliding analysis | Sliding Window |
| String matching | Trie, KMP |

### 1.3 Architecture Design

Sketch the high-level architecture:

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│   Input     │────▶│   Processor  │────▶│   Output    │
│   Layer     │     │   (DSA Core) │     │   Layer     │
└─────────────┘     └──────────────┘     └─────────────┘
                           │
                    ┌──────┴──────┐
                    │  Storage    │
                    │  Layer      │
                    └─────────────┘
```

---

## Phase 2: Implementation (50% of time)

### 2.1 Data Structure Implementation

Start with the core data structure:

```python
class MinHeap:
    def __init__(self):
        self.heap = []

    def parent(self, i):
        return (i - 1) // 2

    def left_child(self, i):
        return 2 * i + 1

    def right_child(self, i):
        return 2 * i + 2

    def swap(self, i, j):
        self.heap[i], self.heap[j] = self.heap[j], self.heap[i]

    def insert(self, key):
        self.heap.append(key)
        self._heapify_up(len(self.heap) - 1)

    def extract_min(self):
        if not self.heap:
            raise IndexError("Heap is empty")
        minimum = self.heap[0]
        last = self.heap.pop()
        if self.heap:
            self.heap[0] = last
            self._heapify_down(0)
        return minimum

    def _heapify_up(self, i):
        while i > 0 and self.heap[self.parent(i)] > self.heap[i]:
            self.swap(i, self.parent(i))
            i = self.parent(i)

    def _heapify_down(self, i):
        smallest = i
        left = self.left_child(i)
        right = self.right_child(i)

        if left < len(self.heap) and self.heap[left] < self.heap[smallest]:
            smallest = left
        if right < len(self.heap) and self.heap[right] < self.heap[smallest]:
            smallest = right

        if smallest != i:
            self.swap(i, smallest)
            self._heapify_down(smallest)
```

### 2.2 Algorithm Implementation

Implement algorithms using your data structures:

```python
def dijkstra(graph, start):
    distances = {node: float('infinity') for node in graph}
    distances[start] = 0
    previous = {node: None for node in graph}
    pq = MinHeap()
    pq.insert((0, start))
    visited = set()

    while pq.heap:
        current_dist, current_node = pq.extract_min()

        if current_node in visited:
            continue
        visited.add(current_node)

        for neighbor, weight in graph[current_node].items():
            if neighbor not in visited:
                new_dist = current_dist + weight
                if new_dist < distances[neighbor]:
                    distances[neighbor] = new_dist
                    previous[neighbor] = current_node
                    pq.insert((new_dist, neighbor))

    return distances, previous
```

### 2.3 Error Handling

Always handle edge cases:

```python
def safe_operation(data):
    # Input validation
    if not data:
        raise ValueError("Data cannot be empty")

    if not isinstance(data, list):
        raise TypeError("Data must be a list")

    # Edge cases
    if len(data) == 1:
        return data[0]

    # Normal operation
    try:
        result = perform_operation(data)
        return result
    except MemoryError:
        raise RuntimeError("Dataset too large for current memory")
    except Exception as e:
        raise RuntimeError(f"Operation failed: {e}")
```

---

## Phase 3: Testing (20% of time)

### 3.1 Unit Tests

Test every method:

```python
import pytest

class TestMinHeap:
    def test_insert_single(self):
        heap = MinHeap()
        heap.insert(5)
        assert heap.heap == [5]

    def test_insert_multiple(self):
        heap = MinHeap()
        for val in [5, 3, 7, 1, 4]:
            heap.insert(val)
        assert heap.heap[0] == 1

    def test_extract_min(self):
        heap = MinHeap()
        for val in [5, 3, 7, 1, 4]:
            heap.insert(val)
        assert heap.extract_min() == 1
        assert heap.extract_min() == 3

    def test_extract_empty(self):
        heap = MinHeap()
        with pytest.raises(IndexError):
            heap.extract_min()

    def test_heap_property_maintained(self):
        heap = MinHeap()
        values = [10, 5, 3, 2, 7, 1, 8]
        for val in values:
            heap.insert(val)
        # Verify parent <= children for all nodes
        for i in range(len(heap.heap)):
            left = heap.left_child(i)
            right = heap.right_child(i)
            if left < len(heap.heap):
                assert heap.heap[i] <= heap.heap[left]
            if right < len(heap.heap):
                assert heap.heap[i] <= heap.heap[right]
```

### 3.2 Integration Tests

Test components working together:

```python
def test_dijkstra_finds_shortest_path():
    graph = {
        'A': {'B': 1, 'C': 4},
        'B': {'C': 2, 'D': 5},
        'C': {'D': 1},
        'D': {}
    }
    distances, previous = dijkstra(graph, 'A')
    assert distances['D'] == 4  # A -> B -> C -> D
    assert previous['D'] == 'C'
    assert previous['C'] == 'B'
    assert previous['B'] == 'A'
```

### 3.3 Performance Tests

Benchmark your implementation:

```python
import time
import random

def benchmark_sorting():
    sizes = [100, 1000, 10000, 100000]
    for n in sizes:
        data = random.sample(range(n * 10), n)
        start = time.time()
        your_sort(data.copy())
        elapsed = time.time() - start
        print(f"n={n}: {elapsed:.4f}s")
```

---

## Phase 4: Optimization (10% of time)

### 4.1 Profile First

Don't optimize without measuring:

```python
import cProfile

def profile_my_function():
    data = generate_test_data(10000)
    cProfile.run('my_algorithm(data)')
```

### 4.2 Common Optimizations

| Technique | When to Use |
|-----------|-------------|
| Memoization | Repeated subproblems |
| Lazy evaluation | Large datasets |
| In-place operations | Memory constraints |
| Batch processing | I/O operations |
| Early termination | Search with known bounds |

### 4.3 Complexity Checklist

Ensure your implementation meets target complexity:

```
□ Time complexity documented
□ Space complexity documented
□ Worst case analyzed
□ Average case analyzed
□ Best case analyzed
□ No unnecessary operations
□ No redundant data copying
□ Appropriate data structure chosen
```

---

## Phase 5: Documentation (Completion)

### 5.1 Code Documentation

```python
def dijkstra(graph: Dict[str, Dict[str, int]], 
             start: str) -> Tuple[Dict[str, int], Dict[str, str]]:
    """
    Find shortest paths from start node to all other nodes.
    
    Args:
        graph: Adjacency list representation {node: {neighbor: weight}}
        start: Starting node
        
    Returns:
        Tuple of (distances dict, previous node dict)
        
    Time Complexity: O((V + E) log V) with binary heap
    Space Complexity: O(V)
    """
```

### 5.2 Decision Log

Document why you made certain choices:

```markdown
## Design Decisions

### Why MinHeap over sorted array?
- Insert: O(log n) vs O(n)
- Extract min: O(log n) vs O(1) but O(n) to maintain
- Our use case has many inserts and extracts, so heap wins

### Why adjacency list over matrix?
- Sparse graph: O(V + E) vs O(V²)
- Memory: O(V + E) vs O(V²)
```

---

## Quick Reference Checklist

```
PLANNING
□ Problem clearly defined
□ DSA concepts identified
□ Architecture sketched
□ Edge cases listed

IMPLEMENTATION
□ Core data structure built
□ Algorithm implemented
□ Error handling added
□ Input validation included

TESTING
□ Unit tests written
□ Integration tests passing
□ Edge cases covered
□ Performance benchmarks run

OPTIMIZATION
□ Profiled bottlenecks
□ Target complexity achieved
□ Memory usage acceptable
□ No premature optimization

DOCUMENTATION
□ README complete
□ Code documented
□ Complexity analysis included
□ Design decisions recorded
```
