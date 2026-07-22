// This file demonstrates TypeScript's object-oriented programming features
// including classes, interfaces, abstract classes, generics, and decorators.

// Interface for shapes
interface Shape {
    readonly color: string;
    area(): number;
    perimeter(): number;
    description(): string;
}

// Interface for scalable shapes
interface Scalable {
    scale(factor: number): void;
}

// Interface for drawable shapes
interface Drawable {
    draw(): string;
}

// Abstract base class for shapes
abstract class BaseShape implements Shape, Scalable, Drawable {
    constructor(
        public readonly color: string,
        public readonly name: string
    ) {}
    
    // Abstract methods (must be implemented by subclasses)
    abstract area(): number;
    abstract perimeter(): number;
    
    // Concrete methods
    description(): string {
        return `${this.name} (${this.color})`;
    }
    
    draw(): string {
        return `Drawing ${this.description()} with area ${this.area().toFixed(2)}`;
    }
    
    // Scale method (to be implemented by subclasses)
    abstract scale(factor: number): void;
    
    // Compare area with another shape
    hasLargerArea(other: Shape): boolean {
        return this.area() > other.area();
    }
    
    // Get ratio of areas
    areaRatio(other: Shape): number {
        return this.area() / other.area();
    }
}

// Circle class
class Circle extends BaseShape {
    private _radius: number;
    
    constructor(color: string, radius: number) {
        super(color, 'Circle');
        this._radius = radius;
    }
    
    // Getter
    get radius(): number {
        return this._radius;
    }
    
    // Setter with validation
    set radius(value: number) {
        if (value <= 0) {
            throw new Error('Radius must be positive');
        }
        this._radius = value;
    }
    
    // Implement abstract methods
    area(): number {
        return Math.PI * this._radius ** 2;
    }
    
    perimeter(): number {
        return 2 * Math.PI * this._radius;
    }
    
    // Implement scale
    scale(factor: number): void {
        this._radius *= factor;
    }
    
    // Additional method
    diameter(): number {
        return 2 * this._radius;
    }
}

// Rectangle class
class Rectangle extends BaseShape {
    constructor(
        color: string,
        private _width: number,
        private _height: number
    ) {
        super(color, 'Rectangle');
    }
    
    // Getters
    get width(): number {
        return this._width;
    }
    
    get height(): number {
        return this._height;
    }
    
    // Implement abstract methods
    area(): number {
        return this._width * this._height;
    }
    
    perimeter(): number {
        return 2 * (this._width + this._height);
    }
    
    // Implement scale
    scale(factor: number): void {
        this._width *= factor;
        this._height *= factor;
    }
    
    // Additional methods
    isSquare(): boolean {
        return this._width === this._height;
    }
    
    diagonal(): number {
        return Math.sqrt(this._width ** 2 + this._height ** 2);
    }
}

// Square class (special case of Rectangle)
class Square extends Rectangle {
    constructor(color: string, side: number) {
        super(color, side, side);
    }
    
    // Additional method
    side(): number {
        return this.width;
    }
    
    override description(): string {
        return `Square (${this.color})`;
    }
}

// Triangle class (three sides)
class Triangle extends BaseShape {
    constructor(
        color: string,
        private _a: number,
        private _b: number,
        private _c: number
    ) {
        super(color, 'Triangle');
        this.validate();
    }
    
    // Validate triangle inequality
    private validate(): void {
        if (this._a + this._b <= this._c ||
            this._a + this._c <= this._b ||
            this._b + this._c <= this._a) {
            throw new Error('Invalid triangle: violates triangle inequality');
        }
    }
    
    // Getters
    get a(): number {
        return this._a;
    }
    
    get b(): number {
        return this._b;
    }
    
    get c(): number {
        return this._c;
    }
    
    // Implement abstract methods
    area(): number {
        // Heron's formula
        const s = (this._a + this._b + this._c) / 2;
        return Math.sqrt(s * (s - this._a) * (s - this._b) * (s - this._c));
    }
    
    perimeter(): number {
        return this._a + this._b + this._c;
    }
    
    // Implement scale
    scale(factor: number): void {
        this._a *= factor;
        this._b *= factor;
        this._c *= factor;
        this.validate(); // Re-validate after scaling
    }
    
    // Additional methods
    isEquilateral(): boolean {
        return this._a === this._b && this._b === this._c;
    }
    
    isIsosceles(): boolean {
        return this._a === this._b || this._a === this._c || this._b === this._c;
    }
    
    isRight(): boolean {
        const sides = [this._a, this._b, this._c].sort((a, b) => a - b);
        return Math.abs(sides[2] ** 2 - (sides[0] ** 2 + sides[1] ** 2)) < 1e-10;
    }
}

// Generic shape collection
class ShapeCollection<T extends Shape> {
    private shapes: T[] = [];
    
    add(shape: T): void {
        this.shapes.push(shape);
    }
    
    remove(index: number): T | undefined {
        return this.shapes.splice(index, 1)[0];
    }
    
    get(index: number): T | undefined {
        return this.shapes[index];
    }
    
    get length(): number {
        return this.shapes.length;
    }
    
    // Find shape with largest area
    largest(): T | undefined {
        if (this.shapes.length === 0) return undefined;
        
        return this.shapes.reduce((largest, shape) =>
            shape.area() > largest.area() ? shape : largest
        );
    }
    
    // Find shape with smallest area
    smallest(): T | undefined {
        if (this.shapes.length === 0) return undefined;
        
        return this.shapes.reduce((smallest, shape) =>
            shape.area() < smallest.area() ? shape : smallest
        );
    }
    
    // Sort by area
    sortByArea(): T[] {
        return [...this.shapes].sort((a, b) => a.area() - b.area());
    }
    
    // Filter by color
    filterByColor(color: string): T[] {
        return this.shapes.filter(shape => shape.color === color);
    }
    
    // Calculate total area
    totalArea(): number {
        return this.shapes.reduce((sum, shape) => sum + shape.area(), 0);
    }
    
    // Print all shapes
    printAll(): void {
        console.log('Shape Collection:');
        console.log('================');
        this.shapes.forEach((shape, index) => {
            console.log(`${index + 1}. ${shape.description()}`);
            console.log(`   Area: ${shape.area().toFixed(2)}, Perimeter: ${shape.perimeter().toFixed(2)}`);
        });
        console.log();
        console.log(`Total Area: ${this.totalArea().toFixed(2)}`);
        const largest = this.largest();
        if (largest) {
            console.log(`Largest Shape: ${largest.description()} (Area: ${largest.area().toFixed(2)})`);
        }
    }
}

// Decorator for logging
function LogMethod(
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

// Decorator for validation
function PositiveNumber(
    target: any,
    propertyKey: string,
    parameterIndex: number
) {
    const originalConstructor = target;
    
    const newConstructor = function (...args: any[]) {
        const value = args[parameterIndex];
        if (typeof value === 'number' && value <= 0) {
            throw new Error(`${propertyKey} parameter must be positive`);
        }
        return new originalConstructor(...args);
    };
    
    newConstructor.prototype = originalConstructor.prototype;
    return newConstructor;
}

// Utility class for shape operations
class ShapeUtils {
    // Calculate area of circle
    @LogMethod
    static circleArea(radius: number): number {
        return Math.PI * radius ** 2;
    }
    
    // Calculate area of rectangle
    @LogMethod
    static rectangleArea(width: number, height: number): number {
        return width * height;
    }
    
    // Calculate area of triangle
    @LogMethod
    static triangleArea(a: number, b: number, c: number): number {
        const s = (a + b + c) / 2;
        return Math.sqrt(s * (s - a) * (s - b) * (s - c));
    }
    
    // Compare two shapes
    static compareShapes(a: Shape, b: Shape): number {
        return a.area() - b.area();
    }
    
    // Check if two shapes are similar
    static areSimilar(a: Shape, b: Shape): boolean {
        const ratio = a.area() / b.area();
        const perimeterRatio = a.perimeter() / b.perimeter();
        return Math.abs(Math.sqrt(ratio) - perimeterRatio) < 1e-10;
    }
}

// Main function to demonstrate all features
function main(): void {
    console.log('=== TypeScript Object-Oriented Programming ===');
    console.log('Demonstrating classes, interfaces, generics, and decorators');
    console.log();
    
    // Create shapes
    const circle = new Circle('red', 5);
    const rectangle = new Rectangle('blue', 4, 6);
    const square = new Square('green', 4);
    const triangle = new Triangle('yellow', 3, 4, 5);
    
    // Demonstrate basic shape properties
    console.log('Individual Shapes:');
    console.log(`${circle.description()}: Area = ${circle.area().toFixed(2)}, Perimeter = ${circle.perimeter().toFixed(2)}`);
    console.log(`${rectangle.description()}: Area = ${rectangle.area().toFixed(2)}, Perimeter = ${rectangle.perimeter().toFixed(2)}`);
    console.log(`${square.description()}: Area = ${square.area().toFixed(2)}, Perimeter = ${square.perimeter().toFixed(2)}`);
    console.log(`${triangle.description()}: Area = ${triangle.area().toFixed(2)}, Perimeter = ${triangle.perimeter().toFixed(2)}`);
    console.log();
    
    // Demonstrate draw method (interface implementation)
    console.log('Drawing Shapes:');
    console.log(circle.draw());
    console.log(rectangle.draw());
    console.log(square.draw());
    console.log(triangle.draw());
    console.log();
    
    // Demonstrate scaling
    console.log('Scaling Shapes:');
    console.log(`Before scaling - Circle radius: ${circle.radius}`);
    circle.scale(2);
    console.log(`After scaling by 2 - Circle radius: ${circle.radius}`);
    console.log(`New area: ${circle.area().toFixed(2)}`);
    console.log();
    
    // Demonstrate collection
    console.log('Shape Collection Demo:');
    const collection = new ShapeCollection<Shape>();
    collection.add(circle);
    collection.add(rectangle);
    collection.add(square);
    collection.add(triangle);
    collection.printAll();
    console.log();
    
    // Demonstrate generic sorting
    console.log('Sorting by Area:');
    const sorted = collection.sortByArea();
    sorted.forEach((shape, index) => {
        console.log(`${index + 1}. ${shape.description()} - Area: ${shape.area().toFixed(2)}`);
    });
    console.log();
    
    // Demonstrate utility methods
    console.log('Utility Methods:');
    console.log(`Circle is larger than rectangle: ${circle.hasLargerArea(rectangle)}`);
    console.log(`Area ratio (circle/rectangle): ${circle.areaRatio(rectangle).toFixed(2)}`);
    console.log(`Triangle is right-angled: ${triangle.isRight()}`);
    console.log(`Square is square: ${square.isSquare()}`);
    console.log();
    
    // Demonstrate static utilities
    console.log('Static Utility Methods:');
    console.log(`Circle area (static): ${ShapeUtils.circleArea(5).toFixed(2)}`);
    console.log(`Rectangle area (static): ${ShapeUtils.rectangleArea(4, 6).toFixed(2)}`);
    console.log(`Triangle area (static): ${ShapeUtils.triangleArea(3, 4, 5).toFixed(2)}`);
    console.log();
    
    // Demonstrate interface checking
    console.log('Interface Checking:');
    const shapes: Shape[] = [circle, rectangle, square, triangle];
    const scalableShapes: Scalable[] = [circle, rectangle, square, triangle];
    const drawableShapes: Drawable[] = [circle, rectangle, square, triangle];
    
    console.log(`Number of shapes: ${shapes.length}`);
    console.log(`Number of scalable shapes: ${scalableShapes.length}`);
    console.log(`Number of drawable shapes: ${drawableShapes.length}`);
}

// Run the demonstration
main();