# Linked List Problems

## Easy Problems

### 1. Reverse a Linked List
**Problem**: Given the head of a singly linked list, reverse the list, and return the reversed list.

**Example**:
```
Input: head = [1,2,3,4,5]
Output: [5,4,3,2,1]
```

**Solution Approach**:
- Use three pointers: prev, current, and next
- Iterate through the list, reversing the direction of pointers
- Time: O(n), Space: O(1)

**Python Solution**:
```python
def reverse_list(head):
    prev = None
    current = head
    
    while current:
        next_node = current.next
        current.next = prev
        prev = current
        current = next_node
    
    return prev
```

### 2. Merge Two Sorted Lists
**Problem**: Merge two sorted linked lists and return it as a sorted list. The list should be made by splicing together the nodes of the first two lists.

**Example**:
```
Input: l1 = [1,2,4], l2 = [1,3,4]
Output: [1,1,2,3,4,4]
```

**Solution Approach**:
- Use a dummy node to simplify edge cases
- Compare nodes from both lists and append the smaller one
- Time: O(n+m), Space: O(1)

**Python Solution**:
```python
def merge_two_lists(l1, l2):
    dummy = ListNode(0)
    current = dummy
    
    while l1 and l2:
        if l1.val < l2.val:
            current.next = l1
            l1 = l1.next
        else:
            current.next = l2
            l2 = l2.next
        current = current.next
    
    current.next = l1 if l1 else l2
    return dummy.next
```

### 3. Remove Linked List Elements
**Problem**: Given the head of a linked list and an integer val, remove all the nodes of the linked list that has Node.val == val, and return the new head.

**Example**:
```
Input: head = [1,2,6,3,4,5,6], val = 6
Output: [1,2,3,4,5]
```

**Solution Approach**:
- Use a dummy node to handle edge cases (like removing head)
- Iterate through list, skipping nodes with target value
- Time: O(n), Space: O(1)

**Python Solution**:
```python
def remove_elements(head, val):
    dummy = ListNode(0)
    dummy.next = head
    current = dummy
    
    while current.next:
        if current.next.val == val:
            current.next = current.next.next
        else:
            current = current.next
    
    return dummy.next
```

### 4. Palindrome Linked List
**Problem**: Given the head of a singly linked list, return true if it is a palindrome or false otherwise.

**Example**:
```
Input: head = [1,2,2,1]
Output: true
```

**Solution Approach**:
- Find middle using slow/fast pointers
- Reverse second half
- Compare first half and reversed second half
- Restore list (optional)
- Time: O(n), Space: O(1)

**Python Solution**:
```python
def is_palindrome(head):
    if not head or not head.next:
        return True
    
    # Find middle
    slow = fast = head
    while fast.next and fast.next.next:
        slow = slow.next
        fast = fast.next.next
    
    # Reverse second half
    second_half_start = reverse_list(slow.next)
    
    # Compare halves
    first_half = head
    second_half = second_half_start
    result = True
    
    while second_half:
        if first_half.val != second_half.val:
            result = False
            break
        first_half = first_half.next
        second_half = second_half.next
    
    # Restore list (optional)
    slow.next = reverse_list(second_half_start)
    
    return result

def reverse_list(head):
    prev = None
    while head:
        next_node = head.next
        head.next = prev
        prev = head
        head = next_node
    return prev
```

### 5. Linked List Cycle
**Problem**: Given head, the head of a linked list, determine if the linked list has a cycle in it.

**Example**:
```
Input: head = [3,2,0,-4], pos = 1
Output: true
Explanation: There is a cycle in the linked list, where the tail connects to the 1st node (0-indexed).
```

**Solution Approach**:
- Use Floyd's Tortoise and Hare algorithm
- Slow pointer moves 1 step, fast pointer moves 2 steps
- If there's a cycle, they will meet
- Time: O(n), Space: O(1)

**Python Solution**:
```python
def has_cycle(head):
    slow = fast = head
    
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next
        if slow == fast:
            return True
    
    return False
```

## Medium Problems

### 1. Copy List with Random Pointer
**Problem**: A linked list of length n is given such that each node contains an additional random pointer, which could point to any node in the list, or null.

Construct a deep copy of the list. The deep copy should consist of exactly n brand new nodes, where each new node has its value set to the value of its corresponding original node. Both the next and random pointer of the new nodes should point to new nodes in the copied list such that the pointers in the original list and copied list represent the same list state.

**Example**:
```
Input: head = [[7,null],[13,0],[11,4],[10,2],[1,0]]
Output: [[7,null],[13,0],[11,4],[10,2],[1,0]]
```

**Solution Approach**:
- Interweave copied nodes with original nodes
- Assign random pointers for copied nodes
- Separate the two lists
- Time: O(n), Space: O(1)

**Python Solution**:
```python
def copy_random_list(head):
    if not head:
        return None
    
    # Step 1: Insert copied nodes after original nodes
    current = head
    while current:
        new_node = Node(current.val)
        new_node.next = current.next
        current.next = new_node
        current = new_node.next
    
    # Step 2: Assign random pointers for copied nodes
    current = head
    while current:
        if current.random:
            current.next.random = current.random.next
        current = current.next.next
    
    # Step 3: Separate the two lists
    current = head
    new_head = head.next
    while current:
        copy = current.next
        current.next = copy.next
        if copy.next:
            copy.next = copy.next.next
        current = current.next
    
    return new_head
```

### 2. Intersection of Two Linked Lists
**Problem**: Given the heads of two singly linked-lists headA and headB, return the node at which the two lists intersect. If the two linked lists have no intersection at all, return null.

**Example**:
```
Input: intersectVal = 8, listA = [4,1,8,4,5], listB = [5,6,1,8,4,5]
Output: Intersected at '8'
```

**Solution Approach**:
- Calculate lengths of both lists
- Advance the pointer of longer list by the difference in lengths
- Then move both pointers together until they meet
- Time: O(n+m), Space: O(1)

**Python Solution**:
```python
def get_intersection_node(headA, headB):
    if not headA or not headB:
        return None
    
    # Get lengths of both lists
    lenA, lenB = 0, 0
    current = headA
    while current:
        lenA += 1
        current = current.next
    
    current = headB
    while current:
        lenB += 1
        current = current.next
    
    # Advance the longer list's pointer
    currA, currB = headA, headB
    if lenA > lenB:
        for _ in range(lenA - lenB):
            currA = currA.next
    else:
        for _ in range(lenB - lenA):
            currB = currB.next
    
    # Move both pointers until they meet
    while currA and currB:
        if currA == currB:
            return currA
        currA = currA.next
        currB = currB.next
    
    return None
```

### 3. LRU Cache
**Problem**: Design a data structure that follows the constraints of a Least Recently Used (LRU) cache.

Implement the LRUCache class:
- LRUCache(int capacity) Initialize the LRU cache with positive size capacity.
- int get(int key) Return the value of the key if the key exists, otherwise return -1.
- void put(int key, int value) Update the value of the key if the key exists. Otherwise, add the key-value pair to the cache. If the number of keys exceeds the capacity from this operation, evict the least recently used key.

**Example**:
```
Input
["LRUCache", "put", "put", "get", "put", "get", "put", "get", "get", "get"]
[[2],     [1, 1], [2, 2], [1],    [3, 3], [2],    [4, 4], [1],    [3],    [4]]
Output
[null, null, null, 1, null, -1, null, -1, 3, 4]
```

**Solution Approach**:
- Use hashmap for O(1) lookup
- Use doubly linked list to maintain order of usage
- Most recently used at head, least recently used at tail
- Time: O(1) for both get and put

**Python Solution**:
```python
class Node:
    def __init__(self, key=0, value=0):
        self.key = key
        self.value = value
        self.prev = None
        self.next = None

class LRUCache:
    def __init__(self, capacity: int):
        self.capacity = capacity
        self.cache = {}
        
        # Dummy head and tail
        self.head = Node()
        self.tail = Node()
        self.head.next = self.tail
        self.tail.prev = self.head
    
    def _remove(self, node):
        """Remove node from linked list"""
        prev_node = node.prev
        next_node = node.next
        prev_node.next = next_node
        next_node.prev = prev_node
    
    def _add_to_head(self, node):
        """Add node right after head"""
        node.prev = self.head
        node.next = self.head.next
        self.head.next.prev = node
        self.head.next = node
    
    def _move_to_head(self, node):
        """Move existing node to head"""
        self._remove(node)
        self._add_to_head(node)
    
    def _pop_tail(self):
        """Remove and return the tail node (LRU item)"""
        res = self.tail.prev
        self._remove(res)
        return res
    
    def get(self, key: int) -> int:
        node = self.cache.get(key)
        if not node:
            return -1
        # Move accessed node to head (most recently used)
        self._move_to_head(node)
        return node.value
    
    def put(self, key: int, value: int) -> None:
        node = self.cache.get(key)
        if not node:
            # Key doesn't exist, create new node
            new_node = Node(key, value)
            self.cache[key] = new_node
            self._add_to_head(new_node)
            
            # Check capacity
            if len(self.cache) > self.capacity:
                # Remove LRU item
                tail = self._pop_tail()
                del self.cache[tail.key]
        else:
            # Key exists, update value and move to head
            node.value = value
            self._move_to_head(node)
```

### 4. Reorder List
**Problem**: You are given the head of a singly linked-list. The list can be represented as:
L0 → L1 → … → Ln - 1 → Ln
Reorder the list to be on the following form:
L0 → Ln → L1 → Ln - 1 → L2 → Ln - 2 → …
You may not modify the values in the list's nodes. Only nodes themselves may be changed.

**Example**:
```
Input: head = [1,2,3,4]
Output: [1,4,2,3]
```

**Solution Approach**:
- Find middle of list using slow/fast pointers
- Reverse second half of list
- Merge two halves alternately
- Time: O(n), Space: O(1)

**Python Solution**:
```python
def reorder_list(head):
    if not head or not head.next:
        return
    
    # Find middle of list
    slow = fast = head
    while fast.next and fast.next.next:
        slow = slow.next
        fast = fast.next.next
    
    # Reverse second half
    second = slow.next
    prev = None
    while second:
        next_temp = second.next
        second.next = prev
        prev = second
        second = next_temp
    slow.next = None  # Terminate first half
    
    # Merge two halves
    first, second = head, prev
    while second:
        # Save next pointers
        temp1 = first.next
        temp2 = second.next
        
        # Link nodes
        first.next = second
        second.next = temp1
        
        # Move pointers
        first = temp1
        second = temp2
```

### 5. Remove Nth Node From End of List
**Problem**: Given the head of a linked list, remove the nth node from the end of the list and return its head.

**Example**:
```
Input: head = [1,2,3,4,5], n = 2
Output: [1,2,3,5]
```

**Solution Approach**:
- Use two pointers with distance n between them
- When first pointer reaches end, second pointer is at node to remove
- Use dummy node to handle edge case of removing head
- Time: O(n), Space: O(1)

**Python Solution**:
```python
def remove_nth_from_end(head, n):
    dummy = ListNode(0)
    dummy.next = head
    first = second = dummy
    
    # Advance first pointer n+1 steps
    for _ in range(n + 1):
        first = first.next
    
    # Move both pointers until first reaches end
    while first:
        first = first.next
        second = second.next
    
    # Skip the target node
    second.next = second.next.next
    return dummy.next
```

## Hard Problems

### 1. Sort List
**Problem**: Given the head of a linked list, return the list after sorting it in ascending order.

**Example**:
```
Input: head = [4,2,1,3]
Output: [1,2,3,4]
```

**Solution Approach**:
- Use merge sort for linked lists
- Find middle using slow/fast pointers
- Recursively sort both halves
- Merge two sorted lists
- Time: O(n log n), Space: O(log n) due to recursion

**Python Solution**:
```python
def sort_list(head):
    if not head or not head.next:
        return head
    
    # Split the list into two halves
    slow = fast = head
    prev = None
    while fast and fast.next:
        prev = slow
        slow = slow.next
        fast = fast.next.next
    
    # Terminate first half
    prev.next = None
    
    # Recursively sort both halves
    left = sort_list(head)
    right = sort_list(slow)
    
    # Merge sorted halves
    return merge_two_lists(left, right)

def merge_two_lists(l1, l2):
    dummy = ListNode(0)
    current = dummy
    
    while l1 and l2:
        if l1.val < l2.val:
            current.next = l1
            l1 = l1.next
        else:
            current.next = l2
            l2 = l2.next
        current = current.next
    
    current.next = l1 if l1 else l2
    return dummy.next
```

### 2. Copy List with Random Pointer
**Problem**: A linked list of length n is given such that each node contains an additional random pointer, which could point to any node in the list, or null.

Construct a deep copy of the list. The deep copy should consist of exactly n brand new nodes, where each new node has its value set to the value of its corresponding original node. Both the next and random pointer of the new nodes should point to new nodes in the copied list such that the pointers in the original list and copied list represent the same list state.

**Example**:
```
Input: head = [[7,null],[13,0],[11,4],[10,2],[1,0]]
Output: [[7,null],[13,0],[11,4],[10,2],[1,0]]
```

**Solution Approach**:
- Interweave copied nodes with original nodes
- Assign random pointers for copied nodes
- Separate the two lists
- Time: O(n), Space: O(1)

**Python Solution**:
```python
def copy_random_list(head):
    if not head:
        return None
    
    # Step 1: Insert copied nodes after original nodes
    current = head
    while current:
        new_node = Node(current.val)
        new_node.next = current.next
        current.next = new_node
        current = new_node.next
    
    # Step 2: Assign random pointers for copied nodes
    current = head
    while current:
        if current.random:
            current.next.random = current.result.next
        current = current.next.next
    
    # Step 3: Separate the two lists
    current = head
    new_head = head.next
    while current:
        copy = current.next
        current.next = copy.next
        if copy.next:
            copy.next = copy.next.next
        current = current.next
    
    return new_head
```

### 3. Flatten Multilevel Doubly Linked List
**Problem**: You are given a doubly linked list which in addition to the next and previous pointers, it could have a child pointer, which may or may not point to a separate doubly linked list. These child lists may have one or more children of their own, and so on, to produce a multilevel data structure, as shown in the example below.

Flatten the list so that all the nodes appear in a single-level, doubly linked list. You are given the head of the first level of the list.

**Example**:
```
Input: head = [1,2,3,4,5,6,null,null,null,7,8,9,10,null,null,11,12]
Output: [1,2,3,7,8,11,12,9,10,4,5,6]
```

**Solution Approach**:
- Use DFS or iterative approach with stack
- When encountering a child, flatten it and insert it after current node
- Time: O(n), Space: O(n) worst case (for stack)

**Python Solution**:
```python
def flatten(head):
    if not head:
        return None
    
    # pseudo head to ensure the `prev` pointer is never none
    pseudo_head = Node(0, None, head, None)
    
    prev = pseudo_head
    
    stack = []
    if head:
        stack.append(head)
    
    while stack:
        curr = stack.pop()
        
        prev.next = curr
        curr.prev = prev
        
        # push next and child nodes to stack
        # note that we push next first so that it is processed after child
        if curr.next:
            stack.append(curr.next)
        if curr.child:
            stack.append(curr.child)
            # don't forget to remove all child pointers
            curr.child = None
        
        prev = curr
    
    # detach the pseudo head from the real result
    pseudo_head.next.prev = None
    return pseudo_head.next
```

### 4. Add Two Numbers
**Problem**: You are given two non-empty linked lists representing two non-negative integers. The digits are stored in reverse order, and each of their nodes contains a single digit. Add the two numbers and return the sum as a linked list.

You may assume the two numbers do not contain any leading zero, except the number 0 itself.

**Example**:
```
Input: l1 = [2,4,3], l2 = [5,6,4]
Output: [7,0,8]
Explanation: 342 + 465 = 807.
```

**Solution Approach**:
- Traverse both lists simultaneously
- Add corresponding digits along with carry
- Create new node for sum digit
- Handle carry for next iteration
- Time: O(max(m,n)), Space: O(max(m,n))

**Python Solution**:
```python
def add_two_numbers(l1, l2):
    dummy = ListNode(0)
    current = dummy
    carry = 0
    
    while l1 or l2 or carry:
        val1 = l1.val if l1 else 0
        val2 = l2.val if l2 else 0
        
        total = val1 + val2 + carry
        carry = total // 10
        digit = total % 10
        
        current.next = ListNode(digit)
        current = current.next
        
        if l1:
            l1 = l1.next
        if l2:
            l2 = l2.next
    
    return dummy.next
```

### 5. Partition List
**Problem**: Given the head of a linked list and a value x, partition it such that all nodes less than x come before nodes greater than or equal to x.

You should preserve the original relative order of the nodes in each of the two partitions.

**Example**:
```
Input: head = [1,4,3,2,5,2], x = 3
Output: [1,2,2,4,3,5]
```

**Solution Approach**:
- Create two dummy heads: one for nodes < x, one for nodes >= x
- Traverse original list and append nodes to appropriate list
- Connect the two lists
- Time: O(n), Space: O(1)

**Python Solution**:
```python
def partition(head, x):
    # Two dummy heads for two lists
    before_head = ListNode(0)
    after_head = ListNode(0)
    
    before = before_head
    after = after_head
    
    while head:
        if head.val < x:
            before.next = head
            before = before.next
        else:
            after.next = head
            after = after.next
        
        head = head.next
    
    # Connect the two lists
    after.next = None
    before.next = after_head.next
    
    return before_head.next
```

## Additional Practice Problems

### Easy
1. Delete a node in a linked list (given only access to that node)
2. Find the middle of the linked list
3. Convert sorted list to binary search tree
4. Linked list cycle II (find where cycle begins)
5. Odd even linked list
6. Delete duplicates from sorted list
7. Delete duplicates from unsorted list (using hash set)
8. Intersection of two linked lists II (return node values)
9. Palindrome linked list (using stack)
10. Convert binary number in linked list to integer

### Medium
1. Rotate list
2. Split linked list in parts
3. Swap nodes in pairs
4. Reverse nodes in k-group
5. Copy list with random pointer (already covered)
6. LRU cache (already covered)
7. Insertion sort list
8. Sort list (already covered)
9. Maximum twin sum of a linked list
10. Remove zero sum consecutive nodes from linked list

### Hard
1. Flatten multilevel doubly linked list (already covered)
2. Add two numbers (already covered)
3. Add two numbers II (forward order)
4. Reorder list (already covered)
5. Remove nth node from end of list (already covered)
6. Partition list (already covered)
7. Design linked list
8. Add two polynomials represented as linked lists
9. Merge k sorted lists
10. Convert binary search tree to sorted doubly linked list

## Summary
Linked lists are fundamental data structures that excel in scenarios requiring frequent insertions and deletions. Mastering linked list manipulation is crucial for technical interviews as they test pointer manipulation skills, edge case handling, and algorithmic thinking.

Key patterns to remember:
- **Two pointers (fast/slow)**: For finding middle, detecting cycles, etc.
- **Dummy nodes**: To simplify edge cases (especially head modifications)
- **In-place reversal**: Using three pointers (prev, current, next)
- **Recursive approaches**: For problems like merge sort on linked lists
- **Hash maps**: For problems requiring O(1) lookups (like copy with random pointer)
- **Multiple lists**: Splitting into sublists and recombining (like partition problem)

When solving linked list problems, always consider:
1. Edge cases: empty list, single element, two elements
2. Memory management: especially in languages without garbage collection
3. Preserving original structure: if required to not modify the input
4. Time and space complexity: aiming for optimal solutions
5. Clarity: using meaningful variable names and comments for complex pointer manipulations