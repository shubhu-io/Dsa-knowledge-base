# Tree Tutorial

## Overview
A tree is a hierarchical data structure consisting of nodes connected by edges. Unlike linear data structures (arrays, linked lists, stacks, queues), trees represent hierarchical relationships between elements. Trees are fundamental in computer science with applications ranging from file systems and databases to AI and networking.

## Key Characteristics
- **Hierarchical Structure**: Organizes data in parent-child relationships
- **Root Node**: Topmost node with no parent
- **Leaf Nodes**: Nodes with no children
- **Internal Nodes**: Nodes with at least one child
- **Edges**: Connections between parent and child nodes
- **Depth/Level**: Distance from root node
- **Height**: Maximum depth of any node
- **Degree**: Number of children a node has
- **Subtree**: Tree consisting of a node and all its descendants

## Tree Structure
```
           A (root)
         /   |   \
        B    C    D
       / \      / \
      E   F    G   H
         /
        J
```
In this tree:
- A is the root node
- B, C, D are children of A
- E, F are children of B; G, H are children of C
- J is child of F
- E, F, G, H, J are leaf nodes
- Height of tree is 3 (A→B→F→J path)
- Depth of node F is 2 (A→B→F)

## Types of Trees

### 1. Binary Tree
- Each node has at most 2 children (left and right)
- Most common type of tree
- Special variants: Full, Complete, Perfect, Balanced binary trees

### 2. Binary Search Tree (BST)
- Binary tree with ordering property:
  - Left subtree < Node < Right subtree
- Enables efficient search, insertion, deletion (O(log n) average)
- Widely used in databases and symbol tables

### 3. Balanced Trees
- Maintain balance to ensure O(log n) operations
- Variants: AVL trees, Red-Black trees, Splay trees
- Critical for consistent performance

### 4. Heap
- Complete binary tree with heap property:
  - Max Heap: Parent ≥ Children
  - Min Heap: Parent ≤ Children
- Used for priority queues and heap sort

### 5. Trie (Prefix Tree)
- Tree where each node represents a character
- Used for efficient string operations and prefix matching
- Common in autocomplete systems and spell checkers

### 6. B-Tree and B+Tree
- Self-balancing tree data structures
- Optimized for disk storage systems that read/write large blocks of data
- Widely used in databases and file systems

### 7. Segment Tree
- Tree for storing intervals or segments
- Efficiently answers range queries and updates
- Used in computational geometry and data analysis

### 8. Fenwick Tree (Binary Indexed Tree)
- Tree for representing frequency tables
- Efficiently computes prefix sums and updates
- Space-efficient alternative to segment trees

## Tree Traversals

### Depth-First Search (DFS)
Visit nodes by going as deep as possible before backtracking:

#### Preorder (Root-Left-Right)
```
Visit Root → Traverse Left Subtree → Traverse Right Subtree
```
Use cases: Creating copy of tree, prefix expression evaluation

#### Inorder (Left-Root-Right)
```
Traverse Left Subtree → Visit Root → Traverse Right Subtree
```
Use cases: BST gives sorted order, infix expression evaluation

#### Postorder (Left-Right-Root)
```
Traverse Left Subtree → Traverse Right Subtree → Visit Root
```
Use cases: Deleting tree, postfix expression evaluation

### Breadth-First Search (BFS)
Visit nodes level by level:
```
Visit all nodes at depth d before nodes at depth d+1
```
Use cases: Level order traversal, shortest path in unweighted graphs

## Basic Operations and Time Complexities

### Binary Search Tree Operations
| Operation | Average Case | Worst Case | Notes |
|-----------|--------------|------------|-------|
| Search | O(log n) | O(n) | Requires BST property |
| Insert | O(1) | O(n) | Requires BST property |
| Delete | O(log n) | O(n) | Requires BST property |
| Min/Max | O(log n) | O(n) | Leftmost/rightmost node |
| Successor/Predessor | O(log n) | O(n) | Next/previous in sorted order |
| Space | O(n) | O(n) | Proportional to nodes |

### Balanced Tree Operations (AVL, Red-Black)
| Operation | Time Complexity | Notes |
|-----------|----------------|-------|
| Search | O(log n) | Guaranteed |
| Insert | O(log n) | With rotations |
| Delete | O(log n) | With rotations |
| Min/Max | O(log n) |  |
| Space | O(n) |  |

### Heap Operations
| Operation | Time Complexity | Notes |
|-----------|----------------|-------|
| Peek (Min/Max) | O(1) | Root element |
| Insert | O(log n) | Heapify up |
| Extract Min/Max | O(log n) | Replace root, heapify down |
| Increase/Decrease Key | O(log n) | With heapify up/down |
| Build Heap | O(n) | Bottom-up construction |
| Space | O(n) | Array representation |

## Detailed Implementation Examples

### Binary Search Tree in Python
```python
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

class BinarySearchTree:
    def __init__(self):
        self.root = None
    
    def insert(self, val):
        """Insert a value into the BST"""
        if self.root is None:
            self.root = TreeNode(val)
        else:
            self._insert_recursive(self.root, val)
    
    def _insert_recursive(self, node, val):
        if val < node.val:
            if node.left is None:
                node.left = TreeNode(val)
            else:
                self._insert_recursive(node.left, val)
        else:  # val >= node.val
            if node.right is None:
                node.right = TreeNode(val)
            else:
                self._insert_recursive(node.right, val)
    
    def search(self, val):
        """Search for a value in the BST"""
        return self._search_recursive(self.root, val)
    
    def _search_recursive(self, node, val):
        if node is None or node.val == val:
            return node
        if val < node.val:
            return self._search_recursive(node.left, val)
        return self._search_recursive(node.right, val)
    
    def inorder_traversal(self):
        """Return inorder traversal (sorted order for BST)"""
        result = []
        self._inorder_recursive(self.root, result)
        return result
    
    def _inorder_recursive(self, node, result):
        if node:
            self._inorder_recursive(node.left, result)
            result.append(node.val)
            self._inorder_recursive(node.right, result)
    
    def delete(self, val):
        """Delete a value from the BST"""
        self.root = self._delete_recursive(self.root, val)
    
    def _delete_recursive(self, root, val):
        if root is None:
            return root
        
        if val < root.val:
            root.left = self._delete_recursive(root.left, val)
        elif val > root.val:
            root.right = self._delete_recursive(root.right, val)
        else:
            # Node to be deleted found
            # Case 1: No child or one child
            if root.left is None:
                return root.right
            elif root.right is None:
                return root.left
            
            # Case 2: Two children
            # Get inorder successor (smallest in right subtree)
            temp = self._min_value_node(root.right)
            root.val = temp.val
            # Delete the inorder successor
            root.right = self._delete_recursive(root.right, temp.val)
        
        return root
    
    def _min_value_node(self, node):
        current = node
        while current.left is not None:
            current = current.left
        return current
    
    def height(self):
        """Calculate height of the tree"""
        return self._height_recursive(self.root)
    
    def _height_recursive(self, node):
        if node is None:
            return -1
        return 1 + max(self._height_recursive(node.left), self._height_recursive(node.right))

# Example usage
if __name__ == "__main__":
    bst = BinarySearchTree()
    values = [50, 30, 70, 20, 40, 60, 80]
    
    for val in values:
        bst.insert(val)
    
    print("Inorder traversal:", bst.inorder_traversal())
    print("Search 40:", bst.search(40) is not None)
    print("Search 25:", bst.search(25) is not None)
    print("Height:", bst.height())
    
    bst.delete(20)
    print("After deleting 20:", bst.inorder_traversal())
    
    bst.delete(30)
    print("After deleting 30:", bst.inorder_traversal())
    
    bst.delete(50)
    print("After deleting 50:", bst.inorder_traversal())
```

### AVL Tree (Self-Balancing BST) in Python
```python
class AVLNode:
    def __init__(self, val):
        self.val = val
        self.left = None
        self.right = None
        self.height = 1

class AVLTree:
    def __init__(self):
        self.root = None
    
    def insert(self, val):
        """Insert a value into the AVL tree"""
        self.root = self._insert_recursive(self.root, val)
    
    def _insert_recursive(self, root, val):
        # Step 1: Perform normal BST insertion
        if not root:
            return AVLNode(val)
        
        if val < root.val:
            root.left = self._insert_recursive(root.left, val)
        else:
            root.right = self._insert_recursive(root.right, val)
        
        # Step 2: Update height of this ancestor node
        root.height = 1 + max(self._get_height(root.left),
                              self._get_height(root.right))
        
        # Step 3: Get the balance factor
        balance = self._get_balance(root)
        
        # Step 4: If unbalanced, handle 4 cases
        # Left Left Case
        if balance > 1 and val < root.left.val:
            return self._right_rotate(root)
        
        # Right Right Case
        if balance < -1 and val > root.right.val:
            return self._left_rotate(root)
        
        # Left Right Case
        if balance > 1 and val > root.left.val:
            root.left = self._left_rotate(root.left)
            return self._right_rotate(root)
        
        # Right Left Case
        if balance < -1 and val < root.right.val:
            root.right = self._right_rotate(root.right)
            return self._left_rotate(root)
        
        return root
    
    def _left_rotate(self, z):
        y = z.right
        T2 = y.left
        
        # Perform rotation
        y.left = z
        z.right = T2
        
        # Update heights
        z.height = 1 + max(self._get_height(z.left),
                           self._get_height(z.right))
        y.height = 1 + max(self._get_height(y.left),
                           self._get_height(y.right))
        
        # Return new root
        return y
    
    def _right_rotate(self, z):
        y = z.left
        T3 = y.right
        
        # Perform rotation
        y.right = z
        z.left = T3
        
        # Update heights
        z.height = 1 + max(self._get_height(z.left),
                           self._get_height(z.right))
        y.height = 1 + max(self._get_height(y.left),
                           self._get_height(y.right))
        
        # Return new root
        return y
    
    def _get_height(self, root):
        if not root:
            return 0
        return root.height
    
    def _get_balance(self, root):
        if not root:
            return 0
        return self._get_height(root.left) - self._get_height(root.right)
    
    def inorder_traversal(self):
        """Return inorder traversal"""
        result = []
        self._inorder_recursive(self.root, result)
        return result
    
    def _inorder_recursive(self, node, result):
        if node:
            self._inorder_recursive(node.left, result)
            result.append(node.val)
            self._inorder_recursive(node.right, result)

# Example usage
if __name__ == "__main__":
    avl = AVLTree()
    values = [10, 20, 30, 40, 50, 25]
    
    for val in values:
        avl.insert(val)
    
    print("Inorder traversal:", avl.inorder_traversal())
    print("Height:", avl._get_height(avl.root))
```

### Heap (Min Heap) in Python
```python
import heapq

class MinHeap:
    def __init__(self):
        self.heap = []
    
    def push(self, item):
        """Add an item to the heap"""
        heapq.heappush(self.heap, item)
    
    def pop(self):
        """Remove and return the smallest item"""
        if self.is_empty():
            raise IndexError("pop from empty heap")
        return heapq.heappop(self.heap)
    
    def peek(self):
        """Return the smallest item without removing it"""
        if self.is_empty():
            raise IndexError("peek from empty heap")
        return self.heap[0]
    
    def is_empty(self):
        """Check if heap is empty"""
        return len(self.heap) == 0
    
    def size(self):
        """Return number of elements in heap"""
        return len(self.heap)
    
    def heapify(self, arr):
        """Convert list to heap in-place"""
        self.heap = arr[:]
        heapq.heapify(self.heap)
    
    def heap_sort(self):
        """Return sorted list using heap sort"""
        temp = self.heap[:]
        result = []
        while temp:
            result.append(heapq.heappop(temp))
        return result

# Example usage
if __name__ == "__main__":
    heap = MinHeap()
    elements = [5, 3, 8, 1, 9, 2]
    
    for elem in elements:
        heap.push(elem)
    
    print("Heap elements:", heap.heap)
    print("Minimum element:", heap.peek())
    
    sorted_elements = []
    while not heap.is_empty():
        sorted_elements.append(heap.pop())
    
    print("Sorted elements:", sorted_elements)
    
    # Using heapify
    heap2 = MinHeap()
    heap2.heapify([5, 3, 8, 1, 9, 2])
    print("Heap after heapify:", heap2.heap)
    print("Sorted via heap sort:", heap2.heap_sort())
```

## Tree Applications

### 1. File Systems
- Directory structures represented as trees
- Each directory is a node, files are leaves
- Path resolution involves tree traversal

### 2. Database Systems
- **B-Trees and B+Trees**: Used for indexing
- **Segment Trees**: Used for range queries in databases
- **XML Databases**: Tree-based storage of hierarchical data

### 3. Compiler Design
- **Abstract Syntax Trees (AST)**: Represent syntactic structure of code
- **Parse Trees**: Intermediate representation during parsing
- **Symbol Trees**: Hierarchical organization of symbols

### 4. Computer Graphics
- **Scene Graphs**: Hierarchical representation of graphical objects
- **BSP Trees**: Binary Space Partitioning for rendering
- **Quadtrees/Octrees**: Spatial partitioning for collision detection

### 5. Artificial Intelligence
- **Decision Trees**: Used in machine learning for classification
- **Game Trees**: Represent game states in AI (Minimax algorithm)
- **Trie Structures**: Used in natural language processing

### 6. Networking
- **Routing Tables**: Often implemented as trees or tries
- **Spanning Tree Protocol**: Prevents loops in network topology
- **Mesh Networks**: Tree-based topologies for efficient routing

### 7. Operating Systems
- **Process Hierarchy**: Parent-child process relationships
- **File System Hierarchy**: Directory structure as tree
- **Interrupt Hierarchy**: Priority-based interrupt handling

### 8. Mathematical Applications
- **Expression Trees**: Represent mathematical expressions
- **Union-Find Data Structures**: Forest of trees for disjoint sets
- **Huffman Coding**: Tree-based algorithm for data compression

## Tree Properties and Formulas

### For a Binary Tree with n nodes:
- **Minimum Height**: ⌊log₂(n+1)⌋ - 1
- **Maximum Height**: n-1 (skewed tree)
- **Maximum Number of Nodes at Level k**: 2ᵏ
- **Maximum Number of Nodes**: 2ʰ⁺¹ - 1 (where h is height)
- **Minimum Number of Nodes**: h+1 (skewed tree)
- **Number of LeafNodes**: Between 1 and 2ʰ
- **Number of Null Links**: n+1 (in linked representation)

### For a Full Binary Tree:
- **Number of LeafNodes**: Number of internal nodes + 1
- **Total Nodes**: 2L - 1 (where L is number of leaf nodes)

### For a Complete Binary Tree:
- **Height**: ⌊log₂n⌋
- **Leaf Nodes**: ⌈(n+1)/2⌉ to ⌊n/2⌋ + 1
- **Internal Nodes**: ⌊n/2⌋

## Traversal Techniques and Applications

### Preorder Traversal (Root-Left-Right)
**Applications**:
- Creating a copy of the tree
- Getting prefix expression from expression tree
- Prefix notation in compilers
- Tree serialization

### Inorder Traversal (Left-Root-Right)
**Applications**:
- Getting sorted order from BST
- Getting infix expression from expression tree
- Database indexing (B-trees)

### Postorder Traversal (Left-Right-Root)
**Applications**:
- Deleting the tree
- Getting postfix expression from expression tree
- Calculating directory sizes
- Reverse Polish notation evaluation

### Level Order Traversal (BFS)
**Applications**:
- Finding shortest path in unweighted graphs
- Level-wise processing of trees
- Breadth-first copying of trees
- Finding minimum depth of binary tree

## Space-Time Tradeoffs

### Compared to Arrays/Linked Lists
| Aspect | Tree | Array/Linked List |
|--------|------|-------------------|
| Search | O(log n) balanced, O(n) worst | O(n) unsorted, O(log n) sorted |
| Insertion | O(log n) balanced, O(n) worst | O(n) array, O(1) linked list |
| Deletion | O(log n) balance, O(n) worst | O(n) array, O(1) linked list |
| Min/Max | O(log n) balanced | O(n) unsorted, O(1) sorted |
| Predecessor/Successor | O(log n) balanced | O(n) |
| Space | O(n) | O(n) |
| Ordering | Maintains sorted order (BST) | Requires sorting |

### Compared to Hash Tables
| Aspect | Tree (BST) | Hash Table |
|--------|------------|------------|
| Search | O(log n) avg, O(n) worst | O(1) avg, O(n) worst |
| Insertion | O(log n) avg, O(n) worst | O(1) avg, O(n) worst |
| Deletion | O(log n) avg, O(n) worst | O(1) avg, O(n) worst |
| Min/Max | O(log n) avg | O(n) |
| Predecessor/Successor | O(log n) avg | O(n) |
| Range Queries | O(k + log n) | O(n) |
| Space | O(n) | O(n) |
| Ordering | Maintains sorted order | No ordering guarantee |

## Common Pitfalls and How to Avoid Them

### 1. Forgetting to Handle Empty Trees
**Problem**: Operations fail when tree is empty
**Solution**: Always check if root is None before operations
- Test with empty tree as edge case
- Return appropriate values or raise exceptions

### 2. Incorrect Recursion Base Cases
**Problem**: Infinite recursion or missing base cases
**Solution**:
- Clearly define base case (usually node is None)
- Ensure recursive calls progress toward base case
- Test with small trees (0, 1, 2 nodes)

### 3. Not Maintaining Tree Properties
**Problem**: Violating BST, heap, or balance properties
**Solution**:
- Verify invariants after each operation
- Use assertions during development
- Test with known good/bad cases

### 4. Memory Leaks (Manual Memory Management)
**Problem**: Not freeing memory when removing nodes
**Solution**:
- Always deallocate/free memory when removing nodes
- In garbage-collected languages, ensure references are removed
- Use memory profilers to detect leaks

### 5. Stack Overflow in Recursive Operations
**Problem**: Recursion depth too large for skewed trees
**Solution**:
- Use iterative implementations for skewed trees
- Increase recursion limit if necessary (system-dependent)
- Convert recursion to explicit stack when needed

### 6. Incorrect Balance Factor Calculations
**Problem**: Mistakes in AVL/Red-Black tree rotations
**Solution**:
- Draw diagrams to visualize rotations
- Test with known sequences that trigger rotations
- Verify balance factors after each operation

### 7. Off-by-One Errors in Indexing
**Problem**: Mistakes in array-based tree implementations
**Solution**:
- Clearly define indexing scheme (0-based or 1-based)
- Test with small, Known examples
- Use assertions to validate index bounds

### 8. Not Handling Duplicate Values
**Problem**: Ambiguity in how duplicates are handled
**Solution**:
- Clearly define policy (left subtree, right subtree, or count)
- Be consistent throughout implementation
- Document the choice clearly

## Performance Characteristics

### Time Complexity Summary
| Operation | BST (Avg) | BST (Worst) | Balanced Tree | Heap |
|-----------|-----------|-------------|---------------|------|
| Search | O(log n) | O(n) | O(log n) | O(n) |
| Insert | O(log n) | O(n) | O(log n) | O(log n) |
| Delete | O(log n) | O(n) | O(log n) | O(log n) |
| Min/Max | O(log n) | O(n) | O(log n) | O(1) |
| Predecessor/Successor | O(log n) | O(n) | O(log n) | O(n) |

### Space Complexity
- **All Tree Variants**: O(n) for n nodes
- **Auxiliary Space for Operations**: 
  - Recursive: O(h) where h is height (O(log n) balanced, O(n) worst)
  - Iterative with explicit stack: O(h)
  - Level order traversal: O(w) where w is maximum width

### Height Bounds
- **Minimum Height**: ⌊log₂(n+1)⌋ - 1
- **Maximum Height**: n-1 (completely skewed tree)
- **Balanced Trees**: O(log n) guaranteed
- **Heap**: ⌊log₂n⌋ for complete binary tree

## Real-World Examples

### 1. File System Directory Structure
- Root directory = tree root
- Subdirectories = internal nodes
- Files = leaf nodes
- Path resolution = tree traversal from root

### 2. Document Object Model (DOM)
- HTML/XML documents represented as trees
- Elements = nodes
- Text content = leaf nodes or node values
- CSS selector matching = tree traversal with filtering

### 3. Abstract Syntax Trees (AST)
- Source code parsed into tree structure
- Each construct = node
- Expressions and statements = subtrees
- Used in compilers and interpreters for analysis and code generation

### 4. Decision Trees in Machine Learning
- Internal nodes = feature tests
- Branches = test outcomes
- Leaf nodes = class labels or values
- Used for classification and regression

### 5. Game Trees in AI
- Nodes = game states
- Edges = moves
- Root = current state
- Used in minimax algorithm for game playing
- Often combined with alpha-beta pruning

### 6. XML/JSON Document Storage
- Hierarchical data naturally fits tree model
- Elements/nodes = tree nodes
- Attributes = node properties
- Text content = node values
- Querying = tree traversal with filtering

### 7. Routing Algorithms in Networking
- Network topology represented as graph
- Shortest path trees computed from source
- Used in OSPF and other routing protocols
- Multicast routing uses spanning trees

### 8. Memory Management
- Heap allocation often uses tree-based free lists
- Buddy memory allocator uses binary trees
- Garbage collectors use object graphs (generalized trees)

## Interview Tips

### What Interviewers Look For
1. **Understanding of Tree Properties**: Correctly applying tree characteristics
2. **Implementation Skills**: Ability to implement trees using pointers/references
3. **Traversal Proficiency**: Mastery of all three DFS and BFS traversals
4. **Problem Mapping**: Recognizing when a problem requires tree-based solution
5. **Edge Case Handling**: Empty tree, single node, skewed trees, balanced trees
6. **Algorithm Knowledge**: Knowing classic tree algorithms (invert BST, validate BST, etc.)
7. **Time/Space Complexity Awareness**: Optimizing for efficiency
8. **Clean Code**: Readable, well-commented implementations

### Common Interview Questions
1. Maximum depth of binary tree
2. Validate Binary Search Tree
3. Convert Sorted Array to Binary Search Tree
4. Binary Tree Level Order Traversal
5. Invert Binary Tree
6. Diameter of Binary Tree
7. Balanced Binary Tree
8. Path Sum
9. Construct Binary Tree from Preorder and Inorder Traversal
10. Lowest Common Ancestor (LCA) of a Binary Tree

### Follow-up Questions to Expect
- How would you check if a binary tree is a valid BST?
- What's the difference between complete and full binary trees?
- How would you find the kth smallest element in a BST?
- How would you serialize and deserialize a binary tree?
- What are the differences between AVL and Red-Black trees?
- How would you find the lowest common ancestor in a BST?
- How would you flatten a binary tree to a linked list?
- What is the time complexity of searching in a balanced vs unbalanced BST?
- How would you find all nodes at distance k from a given node?
- How would you implement an iterator over a BST?

### Best Practices for Interview Answers
1. **Clarify Requirements**: Ask about tree type, constraints, operations needed
2. **Discuss Trade-offs**: Mention time/space complexity and implementation choices
3. **Consider Edge Cases**: Empty tree, single node, skewed trees, duplicate values
4. **Talk Through Approach**: Explain algorithm before coding, justify choices
5. **Write Clean Code**: Meaningful variable names, proper formatting, comments
6. **Test Solution**: Walk through examples to catch logical errors
7. **Mention Alternatives**: Discuss other approaches and justify your choice
8. **Address Memory Management**: In relevant languages, discuss allocation/deallocation
9. **Consider Extensions**: How would solution change for balanced vs unbalanced?
10. **Think About Real-World Applications**: Relate to practical use cases

## Summary
Trees are fundamental data structures that represent hierarchical relationships between elements. Their power lies in efficiently representing and manipulating hierarchical data, enabling solutions to complex problems across numerous domains.

Whether implemented as binary trees, binary search trees, balanced trees, heaps, or specialized variants like tries and B-trees, trees provide efficient mechanisms for storage, retrieval, and manipulation of data with specific structural properties.

The key to mastering trees is understanding the trade-offs between different tree types and recognizing when a problem's structure naturally maps to a tree representation. Common patterns to recognize include:
- Hierarchical data (file systems, organization charts)
- Ordered data requiring efficient search (BSTs, balanced trees)
- Priority-based processing (heaps)
- Spatial data (quadtrees, octrees, k-d trees)
- String processing (tries, suffix trees)
- Game state representation (game trees)
- Expression parsing and evaluation (expression trees)
- Network routing (spanning trees, shortest path trees)
- Memory management (buddy allocator, garbage collection)

By understanding these patterns and practicing tree-based problems, you'll develop the intuition needed to apply trees effectively in both interview situations and real-world software development. Whether you're preparing for technical interviews, working on software projects, or studying computer science theory, a solid understanding of trees will serve you well across numerous applications and technologies.