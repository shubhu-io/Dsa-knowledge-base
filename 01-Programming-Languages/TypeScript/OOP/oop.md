# Object-Oriented Programming in TypeScript

## Overview
TypeScript provides full support for object-oriented programming with classes, interfaces, inheritance, generics, decorators, and more. It adds static typing to JavaScript's prototype-based OOP, making it easier to build and maintain large-scale applications.

## Key Features
- **Classes**: ES6 classes with TypeScript extensions
- **Interfaces**: Define contracts for objects and classes
- **Inheritance**: Single class inheritance with multiple interface implementation
- **Access Modifiers**: public, private, protected, and readonly
- **Abstract Classes**: Cannot be instantiated, designed for inheritance
- **Generics**: Write reusable, type-safe code
- **Decorators**: Meta-programming syntax for modifying classes and members
- **Mixins**: Compose behaviors from multiple sources

## Classes

```typescript
// Basic class
class Person {
    // Properties with access modifiers
    private _name: string;
    protected age: number;
    public readonly id: number;
    
    // Constructor
    constructor(name: string, age: number, id: number) {
        this._name = name;
        this.age = age;
        this.id = id;
    }
    
    // Getter
    get name(): string {
        return this._name;
    }
    
    // Setter with validation
    set name(value: string) {
        if (value.length < 2) {
            throw new Error('Name must be at least 2 characters');
        }
        this._name = value;
    }
    
    // Method
    greet(): string {
        return `Hello, I'm ${this._name}!`;
    }
    
    // Static method
    static create(name: string, age: number): Person {
        return new Person(name, age, Math.floor(Math.random() * 1000));
    }
}

// Parameter properties (shorthand)
class User {
    constructor(
        public readonly id: number,
        public name: string,
        protected email: string,
        private password: string
    ) {}
    
    // Method
    checkPassword(input: string): boolean {
        return this.password === input;
    }
}
```

## Inheritance

```typescript
// Base class
class Animal {
    constructor(
        public name: string,
        protected sound: string
    ) {}
    
    speak(): string {
        return `${this.name} makes ${this.sound}`;
    }
    
    // Virtual method (can be overridden)
    move(): string {
        return `${this.name} moves`;
    }
}

// Derived class
class Dog extends Animal {
    constructor(
        name: string,
        public breed: string
    ) {
        super(name, 'Woof');
    }
    
    // Override method
    override speak(): string {
        return `${super.speak()}!`;
    }
    
    // New method
    fetch(): string {
        return `${this.name} fetches the ball`;
    }
}

// Multi-level inheritance
class Puppy extends Dog {
    constructor(name: string, breed: string) {
        super(name, breed);
    }
    
    override speak(): string {
        return 'Yip!';
    }
    
    play(): string {
        return `${this.name} plays happily`;
    }
}

// Usage
const dog = new Dog('Rex', 'German Shepherd');
console.log(dog.speak());  // Rex makes Woof!
console.log(dog.fetch());  // Rex fetches the ball

const puppy = new Puppy('Max', 'Labrador');
console.log(puppy.speak());  // Yip!
console.log(puppy.play());   // Max plays happily
```

## Interfaces

```typescript
// Basic interface
interface Shape {
    area(): number;
    perimeter(): number;
    readonly color: string;
}

// Extending interfaces
interface Drawable {
    draw(): string;
}

interface Resizable {
    resize(factor: number): void;
}

// Interface extending multiple interfaces
interface Shape2D extends Drawable, Resizable {
    area(): number;
    perimeter(): number;
}

// Implementing interfaces
class Circle implements Shape2D {
    constructor(
        public readonly color: string,
        private radius: number
    ) {}
    
    area(): number {
        return Math.PI * this.radius ** 2;
    }
    
    perimeter(): number {
        return 2 * Math.PI * this.radius;
    }
    
    draw(): string {
        return `Drawing circle with radius ${this.radius}`;
    }
    
    resize(factor: number): void {
        this.radius *= factor;
    }
}

// Interface for functions
interface MathOperation {
    (a: number, b: number): number;
}

const add: MathOperation = (a, b) => a + b;
const subtract: MathOperation = (a, b) => a - b;

// Index signatures
interface StringMap {
    [key: string]: string;
}

interface NumberArray {
    [index: number]: number;
}
```

## Abstract Classes

```typescript
// Abstract class
abstract class Vehicle {
    constructor(
        public make: string,
        public model: string,
        protected year: number
    ) {}
    
    // Abstract method (must be implemented by subclasses)
    abstract start(): string;
    abstract stop(): string;
    
    // Concrete method
    getInfo(): string {
        return `${this.year} ${this.make} ${this.model}`;
    }
    
    // Protected method
    protected checkFuel(): boolean {
        return true;
    }
}

// Derived class
class Car extends Vehicle {
    private isRunning = false;
    
    constructor(
        make: string,
        model: string,
        year: number,
        private fuelType: string
    ) {
        super(make, model, year);
    }
    
    start(): string {
        if (this.checkFuel()) {
            this.isRunning = true;
            return `${this.getInfo()} started with ${this.fuelType}`;
        }
        return 'Not enough fuel';
    }
    
    stop(): string {
        this.isRunning = false;
        return `${this.getInfo()} stopped`;
    }
    
    // Additional method
    drive(): string {
        if (this.isRunning) {
            return `Driving ${this.getInfo()}`;
        }
        return 'Start the car first';
    }
}

// Another derived class
class ElectricCar extends Vehicle {
    private batteryLevel = 100;
    
    constructor(
        make: string,
        model: string,
        year: number,
        private batteryCapacity: number
    ) {
        super(make, model, year);
    }
    
    start(): string {
        if (this.batteryLevel > 0) {
            return `${this.getInfo()} (Electric) started silently`;
        }
        return 'Battery depleted';
    }
    
    stop(): string {
        return `${this.getInfo()} (Electric) stopped`;
    }
    
    charge(): string {
        this.batteryLevel = 100;
        return `Charged to ${this.batteryLevel}%`;
    }
}
```

## Generics

```typescript
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
    
    isEmpty(): boolean {
        return this.items.length === 0;
    }
    
    size(): number {
        return this.items.length;
    }
}

// Generic interface
interface Repository<T> {
    findById(id: string): Promise<T | null>;
    findAll(): Promise<T[]>;
    save(entity: T): Promise<T>;
    delete(id: string): Promise<boolean>;
}

// Generic function
function identity<T>(arg: T): T {
    return arg;
}

// Generic constraints
interface HasLength {
    length: number;
}

function logLength<T extends HasLength>(arg: T): T {
    console.log(arg.length);
    return arg;
}

// Multiple type parameters
function pair<T, U>(first: T, second: U): [T, U] {
    return [first, second];
}
```

## Decorators

```typescript
// Method decorator
function Log(
    target: any,
    propertyKey: string,
    descriptor: PropertyDescriptor
) {
    const originalMethod = descriptor.value;
    
    descriptor.value = function (...args: any[]) {
        console.log(`Calling ${propertyKey} with args:`, args);
        const result = originalMethod.apply(this, args);
        console.log(`Result:`, result);
        return result;
    };
}

// Class decorator
function Sealed(constructor: Function) {
    Object.seal(constructor);
    Object.seal(constructor.prototype);
}

// Property decorator
function Validate(
    target: any,
    propertyKey: string
) {
    let value: any;
    
    const getter = () => value;
    const setter = (newVal: any) => {
        if (newVal === null || newVal === undefined) {
            throw new Error(`Cannot set ${propertyKey} to null or undefined`);
        }
        value = newVal;
    };
    
    Object.defineProperty(target, propertyKey, {
        get: getter,
        set: setter,
    });
}

// Using decorators
@Sealed
class User {
    @Validate
    public name: string;
    
    @Validate
    public email: string;
    
    constructor(name: string, email: string) {
        this.name = name;
        this.email = email;
    }
    
    @Log
    greet(): string {
        return `Hello, ${this.name}!`;
    }
}
```

## Mixins

```typescript
// Base type for mixins
type Constructor<T = {}> = new (...args: any[]) => T;

// Mixin for timestamp functionality
Timestamped = <T extends Constructor>(Base: T) => {
    return class extends Base {
        createdAt = new Date();
        updatedAt = new Date();
        
        updateTimestamp() {
            this.updatedAt = new Date();
        }
    };
};

// Mixin for identification
Identified = <T extends Constructor>(Base: T) => {
    return class extends Base {
        id = Math.random().toString(36).substr(2, 9);
    };
};

// Mixin for validation
Validatable = <T extends Constructor>(Base: T) => {
    return class extends Base {
        errors: string[] = [];
        
        validate(): boolean {
            this.errors = [];
            // Add validation logic here
            return this.errors.length === 0;
        }
    };
};

// Apply mixins
class BaseEntity {
    constructor(public name: string) {}
}

// Compose mixins
const EnhancedEntity = Timestamped(Identified(Validatable(BaseEntity)));

// Usage
const entity = new EnhancedEntity('Test Entity');
console.log(entity.id);           // Random ID
console.log(entity.createdAt);    // Current date
console.log(entity.validate());   // true
```

## Access Modifiers

```typescript
class Employee {
    public name: string;           // Accessible everywhere
    protected department: string;  // Accessible in class and subclasses
    private salary: number;        // Accessible only in class
    readonly id: number;           // Read-only after initialization
    
    constructor(
        name: string,
        department: string,
        salary: number,
        id: number
    ) {
        this.name = name;
        this.department = department;
        this.salary = salary;
        this.id = id;
    }
    
    // Public method
    getInfo(): string {
        return `${this.name} works in ${this.department}`;
    }
    
    // Protected method
    protected getSalary(): number {
        return this.salary;
    }
    
    // Private method
    private calculateBonus(): number {
        return this.salary * 0.1;
    }
    
    // Method using private and protected members
    getCompensation(): number {
        return this.salary + this.calculateBonus();
    }
}

// Derived class can access protected members
class Manager extends Employee {
    constructor(
        name: string,
        department: string,
        salary: number,
        id: number,
        private teamSize: number
    ) {
        super(name, department, salary, id);
    }
    
    getTeamInfo(): string {
        // Can access protected member
        return `${this.name} manages team of ${this.teamSize} in ${this.department}`;
    }
}

// Usage
const emp = new Employee('Alice', 'Engineering', 80000, 1);
console.log(emp.name);           // OK: public
// console.log(emp.department); // Error: protected
// console.log(emp.salary);    // Error: private

const mgr = new Manager('Bob', 'Engineering', 100000, 2, 5);
console.log(mgr.getTeamInfo());  // OK
```

## Benefits of TypeScript OOP
1. **Static typing**: Catch errors at compile time
2. **IDE support**: Better autocomplete, refactoring, and navigation
3. **Maintainability**: Clear contracts with interfaces
4. **Reusability**: Generics and mixins for code reuse
5. **Documentation**: Type annotations serve as documentation
6. **Backwards compatibility**: Compiles to plain JavaScript

## Example: Shape Hierarchy
See `classes.ts` for a complete example demonstrating TypeScript's OOP features with shapes.

## See Also
- [[syntax.md|TypeScript Syntax]]
- [[../Algorithms/String/string_algorithms.ts|String Algorithms]]
- [TypeScript Handbook: Classes](https://www.typescriptlang.org/docs/handbook/2/classes.html)
- [TypeScript Deep Dive: OOP](https://basarat.gitbook.io/typescript/future-javascript/classes)