# TypeScript Basics Tutorial

## Variables and Data Types

```typescript
// Explicit types
let name: string = "Alice";
let age: number = 30;
let isStudent: boolean = true;

// Type inference
let score = 100;  // inferred as number

// Arrays
let numbers: number[] = [1, 2, 3];
let names: Array<string> = ["Alice", "Bob"];

// Tuples
let person: [string, number] = ["Alice", 30];

// Enums
enum Direction {
    Up,
    Down,
    Left,
    Right
}

// Union types
let id: string | number = "123";
```

## Interfaces

```typescript
interface Person {
    name: string;
    age: number;
    email?: string;  // Optional
}

interface Employee extends Person {
    department: string;
}
```

## Control Flow

### If-Else
```typescript
if (age >= 18) {
    console.log("Adult");
} else {
    console.log("Minor");
}
```

### For Loop
```typescript
for (let i = 0; i < 5; i++) {
    console.log(i);
}
```

### Switch
```typescript
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

## Functions

```typescript
// Basic function
function add(a: number, b: number): number {
    return a + b;
}

// Arrow function
const multiply = (a: number, b: number): number => a * b;

// Optional parameters
function greet(name: string, greeting?: string): string {
    return `${greeting || "Hello"}, ${name}!`;
}

// Default parameters
function power(base: number, exponent: number = 2): number {
    return Math.pow(base, exponent);
}
```

## Classes

```typescript
class Person {
    constructor(
        public name: string,
        private age: number
    ) {}

    greet(): string {
        return `Hello, I'm ${this.name}`;
    }
}

class Student extends Person {
    constructor(
        name: string,
        age: number,
        public grade: string
    ) {
        super(name, age);
    }

    greet(): string {
        return `${super.greet()}, and I'm a student`;
    }
}
```

## Generics

```typescript
// Generic function
function identity<T>(value: T): T {
    return value;
}

// Generic interface
interface Repository<T> {
    getById(id: number): T;
    getAll(): T[];
}

// Generic class
class Stack<T> {
    private items: T[] = [];

    push(item: T): void {
        this.items.push(item);
    }

    pop(): T | undefined {
        return this.items.pop();
    }
}
```

## Async/Await

```typescript
// Promise
function fetchData(): Promise<string> {
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
```

## Best Practices

1. Enable `strict` mode in tsconfig.json
2. Avoid `any` type
3. Use interfaces for object shapes
4. Prefer type inference when clear
5. Use `readonly` for immutable data