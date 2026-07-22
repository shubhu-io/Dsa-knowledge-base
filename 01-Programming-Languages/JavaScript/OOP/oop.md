# Object-Oriented Programming in JavaScript

## Overview

JavaScript uses **prototypal inheritance** — objects directly inherit from other objects via prototype links. ES6 added `class` syntax as syntactic sugar over this prototype system. JavaScript also supports functional composition and factory functions as alternatives to class-based OOP.

## Prototypal Inheritance

Every object has an internal `[[Prototype]]` link. Property lookups traverse the prototype chain until the property is found or the chain ends at `null`.

```javascript
const vehicle = {
    start() { return `${this.model} started`; },
    stop()  { return `${this.model} stopped`; },
};

const car = Object.create(vehicle);
car.model = "Tesla";
car.drive = function () { return `${this.model} is driving`; };

console.log(car.start());  /* "Tesla started" — inherited */
console.log(car.drive());  /* "Tesla is driving" — own */
```

### Constructor Functions (pre-ES6)

```javascript
function Shape(x, y) {
    this.x = x;
    this.y = y;
}

Shape.prototype.area = function () {
    return 0;  /* base implementation */
};

function Circle(x, y, r) {
    Shape.call(this, x, y);  /* call parent constructor */
    this.radius = r;
}

/* Set up prototype chain */
Circle.prototype = Object.create(Shape.prototype);
Circle.prototype.constructor = Circle;

Circle.prototype.area = function () {
    return Math.PI * this.radius * this.radius;
};
```

## ES6 Classes

Classes provide cleaner syntax but work the same way under the hood — prototype-based.

```javascript
class Shape {
    #x;  /* private field */
    #y;

    constructor(x = 0, y = 0) {
        this.#x = x;
        this.#y = y;
    }

    get x() { return this.#x; }
    get y() { return this.#y; }

    area() {
        throw new Error("area() must be implemented by subclass");
    }

    toString() {
        return `${this.constructor.name} @ (${this.#x}, ${this.#y})`;
    }
}

class Circle extends Shape {
    #radius;

    constructor(x, y, radius) {
        super(x, y);   /* call parent constructor */
        this.#radius = radius;
    }

    area() {
        return Math.PI * this.#radius ** 2;
    }

    get radius() { return this.#radius; }
}

class Rectangle extends Shape {
    #w;
    #h;

    constructor(x, y, w, h) {
        super(x, y);
        this.#w = w;
        this.#h = h;
    }

    area() {
        return this.#w * this.#h;
    }
}
```

## Constructors

Every function can be used as a constructor with `new`. The `new` keyword:

1. Creates a new empty object
2. Links its prototype to the function's `prototype`
3. Calls the function with `this` bound to the new object
4. Returns the object (unless constructor returns another object)

```javascript
function Person(name, age) {
    this.name = name;
    this.age = age;
}

Person.prototype.greet = function () {
    return `Hi, I'm ${this.name}`;
};

const alice = new Person("Alice", 30);
console.log(alice.greet());  /* "Hi, I'm Alice" */
```

## Factory Functions

Factory functions create and return objects without `new` or `this`. They naturally support closures for private state.

```javascript
function createShape(x, y) {
    let _x = x, _y = y;  /* private via closure */

    return {
        get x() { return _x; },
        get y() { return _y; },
        moveTo(nx, ny) { _x = nx; _y = ny; },
        area() { return 0; },
    };
}

function createCircle(x, y, radius) {
    const base = createShape(x, y);
    return {
        ...base,   /* spread: copy own properties */
        area: () => Math.PI * radius ** 2,
        get radius() { return radius; },
    };
}

const c = createCircle(0, 0, 5);
console.log(c.area());  /* 78.54 */
```

## Mixins

Mixins add capabilities to objects without class inheritance.

```javascript
const Serializable = (superclass) => class extends superclass {
    serialize() {
        return JSON.stringify(this);
    }

    static deserialize(json) {
        return Object.assign(new this(), JSON.parse(json));
    }
};

const Loggable = (superclass) => class extends superclass {
    log(msg) {
        console.log(`[${this.constructor.name}] ${msg}`);
    }
};

class User extends Serializable(Loggable(Object)) {
    constructor(name, email) {
        super();
        this.name = name;
        this.email = email;
    }
}

const user = new User("Alice", "alice@example.com");
const json = user.serialize();
user.log("saved");
```

## Composition vs Inheritance

| Aspect | Inheritance (`extends`) | Composition (factories/mixins) |
|--------|------------------------|-------------------------------|
| Relationship | "is-a" | "has-a" |
| Coupling | Tight (class hierarchy) | Loose (object assembly) |
| Flexibility | Single inheritance only | Unlimited combinations |
| Private state | `#private` fields | Closures |
| Testing | Easier (known structure) | Harder (dynamic) |

**Rule of thumb:** Favor composition over inheritance unless you need polymorphism across an interface hierarchy.

```javascript
/* Composition: assemble behavior from small units */
const withTimer = (obj) => ({
    ...obj,
    time(label, fn) {
        console.time(label);
        fn();
        console.timeEnd(label);
    }
});

const withValidation = (obj) => ({
    ...obj,
    validate(data) {
        return data != null && typeof data === "object";
    }
});

const api = withTimer(withValidation({}));

api.validate({ id: 1 });        /* true */
api.time("slow-op", () => {});  /* logs timing */
```

## Common Pitfalls

| Pitfall | Problem | Fix |
|---------|---------|-----|
| Forgetting `new` | `this` binds to global or throws | Use classes or factory functions |
| Sharing mutable arrays in prototypes | All instances share same array | Create in constructor, not on prototype |
| Arrow functions as methods | `this` is wrong | Use method shorthand in classes |
| `class` is sugar | Not truly different from prototypes | Understand prototype chain |
| Private fields are hard-private | No `#field` access from outside at all | Use closures for "soft" privacy |

## See Also

- [[syntax-js]] — JavaScript syntax reference
- [[classes-js]] — Shape hierarchy example
- [[oop-java]] — OOP in Java (class-based)
- [[oop-cpp]] — OOP in C++ (classes + templates)
