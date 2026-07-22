/**
 * classes.js
 *
 * Demonstrates JavaScript OOP patterns:
 *   - ES6 classes with inheritance and private fields
 *   - Prototypal inheritance (Object.create)
 *   - Factory functions with closures
 *   - Polymorphism
 *   - Mixins
 *
 * Shape hierarchy: Shape -> Circle, Rectangle, Triangle
 *
 * Run: node classes.js
 */

/* ================================================================
 * ES6 Classes — the modern approach
 * ================================================================ */

class Shape {
    #x;
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

    type() {
        return this.constructor.name;
    }

    toString() {
        return `${this.type()} @ (${this.#x}, ${this.#y})`;
    }
}

class Circle extends Shape {
    #radius;

    constructor(x, y, radius) {
        super(x, y);
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

class Triangle extends Shape {
    #bx; #by; #cx; #cy;

    constructor(ax, ay, bx, by, cx, cy) {
        super(ax, ay);
        this.#bx = bx;
        this.#by = by;
        this.#cx = cx;
        this.#cy = cy;
    }

    area() {
        return 0.5 * Math.abs(
            this.x * (this.#by - this.#cy) +
            this.#bx * (this.#cy - this.y) +
            this.#cx * (this.y - this.#by)
        );
    }
}

/* ================================================================
 * ShapeGroup — demonstrates polymorphism with ES6 classes
 * ================================================================ */

class ShapeGroup {
    #name;
    #shapes = [];

    constructor(name) {
        this.#name = name;
    }

    add(shape) {
        this.#shapes.push(shape);
    }

    totalArea() {
        return this.#shapes.reduce((sum, s) => sum + s.area(), 0);
    }

    print() {
        console.log(`Group "${this.#name}" (${this.#shapes.length} shapes):`);
        for (const s of this.#shapes) {
            console.log(`  ${s}  area=${s.area().toFixed(2)}`);
        }
        console.log(`  Total area = ${this.totalArea().toFixed(2)}`);
    }
}

/* ================================================================
 * Prototypal Inheritance — the original pattern (pre-ES6)
 * ================================================================ */

function createProtoShape(x, y) {
    return {
        x, y,
        area() { return 0; },
        type() { return "Shape"; },
        toString() { return `${this.type()} @ (${this.x}, ${this.y})`; },
    };
}

function createProtoCircle(x, y, radius) {
    const shape = createProtoShape(x, y);
    return Object.assign(shape, {
        radius,
        area() { return Math.PI * radius ** 2; },
        type() { return "ProtoCircle"; },
    });
}

/* ================================================================
 * Factory Functions — private state via closures
 * ================================================================ */

function factoryShape(x, y) {
    let _x = x, _y = y;  /* private via closure */

    return {
        get x() { return _x; },
        get y() { return _y; },
        moveTo(nx, ny) { _x = nx; _y = ny; },
        area() { return 0; },
        type() { return "FactoryShape"; },
        toString() { return `${this.type()} @ (${_x}, ${_y})`; },
    };
}

function factoryCircle(x, y, radius) {
    const base = factoryShape(x, y);
    return {
        ...base,
        radius,
        area: () => Math.PI * radius ** 2,
        type: () => "FactoryCircle",
    };
}

/* ================================================================
 * Mixin — add capabilities to any class
 * ================================================================ */

const Printable = (superclass) => class extends superclass {
    print() {
        console.log(`  [Printable] ${this}`);
    }
};

const Serializable = (superclass) => class extends superclass {
    toJSON() {
        return { type: this.type(), x: this.x, y: this.y };
    }
};

class EnhancedCircle extends Serializable(Printable(Circle)) {
    /* inherits from Circle, gains print() and toJSON() */
}

/* ================================================================
 * Demo
 * ================================================================ */

function main() {
    console.log("=== ES6 Classes ===");
    const group = new ShapeGroup("Geometry Demo");
    group.add(new Circle(0, 0, 5.0));
    group.add(new Rectangle(1, 1, 4.0, 6.0));
    group.add(new Triangle(0, 0, 4, 0, 2, 3));
    group.print();

    console.log("\n=== Polymorphism ===");
    const shapes = [
        new Circle(0, 0, 3.0),
        new Rectangle(0, 0, 2.0, 7.0),
        new Triangle(0, 0, 6, 0, 3, 4),
    ];
    for (const s of shapes) {
        console.log(`  ${s.type()} -> ${s.area().toFixed(2)}`);
    }

    console.log("\n=== Prototypal Inheritance ===");
    const protoCircle = createProtoCircle(0, 0, 5.0);
    console.log(`  ${protoCircle}  area=${protoCircle.area().toFixed(2)}`);

    console.log("\n=== Factory Functions ===");
    const factoryC = factoryCircle(0, 0, 5.0);
    console.log(`  ${factoryC}  area=${factoryC.area().toFixed(2)}`);
    factoryC.moveTo(2, 3);
    console.log(`  After move: ${factoryC}`);

    console.log("\n=== Mixins ===");
    const enhanced = new EnhancedCircle(1, 2, 4.0);
    enhanced.print();
    console.log(`  JSON: ${JSON.stringify(enhanced.toJSON())}`);
}

main();
