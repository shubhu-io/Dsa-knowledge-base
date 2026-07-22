# TypeScript Syntax

## Overview
TypeScript extends JavaScript with optional static typing, providing powerful features for catching errors at compile time. This guide covers the essential syntax elements including types, interfaces, generics, and advanced type features.

## Basic Types

```typescript
// Primitive types
let isDone: boolean = false;
let decimal: number = 6;
let color: string = "blue";
let list: number[] = [1, 2, 3];
let tuple: [string, number] = ["hello", 10];

// Enum
enum Direction {
    Up = 1,
    Down,
    Left,
    Right,
}
let dir: Direction = Direction.Up;

// Any, unknown, void, null, undefined, never
let notSure: unknown = 4;
let anything: any = "could be anything";
function warnUser(): void {
    console.log("This is a warning message");
}
let u: undefined = undefined;
let n: null = null;
function throwError(message: string): never {
    throw new Error(message);
}

// Type assertions
let someValue: unknown = "this is a string";
let strLength: number = (someValue as string).length;
// or
let strLength2: number = (<string>someValue).length;
```

## Interfaces

```typescript
// Basic interface
interface User {
    name: string;
    age: number;
    email?: string;  // Optional property
    readonly id: number;  // Read-only property
}

// Extending interfaces
interface Employee extends User {
    employeeId: string;
    department: string;
}

// Interface for functions
interface SearchFunc {
    (source: string, subString: string): boolean;
}

// Index signatures
interface StringArray {
    [index: number]: string;
}

interface Dictionary {
    [key: string]: number;
}

// Implementing interfaces
class Customer implements User {
    constructor(
        public name: string,
        public age: number,
        public readonly id: number,
        public customerId: string
    ) {}
}
```

## Type Aliases

```typescript
// Basic type alias
type Point = {
    x: number;
    y: number;
};

// Union types
type ID = string | number;
type Nullable<T> = T | null;

// Intersection types
type Named = {
    name: string;
};
type Aged = {
    age: number;
};
type Person = Named & Aged;

// Mapped types
type Readonly<T> = {
    readonly [P in keyof T]: T[P];
};

type Partial<T> = {
    [P in keyof T]?: T[P];
};
```

## Generics

```typescript
// Generic function
function identity<T>(arg: T): T {
    return arg;
}

// Generic interface
interface GenericIdentityFn<T> {
    (arg: T): T;
}

// Generic class
class GenericNumber<T> {
    zeroValue: T;
    add: (x: T, y: T) => T;
}

// Generic constraints
interface Lengthwise {
    length: number;
}

function loggingIdentity<T extends Lengthwise>(arg: T): T {
    console.log(arg.length);
    return arg;
}

// Using keyof with generics
function getProperty<T, K extends keyof T>(obj: T, key: K): T[K] {
    return obj[key];
}
```

## Enums

```typescript
// Numeric enum
enum Color {
    Red,
    Green,
    Blue,
}
let c: Color = Color.Green;

// String enum
enum Direction {
    Up = "UP",
    Down = "DOWN",
    Left = "LEFT",
    Right = "RIGHT",
}

// Const enum (inlined at compile time)
const enum HttpStatus {
    OK = 200,
    NotFound = 404,
    ServerError = 500,
}

// Heterogeneous enum (not recommended)
enum BooleanLikeHeterogeneousEnum {
    No = 0,
    Yes = "YES",
}
```

## Type Guards

```typescript
// typeof type guard
function padLeft(value: string, padding: string | number) {
    if (typeof padding === "number") {
        return " ".repeat(padding) + value;
    }
    return padding + value;
}

// instanceof type guard
class Bird {
    fly() { console.log("Flying"); }
    layEggs() { console.log("Laying eggs"); }
}

class Fish {
    swim() { console.log("Swimming"); }
    layEggs() { console.log("Laying eggs"); }
}

function move(animal: Bird | Fish) {
    if (animal instanceof Bird) {
        animal.fly();
    } else {
        animal.swim();
    }
}

// User-defined type guard
function isFish(animal: Bird | Fish): animal is Fish {
    return (animal as Fish).swim !== undefined;
}

// Discriminated unions
interface Circle {
    kind: "circle";
    radius: number;
}

interface Square {
    kind: "square";
    sideLength: number;
}

interface Triangle {
    kind: "triangle";
    base: number;
    height: number;
}

type Shape = Circle | Square | Triangle;

function getArea(shape: Shape): number {
    switch (shape.kind) {
        case "circle":
            return Math.PI * shape.radius ** 2;
        case "square":
            return shape.sideLength ** 2;
        case "triangle":
            return (shape.base * shape.height) / 2;
    }
}
```

## Utility Types

```typescript
// Partial<T> - makes all properties optional
interface Config {
    host: string;
    port: number;
    debug: boolean;
}
function createConfig(config: Partial<Config>): Config {
    return {
        host: "localhost",
        port: 3000,
        debug: false,
        ...config,
    };
}

// Required<T> - makes all properties required
interface Options {
    width?: number;
    height?: number;
    color?: string;
}
function processOptions(options: Required<Options>): void {
    console.log(options.width * options.height);
}

// Pick<T, K> - picks specific properties
interface User {
    name: string;
    age: number;
    email: string;
    password: string;
}
type UserPreview = Pick<User, "name" | "email">;

// Omit<T, K> - omits specific properties
type UserWithoutPassword = Omit<User, "password">;

// Record<K, T> - constructs object type with keys K and values T
interface CatInfo {
    age: number;
    breed: string;
}
type CatName = "miffy" | "boris" | "mordred";
const cats: Record<CatName, CatInfo> = {
    miffy: { age: 10, breed: "Persian" },
    boris: { age: 5, breed: "Maine Coon" },
    mordred: { age: 16, breed: "British Shorthair" },
};

// ReturnType<T> - extracts return type of function
function createUser() {
    return { name: "Alice", age: 30 };
}
type UserReturn = ReturnType<typeof createUser>;

// Parameters<T> - extracts parameter types of function
function greet(name: string, age: number): string {
    return `Hello ${name}, you are ${age}`;
}
type GreetParams = Parameters<typeof greet>;

// Awaited<T> - unwraps Promise type
type A = Awaited<Promise<string>>;  // string
type B = Awaited<Promise<Promise<number>>>;  // number
```

## Mapped Types

```typescript
// Basic mapped type
type Optional<T> = {
    [P in keyof T]?: T[P];
};

type ReadonlyMapped<T> = {
    readonly [P in keyof T]: T[P];
};

// Key remapping with as
type Getters<T> = {
    [P in keyof T as `get${Capitalize<string & P>}`]: () => T[P];
};

interface Person {
    name: string;
    age: number;
}

type PersonGetters = Getters<Person>;
// { getName: () => string; getAge: () => number; }

// Filtering keys
type FunctionPropertyNames<T> = {
    [K in keyof T]: T[K] extends Function ? K : never;
}[keyof T];

interface Example {
    name: string;
    greet(): void;
    age: number;
    calculate(): number;
}

type ExampleFunctions = FunctionPropertyNames<Example>;  // "greet" | "calculate"
```

## Declaration Files

```typescript
// Basic declaration file (types.d.ts)
declare module "my-module" {
    export function doSomething(): void;
    export interface Config {
        debug: boolean;
    }
}

// Ambient declarations
declare const API_URL: string;
declare function fetchJSON(url: string): Promise<any>;

// Module augmentation
declare module "express" {
    interface Request {
        userId?: string;
    }
}

// Global type declarations
declare global {
    interface Window {
        myCustomProperty: string;
    }
}

// Using declaration files
/// <reference types="node" />
/// <reference path="./custom.d.ts" />
```

## Type Assertions and Assertions Functions

```typescript
// Type assertions
let value: unknown = "hello";
let len1: number = (<string>value).length;
let len2: number = (value as string).length;

// Assertion functions
function assertIsString(value: unknown): asserts value is string {
    if (typeof value !== "string") {
        throw new Error("Expected string");
    }
}

function processValue(value: unknown) {
    assertIsString(value);
    // value is now string here
    console.log(value.toUpperCase());
}

// Non-null assertion operator
function getLength(s: string | null): number {
    return s!.length;
}

// Optional chaining and nullish coalescing
interface Company {
    name: string;
    address?: {
        city?: string;
        street?: string;
    };
}

function getCity(company: Company): string {
    return company.address?.city ?? "Unknown";
}
```

## Example: Complete TypeScript Program

```typescript
// Generic repository pattern
interface Repository<T, ID> {
    findById(id: ID): Promise<T | null>;
    findAll(): Promise<T[]>;
    save(entity: T): Promise<T>;
    delete(id: ID): Promise<boolean>;
}

// Entity base class
abstract class Entity<ID> {
    constructor(protected readonly id: ID) {}
    
    equals(other: Entity<ID>): boolean {
        return this.id === other.id;
    }
}

// User entity
class User extends Entity<string> {
    constructor(
        id: string,
        public name: string,
        public email: string,
        public age: number
    ) {
        super(id);
    }
    
    isAdult(): boolean {
        return this.age >= 18;
    }
}

// In-memory repository implementation
class InMemoryRepository<T extends Entity<ID>, ID> implements Repository<T, ID> {
    private items: Map<ID, T> = new Map();
    
    async findById(id: ID): Promise<T | null> {
        return this.items.get(id) ?? null;
    }
    
    async findAll(): Promise<T[]> {
        return Array.from(this.items.values());
    }
    
    async save(entity: T): Promise<T> {
        this.items.set(entity["id"], entity);
        return entity;
    }
    
    async delete(id: ID): Promise<boolean> {
        return this.items.delete(id);
    }
}

// Usage
async function main() {
    const userRepo = new InMemoryRepository<User, string>();
    
    const user = new User("1", "Alice", "alice@example.com", 30);
    await userRepo.save(user);
    
    const found = await userRepo.findById("1");
    console.log(found?.name);
    
    const allUsers = await userRepo.findAll();
    console.log(`Total users: ${allUsers.length}`);
}

main();
```

## See Also
- [[../00-Getting-Started/README|Getting Started]]
- [[oop.md|OOP in TypeScript]]
- [[../Algorithms/String/string_algorithms.ts|String Algorithms]]
- [TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/)
- [TypeScript Deep Dive](https://basarat.gitbook.io/typescript/)