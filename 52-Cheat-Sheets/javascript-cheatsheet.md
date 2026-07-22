# JavaScript Cheat Sheet for DSA

Quick reference for JavaScript ES6+ data structures, algorithms, and common patterns.

---

## Variables and Data Types

```javascript
// Variables
let x = 10;            // Mutable, block scoped
const y = 3.14;        // Immutable binding, block scoped
var z = "old way";     // Function scoped (avoid)

// Types
typeof "hello"         // "string"
typeof 42              // "number"
typeof true            // "boolean"
typeof undefined       // "undefined"
typeof null            // "object" (bug)
typeof {}              // "object"
typeof []              // "object"
```

---

## Built-in Data Structures

### Arrays

```javascript
// Creation
const arr = [1, 2, 3, 4, 5];
const empty = [];
const filled = Array(5).fill(0);  // [0, 0, 0, 0, 0]

// Methods
arr.push(6);            // Add to end
arr.unshift(0);         // Add to beginning
arr.pop();              // Remove from end
arr.shift();            // Remove from beginning
arr.splice(1, 2);       // Remove 2 elements at index 1
arr.indexOf(3);         // Find index (-1 if not found)
arr.includes(3);        // Check if exists (true/false)
arr.find(x => x > 3);  // Find first match
arr.findIndex(x => x > 3);  // Find index of first match

// Sorting
arr.sort((a, b) => a - b);  // Ascending numbers
arr.sort((a, b) => b - a);  // Descending numbers
arr.reverse();               // Reverse in place

// Transform
const mapped = arr.map(x => x * 2);
const filtered = arr.filter(x => x > 2);
const reduced = arr.reduce((acc, x) => acc + x, 0);
const found = arr.some(x => x > 3);    // Boolean
const every = arr.every(x => x > 0);   // Boolean
const flat = arr.flat();               // Flatten nested

// Slicing (doesn't modify original)
arr.slice(1, 3);     // Elements at index 1, 2
arr.slice(-2);       // Last 2 elements
arr.slice();         // Shallow copy

// Spread operator
const newArr = [...arr, 7, 8];
const copy = [...arr];
```

### Objects

```javascript
// Creation
const obj = { name: "Alice", age: 30 };
const empty = {};
const fromEntries = Object.fromEntries([["a", 1], ["b", 2]]);

// Access
obj.name           // Dot notation
obj["name"]        // Bracket notation
obj.email          // undefined (no error)

// Methods
Object.keys(obj);      // ["name", "age"]
Object.values(obj);    // ["Alice", 30]
Object.entries(obj);   // [["name", "Alice"], ["age", 30]]
Object.assign({}, obj);  // Shallow copy
Object.freeze(obj);    // Make immutable

// Spread operator
const newObj = { ...obj, email: "a@b.com" };
```

### Maps

```javascript
// Creation
const map = new Map();
map.set("key1", "value1");
map.set("key2", "value2");

// Operations
map.get("key1");        // "value1"
map.has("key1");        // true
map.size;               // 2
map.delete("key1");
map.clear();

// Iteration
for (const [key, value] of map) {
    console.log(key, value);
}

// From object
const mapFromObj = new Map(Object.entries(obj));
```

### Sets

```javascript
// Creation
const set = new Set([1, 2, 3, 3]);  // {1, 2, 3}
const empty = new Set();

// Operations
set.add(4);
set.has(2);         // true
set.size;           // 3
set.delete(1);

// Set operations
const setA = new Set([1, 2, 3]);
const setB = new Set([2, 3, 4]);

const union = new Set([...setA, ...setB]);
const intersection = new Set([...setA].filter(x => setB.has(x)));
const difference = new Set([...setA].filter(x => !setB.has(x)));
```

---

## Destructuring

```javascript
// Array destructuring
const [a, b, ...rest] = [1, 2, 3, 4, 5];  // a=1, b=2, rest=[3,4,5]
const [x, , z] = [1, 2, 3];  // Skip middle: x=1, z=3

// Object destructuring
const { name, age, email = "N/A" } = user;
const { name: userName } = user;  // Rename variable

// Function parameter destructuring
function greet({ name, age }) {
    return `Hello ${name}, you are ${age}`;
}
```

---

## Stacks and Queues

### Stack

```javascript
class Stack {
    constructor() {
        this.items = [];
    }

    push(item) {
        this.items.push(item);
    }

    pop() {
        if (!this.isEmpty()) {
            return this.items.pop();
        }
        throw new Error("Stack is empty");
    }

    peek() {
        if (!this.isEmpty()) {
            return this.items[this.items.length - 1];
        }
        throw new Error("Stack is empty");
    }

    isEmpty() {
        return this.items.length === 0;
    }

    size() {
        return this.items.length;
    }
}
```

### Queue

```javascript
class Queue {
    constructor() {
        this.items = {};
        this.head = 0;
        this.tail = 0;
    }

    enqueue(item) {
        this.items[this.tail] = item;
        this.tail++;
    }

    dequeue() {
        if (this.isEmpty()) {
            throw new Error("Queue is empty");
        }
        const item = this.items[this.head];
        delete this.items[this.head];
        this.head++;
        return item;
    }

    front() {
        if (!this.isEmpty()) {
            return this.items[this.head];
        }
        throw new Error("Queue is empty");
    }

    isEmpty() {
        return this.head === this.tail;
    }

    size() {
        return this.tail - this.head;
    }
}
```

---

## Linked List

```javascript
class ListNode {
    constructor(val = 0, next = null) {
        this.val = val;
        this.next = next;
    }
}

class LinkedList {
    constructor() {
        this.head = null;
    }

    addFirst(val) {
        this.head = new ListNode(val, this.head);
    }

    addLast(val) {
        if (!this.head) {
            this.head = new ListNode(val);
            return;
        }
        let curr = this.head;
        while (curr.next) {
            curr = curr.next;
        }
        curr.next = new ListNode(val);
    }

    remove(val) {
        const dummy = new ListNode(0, this.head);
        let prev = dummy;
        let curr = this.head;
        while (curr) {
            if (curr.val === val) {
                prev.next = curr.next;
                break;
            }
            prev = curr;
            curr = curr.next;
        }
        this.head = dummy.next;
    }

    find(val) {
        let curr = this.head;
        while (curr) {
            if (curr.val === val) {
                return curr;
            }
            curr = curr.next;
        }
        return null;
    }
}
```

---

## Binary Tree

```javascript
class TreeNode {
    constructor(val = 0, left = null, right = null) {
        this.val = val;
        this.left = left;
        this.right = right;
    }
}

function inorder(root) {
    if (!root) return [];
    return [...inorder(root.left), root.val, ...inorder(root.right)];
}

function preorder(root) {
    if (!root) return [];
    return [root.val, ...preorder(root.left), ...preorder(root.right)];
}

function postorder(root) {
    if (!root) return [];
    return [...postorder(root.left), ...postorder(root.right), root.val];
}
```

---

## Graph

```javascript
// Adjacency list
const graph = {
    'A': ['B', 'C'],
    'B': ['A', 'D'],
    'C': ['A', 'D'],
    'D': ['B', 'C']
};

// BFS
function bfs(graph, start) {
    const visited = new Set([start]);
    const queue = [start];
    const result = [];
    while (queue.length) {
        const node = queue.shift();
        result.push(node);
        for (const neighbor of graph[node]) {
            if (!visited.has(neighbor)) {
                visited.add(neighbor);
                queue.push(neighbor);
            }
        }
    }
    return result;
}

// DFS (iterative)
function dfs(graph, start) {
    const visited = new Set();
    const stack = [start];
    const result = [];
    while (stack.length) {
        const node = stack.pop();
        if (!visited.has(node)) {
            visited.add(node);
            result.push(node);
            for (const neighbor of graph[node]) {
                if (!visited.has(neighbor)) {
                    stack.push(neighbor);
                }
            }
        }
    }
    return result;
}
```

---

## Sorting Algorithms

```javascript
// Bubble Sort - O(n²)
function bubbleSort(arr) {
    const n = arr.length;
    for (let i = 0; i < n; i++) {
        for (let j = 0; j < n - i - 1; j++) {
            if (arr[j] > arr[j + 1]) {
                [arr[j], arr[j + 1]] = [arr[j + 1], arr[j]];
            }
        }
    }
    return arr;
}

// Merge Sort - O(n log n)
function mergeSort(arr) {
    if (arr.length <= 1) return arr;
    const mid = Math.floor(arr.length / 2);
    const left = mergeSort(arr.slice(0, mid));
    const right = mergeSort(arr.slice(mid));
    return merge(left, right);
}

function merge(left, right) {
    const result = [];
    let i = j = 0;
    while (i < left.length && j < right.length) {
        if (left[i] <= right[j]) {
            result.push(left[i++]);
        } else {
            result.push(right[j++]);
        }
    }
    return result.concat(left.slice(i), right.slice(j));
}
```

---

## Common Algorithms

```javascript
// Binary Search - O(log n)
function binarySearch(arr, target) {
    let left = 0, right = arr.length - 1;
    while (left <= right) {
        const mid = Math.floor((left + right) / 2);
        if (arr[mid] === target) return mid;
        if (arr[mid] < target) left = mid + 1;
        else right = mid - 1;
    }
    return -1;
}

// Two Pointers
function twoSum(arr, target) {
    let left = 0, right = arr.length - 1;
    while (left < right) {
        const sum = arr[left] + arr[right];
        if (sum === target) return [left, right];
        if (sum < target) left++;
        else right--;
    }
    return [];
}

// Sliding Window
function maxSubarraySum(arr, k) {
    let windowSum = arr.slice(0, k).reduce((a, b) => a + b, 0);
    let maxSum = windowSum;
    for (let i = k; i < arr.length; i++) {
        windowSum += arr[i] - arr[i - k];
        maxSum = Math.max(maxSum, windowSum);
    }
    return maxSum;
}
```

---

## Important Methods

```javascript
// Array methods
Array.isArray([]);
[].length;
[1, 2, 3].toString();  // "1,2,3"

// Object methods
Object.keys({a: 1});
Object.values({a: 1});
Object.entries({a: 1});
Object.fromEntries([["a", 1]]);

// Spread/rest
const arr = [1, 2, 3];
const copy = [...arr];
const [first, ...rest] = arr;

// Optional chaining
user?.address?.city;
arr?.[0];

// Nullish coalescing
const value = null ?? "default";  // "default"
const value2 = 0 ?? "default";    // 0
```

---

## Common Patterns

### Memoization

```javascript
function memoize(fn) {
    const cache = new Map();
    return function(...args) {
        const key = JSON.stringify(args);
        if (cache.has(key)) {
            return cache.get(key);
        }
        const result = fn.apply(this, args);
        cache.set(key, result);
        return result;
    };
}
```

### Debounce

```javascript
function debounce(fn, delay) {
    let timeoutId;
    return function(...args) {
        clearTimeout(timeoutId);
        timeoutId = setTimeout(() => fn.apply(this, args), delay);
    };
}
```

### Throttle

```javascript
function throttle(fn, limit) {
    let inThrottle;
    return function(...args) {
        if (!inThrottle) {
            fn.apply(this, args);
            inThrottle = true;
            setTimeout(() => inThrottle = false, limit);
        }
    };
}
```
