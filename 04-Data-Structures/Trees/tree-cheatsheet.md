# Tree Cheat Sheet

## Core Concepts

### What is a Tree?
A tree is a hierarchical data structure consisting of nodes connected by edges. It represents hierarchical relationships between elements with a single root node and zero or more subtrees.

### Key Characteristics
- **Hierarchical Structure**: Parent-child relationships between nodes
- **Root Node**: Topmost node with no parent
- **Leaf Nodes**: Nodes with no children
- **Internal Nodes**: Nodes with at least one child
- **Edges**: Connections between parent and child nodes
- **No Cycles**: Exactly one path between any two nodes
- **Recursive Structure**: Each subtree is itself a tree

### Tree Terminology
- **Node**: Fundamental unit containing data and links to children
- **Edge**: Connection between parent and child nodes
- **Root**: Top node in the tree
- **Parent**: Node that has one or more child nodes
- **Child**: Node directly connected to another node when moving away from root
- **Leaf**: Node with no children
- **Sibling**: Nodes with the same parent
- **Ancestor**: Any node on the path from root to given node (including root)
- **Descendant**: Any node that can be reached by repeatedly moving from parent to child
- **Depth**: Number of edges from root to node
- **Height**: Number of edges on longest path from node to leaf-to-leaf path through node
- **Level**: Set of all nodes at given depth
- **Degree**: Number of children a node has
- **Subtree**: Tree consisting of a node and all its descendants
- **Forest**: Collection of disjoint trees

## Types of Trees

### 1. Binary Tree
- Each node has at most 2 children (left and right)
- Most fundamental tree structure
- Special properties enable efficient algorithms

### 2. Binary Search Tree (BST)
- Binary tree with ordering property:
  - Left subtree < Node value < Right subtree
- Enables efficient search, insertion, deletion (O(log n) average)
- Duplicate handling: usually left subtree ≤ node < right subtree

### 3. Balanced Trees
- Maintain balance to guarantee O(log n) operations
- **AVL Tree**: Height-balanced (|height_left - height_right| ≤ 1)
- **Red-Black Tree**: Approximately balanced with color properties
- **Splay Tree**: Self-adjusting with recent accesses moved to root

### 4. Heap
- Complete binary tree with heap property:
  - Max Heap: Parent.value ≥ Children.value
  - Min Heap: Parent.value ≤ Children.value
- Used for priority queues and heap sort
- Array-based implementation common

### 5. Trie (Prefix Tree)
- Tree where each node represents a character
- Path from root to node represents a string
- Used for efficient prefix matching and string operations
- Common in autocomplete systems and spell checkers

### 6. B-Tree and B+Tree
- Self-balancing tree data structures optimized for disk storage
- Nodes can have many children (reduces tree height)
- All leaves at same level
- Widely used in databases and file systems
- B+Tree: All data in leaves, internal nodes only for routing

### 7. Segment Tree
- Tree for storing intervals or segments
- Efficiently answers range queries and updates
- Each node represents an interval
- Used in computational geometry and data analysis

### 8. Fenwick Tree (Binary Indexed Tree)
- Space-efficient tree for representing frequency tables
- Efficiently computes prefix sums and updates
- Alternative to segment tree for prefix sum problems
- Uses bitwise operations for parent/child relationships

### 9. Cartesian Tree
- Binary tree derived from a sequence of numbers
- Heap-ordered with respect to node values
- Inorder traversal gives original sequence
- Used in RMQ (Range Minimum Query) problems

### 10. Treap
- Randomized binary search tree
- Combines BST and heap properties
- Each node has key (BST) and priority (heap)
- Expected O(log n) operations

## Tree Traversals

### Depth-First Search (DFS)
Visit nodes by going as deep as possible before backtracking:

#### Preorder (Root-Left-Right)
```
Visit Root → Traverse Left Subtree → Traverse Right Subtree
```
Applications: Tree copying, prefix expression, decision trees
Iterative: Use stack, push right then left

#### Inorder (Left-Root-Right)
```
Traverse Left Subtree → Visit Root → Traverse Right Subtree
```
Applications: BST gives sorted order, infix expression
Iterative: Use stack, go left as far as possible

#### Postorder (Left-Right-Root)
```
Traverse Left Subtree → Traverse Right Subtree → Visit Root
```
Applications: Tree deletion, postfix expression, directory sizes
Iterative: Use two stacks or one stack with last visited tracking

### Breadth-First Search (BFS)
Visit nodes level by level:
```
Visit all nodes at depth d before nodes at depth d+1
```
Applications: Level order traversal, shortest path in unweighted graphs
Implementation: Use queue

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

### Trie Operations
| Operation | Time Complexity | Notes |
|-----------|----------------|-------|
| Insert | O(L) | L = length of key |
| Search | O(L) | L = length of key |
| Delete | O(L) | L = length of key |
| Prefix Search | O(P + K) | P = prefix length, K = # keys with prefix |
| Space | O(N*L) | N = # keys, L = avg key length |

## Implementation Techniques

### Pointer-Based Representation
```python
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right
```

### Array-Based Representation (for Complete Binary Trees)
- Root at index 0
- Left child of i: 2*i + 1
- Right child of i: 2*i + 2
- Parent of i: floor((i-1)/2)
- Used for heaps

### Recursive Patterns
```python
# DFS traversal pattern
def dfs(node):
    if not node:
        return base_case
    
    # Process node (preorder)
    result = process(node)
    
    # Recurse on children
    left_result = dfs(node.left)
    right_result = dfs(node.right)
    
    # Combine results (postorder)
    return combine(result, left_result, right_result)
```

### Iterative Patterns
```python
# Preorder iterative
def preorder_iterative(root):
    if not root:
        return []
    
    stack = [root]
    result = []
    
    while stack:
        node = stack.pop()
        result.append(node.val)
        
        # Push right first so left is processed first
        if node.right:
            stack.append(node.right)
        if node.left:
            stack.append(node.left)
    
    return result

# Level order (BFS) iterative
def level_order_iterative(root):
    if not root:
        return []
    
    from collections import deque
    queue = deque([root])
    result = []
    
    while queue:
        level_size = len(queue)
        current_level = []
        
        for _ in range(level_size):
            node = queue.popleft()
            current_level.append(node.val)
            
            if node.left:
                queue.append(node.left)
            if node.right:
                queue.append(node.right)
        
        result.append(current_level)
    
    return result
```

## Common Algorithms and Patterns

### 1. Tree Diameter
**Longest path between any two nodes**
- Use DFS to compute height of each node
- Diameter through node = left_height + right_height
- Track maximum diameter encountered
- Time: O(n), Space: O(h)

### 2. Lowest Common Ancestor (LCA)
**Deepest node that has both p and q as descendants**
- Recursive approach:
  - If node is p or q, return node
  - Recurse left and right
  - If both return non-null, current node is LCA
  - Otherwise return non-null child
- Time: O(n), Space: O(h)

### 3. Tree Serialization/Deserialization
**Convert tree to/from string representation**
- Preorder with null markers: "1,2,None,None,3,4,None,None,5,None,None"
- Level order with null markers
- Time: O(n), Space: O(n)

### 4. Path Sum Problems
**Finding paths with specific sum**
- Root-to-leaf: DFS subtracting node values
- Any downward path: Prefix sum + hashmap technique
- All paths: Consider each node as root of downward path

### 5. Tree Flattening
**Convert to linked list using right pointers**
- Preorder flattening: root → left subtree → right subtree
- Postorder flattening: left subtree → right subtree → root
- Time: O(n), Space: O(h)

### 6. Tree Pruning
**Removing subtrees based on condition**
- Post-order traversal
- Return boolean indicating if subtree should be kept
- Set child pointers to None if subtree should be removed
- Time: O(n), Space: O(h)

### 7. Tree Comparison
**Checking if two trees are identical/equivalent**
- Structural comparison: same shape and values
- Flip equivalence: allow swapping left/right children
- Time: O(n), Space: O(h)

## Specialized Tree Variants

### AVL Tree Rotations
**Maintain balance factor of -1, 0, or 1**

#### Left-Left Case
```
    z                                      y
   / \     Right Rotate(z)             /   \
  y   T4   – – – – – – – –>          T1    z
 / \                                   / \  
T1  T2     Left Rotate(y)            T2  T3  T4
   \                                 
    T3
```

#### Right-Right Case
```
  z                                 y
 / \     Left Rotate(z)          /   \
T1  y   – – – – – – – –>       z    T3
    / \     – – – – – – –>    / \  
   T2  T3                     T1  T2
```

#### Left-Right Case
```
   z                                z                                x
  / \     Left Rotate(y)          / \     Right Rotate(z)        /   \
 y   T3   – – – – – – – –>     T1   z   – – – – – – – –>    y     z
/ \                                  / \                          / \  
T1  y                              T2  x                        T1  T2 T3  T4
   \                                / \                            
    x                              T3  T4
```

#### Right-Left Case
```
  z                                 z                                 x
 / \     Right Rotate(y)          / \     Left Rotate(z)          /   \
T1  y   – – – – – – – –>       z   T3   – – – – – – – –>    x     z
    / \                                  / \   \                    / \  
   x  T4                                T1  T2  T3                  T1  T2 y  T3
   / \                                                                   
  T2  T3
```

### Red-Black Tree Properties
1. Every node is either red or black
2. Root is black
3. All leaves (NIL) are black
4. If a node is red, then both its children are black
5. Every path from a node to its descendant leaves contains the same number of black nodes

### Heap Operations Detailed
**Min Heap:**
```
         1
       /   \
      3     6
     / \   / \
    5   9 8  10
```

**Insert 2:**
1. Add at end: [1,3,6,5,9,8,10,2]
2. Heapify up: compare with parent (10), swap → [1,3,6,5,9,8,2,10]
3. Continue: compare with parent (6), swap → [1,3,2,5,9,8,6,10]
4. Continue: compare with parent (3), swap → [1,2,3,5,9,8,6,10]
5. Continue: compare with parent (1), stop → [1,2,3,5,9,8,6,10]

**Extract Min:**
1. Remove root (1)
2. Move last element to root: [10,2,3,5,9,8,6]
3. Heapify down: compare with children (2,3), swap with smaller (2) → [2,10,3,5,9,8,6]
4. Continue: compare with children (5,9), swap with smaller (5) → [2,5,3,10,9,8,6]
5. Continue: compare with child (8), no swap needed → [2,5,3,10,9,8,6]

## Tree Properties and Formulas

### For a Binary Tree with n nodes:
- **Minimum Height**: ⌊log₂(n+1)⌋ - 1
- **Maximum Height**: n-1 (skewed tree)
- **Maximum Number of Nodes at Level k**: 2ᵏ
- **Maximum Number of Nodes**: 2ʰ⁺¹ - 1 (where h is height)
- **Minimum Number of Nodes**: h+1 (skewed tree)
- **Number of Leaf Nodes**: Between 1 and 2ʰ
- **Number of Null Links**: n+1 (in linked representation)

### For a Full Binary Tree:
- **Number of Leaf Nodes**: Number of internal nodes + 1
- **Total Nodes**: 2L - 1 (where L is number of leaf nodes)

### For a Complete Binary Tree:
- **Height**: ⌊log₂n⌋
- **Leaf Nodes**: ⌈(n+1)/2⌉ to ⌊n/2⌋ + 1
- **Internal Nodes**: ⌊n/2⌋
- **Array Representation**: No wasted space

### For a Perfect Binary Tree:
- **All internal nodes have exactly 2 children**
- **All leaves at same level**
- **Total Nodes**: 2ʰ⁺¹ - 1
- **Leaf Nodes**: 2ʰ
- **Internal Nodes**: 2ʰ - 1

## Space-Time Tradeoffs

### Compared to Arrays/Linked Lists
| Aspect | Tree | Array/Linked List |
|--------|------|-------------------|
| Search | O(log n) balanced, O(n) worst | O(n) unsorted, O(log n) sorted |
| Insertion | O(log n) balanced, O(n) worst | O(n) array, O(1) linked list |
| Deletion | O(log n) balanced, O(n) worst | O(n) array, O(1) linked list |
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

### Traversal Space Complexity
| Traversal | Recursive Space | Iterative Space |
|-----------|-----------------|-----------------|
| Preorder | O(h) | O(h) |
| Inorder | O(h) | O(h) |
| Postorder | O(h) | O(h) |
| Level Order | O(1) | O(w) |

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
- Test with small, known examples
- Use assertions to validate index bounds

### 8. Not Handling Duplicate Values
**Problem**: Ambiguity in how duplicates are handled
**Solution**:
- Clearly define policy (left subtree, right subtree, or count)
- Be consistent throughout implementation
- Document the choice clearly

### 9. Incorrect Tree Construction
**Problem**: Mistakes in building trees from traversals
**Solution**:
- Verify traversal properties (preorder: root first, inorder: left-root-right)
- Use hashmap for O(1) lookups in inorder/postorder constructions
- Test with known examples

### 10. Misunderstanding Tree Height vs Depth
**Problem**: Confusing height (edges to leaf) with depth (edges from root)
**Solution**:
- Height of leaf = 0
- Depth of root = 0
- Height of tree = height of root
- Draw diagrams to visualize

## Performance Characteristics

### Time Complexity Summary
| Operation | BST (Avg) | BST (Worst) | Balanced Tree | Heap | Trie |
|-----------|-----------|-------------|---------------|------|------|
| Search | O(log n) | O(n) | O(log n) | O(n) | O(L) |
| Insert | O(log n) | O(n) | O(log n) | O(log n) | O(L) |
| Delete | O(log n) | O(n) | O(log n) | O(log n) | O(L) |
| Min/Max | O(log n) | O(n) | O(log n) | O(1) | O(L) |
| Predecessor/Successor | O(log n) | O(n) | O(log n) | O(n) | O(L) |
| Prefix Search | O(n) | O(n) | O(n) | O(n) | O(P+K) |

### Space Complexity
- **All Tree Variants**: O(n) for n nodes
- **Auxiliary Space for Operations**: 
  - Recursive: O(h) where h is height (O(log n) balanced, O(n) worst)
  - Iterative with explicit stack: O(h)
  - Level order traversal: O(w) where w is maximum width
  - Trie: O(N*L) where N = number of keys, L = average key length

### Height Bounds for n nodes
- **Minimum Height**: ⌊log₂(n+1)⌋ - 1
- **Maximum Height**: n-1 (completely skewed tree)
- **Balanced Trees**: O(log n) guaranteed
- **Heap**: ⌊log₂n⌋ for complete binary tree
- **Trie**: O(L) where L = length of longest key

## Real-World Examples

### 1. File System Directory Structure
- Root directory = tree root
- Subdirectories = internal nodes
- Files = leaf nodes
- Path resolution = tree traversal from root
- Commands like `ls`, `find`, `du` use tree traversals

### 2. Document Object Model (DOM)
- HTML/XML documents represented as trees
- Elements = nodes
- Text content = leaf nodes or node values
- CSS selector matching = tree traversal with filtering
- JavaScript DOM manipulation = tree modification

### 3. Abstract Syntax Trees (AST)
- Source code parsed into tree structure
- Each construct = node
- Expressions and statements = subtrees
- Used in compilers and interpreters for analysis and code generation
- Optimization passes = tree transformations

### 4. Decision Trees in Machine Learning
- Internal nodes = feature tests
- Branches = test outcomes
- Leaf nodes = class labels or values
- Used for classification and regression
- Training = building optimal tree from data
- Prediction = traversing tree based on feature values

### 5. Game Trees in AI
- Nodes = game states
- Edges = moves
- Root = current state
- Used in minimax algorithm for game playing
- Often combined with alpha-beta pruning
- Examples: Chess, Go, Tic-tac-toe AI

### 6. XML/JSON Document Storage
- Hierarchical data naturally fits tree model
- Elements/nodes = tree nodes
- Attributes = node properties
- Text content = node values
- Querying = tree traversal with filtering (XPath, JSONPath)
- Databases: MongoDB (BSON), BaseX (XML)

### 7. Routing Algorithms in Networking
- Network topology represented as graph
- Shortest path trees computed from source
- Used in OSPF and other routing protocols
- Multicast routing uses spanning trees
- Internet routing uses hierarchical tree structures

### 8. Memory Management
- Heap allocation often uses tree-based free lists
- Buddy memory allocator uses binary trees
- Garbage collectors use object graphs (generalized trees)
- Memory pooling uses tree structures for efficient allocation

### 9. Database Indexing
- **B-Trees/B+Trees**: Primary indexing mechanism in most databases
- **Clustered Indexes**: Data stored in B+Tree order
- **Non-clustered Indexes**: Separate B+Tree pointing to data
- **Bitmap Indexes**: Specialized for low-cardinality columns
- **Hash Indexes**: Used for equality lookups

### 10. Compiler Design
- **Parse Trees**: Intermediate representation during parsing
- **Syntax Trees**: Abstract representation of syntactic structure
- **Symbol Tables**: Often implemented as trees or tries
- **Control Flow Graphs**: Directed graphs, often analyzed using tree algorithms
- **Data Flow Analysis**: Uses tree-based representations of program flow

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
11. Binary Tree Right Side View
12. Binary Tree Zigzag Level Order Traversal
13. Populating Next Right Pointers in Each Node
14. Sum Root to Leaf Numbers
15. Binary Tree Longest Consecutive Sequence
16. Binary Tree Cameras
17. Binary Tree Vertical Order Traversal
18. Binary Tree Upside Down
19. Recover Binary Search Tree
20. Kth Smallest Element in a BST

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
- How would you check if two trees are identical?
- How would you check if two trees are mirror images?
- How would you find the maximum width of a binary tree?
- How would you find the sum of all left leaves in a binary tree?
- How would you find the minimum depth of a binary tree?

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

### Quick Reference Formulas
- **Height of perfect binary tree with n nodes**: ⌊log₂(n+1)⌋
- **Number of nodes in perfect binary tree of height h**: 2ʰ⁺¹ - 1
- **Number of leaf nodes in perfect binary tree of height h**: 2ʰ
- **Minimum nodes in AVL tree of height h**: F(h+3) - 1 (where F is Fibonacci sequence)
- **Maximum nodes in AVL tree of height h**: 2ʰ⁺¹ - 1
- **Left child index in array representation**: 2*i + 1
- **Right child index in array representation**: 2*i + 2
- **Parent index in array representation**: floor((i-1)/2)