# TypeScript Introduction

## Why Learn TypeScript?
TypeScript is a typed superset of JavaScript that compiles to plain JavaScript. It adds static type checking to JavaScript while maintaining full compatibility.

## Key Features
- **Static Typing**: Catch errors at compile time
- **Type Inference**: Smart type deduction
- **Interfaces**: Define object shapes
- **Generics**: Reusable type-safe components
- **Enums**: Named constants
- **Access Modifiers**: public, private, protected
- **Null Safety**: Null and undefined checking
- **JavaScript Compatible**: Runs anywhere JS runs

## Getting Started

### Installation
1. Install Node.js
2. Install TypeScript: `npm install -g typescript`
3. Verify: `tsc --version`

### First Program
```typescript
const greeting: string = "Hello, World!";
console.log(greeting);
```

Save as `hello.ts` and compile with `tsc hello.ts`, then run with `node hello.js`

## Basic Syntax

### Variables and Data Types
```typescript
// Explicit types
let name: string = "Alice";
let age: number = 30;
let height: number = 5.5;
let isStudent: boolean = true;

// Type inference
let score = 100;  // inferred as number

// Any type (avoid if possible)
let dynamic: any = "hello";
dynamic = 42;

// Arrays
let numbers: number[] = [1, 2, 3];
let names: Array<string> = ["Alice", "Bob"];

// Tuple
let person: [string, number] = ["Alice", 30];

// Enum
enum Direction {
    Up,
    Down,
    Left,
    Right
}

// Union types
let id: string | number = "123";
id = 123;

// Literal types
type Status = "active" | "inactive" | "pending";
let userStatus: Status = "active";
```

### Interfaces and Types
```typescript
// Interface
interface Person {
    name: string;
    age: number;
    email?: string;  // Optional
    readonly id: number;  // Read-only
}

// Extending interfaces
interface Employee extends Person {
    department: string;
    salary: number;
}

// Type alias
type Point = {
    x: number;
    y: number;
};

// Intersection
type EmployeePerson = Person & Employee;
```

### Functions
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

// Rest parameters
function sum(...numbers: number[]): number {
    return numbers.reduce((a, b) => a + b, 0);
}

// Function overloads
function process(value: string): string;
function process(value: number): number;
function process(value: string | number): string | number {
    if (typeof value === "string") {
        return value.toUpperCase();
    }
    return value * 2;
}
```

### Classes
```typescript
class Animal {
    // Properties
    protected name: string;
    private age: number;

    constructor(name: string, age: number) {
        this.name = name;
        this.age = age;
    }

    // Method
    speak(): string {
        return `${this.name} makes a sound`;
    }

    // Getter
    get info(): string {
        return `${this.name}, ${this.age} years old`;
    }

    // Setter
    set Age(value: number) {
        if (value < 0) throw new Error("Age cannot be negative");
        this.age = value;
    }

    // Static method
    static create(name: string, age: number): Animal {
        return new Animal(name, age);
    }
}

// Inheritance
class Dog extends Animal {
    breed: string;

    constructor(name: string, age: number, breed: string) {
        super(name, age);
        this.breed = breed;
    }

    speak(): string {
        return `${this.name} barks`;
    }
}

// Abstract class
abstract class Shape {
    abstract area(): number;
    abstract perimeter(): number;

    describe(): string {
        return `Area: ${this.area()}, Perimeter: ${this.perimeter()}`;
    }
}

class Circle extends Shape {
    constructor(private radius: number) {
        super();
    }

    area(): number {
        return Math.PI * this.radius ** 2;
    }

    perimeter(): number {
        return 2 * Math.PI * this.radius;
    }
}
```

### Generics
```typescript
// Generic function
function identity<T>(value: T): T {
    return value;
}

// Generic interface
interface Repository<T> {
    getById(id: number): T;
    getAll(): T[];
    save(item: T): void;
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

    peek(): T | undefined {
        return this.items[this.items.length - 1];
    }
}

// Generic constraints
function merge<T extends object, U extends object>(a: T, b: U): T & U {
    return { ...a, ...b };
}
```

### Type Guards and Assertions
```typescript
// Type guards
function isString(value: any): value is string {
    return typeof value === "string";
}

function process(value: string | number) {
    if (isString(value)) {
        console.log(value.toUpperCase());  // TypeScript knows it's string
    } else {
        console.log(value.toFixed(2));  // TypeScript knows it's number
    }
}

// instanceof
function handleError(error: Error | string) {
    if (error instanceof Error) {
        console.log(error.message);
    } else {
        console.log(error);
    }
}

// Type assertion
let someValue: any = "hello";
let strLength: number = (someValue as string).length;
```

### Utility Types
```typescript
// Partial - all properties optional
interface User {
    name: string;
    age: number;
    email: string;
}

function updateUser(user: User, updates: Partial<User>): User {
    return { ...user, ...updates };
}

// Required - all properties required
type CompleteUser = Required<User>;

// Pick - select properties
type UserBasic = Pick<User, "name" | "email">;

// Omit - exclude properties
type UserWithoutEmail = Omit<User, "email">;

// Record - object type
type Scores = Record<string, number>;

// Readonly
const readonlyUser: Readonly<User> = {
    name: "Alice",
    age: 30,
    email: "alice@example.com"
};
// readonlyUser.name = "Bob";  // Error
```

### Async/Await
```typescript
// Promise
function fetchData(): Promise<User> {
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            resolve({ name: "Alice", age: 30, email: "alice@example.com" });
        }, 1000);
    });
}

// Async/await
async function getUser(): Promise<User> {
    try {
        const user = await fetchData();
        return user;
    } catch (error) {
        console.error("Failed to fetch user:", error);
        throw error;
    }
}

// Parallel execution
async function loadAll(): Promise<[User, User]> {
    const [user1, user2] = await Promise.all([
        fetchUser(1),
        fetchUser(2)
    ]);
    return [user1, user2];
}
```

### Modules
```typescript
// Export
export interface User {
    name: string;
    age: number;
}

export function createUser(name: string, age: number): User {
    return { name, age };
}

// Default export
export default class UserService {
    getUser(id: number): User {
        return { name: "Alice", age: 30 };
    }
}

// Import
import UserService, { User } from "./user-service";
import type { User } from "./user-service";  // Type-only import
```

## Best Practices
1. Enable `strict` mode in tsconfig.json
2. Avoid `any` type - use `unknown` if needed
3. Use interfaces for object shapes
4. Prefer type inference when clear
5. Use `readonly` for immutable data
6. Handle null/undefined explicitly
7. Use utility types to avoid repetition

## Common Pitfalls
- Type assertions can bypass type safety
- `any` defeats the purpose of TypeScript
- Not handling `null` and `undefined`
- Overcomplicating types
- Ignoring TypeScript errors with `@ts-ignore`