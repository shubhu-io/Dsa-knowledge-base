# Tree Problems

This file contains a collection of practice problems organized by difficulty level, focusing on tree data structures and their applications.

## Easy Problems

### 1. Maximum Depth of Binary Tree
**Description**: Given the root of a binary tree, return its maximum depth. A binary tree's maximum depth is the number of nodes along the longest path from the root node down to the farthest leaf node.

**Examples**:
```
Input: root = [3,9,20,null,null,15,7]
Output: 3
Explanation: The longest path is [3,20,15] or [3,20,7]

Input: root = [1,null,2]
Output: 2

Input: root = []
Output: 0
```

**Solution Approach**:
- Use recursion: depth = 1 + max(left_depth, right_depth)
- Base case: if node is None, return 0
- Time Complexity: O(n) where n is number of nodes
- Space Complexity: O(h) where h is height of tree (recursion stack)

**Code Implementation**:
```python
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

def maxDepth(root):
    if not root:
        return 0
    return 1 + max(maxDepth(root.left), maxDepth(root.right))

# Iterative solution using BFS
from collections import deque

def maxDepthIterative(root):
    if not root:
        return 0
    
    queue = deque([root])
    depth = 0
    
    while queue:
        depth += 1
        for _ in range(len(queue)):
            node = queue.popleft()
            if node.left:
                queue.append(node.left)
            if node.right:
                queue.append(node.right)
    
    return depth
```

### 2. Validate Binary Search Tree
**Description**: Given the root of a binary tree, determine if it is a valid binary search tree (BST).

**Examples**:
```
Input: root = [2,1,3]
Output: true

Input: root = [5,1,4,null,null,3,6]
Output: false
Explanation: The root node's value is 5 but its right child's value is 4.
```

**Solution Approach**:
- Use recursion with valid range for each node
- For each node, check if its value is within valid range (min, max)
- Initially, range is (-inf, +inf)
- For left child: update max to node.val
- For right child: update min to node.val
- Time Complexity: O(n)
- Space Complexity: O(h)

**Code Implementation**:
```python
def isValidBST(root):
    def validate(node, low=-float('inf'), high=float('inf')):
        if not node:
            return True
        if not (low < node.val < high):
            return False
        return (validate(node.left, low, node.val) and
                validate(node.right, node.val, high))
    
    return validate(root)

# Iterative solution using inorder traversal
def isValidBSTIterative(root):
    stack = []
    prev = -float('inf')
    
    while stack or root:
        while root:
            stack.append(root)
            root = root.left
        
        root = stack.pop()
        if root.val <= prev:
            return False
        prev = root.val
        root = root.right
    
    return True
```

### 3. Convert Sorted Array to Binary Search Tree
**Description**: Given an integer array nums where the elements are sorted in ascending order, convert it to a height-balanced binary search tree.

**Examples**:
```
Input: nums = [-10,-3,0,5,9]
Output: [0,-3,9,-10,null,5]
Explanation: [0,-10,5,null,-3,null,9] is also accepted

Input: nums = [1,3]
Output: [3,1]
Explanation: [1,null,3] and [3,1] are both height-balanced BSTs.
```

**Solution Approach**:
- Use the middle element as root to ensure height balance
- Recursively build left subtree from left half
- Recursively build right subtree from right half
- Time Complexity: O(n)
- Space Complexity: O(log n) for recursion stack

**Code Implementation**:
```python
def sortedArrayToBST(nums):
    if not nums:
        return None
    
    mid = len(nums) // 2
    root = TreeNode(nums[mid])
    root.left = sortedArrayToBST(nums[:mid])
    root.right = sortedArrayToBST(nums[mid+1:])
    
    return root

# Iterative approach using stack
def sortedArrayToBSTIterative(nums):
    if not nums:
        return None
    
    root = TreeNode(0)  # Dummy root
    stack = [(root, 0, len(nums)-1)]  # (node, left, right)
    
    while stack:
        node, left, right = stack.pop()
        mid = (left + right) // 2
        node.val = nums[mid]
        
        # Left child
        if left <= mid - 1:
            node.left = TreeNode(0)
            stack.append((node.left, left, mid-1))
        
        # Right child
        if mid + 1 <= right:
            node.right = TreeNode(0)
            stack.append((node.right, mid+1, right))
    
    return root
```

### 4. Binary Tree Level Order Traversal
**Description**: Given the root of a binary tree, return the level order traversal of its nodes' values. (i.e., from left to right, level by level).

**Examples**:
```
Input: root = [3,9,20,null,null,15,7]
Output: [[3],[9,20],[15,7]]

Input: root = [1]
Output: [[1]]

Input: root = []
Output: []
```

**Solution Approach**:
- Use Breadth-First Search (BFS) with queue
- Process nodes level by level
- For each level, record all node values
- Time Complexity: O(n)
- Space Complexity: O(w) where w is maximum width of tree

**Code Implementation**:
```python
from collections import deque

def levelOrder(root):
    if not root:
        return []
    
    result = []
    queue = deque([root])
    
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

# Alternative using two queues
def levelOrderTwoQueues(root):
    if not root:
        return []
    
    result = []
    current_queue = deque([root])
    
    while current_queue:
        level_values = []
        next_queue = deque()
        
        while current_queue:
            node = current_queue.popleft()
            level_values.append(node.val)
            
            if node.left:
                next_queue.append(node.left)
            if node.right:
                next_queue.append(node.right)
        
        result.append(level_values)
        current_queue = next_queue
    
    return result
```

### 5. Symmetric Tree
**Description**: Given the root of a binary tree, check whether it is a mirror of itself (i.e., symmetric around its center).

**Examples**:
```
Input: root = [1,2,2,3,4,4,3]
Output: true

Input: root = [1,2,2,null,3,null,3]
Output: false
```

**Solution Approach**:
- Use recursion to compare left and right subtrees
- Two trees are mirrors if:
  - Their root values are equal
  - Left subtree of first is mirror of right subtree of second
  - Right subtree of first is mirror of left subtree of second
- Base case: both nodes are None → True
- Time Complexity: O(n)
- Space Complexity: O(h)

**Code Implementation**:
```python
def isSymmetric(root):
    def isMirror(t1, t2):
        if not t1 and not t2:
            return True
        if not t1 or not t2:
            return False
        return (t1.val == t2.val and
                isMirror(t1.left, t2.right) and
                isMirror(t1.right, t2.left))
    
    return isMirror(root, root)

# Iterative solution using queue
def isSymmetricIterative(root):
    if not root:
        return True
    
    queue = deque([(root.left, root.right)])
    
    while queue:
        t1, t2 = queue.popleft()
        
        if not t1 and not t2:
            continue
        if not t1 or not t2:
            return False
        if t1.val != t2.val:
            return False
        
        queue.append((t1.left, t2.right))
        queue.append((t1.right, t2.left))
    
    return True
```

### 6. Path Sum
**Description**: Given the root of a binary tree and an integer targetSum, return true if the tree has a root-to-leaf path such that adding up all the values along the path equals targetSum.

**Examples**:
```
Input: root = [5,4,8,11,null,13,4,7,2,null,null,null,1], targetSum = 22
Output: true
Output: true
Explanation: The path 5-> Explanation: The path 5->4->11->2 sums to 22.

Input: root = [1,2,3], targetSum = 5
Output: false

Input: root = [], targetSum = 0
Output: false
```

**Solution Approach**:
- Use recursion to traverse from root to leaf
- At each node, subtract node value from targetSum
- When reaching leaf node, check if remaining sum is 0
- Time Complexity: O(n)
- Space Complexity: O(h)

**Code Implementation**:
```python
def hasPathSum(root, targetSum):
    if not root:
        return False
    
    # If leaf node, check if it equals remaining sum
    if not root.left and not root.right:
        return root.val == targetSum
    
    # Recursively check left and right subtrees
    return (hasPathSum(root.left, targetSum - root.val) or
            hasPathSum(root.right, targetSum - root.val))

# Iterative solution using stack
def hasPathSumIterative(root, targetSum):
    if not root:
        return False
    
    stack = [(root, targetSum - root.val)]
    
    while stack:
        node, current_sum = stack.pop()
        
        # If leaf node and sum equals 0, return True
        if not node.left and not node.right and current_sum == 0:
            return True
        
        # Push right child
        if node.right:
            stack.append((node.right, current_sum - node.right.val))
        
        # Push left child
        if node.left:
            stack.append((node.left, current_sum - node.left.val))
    
    return False
```

### 7. Binary Tree Inorder Traversal
**Description**: Given the root of a binary tree, return the inorder traversal of its nodes' values.

**Examples**:
```
Input: root = [1,null,2,3]
Output: [1,3,2]

Input: root = []
Output: []

Input: root = [1]
Output: [1]
```

**Solution Approach**:
- Use recursion: left -> root -> right
- Alternatively, use iterative approach with stack
- Time Complexity: O(n)
- Space Complexity: O(h)

**Code Implementation**:
```python
def inorderTraversal(root):
    result = []
    
    def inorder(node):
        if not node:
            return
        inorder(node.left)
        result.append(node.val)
        inorder(node.right)
    
    inorder(root)
    return result

# Iterative solution
def inorderTraversalIterative(root):
    result = []
    stack = []
    current = root
    
    while current or stack:
        # Reach the leftmost node
        while current:
            stack.append(current)
            current = current.left
        
        # Current must be None at this point
        current = stack.pop()
        result.append(current.val)
        
        # Visit right subtree
        current = current.right
    
    return result
```

### 8. Same Tree
**Description**: Given the roots of two binary trees p and q, write a function to check if they are the same or not.

**Examples**:
```
Input: p = [1,2,3], q = [1,2,3]
Output: true

Input: p = [1,2], q = [1,null,2]
Output: false

Input: p = [1,2,1], q = [1,1,2]
Output: false
```

**Solution Approach**:
- Use recursion to compare corresponding nodes
- Two trees are same if:
  - Both roots are None → True
  - One root is None → False
  - Root values are equal AND left subtrees are same AND right subtrees are same
- Time Complexity: O(n)
- Space Complexity: O(h)

**Code Implementation**:
```python
def isSameTree(p, q):
    if not p and not q:
        return True
    if not p or not q:
        return False
    if p.val != q.val:
        return False
    return (isSameTree(p.left, q.left) and
            isSameTree(p.right, q.right))

# Iterative solution using stack
def isSameTreeIterative(p, q):
    stack = [(p, q)]
    
    while stack:
        node1, node2 = stack.pop()
        
        if not node1 and not node2:
            continue
        if not node1 or not node2:
            return False
        if node1.val != node2.val:
            return False
        
        stack.append((node1.left, node2.left))
        stack.append((node1.right, node2.right))
    
    return True
```

### 9. Invert Binary Tree
**Description**: Given the root of a binary tree, invert the tree, and return its root.

**Examples**:
```
Input: root = [4,2,7,1,3,6,9]
Output: [4,7,2,9,6,3,1]

Input: root = [2,1,3]
Output: [2,3,1]

Input: root = []
Output: []
```

**Solution Approach**:
- Use recursion to swap left and right children of each node
- Base case: if node is None, return None
- Time Complexity: O(n)
- Space Complexity: O(h)

**Code Implementation**:
```python
def invertTree(root):
    if not root:
        return None
    
    # Swap left and right children
    root.left, root.right = root.right, root.left
    
    # Recursively invert subtrees
    invertTree(root.left)
    invertTree(root.right)
    
    return root

# Iterative solution using queue
def invertTreeIterative(root):
    if not root:
        return None
    
    queue = deque([root])
    
    while queue:
        node = queue.popleft()
        
        # Swap children
        node.left, node.right = node.right, node.left
        
        # Add children to queue
        if node.left:
            queue.append(node.left)
        if node.right:
            queue.append(node.right)
    
    return root
```

### 10. Diameter of Binary Tree
**Description**: Given the root of a binary tree, return the length of the diameter of the tree. The diameter of a binary tree is the length of the longest path between any two nodes in a tree. This path may or may not pass through the root.

**Examples**:
```
Input: root = [1,2,3,4,5]
Output: 3
Explanation: 3 is the length of the path [4,2,1,3] or [5,2,1,3]

Input: root = [1,2]
Output: 1
```

**Solution Approach**:
- Use recursion to compute height of each node
- For each node, diameter through that node = left_height + right_height
- Keep track of maximum diameter encountered
- Time Complexity: O(n)
- Space Complexity: O(h)

**Code Implementation**:
```python
def diameterOfBinaryTree(root):
    diameter = 0
    
    def height(node):
        nonlocal diameter
        if not node:
            return 0
        
        left_height = height(node.left)
        right_height = height(node.right)
        
        # Update diameter if path through current node is longer
        diameter = max(diameter, left_height + right_height)
        
        # Return height of current node
        return 1 + max(left_height, right_height)
    
    height(root)
    return diameter

# Alternative returning both height and diameter
def diameterOfBinaryTreeV2(root):
    def dfs(node):
        if not node:
            return 0, 0  # height, diameter
        
        left_height, left_diameter = dfs(node.left)
        right_height, right_diameter = dfs(node.right)
        
        current_height = 1 + max(left_height, right_height)
        current_diameter = max(left_height + right_height,
                             left_diameter, right_diameter)
        
        return current_height, current_diameter
    
    return dfs(root)[1]
```

### 11. Balanced Binary Tree
**Description**: Given the root of a binary tree, determine if it is height-balanced. A height-balanced binary tree is a binary tree in which the depth of the two subtrees of every node never differs by more than 1.

**Examples**:
```
Input: root = [3,9,20,null,null,15,7]
Output: true

Input: root = [1,2,2,3,3,null,null,4,4]
Output: false

Input: root = []
Output: true
```

**Solution Approach**:
- Use recursion to check height balance
- For each node, check if left and right subtrees are balanced
- Check if height difference between left and right subtrees <= 1
- Return height of subtree if balanced, otherwise return -1
- Time Complexity: O(n)
- Space Complexity: O(h)

**Code Implementation**:
```python
def isBalanced(root):
    def checkHeight(node):
        if not node:
            return 0
        
        left_height = checkHeight(node.left)
        if left_height == -1:
            return -1
        
        right_height = checkHeight(node.right)
        if right_height == -1:
            return -1
        
        if abs(left_height - right_height) > 1:
            return -1
        
        return 1 + max(left_height, right_height)
    
    return checkHeight(root) != -1
```

### 12. Path Sum II
**Description**: Given the root of a binary tree and an integer targetSum, return all root-to-leaf paths where the sum of the node values in the path equals targetSum.

**Examples**:
```
Input: root = [5,4,8,11,null,13,4,7,2,null,null,5,1], targetSum = 22
Output: [[5,4,11,2],[5,8,4,5]]

Input: root = [1,2,3], targetSum = 5
Output: []

Input: root = [1,2], targetSum = 0
Output: []
```

**Solution Approach**:
- Use DFS to traverse from root to leaf
- Keep track of current path and current sum
- When reaching leaf node, if sum equals targetSum, add path to result
- Time Complexity: O(n) for traversal, but O(n^2) in worst case for copying paths
- Space Complexity: O(h) for recursion stack, plus O(n) for result storage

**Code Implementation**:
```python
def pathSum(root, targetSum):
    result = []
    
    def dfs(node, current_sum, path):
        if not node:
            return
        
        # Add current node to path
        path.append(node.val)
        current_sum += node.val
        
        # If leaf node and sum matches target, add path to result
        if not node.left and not node.right:
            if current_sum == targetSum:
                result.append(list(path))  # Make a copy
        else:
            # Recursively explore left and right subtrees
            dfs(node.left, current_sum, path)
            dfs(node.right, current_sum, path)
        
        # Backtrack: remove current node from path
        path.pop()
    
    dfs(root, 0, [])
    return result
```

### 13. Construct Binary Tree from Preorder and Inorder Traversal
**Description**: Given two integer arrays preorder and inorder where preorder is the preorder traversal of a binary tree and inorder is the inorder traversal of the same tree, construct and return the binary tree.

**Examples**:
```
Input: preorder = [3,9,20,15,7], inorder = [9,3,15,20,7]
Output: [3,9,20,null,null,15,7]

Input: preorder = [-1], inorder = [-1]
Output: [-1]
```

**Solution Approach**:
- The first element in preorder is always the root
- Find root in inorder array; elements left of root form left subtree, elements right form right subtree
- Recursively build left and right subtrees
- Use hashmap to store inorder indices for O(1) lookup
- Time Complexity: O(n)
- Space Complexity: O(n) for hashmap and recursion stack

**Code Implementation**:
```python
def buildTree(preorder, inorder):
    if not preorder or not inorder:
        return None
    
    # Create a hashmap to store value -> index mappings for inorder
    inorder_map = {val: idx for idx, val in enumerate(inorder)}
    
    def build(pre_start, pre_end, in_start, in_end):
        if pre_start > pre_end or in_start > in_end:
            return None
        
        # The first element in preorder is root
        root_val = preorder[pre_start]
        root = TreeNode(root_val)
        
        # Find root position in inorder
        inorder_root_idx = inorder_map[root_val]
        
        # Number of nodes in left subtree
        left_subtree_size = inorder_root_idx - in_start
        
        # Recursively build left and right subtrees
        root.left = build(pre_start + 1, 
                         pre_start + left_subtree_size,
                         in_start, 
                         inorder_root_idx - 1)
        
        root.right = build(pre_start + left_subtree_size + 1,
                          pre_end,
                          inorder_root_idx + 1,
                          in_end)
        
        return root
    
    return build(0, len(preorder)-1, 0, len(inorder)-1)
```

### 14. Binary Tree Right Side View
**Description**: Given the root of a binary tree, imagine yourself standing on the right side of it, return the values of the nodes you can see ordered from top to bottom.

**Examples**:
```
Input: root = [1,2,3,null,5,null,4]
Output: [1,3,4]

Input: root = [1,null,3]
Output: [1,3]

Input: root = []
Output: []
```

**Solution Approach**:
- Use BFS (level order traversal) and take the last node at each level
- Alternatively, use DFS with right-first traversal
- Time Complexity: O(n)
- Space Complexity: O(w) for BFS or O(h) for DFS

**Code Implementation**:
```python
from collections import deque

def rightSideView(root):
    if not root:
        return []
    
    result = []
    queue = deque([root])
    
    while queue:
        level_size = len(queue)
        
        for i in range(level_size):
            node = queue.popleft()
            
            # If it's the last node in this level, add to result
            if i == level_size - 1:
                result.append(node.val)
            
            # Add children to queue
            if node.left:
                queue.append(node.left)
            if node.right:
                queue.append(node.right)
    
    return result

# DFS approach
def rightSideViewDFS(root):
    result = []
    
    def dfs(node, depth):
        if not node:
            return
        
        # If we're visiting this depth for the first time, add node value
        if depth == len(result):
            result.append(node.val)
        
        # Visit right subtree first, then left
        dfs(node.right, depth + 1)
        dfs(node.left, depth + 1)
    
    dfs(root, 0)
    return result
```

### 15. Lowest Common Ancestor of a Binary Tree
**Description**: Given a binary tree, find the lowest common ancestor (LCA) of two given nodes in the tree. According to the definition of LCA on Wikipedia: "The lowest common ancestor is defined between two nodes p and q as the lowest node in T that has both p and q as descendants (where we allow a node to be a descendant of itself)."

**Examples**:
```
Input: root = [3,5,1,6,2,0,8,null,null,7,4], p = 5, q = 1
Output: 3
Explanation: The LCA of nodes 5 and 1 is 3.

Input: root = [3,5,1,6,2,0,8,null,null,7,4], p = 5, q = 4
Output: 5
Explanation: The LCA of nodes 5 and 4 is 5, since a node can be a descendant of itself.

Input: root = [1,2], p = 1, q = 2
Output: 1
```

**Solution Approach**:
- Use recursion to traverse the tree
- If current node is either p or q, return it
- Recursively search left and right subtrees
- If both left and right return non-null, current node is LCA
- Otherwise, return the non-null child (if any)
- Time Complexity: O(n)
- Space Complexity: O(h)

**Code Implementation**:
```python
def lowestCommonAncestor(root, p, q):
    if not root or root == p or root == q:
        return root
    
    left = lowestCommonAncestor(root.left, p, q)
    right = lowestCommonAncestor(root.right, p, q)
    
    # If both left and right are not None, current node is LCA
    if left and right:
        return root
    
    # Otherwise return the non-null child
    return left if left else right
```

## Medium Problems

### 16. Binary Tree Maximum Path Sum
**Description**: A path in a binary tree is a sequence of nodes where each pair of adjacent nodes in the sequence has an edge connecting them. A node can only appear in the sequence at most once. Note that the path does not need to pass through the root. The path sum of a path is the sum of the node's values in the path. Given the root of a binary tree, return the maximum path sum of any non-empty path.

**Examples**:
```
Input: root = [1,2,3]
Output: 6
Explanation: The optimal path is 2 -> 1 -> 3 with a sum of 2 + 1 + 3 = 6.

Input: root = [-10,9,20,null,null,15,7]
Output: 42
Explanation: The optimal path is 15 -> 20 -> 7 with a sum of 15 + 20 + 7 = 42.
```

**Solution Approach**:
- Use recursion to compute maximum path sum through each node
- For each node, compute:
  - Maximum gain from left subtree (or 0 if negative)
  - Maximum gain from right subtree (or 0 if negative)
  - Price of new path through current node = node.val + left_gain + right_gain
  - Update global maximum if this path is better
  - Return maximum gain that can be extended to parent = node.val + max(left_gain, right_gain)
- Time Complexity: O(n)
- Space Complexity: O(h)

**Code Implementation**:
```python
def maxPathSum(root):
    max_sum = float('-inf')
    
    def maxGain(node):
        nonlocal max_sum
        if not node:
            return 0
        
        # Max gain from left and right subtrees (ignore negative gains)
        left_gain = max(maxGain(node.left), 0)
        right_gain = max(maxGain(node.right), 0)
        
        # Price of new path through current node
        price_newpath = node.val + left_gain + right_gain
        
        # Update global maximum
        max_sum = max(max_sum, price_newpath)
        
        # For recursion, return max gain that can be extended to parent
        return node.val + max(left_gain, right_gain)
    
    maxGain(root)
    return max_sum
```

### 17. Serialize and Deserialize Binary Tree
**Description**: Design an algorithm to serialize and deserialize a binary tree. There is no restriction on how your serialization/deserialization algorithm should work. You just need to ensure that a binary tree can be serialized to a string and this string can be deserialized to the original tree structure.

**Examples**:
```
Input: root = [1,2,3,null,null,4,5]
Output: [1,2,3,null,null,4,5]
Explanation: The serialized tree should be able to reconstruct the original tree.
```

**Solution Approach**:
- Use preorder traversal with markers for null nodes
- Serialize: root, left, right (with 'None' for null nodes)
- Deserialize: use iterator to reconstruct tree from serialized string
- Time Complexity: O(n) for both serialize and deserialize
- Space Complexity: O(n) for serialized string and O(h) for recursion stack

**Code Implementation**:
```python
class Codec:
    def serialize(self, root):
        """Encodes a tree to a single string."""
        def preorder(node):
            if not node:
                return ['None']
            return [str(node.val)] + preorder(node.left) + preorder(node.right)
        
        return ','.join(preorder(root))
    
    def deserialize(self, data):
        """Decodes your encoded data to tree."""
        def build_tree(values):
            val = next(values)
            if val == 'None':
                return None
            node = TreeNode(int(val))
            node.left = build_tree(values)
            node.right = build_tree(values)
            return node
        
        values = iter(data.split(','))
        return build_tree(values)

# Alternative using BFS (level order)
class CodecBFS:
    def serialize(self, root):
        if not root:
            return ""
        
        queue = deque([root])
        result = []
        
        while queue:
            node = queue.popleft()
            if node:
                result.append(str(node.val))
                queue.append(node.left)
                queue.append(node.right)
            else:
                result.append("None")
        
        # Remove trailing None values
        while result and result[-1] == "None":
            result.pop()
        
        return ','.join(result)
    
    def deserialize(self, data):
        if not data:
            return None
        
        values = data.split(',')
        root = TreeNode(int(values[0]))
        queue = deque([root])
        i = 1
        
        while queue and i < len(values):
            node = queue.popleft()
            
            # Left child
            if i < len(values) and values[i] != "None":
                left_node = TreeNode(int(values[i]))
                node.left = left_node
                queue.append(left_node)
            i += 1
            
            # Right child
            if i < len(values) and values[i] != "None":
                right_node = TreeNode(int(values[i]))
                node.right = right_node
                queue.append(right_node)
            i += 1
        
        return root
```

### 18. Binary Tree Zigzag Level Order Traversal
**Description**: Given the root of a binary tree, return the zigzag level order traversal of its nodes' values. (i.e., from left to right, then right to left for the next level and alternate between).

**Examples**:
```
Input: root = [3,9,20,null,null,15,7]
Output: [[3],[20,9],[15,7]]

Input: root = [1]
Output: [[1]]

Input: root = []
Output: []
```

**Solution Approach**:
- Use BFS with a flag to indicate direction
- For each level, collect nodes in normal order
- Reverse the level values when going right-to-left
- Time Complexity: O(n)
- Space Complexity: O(w)

**Code Implementation**:
```python
from collections import deque

def zigzagLevelOrder(root):
    if not root:
        return []
    
    result = []
    queue = deque([root])
    left_to_right = True
    
    while queue:
        level_size = len(queue)
        level_values = []
        
        for _ in range(level_size):
            node = queue.popleft()
            level_values.append(node.val)
            
            if node.left:
                queue.append(node.left)
            if node.right:
                queue.append(node.right)
        
        # Reverse if going right to left
        if not left_to_right:
            level_values.reverse()
        
        result.append(level_values)
        left_to_right = not left_to_right
    
    return result
```

### 19. Populating Next Right Pointers in Each Node
**Description**: You are given a perfect binary tree where all leaves are on the same level, and every parent has two children. Populate each next pointer to point to its next right node. If there is no next right node, the next pointer should be set to NULL.

**Examples**:
```
Input: root = [1,2,3,4,5,6,7]
Output: [1,#,2,3,#,4,5,6,7,#]
Explanation: Given the above perfect binary tree (Figure A), your function should populate each next pointer to point to its next right node, just like in Figure B.
```

**Solution Approach**:
- Use level order traversal without extra space
- Use next pointers to traverse current level
- Connect children of current level nodes
- Time Complexity: O(n)
- Space Complexity: O(1)

**Code Implementation**:
```python
class Node:
    def __init__(self, val: int = 0, left: 'Node' = None, right: 'Node' = None, next: 'Node' = None):
        self.val = val
        self.left = left
        self.right = right
        self.next = next

def connect(root):
    if not root:
        return None
    
    # Start with the root node
    leftmost = root
    
    while leftmost.left:
        # Iterate through the current level using next pointers
        head = leftmost
        while head:
            # Connection 1: left child to right child
            head.left.next = head.right
            
            # Connection 2: right child to next node's left child
            if head.next:
                head.right.next = head.next.left
            
            # Move to next node in current level
            head = head.next
        
        # Move to next level
        leftmost = leftmost.left
    
    return root

# Alternative using BFS with queue
def connectBFS(root):
    if not root:
        return None
    
    queue = deque([root])
    
    while queue:
        level_size = len(queue)
        
        for i in range(level_size):
            node = queue.popleft()
            
            # Set next pointer to next node in queue (if not last in level)
            if i < level_size - 1:
                node.next = queue[0]
            
            # Add children to queue
            if node.left:
                queue.append(node.left)
            if node.right:
                queue.append(node.right)
    
    return root
```

### 20. Sum Root to Leaf Numbers
**Description**: You are given the root of a binary tree containing digits from 0 to 9 only. Each root-to-leaf path in the tree represents a number. For example, the root-to-leaf path 1 -> 2 -> 3 represents the number 123. Return the total sum of all root-to-leaf numbers.

**Examples**:
```
Input: root = [1,2,3]
Output: 25
Explanation: The root-to-leaf path 1->2 represents the number 12. The root-to-leaf path 1->3 represents the number 13. Therefore, sum = 12 + 13 = 25.

Input: root = [4,9,0,5,1]
Output: 1026
Explanation: The root-to-leaf path 4->9->5 represents the number 495. The root-to-leaf path 4->9->0 represents the number 490. The root-to-leaf path 4->0 represents the number 40. Therefore, sum = 495 + 490 + 40 = 1026.
```

**Solution Approach**:
- Use DFS to traverse from root to leaf
- Keep track of current number formed so far
- When reaching leaf node, add current number to total sum
- Time Complexity: O(n)
- Space Complexity: O(h)

**Code Implementation**:
```python
def sumNumbers(root):
    def dfs(node, current_sum):
        if not node:
            return 0
        
        # Update current sum
        current_sum = current_sum * 10 + node.val
        
        # If leaf node, return current sum
        if not node.left and not node.right:
            return current_sum
        
        # Recursively sum left and right subtrees
        return dfs(node.left, current_sum) + dfs(node.right, current_sum)
    
    return dfs(root, 0)

# Iterative solution using stack
def sumNumbersIterative(root):
    if not root:
        return 0
    
    stack = [(root, root.val)]
    total_sum = 0
    
    while stack:
        node, current_sum = stack.pop()
        
        # If leaf node, add to total sum
        if not node.left and not node.right:
            total_sum += current_sum
        
        # Push right child
        if node.right:
            stack.append((node.right, current_sum * 10 + node.right.val))
        
        # Push left child
        if node.left:
            stack.append((node.left, current_sum * 10 + node.left.val))
    
    return total_sum
```

### 21. Binary Tree Longest Consecutive Sequence
**Description**: Given the root of a binary tree, return the length of the longest consecutive sequence path. The path refers to any sequence of nodes from some starting node to any node in the tree along the parent-child connections. The longest consecutive path needs to be from parent to child (cannot be the reverse).

**Examples**:
```
Input: root = [1,null,3,2,4,null,null,null,5]
Output: 3
Explanation: Longest consecutive sequence path is 3-4-5, so return 3.

Input: root = [2,null,3,2,null,1]
Output: 2
Explanation: Longest consecutive sequence path is 2-3, not 3-2-1, so return 2.
```

**Solution Approach**:
- Use DFS to traverse the tree
- For each node, check if it continues the sequence from parent
- Keep track of current sequence length and maximum found
- Time Complexity: O(n)
- Space Complexity: O(h)

**Code Implementation**:
```python
def longestConsecutive(root):
    max_length = 0
    
    def dfs(node, parent_val, current_length):
        nonlocal max_length
        if not node:
            return
        
        # Check if current node continues the sequence
        if node.val == parent_val + 1:
            current_length += 1
        else:
            current_length = 1  # Reset sequence length
        
        # Update maximum length
        max_length = max(max_length, current_length)
        
        # Recursively explore left and right subtrees
        dfs(node.left, node.val, current_length)
        dfs(node.right, node.val, current_length)
    
    if root:
        dfs(root, root.val - 1, 0)  # Start with value that won't match
    
    return max_length
```

### 22. Binary Tree Cameras
**Description**: Given the root of a binary tree, install the minimum number of cameras needed to monitor all nodes of the tree. Each camera at a node can monitor its parent, itself, and its immediate children. Return the minimum number of cameras needed.

**Examples**:
```
Input: root = [0,0,null,0,0]
Output: 1
Explanation: One camera is enough to monitor all nodes if placed as shown.

Input: root = [0,0,null,0,null,0,null,null,0]
Output: 2
Explanation: At least two cameras are needed to monitor all nodes of the tree.
```

**Solution Approach**:
- Use greedy approach from bottom to top
- Three states: 0 = needs camera, 1 = has camera, 2 = covered
- Post-order traversal: process children before parent
- Time Complexity: O(n)
- Space Complexity: O(h)

**Code Implementation**:
```python
def minCameraCover(root):
    # States: 0 = needs camera, 1 = has camera, 2 = covered
    cameras = 0
    
    def dfs(node):
        nonlocal cameras
        if not node:
            return 2  # Null nodes are considered covered
        
        left = dfs(node.left)
        right = dfs(node.right)
        
        # If any child needs camera, current node must have camera
        if left == 0 or right == 0:
            cameras += 1
            return 1  # Current node has camera
        
        # If any child has camera, current node is covered
        if left == 1 or right == 1:
            return 2  # Current node is covered
        
        # Otherwise, current node needs camera (to be covered by parent)
        return 0  # Current node needs camera
    
    # If root needs camera, add one more
    if dfs(root) == 0:
        cameras += 1
    
    return cameras
```

### 23. Binary Tree Vertical Order Traversal
**Description**: Given the root of a binary tree, return the vertical order traversal of its nodes' values. (i.e., from top to bottom, column by column). If two nodes are in the same row and column, the order should be from left to right.

**Examples**:
```
Input: root = [3,9,20,null,null,15,7]
Output: [[9],[3,15],[20],[7]]

Input: root = [1,2,3,4,5,6,7]
Output: [[4],[2],[1,5,6],[3,7]]
```

**Solution Approach**:
- Use BFS to traverse tree level by level
- Track column index for each node (root = 0, left = -1, right = +1)
- Use dictionary to store nodes by column
- Sort columns and return values in order
- Time Complexity: O(n log n) due to sorting
- Space Complexity: O(n)

**Code Implementation**:
```python
from collections import deque, defaultdict

def verticalOrder(root):
    if not root:
        return []
    
    # Dictionary to store nodes by column
    column_table = defaultdict(list)
    min_column = max_column = 0
    
    queue = deque([(root, 0)])  # (node, column)
    
    while queue:
        node, column = queue.popleft()
        
        if node is not None:
            column_table[column].append(node.val)
            min_column = min(min_column, column)
            max_column = max(max_column, column)
            
            # Add children to queue
            queue.append((node.left, column - 1))
            queue.append((node.right, column + 1))
    
    # Return columns in order from left to right
    return [column_table[x] for x in range(min_column, max_column + 1)]
```

### 24. Binary Tree Upside Down
**Description**: Given the root of a binary tree, turn the tree upside down and return the new root. You can turn a binary tree upside down with the following steps:
1. The original left child becomes the new root.
2. The original root becomes the new right child.
3. The original right child becomes the new left child.
The mentioned steps are done level by level.

**Examples**:
```
Input: root = [1,2,3,4,5]
Output: [4,5,2,null,null,3,1]

Input: root = []
Output: []

Input: root = [1]
Output: [1]
```

**Solution Approach**:
- Use recursion to process leftmost path first
- The leftmost leaf becomes the new root
- Rewire pointers as we unwind the recursion
- Time Complexity: O(n)
- Space Complexity: O(h)

**Code Implementation**:
```python
def upsideDownBinaryTree(root):
    if not root or not root.left:
        return root
    
    # Recursively process left subtree
    new_root = upsideDownBinaryTree(root.left)
    
    # Rewire pointers
    root.left.left = root.right  # Original right becomes left child
    root.left.right = root       # Original root becomes right child
    
    # Remove original connections
    root.left = None
    root.right = None
    
    return new_root

# Iterative solution
def upsideDownBinaryTreeIterative(root):
    if not root:
        return None
    
    current = root
    prev = None
    prev_right = None
    
    while current:
        # Store next nodes
        next_node = current.left
        
        # Rewire current node
        current.left = prev_right
        current.right = prev
        
        # Move to next node
        prev_right = current.right
        prev = current
        current = next_node
    
    return prev
```

### 25. Recover Binary Search Tree
**Description**: You are given the root of a binary search tree (BST), where exactly two nodes of the tree were swapped by mistake. Recover the tree without changing its structure.

**Examples**:
```
Input: root = [1,3,null,null,2]
Output: [3,1,null,null,2]
Explanation: 3 cannot be a left child of 1 because 3 > 1. Swapping 1 and 3 makes the BST valid.

Input: root = [3,1,4,null,null,2]
Output: [2,1,4,null,null,3]
Explanation: 2 cannot be in the right subtree of 3 because 2 < 3. Swapping 2 and 3 makes the BST valid.
```

**Solution Approach**:
- Use inorder traversal to find the two swapped nodes
- In BST, inorder traversal should be sorted
- Identify nodes where order is violated
- Time Complexity: O(n)
- Space Complexity: O(h) or O(1) with Morris traversal

**Code Implementation**:
```python
def recoverTree(root):
    # Initialize pointers for swapped nodes
    first = second = prev = None
    
    def inorder(node):
        nonlocal first, second, prev
        if not node:
            return
        
        # Traverse left subtree
        inorder(node.left)
        
        # Check if current node violates BST property
        if prev and prev.val > node.val:
            # First violation
            if not first:
                first = prev
            # Second violation (might be same as first)
            second = node
        
        prev = node
        
        # Traverse right subtree
        inorder(node.right)
    
    # Find swapped nodes
    inorder(root)
    
    # Swap values to recover BST
    if first and second:
        first.val, second.val = second.val, first.val
```

### 26. Binary Tree Preorder Traversal
**Description**: Given the root of a binary tree, return the preorder traversal of its nodes' values.

**Examples**:
```
Input: root = [1,null,2,3]
Output: [1,2,3]

Input: root = []
Output: []

Input: root = [1]
Output: [1]
```

**Solution Approach**:
- Use recursion: root -> left -> right
- Alternatively, use iterative approach with stack
- Time Complexity: O(n)
- Space Complexity: O(h)

**Code Implementation**:
```python
def preorderTraversal(root):
    result = []
    
    def preorder(node):
        if not node:
            return
        result.append(node.val)
        preorder(node.left)
        preorder(node.right)
    
    preorder(root)
    return result

# Iterative solution
def preorderTraversalIterative(root):
    if not root:
        return []
    
    result = []
    stack = [root]
    
    while stack:
        node = stack.pop()
        result.append(node.val)
        
        # Push right first so left is processed first
        if node.right:
            stack.append(node.right)
        if node.left:
            stack.append(node.left)
    
    return result
```

### 27. Binary Tree Postorder Traversal
**Description**: Given the root of a binary tree, return the postorder traversal of its nodes' values.

**Examples**:
```
Input: root = [1,null,2,3]
Output: [3,2,1]

Input: root = []
Output: []

Input: root = [1]
Output: [1]
```

**Solution Approach**:
- Use recursion: left -> right -> root
- Alternatively, use iterative approach with stack
- Time Complexity: O(n)
- Space Complexity: O(h)

**Code Implementation**:
```python
def postorderTraversal(root):
    result = []
    
    def postorder(node):
        if not node:
            return
        postorder(node.left)
        postorder(node.right)
        result.append(node.val)
    
    postorder(root)
    return result

# Iterative solution using two stacks
def postorderTraversalIterative(root):
    if not root:
        return []
    
    stack1 = [root]
    stack2 = []
    
    while stack1:
        node = stack1.pop()
        stack2.append(node)
        
        if node.left:
            stack1.append(node.left)
        if node.right:
            stack1.append(node.right)
    
    result = []
    while stack2:
        node = stack2.pop()
        result.append(node.val)
    
    return result

# Iterative solution using one stack
def postorderTraversalOneStack(root):
    if not root:
        return []
    
    result = []
    stack = []
    last_visited = None
    current = root
    
    while current or stack:
        if current:
            stack.append(current)
            current = current.left
        else:
            peek_node = stack[-1]
            # If right child exists and hasn't been visited yet
            if peek_node.right and last_visited != peek_node.right:
                current = peek_node.right
            else:
                result.append(stack.pop().val)
                last_visited = stack.pop() if stack else None
    
    return result
```

### 28. Kth Smallest Element in a BST
**Description**: Given the root of a binary search tree, and an integer k, return the kth smallest value (1-indexed) of all the values of the nodes in the tree.

**Examples**:
```
Input: root = [3,1,4,null,2], k = 1
Output: 1

Input: root = [5,3,6,2,4,null,null,1], k = 3
Output: 3
```

**Solution Approach**:
- Use inorder traversal (which gives sorted order in BST)
- Stop when we've visited k nodes
- Time Complexity: O(h + k) where h is height of tree
- Space Complexity: O(h)

**Code Implementation**:
```python
def kthSmallest(root, k):
    stack = []
    current = root
    
    while current or stack:
        # Reach the leftmost node
        while current:
            stack.append(current)
            current = current.left
        
        # Process node
        current = stack.pop()
        k -= 1
        if k == 0:
            return current.val
        
        # Move to right subtree
        current = current.right
    
    return -1  # Should not reach here if k is valid

# Recursive solution with early termination
def kthSmallestRecursive(root, k):
    def inorder(node):
        nonlocal k
        if not node:
            return None
        
        # Search left subtree
        left = inorder(node.left)
        if left is not None:
            return left
        
        # Process current node
        k -= 1
        if k == 0:
            return node.val
        
        # Search right subtree
        return inorder(node.right)
    
    return inorder(root)
```

## Hard Problems

### 29. Serialize and Deserialize N-ary Tree
**Description**: Design an algorithm to serialize and deserialize an N-ary tree. An N-ary tree is a rooted tree in which each node has no more than N children. There is no restriction on how your serialization/deserialization algorithm should work. You just need to ensure that an N-ary tree can be serialized to a string and this string can be deserialized to the original tree structure.

**Examples**:
```
Input: root = [1,null,3,2,4,5,6,null,null,null,7,8,9,10,null,null,11,null,12,null,13,null,null,14]
Output: [1,null,3,2,4,5,6,null,null,null,7,8,9,10,null,null,11,null,12,null,13,null,null,14]
```

**Solution Approach**:
- Use preorder traversal with child count markers
- Serialize: node value, number of children, then recursively serialize each child
- Deserialize: read value, read child count, then recursively deserialize each child
- Time Complexity: O(n) for both serialize and deserialize
- Space Complexity: O(n) for serialized string and O(h) for recursion stack

**Code Implementation**:
```python
class Node:
    def __init__(self, val=None, children=None):
        self.val = val
        self.children = children if children is not None else []

class Codec:
    def serialize(self, root):
        """Encodes a tree to a single string."""
        def dfs(node):
            if not node:
                return []
            result = [str(node.val), str(len(node.children))]
            for child in node.children:
                result.extend(dfs(child))
            return result
        
        return ','.join(dfs(root))
    
    def deserialize(self, data):
        """Decodes your encoded data to tree."""
        if not data:
            return None
        
        values = iter(data.split(','))
        
        def dfs():
            val = next(values)
            if val == '':
                return None
            node_val = int(val)
            children_count = int(next(values))
            
            node = Node(node_val, [])
            for _ in range(children_count):
                node.children.append(dfs())
            
            return node
        
        return dfs()
```

### 30. Binary Tree Longest Consecutive Sequence II
**Description**: Given the root of a binary tree, return the length of the longest consecutive path in the tree. This path can be either increasing or decreasing. For example, [1,2,3,4] and [4,3,2,1] are both considered valid consecutive paths.

**Examples**:
```
Input: root = [1,2,0,3]
Output: 3
Explanation: The longest consecutive path is [0,1,2] or [2,1,0].

Input: root = [2,1,3]
Output: 3
Explanation: The longest consecutive path is [1,2,3] or [3,2,1].
```

**Solution Approach**:
- Use DFS to traverse the tree
- For each node, compute:
  - inc: length of longest increasing consecutive path ending at this node
  - dec: length of longest decreasing consecutive path ending at this node
- Update global maximum with inc + dec - 1 (node counted twice)
- Time Complexity: O(n)
- Space Complexity: O(h)

**Code Implementation**:
```python
def longestConsecutiveII(root):
    max_length = 0
    
    def dfs(node):
        nonlocal max_length
        if not node:
            return 0, 0  # inc, dec
        
        # Get values from left and right subtrees
        left_inc, left_dec = dfs(node.left)
        right_inc, right_dec = dfs(node.right)
        
        # Initialize current node's inc and dec
        inc = dec = 1
        
        # Check left child
        if node.left:
            if node.left.val == node.val + 1:
                inc = max(inc, left_inc + 1)
            if node.left.val == node.val - 1:
                dec = max(dec, left_dec + 1)
        
        # Check right child
        if node.right:
            if node.right.val == node.val + 1:
                inc = max(inc, right_inc + 1)
            if node.right.val == node.val - 1:
                dec = max(dec, right_dec + 1)
        
        # Update global maximum
        max_length = max(max_length, inc + dec - 1)
        
        return inc, dec
    
    dfs(root)
    return max_length
```

### 31. Binary Tree Maximum Path Sum II
**Description**: Given a binary tree, find the maximum path sum. The path may start and end at any node in the tree.

**Note**: This is actually the same as problem 16, but included here for completeness.

**Solution Approach**:
- Refer to problem 16 (Binary Tree Maximum Path Sum)
- Same solution applies

### 32. Construct Binary Tree from String
**Description**: You need to construct a binary tree from a string consisting of parenthesis and integers. The whole input represents a binary tree. It contains an integer followed by zero, one or two pairs of parenthesis. The integer represents the root's value and a pair of parenthesis contains a child binary tree with the same structure.

**Examples**:
```
Input: s = "4(2(3)(1))(6(5)(7))"
Output: [4,2,6,3,1,5,7]

Input: s = "4(2(3)(1))(6(5)(7))"
Output: [4,2,6,3,1,5,7]

Input: s = "-4(2(3)(1))(6(5)(7))"
Output: [-4,2,6,3,1,5,7]
```

**Solution Approach**:
- Use stack to keep track of nodes
- Parse string character by character
- When encountering digits, build the number
- When encountering '(', create a new node and push to stack
- When encountering ')', pop from stack
- Time Complexity: O(n)
- Space Complexity: O(n)

**Code Implementation**:
```python
def str2tree(s):
    if not s:
        return None
    
    stack = []
    i = 0
    n = len(s)
    
    while i < n:
        if s[i] == ')':
            stack.pop()
            i += 1
        elif s[i] == '(':
            i += 1
        else:
            # Parse number (could be negative)
            sign = 1
            if s[i] == '-':
                sign = -1
                i += 1
            
            num = 0
            while i < n and s[i].isdigit():
                num = num * 10 + int(s[i])
                i += 1
            
            num *= sign
            node = TreeNode(num)
            
            if stack:
                parent = stack[-1]
                if not parent.left:
                    parent.left = node
                else:
                    parent.right = node
            
            stack.append(node)
    
    return stack[0] if stack else None
```

### 33. Find Leaves of Binary Tree
**Description**: Given the root of a binary tree, collect a tree's nodes as if you were doing this: Collect all the leaf nodes, remove them, and repeat until the tree is empty.

**Examples**:
```
Input: root = [1,2,3,4,5]
Output: [[4,5,3],[2],[1]]
Explanation: 
[[4,5,3],[2],[1]] has the following meaning:
- First iteration: [4,5,3] (leaves)
- Second iteration: [2] (new leaves after removing [4,5,3])
- Third iteration: [1] (new leaves after removing [2])
```

**Solution Approach**:
- Use DFS to compute height of each node
- Nodes with same height are removed in same iteration
- Use dictionary to group nodes by height
- Time Complexity: O(n)
- Space Complexity: O(n)

**Code Implementation**:
```python
def findLeaves(root):
    from collections import defaultdict
    
    leaves_by_height = defaultdict(list)
    
    def getHeight(node):
        if not node:
            return -1
        
        left_height = getHeight(node.left)
        right_height = getHeight(node.right)
        height = 1 + max(left_height, right_height)
        
        leaves_by_height[height].append(node.val)
        return height
    
    getHeight(root)
    
    # Return leaves grouped by height (from smallest to largest height)
    return [leaves_by_height[h] for h in sorted(leaves_by_height.keys())]
```

### 34. Most Frequent Subtree Sum
**Description**: Given the root of a tree, you are asked to find the most frequent subtree sum. The subtree sum of a node is defined as the sum of all the node values formed by the subtree rooted at that node (including the node itself). So what is the most frequent subtree sum value? If there is a tie, return all the values with the highest frequency in any order.

**Examples**
```
Input: root = [5,2,-3]
Output: [2,4,-3]
Explanation: All subtree sums are unique: 2, 4, -3, so return all.

Input: root = [5,2,-5]
Output: [2]
Explanation: Subtree sums are: 2 (node 2), 2 (node 5's left), -3 (node 5's right + 5 + 2), so 2 appears twice.
```

**Solution Approach**:
- Use DFS to compute subtree sums
- Use dictionary to count frequency of each sum
- Find maximum frequency and return all sums with that frequency
- Time Complexity: O(n)
- Space Complexity: O(n)

**Code Implementation**:
```python
from collections import defaultdict

def findFrequentTreeSum(root):
    if not root:
        return []
    
    sum_count = defaultdict(int)
    
    def subtreeSum(node):
        if not node:
            return 0
        
        left_sum = subtreeSum(node.left)
        right_sum = subtreeSum(node.right)
        total = node.val + left_sum + right_sum
        
        sum_count[total] += 1
        return total
    
    subtreeSum(root)
    
    # Find maximum frequency
    max_freq = max(sum_count.values())
    
    # Return all sums with maximum frequency
    return [sum_val for sum_val, freq in sum_count.items() if freq == max_freq]
```

### 35. Kill Process
**Description**: Given n processes, each process has a unique PID (process id) and its PPID (parent process id). Each process only has one parent process, but may have multiple children processes. This is just like a tree structure. Only one process has PPID = 0, which means this process has no parent process. All the PIDs will be distinct positive integers.

We use two list of integers to represent a list of processes, where the first list contains PID for each process and the second list contains the corresponding PPID.

Now given the PID of a process that is to be killed, return a list of PIDs of processes that will be killed in the end. When a process is killed, all its children processes will be killed.

**Examples**:
```
Input: pid =  [1,3,10,5]
ppid = [3,0,5,3]
kill = 5
Output: [5,10]
Explanation: 
           3
         /   \
        1     5
             /
            10
Kill 5 will also kill 10.
```

**Solution Approach**:
- Build adjacency list representing the tree (parent -> children)
- Use BFS or DFS to traverse from the process to be killed
- Collect all visited nodes
- Time Complexity: O(n)
- Space Complexity: O(n)

**Code Implementation**:
```python
from collections import defaultdict, deque

def killProcess(pid, ppid, kill):
    # Build tree: parent -> children
    children = defaultdict(list)
    for i in range(len(pid)):
        children[ppid[i]].append(pid[i])
    
    # BFS to find all processes to be killed
    result = []
    queue = deque([kill])
    
    while queue:
        current = queue.popleft()
        result.append(current)
        
        # Add all children to queue
        for child in children[current]:
            queue.append(child)
    
    return result

# DFS approach
def killProcessDFS(pid, ppid, kill):
    # Build tree: parent -> children
    children = defaultdict(list)
    for i in range(len(pid)):
        children[ppid[i]].append(pid[i])
    
    result = []
    
    def dfs(process):
        result.append(process)
        for child in children[process]:
            dfs(child)
    
    dfs(kill)
    return result
```

### 36. Smallest Subtree with all the Deepest Nodes
**Description**: Given the root of a binary tree, return the smallest subtree such that it contains all the deepest nodes in the original tree. A node is called the deepest if it has the largest depth possible among any node in the entire tree. The subtree of a node is the tree consisting of that node, plus all of its descendants.

**Examples**:
```
Input: root = [3,5,1,6,2,0,8,null,null,7,4]
Output: [2,7,4]
Explanation: We return the node with value 2, colored in yellow in the diagram.
The nodes colored in blue are the deepest nodes of the tree.
The subtree rooted at node 2, colored in yellow, is the smallest subtree that contains all the deepest nodes.
```

**Solution Approach**:
- Use DFS to compute depth of each node
- For each node, if left and right subtrees have same depth, this node is LCA of deepest nodes
- Otherwise, return the subtree with greater depth
- Time Complexity: O(n)
- Space Complexity: O(h)

**Code Implementation**:
```python
def subtreeWithAllDeepest(root):
    def dfs(node):
        if not node:
            return None, 0  # node, depth
        
        left_node, left_depth = dfs(node.left)
        right_node, right_depth = dfs(node.right)
        
        if left_depth > right_depth:
            return left_node, left_depth + 1
        elif right_depth > left_depth:
            return right_node, right_depth + 1
        else:
            return node, left_depth + 1
    
    return dfs(root)[0]
```

### 37. Increasing Order Search Tree
**Description**: Given the root of a binary search tree, rearrange the tree in in-order so that the leftmost node in the tree is now the root of the tree, and every node has no left child and only one right child.

**Examples**:
```
Input: root = [5,3,6,2,4,null,null,1]
Output: [1,null,2,null,3,null,4,null,5,null,6,null,8]

Input: root = [5,1,7]
Output: [1,null,5,null,7]
```

**Solution Approach**:
- Use inorder traversal to get nodes in sorted order
- Reconstruct tree with only right children
- Time Complexity: O(n)
- Space Complexity: O(n) for storing nodes

**Code Implementation**:
```python
def increasingBST(root):
    def inorder(node):
        if not node:
            return []
        return inorder(node.left) + [node.val] + inorder(node.right)
    
    values = inorder(root)
    
    # Build new tree with only right children
    dummy = TreeNode(0)
    current = dummy
    
    for val in values:
        current.right = TreeNode(val)
        current = current.right
    
    return dummy.right

# Alternative: in-place transformation during inorder traversal
def increasingBSTInPlace(root):
    def inorder(node):
        nonlocal curr
        if not node:
            return
        
        inorder(node.left)
        
        # Reset left pointer and connect to current
        node.left = None
        curr.right = node
        curr = node
        
        inorder(node.right)
    
    dummy = TreeNode(0)
    curr = dummy
    inorder(root)
    return dummy.right
```

### 38. Binary Tree Coloring Game
**Description**: Two players play a turn based game on a binary tree. We are given the root of this binary tree, and the number of nodes n in the tree. n is odd, and each node has a distinct value from 1 to n.

Initially, the first player names a value x with 1 <= x <= n, and the second player names a value y with 1 <= y <= n and y != x. The first player colors the node with value x red, and the second player colors the node with value y blue.

Then, the players take turns starting with the first player. In each turn, a player chooses a node of their color (red if player 1, blue if player 2) and colors an uncolored neighbor of the chosen node (either the left child, right child, or parent of the chosen node.)

If a player cannot choose such a node in their turn, that player loses, and the other player wins.

Return true if and only if the second player can win.

**Examples**:
```
Input: root = [1,2,3,4,5,6,7,8,9,10,11], n = 11, x = 3
Output: true
Explanation: The second player can choose the node with value 2.
```

**Solution Approach**:
- Find the node with value x
- Count nodes in left subtree, right subtree, and parent's side
- Second player wins if they can choose a region with more than n/2 nodes
- Time Complexity: O(n)
- Space Complexity: O(h)

**Code Implementation**:
```python
def btreeGameWinningMove(root, n, x):
    def count_nodes(node):
        if not node:
            return 0
        return 1 + count_nodes(node.left) + count_nodes(node.right)
    
    def find_node(node, target):
        if not node:
            return None
        if node.val == target:
            return node
        left = find_node(node.left, target)
        if left:
            return left
        return find_node(node.right, target)
    
    # Find the node with value x
    x_node = find_node(root, x)
    
    # Count nodes in left and right subtrees
    left_count = count_nodes(x_node.left)
    right_count = count_nodes(x_node.right)
    
    # Nodes in parent's side = total - left - right - 1 (the x node itself)
    parent_count = n - left_count - right_count - 1
    
    # Second player wins if they can claim more than half the nodes
    max_claim = max(left_count, right_count, parent_count)
    return max_claim > n // 2
```

### 39. Construct Binary Tree from Preorder and Postorder Traversal
**Description**: Given two integer arrays, preorder and postorder where preorder is the preorder traversal of a binary tree and postorder is the postorder traversal of the same tree, construct and return the binary tree.

**Examples**:
```
Input: preorder = [1,2,4,5,3,6,7], postorder = [4,5,2,6,7,3,1]
Output: [1,2,3,4,5,6,7]

Input: preorder = [1], postorder = [1]
Output: [1]
```

**Solution Approach**:
- First element in preorder is root, last element in postorder is root
- Second element in preorder is root of left subtree
- Find this element in postorder to determine left subtree boundary
- Recursively build left and right subtrees
- Time Complexity: O(n^2) worst case, O(n) with optimization
- Space Complexity: O(n)

**Code Implementation**:
```python
def constructFromPrePost(preorder, postorder):
    if not preorder:
        return None
    
    # Create a map for postorder indices for O(1) lookup
    post_map = {val: idx for idx, val in enumerate(postorder)}
    
    def build(pre_start, pre_end, post_start, post_end):
        if pre_start > pre_end:
            return None
        
        # First element in preorder is root
        root = TreeNode(preorder[pre_start])
        
        # If only one element, return leaf node
        if pre_start == pre_end:
            return root
        
        # Second element in preorder is root of left subtree
        left_root_val = preorder[pre_start + 1]
        left_root_post_idx = post_map[left_root_val]
        
        # Number of elements in left subtree
        left_size = left_root_post_idx - post_start + 1
        
        # Recursively build left and right subtrees
        root.left = build(pre_start + 1, 
                         pre_start + left_size,
                         post_start, 
                         post_start + left_size - 1)
        
        root.right = build(pre_start + left_size + 1,
                          pre_end,
                          post_start + left_size,
                          post_end - 1)
        
        return root
    
    return build(0, len(preorder)-1, 0, len(postorder)-1)
```

### 40. Distance K in Binary Tree
**Description**: Given the root of a binary tree, the value of a target node target, and an integer k, return an array of the values of all nodes that have distance k from the target node.

**Examples**:
```
Input: root = [3,5,1,6,2,0,8,null,null,7,4], target = 5, k = 2
Output: [7,4,1]
Explanation: The nodes that are a distance 2 from the target node (value 5) are 7, 4, and 1.

Input: root = [1], target = 1, k = 3
Output: []
```

**Solution Approach**:
- Convert tree to graph by adding parent pointers
- Use BFS from target node to find all nodes at distance k
- Time Complexity: O(n)
- Space Complexity: O(n)

**Code Implementation**:
```python
from collections import deque, defaultdict

def distanceK(root, target, k):
    # Build adjacency list (graph representation)
    graph = defaultdict(list)
    
    def build_graph(node, parent=None):
        if not node:
            return
        if parent:
            graph[node.val].append(parent.val)
            graph[parent.val].append(node.val)
        if node.left:
            build_graph(node.left, node)
        if node.right:
            build_graph(node.right, node)
    
    build_graph(root)
    
    # BFS from target node
    queue = deque([target])
    visited = set([target])
    distance = 0
    
    while queue and distance < k:
        size = len(queue)
        for _ in range(size):
            node = queue.popleft()
            for neighbor in graph[node]:
                if neighbor not in visited:
                    visited.add(neighbor)
                    queue.append(neighbor)
        distance += 1
    
    # Return nodes at distance k
    return list(queue)
```

### 41. Binary Tree Pruning
**Description**: Given the root of a binary tree, return the same tree where every subtree (of the given tree) not containing a 1 has been removed.

**Examples**:
```
Input: root = [1,null,0,0,1]
Output: [1,null,0,null,1]
Explanation: 
Only the red nodes satisfy the property "every subtree not containing a 1".
The diagram on the right shows the answer.
```

**Solution Approach**:
- Use post-order traversal
- For each node, check if left or right subtree contains 1
- If subtree doesn't contain 1, set it to None
- Return True if current subtree contains 1
- Time Complexity: O(n)
- Space Complexity: O(h)

**Code Implementation**:
```python
def pruneTree(root):
    def containsOne(node):
        if not node:
            return False
        
        # Check if left or right subtree contains 1
        left_contains = containsOne(node.left)
        right_contains = containsOne(node.right)
        
        # If subtree doesn't contain 1, remove it
        if not left_contains:
            node.left = None
        if not right_contains:
            node.right = None
        
        # Return True if current node or any subtree contains 1
        return node.val == 1 or left_contains or right_contains
    
    return root if containsOne(root) else None
```

### 42. Flip Equivalent Binary Trees
**Description**: For a binary tree T, we can define a flip operation as follows: choose any node, and swap the left and right child subtrees.

A binary tree X is flip equivalent to a binary tree Y if and only if we can make X equal to Y after some number of flip operations.

Given the roots of two binary trees root1 and root2, return true if the two trees are flip equivalent or false otherwise.

**Examples**:
```
Input: root1 = [1,2,3,4,5,6,null,null,null,7,8], root2 = [1,3,2,null,6,4,5,null,null,null,null,8,7]
Output: true
Explanation: We flipped at nodes with values 1, 3, and 5.
```

**Solution Approach**:
- Use recursion to compare trees
- Two trees are flip equivalent if:
  - Both are None → True
  - One is None → False
  - Root values are equal AND
    - (Left subtrees are equivalent AND Right subtrees are equivalent) OR
    - (Left subtree of first is equivalent to Right subtree of second AND Right subtree of first is equivalent to Left subtree of second)
- Time Complexity: O(min(n1, n2))
- Space Complexity: O(h)

**Code Implementation**:
```python
def flipEquiv(root1, root2):
    if not root1 and not root2:
        return True
    if not root1 or not root2:
        return False
    if root1.val != root2.val:
        return False
    
    # Check without flip or with flip
    return (flipEquiv(root1.left, root2.left) and flipEquiv(root1.right, root2.right)) or \
           (flipEquiv(root1.left, root2.right) and flipEquiv(root1.right, root2.left))
```

### 43. Cousins in Binary Tree
**Description**: In a binary tree, the root node is at depth 0, and children of each depth k node are at depth k+1.

Two nodes of a binary tree are cousins if they have the same depth, but have different parents.

We are given the root of a binary tree with unique values, and the values x and y of two different nodes in the tree. Return true if and only if the nodes corresponding to the values x and y are cousins.

**Examples**:
```
Input: root = [1,2,3,4], x = 4, y = 3
Output: false

Input: root = [1,2,3,4,5,6,7,8,9,10,11], x = 5, y = 6
Output: true
```

**Solution Approach**:
- Use BFS to traverse tree level by level
- Track parent and depth for x and y
- Check if they have same depth but different parents
- Time Complexity: O(n)
- Space Complexity: O(w)

**Code Implementation**:
```python
def isCousins(root, x, y):
    if not root:
        return False
    
    queue = deque([(root, None, 0)])  # (node, parent, depth)
    x_info = y_info = None
    
    while queue and (not x_info or not y_info):
        node, parent, depth = queue.popleft()
        
        if node.val == x:
            x_info = (parent, depth)
        if node.val == y:
            y_info = (parent, depth)
        
        if node.left:
            queue.append((node.left, node, depth + 1))
        if node.right:
            queue.append((node.right, node, depth + 1))
    
    # Check if same depth and different parents
    return x_info[0] != y_info[0] and x_info[1] == y_info[1]
```

### 44. Sum of Nodes with Even-Valued Grandparent
**Description**: Given the root of a binary tree, return the sum of values of nodes with an even-valued grandparent. If there are no nodes with an even-valued grandparent, return 0.

**Examples**:
```
Input: root = [6,7,8,2,7,1,3,9,null,1,4,null,null,null,5]
Output: 18
Explanation: The red nodes are the nodes with even-value grandparent while the blue nodes are the grandchildren.
```

**Solution Approach**:
- Use DFS to traverse the tree
- Pass parent and grandparent values down the recursion
- If grandparent value is even, add current node's value to sum
- Time Complexity: O(n)
- Space Complexity: O(h)

**Code Implementation**:
```python
def sumEvenGrandparent(root):
    def dfs(node, parent=None, grandparent=None):
        if not node:
            return 0
        
        # Add current node's value if grandparent exists and is even
        total = 0
        if grandparent and grandparent.val % 2 == 0:
            total += node.val
        
        # Recursively explore left and right subtrees
        total += dfs(node.left, node, parent)
        total += dfs(node.right, node, parent)
        
        return total
    
    return dfs(root)
```

### 45. Maximum Width of Binary Tree
**Description**: Given the root of a binary tree, return the maximum width of the given tree. The maximum width of a tree is the maximum width among all levels. The width of one level is defined as the length between the end-nodes (the leftmost and rightmost non-null nodes in the level, where the null nodes between the end-nodes are also counted into the length calculation.

**Examples**:
```
Input: root = [1,3,2,5,3,null,9]
Output: 4
Explanation: The maximum width existing in the third level with the value 4 (5,3,null,9).

Input: root = [1,3,2,5,null,null,9,6,null,7]
Output: 7
Explanation: The maximum width existing in the fourth level with the value 7 (6,null,null,null,null,null,7).
```

**Solution Approach**:
- Use BFS with indexing
- Assign index to each node (root = 0, left = 2*i+1, right = 2*i+2)
- For each level, width = rightmost_index - leftmost_index + 1
- Time Complexity: O(n)
- Space Complexity: O(w)

**Code Implementation**:
```python
def widthOfBinaryTree(root):
    if not root:
        return 0
    
    max_width = 0
    queue = deque([(root, 0)])  # (node, index)
    
    while queue:
        level_length = len(queue)
        _, first_index = queue[0]
        
        for i in range(level_length):
            node, index = queue.popleft()
            
            # Calculate width for this level
            if i == 0:
                left_index = index
            if i == level_length - 1:
                right_index = index
            
            # Add children to queue
            if node.left:
                queue.append((node.left, 2 * index))
            if node.right:
                queue.append((node.right, 2 * index + 1))
        
        # Update maximum width
        max_width = max(max_width, right_index - left_index + 1)
    
    return max_width
```

### 46. Print Binary Tree
**Description**: Print a binary tree in an m*n 2D string array following these rules:
1. The row number m should be equal to the height of the given binary tree.
2. The column number n should always be an odd number.
3. The root node's value (in string format) should be put in the exact middle of the first row it can be put in. The column where the root node's value belongs is calculated by the formula: (n-1)/2.
4. For each node that has been put in the array at position (r, c), its left child value should be put at position (r+1, c - 2^(height-r-1)) and its right child value should be put at position (r+1, c + 2^(height-r-1)).

**Examples**:
```
Input: root = [1,2,3,null,4]
Output: 
[["", "", "", "", "", "", "", ""],
 ["", "", "", "1", "", "", "", ""],
 ["", "", "2", "", "", "", "3", ""],
 ["", "4", "", "", "", "", "", ""]]

Input: root = [1,2,3,null,null,4,5]
Output: 
[["", "", "", "", "", "", "", "", ""],
 ["", "", "", "1", "", "", "", "", ""],
 ["", "2", "", "", "", "", "3", "", ""],
 ["", "", "4", "", "", "", "", "5", ""]]
```

**Solution Approach**:
- Calculate height of tree
- Create 2D array with dimensions height x (2^height - 1)
- Use DFS to place nodes in correct positions
- Time Complexity: O(m*n) where m = height, n = 2^height - 1
- Space Complexity: O(m*n)

**Code Implementation**:
```python
def printTree(root):
    def get_height(node):
        if not node:
            return 0
        return 1 + max(get_height(node.left), get_height(node.right))
    
    height = get_height(root)
    width = 2**height - 1
    result = [["" for _ in range(width)] for _ in range(height)]
    
    def fill_tree(node, row, left, right):
        if not node:
            return
        
        mid = (left + right) // 2
        result[row][mid] = str(node.val)
        
        fill_tree(node.left, row + 1, left, mid - 1)
        fill_tree(node.right, row + 1, mid + 1, right)
    
    fill_tree(root, 0, 0, width - 1)
    return result
```

### 47. Construct Binary Tree from Inorder and Postorder Traversal
**Description**: Given two integer arrays inorder and postorder where inorder is the inorder traversal of a binary tree and postorder is the postorder traversal of the same tree, construct and return the binary tree.

**Examples**
```
Input: inorder = [9,3,15,20,7], postorder = [9,15,7,20,3]
Output: [3,9,20,null,null,15,7]

Input: inorder = [-1], postorder = [-1]
Output: [-1]
```

**Solution Approach**:
- Last element in postorder is root
- Find root in inorder array; elements left form left subtree, elements right form right subtree
- Recursively build left and right subtrees
- Use hashmap for O(1) inorder lookup
- Time Complexity: O(n)
- Space Complexity: O(n)

**Code Implementation**:
```python
def buildTree(inorder, postorder):
    if not inorder or not postorder:
        return None
    
    # Create a map for inorder indices for O(1) lookup
    inorder_map = {val: idx for idx, val in enumerate(inorder)}
    
    def build(in_start, in_end, post_start, post_end):
        if in_start > in_end or post_start > post_end:
            return None
        
        # Last element in postorder is root
        root_val = postorder[post_end]
        root = TreeNode(root_val)
        
        # Find root position in inorder
        inorder_root_idx = inorder_map[root_val]
        
        # Number of elements in left subtree
        left_subtree_size = inorder_root_idx - in_start
        
        # Recursively build left and right subtrees
        root.left = build(in_start, 
                         inorder_root_idx - 1,
                         post_start, 
                         post_start + left_subtree_size - 1)
        
        root.right = build(inorder_root_idx + 1,
                          in_end,
                          post_start + left_subtree_size,
                          post_end - 1)
        
        return root
    
    return build(0, len(inorder)-1, 0, len(postorder)-1)
```

### 48. Convert Sorted List to Binary Search Tree
**Description**: Given the head of a singly linked list where elements are sorted in ascending order, convert it to a height-balanced BST.

**Examples**:
```
Input: head = [-10,-3,0,5,9]
Output: [0,-3,9,-10,null,5]
Explanation: One possible answer is [0,-3,9,-10,null,5], which represents the shown height-balanced BST.

Input: head = []
Output: []
```

**Solution Approach**:
- Find middle element using slow/fast pointers
- Make middle element the root
- Recursively build left subtree from left half
- Recursively build right subtree from right half
- Time Complexity: O(n log n)
- Space Complexity: O(log n) for recursion stack

**Code Implementation**:
```python
class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next

def sortedListToBST(head):
    if not head:
        return None
    if not head.next:
        return TreeNode(head.val)
    
    # Find middle using slow/fast pointers
    slow = fast = head
    prev = None
    
    while fast and fast.next:
        prev = slow
        slow = slow.next
        fast = fast.next.next
    
    # Disconnect left half
    if prev:
        prev.next = None
    
    # Make middle element the root
    root = TreeNode(slow.val)
    
    # Recursively build subtrees
    root.left = sortedListToBST(head)
    root.right = sortedListToBST(slow.next)
    
    return root

# Alternative: inorder simulation approach
def sortedListToBSTInorder(head):
    # Find size of list
    size = 0
    current = head
    while current:
        size += 1
        current = current.next
    
    # Use nonlocal variable to track current list node
    def convert(l, r):
        nonlocal head
        if l > r:
            return None
        
        mid = (l + r) // 2
        
        # Recursively form left half
        left = convert(l, mid - 1)
        
        # Create root node from current head
        root = TreeNode(head.val)
        head = head.next
        
        # Recursively form right half
        root.right = convert(mid + 1, r)
        
        root.left = left
        return root
    
    return convert(0, size - 1)
```

### 49. Path Sum III
**Description**: Given the root of a binary tree and an integer targetSum, return the number of paths where the sum of the values along the path equals targetSum. The path does not need to start or end at the root or a leaf, but it must go downwards (traveling only from parent to child).

**Examples**:
```
Input: root = [10,5,-3,3,2,null,11,3,-2,null,1], targetSum = 8
Output: 3
Explanation: The paths that sum to 8 are shown.
```

**Solution Approach**:
- Use DFS with prefix sum technique
- Keep track of cumulative sum from root to current node
- Use hashmap to store frequency of prefix sums
- For each node, check if (current_sum - targetSum) exists in prefix sums
- Time Complexity: O(n)
- Space Complexity: O(n)

**Code Implementation**:
```python
from collections import defaultdict

def pathSumIII(root, targetSum):
    def dfs(node, current_sum, prefix_sums):
        if not node:
            return 0
        
        current_sum += node.val
        
        # Count paths ending at current node
        count = prefix_sums.get(current_sum - targetSum, 0)
        
        # Add current sum to prefix_sums
        prefix_sums[current_sum] = prefix_sums.get(current_sum, 0) + 1
        
        # Recursively explore left and right subtrees
        count += dfs(node.left, current_sum, prefix_sums)
        count += dfs(node.right, current_sum, prefix_sums)
        
        # Remove current sum from prefix_sums (backtrack)
        prefix_sums[current_sum] -= 1
        if prefix_sums[current_sum] == 0:
            del prefix_sums[current_sum]
        
        return count
    
    return dfs(root, 0, defaultdict(int))
```

### 50. Binary Tree Right Side View (Alternative Approach)
**Description**: Given the root of a binary tree, imagine yourself standing on the right side of it, return the values of the nodes you can see ordered from top to bottom.

**Examples**:
```
Input: root = [1,2,3,null,5,null,4]
Output: [1,3,4]
```

**Solution Approach**:
- Use DFS with right-first traversal
- Keep track of maximum depth reached
- When visiting a node at new depth, add it to result
- Time Complexity: O(n)
- Space Complexity: O(h)

**Code Implementation**:
```python
def rightSideViewDFS(root):
    result = []
    max_depth = -1
    
    def dfs(node, depth):
        nonlocal max_depth
        if not node:
            return
        
        # If we're visiting this depth for the first time
        if depth > max_depth:
            result.append(node.val)
            max_depth = depth
        
        # Visit right subtree first, then left
        dfs(node.right, depth + 1)
        dfs(node.left, depth + 1)
    
    dfs(root, 0)
    return result
```

## Summary

This collection of tree problems covers a wide range of difficulty levels and concepts:

**Easy Problems** focus on:
- Basic tree traversals (inorder, preorder, postorder, level order)
- Tree properties validation (BST validation, symmetric tree)
- Simple tree modifications (invert tree, same tree)
- Path-related problems (path sum, diameter)
- Construction from sorted arrays

**Medium Problems** introduce:
- More complex path problems (maximum path sum, path sum II)
- Tree serialization and deserialization
- Level order variations (zigzag, vertical order)
- Pointer manipulation (next right pointers)
- Special tree constructions (from strings, subtrees)
- Optimization problems (cameras, consecutive sequences)

**Hard Problems** challenge:
- Complex tree transformations (upside down, recover BST)
- Advanced traversal techniques (distance K, cousins)
- Tree pruning and modification
- Complex path counting (path sum III)
- Tree comparison and equivalence
- Sophisticated tree constructions (from various traversals)
- Memory and time optimization techniques

These problems collectively cover essential tree concepts including:
- Tree traversals (DFS, BFS, variations)
- Binary Search Tree properties and operations
- Tree modification and transformation
- Path and distance calculations
- Tree construction from various representations
- Optimization and greedy approaches on trees
- Advanced tree properties (balance, symmetry, completeness)

Each problem includes:
- Clear problem description
- Examples with expected outputs
- Step-by-step solution approach
- Time and space complexity analysis
- Working code implementations in Python
- Alternative approaches where applicable

Practicing these problems will help develop strong intuition for tree-based problem solving and prepare for technical interviews at top technology companies.