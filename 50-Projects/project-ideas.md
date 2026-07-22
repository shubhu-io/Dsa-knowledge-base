# Project Ideas Catalog

Detailed descriptions and implementation guides for DSA projects across all skill levels.

---

## Beginner Projects

### 1. To-Do List CLI Application
**Difficulty:** ★☆☆☆☆ | **Time:** 2-3 hours | **Concepts:** Arrays, Linked Lists

**Description:** Build a command-line to-do list that supports adding, removing, completing, and listing tasks.

**Features:**
- Add tasks with priority levels
- Remove tasks by ID or name
- Mark tasks as complete
- Filter by status (pending/completed)
- Save/load from file

**Implementation Approach:**
```python
class Task:
    def __init__(self, name, priority="medium"):
        self.name = name
        self.priority = priority
        self.completed = False
        self.created_at = datetime.now()

class TodoList:
    def __init__(self):
        self.tasks = []

    def add_task(self, name, priority="medium"):
        task = Task(name, priority)
        self.tasks.append(task)
        return task

    def remove_task(self, index):
        if 0 <= index < len(self.tasks):
            return self.tasks.pop(index)
        raise IndexError("Task not found")
```

**Extensions:** Add deadlines, categories, and search functionality.

---

### 2. Contact Book with Search
**Difficulty:** ★☆☆☆☆ | **Time:** 3-4 hours | **Concepts:** Hash Maps, Binary Search

**Description:** A contact management system with fast lookup and alphabetical sorting.

**Features:**
- Add/edit/delete contacts
- Search by name (partial matching)
- Search by phone number
- Sort contacts alphabetically
- Export to CSV

**Key Algorithm:**
```python
class ContactBook:
    def __init__(self):
        self.contacts = {}  # name -> contact info
        self.sorted_names = []

    def add_contact(self, name, phone, email):
        self.contacts[name.lower()] = {
            "name": name,
            "phone": phone,
            "email": email
        }
        self.sorted_names.append(name.lower())
        self.sorted_names.sort()

    def search(self, query):
        results = []
        for name in self.sorted_names:
            if query.lower() in name:
                results.append(self.contacts[name])
        return results
```

---

### 3. Stack-Based Calculator
**Difficulty:** ★★☆☆☆ | **Time:** 4-5 hours | **Concepts:** Stacks, Expression Parsing

**Description:** Evaluate mathematical expressions using the shunting-yard algorithm.

**Features:**
- Support +, -, *, /, ^ operators
- Handle parentheses
- Support decimal numbers
- Error handling for invalid expressions
- History of calculations

**Algorithm (Shunting-Yard):**
```
Infix: (3 + 4) * 2 / 7
Step 1: Convert to postfix: 3 4 + 2 * 7 /
Step 2: Evaluate using stack
```

---

### 4. Browser History Simulator
**Difficulty:** ★★☆☆☆ | **Time:** 3-4 hours | **Concepts:** Doubly Linked Lists

**Description:** Simulate browser back/forward navigation using a doubly linked list.

**Features:**
- Visit new URLs
- Navigate back and forward
- Display current history
- Clear history

**Structure:**
```
[prev] <-> [page] <-> [next]
null      google.com   null
```

---

### 5. Word Frequency Counter
**Difficulty:** ★☆☆☆☆ | **Time:** 2-3 hours | **Concepts:** Hash Maps, Sorting

**Description:** Count and rank word frequencies in text documents.

**Features:**
- Read from text files
- Ignore common stop words
- Sort by frequency
- Generate frequency reports
- Visualize with bar charts

---

## Intermediate Projects

### 16. Autocomplete System with Trie
**Difficulty:** ★★★☆☆ | **Time:** 6-8 hours | **Concepts:** Tries, String Matching

**Description:** Build a search autocomplete that suggests completions as the user types.

**Features:**
- Prefix-based suggestions
- Ranked by frequency
- Support for large dictionaries
- Real-time suggestions

**Trie Implementation:**
```python
class TrieNode:
    def __init__(self):
        self.children = {}
        self.is_end = False
        self.frequency = 0

class AutocompleteTrie:
    def __init__(self):
        self.root = TrieNode()

    def insert(self, word, freq=1):
        node = self.root
        for char in word:
            if char not in node.children:
                node.children[char] = TrieNode()
            node = node.children[char]
        node.is_end = True
        node.frequency += freq

    def search_prefix(self, prefix):
        node = self.root
        for char in prefix:
            if char not in node.children:
                return []
            node = node.children[char]
        return self._get_all_words(node, prefix)

    def _get_all_words(self, node, prefix):
        words = []
        if node.is_end:
            words.append((prefix, node.frequency))
        for char, child in node.children.items():
            words.extend(self._get_all_words(child, prefix + char))
        return sorted(words, key=lambda x: -x[1])
```

---

### 17. Social Network Shortest Path
**Difficulty:** ★★★☆☆ | **Time:** 8-10 hours | **Concepts:** Graphs, BFS, Adjacency Lists

**Description:** Find the shortest connection path between two users (degrees of separation).

**Features:**
- Add/remove friendships
- Find shortest path between users
- Suggest friends (friends of friends)
- Calculate network diameter
- Find communities/clusters

---

### 18. File System Navigator
**Difficulty:** ★★★☆☆ | **Time:** 6-8 hours | **Concepts:** Trees, DFS, BFS

**Description:** Navigate and search through a hierarchical file system structure.

**Features:**
- Navigate directories
- Search files by name/extension
- Calculate directory sizes
- Find duplicate files
- Display directory tree

---

### 19. Huffman File Compressor
**Difficulty:** ★★★☆☆ | **Time:** 8-10 hours | **Concepts:** Binary Trees, Priority Queues, Greedy

**Description:** Compress and decompress files using Huffman coding.

**Process:**
1. Count character frequencies
2. Build Huffman tree using min-heap
3. Generate codes from tree
4. Encode/decode data

---

### 24. Shortest Route Finder (GPS)
**Difficulty:** ★★★★☆ | **Time:** 10-12 hours | **Concepts:** Dijkstra's, Graphs, Heaps

**Description:** Find shortest paths between locations using Dijkstra's algorithm.

**Features:**
- Weighted graph representation
- Dijkstra's algorithm implementation
- A* with heuristic for optimization
- Visual map display
- Multiple route options

---

## Advanced Projects

### 31. In-Memory Database Engine
**Difficulty:** ★★★★★ | **Time:** 20-30 hours | **Concepts:** B-Trees, Disk I/O, SQL Parsing

**Description:** Build a simplified SQL database engine that stores data in B-tree indexed files.

**Features:**
- CREATE TABLE, INSERT, SELECT, UPDATE, DELETE
- B-tree indexing for fast lookups
- Transaction support (ACID basics)
- Query optimizer
- Data persistence

---

### 34. Pathfinding Visualizer
**Difficulty:** ★★★★☆ | **Time:** 15-20 hours | **Concepts:** A*, Dijkstra, BFS, DFS, Heaps

**Description:** Interactive web app visualizing different pathfinding algorithms.

**Features:**
- Grid-based maze generation
- Multiple algorithm comparison
- Step-by-step visualization
- Speed control
- Wall/weight placement

---

### 36. Real-Time News Feed
**Difficulty:** ★★★★☆ | **Time:** 15-20 hours | **Concepts:** Heaps, Caching, Graphs

**Description:** Build a social media-style news feed with ranking algorithms.

**Features:**
- Priority-based feed ranking
- Real-time updates
- User preferences
- Content deduplication
- Pagination with cursors

---

## Expert Projects

### 46. Distributed Cache System
**Difficulty:** ★★★★★ | **Time:** 30-40 hours | **Concepts:** Consistent Hashing, Replication, CAP Theorem

**Description:** Build a distributed caching system similar to Memcached/Redis.

**Features:**
- Consistent hashing for distribution
- Cache eviction policies (LRU, LFU, TTL)
- Replication and fault tolerance
- Cache coherence protocol
- Monitoring and metrics

### 47. Graph Database
**Difficulty:** ★★★★★ | **Time:** 40-50 hours | **Concepts:** Adjacency Lists, Traversal, Cypher-like Query Language

**Description:** Build a graph database supporting property graphs and traversal queries.

**Features:**
- Node and edge storage with properties
- Cypher-like query language
- Pattern matching
- Index-free adjacency
- ACID transactions

---

## Choosing Your Project

| Factor | Consideration |
|--------|---------------|
| **Skill Level** | Be honest about your current abilities |
| **Time Available** | Better to complete a simpler project than abandon a complex one |
| **Interest** | Pick something you'd actually use |
| **Portfolio Need** | Choose projects that showcase skills employers want |
| **Learning Goal** | Target specific DSA concepts you want to master |
