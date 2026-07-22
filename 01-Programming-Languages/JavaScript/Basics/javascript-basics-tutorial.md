# JavaScript Basics Tutorial

## Variables and Data Types

```javascript
// Variables
let name = "Alice";      // Mutable
const age = 30;          // Immutable
var score = 100;         // Old way (avoid)

// Data types
let str = "Hello";       // String
let num = 42;            // Number
let dec = 3.14;          // Number (decimal)
let bool = true;         // Boolean
let nothing = null;      // Null
let notDefined;          // Undefined
let id = Symbol('id');   // Symbol
let big = 9007199254740991n; // BigInt

console.log(`Name: ${name}, Age: ${age}`);
```

## Control Flow

### If-Else
```javascript
if (age >= 18) {
    console.log("Adult");
} else if (age >= 13) {
    console.log("Teenager");
} else {
    console.log("Child");
}

// Ternary operator
let status = age >= 18 ? "Adult" : "Minor";
```

### Switch
```javascript
switch (day) {
    case "Monday":
        console.log("Start of week");
        break;
    case "Friday":
        console.log("Almost weekend");
        break;
    default:
        console.log("Midweek");
}
```

### Loops
```javascript
// For loop
for (let i = 0; i < 5; i++) {
    console.log(i);
}

// For...of (arrays)
let nums = [1, 2, 3, 4, 5];
for (let n of nums) {
    console.log(n);
}

// For...in (objects)
let person = {name: "Alice", age: 30};
for (let key in person) {
    console.log(`${key}: ${person[key]}`);
}

// While loop
let count = 5;
while (count > 0) {
    console.log(count);
    count--;
}
```

## Functions

```javascript
// Function declaration
function add(a, b) {
    return a + b;
}

// Arrow function
const multiply = (a, b) => a * b;

// Default parameters
function greet(name = "World") {
    console.log(`Hello, ${name}!`);
}

// Rest parameters
function sum(...numbers) {
    return numbers.reduce((a, b) => a + b, 0);
}

// Callback
function processArray(arr, callback) {
    return arr.map(callback);
}
```

## Arrays

```javascript
let arr = [1, 2, 3, 4, 5];

// Methods
arr.push(6);           // Add to end
arr.pop();             // Remove from end
arr.unshift(0);        // Add to start
arr.shift();           // Remove from start
arr.includes(3);       // Check if exists
arr.indexOf(3);        // Find index

// Higher-order methods
arr.map(x => x * 2);           // Transform
arr.filter(x => x > 2);        // Filter
arr.reduce((a, b) => a + b, 0); // Sum
arr.find(x => x > 3);          // Find first
arr.every(x => x > 0);         // All match
arr.some(x => x > 4);          // Any match

// Spread operator
let combined = [...arr, 6, 7, 8];

// Destructuring
let [first, second, ...rest] = arr;
```

## Objects

```javascript
let person = {
    name: "Alice",
    age: 30,
    greet() {
        console.log(`Hello, I'm ${this.name}`);
    }
};

// Access
console.log(person.name);
console.log(person["age"]);

// Add/modify
person.email = "alice@example.com";
person.age = 31;

// Destructuring
let { name, age } = person;

// Spread
let updated = { ...person, age: 32 };
```

## Classes

```javascript
class Person {
    constructor(name, age) {
        this.name = name;
        this.age = age;
    }
    
    greet() {
        console.log(`Hello, I'm ${this.name}`);
    }
    
    static create(name, age) {
        return new Person(name, age);
    }
}

class Student extends Person {
    constructor(name, age, grade) {
        super(name, age);
        this.grade = grade;
    }
    
    study() {
        console.log(`${this.name} is studying`);
    }
}
```

## Async/Await

```javascript
// Promise
function fetchData() {
    return new Promise((resolve) => {
        setTimeout(() => resolve("Data loaded"), 1000);
    });
}

// Async/await
async function loadData() {
    try {
        const data = await fetchData();
        console.log(data);
    } catch (error) {
        console.error(error);
    }
}

// Fetch API
async function getUser() {
    const response = await fetch('https://api.example.com/user');
    const data = await response.json();
    return data;
}
```

## ES6+ Features

```javascript
// Template literals
let msg = `Hello, ${name}!`;

// Optional chaining
let city = person?.address?.city;

// Nullish coalescing
let value = null ?? "default";

// Import/Export
import { func } from './module.js';
export const myFunc = () => {};

// Map and Set
let map = new Map();
map.set("key", "value");

let set = new Set([1, 2, 3, 3]); // {1, 2, 3}
```

## Best Practices

1. Use const by default, let when needed
2. Use arrow functions for callbacks
3. Use template literals over concatenation
4. Use destructuring for objects/arrays
5. Use async/await over callbacks
6. Use optional chaining for nested access