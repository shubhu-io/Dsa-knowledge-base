# JavaScript Syntax Reference

## let, const, and var

```javascript
/* const — immutable binding (preferred) */
const PI = 3.14159;
const name = "Alice";

/* let — mutable block-scoped variable */
let count = 0;
count += 1;

/* var — function-scoped, hoisted (avoid) */
var legacy = "don't use this";
```

## Arrow Functions

```javascript
/* Arrow function syntax */
const add = (a, b) => a + b;
const square = x => x * x;            /* single param, no parens needed */

/* Block body for multiple statements */
const greet = (name) => {
    const message = `Hello, ${name}!`;
    return message;
};

/* Arrow functions do NOT have their own `this` */
const counter = {
    count: 0,
    increment: () => {
        /* `this` refers to enclosing scope, NOT counter */
    },
    incrementMethod() {
        /* `this` refers to counter */
        this.count++;
    }
};
```

## Destructuring

```javascript
/* Object destructuring */
const person = { name: "Alice", age: 30, city: "NYC" };
const { name, age } = person;
const { name: n, ...rest } = person;  /* rename + rest */

/* Array destructuring */
const [first, second, ...rest] = [1, 2, 3, 4, 5];

/* Function parameter destructuring */
function createUser({ name, age, role = "user" }) {
    return { name, age, role };
}
createUser({ name: "Bob", age: 25 });
```

## Spread and Rest Operators

```javascript
/* Spread: expand arrays/objects */
const arr1 = [1, 2, 3];
const arr2 = [...arr1, 4, 5];        /* [1,2,3,4,5] */

const obj1 = { a: 1, b: 2 };
const obj2 = { ...obj1, c: 3 };     /* {a:1, b:2, c:3} */

/* Spread in function calls */
Math.max(...[1, 5, 3]);              /* 5 */

/* Rest: collect into array */
function sum(...nums) {
    return nums.reduce((acc, n) => acc + n, 0);
}
sum(1, 2, 3, 4);  /* 10 */
```

## Promises and async/await

```javascript
/* Promise — represents eventual completion/failure */
function fetchData(url) {
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            if (url) resolve({ data: "result" });
            else reject(new Error("No URL"));
        }, 1000);
    });
}

/* async/await — syntactic sugar over Promises */
async function getData() {
    try {
        const result = await fetchData("https://api.example.com");
        console.log(result.data);
    } catch (err) {
        console.error("Failed:", err.message);
    }
}

/* Promise.all — concurrent async operations */
const results = await Promise.all([
    fetchData("/api/users"),
    fetchData("/api/posts"),
]);
```

## Modules

```javascript
/* ES Modules — the standard (ESM) */

/* math.js — named exports */
export const add = (a, b) => a + b;
export const multiply = (a, b) => a * b;
export default class Calculator { /* ... */ }

/* app.js — imports */
import Calculator, { add, multiply } from "./math.js";
import * as math from "./math.js";

const calc = new Calculator();
console.log(add(2, 3));           /* 5 */
console.log(math.multiply(4, 5)); /* 20 */
```

## Closures

A closure is a function that remembers variables from its enclosing scope.

```javascript
/* Closure captures `factor` from outer scope */
function makeMultiplier(factor) {
    return (x) => x * factor;
}

const double = makeMultiplier(2);
const triple = makeMultiplier(3);
console.log(double(5));  /* 10 */
console.log(triple(5));  /* 15 */

/* Private state via closure */
function createCounter() {
    let count = 0;  /* private — not accessible outside */
    return {
        increment: () => ++count,
        decrement: () => --count,
        getCount: () => count,
    };
}

const counter = createCounter();
counter.increment();
counter.increment();
console.log(counter.getCount());  /* 2 */
```

## Prototypal Inheritance

```javascript
/* Every object has an internal [[Prototype]] link */
const animal = {
    breathe() { return `${this.name} is breathing`; },
};

const dog = Object.create(animal);
dog.name = "Rex";
dog.bark = function () { return "Woof!"; };

console.log(dog.breathe());  /* "Rex is breathing" — delegated */
console.log(dog.bark());     /* "Woof!" */

/* Checking prototype chain */
console.log(Object.getPrototypeOf(dog) === animal);  /* true */
console.log(dog instanceof Object);  /* true */
```

## Template Literals

```javascript
const name = "Alice";
console.log(`Hello, ${name}!`);

/* Multi-line strings */
const html = `
<div>
    <p>${name}</p>
</div>
`;

/* Tagged templates */
function highlight(strings, ...values) {
    return strings.reduce((result, str, i) =>
        result + str + (values[i] ? `<b>${values[i]}</b>` : ""), ""
    );
}
```

## Optional Chaining and Nullish Coalescing

```javascript
const user = { profile: { address: null } };

/* Optional chaining — short-circuits on null/undefined */
const zip = user?.profile?.address?.zip;  /* undefined, no error */

/* Nullish coalescing — default only for null/undefined */
const city = user?.profile?.address?.city ?? "Unknown";
```

## Common Pitfalls

| Pitfall | Problem | Fix |
|---------|---------|-----|
| `var` hoisting | Surprising scope | Use `const`/`let` |
| `this` in arrows | Doesn't bind to object | Use method syntax for object methods |
| `==` vs `===` | Coercion surprises | Always use `===` |
| Mutation | Shared reference bugs | Use spread/copy for new objects |
| Async timing | Race conditions | `await` or `.then()` chains |

## See Also

- [[javascript-basics-tutorial]]
- [[javascript-introduction]]
- [[string_algorithms]]
